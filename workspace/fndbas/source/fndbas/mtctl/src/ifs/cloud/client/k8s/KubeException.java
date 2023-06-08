package ifs.cloud.client.k8s;

public class KubeException extends Exception {
   /**
    * 
    */
   private static final long serialVersionUID = 4400368579305070046L;

   public KubeException() {
   }

   public KubeException(String message) {
      super(message);
   }

   public KubeException(Throwable cause) {
      super(cause);
   }

   public KubeException(String message, Throwable cause) {
      super(message, cause);
   }

   public KubeException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
      super(message, cause, enableSuppression, writableStackTrace);
   }
}
