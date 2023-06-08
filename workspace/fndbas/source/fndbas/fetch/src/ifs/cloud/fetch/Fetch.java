package ifs.cloud.fetch;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import ifs.cloud.fetch.jfrog.HttpAuthException;
import ifs.cloud.fetch.jfrog.HttpException;
import ifs.cloud.fetch.manifest.ArtifactManifest;
import ifs.cloud.fetch.manifest.ArtifactManifest.Artifact;
import ifs.cloud.fetch.manifest.ManifestException;

public class Fetch extends Logger {

   public static void main(String[] args) {
      new Fetch().run(args);
   }

   private Fetch() {
      super.log(ALLWAYS, "IFS Cloud - Fetch Artifacts");
   }

   private void run(String[] args) {
      try {
         System.exit(fetch(new FetchConfig(args)));
      }
      catch (Exception ex) {
         super.log(Level.SEVERE, this.getClass().getName(), "failed.");
         super.log(Level.SEVERE, ex.getMessage());
         super.log(Level.FINE, ex);
         System.exit(1);
      }
   }

   private int fetch(FetchConfig fetchConfig) throws IOException, FetchException {
      setLogLevel(fetchConfig.getLogLevel());
      if (fetchConfig.getShowHelp()) {
         showHelp(fetchConfig);
         return 0;
      }
      if (fetchConfig.getDumpArgs()) {
         super.log(Level.CONFIG, fetchConfig.toString());
      }
      super.log(Level.FINE, "Listing manifests in build home", fetchConfig.getBuildHome());
      // list xml files in build/artifact folder
      File[] manifests = fetchConfig.listManifests();
      if (manifests != null && manifests.length > 0) {

         log(Level.FINE, manifests.length, "manifests found.");
         log(Level.FINE, "Creating client...");
         try (IClient client = fetchConfig.createClient()) {
            log(Level.FINE, "client:", client);
            int failed = 0;
            DownloadStatus[] status = new DownloadStatus[manifests.length];
            for (int i = 0; i < manifests.length; i++) {
               status[i] = processManifest(fetchConfig, manifests[i], client);
               failed += status[i].countFailed();
            }
            printStatus(status);
            return failed;
         }
      }
      else {
         log(Level.WARNING, "No manifests found in", fetchConfig.getArtifactManifestPath());
         return 0;
      }
   }

   private void showHelp(FetchConfig fetchConfig) {
      super.log(ALLWAYS, this.getClass().getName(), "<command-line>");
      super.log(ALLWAYS, "Implementation", this.getClass().getProtectionDomain().getCodeSource().getLocation());
      super.log(ALLWAYS, "Java Home", System.getProperty("java.home"));
      super.log(ALLWAYS, "Java VM", System.getProperty("java.vm.name"), System.getProperty("java.runtime.version"));
      super.log(ALLWAYS, fetchConfig.getHelpText());
   }

   private void printStatus(DownloadStatus[] status) {
      log(ALLWAYS, "---------------");
      log(ALLWAYS, "Fetch completed");
      for (DownloadStatus ds : status) {
         log(ALLWAYS, ds.description);
         if (ds.status.size() == 0)
            log(ALLWAYS, "  Empty manifest");
         else
            for (ArtifactStatus temp : ds.status) {
               log(ALLWAYS, " ", temp.artifact.getArtifactTargetName(), "(", temp.artifact.getVersion(), ") :", temp.status);
            }
      }
   }

   private DownloadStatus processManifest(FetchConfig fetchConfig, File manifestFile, IClient client) throws FetchException, ManifestException, IOException {
      DownloadStatus status = new DownloadStatus();
      status.description = manifestFile.getName();

      // load manifest xml
      log(Level.FINE, "Loading manifest", status.description, "...");
      ArtifactManifest manifest = new ArtifactManifest(manifestFile);
      ArrayList<Artifact> artifacts = manifest.getArtifacts();
      if (artifacts.size() == 0)
         log(Level.WARNING, "Manifest", status.description, "is invalid or no artifacts defined");

      for (Artifact artifact : artifacts) {
         status.add(artifact, downloadArtifact(fetchConfig, artifact, client));
      }
      return status;
   }

   private Status downloadArtifact(FetchConfig fetchConfig, Artifact artifact, IClient client) throws FetchException {
      super.log(Level.FINE, artifact.getDescription());
      try {
         // check if artifact exists
         String filename = artifact.getPathInArtifactory();
         super.log(Level.FINE, "Get", artifact.getArtifactTargetName(), "manifest info...");
         final FileInfo fi = client.getFileInfo(filename);
         super.log(Level.FINE, fi);
         if (fetchConfig.getForceDownload() || client.isFileChanged(fi)) {

            super.log(Level.FINE, "Downloading", artifact.getArtifactTargetName(), "version", artifact.getVersion(), "(", formatSize(fi.getSize()), ")...");
            File tempArchive = artifact.getExplode() ? fetchConfig.generateTempFile(artifact.getArtifactName(), ".artifact") : getTargetComponentPath(fetchConfig, artifact);
            try (ArtifactWriter writer = new ArtifactWriter(tempArchive)) {
               if (!fetchConfig.getHideProgress()) {
                  writer.setProgressIndicator(new Progress(this, fi.getSize(), artifact.getArtifactTargetName()));
               }
               client.downloadFile(fi, writer);
            }
            super.log(Level.FINE, "Completed downloading", artifact.getArtifactTargetName());

            if (artifact.getExplode()) {
               File targetComponentPath = FetchConfig.makeFilePath(fetchConfig.getBuildHome(), artifact.getExtractpath());
               super.log(Level.FINE, "Unpacking", artifact.getArtifactTargetName(), "to", targetComponentPath);
               unpack(tempArchive, targetComponentPath);
            }
         }
         else {
            super.log(Level.WARNING, "No changes, not downloading", artifact.getArtifactTargetName());
            return Status.NO_CHANGE;
         }
      }
      catch (HttpAuthException ex) {
         super.log(Level.SEVERE, "Authentication error");
         throw ex;
      }
      catch (HttpException ex) {
         super.log(Level.WARNING, "Failed downloading", artifact.getPathInArtifactory());
         if (ex.getCode() != -1) {
            super.log(Level.WARNING, "HTTP response code:", ex.toString());
         }
         super.log(Level.FINE, ex);
         return Status.ERROR;
      }
      catch (FetchException | IOException ex) {
         super.log(Level.FINE, ex);
         return Status.ERROR;
      }
      return Status.OK;
   }

   private File getTargetComponentPath(FetchConfig fetchConfig, Artifact artifact) {
      // final target of downloaded archive
      File targetComponentPath = FetchConfig.makeFilePath(fetchConfig.getBuildHome(), artifact.getExtractpath(), artifact.getArtifactTargetName());
      targetComponentPath.getParentFile().mkdirs();
      return targetComponentPath;
   }

   private String formatSize(long size) {
      if (size <= 0)
         return "0";
      final String[] units = new String[] { "B", "KB", "MB", "GB", "TB" };
      int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
      return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + " " + units[digitGroups];
   }

   private void unpack(File archive, File destination) throws IOException {
      if (!destination.exists()) {
         destination.mkdir();
      }
      try (ZipInputStream zipIn = new ZipInputStream(new FileInputStream(archive))) {
         ZipEntry entry = zipIn.getNextEntry();
         // iterates over entries in the zip file
         while (entry != null) {
            File target = new File(destination, entry.getName());
            if (entry.isDirectory()) {
               // if the entry is a directory, make the directory
               target.mkdirs();
            }
            else {
               // if the entry is a file, extracts it
               extractFile(zipIn, target);
            }
            zipIn.closeEntry();
            entry = zipIn.getNextEntry();
         }
      }
   }

   private static final int BUFFER_SIZE = 4096;

   private void extractFile(ZipInputStream zipIn, File target) throws IOException {
      super.log(Level.FINE, "Writing ", target);
      try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(target))) {
         byte[] bytesIn = new byte[BUFFER_SIZE];
         int read = 0;
         while ((read = zipIn.read(bytesIn)) != -1) {
            bos.write(bytesIn, 0, read);
         }
      }
   }

   class Progress implements IProgress {
      private final Logger logger;
      private final long total;
      private final String fileName;

      private long prev = -1;

      Progress(Logger logger, long total, String fileName) {
         this.logger = logger;
         this.total = total;
         this.fileName = fileName;
      }

      @Override
      public void show(long progress) {
         int prog = (int) Math.round((double) 100 * (double) progress / (double) total);
         int pos = prog / 5;
         if (pos > prev) {

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < pos; i++) {
               sb.append('=');
            }
            for (int i = pos; i < 20; i++) {
               sb.append(' ');
            }

            logger.log(Level.FINE, "[", sb.toString(), "]", "downloading", fileName, formatSize(progress), "/", formatSize(total));
            prev = pos;
         }
      }
   }

   class DownloadStatus {
      public ArrayList<ArtifactStatus> status = new ArrayList<>();
      public String description;

      public void add(Artifact artifact, Status status) {
         this.status.add(new ArtifactStatus(artifact, status));
      }
      
      int countFailed() {
         int failed = 0;
         for (int i = 0; i < status.size(); i++) {
            ArtifactStatus as = status.get(i);
            if (as.status == Status.ERROR)
               failed++;
         }
         return failed;
      }
   }

   class ArtifactStatus {
      final Artifact artifact;
      final Status status;

      public ArtifactStatus(Artifact artifact, Status status) {
         this.artifact = artifact;
         this.status = status;
      }
   }

   enum Status {
      OK, NO_CHANGE, ERROR
   }
}
