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
 * ----------------------------------------------------------------------------
 * File        : ImportConnectConfigs.java
 * Description :
 * Notes       :
 * ----------------------------------------------------------------------------
 * Modified    :
 * ----------------------------------------------------------------------------
 */
package ifs.fnd.dataimport;

import java.io.*;
import java.sql.*;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Objects;
import java.util.Properties;

public class ImportConnectConfigs {

    private String debugFilePath = null;
    private String filesDir = null;
    private boolean quiet = false;
    private String loginId;
    private String password;
    private String connectString;

    private OutputMessageStream debugStream = null;
    private Connection connection = null;

    private static final String STMT_IMPORT_CONFIG = "DECLARE \n" +
            "result_    Connect_Config_Xml_API.Import_Result;"
            + "BEGIN \n"
            + "result_ := Connect_Config_Xml_API.Import_(:file_clob_, :import_method_, :new_name_);\n"
            + "END;";

   /**
    * Creates a new instance of DbMergeFilesTask
    * @param connectString
    * @param loginId
    * @param password
    * @param filesDir
    * @param debugFilePath
    * @param quiet
    */
   public ImportConnectConfigs(String connectString, String loginId, String password, String filesDir, String debugFilePath) {
      this.connectString = connectString;
      this.loginId = loginId; 
      this.password = password;
      this.filesDir = filesDir;
      this.debugFilePath = debugFilePath + "/" + "import_connectConfigs.log";
   }   
   

    public void execute() throws ImportException {
        try {
            validatePrerequisites();
            initializeLogStream();
            File filesDir = new File(this.filesDir);
            if (filesDir.exists()) {
                connectToDatabase();
                importConfigFiles(filesDir);
            }
        } catch (Exception e) {
            if (!quiet) {
                logError("Error occurred while importing connect config files " + "\n");
                logError("Error : " + e.getMessage() + "\n");
                logError(Arrays.toString(e.getStackTrace()));
                throw new ImportException(e.getMessage());
            }
        } finally {
            closeDbConnection();
            closeDebugStream();
        }
    }

    private void importConfigFiles(File filesDir) {
        logInfo("Importing files in directory : " + filesDir.getName());
        File[] filesList = filesDir.listFiles();
        if (Objects.nonNull(filesList) && filesList.length > 0) {
            for (File file : filesList) {
                importFile(file);
            }
        } else {
            logInfo("There are no connect config files to import");
        }
    }

    private void importFile(File file) {
        if (file.isFile()) {
            try (CallableStatement statement = connection.prepareCall(STMT_IMPORT_CONFIG)) {
                logInfo("Importing file : " + file.getName());
                Clob fileClob = connection.createClob();
                String fileContent = getStringContent(file);
                fileClob.setString(1, fileContent);
                statement.setClob(1, fileClob);
                statement.setString(2, "DELIVERY");
                statement.setString(3, "");
                statement.execute();
                logInfo("Successfully imported file : " + file.getName());
            } catch (Exception e) {
                logError("Error importing file " + file.getName() + "\n");
                logError("Error : " + e.getMessage() + "\n");
                logError(Arrays.toString(e.getStackTrace()));
            }
        } else if (file.isDirectory()) {
            importConfigFiles(file);
        }
    }

    private String getStringContent(File file) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line = reader.readLine();
        StringBuilder stringBuilder = new StringBuilder();
        while (Objects.nonNull(line)) {
            stringBuilder.append(line).append("\n");
            line = reader.readLine();
        }
        return stringBuilder.toString();
    }

    private void closeDebugStream() {
        if (Objects.nonNull(debugStream)) {
            debugStream.close();
            debugStream = null;
        }
    }

    private void closeDbConnection() throws ImportException {
        if (Objects.nonNull(connection)) {
            try {
                connection.close();
            } catch (SQLException e) {
                logError("Error closing database connection.");
                logError("Error: " + e.getMessage());
            }
        }
    }

    private void connectToDatabase() throws SQLException, ImportException {
        logInfo("Connecting to the database");
        Properties properties = new Properties();
        properties.setProperty("user", loginId);
        properties.setProperty("password", password);
        connection = DriverManager.getConnection(connectString, properties);
        connection.setAutoCommit(true);
        try {
            if (connection.isClosed())
                throw new ImportException("ERROR:No connection to the database could be established (1)! Connect string " + connectString);
            logInfo("Connection to the database successful");
        } catch (Exception e) {
            throw new ImportException("ERROR:No connection to the database could be established (1)! Connect string " + connectString);
        }
    }

    private void initializeLogStream() throws FileNotFoundException {
        if (debugFilePath != null) {
            File file = new File(debugFilePath);
            debugStream = new OutputMessageStream(new FileOutputStream(file, true));
            System.setErr(debugStream);
            logNewLine();
        }
    }

    private void validatePrerequisites() throws ImportException {
        if (filesDir == null || filesDir.length() == 0) {
            throw new ImportException("WARNING: IMPORT: Mandatory connect config file directory path is Null.");
        }
    }

    private void logInfo(String msg) {
        if (debugStream != null) {
            debugStream.println(msg);
        }
    }

    private void logError(String msg) {
        if (debugStream != null) {
            String[] ms = msg.split("\n");
            for (int i = 0; i < ms.length; i++) {
                debugStream.printEr(ms[i]);
            }
        }
    }

    private void logNewLine() {
        if (debugStream != null) {
            debugStream.newLine();
        }
    }

    private class OutputMessageStream extends java.io.PrintStream {

        public OutputMessageStream(FileOutputStream fos) {
            super(fos);
        }

        public OutputMessageStream(FileOutputStream fos, boolean autoFlush) {
            super(fos, autoFlush);
        }

        @Override
        public void print(String msg) {
            super.print(msg);
        }

        @Override
        public void println(String msg) {
            Calendar calendar = Calendar.getInstance();
            java.util.Date date = calendar.getTime();
            super.println("[" + date.toString() + "]  " + msg);
        }

        public void printEr(String msg) {
            super.println(msg);
        }

        public void newLine() {
            super.println("");
        }

        public void printDebug(String msg) {
            Calendar calendar = Calendar.getInstance();
            java.util.Date date = calendar.getTime();
            super.print("[" + date.toString() + " ]" + msg + "\r\n");
        }
    }
}
