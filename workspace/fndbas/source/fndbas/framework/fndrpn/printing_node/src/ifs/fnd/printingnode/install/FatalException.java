/*
 * FatalException.java
 *
 * Modified:
 *    madrse  2008-Mar-03 - Created
 */
package ifs.fnd.printingnode.install;

/**
 * An exception thrown to indicate that the main program should be aborted.
 */
public class FatalException extends Exception {

   public FatalException(String msg) {
      super(msg);
   }

   public FatalException(Throwable cause, String msg) {
      super(msg, cause);
   }
}
