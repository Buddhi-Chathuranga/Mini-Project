/*=====================================================================================
 * FinalizeComponent.java
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
import java.util.List;
import java.util.logging.*;
import javax.swing.text.*;
import org.netbeans.api.lexer.Language;

/**
 *
 * @author mabose
 */
public class FinalizeComponent extends Thread {

    ThreadGroup moduleThreadGroup;
    private String statement, userName, passWord, connectString, fileName, logFilePath, masterLogFilePath, spoolFile, threadingMethod;
    @SuppressWarnings("NonConstantLogger")
    private Logger errorLogger;
    private HashMap<String, String> definesMap;
    private boolean outputs, extLogging;
    private DbInstallerWatcher dbInstallerWatcher;
    private File temporaryPath;
    private String lineSeparator = System.getProperty("line.separator", "\n");

    public FinalizeComponent(ThreadGroup moduleThreadGroup, String threadName, String statement,
            String userName, String passWord, String connectString, String fileName,
            Logger errorLogger, HashMap<String, String> definesMap,
            boolean outputs, boolean extLogging,
            DbInstallerWatcher dbInstallerWatcher,
            String logFilePath, String masterLogFilePath, String spoolFile,
            File temporaryPath, String threadingMethod) {       
        super(moduleThreadGroup, threadName);
        this.moduleThreadGroup = moduleThreadGroup;
        this.statement = statement + "\n";
        this.userName = userName;
        this.passWord = passWord;
        this.connectString = connectString;
        this.fileName = fileName;
        this.errorLogger = errorLogger;
        this.definesMap = definesMap;
        this.outputs = outputs;
        this.extLogging = extLogging;
        this.dbInstallerWatcher = dbInstallerWatcher;
        this.logFilePath = logFilePath;
        this.masterLogFilePath = masterLogFilePath;
        this.spoolFile = spoolFile;
        this.temporaryPath = temporaryPath;
        this.threadingMethod = threadingMethod;
    }

    @Override
    @SuppressWarnings("SleepWhileInLoop")
    public void run() {
        boolean waiting = true;
        boolean isInterrupted = false;
        String threadGroupName;
        if (moduleThreadGroup.getName().contains(".")) {
           threadGroupName = moduleThreadGroup.getName().substring(0, moduleThreadGroup.getName().indexOf("."));
        } else {
           threadGroupName = moduleThreadGroup.getName();
        }
        while (waiting) {
            try {
                Thread.sleep(5000);
            } catch (InterruptedException iex) {
                isInterrupted = true;
            }
            Thread[] threads = new Thread[moduleThreadGroup.activeCount() + 5];
            moduleThreadGroup.enumerate(threads);
            int maxThreads = moduleThreadGroup.activeCount();
            int validThreads = 0;
            for (int i = 0; i < maxThreads; i++) {
               if (threads[i].getName().toString().contains(".")) {
                  if (threads[i].getName().toString().substring(0, threads[i].getName().toString().indexOf(".")).equalsIgnoreCase(threadGroupName)) {
                     validThreads++;
                  }
               }
            }
            // > 1 since this thread itself is inclued in the thread group
            waiting = (validThreads > 1);
        }
        boolean dbSessionCounter = false;
        Connection con = null;
        FileHandler fHandler = null;
        String fullLogFileName = null;
        String fileNameStr = fileName.replace("/", "_").replace("\\", "_").replace(".", "_");
        fullLogFileName = logFilePath + fileNameStr + "_final.log";
        Logger logger = Logger.getLogger(fileNameStr + ".final");
        logger.setUseParentHandlers(false);
        String timeStamp;
        try {
            if (!isInterrupted) {
                if (extLogging) {                   
                    logger.setLevel(Level.FINE);
                } else {
                    logger.setLevel(Level.INFO);
                }
                try {
                    fHandler = new FileHandler(fullLogFileName);
                    fHandler.setFormatter(new ThreadFormatter());
                    fHandler.setFilter(new SpoolFileFilter());
                    logger.addHandler(fHandler);
                } catch (IOException ex) {
                    StringBuilder errorMsg = new StringBuilder();
                    timeStamp = DbInstallerUtil.getDbTimestamp(con);
                    errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                    errorMsg.append("!!!Error setting up error log file ").append(fullLogFileName).append(lineSeparator).append(ex.getMessage());
                    errorLogger.warning(errorMsg.toString());
                }
                while (dbInstallerWatcher.getSessionCounter() >= dbInstallerWatcher.maxSessions) {
                    logger.fine(new StringBuilder("Too many open DB sessions: ").append(dbInstallerWatcher.getSessionCounter()).toString());
                    try {
                        Thread.sleep(10000);
                    } catch (Exception ex) {
                    }
                }
                dbInstallerWatcher.addToSessionCounter();
                dbSessionCounter = true;
                con = DBConnection.openConnection(userName, passWord, connectString);
                if (con == null) {
                    String logText = new StringBuilder("!!!Error No connection to the database could be established when deploying file ").append(fileName).append(" ").append(DbInstallerUtil.logonError).toString();
                    logger.severe(logText);
                    errorLogger.severe(logText);
                    dbInstallerWatcher.addCompileErrorCounter();
                } else if (!con.isClosed()) {
                    try {
                        con.setAutoCommit(true);
                    } catch (SQLException ex) {
                        logger.warning("!!!Error while configurating DB connection");
                        logger.warning(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                        StringBuilder errorMsg = new StringBuilder();
                        timeStamp = DbInstallerUtil.getDbTimestamp(con);
                        errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
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
                    StyleContext context = new StyleContext();
                    StyledDocument doc = new DefaultStyledDocument(context);
                    SimpleAttributeSet attributes = new SimpleAttributeSet();
                    try {
                        doc.insertString(doc.getLength(), statement, attributes);
                        doc.putProperty("mimeType", "text/x-plsql");
                        doc.putProperty(Language.class, PlsqlTokenId.language());
                    } catch (Exception ex) {
                        logger.warning("!!!Error creating internal document class");
                        logger.warning(ex.getMessage());
                        StringBuilder errorMsg = new StringBuilder();
                        timeStamp = DbInstallerUtil.getDbTimestamp(con);
                        errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                        errorMsg.append("!!!Error creating internal document class").append(lineSeparator).append(ex.getMessage());
                        errorLogger.warning(errorMsg.toString());
                        dbInstallerWatcher.addCompileErrorCounter();
                    }
                    PlsqlExecutableBlocksMaker blockMaker = new PlsqlExecutableBlocksMaker(statement, doc);
                    final List executableObjs = blockMaker.makeExceutableObjects();
                    PlsqlFileExecutor exe = new PlsqlFileExecutor(executableObjs, doc, logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName);                    
                    definesMap = exe.executePLSQL();
                    try {
                        con.close();
                        dbInstallerWatcher.removeFromSessionCounter();
                        dbSessionCounter = false;
                    } catch (SQLException ex) {
                        logger.warning("!!!Error while closing DB connection");
                        logger.warning(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                        StringBuilder errorMsg = new StringBuilder();
                        timeStamp = DbInstallerUtil.getDbTimestamp(con);
                        errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                        errorMsg.append("!!!Error while closing DB connection").append(lineSeparator).append(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                        errorLogger.warning(errorMsg.toString());
                        dbInstallerWatcher.addCompileErrorCounter();
                    }
                } else {
                    String logText = new StringBuilder("!!!Error No connection to the database could be established when deploying file ").append(fileName).toString();
                    logger.severe(logText);
                    errorLogger.severe(logText);
                }
                if (fHandler != null) {
                    logger.removeHandler(fHandler);
                    fHandler.close();
                }
                File tempInLogFile = new File(fullLogFileName);
                if (tempInLogFile.exists()) {
                    File tempOutLogFile;
                    BufferedWriter output;
                    try (BufferedReader input = new BufferedReader(new FileReader(tempInLogFile))) {
                        if (spoolFile.length() > 0) {
                            tempOutLogFile = new File(logFilePath + spoolFile);
                        } else {
                            tempOutLogFile = new File(logFilePath + fileName.substring(0, fileName.indexOf(".")) + ".log");
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
            errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
            errorMsg.append("!!! Unexpected error").append(lineSeparator).append(e.getMessage());
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
        } catch (DbBuildException ex) {
          Logger.getLogger(FinalizeComponent.class.getName()).log(Level.SEVERE, null, ex);
       } finally {
            DbInstallerUtil.componentsMap.remove(fileName.substring(0, fileName.indexOf('.')).toLowerCase()+"Finalize");
            if (dbSessionCounter = true) {
                dbInstallerWatcher.removeFromSessionCounter();
                dbSessionCounter = false;
            }
            dbInstallerWatcher.removeFromThreadCounterAll();
            dbInstallerWatcher.removeFromThreadCounterInternal();
        }
    }
}