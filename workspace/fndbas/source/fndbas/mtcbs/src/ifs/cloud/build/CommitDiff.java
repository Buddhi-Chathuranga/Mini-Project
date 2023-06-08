package ifs.cloud.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;

import ifs.cloud.build.Component.WorkingThread;
import ifs.cloud.build.Log.LogException;

class CommitDiff {
   
   static class Copier extends Component.Worker {

      Copier(Context context) {
         super(context);
      }

      private String[] makePathParts(String path) throws IOException {
         // path -> accrul/model/accrul/AccrulUtility.utility
         // 0th element must be the component
         path = path.trim().replace("\\", "/");
         if (path.length() == 0)
            return new String[0];
         if (path.charAt(0) == '/')
            throw new IOException("Invalid path " + path);
         return path.split("/");
      }

      @Override
      WorkingThread[] createThreads() throws IOException {
         HashMap<File, ArrayList<String[]>> componentFiles = new HashMap<>();
         try (BufferedReader input = new BufferedReader(new FileReader(context.getFileList()))) {
            File component = null;
            String line;
            while ((line = input.readLine()) != null) {
               String[] pathParts = makePathParts(line);
               if (pathParts.length > 1) {
                  component = Util.createFilePath(context.getSourcePath(), pathParts[0]);
                  ArrayList<String[]> comp = componentFiles.get(component);
                  if (comp == null) {
                     comp = new ArrayList<>();
                     componentFiles.put(component, comp);
                  }
                  comp.add(pathParts);
               }
            }
         }
         ListCopyThread[] cthreads = new ListCopyThread[componentFiles.size()];
         Log.printf(Level.INFO, "%d component%s found.", cthreads.length, cthreads.length > 1 ? "s": "");
         int i = 0;
         for (HashMap.Entry<File, ArrayList<String[]>> entry : componentFiles.entrySet()) {
            cthreads[i] = new ListCopyThread(context, entry.getKey(), entry.getValue());
            cthreads[i].start();
            i++;
         }
         return cthreads;
      }
   }

   private static class ListCopyThread extends Component.WorkingThread {

      private final List<String[]> files;

      ListCopyThread(Context context, File component, List<String[]> files) {
         super(context, component);
         this.files = files;
      }

      private File createTargetPath(File parent, String... paths) {
         File f = parent;
         for (int i = 1; i < paths.length; i++) {
            f = new File(f, paths[i]);
         }
         return f;
      }

      @Override
      void copy() {
         for (String[] pathParts : files) {
            // pathParts contain more than 2 items, checked before adding
            if (!excluded(pathParts[1])) {
               File source = Util.createFilePath(context.getSourcePath(), pathParts);
               // target without the component
               File copyTo = createTargetPath(context.getTargetPath(), pathParts);
               if (Log.DEBUG) {
                  Log.debug("Copying file");
                  Log.debug("source: %s", source);
                  Log.debug("copyTo: %s", copyTo);
               }
               copyTo.getParentFile().mkdirs();
               try {
                  Files.copy(source.toPath(), copyTo.toPath(), options);
                  copied++;
               }
               catch (IOException ex) {
                  Log.printf(Level.WARNING, "Copy error (%s) %s %s", component.getName(), source.getName(), new LogException(ex, true));
                  failed++;
               }
            }
            //only copy deploy.ini if included in list.
            if ("deploy.ini".equals(pathParts[1])) {
               super.createDeployIni();
            }
         }
      }
      
      @Override
      void createDeployIni() {
         //Nothing to be done here;
         //super.createDeployIni() called in copy().
      }         
   }
}