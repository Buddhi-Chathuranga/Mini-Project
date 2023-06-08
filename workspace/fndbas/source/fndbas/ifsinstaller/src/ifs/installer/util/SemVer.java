package ifs.installer.util;

import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import ifs.installer.logging.InstallerLogger;

// !! NOTE !!
// Not an actual implementation of SemVer!
public class SemVer {

   private int major;
   private int minor;
   private int patch;
   private String version;

   private static final Logger logger = InstallerLogger.getLogger();

   public SemVer(String version) {
      this.version = version.trim();
      parseVersion(this.version);
   }

   private void parseVersion(String version) {
      if (version.startsWith("~")) {
         logger.info("Found contraint ~ used in version " + version);
         version = version.substring(1);
      }
      Pattern pattern = Pattern.compile(
            "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$");
      Matcher matcher = pattern.matcher(version);
      if (matcher.matches()) {
         try {
            major = Integer.valueOf(matcher.group(1));
            minor = Integer.valueOf(matcher.group(2));
            patch = Integer.valueOf(matcher.group(3));
         } catch (NumberFormatException nfe) {
            throw new IllegalArgumentException("Unable to parse version values, expected digits (semVer)");
         }
      } else {
         throw new IllegalArgumentException(
               "Unable to parse version, expected format is MAJOR.MINOR.PATCH (" + version + ")");
      }
   }

   public boolean satisifesSp(SemVer anotherVersion) {
      return major == anotherVersion.major && minor == anotherVersion.minor && patch >= anotherVersion.patch;
   }

   public String getVersion() {
      return this.version;
   }
}
