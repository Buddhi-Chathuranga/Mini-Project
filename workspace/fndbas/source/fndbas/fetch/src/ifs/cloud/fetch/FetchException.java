package ifs.cloud.fetch;

public class FetchException extends Exception {

   private static final long serialVersionUID = 8603288048987923624L;

   public FetchException() {}

   public FetchException(String message) {
      super(message);
   }

   public FetchException(Throwable cause) {
      super(cause);
   }

   public FetchException(String message, Throwable cause) {
      super(message, cause);
   }

   public FetchException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
      super(message, cause, enableSuppression, writableStackTrace);
   }
}