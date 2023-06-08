package ifs.cloud.client.cli;

public class CliException extends Exception {
   /**
    * 
    */
   private static final long serialVersionUID = 5734568731564772936L;

   public CliException(String msg, Throwable inner) {
      super(msg, inner);
   }

   public CliException(String msg) {
      super(msg);
   }

   public CliException(Throwable cause) {
      super(cause);
   }
}
