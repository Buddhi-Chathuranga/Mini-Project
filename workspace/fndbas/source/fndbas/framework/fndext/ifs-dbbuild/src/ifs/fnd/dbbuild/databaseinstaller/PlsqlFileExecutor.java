/*=====================================================================================
 * PlsqlFileExecutor.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * Bug 105000  2012-09-05  MaBose     Re-execute latest command in case of resource busy, ORA-00054
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;
import java.util.logging.*;
import javax.swing.text.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.netbeans.api.lexer.Token;
import org.netbeans.api.lexer.TokenHierarchy;
import org.netbeans.api.lexer.TokenSequence;


/**
 * Class that execute the plsql commands
 * @author mabose
 */
@SuppressWarnings("ClassWithMultipleLoggers")
public class PlsqlFileExecutor {

    private List executableObjs;
    private Document doc;
    private boolean outputs;
    @SuppressWarnings("NonConstantLogger")
    private Logger logger, errorLogger;
    private HashMap<String, String> definesMap;
    private Connection con;
    private DbInstallerWatcher dbInstallerWatcher;
    private String fileName;
    private String lineSeparator = System.getProperty("line.separator", "\n");

    /**
     * Creates a new instance of the class
     */
    public PlsqlFileExecutor() {
    }

    /**
     * Creates a new instance of the class with variables
     * @param executableObjs List
     * @param doc Document
     * @param logger Logger
     * @param errorLogger Logger
     * @param definesMap HashMap<String, String> 
     * @param con Connection
     * @param dbInstallerWatcher DbInstallerWatcher
     * @param outputs boolean
     * @param fileName String
     * @param silent boolean
     * @param loggingOn boolean
     */
    public PlsqlFileExecutor(List executableObjs, Document doc, Logger logger, Logger errorLogger, HashMap<String, String> definesMap, Connection con, DbInstallerWatcher dbInstallerWatcher, boolean outputs, String fileName) {   
        this.executableObjs = executableObjs;
        this.doc = doc;
        this.logger = logger;
        this.errorLogger = errorLogger;
        this.definesMap = definesMap;
        this.con = con;
        this.dbInstallerWatcher = dbInstallerWatcher;
        this.outputs = outputs;
        this.fileName = fileName;
    }

    /**
     * Method pads spaces to the right
     * @param txt String
     * @param size int
     * @return String
     */
    private String rPad(String txt, int size) {
        return rPad(txt, size, ' ');
    }

    /**
     * Method pads characters to the right
     * @param txt String
     * @param size int
     * @param padChar char
     * @return String
     */
    private String rPad(String txt, int size, char padChar) {
        if (txt == null) {
            txt = "";
        }
        int padSize = size - txt.length();
        if (padSize < 1) {
            return txt;
        }
        char[] padding = new char[padSize];
        for (int i = 0; i < padSize; i++) {
            padding[i] = padChar;
        }
        return txt + new String(padding);
    }

    /**
     * Class for viewing select results
     */
    private class ResultSetViewer {

        ResultSet rs;
        Statement stmt;
        String query;
        int totalRowCount;
        ResultSetMetaData meta;

        /**
         * Creates a new instance of the class
         * @param rs ResultSet
         * @param stmt Statement
         * @param logger Logger
         * @param errorLogger Logger 
         */
        ResultSetViewer(ResultSet rs, Statement stmt, String query, Logger logger, Logger errorLogger, String fileName) {
            try {
                this.meta = rs.getMetaData();
                this.rs = rs;
                this.stmt = stmt;
                this.query = query;
                this.totalRowCount = 0;
            } catch (SQLException ex) {
                logger.warning(new StringBuilder("Error fetching meta data for select.").append(lineSeparator).append(this.query).append(lineSeparator).append(ex.toString()).toString());
                StringBuilder errorMsg = new StringBuilder(lineSeparator);
                String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                errorMsg.append("!!!Error fetching meta data for select").append(lineSeparator).append(this.query).append(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                errorLogger.warning(errorMsg.toString());
                dbInstallerWatcher.addCompileErrorCounter();
                this.meta = null;
            }
        }

        /**
         * Method displays the next block
         * @param logger Logger
         * @param errorLogger Logger
         */
        private void displayNextBlock(Logger logger, Logger errorLogger) {
            if (!(meta == null || rs == null)) {
                try {
                    int columnCount = meta.getColumnCount();
                    int[] columnSize = new int[columnCount + 1];
                    ArrayList<String[]> result = new ArrayList<>();
                    for (int i = 1; i <= columnCount; i++) {
                        String txt = meta.getColumnLabel(i);
                        if (txt == null) {
                            txt = "";
                        }
                        int size = txt.length() + 3;
                        columnSize[i] = size;
                    }
                    for (int rowCount = 0; rowCount < DbInstallerUtil.defaultMaxSelectedRows; rowCount++) {
                        if (totalRowCount == 0 || rowCount != 0) {
                            //don't do rs.next() for the first line in subsequent fetches since it's already been done at the end of the last fetch
                            //to determine if there were more rows to fetch (in which case the "Fetch next" message should be displayed
                            if (!rs.next()) {
                                break;
                            }
                        }
                        String[] values = new String[columnCount + 1];
                        for (int i = 1; i <= columnCount; i++) {
                            String txt = rs.getString(i);
                            if (txt == null) {
                                txt = "";
                            }
                            int size = txt.length() + 3;
                            columnSize[i] = size > columnSize[i] ? size : columnSize[i];
                            values[i] = txt;
                        }
                        result.add(values);
                        totalRowCount++;
                    }
                    int totalSize = 0;
                    StringBuilder colTitles = new StringBuilder();
                    StringBuilder sqlResult = new StringBuilder();
                    for (int i = 1; i <= columnCount; i++) {
                        colTitles.append(rPad(meta.getColumnLabel(i), columnSize[i]));
                        totalSize += columnSize[i];
                    }
                    logger.info(colTitles.toString());
                    logger.info(rPad("", totalSize, '-'));
                    for (int i = 0; i < result.size(); i++) {
                        String[] values = result.get(i);
                        for (int j = 1; j <= columnCount; j++) {
                            sqlResult.append(rPad(values[j], columnSize[j]));
                        }
                        logger.info(sqlResult.toString());
                        sqlResult.delete(0, sqlResult.length());
                    }
                    if (!rs.next()) {
                        logger.info("---");
                        logger.info(new StringBuilder().append(totalRowCount).append(" row(s).").append(lineSeparator).toString());
                        rs = null;
                    } else {
                        logger.info("---");
                        logger.info(new StringBuilder("Maximum ").append(DbInstallerUtil.defaultMaxSelectedRows).append(" rows will be displayed...").toString());
                        rs = null;
                    }
                } catch (SQLException ex) {
                    logger.warning(new StringBuilder("!!!Error fetching rows").append(lineSeparator).append(this.query).append(lineSeparator).append(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator)).toString());
                    StringBuilder errorMsg = new StringBuilder(lineSeparator);
                    String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                    errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                    errorMsg.append("!!!Error fetching rows").append(lineSeparator).append(this.query);
                    errorMsg.append(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                    errorLogger.warning(errorMsg.toString());
                    dbInstallerWatcher.addCompileErrorCounter();
                }
            }
        }
    }

    /**
     * Methods executes a select query
     * @param query String
     * @throws java.sql.SQLException
     */
    private void executeSelect(String query) throws SQLException {
        if (this.logger.getLevel() == Level.FINE
                || this.logger.getLevel() == Level.FINER
                || this.logger.getLevel() != Level.FINEST) {
            StringBuilder logText = new StringBuilder();
            logText.append("> Executing Statement:").append(lineSeparator);
            if (query.contains("\n")) {
                if (this.logger.getLevel() == Level.FINE) {
                    logText.append(query.substring(0, query.indexOf('\n'))).append(lineSeparator).append("   ...");
                } else {
                    logText.append(query.replaceAll("\n", lineSeparator));
                }
            } else {
                logText.append(query);
            }
            this.logger.fine(logText.toString());
        }
        try (Statement stmt = this.con.createStatement()) {
            stmt.setEscapeProcessing(false);
            ResultSet rs = stmt.executeQuery(query);
            ResultSetViewer viewer = new ResultSetViewer(rs, stmt, query, this.logger, this.errorLogger, this.fileName);
            viewer.displayNextBlock(this.logger, this.errorLogger);
            rs.close();
        }
    }

    /**
     * Method for describing a db object
     * @param tokenizer StringTokenizer
     * @throws java.sql.SQLException
     */
    private void describeObject(StringTokenizer tokenizer) throws SQLException {
        if (!tokenizer.hasMoreTokens()) {
            this.logger.info("Syntax: DESCRIBE [object]");
            return;
        }
        String objectName = tokenizer.nextToken().toUpperCase();
        String query = "SELECT COLUMN_NAME \"Name\", "
                + "decode(nullable,'Y','','NOT NULL') \"Nullable\", "
                + "data_type||decode(data_type,'VARCHAR2','('||char_length||')', "
                + "'DATE','','NUMBER',decode(data_precision,null,'','('||data_precision||"
                + "decode(data_scale,0,'',null,'',','||data_scale)||')'),'') \"Type\""
                + "FROM ALL_TAB_COLUMNS "
                + "WHERE TABLE_NAME = '" + objectName + "'ORDER BY COLUMN_ID";
        this.logger.info(new StringBuilder("DESCRIBE ").append(objectName).toString());
        executeSelect(query);
    }

   private void recompileInvalidatedPackages(String errorText, String exeObjType, String exeObjName) {
      String userName = DBConnection.getUserName().toUpperCase();
      String pattern = "("+userName+"\\.)?([A-Z0-9_]{1,128})( \\(|\\))";
      Pattern p = Pattern.compile(pattern);
      Matcher m = p.matcher(errorText);
      List<String> objects = new ArrayList<>();
      while (m.find()) {
         String packageToCompile = "'"+m.group(2)+"', Installation_SYS.Get_Object_Type('"+m.group(2)+"')";
         if (!objects.contains(packageToCompile)
                 && !exeObjName.toUpperCase().equals(m.group(2).toUpperCase())) {
            objects.add(packageToCompile);
         } 
      }
      pattern = "("+userName+"\\.)([A-Z0-9_]{1,128})";
      p = Pattern.compile(pattern);
      m = p.matcher(errorText);
      while (m.find()) {
         String packageToCompile = "'"+m.group(2)+"', Installation_SYS.Get_Object_Type('"+m.group(2)+"')";
         if (!objects.contains(packageToCompile)
                 && !exeObjName.toUpperCase().equals(m.group(2).toUpperCase())) {
            objects.add(packageToCompile);
         } 
      }
      Collections.reverse(objects);
      if (exeObjType != null && !exeObjType.isEmpty() && exeObjName != null && !exeObjName.isEmpty()) {
         String objectToCompile = "'"+exeObjName+"', '"+exeObjType+"'";
         if (!objects.contains(objectToCompile)) {
            objects.add(objectToCompile);
         } 
      }
      for (int i = 0; i < objects.size(); i++) {
         Statement stm = null;
         try 
         {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
            }
            stm = con.createStatement();
            stm.setEscapeProcessing(false);
            this.logger.info("Recompiling "+objects.get(i));
            stm.execute("BEGIN Database_SYS.Compile_Invalid_Object("+objects.get(i)+", FALSE); END;");
         } catch (SQLException sqlEx) {
         } catch (Exception ex) {
         } finally {
            try {
               if (stm != null) {
                  stm.close();
               } 
            } catch (SQLException ex2) {
            }
         }
      }
   }
       
    private String deployPlsqlCodeNewSession(String plsqlText) {
        String timeStamp;
        String excMessage = "";
        String userName = DBConnection.getUserName();
        String passWord = DBConnection.getPassword();
        String connectString = DBConnection.getConnectionString();
        dbInstallerWatcher.addToSessionCounter();
        Connection tempCon = DBConnection.openConnection(userName, passWord, connectString);
        try {
            if (tempCon==null) {
                String logText = new StringBuilder("!!!Error No connection to the database could be established when deploying file ").append(fileName).append(" ").append(DbInstallerUtil.logonError).toString();
                logger.severe(logText);
                errorLogger.severe(logText);
                dbInstallerWatcher.addCompileErrorCounter();
            } else if (!tempCon.isClosed()) {
                try {
                   tempCon.setAutoCommit(false);
                } catch (SQLException ex) {
                   logger.warning("!!!Error while configurating DB connection");
                   logger.warning(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                   StringBuilder errorMsg = new StringBuilder();
                   timeStamp = DbInstallerUtil.getDbTimestamp(tempCon);
                   errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(" at ").append(timeStamp).append(lineSeparator);
                   errorMsg.append("!!!Error while configurating DB connection").append(lineSeparator).append(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                   errorLogger.warning(errorMsg.toString());
               }
               if (outputs) {
                  try {
                       try (Statement stm = tempCon.createStatement()) {
                           stm.setEscapeProcessing(false);
                           stm.executeUpdate("BEGIN Dbms_Output.Enable(buffer_size => NULL); END;");
                       }
                  } catch (SQLException sqlEx) {
                     String msg = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                     StringBuilder logMsg = new StringBuilder();
                     logMsg.append(lineSeparator).append("!!!Error turning on DbmsOutput").append(lineSeparator);
                     logMsg.append(msg).append(lineSeparator);
                     logger.warning(logMsg.toString());
                     StringBuilder errorMsg = new StringBuilder();
                     errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(lineSeparator);
                     errorMsg.append("!!!Error turning on DbmsOutput").append(lineSeparator).append(msg);
                     errorLogger.warning(errorMsg.toString());
                     dbInstallerWatcher.addCompileErrorCounter();
                  }
               }                    
               try {
                    try (Statement stm = tempCon.createStatement()) {
                        stm.setEscapeProcessing(false);
                        stm.execute(plsqlText);
                    }
               } catch (SQLException sqlEx) {
                  excMessage = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
               } catch (Exception ex) {
                  excMessage = ex.getMessage();
               }
            }
        } catch (SQLException ex) {
            excMessage = excMessage + ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
        }
        try {
            tempCon.close();
            dbInstallerWatcher.removeFromSessionCounter();
        } catch (SQLException | NullPointerException ex) {
            excMessage = excMessage + ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
        }
        return excMessage;
    }

    @SuppressWarnings("SleepWhileInLoop")
    private boolean executeStatement(String plsqlText, String exeObjName, String exeObjType, boolean logHeader) {
        boolean deploymentOk = true;
        Statement stm = null;
        try {
            stm = con.createStatement();
            stm.setEscapeProcessing(false);
            if (logHeader) {
                this.logger.fine(new StringBuilder("> Creating ").append(exeObjType).append(" ").append(exeObjName).toString());
            }
            stm.execute(plsqlText);
            stm.close();
        } catch (SQLException sqlEx) {
            String excMessage = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
            boolean retry = false;
            int retries = 0;
            if (excMessage.contains("PLS-00907")||excMessage.contains("PLS-00905")) {
                this.logger.info("Database object has been invalidated, trying to recompile dependencies 1.");
                recompileInvalidatedPackages(excMessage, exeObjType, exeObjName);
                retries++;
                retry = true;
            } else if (excMessage.contains("ORA-00060") ||
                       excMessage.contains("ORA-04020") ||
                       excMessage.contains("ORA-04021") ||
                       excMessage.contains("ORA-20113") ||
                       excMessage.contains("ORA-00054")) {
                retries++;
                retry = true;
                this.logger.info(new StringBuilder("Database object is locked, waiting ").append(retries * 5).append(" seconds and trying to execute the statement again.").toString());
            }
            while (retry) {
                if (retries > 0) {
                    try {
                        Thread.sleep(retries * 5000);
                    } catch (InterruptedException e) {
                    }
                }
                excMessage = "";
                retry = false;
                try {
                    stm.execute(plsqlText);
                    stm.close();
                } catch (SQLException sqlEx2) {
                    excMessage = sqlEx2.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                    if (excMessage.contains("ORA-00060") ||
                        excMessage.contains("ORA-04021") ||
                        excMessage.contains("ORA-20113") ||
                        excMessage.contains("ORA-00054")) {
                        retries++;
                        if (retries < 6) {
                            this.logger.info(new StringBuilder("Database object is locked, waiting ").append(retries * 5).append(" seconds and trying to execute the statement again.").toString());
                            retry = true;
                        }
                    }
                }
            }
            if (excMessage.length() > 0) {
               String action;
               if (plsqlText.trim().toUpperCase().startsWith("CREATE")) {
                   action = "creating ";
               } else {
                   action = "executing ";
               }
               String timeStamp = DbInstallerUtil.getDbTimestamp(con);
               this.logger.warning(new StringBuilder(lineSeparator).append("!!!Error ").append(action).append(exeObjType).append(" ").append(exeObjName).append(" at ").append(timeStamp).append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(excMessage).append(lineSeparator).toString());
               StringBuilder errorMsg = new StringBuilder(lineSeparator);
               errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
               errorMsg.append("!!!Error ").append(action).append(exeObjType).append(" ").append(exeObjName).append(lineSeparator);
               errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(excMessage);
               errorLogger.warning(errorMsg.toString());
               dbInstallerWatcher.addCompileErrorCounter();
               deploymentOk = false;
            }
        } catch (Exception ex) {
            String msg = ex.getMessage();
            String timeStamp = DbInstallerUtil.getDbTimestamp(con);
            this.logger.warning(new StringBuilder("!!!Error: Uncategorized database problem at ").append(timeStamp).append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).toString());
            StringBuilder errorMsg = new StringBuilder(lineSeparator);
            errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
            errorMsg.append("!!!Error executing select statement").append(lineSeparator);
            errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
            deploymentOk = false;
        } finally {
            try {
               stm.close();
            } catch (SQLException Ex3) {
            }
        }
        return deploymentOk;
    }

    @SuppressWarnings("SleepWhileInLoop")
    private boolean executeUpdateStatement(String plsqlText, String exeObjType, boolean logHeader) {
        boolean deploymentOk = true;
        String msg;
        Statement stm = null;
        try {
            stm = con.createStatement();
            stm.setEscapeProcessing(false);
            if ((logHeader)
                    && (this.logger.getLevel() == Level.FINE
                    || this.logger.getLevel() == Level.FINER
                    || this.logger.getLevel() == Level.FINEST)) {
                StringBuilder logText = new StringBuilder("> Executing ");
                logText.append(exeObjType).append(" block").append(lineSeparator);
                if (plsqlText.contains("\n")) {
                    if (this.logger.getLevel() == Level.FINE) {
                        String tmpText = plsqlText.substring(0, plsqlText.indexOf('\n')).trim();
                        if (("DECLARE".equalsIgnoreCase(tmpText)
                                || "BEGIN".equalsIgnoreCase(tmpText))
                                && plsqlText.indexOf('\n') != plsqlText.lastIndexOf('\n')) {
                            tmpText = plsqlText.substring(0, plsqlText.indexOf('\n', plsqlText.indexOf('\n') + 1));
                        }
                        logText.append(tmpText).append(lineSeparator).append("...");
                    } else {
                        logText.append(plsqlText.replaceAll("\n", lineSeparator));
                    }
                } else {
                    logText.append(plsqlText);
                }
                this.logger.fine(logText.toString());
            }
            stm.executeUpdate(plsqlText);
            stm.close();
            DbInstallerUtil.processDbmsOutputMessages(this.outputs, con, logger, errorLogger, dbInstallerWatcher, fileName);
        } catch (SQLException sqlEx1) {
            boolean retry = false;
            String excMessage = sqlEx1.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
            int retries = 0;
            if (excMessage.contains("ORA-04068")) {
                this.logger.fine("Database object has been discarded, trying to execute the statement again.");
                if (outputs) {
                   try {
                     Statement stmtEnable;
                     stmtEnable = con.createStatement();
                     stmtEnable.setEscapeProcessing(false);
                     stmtEnable.execute("BEGIN Dbms_Output.Enable(buffer_size => NULL); END;");
                     stmtEnable.close();
                   } catch (SQLException enableEx) {
                     msg = enableEx.getMessage();
                     String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                     this.logger.warning(new StringBuilder("!!!Error: Uncategorized database problem at ").append(timeStamp).append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).toString());
                     StringBuilder errorMsg = new StringBuilder(lineSeparator);
                     errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                     errorMsg.append("!!!Error executing select statement").append(lineSeparator);
                     errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
                     errorLogger.warning(errorMsg.toString());
                     dbInstallerWatcher.addCompileErrorCounter();
                     deploymentOk = false;
                   }
                }
                retries++;
                retry = true;
            } else if (excMessage.contains("PLS-00907")||excMessage.contains("PLS-00905")) {
                this.logger.info("Database object has been invalidated, trying to recompile dependencies 2.");
                recompileInvalidatedPackages(excMessage, "", "");
                retries++;
                retry = true;
            } else if (excMessage.contains("ORA-00060") ||
                       excMessage.contains("ORA-04020") ||
                       excMessage.contains("ORA-04021") ||
                       excMessage.contains("ORA-20113") ||
                       excMessage.contains("ORA-00054")) {
                retries++;
                retry = true;
                this.logger.info(new StringBuilder("Database object is locked, waiting ").append(retries * 5).append(" seconds and trying to execute the statement again.").toString());
            }
            while (retry) {
                if (retries > 0) {
                    try {
                        Thread.sleep(retries * 5000);
                    } catch (InterruptedException e) {
                    }
                }
                retry = false;
                excMessage = "";
                try {
                    stm.executeUpdate(plsqlText);
                    stm.close();
                    DbInstallerUtil.processDbmsOutputMessages(this.outputs, con, logger, errorLogger, dbInstallerWatcher, fileName);
                } catch (SQLException sqlEx2) {
                    excMessage = sqlEx2.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                    if (excMessage.contains("ORA-00060") ||
                        excMessage.contains("ORA-04020") ||
                        excMessage.contains("ORA-04021") ||
                        excMessage.contains("ORA-20113") ||
                        excMessage.contains("ORA-00054")) {
                        retries++;
                        if (retries < 6) {
                            retry = true;
                            this.logger.info(new StringBuilder("Database object is locked, waiting ").append(retries * 5).append(" seconds and trying to execute the statement again.").toString());
                        }
                    }
                }
            }
            if (excMessage.length() > 0) {
                msg = excMessage;
                String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                StringBuilder logMsg = new StringBuilder(lineSeparator);
                logMsg.append("!!!Error occurred while executing Plsql Block at ").append(timeStamp).append(lineSeparator);
                logMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).append(lineSeparator);
                this.logger.warning(logMsg.toString());
                StringBuilder errorMsg = new StringBuilder(lineSeparator);
                errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                errorMsg.append("!!!Error occurred while executing Plsql Block").append(lineSeparator);
                errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
                errorLogger.warning(errorMsg.toString());
                dbInstallerWatcher.addCompileErrorCounter();
                deploymentOk = false;
            }
        } catch (Exception ex) {
            msg = ex.getMessage();
            String timeStamp = DbInstallerUtil.getDbTimestamp(con);
            this.logger.warning(new StringBuilder("!!!Error: Uncategorized database problem at ").append(timeStamp).append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).toString());
            StringBuilder errorMsg = new StringBuilder(lineSeparator);
            errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
            errorMsg.append("!!!Error executing select statement").append(lineSeparator);
            errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
            deploymentOk = false;
        } finally {
            try {
               stm.close();
            } catch (SQLException Ex3) {
            }
        }
        return deploymentOk;
    }

    @SuppressWarnings("SleepWhileInLoop")
    private boolean deployPlsqlCode(String plsqlText, String exeObjName, String exeObjType) {
        List errLst;
        boolean exception = false;
        boolean deploymentOk = true;
        boolean timeOut = false;
        String msg;
        String excMessage = "";
        Statement stm = null;
        
        boolean retry = true;
        int retries = 0;
        while (retry) {
            excMessage = "";
            retry = false;
            exception = false;
            timeOut = false;
            try {
                stm = con.createStatement();
                stm.setEscapeProcessing(false);
                this.logger.fine(new StringBuilder("> Creating ").append(exeObjType).append(" ").append(exeObjName).toString());
                stm.setQueryTimeout(600);
                stm.execute(plsqlText);
                stm.close();
            } catch (SQLException sqlEx) {
                excMessage = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                timeOut = sqlEx instanceof SQLTimeoutException  || excMessage.contains("ORA-01013");
                if (timeOut) {
                   try {
                       Thread.sleep(((plsqlText.length() % 3) + 1) * 1000);
                   } catch (InterruptedException e) {
                   }
                }
                exception = true;
            } catch (Exception ex) {
                 excMessage = ex.getMessage();
                 exception = true;
            } finally {
                 try {
                     stm.close();
                 } catch (SQLException | NullPointerException Ex) {
                 }
            }
            errLst = getPackageErrors(exeObjName, exeObjType, plsqlText);
            if ((errLst.toString().contains("PLS-00907")||errLst.toString().contains("PLS-00905")) && (!exception)) {
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                }
                retries++;
                if (retries < 6) {
                   retry = true;
                   this.logger.info(new StringBuilder("Database object ").append(exeObjName).append(" has been invalidated, trying to recompile dependencies. Waiting ").append(retries * 5).append(" seconds and trying to execute the statement again.").toString());
                  recompileInvalidatedPackages(errLst.toString(), exeObjType, exeObjName);
                }
            } else if (excMessage.contains("PLS-00907")||excMessage.contains("PLS-00905")) {
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                }
                retries++;
                if (retries < 6) {
                   retry = true;
                   this.logger.info(new StringBuilder("Database object ").append(exeObjName).append(" has been invalidated, trying to recompile dependencies. Waiting ").append(retries * 5).append(" seconds and trying to execute the statement again.").toString());
                   recompileInvalidatedPackages(excMessage, exeObjType, exeObjName);
                }
            } else if (excMessage.contains("Object has been closed") ||
                       excMessage.contains("Closed Statement")) {
               this.logger.info(new StringBuilder("Object ").append(exeObjName).append(" has been closed, waiting ").append(retries * 5).append(" seconds and trying to execute the statement again in a new database session").toString());
               try {
                   Thread.sleep(retries * 5000);
               } catch (InterruptedException e) {
               }
               excMessage = deployPlsqlCodeNewSession(plsqlText);
               if ("".equals(excMessage)) {
                   exception = false;
               }
            } else if (timeOut) {
               try {
                    Thread.sleep((((plsqlText.length()  + exeObjName.length()) % 3) + 1) * 1000);
               } catch (InterruptedException e) {
               }
               try {
                  stm.setQueryTimeout(((plsqlText.length() % 10) + 120) * 5);
               } catch (SQLException e) {
               }
               retries++;
               if (retries < 2) {
                  retry = true;
               }
            } else if (excMessage.contains("ORA-00060") ||
                       excMessage.contains("ORA-04020") ||
                       excMessage.contains("ORA-04021") ||
                       excMessage.contains("ORA-20113") ||
                       excMessage.contains("ORA-00054")) {
                retries++;
                if (retries < 6) {
                   retry = true;
                   this.logger.info(new StringBuilder("Database object ").append(exeObjName).append(" is locked, waiting ").append(retries * 5).append(" seconds and trying to execute the statement again.").toString());
                }
            }
            if (retry) {
               try {
                  Thread.sleep(retries * 5000);
               } catch (InterruptedException e) {
               }
            }
        }
        errLst = getPackageErrors(exeObjName, exeObjType, plsqlText);
        if ((errLst.isEmpty()) && (!exception)) {
            this.logger.finer(new StringBuilder(exeObjType).append(" ").append(exeObjName).append(" OK").toString());
        } else if ((errLst.isEmpty()) && (exception)) {
            int errLine = getLineNumberFromMsg(excMessage);
            msg = getModifiedErrorMsg(excMessage, errLine);
            String timeStamp = DbInstallerUtil.getDbTimestamp(con);
            StringBuilder errorMsg = new StringBuilder(lineSeparator);
            errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
            if (timeOut) {
               logger.warning(new StringBuilder(lineSeparator).append("!!!Error deploying database object").append(lineSeparator).append(exeObjType).append(" ").append(exeObjName).append(" not created/replaced because it is locked by another process. You might need to redeploy it manually").append(lineSeparator).append(msg).toString());
               errorMsg.append("!!!").append(exeObjType).append(" ").append(exeObjName).append(" not created/replaced because it is locked by another process. You might need to redeploy it manually").append(lineSeparator).append(msg);
            }else{
               logger.warning(new StringBuilder(lineSeparator).append("!!!Error deploying database object").append(lineSeparator).append("!!!").append(exeObjType).append(" ").append(exeObjName).append(" created with compilation errors").append(" at ").append(timeStamp).append(lineSeparator).append(msg).append(lineSeparator).toString());
               errorMsg.append("!!!").append(exeObjType).append(" ").append(exeObjName).append(" created with compilation errors").append(lineSeparator).append(msg);
            }
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
            deploymentOk = false;
        } else {
            String timeStamp = DbInstallerUtil.getDbTimestamp(con);
            logger.warning(new StringBuilder(lineSeparator).append("!!!Error deploying database object").append(lineSeparator).append("!!!").append(exeObjType).append(" ").append(exeObjName).append(" created with compilation errors").append(" at ").append(timeStamp).toString());
            StringBuilder errorMsg = new StringBuilder(lineSeparator);
            errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
            errorMsg.append("!!!").append(exeObjType).append(" ").append(exeObjName).append(" created with compilation errors").append(lineSeparator);
            for (int a = 0; a < errLst.size(); a++) {
                PlsqlErrorObject errObj = (PlsqlErrorObject) errLst.get(a);
                int errNo = errObj.getLineNumber();
                msg = errObj.getErrorMsg();
                msg = getModifiedErrorMsg(msg, errNo);
                logger.warning(msg);
                errorMsg.append(msg).append(lineSeparator);
            }
            logger.warning(lineSeparator);
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
            deploymentOk = false;
        }
        return deploymentOk;
    }

    /**
     * Method for executing a set of plsql code blocks.
     * @return HashMap<String, String>
     */
    public HashMap<String, String> executePLSQL() {
        boolean deploymentOk = true;
        try {
            if (con.isClosed()) {
                this.logger.warning("!!!Error, no database connection exists");
                StringBuilder errorMsg = new StringBuilder(lineSeparator);
                errorMsg.append("!!!Error deploying file ").append(fileName).append(lineSeparator);
                errorMsg.append("!!! No database connection exists");
                errorLogger.warning(errorMsg.toString());
                dbInstallerWatcher.addCompileErrorCounter();
                return this.definesMap;
            }
        } catch (SQLException ex) {
            this.logger.warning("!!!Error, no database connection exists");
            StringBuilder errorMsg = new StringBuilder(lineSeparator);
            errorMsg.append("!!!Error deploying file ").append(fileName).append(lineSeparator);
            errorMsg.append("!!! No database connection exists");
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
            return this.definesMap;
        }


        boolean defineOn = "ON".equalsIgnoreCase(definesMap.get("DEFINE"));
        char define = definesMap.get("DEFINECHARACTER").charAt(0);
        String plsqlText = "";
        String exeObjName;

        boolean debugMode = false;
        try {
            int columnComment = 0;
            if (debugMode) { // Logic for debugMode might be added later
                if (this.fileName.toLowerCase().endsWith(".api") || this.fileName.toLowerCase().endsWith(".apy")) {
                    plsqlText = "ALTER SYSTEM SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL' \t\n";
                    try {
                        this.logger.fine(new StringBuilder("> Enabling Usages for ").append(this.fileName).toString());
                        try (Statement stm = this.con.createStatement()) {
                            stm.setEscapeProcessing(false);
                            stm.execute(plsqlText);
                        }
                    } catch (SQLException sqlEx) {
                        String msg = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                        String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                        this.logger.warning(new StringBuilder("!!!Error setting up PLSCOPE_SETTINGS ").append(" at ").append(timeStamp).append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).toString());
                        StringBuilder errorMsg = new StringBuilder(lineSeparator);
                        errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                        errorMsg.append("!!!Error setting up PLSCOPE_SETTINGS ").append(lineSeparator);
                        errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
                        errorLogger.warning(errorMsg.toString());
                        dbInstallerWatcher.addCompileErrorCounter();
                        deploymentOk = false;
                    }
                }
            }

            for (int i = 0; i < this.executableObjs.size(); i++) {
                PlsqlExecutableObject exeObj = (PlsqlExecutableObject) this.executableObjs.get(i);
                plsqlText = exeObj.getPlsqlString();

                exeObjName = exeObj.getExecutableObjName().toUpperCase();
                if ((exeObj.getType() != PlsqlExecutableObjectType.UNKNOWN)
                        && (exeObj.getType() != PlsqlExecutableObjectType.COMMENT)) {
                    //replace aliases since there are aliases in PROMPTS
                    if (defineOn) {
                        plsqlText = replaceAliases(plsqlText, define);
                        exeObjName = replaceAliases(exeObjName, define);
                    }
                }
                String msg;
                if (exeObj.getType() == PlsqlExecutableObjectType.VIEW) {
                    deploymentOk = executeStatement(plsqlText, exeObjName, "VIEW", true);
                } else if (exeObj.getType() == PlsqlExecutableObjectType.STATEMENT) {
                    String firstWord;
                    StringTokenizer tokenizer = new StringTokenizer(plsqlText, " \t\n");
                    if (tokenizer.hasMoreTokens()) {
                        firstWord = tokenizer.nextToken();
                    } else {
                        firstWord = plsqlText;
                    }
                    if (firstWord.equalsIgnoreCase("SELECT")) {
                        try {
                            executeSelect(plsqlText);
                        } catch (SQLException sqlEx) {
                            msg = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                            String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                            this.logger.warning(new StringBuilder("!!!Error executing select statement ").append(exeObjName).append(" at ").append(timeStamp).append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).toString());
                            StringBuilder errorMsg = new StringBuilder(lineSeparator);
                            errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                            errorMsg.append("!!!Error executing select statement").append(lineSeparator);
                            errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
                            errorLogger.warning(errorMsg.toString());
                            dbInstallerWatcher.addCompileErrorCounter();
                            deploymentOk = false;
                        }
                    } else {
                        if (this.logger.getLevel() == Level.FINE
                                || this.logger.getLevel() == Level.FINER
                                || this.logger.getLevel() == Level.FINEST) {
                            StringBuilder logText = new StringBuilder("> Executing statement ");
                            logText.append(lineSeparator);
                            if (plsqlText.contains("\n")) {
                                if (this.logger.getLevel() == Level.FINE) {
                                    logText.append(plsqlText.substring(0, plsqlText.indexOf('\n'))).append(lineSeparator).append("...");
                                } else {
                                    logText.append(plsqlText.replaceAll("\n", lineSeparator));
                                }
                            } else {
                                logText.append(plsqlText);
                            }
                            this.logger.fine(logText.toString());
                        }
                        deploymentOk = executeStatement(plsqlText, exeObjName, "STATEMENT", false);
                    }
                    continue;
                } else if (exeObj.getType() == PlsqlExecutableObjectType.TRIGGER) {
                    deploymentOk = executeStatement(plsqlText, exeObjName, "TRIGGER", true);
                } else if (exeObj.getType() == PlsqlExecutableObjectType.JAVASOURCE) {
                    deploymentOk = executeStatement(plsqlText, exeObjName, "JAVA SOURCE", true);
                } else if (exeObj.getType() == PlsqlExecutableObjectType.TABLECOMMENT) {
                    deploymentOk = executeStatement(plsqlText, exeObjName, "TABLE COMMENT", true);
                } else if (exeObj.getType() == PlsqlExecutableObjectType.COLUMNCOMMENT) {
                    deploymentOk = executeStatement(plsqlText, exeObjName, "COLUMN COMMENT", (columnComment == 0));
                    columnComment++;
                } else if (exeObj.getType() == PlsqlExecutableObjectType.DECLAREEND) {
                    deploymentOk = executeUpdateStatement(plsqlText, "DECLARE END", true);
                } else if (exeObj.getType() == PlsqlExecutableObjectType.BEGINEND) {
                    deploymentOk = executeUpdateStatement(plsqlText, "BEGIN END", true);
                } else if (exeObj.getType() == PlsqlExecutableObjectType.UNKNOWN) {
                    define = getAliases(exeObj.getStartOffset(), exeObj.getEndOffset(), define);
                    defineOn = "ON".equalsIgnoreCase(definesMap.get("DEFINE"));
                    if (defineOn) {
                       plsqlText = replaceAliases(plsqlText, define);
                    }
                    plsqlText = plsqlText.trim();
                    removeAliases(exeObj.getStartOffset(), exeObj.getEndOffset());
                    String firstWord;
                    StringTokenizer tokenizer = new StringTokenizer(plsqlText, " \t\n");
                    if (tokenizer.hasMoreTokens()) {
                        firstWord = tokenizer.nextToken();
                    } else {
                        firstWord = plsqlText;
                    }
                    if (firstWord.equalsIgnoreCase("SELECT")) {
                        try {
                            executeSelect(plsqlText);
                        } catch (SQLException sqlEx) {
                            msg = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                            String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                            this.logger.warning(new StringBuilder("!!!Error executing select statement ").append(exeObjName).append(" at ").append(timeStamp).append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).toString());
                            StringBuilder errorMsg = new StringBuilder(lineSeparator);
                            errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                            errorMsg.append("!!!Error executing select statement").append(lineSeparator);
                            errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
                            errorLogger.warning(errorMsg.toString());
                            dbInstallerWatcher.addCompileErrorCounter();
                            deploymentOk = false;
                        }
                    } else if (firstWord.equalsIgnoreCase("DESC")
                            || firstWord.equalsIgnoreCase("DESCRIBE")) {
                        try {
                            describeObject(tokenizer);
                        } catch (SQLException sqlEx) {
                            msg = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                            this.logger.warning(new StringBuilder("!!!Error occurred while describing object").append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).toString());
                            StringBuilder errorMsg = new StringBuilder(lineSeparator);
                            String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                            errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                            errorMsg.append("!!!Error executing describing object").append(lineSeparator);
                            errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
                            errorLogger.warning(errorMsg.toString());
                            dbInstallerWatcher.addCompileErrorCounter();
                            deploymentOk = false;
                        }
                    } else if (firstWord.equalsIgnoreCase("PROMPT")) {
                        if (plsqlText.length() > 7) {
                            this.logger.info(plsqlText.substring(7));
                        } else {
                            this.logger.info(" ");
                        }
                    } else if (firstWord.equalsIgnoreCase("SPOOL")) {
                       continue;
                    } else if (firstWord.equalsIgnoreCase("EXIT")) {
                        logger.info(new StringBuilder(lineSeparator).append("!!!EXIT find in file ").append(fileName).append(". Stopping file execution").toString());
                        this.definesMap.put("ExitIn"+fileName, "EXIT");
                        break;
                    } else if (firstWord.equalsIgnoreCase("ACCEPT")) {
                        if (tokenizer.hasMoreTokens()) {
                            String alias, value, defaultValue, question, nextToken;
                            boolean hide = false;
                            boolean prompt = false;
                            alias = tokenizer.nextToken();
                            question = alias;
                            defaultValue = "";
                            value = "";
                            
                            while (tokenizer.hasMoreTokens()) {
                               nextToken = tokenizer.nextToken();
                               if (nextToken.equalsIgnoreCase("DEFAULT")) {
                                  if (tokenizer.hasMoreTokens()) {
                                     defaultValue = tokenizer.nextToken();
                                     if (defaultValue.startsWith("'")) {
                                        String temp = defaultValue;
                                        while (tokenizer.hasMoreTokens() && !temp.endsWith("'")) {
                                           temp = tokenizer.nextToken();
                                           defaultValue = defaultValue + " " + temp;
                                        }
                                        defaultValue = defaultValue.replace("'", "");
                                     }
                                  }
                               }
                               if (nextToken.equalsIgnoreCase("PROMPT")) {
                                  if (tokenizer.hasMoreTokens()) {
                                     prompt = true;
                                     question = tokenizer.nextToken();
                                     if (question.startsWith("'")) {
                                        String temp = question;
                                        while (tokenizer.hasMoreTokens() && !temp.endsWith("'")) {
                                           temp = tokenizer.nextToken();
                                           question = question + " " + temp;
                                        }
                                        question = question.replace("'", "");
                                     }
                                  }
                               }
                               if (nextToken.equalsIgnoreCase("HIDE")) {
                                  hide = true;
                               }
                            }
                            if (!prompt) {
                                question = alias;
                                if (defaultValue.length() > 0) {
                                    question = question + " (default is " + defaultValue + ")";
                                }
                                question = "Enter value for " + question + " in file " + this.fileName;
                            }
                            if (value.length() < 1) {
                                if (defaultValue.length() > 0) {
                                    value = defaultValue;
                                    if (alias.toUpperCase().contains("PASSWORD")
                                            || alias.toUpperCase().contains("PASSWD")
                                            || alias.equalsIgnoreCase("PWD")
                                            || hide) {
                                        this.logger.info(new StringBuilder("The default value for ").append(alias.toUpperCase()).append(" is used").toString());
                                    } else {
                                        this.logger.info(new StringBuilder("The default value \"").append(value).append("\" is used for ").append(alias.toUpperCase()).toString());
                                    }
                                } else {
                                    value = " ";
                                }
                            }
                            if (alias.length() > 0 && value.length() > 0) {
                                this.definesMap.put(alias.toUpperCase(), value);
                            }
                        }
                    } else if (firstWord.equalsIgnoreCase("SHOW")) {
                    } else if (firstWord.equalsIgnoreCase("CLEAR")) {
                    } else if (firstWord.equalsIgnoreCase("SET")) {
                        if (tokenizer.hasMoreTokens()) {
                            String setting = tokenizer.nextToken();
                            if ("DEFINE".equalsIgnoreCase(setting)) {
                                if (tokenizer.hasMoreElements()) {
                                    String token = tokenizer.nextToken();
                                    if ("OFF".equalsIgnoreCase(token)) {
                                       defineOn = false;
                                       definesMap.put("DEFINE", "OFF");
                                    }
                                    else {
                                       defineOn = true;
                                       definesMap.put("DEFINE", "ON");
                                       if (token.length() == 1) {
                                          define = token.charAt(0);
                                          definesMap.put("DEFINECHARACTER", token);
                                       }
                                    }
                                }
                            }
                        }
                    } else if (firstWord.equalsIgnoreCase("DEFINE") || firstWord.equalsIgnoreCase("DEF") || firstWord.equalsIgnoreCase("DEFI") || firstWord.equalsIgnoreCase("DEFIN")) {
                    } else if (firstWord.equalsIgnoreCase("UNDEFINE") || firstWord.equalsIgnoreCase("UNDEF")) {
                    } else if (firstWord.equalsIgnoreCase("EXECUTE") || firstWord.equalsIgnoreCase("EXEC") || firstWord.equalsIgnoreCase("CALL")) {
                        if (!plsqlText.trim().endsWith(";")) {
                            plsqlText += ";";
                        }
                        plsqlText = "BEGIN\n" + plsqlText.substring(firstWord.length()) + "\nEND;";
                        executeUpdateStatement(plsqlText, "PLSQL", true);
                    } else if ((";".equals(plsqlText) || "/".equals(plsqlText)) || ("".equals(plsqlText))) {
                    } else {
                        deploymentOk = executeStatement(plsqlText, exeObjName, "COMMAND", true);
                    }
                } else if (exeObj.getType() == PlsqlExecutableObjectType.PROCEDURE) {
                    deploymentOk = deployPlsqlCode(plsqlText, exeObjName, "PROCEDURE");
                } else if (exeObj.getType() == PlsqlExecutableObjectType.FUNCTION) {
                    deploymentOk = deployPlsqlCode(plsqlText, exeObjName, "FUNCTION");
                } else if (exeObj.getType() == PlsqlExecutableObjectType.PACKAGE) {
                    deploymentOk = deployPlsqlCode(plsqlText, exeObjName, "PACKAGE");
                } else if (exeObj.getType() == PlsqlExecutableObjectType.PACKAGEBODY) {
                    deploymentOk = deployPlsqlCode(plsqlText, exeObjName, "PACKAGE BODY");
                } else if (exeObj.getType() == PlsqlExecutableObjectType.TYPE) {
                    deploymentOk = deployPlsqlCode(plsqlText, exeObjName, "TYPE");
                } else if (exeObj.getType() == PlsqlExecutableObjectType.TYPEBODY) {
                    deploymentOk = deployPlsqlCode(plsqlText, exeObjName, "TYPE BODY");
                }
            }
        } catch (Exception ex) {
            String msg = ex.getMessage();
            String timeStamp = DbInstallerUtil.getDbTimestamp(con);
            this.logger.warning(new StringBuilder("!!!Error: Uncategorized database problem at ").append(timeStamp).append(lineSeparator).append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg).toString());
            StringBuilder errorMsg = new StringBuilder(lineSeparator);
            errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
            errorMsg.append("!!!Error executing select statement").append(lineSeparator);
            errorMsg.append(plsqlText.replace("\n", lineSeparator)).append(lineSeparator).append(msg);
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
            deploymentOk = false;
        }
        return this.definesMap;
    }

    /**
     * Method for returning a readable error message
     * @param msg String
     * @param lineNumber int
     * @return String
     */
    private static String getModifiedErrorMsg(String msg, int lineNumber) {
        int index = msg.indexOf('\n');
        if (index >= 0) {
            msg = msg.replaceAll("\n", "");
        }
        msg = new StringBuilder(msg).append(" error at line no :").append(lineNumber).toString();
        return msg;
    }

    /**
     * Method for getting all errors for a db object
     * @param packageName String
     * @param packageType String
     * @return List
     */
    private List getPackageErrors(String packageName, String packageType, String plsqlText) {
        List<PlsqlErrorObject> lst = new ArrayList<>();
        if (con != null) {
            Statement stm = null;
            try {
                if (!con.isClosed()) {
                    stm = this.con.createStatement();
                    stm.setEscapeProcessing(false);
                    StringBuilder query = new StringBuilder("SELECT LINE, POSITION, TEXT FROM ");
                    int endPos = plsqlText.toUpperCase().indexOf("." + packageName);
                    if (endPos > 0) {
                        int startPos = plsqlText.lastIndexOf(" ", endPos);
                        if (startPos > 0) {
                            String owner = plsqlText.substring(startPos + 1, endPos);
                            query = query.append("DBA_ERRORS WHERE OWNER = '").append(owner).append("' AND TYPE = '");
                        } else {
                            query = query.append("USER_ERRORS WHERE TYPE = '");
                        }
                    } else {
                        query = query.append("USER_ERRORS WHERE TYPE = '");
                    }
                    query = query.append(packageType).append("' AND NAME = '").append(packageName).append("'");
                    PlsqlErrorObject errObj;
                    ResultSet rs;
                    for (rs = stm.executeQuery(query.toString()); rs.next();) {
                        int lineNo = rs.getInt("LINE");
                        int pos = rs.getInt("POSITION");
                        String msg = rs.getString("TEXT");
                        errObj = new PlsqlErrorObject();
                        errObj.setLineNumber(lineNo);
                        errObj.setPosition(pos);
                        errObj.setErrorMsg(msg);
                        lst.add(errObj);
                    }
                    rs.close();
                }
            } catch (SQLException e) {
                if (e.getMessage().contains("ORA-00942")) {
                    // ignore!
                } else {
                    // do what??
                }
            } finally {
                try {
                    stm.close();
                } catch (SQLException ex) {
                }
            }
        }
        return lst;
    }

/**
 * Method that will return the error line number in the given SQL error message
 * @param message String
 * @return int
 */
    protected static int getLineNumberFromMsg(String message) {
        int indexLine = message.indexOf("line ");
        int indexColumn = message.indexOf(',');
        int errLine = 1;
        if ((indexLine >= 0) && (indexColumn >= 0) && (indexColumn - indexLine > 5)) {
            String errLineStr = message.substring(indexLine + 5, indexColumn);
            try {
                errLine = Integer.parseInt(errLineStr);
            } catch (Exception e) {
            }
        }
        return errLine;
    }

    /**
     * Method that will parse the document and initialize the aliases
     * @param start int
     * @param end int
     * @param define char
     * @return char
     */
    @SuppressWarnings("UnusedAssignment")
    private char getAliases(int start, int end, char define) {
        TokenHierarchy tokenHierarchy = TokenHierarchy.get(this.doc);
        @SuppressWarnings("unchecked")
        TokenSequence<PlsqlTokenId> ts = tokenHierarchy.tokenSequence(PlsqlTokenId.language());
        ts.move(start);
        boolean moveNext = ts.moveNext();
        Token<PlsqlTokenId> token = ts.token();
        Token<PlsqlTokenId> tokenPre = ts.token();

        while (moveNext) {
            if (token.offset(tokenHierarchy) >= end) {
                break;
            }
            //Check whether this is DEFINE
            PlsqlTokenId tokenId = token.id();
            if (tokenId == PlsqlTokenId.SQL_PLUS) {
                String tokenTxt = DbInstallerUtil.readLine(ts, token);
                if ((tokenTxt.toUpperCase().startsWith("DEF "))
                        || (tokenTxt.toUpperCase().startsWith("DEFI "))
                        || (tokenTxt.toUpperCase().startsWith("DEFIN "))
                        || (tokenTxt.toUpperCase().startsWith("DEFINE "))) {
                    if (!tokenTxt.contains(" = ") && tokenTxt.contains("=")) {
                        tokenTxt = tokenTxt.substring(0, tokenTxt.indexOf('=')) + " = " + tokenTxt.substring(tokenTxt.indexOf('=') + 1);
                    }
                    StringTokenizer tokenizer = new StringTokenizer(tokenTxt);
                    tokenizer.nextToken();
                    String alias;
                    String value = "";
                    boolean isNext = tokenizer.hasMoreTokens();
                    if (isNext) {
                        alias = tokenizer.nextToken();
                    } else {
                        break;
                    }

                    isNext = tokenizer.hasMoreTokens();
                    if ((isNext) && (tokenizer.nextToken().toString().equals("="))) {
                        boolean comments = false;
                        if (tokenizer.hasMoreTokens()) {
                            while ((tokenizer.hasMoreTokens()) && (!comments)) {
                                String temp = tokenizer.nextToken();
                                if (temp.startsWith("--") || temp.startsWith("/*")) {
                                    comments = true;
                                } else {
                                    value = value + " " + temp;
                                }
                            }
                            value = value.trim();
                            if ((value.startsWith("\"") && value.endsWith("\""))
                                    || (value.startsWith("\'") && value.endsWith("\'"))) {
                                value = value.substring(1, value.length() - 1);
                            }
                            if (value.indexOf(define) >= 0) { //The substitute variable might be another substitute variable
                                value = replaceAliases(value, define);
                            }
                            this.definesMap.put(alias.toUpperCase(), value);
                        }
                    }
                } else if (tokenTxt.toUpperCase().startsWith("SET ")) {
                    StringTokenizer tokenizer = new StringTokenizer(tokenTxt);
                    String alias;
                    alias = tokenizer.nextToken();
                    alias = tokenizer.nextToken();
                    if ("DEFINE".equalsIgnoreCase(alias.trim())) {
                        if (tokenizer.hasMoreTokens()) {
                            alias = tokenizer.nextToken();
                        } else {
                            break;
                        }
                        if ("OFF".equalsIgnoreCase(alias)) {
                           definesMap.put("DEFINE", "OFF");
                        } else {
                           definesMap.put("DEFINE", "ON");
                           if (alias.length() == 1) {
                               define = alias.charAt(0); //If define changed we catch it here
                               definesMap.put("DEFINECHARACTER", alias);
                           }
                        }
                    } else {
                        break;
                    }
                }
            }
            if ((token.id() != PlsqlTokenId.WHITESPACE)
                    && (token.id() != PlsqlTokenId.LINE_COMMENT)
                    && (token.id() != PlsqlTokenId.BLOCK_COMMENT)) {
                tokenPre = token;
            }
            moveNext = ts.moveNext();
            token = ts.token();
        }
        return define;
    }

    /**
     * Method that will remove aliases at UNDEFINE
     * @param start int
     * @param end int
     */
    private void removeAliases(int start, int end) {
        TokenHierarchy tokenHierarchy = TokenHierarchy.get(this.doc);
        @SuppressWarnings("unchecked")
        TokenSequence<PlsqlTokenId> ts = tokenHierarchy.tokenSequence(PlsqlTokenId.language());
        ts.move(start);
        boolean moveNext = ts.moveNext();
        Token<PlsqlTokenId> token = ts.token();

        while (moveNext) {
            if (token.offset(tokenHierarchy) >= end) {
                break;
            }
            //Check whether this is DEFINE
            PlsqlTokenId tokenId = token.id();
            if (tokenId == PlsqlTokenId.SQL_PLUS) {
                String tokenTxt = DbInstallerUtil.readLine(ts, token);
                if ((tokenTxt.toUpperCase().startsWith("UNDEF "))
                        || (tokenTxt.toUpperCase().startsWith("UNDEFI "))
                        || (tokenTxt.toUpperCase().startsWith("UNDEFIN "))
                        || (tokenTxt.toUpperCase().startsWith("UNDEFINE "))) {
                    String alias;
                    StringTokenizer tokenizer = new StringTokenizer(tokenTxt);
                    tokenizer.nextToken();
                    boolean isNext = tokenizer.hasMoreTokens();
                    if (isNext) {
                        alias = tokenizer.nextToken();
                        if (alias != null) {
                            this.definesMap.remove(alias.toUpperCase());
                        }
                        break;
                    } else {
                        break;
                    }
                }
            }
            moveNext = ts.moveNext();
            token = ts.token();
        }
    }

    /**
     * Replace aliases in the given string
     * @param plsqlString String
     * @param define char
     * @return String
     */
    private String replaceAliases(String plsqlString, char define) {
        if (plsqlString.indexOf(define) < 0) {
            return plsqlString;
        }
        plsqlString = plsqlString.replace("&&", "&");
        StringBuilder newString = new StringBuilder();
        for (int i = 0; i < plsqlString.length(); i++) {
            char c = plsqlString.charAt(i);
            if (c == define) {
                for (int j = i + 1; j < plsqlString.length(); j++) {
                    char nextChar = plsqlString.charAt(j);
                    if (Character.isJavaIdentifierPart(nextChar) && j == plsqlString.length() - 1) { //we have reached the end of the text
                        nextChar = '.'; //this will make sure that the correct sustitution is made below by emulating an additional character
                        j = j + 1;
                    }
                    if (!Character.isJavaIdentifierPart(nextChar)) { //potential end of substitutionvariable
                        if (j > i + 1) { //substituion variable found
                            String name = plsqlString.substring(i + 1, j).toUpperCase();
                            String value = DbInstallerUtil.passwordsMap.get(name);
                            if (value == null) {
                               value = this.definesMap.get(name);
                            }
                            if (value == null) {
                              value = " ";
                              if (name.toUpperCase().contains("PASSWORD")
                                      || name.toUpperCase().contains("PASSWD")
                                      || name.equalsIgnoreCase("PWD")) {
                                 this.logger.warning(new StringBuilder("Missing value for ").append(name).append(".").toString());
                              } else {
                                 this.logger.warning(new StringBuilder("!!!Error: Missing value for ").append(name).append(". It will be set to blank to continue. ").toString());
                                 StringBuilder errorMsg = new StringBuilder(lineSeparator);
                                 String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                                 errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                                 errorMsg.append("!!!Error: Missing value for ").append(name).append(". It will be set to blank to continue. ").append(lineSeparator);
                                 errorLogger.warning(errorMsg.toString());
                                 dbInstallerWatcher.addCompileErrorCounter();
                              }
                            }
                            if (value.indexOf(define) >= 0) {
                                value = replaceAliases(value, define); //does the converted string contains new substitute variables
                            }
                            newString.append(value);
                            if (nextChar == '.') {
                                i = j;
                            } else {
                                i = j - 1;
                            }
                        } else {
                            newString.append(c);
                        }
                        break;
                    }
                }
            } else {
                newString.append(c);
            }
        }
        return newString.toString();
    }
}
