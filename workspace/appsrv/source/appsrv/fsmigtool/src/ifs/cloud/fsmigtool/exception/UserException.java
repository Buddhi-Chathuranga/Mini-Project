/*
 *                 IFS Research & Development
 *
 *  This program is protected by copyright law and by international
 *  conventions. All licensing, renting, lending or copying (including
 *  for private use), and all other use of the program, which is not
 *  expressively permitted by IFS Research & Development (IFS), is a
 *  violation of the rights of IFS. Such violations will be reported to the
 *  appropriate authorities.
 *
 *  VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 *  TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 */
package ifs.cloud.fsmigtool.exception;

/**
 * @author IFS RnD
 */
public class UserException extends RuntimeException {

   public static final String MIGTOOL_CLIENT_ERR = "FS_MIGTOOL_USER_ERROR";

   private final String errorCode;

   public UserException(final String errorMessage, final String errorCode) {
      super(errorMessage);
      this.errorCode = errorCode;
   }

   public UserException(final String errorMessage, final Throwable throwable, final String errorCode) {
      super(errorMessage, throwable);
      this.errorCode = errorCode;
   }

   public UserException(final String errorMessage, final Throwable throwable) {
      super(errorMessage, throwable);
      this.errorCode = MIGTOOL_CLIENT_ERR;
   }

   public UserException(final String errorMessage) {
      super(errorMessage);
      this.errorCode = MIGTOOL_CLIENT_ERR;
   }

   public String getErrorCode() {
      return errorCode;
   }

}
