/*=====================================================================================
 * ReadFileThread.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.io.*;
import java.sql.*;
import java.util.HashMap;
import java.util.logging.*;

/**
 * Class for reading plsql files and execute them in stand alone threads
 * @author mabose
 */
public class ReadFileThread extends Thread {

    private File path, temporaryPath, fileName;
    @SuppressWarnings("NonConstantLogger")
    private Logger errorLogger;
    private HashMap<String, String> definesMap;
    private boolean outputs, extLogging;
    private String logFilePath, masterLogFilePath, userName, passWord, connectString, threadingMethod, spoolFile;
    private ThreadGroup threadGroup;
    private DbInstallerWatcher dbInstallerWatcher;
    private String lineSeparator = System.getProperty("line.separator", "\n");

    /**
     * Constructor for class ReadFileThread
     * @param threadGroup ThreadGroup
     * @param threadName String
     * @param path File
     * @param temporaryPath File
     * @param fileName File
     * @param logFilePath String
     * @param masterLogFilePath String
     * @param errorLogger Logger
     * @param definesMap HashMap<String, String>
     * @param userName String
     * @param passWord String
     * @param connectString String
     * @param threadingMethod String
     * @param outputs boolean
     * @param dbInstallerWatcher DbInstallerWatcher 
     * @param spoolFile String
     */
   public ReadFileThread(ThreadGroup threadGroup, String threadName,
            File path, File temporaryPath, File fileName, String logFilePath, String masterLogFilePath, Logger errorLogger,
            HashMap<String, String> definesMap,
            String userName, String passWord, String connectString, String threadingMethod, boolean outputs, boolean extLogging,
            DbInstallerWatcher dbInstallerWatcher, String spoolFile) {       
        super(threadGroup, threadName);
        this.threadGroup = threadGroup;
        this.path = path;
        this.temporaryPath = temporaryPath;
        this.fileName = fileName;
        this.logFilePath = logFilePath;
        this.masterLogFilePath = masterLogFilePath;
        this.errorLogger = errorLogger;
        this.definesMap = definesMap;
        this.userName = userName;
        this.passWord = passWord;
        this.connectString = connectString;
        this.threadingMethod = threadingMethod;
        this.outputs = outputs;
        this.extLogging = extLogging;
        this.dbInstallerWatcher = dbInstallerWatcher;
        this.spoolFile = spoolFile;
    }

    private boolean insDependenciesExist(String componentName) {
        boolean returnValue = false;
         String dependencyList = DbInstallerUtil.dependencyMap.get(componentName);
         if ("NONE.".equals(dependencyList) || "LAST.".equals(dependencyList)) {
             returnValue = false;
         } else {
             String[] componentDependencies = dependencyList.split(";");
             for (int i = 0; i < componentDependencies.length; i++) {
                 if (componentDependencies[i].contains(".STATIC")) {
                     String dependencyComponent = componentDependencies[i].substring(0, componentDependencies[i].indexOf('.'));
                     if (DbInstallerUtil.componentsMap.containsKey(dependencyComponent)) { 
                        if ("Done".equals(DbInstallerUtil.componentsMap.get(dependencyComponent))
                        ||  "PostIns".equals(DbInstallerUtil.componentsMap.get(dependencyComponent))) {
                           if (insDependenciesExist(dependencyComponent)) {
                              returnValue = true;
                              break;
                           }
                        } else {
                            returnValue = true;
                            break;
                        }
                     }
                 }
             }
         }
        return returnValue;
    }

    /**
     * Method for reading plsql files and execute them in stand alone threads
     */
    @Override
    @SuppressWarnings("SleepWhileInLoop")
    public void run() {
        String componentName = this.threadGroup.getName().toUpperCase();
        if (componentName.contains(".")) {
            componentName = componentName.substring(0, componentName.indexOf('.'));
        }
        boolean waiting = (fileName.toString().toLowerCase().endsWith(".ins"));
        boolean isInterrupted = false;
        while (waiting) {
            try {
                Thread.sleep(5000);
            } catch (InterruptedException iex) {
                isInterrupted = true;
            }
            waiting = (insDependenciesExist(componentName));
        }
        boolean dbSessionCounter = false;
        Connection con = null;
        boolean doLogging = !fileName.toString().toLowerCase().endsWith(".module");
        FileHandler fHandler = null;
        String fullLogFileName = null;
        String fileNameStr = fileName.toString().replace("/", "_").replace("\\", "_").replace(".", "_");
        if (doLogging) {
            fullLogFileName = logFilePath + fileNameStr + "_thread.log";
        }
        Logger logger = Logger.getLogger(fileNameStr + ".thread");
        logger.setUseParentHandlers(false);
        String timeStamp;
        try {
            if (!isInterrupted) {
                if (extLogging) {
                    logger.setLevel(Level.FINE);
                } else {
                    logger.setLevel(Level.INFO);
                }
                if (doLogging) {
                    try {
                        fHandler = new FileHandler(fullLogFileName);
                        fHandler.setFormatter(new ThreadFormatter());
                        fHandler.setFilter(new SpoolFileFilter());
                        logger.addHandler(fHandler);
                    } catch (IOException ex) {
                        StringBuilder errorMsg = new StringBuilder();
                        timeStamp = DbInstallerUtil.getDbTimestamp(con);
                        errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(" at ").append(timeStamp).append(lineSeparator);
                        errorMsg.append("!!!Error setting up error log file ").append(fullLogFileName).append(lineSeparator).append(ex.getMessage());
                        errorLogger.warning(errorMsg.toString());
                    }
                }
                while (dbInstallerWatcher.getSessionCounter() >= dbInstallerWatcher.maxSessions) {
                    logger.fine(new StringBuilder("Too many open DB sessions: ").append(dbInstallerWatcher.getSessionCounter()).toString());
                    try {
                        Thread.sleep(10000);
                    } catch (InterruptedException ex) {
                    }
                }
                dbInstallerWatcher.addToSessionCounter();
                dbSessionCounter = true;
                con = DBConnection.openConnection(userName, passWord, connectString);
                if (con==null) {
                    String logText = new StringBuilder("!!!Error No connection to the database could be established when deploying file ").append(fileName).append(" ").append(DbInstallerUtil.logonError).toString();
                    logger.severe(logText);
                    errorLogger.severe(logText);
                    dbInstallerWatcher.addCompileErrorCounter();
                    if (fileName.toString().toLowerCase().endsWith(".module")) {
                        componentName = fileName.getName().substring(0, fileName.getName().indexOf(".")).toUpperCase();
                        if (DbInstallerUtil.componentsMap.containsKey(componentName)) {
                           DbInstallerUtil.componentsMap.put(componentName, "Done");
                        }
                    }
                } else if (!con.isClosed()) {
                    try {
                     con.setAutoCommit(false);
                    } catch (SQLException ex) {
                        logger.warning("!!!Error while configurating DB connection");
                        logger.warning(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                        StringBuilder errorMsg = new StringBuilder();
                        timeStamp = DbInstallerUtil.getDbTimestamp(con);
                        errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(" at ").append(timeStamp).append(lineSeparator);
                        errorMsg.append("!!!Error while configurating DB connection").append(lineSeparator).append(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                        errorLogger.warning(errorMsg.toString());
                    }
                    if (outputs) {
                        try {
                            Statement stm;
                            stm = con.createStatement();
                            stm.setEscapeProcessing(false);
                            stm.executeUpdate("BEGIN Dbms_Output.Enable(buffer_size => NULL); END;");
                            stm.close();
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

                    String defineOn = definesMap.get("DEFINE");
                    definesMap.put("DEFINE", "ON");
                    PlsqlFileReader p = new PlsqlFileReader(extLogging);
                    if (new File(temporaryPath.toString() + "/dbsession.general").exists()) {
                        p.readFile(temporaryPath, temporaryPath, new File("dbsession.general"), logFilePath, masterLogFilePath, logger, errorLogger, definesMap, con, userName, passWord, connectString, threadingMethod, dbInstallerWatcher, outputs);
                    }
                    definesMap.put("DEFINE", defineOn);
                     try {
                         Statement stm;
                         stm = con.createStatement();
                         stm.setEscapeProcessing(false);
                         String statement = new StringBuilder("BEGIN Dbms_Application_Info.Set_Action('Deploying ").append(fileName.toString()).append("'); END;").toString();
                         stm.execute(statement);
                         stm.close();
                     } catch (SQLException sqlEx) {
                         String msg = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                         StringBuilder logMsg = new StringBuilder();
                         logMsg.append(lineSeparator).append("!!!Error setting Dbms_Application_Info").append(lineSeparator);
                         logMsg.append(msg).append(lineSeparator);
                         logger.warning(logMsg.toString());
                         StringBuilder errorMsg = new StringBuilder();
                         errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(lineSeparator);
                         errorMsg.append("!!!Error Dbms_Application_Info").append(lineSeparator).append(msg);
                         errorLogger.warning(errorMsg.toString());
                         dbInstallerWatcher.addCompileErrorCounter();
                     }
                    p.readFile(path, temporaryPath, fileName, logFilePath, masterLogFilePath, logger, errorLogger, definesMap, con, userName, passWord, connectString, threadingMethod, dbInstallerWatcher, outputs);
                    try {
                        con.close();
                        dbInstallerWatcher.removeFromSessionCounter();
                        dbSessionCounter = false;
                    } catch (SQLException ex) {
                        logger.warning("!!!Error while closing DB connection");
                        logger.warning(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                        StringBuilder errorMsg = new StringBuilder();
                        timeStamp = DbInstallerUtil.getDbTimestamp(con);
                        errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(" at ").append(timeStamp).append(lineSeparator);
                        errorMsg.append("!!!Error while closing DB connection").append(lineSeparator).append(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                        errorLogger.warning(errorMsg.toString());
                        dbInstallerWatcher.addCompileErrorCounter();
                    }
                } else {
                    String logText = new StringBuilder("!!!Error No connection to the database could be established when deploying file ").append(fileName).toString();
                    logger.severe(logText);
                    errorLogger.severe(logText);
                    dbInstallerWatcher.addCompileErrorCounter();
                    if (fileName.toString().toLowerCase().endsWith(".module")) {
                        componentName = fileName.getName().substring(0, fileName.getName().indexOf(".")).toUpperCase();
                        if (DbInstallerUtil.componentsMap.containsKey(componentName)) {
                           DbInstallerUtil.componentsMap.put(componentName, "Done");
                        }
                    }
                }
                if (fHandler != null) {
                    logger.removeHandler(fHandler);
                    fHandler.close();
                }
                if (doLogging) {
                    File tempInLogFile = new File(fullLogFileName);
                    File tempOutLogFile;
                    BufferedWriter output;
                    try (BufferedReader input = new BufferedReader(new FileReader(tempInLogFile))) {
                        if (spoolFile.length() > 0) {
                            tempOutLogFile = new File(logFilePath + spoolFile);
                        } else {
                            tempOutLogFile = new File(logFilePath + fileName.toString().substring(0, fileName.toString().indexOf(".")) + ".log");
                        }
                        output = new BufferedWriter(new FileWriter(tempOutLogFile, true));
                        String line;
                        while ((line = input.readLine()) != null) {
                            output.write(line + lineSeparator);
                        }
                    }
                    output.close();
                    tempInLogFile.delete();
                }
            }
        } catch (SecurityException | SQLException | IOException e) {
            StringBuilder errorMsg = new StringBuilder();
            timeStamp = DbInstallerUtil.getDbTimestamp(con);
            errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(" at ").append(timeStamp).append(lineSeparator);
            errorMsg.append("!!! Unexpected error").append(lineSeparator).append(e.getMessage());
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
        } catch (DbBuildException ex) {
          Logger.getLogger(ReadFileThread.class.getName()).log(Level.SEVERE, null, ex);
       } finally {
            if (dbSessionCounter = true) {
                dbInstallerWatcher.removeFromSessionCounter();
                dbSessionCounter = false;
            }
            dbInstallerWatcher.removeFromThreadCounterAll();
            if (fileName.toString().toLowerCase().endsWith(".ins")) {
                componentName = fileName.getName().substring(0, fileName.getName().indexOf(".")).toUpperCase();
                if (DbInstallerUtil.componentsMap.containsKey(componentName)) {
                  if (DbInstallerUtil.componentsMap.get(componentName).equals("Ins")) {
                     DbInstallerUtil.componentsMap.put(componentName, "Done");
                  } else {
                     DbInstallerUtil.componentsMap.put(componentName, "PostIns");
                  }
                }
                dbInstallerWatcher.removeFromThreadCounterInternal();
            }
        }
    }
}
