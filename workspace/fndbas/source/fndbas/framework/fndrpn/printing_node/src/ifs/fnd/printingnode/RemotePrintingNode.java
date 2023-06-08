/*
 * RemotePrintingNode.java
 *
 * Modified:
 *    dozese  2004-Nov-02 - Created
 *    madrse  2008-Feb-14 - Rewritten to use java access provider
 *    dasvse  2010-Apr-15 - SSO Fix
 *    madilk  2010-Oct-21 - 93483 - Print Agent ignores the selection of pages to print as set in the Print Report dialog
 *    NaBaLK  2012-09-14  - Corrections to support individual settings from Print Dialog (Bug#104774)
 *    Chaalk  2012-11-30  - 107078 - Print Agent doesn't work with SSO for Apps 8. Changed fndext to fndint
 *    LiRiSE  2013-03-08  - Added support for a printing parameters configuration file.
 *    NaBaLK  2014-05-08  - Initialized the Logger again for shutdown (TEREPORT-1204)
 *    MaBaLK  2015-02-16  - Print Agent crashes when started before Extended Server is available (Bug#121083)
 *    Asiwlk  2017-04-21  - Print Agent shows errors in log when MWS maintenance mode is enabled.
 *    CHAALK  2017-Jul-06 - Remove jdom and use org.w3c.dom conversion
 *    CHAALK  2018-Feb-18 - Handled OutOfMemoryError:Java heap space (Jira TEREPORT-2848)
 *    DDESLK  2019-Feb-07 - IFS Print Agent java multithreading support and crash log improvements (Bug#144941)
 *    MABALK  2019-10-10  - Error message of 'Manual decision needed' of the in Print Agent. (DUXZREP-178)
 */
package ifs.fnd.printingnode;

import com.datalogics.apdfl.jni.*;
import ifs.client.application.pdfarchive.PdfArchive;
import ifs.client.application.pdfarchive.PdfArchiveArray;
import ifs.client.application.printjobcontents.PrintJobContents;
import ifs.client.application.printjobcontents.PrintJobContentsArray;
import ifs.client.application.remoteprintingnode.*;
import ifs.fnd.ap.APException;
import ifs.fnd.ap.ManualDecision;
import ifs.fnd.ap.ManualDecisionCollection;
import ifs.fnd.ap.ManualDecisionException;
import ifs.fnd.ap.Server;
import ifs.fnd.base.*;
import ifs.fnd.log.*;
import ifs.fnd.printingnode.socketspooler.Spooler;
import ifs.fnd.record.*;
import ifs.fnd.service.IfsShutdownHook;
import ifs.fnd.service.ShutdownListener;
import ifs.fnd.sf.sta.*;
import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.util.*;
import ifs.fnd.printingnode.printagentutility.*;
import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.logging.Level;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Element;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;

/**
 */
public class RemotePrintingNode extends IfsShutdownHook {

   private int maxThreads = 4;
   private Logger log = LogMgr.getFrameworkLogger();

   private HashMap mappings = new HashMap();

   private PrintJobHandler pjHandler;
   private Document configDoc = null;

   // printing node instance parameters
   private String nodeName;
   int pollTime = 10;
   int printRetries = Integer.parseInt(System.getProperty("print_retries", "3"));

   // login parameters
   private String connectString;
   private String username;
   private String password;

   // configuration file variables
   private String configFileName;
   String printerConfFileDir = ".";
   private Element configRootElement;
   private boolean RunPA = true;

   com.datalogics.PDFL.PrintUserParams recLog = null;
   PrintWriter writerLog = null;
   List<RemoteJobProcessor> threadPool = new ArrayList<>();

   List<OldRemoteJob> oldJobs = new ArrayList<>();
   List<RemoteJob> Jobs = new ArrayList<>();

   RemoteJob remoteJob;
   OldRemoteJob oldRemoteJob;

   // crashed print jobs variables
   String crashedDir = this.printerConfFileDir + File.separator + "crash_logs";
   String crashedPDFDir = this.printerConfFileDir + File.separator + "crash_pdfs";
   String currentLogFile = "";

   private HashMap hashNumCopies, hashPageFrom, hashPageTo;

   private RemotePrintingNode() {
   }

   String getName() {
      return nodeName;
   }

   HashMap getMappings() {
      return mappings;
   }

   //========================================================================================
   // Startup
   //========================================================================================
   private void startup(String[] args) throws IfsException {

      // start shutdown listener if running as service/daemon
      ShutdownListener.start();

      // register shutdown hook
      IfsShutdownHook.addShutdownHook(this);

      // read command line arguments
      if (log.trace) {
         log.trace("Reading command line arguments &1", Arrays.asList(args).toString());
      }
      FndArguments fndargs = new FndArguments();
      fndargs.registerArgument("CONF_FILE", "Configuration file");
      fndargs.registerArgument("PRINTER_CONF_DIR", "Printer Configuration file dir");
      FndApplication app = new FndApplication(args, fndargs);

      // open and parse configuration file
      configFileName = fndargs.getArgument("CONF_FILE");
      printerConfFileDir = fndargs.getArgument("PRINTER_CONF_DIR");
      if (configFileName == null) {
         configFileName = "ifs-printagent-config.xml";
      }
      if (printerConfFileDir == null) {
         printerConfFileDir = System.getProperty("user.dir");
      }

      if (printerConfFileDir == null) {
         printerConfFileDir = ".";
      }
      if (log.trace) {
         log.trace("Loading configuration file &1", configFileName);
      }
      try {
         DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
         DocumentBuilder builder = factory.newDocumentBuilder();
         configDoc = builder.parse(new File(configFileName));
      } catch (Exception e) {
         log.error(e, "Error in parsing configuration file &1: &2", configFileName, e.getMessage());
         throw new SystemException(e, "PARSECONFIG: Failed to parse configuration file &1: &2", configFileName, e.toString());
      }

      // read login parameters
      configRootElement = configDoc.getDocumentElement();

      //Start Spooler thead if configured.
      String spooler = getConfigParameter("SOCKET_SPOOLER", false);
      if (spooler != null && "on,yes,true".contains(spooler.toLowerCase())) {
         try {
            new Spooler().run();
         } catch (IOException ex) {
            throw new SystemException(ex, "Spooler Error: &1", ex.toString());
         }
      }

      String pa = getConfigParameter("PRINT_AGENT", false);
      if (pa != null && "OFF".equalsIgnoreCase(pa)) {
         // do not continue, sleep until stopped.
         if (log.debug) {
            log.debug("Print Agent will not be started since it has been disabled in the configuration.");
         }
         while (true) {
            try {
               Thread.sleep(1000 * pollTime * 10);
            } catch (InterruptedException e) {
               if (log.trace) {
                  log.trace(e, "Sleep interrupted: &1", e.getMessage());
               }
            }
         }
      }

      String endPoint = getConfigParameter("END_POINT", false);
      if (endPoint == null) {
         endPoint = "";
      }
      connectString = getConfigParameter("URL") + endPoint;

      username = getConfigParameter("USER");
      try {
         password = FndEncryption.decrypt(getConfigParameter("PASSWORD"));
      } catch (IOException e) {
         throw new SystemException(e, "DECRYPTPWD: Failed to decrypt password: &1", e.toString());
      }
      String mt = getConfigParameter("MAX_THREADS", false);
      if (mt != null) {
         try {
            maxThreads = Integer.parseInt(mt);
         } catch (NumberFormatException e) {
            maxThreads = 4; // Default 4
         }
      }

      // initialize java access provider
      initJavaAccessProviderThread();
   }

   private void register() throws IfsException {
      if (RunPA) {
         while (true) {
            try {
               pjHandler = PrintJobHandlerFactory.getHandler();
               // read instance parameters and register printing node
               nodeName = getConfigParameter("ID");
               pollTime = Integer.parseInt(getConfigParameter("POLL_TIME"));
               pjHandler.removePrintingNode(nodeName);
               if (log.info) {
                  log.info("Creating node &1 with poll time &2", nodeName, String.valueOf(pollTime));
               }
               pjHandler.createNode(nodeName, pollTime);

               return; // only loop if error, return otherwise.
            } catch (IfsException ap) {
               handleAPException(ap);
            } finally {
               recLog = null;
               if (writerLog != null) {
                  writerLog.close();
               }
               writerLog = null;
            }
         }
      }
   }

   /**
    * Add a printer mapping to local hashtable and register it in the database.
    */
   private void addMapping(String logical, String physical) throws IfsException {
      if (log.trace) {
         log.trace("Adding mapping: &1 -> &2", logical, physical);
      }
      mappings.put(logical, physical);
      pjHandler.addMapping(logical, nodeName);
   }

   private void logTrayInfo(String logicalPrinter, String physicalPrinter) {
      try {
         if (recLog == null || writerLog == null) {
            recLog = new com.datalogics.PDFL.PrintUserParams();
            String path = new java.io.File(".").getCanonicalPath();
            File file = new File(path + "/logs/tray.info");
            file.getParentFile().mkdirs();
            writerLog = new PrintWriter(file, "UTF-8");
         }

         recLog.setDriverName("winspool");
         recLog.setDeviceName(physicalPrinter);
         recLog.setPortName("Ne04");

         List enumeratePaperSources = new ArrayList();
         enumeratePaperSources = recLog.enumeratePaperSources();
         String trayName;

         writerLog.println("Printer Mapping: " + logicalPrinter + " -> " + physicalPrinter);
         for (int i = 0; i < enumeratePaperSources.size(); i++) {
            trayName = (String) enumeratePaperSources.get(i);
            trayName = trayName.trim();
            writerLog.println(trayName);
         }
      } catch (Exception ex) {
         writerLog.println("Error enumeratePaperSources " + ex.getMessage());
      } finally {
         writerLog.println();
         writerLog.println();
         writerLog.flush();
      }
   }

   public void initJavaAccessProviderThread() throws IfsException {
      Server srv = new Server();
      srv.setIntegrationUrl(true);
      srv.setConnectionString(connectString);
      srv.setCredentials(username, password);
      srv.saveToThread();
   }

   private String getConfigParameter(String name) throws SystemException {
      return getConfigParameter(name, true);
   }

   private String getConfigParameter(String name, boolean mandatory) throws SystemException {
      String value = PrintAgentUtil.getChildElementVlaue(configRootElement, name);
      if (mandatory && (value == null)) {
         throw new SystemException("CONFIGPARAM: Missing mandatory configuration parameter '&1' in configuration file '&2'", name, configFileName);
      }
      return value;
   }

   //========================================================================================
   // Shutdown
   //========================================================================================
   /**
    * Implementation of abstract method in IfsShutdownHook.
    * The method performs shutdown of the printing node.
    */
   public void run() {
      shutdown();
   }

   private synchronized void shutdown() {
      log = LogMgr.getFrameworkLogger();
      if (log != null && log.info) {
         log.info("Shutting down printing node [&1]", nodeName);
      }
      try {
         if (pjHandler != null && connectString != null) {
            if (log != null && log.info) {
               log.info("Stopping printing node [&1]", nodeName);
            }
            // initialize java AP, because this method may be run by a shutdown hook thread
            initJavaAccessProviderThread();

            //pjHandler.removePrintingNode(nodeName);
            if (log != null && log.info) {
               log.info("Stopped printing node [&1]", nodeName);
            }
         }
         if (log.info) {
            log.info("Shutdown complete.");
         }
      } catch (Throwable e) {
         if (log != null) {
            log.error(e, "Ignored error during shutdown: &1", e.getMessage());
            if (log.info) {
               log.info("Shutdown completed with errors.");
            }
         }
      } finally {
         connectString = null;
      }
   }

   //========================================================================================
   // Main loop
   //========================================================================================
   private void mainLoop() throws IfsException {
      String version = getConfigParameter("PDFL_VERSION", true);
      String printParamsConfigFile = getConfigParameter("PRINTING_PARAMETERS_FILE", false);
      if (version == null) {
         version = "10.1";
      }
      if (!version.equalsIgnoreCase("8.1")) {
         try {
            com.datalogics.PDFL.Library lib = new com.datalogics.PDFL.Library();
         } catch (Throwable t) {
            log.info("Error when initializing PDF Library " + version + ": " + t.getMessage());
            try {
               PDJNI.PDFLInit(null, null, null, 0);
               PDJNI.PDFLTerm();
            } catch (PDFLException ex) {
               throw new SystemException("SystemException", "PDFLINIT: Failed to initialize PDF Libarary 8.1: &1", ex.toString());
            }
            log.info("The required version of PDF Library could not be started, using version 8.1 instead.");
            version = "8.1";
         }
         if (!version.equalsIgnoreCase("8.1")) {
            log.info("Datalogics version " + version);
         }
      } else if (version.equalsIgnoreCase("8.1")) {
         try {
            PDJNI.PDFLInit(null, null, null, 0);
            PDJNI.PDFLTerm();
            log.info("Datalogics version 8.1.");
         } catch (PDFLException ex) {
            throw new SystemException("SystemException", "PDFLINIT: Failed to initialize PDF Libarary: &1", ex.toString());
         }
      }
      // read and register printer mappings
      NodeList printerMappings = configDoc.getElementsByTagName("PRINTER_MAPPING");
      for (int i = 0; i < printerMappings.getLength(); i++) {
         if (printerMappings.item(i).getNodeType() == Node.ELEMENT_NODE) {
            Element el = (Element) printerMappings.item(i);
            String logicalPrinter = PrintAgentUtil.getChildElementVlaue(el, "LOGICAL");
            String physicalPrinter = PrintAgentUtil.getChildElementVlaue(el, "PHYSICAL");
            addMapping(logicalPrinter, physicalPrinter);
         }
      }

      // create crashed log file directory
      File logDir = new File(crashedDir);
      if (!logDir.exists()) {
         logDir.mkdir();
      }

      // create crashed pdf file directory
      File PDFDir = new File(crashedPDFDir);
      if (!PDFDir.exists()) {
         PDFDir.mkdir();
      }

      // get the current log file name
      currentLogFile = getLogName();
      if (currentLogFile == null) {
         currentLogFile = "crashlog_0.csv";
      }

      // write the column name list to the log file
      File logFile = new File(crashedDir + File.separator + currentLogFile);
      if (!logFile.exists()) {
         try {
            logFile.createNewFile();
            FileWriter fw = new FileWriter(logFile, true);
            String columnNamesList = "Status,Time,Print Job Id,Result Key,Printer Id,Copies,From,To,Created Time,Language Code,Layout Name,Notes,Report Title";
            StringBuilder builder = new StringBuilder();
            builder.append(columnNamesList + "\n"); // column list
            fw.write(builder.toString());
            fw.close();
         } catch (IOException ex) {
            log.debug("error=" + ex.getMessage());
         }
      }

      // trying to print crashed print jobs upon restart / start
      try {
         printCrashedJobs(version,printParamsConfigFile);
      } catch (InterruptedException ex) {
         log.debug("error=" + ex.getMessage());
      }

      while (true) {

         RemoteJobProcessor proc = getAvailableProcessor(version,printParamsConfigFile);
         proc.start();
         synchronized (proc) {
            try {
               proc.wait(1000 * pollTime);
               if (oldJobs.size() > 0 || Jobs.size() > 0) {
                  logCrashDetails(version);
               }
            } catch (InterruptedException ex) {
               log.info(ex.getMessage());
            }
         }
      }

   }

   //========================================================================================
   // main
   //========================================================================================
   /**
    * @param args the command line arguments
    */
   public static void main(String[] args) throws IfsException {
      RemotePrintingNode rpn = null;
      try {
         rpn = new RemotePrintingNode();
         rpn.startup(args);
         rpn.register();

         while (true) {
            try {
               rpn.mainLoop();
            } catch (IfsException ap) {
               rpn.handleAPException(ap);
            } catch (Exception ex) {
               if (rpn != null && rpn.log != null) {
                  rpn.log.error(ex.getMessage());
               }
            }
         }
      } catch (Throwable t) {
         if (rpn != null && rpn.log != null) {
            rpn.log.error(t);
         }
         throw new RuntimeException(t);
      } finally {
         if (rpn != null) {
            rpn.shutdown();
         }
      }
   }

   // APException should not halt the program but instead wait 3 x polltime and retry.
   private void handleAPException(IfsException ap) throws IfsException {
      if (ap.getCause() instanceof APException) {
         log.error(ap.getCause().getMessage());
         try {
            int mode = checkforMaintenanceMode();
            if (mode > 1) {
               log.info("Server maintenance Mode Enabled. System is undergoing planned maintenance. No print jobs processed.");
            } else if (ap.getCause() instanceof ManualDecisionException){
               ManualDecisionCollection decisions = ((ManualDecisionException)ap.getCause()).getDecisions();
               if (decisions != null) {
               Iterator iterator = decisions.iterator();
               while (iterator.hasNext())
                  log.error(((ManualDecision)iterator.next()).getMessage());
               }
            } else {
               log.error(ap.getCause().getMessage());
            }

            Thread.sleep(1000 * 3 * pollTime * mode);
         } catch (InterruptedException e) {
            if (log.trace) {
               log.trace(e, "Sleep interupted: &1", e.getMessage());
            }
         }
      } else {
         throw ap;
      }
   }

   private int checkforMaintenanceMode() {
      try {
         URL url = new URL(connectString);
         BufferedReader in = new BufferedReader(
                 new InputStreamReader(url.openStream()));

         URLConnection conn = url.openConnection();
         if (conn.toString().toLowerCase().contains("maintenance.html")) {
            return 10;
         } else {

            String inputLine;
            while ((inputLine = in.readLine()) != null) {
               if (inputLine.toLowerCase().contains("maintenance"));
               {
                  return 10;
               }
            }
            in.close();
         }

         return 1;
      } catch (Exception ex) {
         return 1;
      }
   }

   private RemoteJobProcessor getAvailableProcessor(String version,String paramsFileName) throws IfsException {
      while (Thread.activeCount() > maxThreads) {
         try {
            Thread.sleep(250); //wait a while for jobs to finish           
         } catch (InterruptedException e) {
            if (log.trace) {
               log.trace(e, "Sleep interrupted: &1", e.getMessage());
            }
         }
      }
      return new RemoteJobProcessor(version, paramsFileName, this, false);
   }

   /**
    * Method to log the details of the print jobs to crashlog.csv file
    * @param version
    * @throws IfsException
    */
   private void logCrashDetails(String version) throws IfsException {
      if (log.trace) {

         int jobId;
         String printerId;

         String printParamsConfigFileName;
         String printerConfFileDir;

         String strCopies, strResultKey;

         int noOfCopies = 0;

         int resultKey, posIndex, endPosIndex;
         int fromPageStart, fromPageEnd, toPageStart, toPageEnd;
         int printFromPage, printToPage;

         this.hashNumCopies = new HashMap();
         this.hashPageFrom = new HashMap();
         this.hashPageTo = new HashMap();

         if (!version.equalsIgnoreCase("8.1")) {
            jobId = Jobs.get(Jobs.size() - 1).getId();
            printerId = (Jobs.get(Jobs.size() - 1).getPrinterId());
         } else {
            jobId = oldJobs.get(oldJobs.size() - 1).getId();
            printerId = (oldJobs.get(oldJobs.size() - 1).getPrinterId());
         }

         PrintJobHandler handler = PrintJobHandlerFactory.getHandler();
         PdfArchiveArray arr = new PdfArchiveArray();
         PrintJobContentsArray pjcArr = new PrintJobContentsArray();
         PdfArchive pdfArchive = new PdfArchive();
         pdfArchive.printJobId.setValue(jobId);
         FndQueryRecord query = new FndQueryRecord(pdfArchive);
         arr = (PdfArchiveArray) handler.queryPdfArchive(query);
         PrintJobContents printJobContent = new PrintJobContents();
         printJobContent.printJobId.setValue(jobId);
         FndQueryRecord queryPJC = new FndQueryRecord(printJobContent);
         pjcArr = (PrintJobContentsArray) handler.queryPrintJobContents(queryPJC);

         File logFile = new File(crashedDir + File.separator + currentLogFile);

         FileWriter fw = null;
         
         StringBuilder builder = new StringBuilder();
         SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
         String dateTime = format.format(new Date());

         for (int i = 0; i < pjcArr.getLength(); i++) {
            String instanceAttr = pjcArr.get(i).instanceAttr.getValue();
            resultKey = (int) pjcArr.get(i).resultKey.getValue().doubleValue();
            strResultKey = String.valueOf(resultKey);

            String printOption = null;
            String tempStr;

            printFromPage = 0;
            printToPage = -1;

            try {
               //Number of Copies
               posIndex = instanceAttr.indexOf("COPIES(");
               endPosIndex = instanceAttr.indexOf(')', posIndex);

               if (posIndex > -1) {
                  strCopies = instanceAttr.substring(posIndex + 7, endPosIndex);
                  printOption = "copies=" + strCopies;
                  noOfCopies = Integer.parseInt(strCopies);
               }

               //Pages
               posIndex = instanceAttr.indexOf("PAGES(");
               if (posIndex > -1) {
                  fromPageStart = instanceAttr.indexOf("(", posIndex) + 1;
                  fromPageEnd = instanceAttr.indexOf(",", posIndex);
                  toPageStart = fromPageEnd + 2;
                  toPageEnd = instanceAttr.indexOf(")", posIndex);
                  if (fromPageStart == fromPageEnd + 1) {
                     printFromPage = 0;
                     tempStr = instanceAttr.substring(toPageStart, toPageEnd);
                     printOption = "pageTo=" + tempStr;
                     printToPage = Integer.parseInt(tempStr) - 1;
                  } else if (toPageStart == toPageEnd) {
                     tempStr = instanceAttr.substring(fromPageStart, fromPageEnd);
                     printOption = "pageFrom=" + tempStr;
                     printFromPage = Integer.parseInt(tempStr) - 1;
                     printToPage = -1;
                  } else {
                     tempStr = instanceAttr.substring(fromPageStart, fromPageEnd);
                     printOption = "pageFrom=" + tempStr;
                     printFromPage = Integer.parseInt(tempStr) - 1;

                     tempStr = instanceAttr.substring(toPageStart, toPageEnd);
                     printOption = "pageTo=" + tempStr;
                     printToPage = Integer.parseInt(tempStr) - 1;
                  }
               }
            } catch (Exception ex) {
               log.error("Invalid value for [" + printOption + "]. " + ex.getMessage() + " - Aborting job.");
            }

            this.hashNumCopies.put(strResultKey, String.valueOf(noOfCopies));
            this.hashPageFrom.put(strResultKey, String.valueOf(printFromPage));
            this.hashPageTo.put(strResultKey, String.valueOf(printToPage));

         }

         for (int i = 0; i < arr.getLength(); i++) {
            PdfArchive arc = arr.get(i);
            FndBinary pdf = arc.pdf;
            try {
               FileOutputStream fos = new FileOutputStream(new File(crashedPDFDir + File.separator + "PrintJob_" + jobId + "_" + i + ".pdf"));
               fos.write(pdf.getValue());
               fos.close();

               builder.setLength(0);

               resultKey = (int) arc.resultKey.getValue().doubleValue();
               strResultKey = String.valueOf(resultKey);
               int copies = Integer.parseInt((String) this.hashNumCopies.get(strResultKey));
               int pageFrom = Integer.parseInt((String) this.hashPageFrom.get(strResultKey));
               int pageTo = Integer.parseInt((String) this.hashPageTo.get(strResultKey));

               try {
                  fw = new FileWriter(logFile, true);
                  if ((logFile.exists())) {
                     builder.append("C,");
                     builder.append(dateTime + ",");
                     builder.append(jobId + ",");   // Print Job Details
                     builder.append(arc.resultKey.toString() + ",");
                     builder.append(printerId + ",");
                     builder.append(String.valueOf(copies) + ",");
                     builder.append(String.valueOf(pageFrom) + ",");
                     builder.append(String.valueOf(pageTo) + ",");
                     builder.append(arc.created.toString() + ",");
                     builder.append(arc.langCode.toString() + ",");
                     builder.append(arc.layoutName.toString() + ",");
                     builder.append(arc.notes.toString() + ",");
                     builder.append(arc.reportTitle.toString() + ",");
                     builder.append('\n');
                  }
                  fw.write(builder.toString());
                  fw.close();
               } catch (IOException e) {
                  e.printStackTrace();
               }

            } catch (IOException e) {
               log.trace(e.getMessage());
            }
         }

      }
      if (version.equalsIgnoreCase("8.1")) {
         oldJobs.remove(oldJobs.size() - 1).getId();
      } else {
         Jobs.remove(Jobs.size() - 1).getId();
      }

   }

   /**
    * Method to execute the crashed print jobs in single thread upon restart
    * @param version
    * @throws IfsException
    * @throws InterruptedException
    */
   private void printCrashedJobs(String version,String paramsFileName) throws IfsException, InterruptedException {
      if (log.trace) {
         RemoteJobProcessor remoteJobProcessor = new RemoteJobProcessor(version, paramsFileName, this, true);
         remoteJobProcessor.start();
         synchronized (remoteJobProcessor) {
            try {
               remoteJobProcessor.wait(1000 * pollTime);
               remoteJobProcessor.join();
            } catch (InterruptedException ex) {
               log.info(ex.getMessage());
            }
         }
      }
   }
   /**
    * Method to get the file name of the current log file (crashlog.csv)
    * @return current log file name
    */
   String getLogName() {
      String fileName = null;
      File currentLogFile = getLatestFilefromDir(crashedDir);

      if (currentLogFile != null) {
         long fileSizeInBytes = (currentLogFile).length();
         long fileSizeInKB = fileSizeInBytes / 1024;
         long fileSizeInMB = fileSizeInKB / 1024;

         String name = currentLogFile.getName();

         if (fileSizeInMB > 10) {
            String con = name.split("\\.")[0];
            int fileNo = Integer.parseInt(con.split("_")[1]);
            fileName = "crashlog_" + (fileNo + 1) + ".csv";
         } else {
            fileName = name;
         }
      }
      return fileName;
   }
   /**
    * Method to find the last edited / written crash log file (crashlog.csv)
    * @param dirPath
    * @return last edited crashlog file
    */
   private File getLatestFilefromDir(String dirPath) {
      File dir = new File(dirPath);
      File[] files = dir.listFiles();
      if (files == null || files.length == 0) {
         return null;
      }

      File lastModifiedFile = files[0];
      for (int i = 1; i < files.length; i++) {
         if (lastModifiedFile.lastModified() < files[i].lastModified()) {
            lastModifiedFile = files[i];
         }
      }
      return lastModifiedFile;
   }

}
