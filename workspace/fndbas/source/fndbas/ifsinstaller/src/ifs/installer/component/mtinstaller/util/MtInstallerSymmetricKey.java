package ifs.installer.component.mtinstaller.util;

import java.util.Map;
import java.util.logging.Logger;
import java.security.NoSuchAlgorithmException;
import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.SymmetricEncDecUtil;

public class MtInstallerSymmetricKey {

   private static final Logger logger = InstallerLogger.getLogger();

   public void handleSymmetricKey(Map<String, String> envs, Map<String, Object> properties) {
      try {
         String keyGenerationAlgorithm = SymmetricEncDecUtil.DEFAULT_SYMMETRIC_KEY_ALGORITHM;
         int keyLength = SymmetricEncDecUtil.DEFAULT_SYMMETRIC_KEY_LENGTH;
         String symmetricKey = SymmetricEncDecUtil.generateAndHexEncodeSymmetricKey(keyGenerationAlgorithm, keyLength);			
         String setArgs = (String) envs.getOrDefault("helmArgs", "");
         setArgs = "--set-string ifscore.generatedSecrets.symmetricKey.data="
                  + symmetricKey + " " + setArgs;
         envs.put("helmArgs", setArgs);
         logger.info("Generating symmetric-key. This will only be persisted if the secret, 'symmetric-key' does not exist.");
      } catch (NoSuchAlgorithmException e) {
         logger.severe("Unable to generate symmetric key. " + e);
      }
   }
}
