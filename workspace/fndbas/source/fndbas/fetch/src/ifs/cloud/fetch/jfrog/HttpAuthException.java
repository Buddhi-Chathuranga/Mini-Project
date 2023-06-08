package ifs.cloud.fetch.jfrog;

import ifs.cloud.fetch.FetchException;

public class HttpAuthException extends FetchException {

   private static final long serialVersionUID = 1L;

   public HttpAuthException(String message) {
      super(message);
   }

   public HttpAuthException(Throwable cause) {
      super(cause);
   }
}
