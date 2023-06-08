package ifs.installer.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.UnrecoverableKeyException;
import java.security.cert.Certificate;
import java.security.cert.CertificateEncodingException;
import java.security.cert.CertificateException;
import java.util.Arrays;
import java.util.Base64;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

import ifs.installer.logging.InstallerLogger;
import ifs.installer.Installer;

public abstract class Helper {

   private static final Logger logger = InstallerLogger.getLogger();

   public static final boolean IS_WINDOWS = System.getProperty("os.name").toLowerCase().startsWith("windows");
   
   public static String readFile(final String file) throws IOException {
      logger.finer("Reading file: " + file);
      Path path = Paths.get(file);
      Charset charset = StandardCharsets.UTF_8;

      String content = new String(Files.readAllBytes(path), charset);
      logger.finer("File read");
      logger.finest("Content: " + content);
      return content;
   }

   public static boolean isPathValid(String path) {
      try {
         Paths.get(path);
      } catch (InvalidPathException ex) {
         return false;
      }
      return true;
   }

   public static boolean copyAllToDir(final File fromDir, final File toDir, final boolean overwrite, File... exclude)
         throws IOException {
      if (fromDir == null || toDir == null) {
         return false;
      }

      List<File> excludeList = Arrays.asList(exclude);
      File[] filesToCopy = fromDir.listFiles(new FileFilter() {

         @Override
         public boolean accept(File pathname) {
            return !excludeList.contains(pathname);
         }
      });

      if (filesToCopy == null) {
         return false;
      }

      boolean result = true;
      if (!toDir.exists()) {
         toDir.mkdirs();
      }
      for (File f : filesToCopy) {
         if (f.isDirectory()) {
            copyAllToDir(f, new File(toDir + "/" + f.getName()), overwrite, exclude);
         } else {
            result &= copyFileToDir(f, toDir, overwrite);
         }
      }
      return result;
   }

   public static boolean copyFileToDir(final File file, final File dir, final String newName, final boolean overwrite)
         throws IOException {
      if (file == null || dir == null) {
         return false;
      }
      if (!dir.isDirectory()) {
         return false;
      }

      File target = new File(dir.getCanonicalPath() + "/" + newName);
      dir.mkdirs();
      if (overwrite) {
         Files.copy(file.toPath(), target.toPath(), StandardCopyOption.REPLACE_EXISTING);
      } else {
         if (!Files.exists(target.toPath())) {
            Files.copy(file.toPath(), target.toPath());
         }
      }
      return true;
   }

   public static boolean copyFileToDir(final File file, final File dir, final boolean overwrite) throws IOException {
      if (file == null) {
         return false;
      }
      return copyFileToDir(file, dir, file.getName(), overwrite);
   }

   public static void createFile(final String file, final String content) throws IOException {
      if (new File(file).getParentFile() != null) {
         new File(file).getParentFile().mkdirs();
      }
      try (Writer writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "utf-8"))) {
         writer.write(content);
      }
   }

   public static void overwriteFile(final String file, final String content) throws IOException {
      File f = new File(file);
      if (f.exists()) {
         f.delete();
      }
      createFile(file, content);
   }

   public static ProcessResult runProcessWithResult(Map<String, String> envs, String dir, final boolean noLogs,
         final String... commands) throws IOException, InterruptedException {
      ProcessBuilder p = new ProcessBuilder(commands);
      p.directory(new File(dir));
      p.redirectErrorStream(true);
      p.environment().putAll(envs);
      Process process = p.start();

      BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
      StringBuilder builder = new StringBuilder();
      String line = null;
      while ((line = reader.readLine()) != null) {
         if (!noLogs)
            log(line);
         builder.append(line + "\n");
      }

      int timeout;
      try {
         timeout = Integer.valueOf(System.getProperty("commandTimeout", "36000"));
      } catch (NumberFormatException nfe) {
         logger.warning("Incorrect format of commandTImeout");
         timeout = 36000;
      }
      logger.fine("Timeout: " + timeout);
      process.waitFor(timeout, TimeUnit.SECONDS);
      return new ProcessResult(process, builder.toString());
   }

   private static void log(String line) {
      if (line.startsWith("\"")) {
         // trim quotes
         line = line.substring(1, line.length() - 1);
      }

      String lineUpper = line.toUpperCase();
      if (lineUpper.startsWith("SEVERE:")) {
         logger.severe(line.substring("SEVERE:".length()).trim());
      } else if (lineUpper.startsWith("ERROR:")) {
         logger.severe(line.substring("ERROR:".length()).trim());
      } else if (lineUpper.startsWith("WARNING: DB") && Installer.getBreakOnDBError()) {
         logger.severe(line.substring("WARNING:".length()).trim());          
      } else if (lineUpper.startsWith("WARNING:")) {
         logger.warning(line.substring("WARNING:".length()).trim());
      } else if (lineUpper.startsWith("INFO:")) {
         logger.info(line.substring("INFO:".length()).trim());
      } else if (lineUpper.startsWith("FINE:")) {
         logger.fine(line.substring("FINE:".length()).trim());
      } else if (lineUpper.startsWith("FINER:")) {
         logger.finer(line.substring("FINER:".length()).trim());
      } else if (lineUpper.startsWith("FINEST:")) {
         logger.finest(line.substring("FINEST:".length()).trim());
      } else { // default to level FINE
         logger.fine(line);
      }
   }

   public static ProcessResult runProcessWithResult(String dir, final String... commands)
         throws IOException, InterruptedException {
      return runProcessWithResult(new HashMap<String, String>(), dir, false, commands);
   }

   public static String getArgsAsPlainString(String[] args) {
      String result = "";
      for (String s : args) {
         result += s + " ";
      }
      return result;
   }

   public static String getHostName() {
      String hostName = "localhost";
      try {
         hostName = InetAddress.getLocalHost().getHostName();
      } catch (UnknownHostException e) {
         // return localhost
      }
      return hostName;
   }

   public static CertificateInfo parseCertificate(String path, char[] password) throws NoSuchAlgorithmException,
         CertificateException, FileNotFoundException, IOException, KeyStoreException, UnrecoverableKeyException {
      KeyStore keyStore = KeyStore.getInstance("PKCS12");

      try (FileInputStream input = new FileInputStream(path)) {
         keyStore.load(input, password);
      }

      Enumeration<String> aliases = keyStore.aliases();
      String alias = aliases.nextElement();
      if (aliases.hasMoreElements()) {
         logger.warning("More than one alias found in certificate, using the first found");
      }

      Certificate[] chain = keyStore.getCertificateChain(alias);
      String certChain = "";
      for (Certificate c : chain) {
         certChain += exportCertificate(c.getEncoded(), false);
      }

      String key;
      PrivateKey caPrivateKey = (PrivateKey) keyStore.getKey(alias, password);
      key = exportCertificate(caPrivateKey.getEncoded(), true);

      return new CertificateInfo(certChain, key);
   }

   private static String exportCertificate(byte[] data, boolean isPrivateKey) throws CertificateEncodingException {
      StringWriter sw = new StringWriter();
      String type = isPrivateKey ? "RSA PRIVATE KEY" : "CERTIFICATE";
      sw.write("-----BEGIN ".concat(type).concat("-----\n"));
      sw.write(new String(Base64.getEncoder().encode(data)).replaceAll("(.{64})", "$1\n"));
      if (!sw.toString().endsWith("\n")) {
         sw.write("\n");
      }
      sw.write("-----END ".concat(type).concat("-----\n"));
      return sw.toString();
   }

   public static CertificateInfo createSelfSignedCertificate(String certFile, char[] pwd, String... dns)
         throws IOException, InterruptedException, NoSuchAlgorithmException, CertificateException, KeyStoreException,
         UnrecoverableKeyException {
      String dnses = "";
      for (String next : dns) {
         if (next == null || "".equals(next)) {
            continue;
         }
         dnses = dnses.concat("dns:".concat(next).concat(","));
      }

      if ("".equals(dnses)) {
         logger.warning("No dns specified, will default to current host name");
         dnses = dnses.concat("dns:".concat(getHostName()).concat(","));
      }

      // trim off last ','
      dnses = dnses.substring(0, dnses.length() - 1);

      File keyStore;
      boolean keepCert;
      if (!"".equals(certFile)) {
         new File(certFile).getParentFile().mkdirs(); // make sure folder exists
         keyStore = new File(certFile);
         keepCert = true;
      } else {
         keyStore = new File("ifscloudKS.pfx");
         keepCert = false;
      }
      if (keyStore.exists()) {
         logger.warning("Deleting keystore with conflicting name");
         keyStore.delete();
      }

      Helper.runProcessWithResult(System.getProperty("java.home").concat(File.separator).concat("bin"),
            "keytool" + (IS_WINDOWS ? ".exe" : ""), "-genkeypair", "-noprompt", "-storepass", new String(pwd), "-dname",
            "CN=".concat(dns[0]), "-keystore", keyStore.getCanonicalPath(), "-storetype", "PKCS12", "-alias",
            "ifscloud", "-keyalg", "RSA", "-keysize", "2048", "-validity", "365", "-ext", "san=".concat(dnses));

      CertificateInfo result = parseCertificate(keyStore.getCanonicalPath(), pwd);
      if (!keepCert) {
         keyStore.delete();
      }
      return result;
   }

   public static CertificateInfo createSelfSignedCertificateGeneratedPassword(String certFile, String... dns)
         throws IOException, InterruptedException, NoSuchAlgorithmException, CertificateException, KeyStoreException,
         UnrecoverableKeyException {

      // generate a simple password
      String chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
      String pwd = "";
      Random random = new Random(System.nanoTime());
      int length = random.nextInt(16) + 8;
      int nextChar;
      for (int i = 0; i < length; i++) {
         nextChar = random.nextInt(chars.length());
         pwd += chars.charAt(nextChar);
      }

      return createSelfSignedCertificate(certFile, pwd.toCharArray(), dns);
   }

   public static boolean deleteDir(final File dir) {
      boolean result;

      if (dir == null) {
         return false;
      }

      result = true;
      File[] files = dir.listFiles();
      if (files == null) {
         return result;
      }
      for (File f : files) {
         if (f.isDirectory()) {
            result = result & deleteDir(f);
         } else {
            result = result & f.delete();
         }
      }
      result = result & dir.delete();
      return result;
   }

   private static int levenshteinDistance(char[] s, int sLen, char[] t, int tLen) {
      int cost;

      if (sLen == 0) {
         return tLen;
      }
      if (tLen == 0) {
         return sLen;
      }

      cost = s[sLen - 1] == t[tLen - 1] ? 0 : 1;

      return Math.min(levenshteinDistance(s, sLen - 1, t, tLen) + 1, Math
            .min(levenshteinDistance(s, sLen, t, tLen - 1) + 1, levenshteinDistance(s, sLen - 1, t, tLen - 1) + cost));
   }

   public static String checkCommand(List<String> possibleCommands, String typedCommand) {
      String closestMatch = typedCommand;
      int leastCost;

      leastCost = typedCommand.length();
      for (String s : possibleCommands) {
         System.out.println(s);
         int cost = levenshteinDistance(s.toCharArray(), s.length(), typedCommand.toCharArray(), typedCommand.length());
         if (cost < leastCost) {
            closestMatch = s;
            leastCost = cost;
         }
      }
      return closestMatch;
   }

   public static String getDefaultDeliveryDir() {
      String execDir = "";
      try {
         execDir = new File("").getCanonicalFile().getParent();
      } catch (IOException ioe) {
         logger.warning("Unable to get executable dir!");
      }
      return execDir;
   }

   public static boolean getOrDefaultBoolean(Map<String, Object> map, String key, boolean defaultValue) {
      Object value = map.getOrDefault(key, defaultValue);
      if (value instanceof String) {
         return Boolean.parseBoolean((String) value);
      }
      return (boolean) value;
   }

   public static String parseTns(String parmToReturn, String connectString) {
      int startOfParm = connectString.indexOf(parmToReturn);
      if (startOfParm > 0) {
         String parmString = connectString.substring(startOfParm);
         int equalIndex = parmString.indexOf('=');
         int bracketIndex = parmString.indexOf(')');
         if (equalIndex > 0 && bracketIndex > 0) {
            return parmString.substring(equalIndex + 1, bracketIndex);
         }
      }
      return null;
   }
}