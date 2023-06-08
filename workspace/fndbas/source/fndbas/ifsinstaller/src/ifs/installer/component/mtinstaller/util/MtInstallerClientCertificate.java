package ifs.installer.component.mtinstaller.util;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import ifs.installer.logging.InstallerLogger;

// Helper class for certificates passed through yaml files as file paths
public class MtInstallerClientCertificate {

   private static final Logger logger = InstallerLogger.getLogger();

   public void checkCertificates(Map<String, String> envs, Map<String, Object> properties) throws IOException {
      Set<String> set = properties.keySet().stream().filter(s -> s.contains(".certificates."))
            .collect(Collectors.toSet());

      String helmArgs = envs.getOrDefault("helmArgs", "");
      for (String s : set) {
         String value = (String) properties.get(s);
         if(value == null) {
            continue;
         }
         if (new File(value).isFile()) {
            logger.fine("Found certificate file for " + s + ". Will override with --set-file instead.");
            helmArgs += " --set-file " + s + "=" + value.replaceAll("\\\\", "/") + " ";
         }
      }
      envs.put("helmArgs", helmArgs);
   }

}
