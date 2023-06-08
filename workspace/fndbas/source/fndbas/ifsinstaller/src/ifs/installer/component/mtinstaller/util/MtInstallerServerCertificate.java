package ifs.installer.component.mtinstaller.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.util.Base64;
import java.util.Map;
import java.util.logging.Logger;

import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.CertificateInfo;
import ifs.installer.util.Helper;

public class MtInstallerServerCertificate {

   private static final Logger logger = InstallerLogger.getLogger();

   public void handleServerCertificate(Map<String, String> envs, Map<String, Object> properties, String tmpDir) {
      try {
         CertificateInfo certSettings = handleCertificate(properties);
         if (certSettings.isSet()) {
            File ingressCert = new File(tmpDir + File.separator + "ingressCert");
            File ingressCertKey = new File(tmpDir + File.separator + "ingressCertKey");
            File secretsCert = new File(tmpDir + File.separator + "secretsCert");
            File secretsKey = new File(tmpDir + File.separator + "secretsKey");

            ingressCert.deleteOnExit();
            ingressCertKey.deleteOnExit();
            secretsCert.deleteOnExit();
            secretsKey.deleteOnExit();

            Helper.overwriteFile(ingressCert.getCanonicalPath(), certSettings.getCertificate());
            Helper.overwriteFile(ingressCertKey.getCanonicalPath(), certSettings.getPrivateKey());
            Helper.overwriteFile(secretsCert.getCanonicalPath(),
                  new String(Base64.getEncoder().encode(certSettings.getCertificate().getBytes())));
            Helper.overwriteFile(secretsKey.getCanonicalPath(),
                  new String(Base64.getEncoder().encode(certSettings.getPrivateKey().getBytes())));

            String setArgs = (String) envs.getOrDefault("helmArgs", "");
            // prepend certificate stuff
            setArgs = "--set-file ifscore.tlsSecrets.ifsIngressCert.certificate="
                  + ingressCert.getCanonicalPath().replaceAll("\\\\", "/") + " "
                  + "--set-file ifscore.tlsSecrets.ifsIngressCert.key="
                  + ingressCertKey.getCanonicalPath().replaceAll("\\\\", "/") + " "
                  + "--set-file ifscore.secrets.tlsCert.data=" + secretsCert.getCanonicalPath().replaceAll("\\\\", "/")
                  + " " + "--set-file ifscore.secrets.tlsKey.data="
                  + secretsKey.getCanonicalPath().replaceAll("\\\\", "/") + " " + setArgs;
            envs.put("helmArgs", setArgs);
         }
      } catch (UnrecoverableKeyException | NoSuchAlgorithmException | CertificateException | KeyStoreException
            | InterruptedException | IOException e) {
         logger.severe("Unable to handle certificates. " + e);
      }
   }

   // TODO, maybe the cert should be marked as helm: keep and not needed every
   // time.
   private CertificateInfo handleCertificate(Map<String, Object> properties)
         throws UnrecoverableKeyException, NoSuchAlgorithmException, CertificateException, FileNotFoundException,
         KeyStoreException, IOException, InterruptedException {
      if (properties.containsKey("ifscore.tlsSecrets.ifsIngressCert.certificate")
            && properties.containsKey("ifscore.tlsSecrets.ifsIngressCert.key")) {
         logger.info("Found certificate information in values, will use these.");
         return new CertificateInfo();
      }

      if (properties.containsKey("certificateFile")) {
         if (properties.containsKey("certificatePassword")) {
            logger.info("Using existing certificate");
            String cert = (String) properties.get("certificateFile");
            File f = new File(cert);
            if (f.exists() && f.isFile()) {
               return Helper.parseCertificate(cert, ((String) properties.get("certificatePassword")).toCharArray());
            } else {
               logger.warning("Certificate defined in certificateFile not found. Will generate a self-signed.");
            }
         } else {
            logger.warning(
                  "Found property certificateFile but not certificatePassword. Unable to use selected certificate, will generate a self-signed certificate.");
         }
      }
      logger.warning("Generating self-signed certificate. This will not be persisted.");
      String pwd, location;
      boolean genPwd = true;
      pwd = "";
      location = "";
      if (properties.containsKey("selfSignedPassword")) {
         pwd = (String) properties.get("selfSignedPassword");
         genPwd = false;
      }
      if (properties.containsKey("selfSignedCertificateFile")) {
         location = (String) properties.get("selfSignedCertificateFile");
      }
      if (genPwd) {
         return Helper.createSelfSignedCertificateGeneratedPassword(location,
               (String) properties.getOrDefault("global.systemUrl", ""),
               (String) (String) properties.getOrDefault("global.secondarySystemUrl", ""));
      } else {
         return Helper.createSelfSignedCertificate(location, pwd.toCharArray(),
               (String) properties.getOrDefault("global.systemUrl", ""),
               (String) (String) properties.getOrDefault("global.secondarySystemUrl", ""));
      }
   }

}
