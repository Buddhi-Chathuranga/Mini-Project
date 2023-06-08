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
package ifs.cloud.fsmigtool;

import ifs.cloud.fsmigtool.exception.UserException;

/**
 * @author IFS RnD
 */
public class CommandLineHandler {
   
   private static final String ALL_MEDIA_ARG = "--allmedia";
   private static final String ALL_DOCS_ARG = "--alldocs";

   private static final String DOC_CLASSES_ARG = "--docclasses";
   private static final String MEDIA_TYPE_ARG = "--mediatype";

   private static final String DOCS_FROM_FILE_ARG = "--docsfromfile";
   private static final String MEDIA_FROM_FILE_ARG = "--mediafromfile";

   private static final String DB_CONN_ARG = "--dbconn";
   private static final String DB_PASS_ARG = "--dbpass";
   private static final String DB_USER_ARG = "--dbuser";

   private static final String CLOUD_URL_ARG = "--cloudurl";
   private static final String CLOUD_CLIENT_ID = "--cloudclientid";
   private static final String CLOUD_CLIENT_SECRET = "--cloudclientsecret";
   private static final String CLOUD_REALM = "--cloudrealm";

   private static final String LOG_FS_MIG_LOG_TAB_ARG = "--logmigtable";
   
   private static final String ALLOWED_MEDIA_TYPE = "IMAGE|VIDEO|AUDIO";
   
   private final String[] args;

   private boolean allDocs;
   private boolean allMedia;
   private boolean logMigTable;
   private String docsFromFile;
   private String mediaFromFile;
   private String docClasses;
   private String mediaType;
   private String dbConnString;
   private String dbUser;
   private String dbPass;
   private String cloudUrl;
   private String cloudClient;
   private String cloudSecret;
   private String cloudRealm;
   
   private String getArg(String[] args, String argName) {
      String returnValue = null;
      for (int i = 0; i < args.length; i++) {
         String arg = args[i];
         if (argName.equals(arg)) {
            if ((args.length) - 1 > i) {
               returnValue = args[i + 1];
            } else {
               throw new UserException("Missing value for argument " + argName + ".");
            }
         }
      }
      return returnValue;
   }

   private boolean argSet(String[] args, String argName) {
      for (String arg : args) {
         if (argName.equals(arg)) {
            return true;
         }
      }
      return false;
   }

   private boolean valueArgSet(String[] args, String argName) {
      for (int i = 0; i < args.length; i++) {
         if (argName.equals(args[i]) && args.length - 1 > i) {
            return true;
         }
      }
      return false;
   }

   private boolean allAuthOptionsSet(String[] args) {
     String[] authOptions = {DB_CONN_ARG, DB_USER_ARG, DB_PASS_ARG, CLOUD_URL_ARG, CLOUD_CLIENT_ID, CLOUD_CLIENT_SECRET, CLOUD_REALM};
      for (String authOption : authOptions) {
         if (!valueArgSet(args, authOption)) {
            return false;
         }
      }
      return true;
   }

   private boolean anyTransferOptionSet(String[] args) {
      String[] transferOptions = {ALL_DOCS_ARG, DOCS_FROM_FILE_ARG, DOC_CLASSES_ARG, ALL_MEDIA_ARG, MEDIA_FROM_FILE_ARG, MEDIA_TYPE_ARG};
      for (String transferOption : transferOptions) {
         if (argSet(args, transferOption)) {
            return true;
         }
      }
      return false;
   }

   private void handleParameters(String[] args) throws UserException {

      if (argSet(args, ALL_DOCS_ARG))           allDocs       = true;
      if (argSet(args, ALL_MEDIA_ARG))          allMedia      = true;
      if (argSet(args, LOG_FS_MIG_LOG_TAB_ARG)) logMigTable   = true;
      
      if (argSet(args, DOCS_FROM_FILE_ARG))     docsFromFile  = removeExtraSpaces(getArg(args, DOCS_FROM_FILE_ARG ), ",");
      if (argSet(args, MEDIA_FROM_FILE_ARG))    mediaFromFile = removeExtraSpaces(getArg(args, MEDIA_FROM_FILE_ARG), ",");

      if (argSet(args, DOC_CLASSES_ARG))        docClasses    = removeExtraSpaces(getArg(args, DOC_CLASSES_ARG    ), ",");
      if (argSet(args, MEDIA_TYPE_ARG))         mediaType     = removeExtraSpaces(getArg(args, MEDIA_TYPE_ARG     ), "|");

      if (argSet(args, DB_CONN_ARG))            dbConnString  = getArg(args, DB_CONN_ARG        );
      if (argSet(args, DB_PASS_ARG))            dbPass        = getArg(args, DB_PASS_ARG        );
      if (argSet(args, DB_USER_ARG))            dbUser        = getArg(args, DB_USER_ARG        );
      
      if (argSet(args, DB_CONN_ARG))            cloudUrl      = getArg(args, CLOUD_URL_ARG      );
      if (argSet(args, DB_PASS_ARG))            cloudClient   = getArg(args, CLOUD_CLIENT_ID    );
      if (argSet(args, DB_USER_ARG))            cloudSecret   = getArg(args, CLOUD_CLIENT_SECRET);
      if (argSet(args, DB_USER_ARG))            cloudRealm    = getArg(args, CLOUD_REALM        );
      
      if ((isAllDocs() && (getDocsFromFile() != null || getDocClasses() != null)) ||
          (getDocsFromFile() != null && (isAllDocs() || getDocClasses() != null)) ||
          (getDocClasses() != null && (isAllDocs() || getDocsFromFile() != null))) {
         throw new UserException("Only one of " + ALL_DOCS_ARG  + ", "  + DOCS_FROM_FILE_ARG  + " or "    + DOC_CLASSES_ARG  + " can be specified.");
      }

      if ((isAllMedia() && (getMediaFromFile() != null || getMediaType() != null)) ||
          (getMediaFromFile() != null && (isAllMedia() || getMediaType() != null)) ||
          (getMediaType() != null && (isAllMedia() || getMediaFromFile() != null))) {
         throw new UserException("Only one of " + ALL_MEDIA_ARG + ", " + MEDIA_FROM_FILE_ARG + " or " + MEDIA_TYPE_ARG + " can be specified.");
      }

      if (args.length == 0 || !allAuthOptionsSet(args)) {
         throw new UserException("Usage: fsmigtool OPTIONS:"   +
                                                               "\r\n " + ALL_DOCS_ARG         + " | " + DOCS_FROM_FILE_ARG  + " FILE | " + DOC_CLASSES_ARG + " CLASS1,CLASS2,... " +
                                                               "\r\n " + ALL_MEDIA_ARG        + " | " + MEDIA_FROM_FILE_ARG + " FILE | " + MEDIA_TYPE_ARG  + " IMAGE|VIDEO|AUDIO " +
                                                               "\r\n " + DB_CONN_ARG          + " CONNSTRING "                                                                     +
                                                               "\r\n " + DB_USER_ARG          + " USERNAME "                                                                       +
                                                               "\r\n " + DB_PASS_ARG          + " PASSWORD "                                                                       +
                                                               "\r\n " + CLOUD_URL_ARG        + " URL "                                                                            +
                                                               "\r\n " + CLOUD_CLIENT_ID      + " CLIENTID "                                                                       +
                                                               "\r\n " + CLOUD_CLIENT_SECRET  + " CLIENTSECRET"                                                                    +
                                                               "\r\n " + CLOUD_REALM          + " CLOUDREALM");      
      }

      if (!anyTransferOptionSet(args)) {
         throw new UserException("One of " + ALL_MEDIA_ARG + ", " + MEDIA_FROM_FILE_ARG + " or " + MEDIA_TYPE_ARG + " should be specified.");
      }

      if (argSet(args, MEDIA_TYPE_ARG) && !ALLOWED_MEDIA_TYPE.contains(getArg(args, MEDIA_TYPE_ARG))) {
         throw new UserException("Unsupported media type " + getArg(args, MEDIA_TYPE_ARG) + ".");         
      }     
   }

   public CommandLineHandler(String[] args) {
      this.args = args;
   }

   public void parseCommandLine() throws UserException {
      handleParameters(args);
   }

   public boolean shouldHandleMedia() {
      return (isAllMedia() || getMediaType() != null || getMediaFromFile() != null);
   }

   public boolean shouldHandleDocuments() {
      return (isAllDocs() || getDocClasses() != null || getDocsFromFile() != null);
   }

   private String removeExtraSpaces(String arg, String separator) {
      return arg.replaceAll("(\\s*,\\s*)(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", separator);
   }

   public boolean isAllDocs() {
      return allDocs;
   }

   public boolean isAllMedia() {
      return allMedia;
   }
   
   public boolean isLogMigTable() {
      return logMigTable;
   }

   public String getDocsFromFile() {
      return docsFromFile;
   }

   public String getMediaFromFile() {
      return mediaFromFile;
   }

   public String getDocClasses() {
      return docClasses;
   }

   public String getMediaType() {
      return mediaType;
   }

   public String getDbConnString() {
      return dbConnString;
   }

   public String getDbUser() {
      return dbUser;
   }

   public String getDbPass() {
      return dbPass;
   }

   public String getCloudUrl() {
      return cloudUrl;
   }

   public String getCloudClient() {
      return cloudClient;
   }

   public String getCloudSecret() {
      return cloudSecret;
   }

   public String getCloudRealm() {
      return cloudRealm;
   }
}
