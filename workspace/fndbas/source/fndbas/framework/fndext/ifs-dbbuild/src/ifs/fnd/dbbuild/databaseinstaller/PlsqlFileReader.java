/*=====================================================================================
 * PlsqlFileReader.java
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
import java.util.ArrayList;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.logging.*;
import javax.swing.text.*;
import org.netbeans.api.lexer.Language;

/**
 * class for most of the logic while deploying DB objects
 * @author mabose
 */
public class PlsqlFileReader {

   private final boolean extLogging;
   private boolean exitFile;
   private final String lineSeparator = System.getProperty("line.separator", "\n");
   private ThreadGroup mainThreadGroup;
   
   /**
    * Creates a new instance of PlsqlFileReader
    * @param extLogging
    */
   public PlsqlFileReader(boolean extLogging) {
      this.extLogging = extLogging;
   }   

   /**
    * Method that takes a string containing plsql code and divide it into executable blocks before it execute the blocks one by one
    * @param plsqlCode String
    * @param logger Logger
    * @param errorLogger Logger
    * @param definesMapHashMap<String, String>
    * @param con Connection
    * @param dbInstallerWatcher DbInstallerWatcher
    * @param outputs boolean
    * @param fileName String
    * @return HashMap<String, String>
    */
   private HashMap<String, String> executeBlock(String plsqlCode, Logger logger, Logger errorLogger, HashMap<String, String> definesMap, Connection con, DbInstallerWatcher dbInstallerWatcher, boolean outputs, String fileName) {
      if (Thread.currentThread().isInterrupted()) {
         return definesMap;
      }
      if (plsqlCode.replace("\n", "").length() > 0) {
         StyleContext context = new StyleContext();
         StyledDocument doc = new DefaultStyledDocument(context);
         SimpleAttributeSet attributes = new SimpleAttributeSet();
         try {
            doc.insertString(doc.getLength(), plsqlCode, attributes);
            doc.putProperty("mimeType", "text/x-plsql");
            doc.putProperty(Language.class, PlsqlTokenId.language());
         } catch (BadLocationException ex) {
            logger.warning("!!!Error creating internal document class");
            logger.warning(ex.getMessage());
            StringBuilder errorMsg = new StringBuilder();
            errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(lineSeparator);
            errorMsg.append("!!!Error creating internal document class").append(lineSeparator).append(ex.getMessage());
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
         }
         PlsqlExecutableBlocksMaker blockMaker = new PlsqlExecutableBlocksMaker(plsqlCode, doc);
         final List executableObjs = blockMaker.makeExceutableObjects();
         PlsqlFileExecutor exe = new PlsqlFileExecutor(executableObjs, doc, logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName);
         definesMap = exe.executePLSQL();
         if (definesMap.containsKey("ExitIn"+fileName)) {
            definesMap.remove("ExitIn"+fileName);
            exitFile = true;
         }
      }
      return definesMap;
   }

   /**
    * Method that takes a string containing a single plsql block and execute it
    * @param plsqlCode String
    * @param logger Logger
    * @param errorLogger Logger
    * @param definesMapHashMap<String, String>
    * @param con Connection
    * @param dbInstallerWatcher DbInstallerWatcher
    * @param outputs boolean
    * @param fileName String
    * @return HashMap<String, String>
    */
   private HashMap<String, String> executeSingleBlock(String name, PlsqlExecutableObjectType type, String plsqlCode, Logger logger, Logger errorLogger, HashMap<String, String> definesMap, Connection con, DbInstallerWatcher dbInstallerWatcher, boolean outputs, String fileName) {
      if (Thread.currentThread().isInterrupted()) {
         return definesMap;
      }
      if (plsqlCode.replace("\n", "").length() > 0) {
         StyleContext context = new StyleContext();
         StyledDocument doc = new DefaultStyledDocument(context);
         SimpleAttributeSet attributes = new SimpleAttributeSet();
         List<PlsqlExecutableObject> executableObjs = new ArrayList<>();
         try {
            doc.insertString(doc.getLength(), plsqlCode, attributes);
            doc.putProperty("mimeType", "text/x-plsql");
            doc.putProperty(Language.class, PlsqlTokenId.language());

            int start = doc.getStartPosition().getOffset();
            int startLine = DbInstallerUtil.getLineNoForOffset(doc, start);
            int end = doc.getEndPosition().getOffset();
            String content = doc.getText(start, end - start);
            PlsqlExecutableObject obj = new PlsqlExecutableObject(startLine, content, name, type, start, end);
            executableObjs.add(obj);
         } catch (BadLocationException ex) {
            logger.warning("!!!Error creating internal document class");
            logger.warning(ex.getMessage());
            StringBuilder errorMsg = new StringBuilder();
            errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(lineSeparator);
            errorMsg.append("!!!Error creating internal document class").append(lineSeparator).append(ex.getMessage());
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
         }

         PlsqlFileExecutor exe = new PlsqlFileExecutor(executableObjs, doc, logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName);
         definesMap = exe.executePLSQL();
         if (definesMap.containsKey("ExitIn"+fileName)) {
            definesMap.remove("ExitIn"+fileName);
            exitFile = true;
         }
      }
      return definesMap;
   }

   /**
    * private void findNextComponent
    * Method that try to start available components
    * @param doneComponent String
    * @param path File
    * @param temporaryPath File
    * @param logFilePath String
    * @param logger Logger
    * @param errorLogger Logger
    * @param definesMap HashMap<String, String>
    * @param userName String
    * @param passWord String
    * @param connectString String
    * @param outputs boolean 
    * @param ThreadingMethod String
    * @param dbInstallerWatcher DbInstallerWatcher
    * @param spoolFile String
    * @param windowHandler WindowHandler
    */
   @SuppressWarnings("SleepWhileInLoop")
   private void findNextComponent(String doneComponent, File path, File temporaryPath, String logFilePath, String masterLogFilePath, Logger logger, Logger errorLogger, HashMap<String, String> definesMap, String userName, String passWord, String connectString, Connection con, boolean outputs, String threadingMethod, DbInstallerWatcher dbInstallerWatcher, String spoolFile) throws DbBuildException {   
      for (Iterator dependencies = DbInstallerUtil.dependencyMap.keySet().iterator(); dependencies.hasNext();) {
         String componentCandidate = dependencies.next().toString().toUpperCase();
         String dependencyList = DbInstallerUtil.dependencyMap.get(componentCandidate).toUpperCase();
         if (dependencyList.contains(doneComponent + ".")
                 && DbInstallerUtil.componentsMap.containsKey(componentCandidate)) {
            String componentCandidateState = DbInstallerUtil.componentsMap.get(componentCandidate);
            if ("New".equals(componentCandidateState)
                    || "AlreadyExists".equals(componentCandidateState)) {
               boolean readyToGo = true;
               if (!"NONE".equals(doneComponent) &&
                       !"SQLCOMMAND".equals(doneComponent)) {
                  String[] componentDependencies = dependencyList.split(";");
                  for (int i = 0; i < componentDependencies.length; i++) {
                     String dependentComponent = componentDependencies[i].replace(".STATIC", "");
                     if (DbInstallerUtil.componentsMap.containsKey(dependentComponent)) {
                        String tempState = DbInstallerUtil.componentsMap.get(dependentComponent);
                        if (!"Done".equals(tempState)
                                && !"PreIns".equals(tempState)
                                && !"Ins".equals(tempState)) {
                           readyToGo = false;
                           if ("Last".equals(tempState)) {
                              StringBuilder messageString = new StringBuilder(lineSeparator).append("Warning! Unresolved component dependency").append(lineSeparator).append("Component ").append(dependentComponent).append(" is unknown in this environment but it is needed by ").append(componentCandidate).append(lineSeparator);
                              if ("New".equals(componentCandidateState)) {
                                 messageString.append("Component ").append(componentCandidate).append(" will be deployed at the end.").append(lineSeparator);
                                 DbInstallerUtil.componentsMap.put(componentCandidate, "Last");
                              } else if ("AlreadyExists".equals(componentCandidateState)) {
                                 messageString.append("Component ").append(componentCandidate).append(" will be deployed at the end.").append(lineSeparator);
                                 DbInstallerUtil.componentsMap.put(componentCandidate, "LastAlreadyExists");
                              }
                              logger.info(messageString.toString());
                           }
                           break;
                        }
                     } else {
                        if (!"LAST.".equals(dependentComponent)) {
                           StringBuilder messageString = new StringBuilder(lineSeparator).append("Warning! Unresolved component dependency").append(lineSeparator).append("Component ").append(dependentComponent).append(" is missing in this environment but it is needed by ").append(componentCandidate).append(lineSeparator);
                           if ("New".equals(componentCandidateState)) {
                              messageString.append("Component ").append(componentCandidate).append(" will be deployed anyway but unexpected errors might occur.").append(lineSeparator);
                           }
                           logger.info(messageString.toString());
                        }
                     }
                  }
               }
               if (readyToGo) {
                  switch (componentCandidateState) {
                     case "New":
                        DbInstallerUtil.componentsMap.put(componentCandidate, "InProgress");
                        while (mainThreadGroup.activeCount() >= DbInstallerUtil.defaultMaxThreads) {
                           logger.fine(new StringBuilder("Too many open threads: ").append(mainThreadGroup.activeCount()).toString());
                           try {
                              Thread.sleep(2000);
                           } catch (Exception ex) {
                              throw new DbBuildException("WARNING: Unexpected error: " + ex.getMessage(), ex);
                           }
                        }
                        if (!Thread.currentThread().isInterrupted()) {
                           String nextFileName = componentCandidate + ".module";
                           logger.info(new StringBuilder("[").append(DbInstallerUtil.getDbTimestamp(con)).append("] Start deploying ").append(componentCandidate).toString());
                           dbInstallerWatcher.addThread(componentCandidate);
                           HashMap<String, String> tempDefinesMap = new HashMap<>();
                           tempDefinesMap.putAll(definesMap);
                           if (con != null) {
                              try {
                                 if (!con.isClosed()) {
                                    con.commit();
                                 }
                              } catch (SQLException ex) {
                              }
                           }
                           dbInstallerWatcher.addToThreadCounterAll();
                           ReadFileThread fileThread = new ReadFileThread(mainThreadGroup, nextFileName, path.getAbsoluteFile(), temporaryPath, new File(nextFileName), logFilePath, masterLogFilePath, errorLogger, tempDefinesMap, userName, passWord, connectString, threadingMethod, outputs, extLogging, dbInstallerWatcher, spoolFile);
                           fileThread.start();
                        }
                        break;
                     case "AlreadyExists":
                        DbInstallerUtil.componentsMap.put(componentCandidate, "Done");
                        logger.fine(new StringBuilder("Component ").append(componentCandidate).append(" already exists in the database.").toString());
                        findNextComponent(componentCandidate, path, temporaryPath, logFilePath, masterLogFilePath, logger, errorLogger, definesMap, userName, passWord, connectString, con, outputs, threadingMethod, dbInstallerWatcher, spoolFile);
                        break;
                  }
               }
            }
         } else {
            if ("LAST".equals(doneComponent)) {
               if (DbInstallerUtil.componentsMap.containsKey(componentCandidate)) {
                  String componentCandidateState = DbInstallerUtil.componentsMap.get(componentCandidate);
                  if ("New".equals(componentCandidateState)) {
                     String[] componentDependencies = dependencyList.split(";");
                     for (int i = 0; i < componentDependencies.length; i++) {
                        String dependentComponent = componentDependencies[i].replace(".STATIC", "");
                        if (!DbInstallerUtil.componentsMap.containsKey(dependentComponent)) {
                           StringBuilder errorMsg = new StringBuilder(lineSeparator);
                           errorMsg.append("!!!Error: Unresolved component dependency").append(lineSeparator).append("Component ").append(dependentComponent).append(" is missing in this environment but it is needed by ").append(componentCandidate).append(lineSeparator).append("Component ").append(componentCandidate).append(", and any other components that are depending on this, will not be installed.").append(lineSeparator);
                           errorLogger.warning(errorMsg.toString());
                           dbInstallerWatcher.addCompileErrorCounter();
                           DbInstallerUtil.componentsMap.put(componentCandidate, "Done");
                        }
                     }
                  }
               }
            }
         }
      }
   }

   /**
    * Method that replace any aliases
    * @param plsqlString String
    * @param define char
    * @param definesMap HashMap<String, String>
    * @return String
    */
   private String replaceAliases(String plsqlString, char define, HashMap<String, String> definesMap) {
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
                     String name = plsqlString.substring(i + 1, j);
                     String value = definesMap.get(name.toUpperCase());
                     if (value.indexOf(define) >= 0) {
                        value = replaceAliases(value, define, definesMap); //does the converted string contains new substitute variables
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
   
   /**
    * Method that loop until a condition is accomplished
    * @param con Connection
    * @param line String
    * @param logger Logger
    * @param errorLogger Logger
    * @param dbInstallerWatcherDbInstallerWatcher
    * @param fileName String
    * @return boolean
    */
   @SuppressWarnings("SleepWhileInLoop")
   private boolean performIfsInstallerLoop(Connection con, String line, Logger logger, Logger errorLogger, DbInstallerWatcher dbInstallerWatcher, String fileName, HashMap<String, String> definesMap) {
      String[] arrayLine = line.split(";");
      String[] arrayOutParameter = null;
      String executedMethod = null;
      String dbMethod = null;
      String outParameter = null;
      String promptText = null;
      String runSilent = "TRUE";
      String acceptError = "NONE";
      long waitingTime = DbInstallerUtil.silentWaitingTime;
      int sleepingTime = 10000;
      for (int i = 0; i < arrayLine.length; i++) {
         if (arrayLine[i].trim().toUpperCase().startsWith("DBMETHOD=")) {
            dbMethod = arrayLine[i].trim().substring(arrayLine[i].trim().indexOf("=") + 1);
         }
         if (arrayLine[i].trim().toUpperCase().startsWith("CONDITION=")) {
            outParameter = arrayLine[i].trim().substring(arrayLine[i].trim().indexOf("=") + 1);
            if (!outParameter.endsWith(",")) {
               outParameter = outParameter + ",";
            }
            arrayOutParameter = outParameter.split(",");
         }
         if (arrayLine[i].trim().toUpperCase().startsWith("PROMPT=")) {
            promptText = arrayLine[i].trim().substring(arrayLine[i].trim().indexOf("=") + 1);
            if (!promptText.endsWith(":")
                    && !promptText.endsWith(".")) {
               promptText = promptText + ": ";
            }
         }
         if (arrayLine[i].trim().toUpperCase().startsWith("SILENT=")) {
            runSilent = arrayLine[i].trim().substring(arrayLine[i].trim().indexOf("=") + 1);
         }
         if (arrayLine[i].trim().toUpperCase().startsWith("ACCEPTERROR=")) {
            acceptError = arrayLine[i].trim().substring(arrayLine[i].trim().indexOf("=") + 1).toUpperCase();
         }
      }
      Boolean doRun;
      doRun = true;
      doRun = doRun && DbInstallerUtil.askQuestionsMultiRun;
      if (((waitingTime > -1
              && ("TRUE".equalsIgnoreCase(runSilent)
              || "ABORT".equalsIgnoreCase(runSilent))))
              && doRun) {         
         long endTime = System.currentTimeMillis();
         if (waitingTime > -1) {
            endTime = endTime + waitingTime * 1000;
         }
         Statement stmt = null;
         try {
            boolean continueLoop = arrayOutParameter.length > 0;
            boolean firstLoop = true;
            String value;
            while (continueLoop) {
               stmt = con.createStatement();
               stmt.setEscapeProcessing(false);
               dbMethod = replaceAliases(dbMethod, definesMap.get("DEFINECHARACTER").charAt(0), definesMap);
               executedMethod = dbMethod;
               String statement = "SELECT TO_CHAR(" + dbMethod + ") FROM dual";
               ResultSet rs = stmt.executeQuery(statement);
               rs.next();
               value = rs.getString(1);
               rs.close();
               stmt.close();
               for (int i = 0; i < arrayOutParameter.length; i++) {
                  if (arrayOutParameter[i].equals(value)) {
                     StringBuilder dialogText = new StringBuilder(lineSeparator);
                     if (promptText.length() > 0) {
                        dialogText.append(promptText).append(lineSeparator);
                     }
                     dialogText.append("Expected value(s): ").append(outParameter.substring(0, outParameter.lastIndexOf(','))).append(" Current value: ").append(value);
                     dialogText.append(lineSeparator).append(lineSeparator).append("Success! Continue processing...").append(lineSeparator);
                     logger.info(dialogText.toString());
                     continueLoop = false;
                     break;
                  }
               }
               DbInstallerUtil.processDbmsOutputMessages(true, con, logger, errorLogger, dbInstallerWatcher, fileName);
               if (continueLoop) {
                  if ("ABORT".equalsIgnoreCase(runSilent)) {
                     logger.warning("!!!Error: " + promptText);
                     StringBuilder errorMsg = new StringBuilder();
                     errorMsg.append(lineSeparator).append("!!!Error: Unexpected error when executing IFS Installer Loop").append(lineSeparator);
                     errorMsg.append("!!!Error: ").append(promptText);
                     errorLogger.warning(errorMsg.toString());
                     dbInstallerWatcher.addCompileErrorCounter();
                     return false;
                  }
                  if (firstLoop) {
                     firstLoop = false;
                     StringBuilder dialogText = new StringBuilder();
                     if (promptText.length() > 0) {
                        dialogText.append(promptText).append(lineSeparator);
                     }
                     dialogText.append("Expected value(s): ").append(outParameter.substring(0, outParameter.lastIndexOf(','))).append(" Current value: ").append(value);
                     logger.info(dialogText.toString());
                  }
                  try {
                     Thread.sleep(sleepingTime);
                  } catch (Exception ex) {
                     throw new DbBuildException("WARNING: Unexpected error: " + ex.getMessage(), ex);
                  }

                  if (endTime <= System.currentTimeMillis()) {
                     logger.info(new StringBuilder(lineSeparator).append("Waited ").append(waitingTime).append(" seconds for statement ").append(dbMethod).append(" without result. Proceeding...").append(lineSeparator).toString());
                     continueLoop = false;
                  }
               }
            }
         } catch (SQLException sqlEx) {
            StringBuilder logMsg = new StringBuilder();
            if ((sqlEx.getMessage().contains("ORA-00904")
                    && "NOTEXIST".equals(acceptError))
                    || "ALL".equals(acceptError)) {
               logMsg.append(lineSeparator).append("Accepted error!").append(lineSeparator);
               logMsg.append("SQL Method ").append(executedMethod).append(" could not be executed.").append(lineSeparator);
               if ("ALL".equals(acceptError)) {
                  logMsg.append("Message while executing: ").append(sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
               }
               logger.info(logMsg.toString());
            } else {
               logMsg.append("!!!Error: SQL Method ").append(executedMethod).append(" could not be executed.").append(lineSeparator);
               logMsg.append("Error message: ").append(sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
               logger.warning(logMsg.toString());
               StringBuilder errorMsg = new StringBuilder();
               errorMsg.append(lineSeparator).append("!!!Error: SQL Method ").append(executedMethod).append(" could not be executed.").append(lineSeparator);
               errorMsg.append("Error message: ").append(sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
               errorLogger.warning(errorMsg.toString());
               dbInstallerWatcher.addCompileErrorCounter();
            }
         } catch (Exception ex) {
            StringBuilder logMsg = new StringBuilder();
            logMsg.append("!!!Error: Unexpected error when executing IFS Installer Loop").append(lineSeparator);
            logMsg.append("!!!Error message ").append(ex.getMessage());
            logger.warning(logMsg.toString());
            StringBuilder errorMsg = new StringBuilder();
            errorMsg.append(lineSeparator).append("!!!Error: Unexpected error when executing IFS Installer Loop").append(lineSeparator);
            errorMsg.append("!!!Error message ").append(ex.getMessage());
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
         } finally {
            try {
               stmt.close();
            } catch (SQLException sqlEx) {
               StringBuilder errorMsg = new StringBuilder();
               errorMsg.append(lineSeparator).append("!!!Error: Unexpected SQL error").append(lineSeparator);
               errorMsg.append("!!!Error message ").append(sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
               errorLogger.warning(errorMsg.toString());
               dbInstallerWatcher.addCompileErrorCounter();
            }
         }
      }
      return true;
   }

   /**
    * Method that pre reads a plsql file to verify if the file is possible to thread
    * @param fileName File
    * @param logger Logger
    * @param errorLogger Logger
    * @param dbInstallerWatcher DbInstallerWatcher
    * @return boolean
    */
   private boolean verifyThreading(File fileName, Logger logger, Logger errorLogger, DbInstallerWatcher dbInstallerWatcher) {
      Boolean correctThreading = true;
      try {
            Path filePath = fileName.toPath();
            List<String> stringList = Files.readAllLines(filePath, StandardCharsets.UTF_8);
            String[] stringArray = stringList.toArray(new String[]{});
            String line;
            Boolean comments = false;
            int cnt = 0;
            while (cnt<stringArray.length
                    && correctThreading) {
               line = stringArray[cnt];
               if (line.trim().startsWith("/*")) {
                  if (line.indexOf("*/") < 0) {
                     comments = true;
                  }
               } else if (line.trim().toUpperCase().startsWith("-- [THREAD PACKED COMPONENTS]")
                       || line.trim().toUpperCase().startsWith("-- [THREAD OUTLINED COMPONENTS]")) {
                  if (!comments) {
                     boolean first = true;
                     while (!line.toUpperCase().startsWith("-- [END THREAD]")
                             && correctThreading) {
                        if (first) {
                           first = false;
                        } else {
                           while (!line.toUpperCase().startsWith("-- [COMPONENT ")
                                   && !line.toUpperCase().startsWith("-- [END THREAD]")
                                   && correctThreading) {
                              cnt++;
                              if (cnt<stringArray.length) {
                                 line = stringArray[cnt];
                                 if (line.trim().startsWith("/*")) {
                                   while (line.indexOf("*/") < 0
                                        && correctThreading) {
                                      cnt++;
                                      if (cnt<stringArray.length) {
                                         line = stringArray[cnt];
                                      } else {
                                         correctThreading = false;
                                      }
                                    }
                                 }
                              } else {
                                 correctThreading = false;
                              }
                           }
                        }
                        if (line.toUpperCase().startsWith("-- [COMPONENT ")
                                && correctThreading) {
                           while (!line.toUpperCase().startsWith("-- [END COMPONENT")
                                   && correctThreading) {
                              cnt++;
                              if (cnt<stringArray.length) {
                                 line = stringArray[cnt];
                                 if (line.trim().startsWith("/*")) {
                                    while (line.indexOf("*/") < 0
                                            && correctThreading) {
                                       cnt++;
                                       if (cnt<stringArray.length) {
                                         line = stringArray[cnt];
                                       } else {
                                          correctThreading = false;
                                       }
                                    }
                                 } else if (line.toUpperCase().startsWith("-- [COMPONENT ")) {
                                    correctThreading = false;
                                 } else if (line.toUpperCase().startsWith("-- [END THREAD]")) {
                                    correctThreading = false;
                                 }
                              } else {
                                 correctThreading = false;
                              }
                           }
                        }
                     }
                  }
               } else if (line.trim().toUpperCase().startsWith("-- [THREAD SQL_COMMANDS]")) {
                  if (!comments) {
                     boolean first = true;
                     while (!line.toUpperCase().startsWith("-- [END THREAD]")
                             && correctThreading) {
                        if (first) {
                           first = false;
                        } else {
                           while (!line.toUpperCase().startsWith("-- [SQL_COMMAND")
                                   && !line.toUpperCase().startsWith("-- [END THREAD]")
                                   && correctThreading) {
                              cnt++;
                              if (cnt<stringArray.length) {
                                 line = stringArray[cnt];
                                 if (line.trim().startsWith("/*")) {
                                    while (line.indexOf("*/") < 0
                                            && correctThreading) {
                                       cnt++;
                                       if (cnt<stringArray.length) {
                                          line = stringArray[cnt];
                                       } else {
                                          correctThreading = false;
                                       }
                                    }
                                 }
                              } else {
                                 correctThreading = false;
                              }
                           }
                        }
                        if (line.toUpperCase().startsWith("-- [SQL_COMMAND")
                                && correctThreading) {
                           while (!line.toUpperCase().startsWith("-- [END SQL_COMMAND")
                                   && correctThreading) {
                              cnt++;
                              if (cnt<stringArray.length) {
                                 line = stringArray[cnt];
                                 if (line.trim().startsWith("/*")) {
                                    while (line.indexOf("*/") < 0
                                            && correctThreading) {
                                       cnt++;
                                       if (cnt<stringArray.length) {
                                          line = stringArray[cnt];
                                       } else {
                                          correctThreading = false;
                                       }
                                    }
                                 } else if (line.toUpperCase().startsWith("-- [SQL_COMMAND")) {
                                    correctThreading = false;
                                 } else if (line.toUpperCase().startsWith("-- [END THREAD]")) {
                                    correctThreading = false;
                                 }
                              } else {
                                 correctThreading = false;
                              }
                           }
                        }
                     }
                  }
               }
               if (comments) {
                  if (line.indexOf("*/") > -1) {
                     comments = false;
                  }
               }
               cnt++;
            }
         
      } catch (IOException ex) {
         logger.warning("!!! General read file error. Look for invalid, none UTF-8 characters in the file!");
         logger.warning(ex.getMessage());
         StringBuilder errorMsg = new StringBuilder();
         errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(lineSeparator);
         errorMsg.append("!!!General read file error. Look for invalid, none UTF-8 characters in the file! ").append(ex.getMessage());
         errorLogger.warning(errorMsg.toString());
         dbInstallerWatcher.addCompileErrorCounter();
      }
      return correctThreading;
   }

   /**
    * Method that reads a plsql file and executes the found commands
    * @param path File
    * @param temporaryPath File
    * @param fileName File
    * @param logFilePath String
    * @param logger Logger
    * @param errorLogger Logger
    * @param definesMap HashMap<String, String>
    * @param con Connection
    * @param userName String
    * @param passWord String
    * @param connectString String
    * @param defThreadingMethod String
    * @param dbInstallerWatcher DbInstallerWatcher
    * @param outputs boolean
    */
   @SuppressWarnings({"SleepWhileInLoop", "UnusedAssignment"})
   public void readFile(File path, File temporaryPath, File fileName, String logFilePath, String masterLogFilePath, Logger logger, Logger errorLogger, HashMap<String, String> definesMap, Connection con, String userName, String passWord, String connectString, String defThreadingMethod, DbInstallerWatcher dbInstallerWatcher, boolean outputs) throws DbBuildException {
      if (extLogging) {
         logger.setLevel(Level.FINE);
         outputs = true;
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
      } else {
         logger.setLevel(Level.INFO);
      }
      long startTime = System.currentTimeMillis();
      String threadingMethod = defThreadingMethod;
      File fullFileName = null;
      ThreadGroup moduleThreadGroup = mainThreadGroup;
      if (threadingMethod.startsWith("Y")
              && fileName.toString().toLowerCase().endsWith(".module")) {
         fullFileName = new File(temporaryPath.getAbsolutePath() + "/" + fileName.toString());
         moduleThreadGroup = new ThreadGroup(fileName.getName());
      } else {
         fullFileName = new File(path.getAbsolutePath() + "/" + fileName.toString());
      }
      File currentFileName = new File(fullFileName.getName());
      StringBuilder contents = new StringBuilder();
      StringBuilder generalBlock = new StringBuilder();
      FileHandler fHandler;
      if (fullFileName.exists()) {
         try {
            boolean temFile = currentFileName.toString().toLowerCase().endsWith(".tem") || currentFileName.toString().toLowerCase().endsWith("prepare.sql");
            boolean generatedFile = currentFileName.toString().toLowerCase().endsWith(".api") || currentFileName.toString().toLowerCase().endsWith(".apv")
                                 || currentFileName.toString().toLowerCase().endsWith(".apy")
                                 || currentFileName.toString().toLowerCase().endsWith(".svc") || currentFileName.toString().toLowerCase().endsWith(".cpi")
                                 || currentFileName.toString().toLowerCase().endsWith(".apn") || currentFileName.toString().toLowerCase().endsWith(".obd")
                                 || currentFileName.toString().toLowerCase().endsWith(".sch") || currentFileName.toString().toLowerCase().endsWith(".cre");
            logger.fine(new StringBuilder("Deploying ").append(currentFileName.toString()).toString());
            logger.fine("-------------------------------------------------------------");
            //use buffering, reading one line at a time
            if (threadingMethod.startsWith("Y")
                    && temFile) {
               if (!verifyThreading(fullFileName, logger, errorLogger, dbInstallerWatcher)) {
                  threadingMethod = "N";
                  logger.info("Turned off threading since the tags for setting up threading in the tem file is not correct");
               }
            }
            Path filePath = fullFileName.toPath();
            List<String> stringList = Files.readAllLines(filePath, StandardCharsets.UTF_8);
            String[] stringArray = stringList.toArray(new String[]{});
            exitFile = false;
            try {
               String subFolder = null;
               boolean masterTem = false;
			   String line = null;
               String spoolFile = null;
               boolean comments = false;
               boolean dbGeneralSession = false;
               int cnt = 0;
               while (cnt<stringArray.length) {
                  line = stringArray[cnt];
                  if (!exitFile) {
                     if (!comments) {
                        if (temFile) {
                           if (line.trim().toUpperCase().startsWith("-- [THREAD PACKED COMPONENTS]")) {
                              if (contents.length() > 0) {
                                 definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                 contents = contents.delete(0, contents.length());
                              }
                              if (threadingMethod.startsWith("Y") && !exitFile) {
                                 if (DbPrepareDeploy.loadDependenciesFromDb(con, logger, errorLogger, dbInstallerWatcher)) {
                                    threadingMethod = "YP";
                                    logger.info("Changed to packed component threading");
                                 } else {
                                    logger.info("Turned off threading since information about component dependencies could not be loaded");
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [THREAD OUTLINED COMPONENTS]")) {
                              if (contents.length() > 0) {
                                 definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                 contents = contents.delete(0, contents.length());
                              }
                              if (threadingMethod.startsWith("Y") && !exitFile) {
                                 if (DbPrepareDeploy.loadDependenciesFromDb(con, logger, errorLogger, dbInstallerWatcher)) {
                                    threadingMethod = "YO";
                                    logger.info("Changed to outlined component threading");
                                 } else {
                                    logger.info("Turned off threading since information about component dependencies could not be loaded");
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [THREAD SQL_COMMANDS]")) {
                              if (contents.length() > 0) {
                                 definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                 contents = contents.delete(0, contents.length());
                              }
                              if (threadingMethod.startsWith("Y") && !exitFile) {
                                 threadingMethod = "YSC";
                                 logger.info("Changed to SQL command threading");
                              }
                           }
                           if (("YO".equals(threadingMethod)
                                   || "YP".equals(threadingMethod))
                                   && line.toUpperCase().startsWith("-- [COMPONENT ")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    boolean first = true;
                                    while (!line.toUpperCase().startsWith("-- [END THREAD]")) {
                                       if (first) {
                                          first = false;
                                       } else {
                                          while (!line.toUpperCase().startsWith("-- [COMPONENT ")
                                                  && !line.toUpperCase().startsWith("-- [END THREAD]")) {
                                             cnt++;
                                             if (cnt<stringArray.length) {
                                                line = stringArray[cnt];
                                                if (line.trim().startsWith("/*")) {
                                                    while (line.indexOf("*/") < 0) {
                                                       cnt++;
                                                       if (cnt<stringArray.length) {
                                                          line = stringArray[cnt];
                                                       } else {
                                                          throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find EOF in a commented code block");
                                                       }
                                                    }
                                                }
                                             } else {
                                                throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find EOF when searching for next component or the [END THREAD] tag");                                                
                                             }
                                          }
                                       }
                                       if (line.toUpperCase().startsWith("-- [COMPONENT ")) {
                                          String nextFileName = (line.substring(13, line.length() - 1).toUpperCase()).trim();
                                          DbInstallerUtil.componentsMap.put(nextFileName, "New");
                                          StringBuilder codeBlock = new StringBuilder();
                                          while (!line.toUpperCase().startsWith("-- [END COMPONENT")) {
                                             cnt++;
                                             if (cnt<stringArray.length) {
                                                line = stringArray[cnt];
                                                if (line.trim().startsWith("/*")) {
                                                    while (line.indexOf("*/") < 0) {
                                                        cnt++;
                                                        if (cnt<stringArray.length) {
                                                           line = stringArray[cnt];
                                                        } else {
                                                           throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find EOF in a commented code block. Latest known component is " + nextFileName);
                                                        }
                                                    }
                                                } else if (line.toUpperCase().startsWith("-- [COMPONENT ")) {
                                                   throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find tag for next component when expecting tag [END COMPONENT]. Latest known component is " + nextFileName);
                                                } else if (line.toUpperCase().startsWith("-- [END THREAD]")) {
                                                   throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find tag [END THREAD] when expecting tag [END COMPONENT]. Latest known component is " + nextFileName);
                                                } else {
                                                   codeBlock.append(line);
                                                   codeBlock.append("\n");
                                                }
                                             } else {
                                                throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find EOF when searching for the [END COMPONENT] tag for component " + nextFileName);
                                             }
                                          }
                                            try (BufferedWriter output = new BufferedWriter(new FileWriter(temporaryPath.getAbsolutePath() + "/" + nextFileName + ".module"))) {
                                                output.write(codeBlock.toString());
                                            }
                                       }
                                    }
                                    for (Iterator components = DbInstallerUtil.componentsMap.keySet().iterator(); components.hasNext();) {
                                       String componentCandidate = components.next().toString().toUpperCase();
                                       if (!DbInstallerUtil.dependencyMap.containsKey(componentCandidate)) {
                                          logger.info(new StringBuilder("Unknown component: ").append(componentCandidate).append(". It will be installed after all known components are done").toString());
                                          DbInstallerUtil.dependencyMap.put(componentCandidate, "LAST.");
                                          DbInstallerUtil.componentsMap.put(componentCandidate, "Last");
                                       }
                                    }
                                    findNextComponent("NONE", path, temporaryPath, logFilePath, masterLogFilePath, logger, errorLogger, definesMap, userName, passWord, connectString, con, outputs, threadingMethod, dbInstallerWatcher, spoolFile);
                                    Boolean noneRun = true;
                                    while (DbInstallerUtil.isRunningThreads() || noneRun) {
                                       noneRun = false;
                                       logger.fine(new StringBuilder("Currently running threads: ").append(mainThreadGroup.activeCount()).toString());
                                       if (logger.getLevel() == Level.FINER
                                               || logger.getLevel() == Level.FINEST) {
                                          Thread[] threads = new Thread[mainThreadGroup.activeCount() + 5];
                                          mainThreadGroup.enumerate(threads);
                                          int maxThreads = mainThreadGroup.activeCount();
                                          for (int i = 0; i < maxThreads; i++) {
                                             logger.finer(new StringBuilder(" ").append(i + 1).append(" ").append(threads[i].getName()).toString());
                                          }
                                       }
                                       try {
                                          Thread.sleep(2000);
                                       } catch (Exception ex) {
                                          throw new DbBuildException("WARNING: Unexpected error: " + ex.getMessage(), ex);
                                       }
                                       String readyComponent = dbInstallerWatcher.removeThread();
                                       while (!"-1".equals(readyComponent)) {
                                          logger.info(new StringBuilder("[").append(DbInstallerUtil.getDbTimestamp(con)).append("] Component ").append(readyComponent).append(" is ready!").toString());
                                          findNextComponent(readyComponent, path, temporaryPath, logFilePath, masterLogFilePath, logger, errorLogger, definesMap, userName, passWord, connectString, con, outputs, threadingMethod, dbInstallerWatcher, spoolFile);
                                          readyComponent = dbInstallerWatcher.removeThread();
                                       }
                                    }
                                    for (Iterator components = DbInstallerUtil.componentsMap.keySet().iterator(); components.hasNext();) {
                                       String componentCandidate = components.next().toString().toUpperCase();
                                       if ("Last".equals(DbInstallerUtil.componentsMap.get(componentCandidate))) {
                                          DbInstallerUtil.componentsMap.put(componentCandidate, "New");
                                       } else if ("LastAlreadyExists".equals(DbInstallerUtil.componentsMap.get(componentCandidate))) {
                                          DbInstallerUtil.componentsMap.put(componentCandidate, "AlreadyExists");
                                       }
                                    }
                                    findNextComponent("LAST", path, temporaryPath, logFilePath, masterLogFilePath, logger, errorLogger, definesMap, userName, passWord, connectString, con, outputs, threadingMethod, dbInstallerWatcher, spoolFile);
                                    noneRun = true;
                                    while (DbInstallerUtil.isRunningThreads() || noneRun) {
                                       noneRun = false;
                                       logger.fine(new StringBuilder("Currently running threads: ").append(mainThreadGroup.activeCount()).toString());
                                       if (logger.getLevel() == Level.FINER
                                               || logger.getLevel() == Level.FINEST) {
                                          Thread[] threads = new Thread[mainThreadGroup.activeCount() + 5];
                                          mainThreadGroup.enumerate(threads);
                                          int maxThreads = mainThreadGroup.activeCount();
                                          for (int i = 0; i < maxThreads; i++) {
                                             logger.finer(new StringBuilder(" ").append(i + 1).append(" ").append(threads[i].getName()).toString());
                                          }
                                       }
                                       try {
                                          Thread.sleep(2000);
                                       } catch (Exception ex) {
                                          throw new DbBuildException("WARNING: Unexpected error: " + ex.getMessage(), ex);
                                       }
                                       String readyComponent = dbInstallerWatcher.removeThread();
                                       while (!"-1".equals(readyComponent)) {
                                          logger.info(new StringBuilder("[").append(DbInstallerUtil.getDbTimestamp(con)).append("] Component ").append(readyComponent).append(" is ready!").toString());
                                          findNextComponent(readyComponent, path, temporaryPath, logFilePath, masterLogFilePath, logger, errorLogger, definesMap, userName, passWord, connectString, con, outputs, threadingMethod, dbInstallerWatcher, spoolFile);
                                          readyComponent = dbInstallerWatcher.removeThread();
                                       }
                                    }
                                    HashMap<String, String> tempDependencyMap = new HashMap<>();
                                    tempDependencyMap.putAll(DbInstallerUtil.dependencyMap);
                                    for (Iterator components = tempDependencyMap.keySet().iterator(); components.hasNext();) {
                                       String componentCandidate = components.next().toString().toUpperCase();
                                       if ("LAST.".equals(tempDependencyMap.get(componentCandidate))) {
                                          DbInstallerUtil.dependencyMap.remove(componentCandidate);
                                          DbInstallerUtil.componentsMap.remove(componentCandidate);
                                       }
                                    }
                                    logger.info("[End of components]");
                                    threadingMethod = "Y";
                                 }
                              }
                           } else if (("YSC".equals(threadingMethod))
                                   && line.toUpperCase().startsWith("-- [SQL_COMMAND")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    for (Iterator components = DbInstallerUtil.componentsMap.keySet().iterator(); components.hasNext();) {
                                       DbInstallerUtil.componentsMap.put(components.next().toString().toUpperCase(), "Done");
                                    }
                                    boolean first = true;
                                    while (!line.toUpperCase().startsWith("-- [END THREAD]")) {
                                       if (first) {
                                          first = false;
                                       } else {
                                          while (!line.toUpperCase().startsWith("-- [SQL_COMMAND")
                                                  && !line.toUpperCase().startsWith("-- [END THREAD]")) {
                                             cnt++;
                                             if (cnt<stringArray.length) {
                                                line = stringArray[cnt];
                                                if (line.trim().startsWith("/*")) {
                                                    while (line.indexOf("*/") < 0) {
                                                        cnt++;
                                                        if (cnt<stringArray.length) {
                                                           line = stringArray[cnt];
                                                        } else {
                                                           throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find EOF in a commented code block");
                                                        }
                                                    }
                                                }
                                             } else {
                                                throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find EOF when searching for next SQL command or the [END THREAD] tag");
                                             }
                                          }
                                       }
                                       if (line.toUpperCase().startsWith("-- [SQL_COMMAND")) {
                                          String nextFileName = (line.substring(16, line.length() - 1).toUpperCase()).trim();
                                          DbInstallerUtil.componentsMap.put(nextFileName, "New");
                                          DbInstallerUtil.dependencyMap.put(nextFileName, "SQLCOMMAND.");
                                          StringBuilder codeBlock = new StringBuilder();
                                          while (!line.toUpperCase().startsWith("-- [END SQL_COMMAND")) {
                                             cnt++;
                                             if (cnt<stringArray.length) {
                                                line = stringArray[cnt];
                                                if (line.trim().startsWith("/*")) {
                                                    while (line.indexOf("*/") < 0) {
                                                        cnt++;
                                                        if (cnt<stringArray.length) {
                                                           line = stringArray[cnt];
                                                        } else {
                                                           throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find EOF in a commented code block. Latest known SQL command is " + nextFileName);
                                                        }
                                                    }
                                                } else if (line.toUpperCase().startsWith("-- [SQL_COMMAND")) {
                                                   throw new DbBuildException("TERROR:his file could not be used for threaded installation. Find tag for next SQL command when expecting tag [END SQL_COMMAND]. Latest known SQL command is " + nextFileName);
                                                } else if (line.toUpperCase().startsWith("-- [END THREAD]")) {
                                                   throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find tag [END THREAD] when expecting tag [END SQL_COMMAND]. Latest known SQL command is " + nextFileName);
                                                } else {
                                                   codeBlock.append(line);
                                                   codeBlock.append("\n");
                                                }
                                             } else {
                                                throw new DbBuildException("ERROR:This file could not be used for threaded installation. Find EOF when searching for the [END SQL_COMMAND] tag for command " + nextFileName);
                                             }
                                          }
                                            try (BufferedWriter output = new BufferedWriter(new FileWriter(temporaryPath.getAbsolutePath() + "/" + nextFileName + ".module"))) {
                                                output.write(codeBlock.toString());
                                            }
                                       }
                                    }
                                    findNextComponent("SQLCOMMAND", path, temporaryPath, logFilePath, masterLogFilePath, logger, errorLogger, definesMap, userName, passWord, connectString, con, outputs, threadingMethod, dbInstallerWatcher, spoolFile);
                                    while (DbInstallerUtil.isRunningThreads()) {
                                       logger.fine(new StringBuilder("Currently running threads: ").append(mainThreadGroup.activeCount()).toString());
                                       if (logger.getLevel() == Level.FINER
                                               || logger.getLevel() == Level.FINEST) {
                                          Thread[] threads = new Thread[mainThreadGroup.activeCount()];
                                          mainThreadGroup.enumerate(threads);
                                          int maxThreads = mainThreadGroup.activeCount();
                                          for (int i = 0; i < maxThreads; i++) {
                                             logger.finer(new StringBuilder(" ").append(i + 1).append(" ").append(threads[i].getName()).toString());
                                          }
                                       }
                                       try {
                                          Thread.sleep(2000);
                                       } catch (Exception ex) {
                                          throw new DbBuildException("WARNING: Unexpected error: " + ex.getMessage(), ex);
                                       }
                                       String readyComponent = dbInstallerWatcher.removeThread();
                                       while (!"-1".equals(readyComponent)) {
                                          logger.info(new StringBuilder("[").append(DbInstallerUtil.getDbTimestamp(con)).append("] SQL Command ").append(readyComponent).append(" is executed!").toString());
                                          DbInstallerUtil.componentsMap.remove(readyComponent);
                                          DbInstallerUtil.dependencyMap.remove(readyComponent);
                                          readyComponent = dbInstallerWatcher.removeThread();
                                       }
                                    }
                                    logger.info("[End of SQL Commands]");
                                    threadingMethod = "Y";
                                 }
                              }
                           } 
                           if (line.trim().toUpperCase().startsWith("-- [DB GENERAL]")
                                || line.trim().toUpperCase().startsWith("-- [END DB GENERAL]")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    if (line.trim().toUpperCase().startsWith("-- [DB GENERAL]")) {
                                       dbGeneralSession = true;
                                    } else if (line.trim().toUpperCase().startsWith("-- [END DB GENERAL]")
                                            && dbGeneralSession) {
                                       dbGeneralSession = false;
                                       String generalFileName = temporaryPath.getAbsolutePath() + "/" + "dbsession.general";
                                       try {
                                                    try (BufferedWriter output = new BufferedWriter(new FileWriter(generalFileName))) {
                                                        output.write(generalBlock.toString());
                                                    }
                                       } catch (IOException ex) {
                                          logger.warning("!!! General read file error. Look for invalid, none UTF-8 characters in the file!");
                                          logger.warning(ex.getMessage());
                                          StringBuilder errorMsg = new StringBuilder();
                                          errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(lineSeparator);
                                          errorMsg.append("!!!General read file error. Look for invalid, none UTF-8 characters in the file! ").append(ex.getMessage());
                                          errorLogger.warning(errorMsg.toString());
                                          dbInstallerWatcher.addCompileErrorCounter();
                                       }
                                       generalBlock = generalBlock.delete(0, generalBlock.length());
                                    }
                                 }
                              }
                           } 
                           if (line.trim().toUpperCase().startsWith("-- [DB FINAL]")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    try {
                                       cnt++;
                                       line = stringArray[cnt];
                                       StringBuilder finalBlock = new StringBuilder();
                                       while (!line.trim().toUpperCase().startsWith("-- [END DB FINAL]")) {
                                          line = line.replaceFirst("--", "");
                                          finalBlock.append(line);
                                          finalBlock.append("\n");
                                          cnt++;
                                          line = stringArray[cnt];
                                       }
                                       String finalFileName = masterLogFilePath + "/dbsession.final";
                                       try (BufferedWriter output = new BufferedWriter(new FileWriter(finalFileName))) {
                                          output.write(finalBlock.toString());
                                       }
                                    } catch (IOException ex) {
                                       logger.warning("!!! General read file error. Look for invalid, none UTF-8 characters in the file!");
                                       logger.warning(ex.getMessage());
                                       StringBuilder errorMsg = new StringBuilder();
                                       errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(lineSeparator);
                                       errorMsg.append("!!!General read file error. Look for invalid, none UTF-8 characters in the file! ").append(ex.getMessage());
                                       errorLogger.warning(errorMsg.toString());
                                       dbInstallerWatcher.addCompileErrorCounter();
                                    }
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [MASTER_TEM]")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    masterTem = true;
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [END MASTER_TEM]")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    masterTem = false;
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [FOLDER")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (masterTem) {
                                    subFolder = line.trim().substring(10).trim().replace("]", "");
                                 } else {
                                    subFolder = null;
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [END FOLDER]")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 File dbGeneralFileName = new File(temporaryPath.getAbsolutePath() + "/" + subFolder + "/dbsession.general");
                                 dbGeneralFileName.delete();
                                 subFolder = null;
                                 DbInstallerUtil.askQuestionsMultiRun = false;
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [NO DEPLOY LOGGING")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    Handler[] dHandlers = logger.getHandlers();
                                    for (int i = 0; i < dHandlers.length; i++) {
                                       if (dHandlers[i].getFilter() instanceof DeployLogFilter) {
                                          logger.removeHandler(dHandlers[i]);
                                          dHandlers[i].close();
                                       }
                                    }
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [END NO DEPLOY LOGGING")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    boolean deployLogOff = true;
                                    Handler[] dHandlers = logger.getHandlers();
                                    for (int i = 0; i < dHandlers.length; i++) {
                                       if (dHandlers[i].getFilter() instanceof DeployLogFilter) {
                                          deployLogOff = false;
                                       }
                                    }
                                    if (deployLogOff) {
                                       FileHandler deployLogHandler;
                                       try {
                                          deployLogHandler = new FileHandler(masterLogFilePath + "_deploy.log", true);
                                          deployLogHandler.setFormatter(new ThreadFormatter());
                                          deployLogHandler.setFilter(new DeployLogFilter());
                                          logger.addHandler(deployLogHandler);
                                       } catch (IOException ex) {
                                          logger.warning("!!!Error setting up log file");
                                          logger.warning(ex.getMessage());
                                          throw new DbBuildException("WARNING: Error setting up log file " + ex.getMessage(), ex);
                                       }
                                    }
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [NO EXTENDED LOGGING")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    logger.setLevel(Level.INFO);
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [END NO EXTENDED LOGGING")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
//                                    if (extendedLogging) {
                                    if (extLogging) {                                       
                                       logger.setLevel(Level.FINE);
                                       outputs = true;
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
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("-- [IGNORE IN MULTI INSTALL]")
                           && DbInstallerUtil.multiRun) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    while (!line.trim().toUpperCase().startsWith("-- [END IGNORE IN MULTI INSTALL]") && cnt<stringArray.length) {
                                       cnt++;
                                       if (cnt<stringArray.length) {
                                         line = stringArray[cnt];
                                       }
                                    }
                                 }
                              }
                           }
                           if (line.trim().toUpperCase().startsWith("EXECUTE IMMEDIATE 'BEGIN INSTALL_TEM_SYS.SET_MULTI_INSTALLATION_MODE(TRUE)")) {
                              DbInstallerUtil.multiRun = true;
                           }
                           if (line.trim().toUpperCase().startsWith("EXECUTE IMMEDIATE 'BEGIN INSTALL_TEM_SYS.SET_MULTI_INSTALLATION_MODE(FALSE)")) {
                              DbInstallerUtil.multiRun = false;
                           }
                           if (line.trim().toUpperCase().startsWith("-- [IFS INSTALLER LOOP")) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    if (!performIfsInstallerLoop(con, line, logger, errorLogger, dbInstallerWatcher, currentFileName.toString(), definesMap)) {
                                       throw new DbBuildException("ERROR:Process aborted by user");
                                    }
                                 }
                              }
                           }
                           if (dbGeneralSession == true && comments == false) {
                              if (!line.trim().toUpperCase().startsWith("-- [END DB GENERAL]")) {
                                 generalBlock.append(line);
                                 generalBlock.append("\n");
                              }
                           }
                        }
                        if (line.trim().toUpperCase().startsWith("-- [IFS COMPLETE BLOCK")) {
                          if (!comments && !dbGeneralSession) {
                              if (contents.length() > 0) {
                                 definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                 contents = contents.delete(0, contents.length());
                              }
                              String[] lineItems = line.trim().split(" ");
                              PlsqlExecutableObjectType type = PlsqlExecutableObjectType.UNKNOWN;
                              String name = "";
                              if (lineItems.length>4) {
                                 String strType = lineItems[4];
                                 if (strType.equals("PACKAGE")) {
                                    if (lineItems.length>5) {
                                       type = PlsqlExecutableObjectType.PACKAGE;
                                       name = lineItems[5].replace("]", "");
                                    }
                                 } else if (strType.equals("PACKAGEBODY")) {
                                    if (lineItems.length>5) {
                                       type = PlsqlExecutableObjectType.PACKAGEBODY;
                                       name = lineItems[5].replace("]", "");
                                    }
                                 } else if (strType.equals("PROCEDURE")) {
                                    if (lineItems.length>5) {
                                       type = PlsqlExecutableObjectType.PROCEDURE;
                                       name = lineItems[5].replace("]", "");
                                    }
                                 } else if (strType.equals("FUNCTION")) {
                                    if (lineItems.length>5) {
                                       type = PlsqlExecutableObjectType.FUNCTION;
                                       name = lineItems[5].replace("]", "");
                                    }
                                 } else if (strType.equals("VIEW")) {
                                    if (lineItems.length>5) {
                                       type = PlsqlExecutableObjectType.VIEW;
                                       name = lineItems[5].replace("]", "");
                                    }
                                 } else if (strType.startsWith("DECLAREEND")) {
                                    type = PlsqlExecutableObjectType.DECLAREEND;
                                 } else if  (strType.startsWith("BEGINEND")) {
                                    type = PlsqlExecutableObjectType.BEGINEND;
                                 }
                                 if (type != PlsqlExecutableObjectType.UNKNOWN) {
                                    if (!exitFile) {
                                       cnt++;
                                       if (cnt<stringArray.length) {
                                         line = stringArray[cnt];
                                       }
                                       while (!line.trim().toUpperCase().startsWith("-- [END IFS COMPLETE BLOCK") && cnt<stringArray.length) {
                                          contents.append(line);
                                          contents.append("\n");
                                          cnt++;
                                          if (cnt<stringArray.length) {
                                            line = stringArray[cnt];
                                          }
                                       }
                                       if (strType.equals("VIEW")) {
                                          definesMap = executeSingleBlock(name, type, contents.toString().substring(0, contents.toString().lastIndexOf(";")), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                       } else {
                                          definesMap = executeSingleBlock(name, type, contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                       }
                                       contents = contents.delete(0, contents.length());
                                    }
                                 }
                              }
                           }
                        } else if ((line.trim().toUpperCase().startsWith("START "))
                                || (line.trim().startsWith("@@"))
                                || (line.trim().startsWith("@"))) {
                           if (!comments) {
                              if (line.indexOf("%log_path%/") > 0) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                              }
                              String nextFileName = null;
                              File nextPath = null;
                              if ("ON".equalsIgnoreCase(definesMap.get("DEFINE"))) {
                                 line = replaceAliases(line, definesMap.get("DEFINECHARACTER").charAt(0), definesMap);
                              }
                              if (line.trim().toUpperCase().startsWith("START ")) {
                                 nextFileName = line.trim().substring(5).trim().replace("\"", "");
                                 if (nextFileName.length() > 2) {
                                    if (nextFileName.startsWith("%log_path%/")) {
                                        nextFileName = nextFileName.replace("%log_path%", temporaryPath.getAbsolutePath());
                                        nextPath = new File(nextFileName.substring(0, nextFileName.lastIndexOf("/")).trim()).getAbsoluteFile();
                                        nextFileName = nextFileName.substring(nextFileName.lastIndexOf("/") + 1).trim();
                                    } else {
                                       if (nextFileName.startsWith("\\\\")
                                               || (":".equals(nextFileName.substring(1, 2))
                                               && nextFileName.substring(0, 1).matches("[a-zA-Z]"))) {
                                          nextPath = new File(nextFileName.substring(0, nextFileName.replace("\\", "/").lastIndexOf("/")).trim()).getAbsoluteFile();
                                          nextFileName = nextFileName.substring(nextFileName.replace("\\", "/").lastIndexOf("/") + 1).trim();
                                       } else {
                                          if (subFolder == null) {
                                             nextPath = path.getAbsoluteFile();
                                          } else {
                                             nextPath = new File (path.getAbsoluteFile().getAbsolutePath() + "/" + subFolder);
                                          }
                                       }
                                    }
                                 } else {
                                    nextPath = path.getAbsoluteFile();
                                 }
                              } else if (line.trim().startsWith("@@")) {
                                 nextFileName = line.trim().substring(2).trim().replace("\"", "");
                                 if (nextFileName.length() > 2) {
                                    if (nextFileName.startsWith("%log_path%/")) {
                                        nextFileName = nextFileName.replace("%log_path%", temporaryPath.getAbsolutePath());
                                        nextPath = new File(nextFileName.substring(0, nextFileName.lastIndexOf("/")).trim()).getAbsoluteFile();
                                        nextFileName = nextFileName.substring(nextFileName.lastIndexOf("/") + 1).trim();
                                    } else {
                                       if (nextFileName.startsWith("\\\\")
                                               || (":".equals(nextFileName.substring(1, 2))
                                               && nextFileName.substring(0, 1).matches("[a-zA-Z]"))) {
                                          nextPath = new File(nextFileName.substring(0, nextFileName.replace("\\", "/").lastIndexOf("/")).trim()).getAbsoluteFile();
                                          nextFileName = nextFileName.substring(nextFileName.replace("\\", "/").lastIndexOf("/") + 1).trim();
                                       } else {
                                          nextPath = new File(fullFileName.getParent());
                                       }
                                    }
                                 } else {
                                    nextPath = new File(fullFileName.getParent());
                                 }
                              } else if (line.trim().startsWith("@")) {
                                 nextFileName = line.trim().substring(1).trim().replace("\"", "");
                                 if (nextFileName.length() > 2) {
                                    if (nextFileName.startsWith("%log_path%/")) {
                                        nextFileName = nextFileName.replace("%log_path%", temporaryPath.getAbsolutePath());
                                        nextPath = new File(nextFileName.substring(0, nextFileName.lastIndexOf("/")).trim()).getAbsoluteFile();
                                        nextFileName = nextFileName.substring(nextFileName.lastIndexOf("/") + 1).trim();
                                    } else {
                                       if (nextFileName.startsWith("\\\\")
                                               || (":".equals(nextFileName.substring(1, 2))
                                               && nextFileName.substring(0, 1).matches("[a-zA-Z]"))) {
                                          nextPath = new File(nextFileName.substring(0, nextFileName.replace("\\", "/").lastIndexOf("/")).trim()).getAbsoluteFile();
                                          nextFileName = nextFileName.substring(nextFileName.replace("\\", "/").lastIndexOf("/") + 1).trim();
                                       } else {
                                          nextPath = path.getAbsoluteFile();
                                       }
                                    }
                                 } else {
                                    nextPath = path.getAbsoluteFile();
                                 }
                              }
                              if ("ON".equalsIgnoreCase(definesMap.get("DEFINE"))) {
                                 nextFileName = replaceAliases(nextFileName, definesMap.get("DEFINECHARACTER").charAt(0), definesMap);
                              }
                              if ((nextFileName.length() > 0)
                                      && (new File(nextPath.getAbsolutePath() + "/" + nextFileName).exists())) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    if ("YP".equals(threadingMethod)
                                            && currentFileName.toString().toLowerCase().endsWith(".module")
                                            && nextFileName.toLowerCase().endsWith(".ins")) {
                                       while (dbInstallerWatcher.getThreadCounterAll() - dbInstallerWatcher.getThreadCounterInternal() >= DbInstallerUtil.defaultMaxThreads) {
                                          logger.fine(new StringBuilder("Too many open threads: ").append(dbInstallerWatcher.getThreadCounterAll()).toString());
                                          try {
                                             Thread.sleep(2000);
                                          } catch (Exception ex) {
                                             throw new DbBuildException("WARNING: Unexpected error: " + ex.getMessage(), ex);
                                          }
                                       }
                                       if (!Thread.currentThread().isInterrupted()) {
                                          String logText = new StringBuilder("Start deploying file ").append(nextFileName).append(" in a new thread").toString();
                                          logger.info(logText);
                                          HashMap<String, String> tempDefinesMap = new HashMap<>();
                                          tempDefinesMap.putAll(definesMap);
                                          if (con != null) {
                                             try {
                                                if (!con.isClosed()) {
                                                   con.commit();
                                                }
                                             } catch (SQLException ex) {
                                             }
                                          }
                                          String componentName = moduleThreadGroup.getName().toUpperCase();
                                          if (componentName.contains(".")) {
                                             componentName = componentName.substring(0, componentName.indexOf('.'));
                                          }
                                          if (DbInstallerUtil.componentsMap.containsKey(componentName)) {
                                             DbInstallerUtil.componentsMap.put(componentName, "PreIns");
                                          }
                                          dbInstallerWatcher.addToThreadCounterAll();
                                          dbInstallerWatcher.addToThreadCounterInternal();
                                          ReadFileThread fileThread = new ReadFileThread(moduleThreadGroup, nextFileName, nextPath, temporaryPath, new File(nextFileName), logFilePath, masterLogFilePath, errorLogger, tempDefinesMap, userName, passWord, connectString, threadingMethod, outputs, extLogging, dbInstallerWatcher, spoolFile);
                                          fileThread.start();
                                       }
                                    } else {
                                       if (nextFileName.toLowerCase().endsWith(".tem")) {
                                          logger.info(new StringBuilder("Start deploying file ").append(nextFileName).toString());
                                       }
                                       if ((currentFileName.toString().toLowerCase().endsWith(".module"))
                                               || (temFile
                                               && !nextFileName.toLowerCase().endsWith(".tem"))) {
                                       }
                                       if (subFolder == null) {
                                          readFile(nextPath, temporaryPath, new File(nextFileName), logFilePath, masterLogFilePath, logger, errorLogger, definesMap, con, userName, passWord, connectString, threadingMethod, dbInstallerWatcher, outputs);
                                       } else {
                                          File newTemporaryPath = new File (temporaryPath.getAbsolutePath() + "/" + subFolder);
                                          File logDir = new File(logFilePath+subFolder+"/");
                                          if (!logDir.exists()) {
                                             if (!logDir.isDirectory()) {
                                                try {
                                                   logDir.mkdirs();
                                                } catch (SecurityException ex) {
                                                   throw new DbBuildException("WARNING: Could not create folder for log files due to security restrictions " + ex.getMessage(), ex);
                                                }
                                             } else {
                                                throw new DbBuildException("WARNING: Could not create folder for log files");
                                             }
                                          }
                                          readFile(nextPath, newTemporaryPath, new File(nextFileName), logFilePath+subFolder+"/", masterLogFilePath, logger, errorLogger, definesMap, con, userName, passWord, connectString, threadingMethod, dbInstallerWatcher, outputs);
                                       }
                                    }
                                 }
                              } else {
                                 contents.append(line);
                                 contents.append("\n");
                              }
                           }
                        } else if (line.trim().toUpperCase().startsWith("SET SERVEROUT")) {
                           if (!comments) {
                              if (contents.length() > 0) {
                                 definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                 contents = contents.delete(0, contents.length());
                              }
                              if (!exitFile) {
                                 if (line.trim().toUpperCase().endsWith("OFF")) {
                                    if (!extLogging) {                                       
                                       outputs = false;
                                       try {
                                          Statement stm;
                                          stm = con.createStatement();
                                          stm.setEscapeProcessing(false);
                                          stm.execute("BEGIN Dbms_Output.Disable; END;");
                                          stm.close();
                                       } catch (SQLException sqlEx) {
                                          String msg = sqlEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                                          logger.warning(new StringBuilder(lineSeparator).append("!!!Error turning off DbmsOutput").append(lineSeparator).append(msg).append(lineSeparator).toString());
                                          String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                                          StringBuilder errorMsg = new StringBuilder(lineSeparator);
                                          errorMsg.append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                                          errorMsg.append("!!!Error turning off DbmsOutput").append(lineSeparator).append(msg);
                                          errorLogger.warning(errorMsg.toString());
                                          dbInstallerWatcher.addCompileErrorCounter();
                                       }
                                    }
                                 } else {
                                    if (!outputs) { // first empty any previous buffer
                                       String text = "BEGIN DBMS_OUTPUT.GET_LINE(?, ?); END;";
                                       CallableStatement stmt;
                                       stmt = null;
                                       try {
                                           if (!con.isClosed()) {
                                               stmt = con.prepareCall(text);
                                               stmt.registerOutParameter(1, java.sql.Types.VARCHAR);
                                               stmt.registerOutParameter(2, java.sql.Types.NUMERIC);
                                               int status = 0;
                                               while (status == 0) {
                                                   stmt.execute();
                                                   status = stmt.getInt(2);
                                               }
                                           }
                                       } catch (SQLException e) {
                                           logger.warning("!!!Error while clear dbms_output buffer:");
                                           logger.warning(e.toString());
                                           StringBuilder errorMsg = new StringBuilder();
                                           String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                                           errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                                           errorMsg.append("!!!Error while clear dbms_output buffer:").append(lineSeparator).append(e.toString()).append(lineSeparator);
                                           errorMsg.append(e.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                                           errorLogger.warning(errorMsg.toString());
                                           dbInstallerWatcher.addCompileErrorCounter();
                                       } finally {
                                          try {
                                             if (stmt!=null) {
                                                 stmt.close();
                                             }
                                          } catch (SQLException e) {
                                          }
                                       }
                                    }
                                    outputs = true;
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
                              }
                           }
                        } else if (!generatedFile) {
                           if ((line.trim().toUpperCase().startsWith("SPOOL "))
                                && !(line.trim().endsWith(";") || line.trim().endsWith(","))) {
                              if (!comments) {
                                 contents.append(line);
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    spoolFile = replaceAliases(line.trim().substring(6).trim(), definesMap.get("DEFINECHARACTER").charAt(0), definesMap);
                                    if ("OFF".equalsIgnoreCase(spoolFile.trim())) {
                                       Handler[] handlers = logger.getHandlers();
                                       for (int i = 0; i < handlers.length; i++) {
                                          if (handlers[i].getFilter() instanceof SpoolFileFilter) {
                                             logger.removeHandler(handlers[i]);
                                             handlers[i].close();
                                          }
                                       }
                                    } else {
                                       // If a previous log exists, close it.
                                       Handler[] handlers = logger.getHandlers();
                                       for (int i = 0; i < handlers.length; i++) {
                                          if (handlers[i].getFilter() instanceof SpoolFileFilter) {
                                             logger.removeHandler(handlers[i]);
                                             handlers[i].close();
                                          }
                                       }
                                       boolean append = false;
                                       if (spoolFile.toUpperCase().endsWith(" APP")
                                               || spoolFile.toUpperCase().endsWith(" APPE")
                                               || spoolFile.toUpperCase().endsWith(" APPEN")
                                               || spoolFile.toUpperCase().endsWith(" APPEND")) {
                                          append = true;
                                          spoolFile = spoolFile.substring(0, spoolFile.indexOf(' '));
                                       }
                                       fHandler = new FileHandler(logFilePath + spoolFile, append);
                                       fHandler.setFormatter(new ThreadFormatter());
                                       fHandler.setFilter(new SpoolFileFilter());
                                       logger.addHandler(fHandler);
                                    }
                                 }
                              }
                           } else if ((line.trim().toUpperCase().startsWith("ACCEPT "))
                                   && !(line.trim().endsWith(";") || line.trim().endsWith(","))) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!exitFile) {
                                    contents.append(line);
                                    contents.append("\n");
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                              }
                           } else if (line.trim().toUpperCase().startsWith("EXEC INSTALLATION_SYS.CREATE_AND_SET_VERSION")
                                   && fileName.toString().toLowerCase().endsWith(".module")
                                   && "YP".equals(threadingMethod)) {
                              if (!comments) {
                                 if (contents.length() > 0) {
                                    definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                                    contents = contents.delete(0, contents.length());
                                 }
                                 if (!Thread.currentThread().isInterrupted()) {
                                    HashMap<String, String> tempDefinesMap = new HashMap<>();
                                    tempDefinesMap.putAll(definesMap);
                                    if (con != null) {
                                       try {
                                          if (!con.isClosed()) {
                                             con.commit();
                                          }
                                       } catch (SQLException ex) {
                                       }
                                    }
                                    dbInstallerWatcher.addToThreadCounterAll();
                                    dbInstallerWatcher.addToThreadCounterInternal();
                                    DbInstallerUtil.componentsMap.put(moduleThreadGroup.getName().substring(0, moduleThreadGroup.getName().indexOf('.')).toLowerCase()+"Finalize", "Finalize");
                                    FinalizeComponent finalizeComponent = new FinalizeComponent(moduleThreadGroup, moduleThreadGroup.getName(), line, userName, passWord, connectString, moduleThreadGroup.getName(), errorLogger, tempDefinesMap, outputs, extLogging, dbInstallerWatcher, logFilePath, masterLogFilePath, spoolFile, temporaryPath, threadingMethod);
                                    finalizeComponent.start();
                                 }
                              }
                           } else {
                              contents.append(line);
                              contents.append("\n");
                              if (line.trim().startsWith("/*")) {
                                 if (line.indexOf("*/") < 0) {
                                    comments = true;
                                 }
                              }
                           }
                        } else {
                           contents.append(line);
                           contents.append("\n");
                           if (line.trim().startsWith("/*")) {
                              if (line.indexOf("*/") < 0) {
                                 comments = true;
                              }
                           }
                        }
                     } else {
                        contents.append(line);
                        contents.append("\n");
                        if (line.indexOf("*/") > -1) {
                           comments = false;
                        }
                     }
                  }
                  cnt++;
               }
               if (exitFile) {
                  Handler[] handlers = logger.getHandlers();
                  for (int i = 0; i < handlers.length; i++) {
                     if (handlers[i].getFilter() instanceof SpoolFileFilter) {
                        logger.removeHandler(handlers[i]);
                        handlers[i].close();
                     }
                  }
               } else {
                  if (contents.length() > 0) {
                     definesMap = executeBlock(contents.toString(), logger, errorLogger, definesMap, con, dbInstallerWatcher, outputs, fileName.toString());
                  }
               }
               if (con != null) {
                  try {
                     if (!con.isClosed()) {
                        con.commit();
                     }
                  } catch (SQLException ex) {
                  }
               }
            } finally {
               if (fullFileName.toString().toLowerCase().endsWith(".module")) {
                  fullFileName.delete();
                  String componentName = fullFileName.getName();
                  componentName = componentName.substring(0, componentName.indexOf('.')).toUpperCase();
                  if (!DbInstallerUtil.componentsMap.get(componentName).equals("Ins")) {
                     if (DbInstallerUtil.componentsMap.get(componentName).equals("PreIns")) {
                        DbInstallerUtil.componentsMap.put(componentName, "Ins");
                     } else {
                        DbInstallerUtil.componentsMap.put(componentName, "Done");
                     }
                  }
                  dbInstallerWatcher.completeThread(componentName);
               }
            }
            long endTime = System.currentTimeMillis();
            long duration = endTime - startTime;
            String totalTime = Long.toString(duration / 1000);
            if (duration < 10000) {
               totalTime += "." + Long.toString((duration % 1000) / 100);
            }
            logger.info(new StringBuilder("Done deploying ").append(currentFileName.toString()).append(" at ").append(new Timestamp(endTime).toString()).append(" (Total time: ").append(totalTime).append("s)").toString());
         } catch (IOException ex) {
            logger.warning("!!! General read file error. Look for invalid, none UTF-8 characters in the file!");
            logger.warning(ex.getMessage());
            StringBuilder errorMsg = new StringBuilder();
            errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName.toString()).append(lineSeparator);
            errorMsg.append("!!!General read file error. Look for invalid, none UTF-8 characters in the file! ").append(ex.getMessage());
            errorLogger.warning(errorMsg.toString());
            dbInstallerWatcher.addCompileErrorCounter();
         }
      } else {
         String logText = new StringBuilder(lineSeparator).append("!!!Could not find file ").append(fileName.toString()).toString();
         logger.warning(logText);
         errorLogger.warning(logText);
         dbInstallerWatcher.addCompileErrorCounter();
      }
   }

   /**
    * Method for deploying a database installation file
    * @param fullFileName String
    * @param temporaryFilePath String
    * @param userName String
    * @param passWord String
    * @param connectString String
    * @param logFilePath String
    * @param threadingMethod String
    * @param silentWaitingTime long
    * @param con Connection
    */
   @SuppressWarnings("SleepWhileInLoop")
   public void doRun(String fullFileName, String temporaryFilePath, String userName, String passWord, String connectString, String logFilePath, String threadingMethod, long silentWaitingTime, Connection con, String initialPasswords) throws DbBuildException {   
      boolean interrupted = true;
      String fileNameStr = new File(fullFileName).getName();
      mainThreadGroup = new ThreadGroup("db-deploy");
      if (logFilePath != null) {
         if (!(logFilePath.endsWith("/") || logFilePath.endsWith("\\"))) {
            logFilePath = logFilePath + "/";
         }
      }
      File logDir = new File(logFilePath);
      if (!logDir.exists()) {
         if (!logDir.isDirectory()) {
            try {
               logDir.mkdirs();
            } catch (SecurityException ex) {
               throw new DbBuildException("WARNING: Could not create folder for log files due to security restrictions " + ex.getMessage(), ex);
            }
         } else {
            throw new DbBuildException("WARNING: Could not create folder for log files");            
         }
      }
      Logger logger = Logger.getLogger("plsqlfilereader.main");
      logger.setUseParentHandlers(false);
      FileHandler deployLogHandler;
      try {
         deployLogHandler = new FileHandler(logFilePath + "_deploy.log");
         deployLogHandler.setFormatter(new ThreadFormatter());
         deployLogHandler.setFilter(new DeployLogFilter());
         logger.addHandler(deployLogHandler);
      } catch (IOException ex) {
         logger.warning("!!!Error setting up log file");
         logger.warning(ex.getMessage());
         throw new DbBuildException("WARNING: Error setting up log file " + ex.getMessage(), ex);
      }

      Logger errorLogger = Logger.getLogger("plsqlfilereadererror.main");
      errorLogger.setUseParentHandlers(false);
      errorLogger.setLevel(Level.INFO);
      FileHandler errorHandler;
      try {
         String errorFileName;
         if (fileNameStr.contains(".")) {
            errorFileName = fileNameStr.replace("/", "_").replace("\\", "_").substring(0, fileNameStr.indexOf('.')) + ".log";
         } else {
            errorFileName = fileNameStr.replace("/", "_").replace("\\", "_") + ".log";
         }
         errorHandler = new FileHandler(logFilePath + "_ERROR_" + errorFileName);
         errorHandler.setFormatter(new ThreadFormatter());
         errorLogger.addHandler(errorHandler);
      } catch (IOException ex) {
         logger.warning("!!!Error setting up error log file");
         logger.warning(ex.getMessage());
         throw new DbBuildException("WARNING: Error setting up error log file " + ex.getMessage(), ex);
      }
      DbInstallerWatcher dbInstallerWatcher = new DbInstallerWatcher(con);
      DbInstallerUtil.silentWaitingTime = silentWaitingTime;
      dbInstallerWatcher.resetThreadCounters();
      HashMap<String, String> definesMap = new HashMap<>();
      definesMap.put("DEFINECHARACTER", "&");
      definesMap.put("DEFINE", "ON");
      if (initialPasswords.length() > 0) {
         if (initialPasswords.contains(";")) {
            String[] initalPasswordArr = initialPasswords.split(";");
            for (int i = 0; i < initalPasswordArr.length; i++) {
               if (initalPasswordArr[i].contains("=")) {
                  String initalUser = initalPasswordArr[i].substring(0, initalPasswordArr[i].indexOf("="));
                  String initalPassword = initalPasswordArr[i].substring(initalPasswordArr[i].indexOf("=")+1);
                  DbInstallerUtil.passwordsMap.put(initalUser.toUpperCase()+"_PASSWORD", initalPassword);
               }
            }
         }
      }
      File path = new File(fullFileName).getParentFile();
      File temporaryPath = new File(temporaryFilePath);
      File fileName = new File(fileNameStr);

      try {
         try {
            con.setAutoCommit(false);
         } catch (SQLException ex) {
            logger.warning("!!!Error while configurating DB connection");
            logger.warning(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
            StringBuilder errorMsg = new StringBuilder();
            errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fullFileName).append(lineSeparator);
            errorMsg.append("!!!Error while configurating DB connection").append(ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
            errorLogger.warning(errorMsg.toString());
         }

         StringBuilder logText = new StringBuilder(lineSeparator).append("Selected database...........: ").append(userName).append("@").append(connectString).append(lineSeparator);
         logText.append("Selected sourcefile.........: ").append(fullFileName).append(lineSeparator);
         logger.info(logText.toString());

         logger.info(new StringBuilder(lineSeparator).append("Start deploying ").append(fileNameStr).append(lineSeparator).toString());
         readFile(path, temporaryPath, fileName, logFilePath, logFilePath, logger, errorLogger, definesMap, con, userName, passWord, connectString, threadingMethod, dbInstallerWatcher, false);
         
         interrupted = false;

         File dbGeneralFileName = new File(temporaryPath.getAbsolutePath() + "/dbsession.general");
         dbGeneralFileName.delete();

         int countedErrors = dbInstallerWatcher.getCompileErrorCounter();
         logger.info(new StringBuilder(lineSeparator).append("Done deploying ").append(fileNameStr).toString());
         if (countedErrors > 0) {
            String errorText;
            if (countedErrors > 1) {
               errorText = countedErrors + " errors were detected during deployment of DB objects";
            } else {
               errorText = countedErrors + " error was detected during deployment of DB objects";
            }
            logger.info(new StringBuilder(lineSeparator).append(errorText).toString());
            throw new DbBuildException("WARNING: DB: " + errorText);
         } else {
            logger.info(new StringBuilder(lineSeparator).append("No errors detected").toString());
         }
      } finally {
         //mainThreadGroup.interrupt();
         // commented since a new Oracle driver immediatelly kills the Oracle connection. We let the thread complete themselves instead.
         if (interrupted) {
            for (Iterator components = DbInstallerUtil.componentsMap.keySet().iterator(); components.hasNext();) {
               String componentCandidate = components.next().toString().toUpperCase();
               String componentState = DbInstallerUtil.componentsMap.get(componentCandidate);
               if ("AlreadyExists".equals(componentState)
               ||  "Last".equals(componentState)
               ||  "New".equals(componentState)) {
                  DbInstallerUtil.componentsMap.put(componentCandidate, "Done");
               } else {
                  logger.fine(new StringBuilder("Abort! Waiting for ").append(componentCandidate).append(" with state ").append(componentState).append(" to stop").toString());
               }
            }
            while (DbInstallerUtil.isRunningThreads()) {
               logger.fine(new StringBuilder("Abort! Waiting for ").append(mainThreadGroup.activeCount()).append(" running threads to stop").toString());
               try {
                  Thread.sleep(2000);
               } catch (Exception ex) {
               }
            }
         }
            
         PlsqlFileReader p = new PlsqlFileReader(extLogging);         
         if (new File(logFilePath + "/dbsession.final").exists()) {
             p.readFile(temporaryPath, temporaryPath, new File("dbsession.final"), logFilePath, logFilePath, logger, errorLogger, definesMap, con, userName, passWord, connectString, threadingMethod, dbInstallerWatcher, false);
             File dbFinalFileName = new File(logFilePath + "/dbsession.final");
             dbFinalFileName.delete();
         }
         try {
            con.close();
         } catch (SQLException se) {
            throw new DbBuildException("ERROR:Error closing database. " + se.getMessage());
         }
         Handler[] errorHandlers = errorLogger.getHandlers();
         for (int i = 0; i < errorHandlers.length; i++) {
            errorLogger.removeHandler(errorHandlers[i]);
            errorHandlers[i].close();
         }
         Handler[] handlers = logger.getHandlers();
         for (int i = 0; i < handlers.length; i++) {
            logger.removeHandler(handlers[i]);
            handlers[i].close();
         }
      }
   }
}
