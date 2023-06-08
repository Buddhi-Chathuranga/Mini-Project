package ifs.installer.util;

public class CertificateInfo {

   private String certificate;
   private String privateKey;

   public CertificateInfo() {
      certificate = "";
      privateKey = "";
   }

   public CertificateInfo(String certificate, String privateKey) {
      this.certificate = certificate;
      this.privateKey = privateKey;
   }

   public String getCertificate() {
      return this.certificate;
   }

   public String getPrivateKey() {
      return this.privateKey;
   }

   public boolean isSet() {
      return !certificate.isEmpty() && !privateKey.isEmpty();
   }
}
