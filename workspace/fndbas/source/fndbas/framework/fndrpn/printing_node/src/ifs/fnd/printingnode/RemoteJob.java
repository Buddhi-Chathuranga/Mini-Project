/*
 * RemoteJob.java
 *
 * Modified:
 *    madrse  2008-Feb-14 - Rewritten to use java access provider
 *    asiwlk  2009-july-8 - Corrected the number of pages printed with tray options		
 *    madilk  2010-Oct-21 - 93483 - Print Agent ignores the selection of pages to print as set in the Print Report dialog
 *    hamalk  2011-mar-14 - Print Order Problem
 *    NaBaLK  2012-08-29  - Corrections to support individual settings from Print Dialog (Bug#104774)
 *    LiRiSE  2013-03-08  - Added support for a printing parameters configuration file.
 *    LiRiSE  2013-05-13  - Corrections to support printing to different trays.
 *    CHAALK  2014-02-07  - Patch Merge Bug#120928
 *    CHAALK  2015-06-30  - Patch Merge - Print jobs failing in Print Agent intermittently (Bug#121794)
 *    SAWELK  2015-08-06  - Patch Merge DUPLEX printing is not working when using report rule engine to set the duplex mode Bug#122688 
 *    MADILK  2016-12-14  - TEREPORT-2326 - Merging 132493 - Invalid values for copies, printFrom and printTo options hang the Print Agent
 *    CHAALK  2017-Jul-06 - Remove jdom and use org.w3c.dom conversion
 *    CHAALK  2017-08-21  - Patch merge (Bug#137284) 
 *    DDESLK  2018-09-13  - Print Agent Property / PDF insert report rule error (Bug#144175) 
 *    CHAALK  2018-12-19  - Duplex printing is not working as expected and Bad parameter error in print agent log (Bug#145970)
 *    DDESLK  2019-02-07  - IFS Print Agent java multithreading support and crash log improvements (Bug#144941)
 */
package ifs.fnd.printingnode;

import com.datalogics.PDFL.PageRange;
import com.datalogics.PDFL.PageSpec;
import ifs.client.application.pdfarchive.*;
import ifs.client.application.printjobcontents.*;
import ifs.client.application.remoteprintingnode.*;
import ifs.fnd.base.*;
import ifs.fnd.log.*;
import ifs.fnd.record.*;
import ifs.fnd.util.Str;
import java.io.*;
import java.lang.reflect.*;
import java.util.*;
import ifs.fnd.printingnode.printagentutility.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Element;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;


/**
 * Class representing a remote printing job.
 */
class RemoteJob {

   private Logger log = LogMgr.getFrameworkLogger();
   //private SAXBuilder xmlParser = new SAXBuilder();
   private PrintJobHandler handler;
   private RemotePrintingNode node;
   private HashMap mappings;
   private int jobId;
   private int copies = 1;
   private int pageFrom = 0;
   private int pageTo = -1;
   private int firstTray = -1;
   private int lastTray = -1;
   private int restTray = -1;
   private String printerId;
   private Element printerElement;
   private String routingPrinter;
   private boolean omitJobPrinting;
   private com.datalogics.PDFL.PrintUserParams rec;
   private com.datalogics.PDFL.PrintParams psParams;
   private String insertErrorMessage;
   private Method[] psParamMethods;
   private Method[] recMethods;
   private HashMap psParamConfig;
   private HashMap recConfig;
   private HashMap hashNumCopies, hashPageFrom, hashPageTo;
   private String printParamsConfigFileName;
   private String printerConfFileDir;
   private String spoolName;
   private List<PageRange> pageRanges = new ArrayList<PageRange>();

   RemoteJob(int jobId, String printerId, int copies, int pageFrom, int pageTo, RemotePrintingNode node, String printParamsConfigFileName, String printerConfFileDir) throws IfsException {
      //Parameters copies, pageFrom, pageTo are no longer passed to PDFL but only for backward compatibility
      this.node = node;
      this.mappings = node.getMappings();
      handler = PrintJobHandlerFactory.getHandler();
      this.jobId = jobId;
      this.printerId = printerId;
      //this.copies = copies;
      //this.pageFrom = pageFrom;
      //this.pageTo = pageTo;
      this.rec = new com.datalogics.PDFL.PrintUserParams();
      this.psParams = rec.getPrintParams();
      this.psParamMethods = new Method[50];
      this.recMethods = new Method[20];
      this.psParamConfig = new HashMap();
      this.recConfig = new HashMap();
      this.printParamsConfigFileName = printParamsConfigFileName;
      this.printerConfFileDir = printerConfFileDir;
   }
   int getId() {
      return jobId;
   }

   public String getPrinterId() {
      return printerId;
   }

   public String toString() {
      return "[jobId=" + jobId + " printerId=" + printerId + " copies=" + copies + " pageFrom=" + (pageFrom + 1) + " pageTo=" + (pageTo + 1) + "]";
   }

   private void setPrinterconfigParameters() {
      psParamConfig.clear();
      recConfig.clear();
      try {
         File propertyFile=null;
         try
         {
            //located in the "." or could be a full path to file
            propertyFile = new File(this.printParamsConfigFileName);
            if (!propertyFile.exists()) {
               //if not use the printerConfFileDir path
               String configFile = this.printerConfFileDir + File.separator + this.printParamsConfigFileName;
               propertyFile = new File(configFile);
            }
         }
         catch(Exception ex)
         {
            log.error(ex, "Error while reading printing parameter configuration file: &1 &2 ", propertyFile.getAbsolutePath(), ex.getMessage());
         }
         if (propertyFile!=null && propertyFile.exists()) {
            FileInputStream fstream = new FileInputStream(propertyFile.getAbsolutePath());
            DataInputStream in = new DataInputStream(fstream);
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String strLine;
            recMethods = rec.getClass().getMethods();
            psParamMethods = psParams.getClass().getMethods();
            while ((strLine = br.readLine()) != null) {
               if (strLine.startsWith("##") || strLine.isEmpty()) {
                  continue;
               }
               String[] argument = strLine.trim().split("##");
               String[] args = argument[0].trim().split("=");
               String method = args[0];
               String[] configMethod = method.split("\\.");
               if (configMethod.length > 0 && configMethod[0].equalsIgnoreCase("PrintParams")) {
                  psParamConfig.put(configMethod[1], args[1]);
               } else if (configMethod.length > 0 && configMethod[0].equalsIgnoreCase("PrintUserParams")) {
                  recConfig.put(configMethod[1], args[1]);
               } else {
                  log.info("No such class: &1", configMethod[0].toString() + ". Only the two classes PrintParams and PrintUserParams are allowed.");
                  continue;
               }
            }
         }
         else
         {
            log.error("Error while reading printing parameter configuration file: &1", propertyFile.getAbsolutePath());
         }
      } catch (IOException ex) {
         log.info(ex.getMessage());
      }
   }

   private void invokeMethod(Object o, Method[] methods, String parameterName, String argument, com.datalogics.PDFL.Document pdoc) {
      argument = argument.trim();
      parameterName = parameterName.trim();
      if (parameterName.equalsIgnoreCase("firstTray")) {
         this.firstTray = Integer.parseInt(argument);
         return;
      } else if (parameterName.equalsIgnoreCase("restTray")) {
         this.restTray = Integer.parseInt(argument);
         return;
      } else if (parameterName.equalsIgnoreCase("lastTray")) {
         this.lastTray = Integer.parseInt(argument);
         return;
      }
      if (parameterName.equalsIgnoreCase("Duplex") && (argument.equalsIgnoreCase("SIMPLEX") || argument.equalsIgnoreCase("DUPLEX_OFF")
              || argument.equalsIgnoreCase("DUPLEX_VERTICAL") || argument.equalsIgnoreCase("DUPLEX_HORIZONTAL")
              || argument.equalsIgnoreCase("DUPLEX_SHORTSIDE") || argument.equalsIgnoreCase("DUPLEX_LONGSIDE"))) {
         argument = getDuplexMode(argument.toUpperCase(), pdoc.getPage(0)).toString();
      }
      for (int j = 0; j < methods.length; j++) {
         String curMethod = methods[j].getName();
         String matchToSet = "set" + parameterName;
         String matchToUse = "use" + parameterName;
         Type[] pType;
         if (argument.equalsIgnoreCase("DEFAULT")) {
            return;
         }
         if (curMethod.trim().equalsIgnoreCase(matchToSet) || curMethod.trim().equalsIgnoreCase(matchToUse)) {
            try {
               methods[j].setAccessible(true);
               pType = methods[j].getParameterTypes();
               if (pType[0].toString().equalsIgnoreCase("string")) {
                  methods[j].invoke(o, new Object[]{argument});
               } else if (pType[0].toString().equalsIgnoreCase("boolean")) {
                  methods[j].invoke(o, new Object[]{(Boolean.valueOf(argument))});
               } else if (pType[0].toString().equalsIgnoreCase("long")) {
                  methods[j].invoke(o, new Object[]{(new Long(argument))});
               } else if (pType[0].toString().equalsIgnoreCase("int")) {
                  methods[j].invoke(o, new Object[]{(new Integer(argument))});
               } else if (pType[0].toString().equalsIgnoreCase("float")) {
                  methods[j].invoke(o, new Object[]{(new Float(argument))});
               } else if (pType[0].toString().equalsIgnoreCase("class com.datalogics.PDFL.Inclusion")) {
                  methods[j].invoke(o, new Object[]{com.datalogics.PDFL.Inclusion.valueOf(argument)});
               } else if (pType[0].toString().equalsIgnoreCase("class com.datalogics.PDFL.OutputType")) {
                  methods[j].invoke(o, new Object[]{com.datalogics.PDFL.OutputType.valueOf(argument)});
               } else if (pType[0].toString().equalsIgnoreCase("class com.datalogics.PDFL.Document")) {
                  methods[j].invoke(o, new Object[]{new com.datalogics.PDFL.Document(argument)});
               } else if (pType[0].toString().equalsIgnoreCase("class com.datalogics.PDFL.Rect")) {
                  String[] coordinates = argument.split(",");
                  methods[j].invoke(o, new Object[]{(new com.datalogics.PDFL.Rect(new Double(coordinates[0]), new Double(coordinates[1]), new Double(coordinates[2]), new Double(coordinates[3])))});
               } else if (pType[0].toString().equalsIgnoreCase("class com.datalogics.PDFL.PageTilingMode")) {
                  methods[j].invoke(o, new Object[]{com.datalogics.PDFL.PageTilingMode.valueOf(argument)});
               } else if (pType[0].toString().equalsIgnoreCase("class com.datalogics.PDFL.FarEastFont")) {
                  methods[j].invoke(o, new Object[]{com.datalogics.PDFL.FarEastFont.valueOf(argument)});
               } else if (pType[0].toString().equalsIgnoreCase("class com.datalogics.PDFL.OptionalContentContext")) {
                  com.datalogics.PDFL.Document doc = new com.datalogics.PDFL.Document(argument);
                  methods[j].invoke(o, new Object[]{new com.datalogics.PDFL.OptionalContentContext(doc)});
               } else if (pType[0].toString().equalsIgnoreCase("class com.datalogics.PDFL.Duplex")) {
                  methods[j].invoke(o, new Object[]{com.datalogics.PDFL.Duplex.valueOf(argument)});
               } else if (pType[0].toString().equalsIgnoreCase("class java.util.EnumSet")) {
                  Set s = null;
                  if (methods[j].getName().equals("setWhichMarks")) {
                     String[] args = argument.split(",");
                     s = EnumSet.of(com.datalogics.PDFL.PageMarkFlags.valueOf(args[0]));
                     for (int i = 1; i < args.length; i++) {
                        s.add(com.datalogics.PDFL.PageMarkFlags.valueOf(args[i]));
                     }
                  }
                  if (methods[j].getName().equals("setPrintWhatAnnot")) {
                     String[] args = argument.split(",");
                     s = EnumSet.of(com.datalogics.PDFL.PrintWhatAnnotFlags.valueOf(args[0]));
                     for (int i = 1; i < args.length; i++) {
                        s.add(com.datalogics.PDFL.PrintWhatAnnotFlags.valueOf(args[i]));
                     }
                  }
                  if (s != null) {
                     methods[j].invoke(o, new Object[]{s});
                  }
               } else {
                  methods[j].invoke(o, new Object[]{(Object) argument});
               }
            } catch (Exception e) {
               log.info("Ignored exception while setting config. &1", e.getMessage());
            }
            return;
         }
         if (j == methods.length - 1) {
            log.info("No such method &1", parameterName);
         }
      }
   }

   private void setConfig(com.datalogics.PDFL.Document pdoc) {
      Iterator configRec = recConfig.keySet().iterator();
      while (configRec.hasNext()) {
         String curMethod = (String) configRec.next();
         if (curMethod.length() != 0) {
            invokeMethod(rec, recMethods, curMethod, (String) recConfig.get(curMethod), pdoc);
         }
      }
      Iterator configPsParam = psParamConfig.keySet().iterator();
      while (configPsParam.hasNext()) {
         String curMethod = (String) configPsParam.next();
         if (curMethod.length() != 0) {
            invokeMethod(psParams, psParamMethods, curMethod, (String) psParamConfig.get(curMethod), pdoc);
         }
      }
   }

   private void setDefaultPrinterParams(String physicalPrinter, int id, com.datalogics.PDFL.Document doc) {
      pageRanges.add(new PageRange(pageFrom,pageTo, PageSpec.ALL_PAGES));
      psParams.setPageRanges(pageRanges);
      rec.setPaperWidth((int) (doc.getPage(0).getMediaBox().getRight() - doc.getPage(0).getMediaBox().getLeft()));
      rec.setPaperHeight((int) (doc.getPage(0).getMediaBox().getTop() - doc.getPage(0).getMediaBox().getBottom()));
      if(spoolName!=null && spoolName.length()>0){
         rec.setInFileName(spoolName);
      }
      else{
         rec.setInFileName("PrintJob_" + jobId + "_" + id + ".pdf");
      }
      //rec.setOutFileName(null);
      rec.setDeviceName(physicalPrinter);
      if (copies >= 0) {
         rec.setNCopies(copies);
      }
   }

   /**
    * The method will try to print out as many sub-jobs as possible.
    *
    * @return the last error message or null if no errors where generated.
    */
   String perform() throws IfsException {
      int resultKey, posIndex, endPosIndex;
      int fromPageStart, fromPageEnd, toPageStart, toPageEnd;
      int printFromPage, printToPage;
      String strResultKey, strCopies;
      if (log.trace) {
         log.trace("Fetching Routing Info for job &1", String.valueOf(jobId));
      }
      byte[] xmlInfo = handler.getRoutingInfo((double) jobId);
      if (xmlInfo != null) {
         try {
            if (log.debug) {
               log.debug("Got Routing Info: &1", new String(xmlInfo));
            }
            ByteArrayInputStream inputStream = new ByteArrayInputStream(xmlInfo);
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();               
            Document routingInfoDoc = builder.parse(inputStream);
            printerElement = getRoutingInformation(routingInfoDoc, "PRINTER");
            routingPrinter = getPrinterAddress(routingInfoDoc);
            omitJobPrinting = getOmitInformation(routingInfoDoc);
            
            if(routingPrinter==null){
               routingPrinter = getPrinterId(); //Bug(#144175)
            }
                    
            String configFromRouting= getPrintingparametersFile(routingInfoDoc);
            spoolName = getPrintingSpoolFileName(routingInfoDoc);
            //updating Print config settings. Preference goes to the name in the routing xml
            if(configFromRouting != null && configFromRouting.length()>0){
              this.printParamsConfigFileName = configFromRouting;
            }
         } catch (Exception e) {
            log.error(e, "Error while parsing routing info: &1", e.getMessage());
         }
      } else if (log.debug) {
         log.debug("No Routing Info found.");
      }

      // set user and printer parameters from the configaration file
      if(this.printParamsConfigFileName != null && this.printParamsConfigFileName.length()>0){
         setPrinterconfigParameters(); 
      }
      else{
         if (log.debug) {
            log.trace("Printing library defaults are used as the printer configuration parameter file is not set in the configuration xml or in the routing xml.");
         }
      }

      if (log.trace) {
         log.trace("Querying PdfArchive for job &1", String.valueOf(jobId));
      }
      
      int attempts = 4;
      boolean gotPrintJobData = false;
      PdfArchiveArray arr = new PdfArchiveArray() ;
      PrintJobContentsArray pjcArr = new  PrintJobContentsArray();
      
      while(!gotPrintJobData && attempts>0){ //try for stability on Cloud
         try{
            PdfArchive pdfArchive = new PdfArchive();
            pdfArchive.printJobId.setValue(jobId);
            FndQueryRecord query = new FndQueryRecord(pdfArchive);
            if(log.trace) {log.trace("Start Querying PdfArchive for job &1", String.valueOf(jobId));};         
            arr = (PdfArchiveArray) handler.queryPdfArchive(query);
            if(log.trace) {log.trace("Querying PdfArchive Result count &1", arr.getLength());};   
            PrintJobContents printJobContent = new PrintJobContents();
            printJobContent.printJobId.setValue(jobId);
            FndQueryRecord queryPJC = new  FndQueryRecord(printJobContent);
            if(log.trace) {log.trace("Start Querying PrintJobContents for job &1", String.valueOf(jobId));};           
            pjcArr = (PrintJobContentsArray) handler.queryPrintJobContents(queryPJC);
            if(log.trace) {log.trace("Querying PrintJobContents Results count &1", pjcArr.getLength());};  
            query.clear();
            queryPJC.clear();
            gotPrintJobData= true;
         }
         catch(Exception e){
            if(attempts>0){
               if(log.trace){log.trace("Querying attempt &1 failed, trying again..", 5- attempts);};
               attempts--;
               try {
                  Thread.sleep(1000 * 3);
               }
               catch (InterruptedException ex) {
                  if(log.trace){
                     log.trace(ex, "Sleep interrupted: &1", e.getMessage());
                  }
               }
            }
            else{
               if(log.trace){log.trace("Failed to Query &1 tims", 4);};
               return "Failed to Query PdfArcive/PrintJobContents " + e.getMessage();
            }
         }
      }

      this.hashNumCopies = new HashMap();
      this.hashPageFrom = new HashMap();
      this.hashPageTo = new HashMap();
      
      String physicalPrinter = (String) mappings.get(printerId);
      if(log.trace) {log.trace("Trying to lock thread on printer " + physicalPrinter);}; 
      synchronized(physicalPrinter){
      if(log.trace) {log.trace("Got thread lock for printer " + physicalPrinter);};   
      for (int i = 0; i < pjcArr.getLength(); i++) {
         String instanceAttr = pjcArr.get(i).instanceAttr.getValue();
         resultKey = (int) pjcArr.get(i).resultKey.getValue().doubleValue();
         strResultKey = String.valueOf(resultKey);

         String printOption = null;
         String tempStr;
         
         int noOfCopies = 1;
         printFromPage = 0;
         printToPage = -1;
         
         try{
         //Number of Copies
         posIndex = instanceAttr.indexOf("COPIES(");
         endPosIndex = instanceAttr.indexOf(')', posIndex);

         if (posIndex > -1) {
            strCopies = instanceAttr.substring(posIndex + 7, endPosIndex);
               printOption = "copies=" + strCopies;
               noOfCopies = Integer.parseInt(strCopies);
               if(log.trace) {log.trace("PrintJob number of copies  &1", noOfCopies);};  
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
            return "Invalid value for the print option [" + printOption + "] for Result Key " + strResultKey;
         }
         
         this.hashNumCopies.put(strResultKey,String.valueOf(noOfCopies));
         this.hashPageFrom.put(strResultKey, String.valueOf(printFromPage));
         this.hashPageTo.put(strResultKey, String.valueOf(printToPage));
         
         if(log.trace) {log.trace("PrintJob FromPage  &1 ", String.valueOf(printFromPage));}  
         if(log.trace) {log.trace("PrintJob ToPage    &1 ", (printToPage == -1) ? "endPage" : String.valueOf(printToPage));}  
      }

      if (log.trace) {
         log.trace("Fetched &1 PdfArchive row(s)", String.valueOf(arr.size()));
      }
      boolean isSamePrinter = false;
      if (routingPrinter != null && this.mappings.containsKey(routingPrinter)) {
         routingPrinter = (String) this.mappings.get(routingPrinter);
         isSamePrinter = physicalPrinter.equals(routingPrinter);
      } else {
         routingPrinter = physicalPrinter; // fallback on printjob printer
         isSamePrinter = true;
      }

      if (arr.getLength() > 1) {
         PdfArchiveArray arr_tmp = arr;
         PdfArchive tempElement;
         double element1, element2;
         int arrayLength = arr_tmp.getLength();
         for (int i = 0; i < arrayLength; i++) {
            for (int j = arrayLength - 1; j > i; j--) {
               element1 = Double.parseDouble(arr_tmp.get(j - 1).resultKey.toString());
               element2 = Double.parseDouble(arr_tmp.get(j).resultKey.toString());
               if (element1 > element2) {
                  tempElement = arr_tmp.get(j);
                  arr_tmp.set(j, arr_tmp.get(j - 1));
                  arr_tmp.set(j - 1, tempElement);
               }
            }
         }
         arr = arr_tmp;
      }
      if (!Str.isEmpty(physicalPrinter)) {

         com.datalogics.PDFL.Library lib = new com.datalogics.PDFL.Library();
         int trcPageFrom, trcPageTo;
         for (int i = 0; i < arr.getLength(); i++) {
            File tmpFile = null;
            com.datalogics.PDFL.Document pdoc = null;
            try {
               PdfArchive arc = arr.get(i);
               FndBinary pdf = arc.pdf;
               
               // check the content 
               if(pdf.getValue()==null)
               {
                   insertErrorMessage = "ERROR Preparing PDF for jobId=" + arc.printJobId.toString() +" PDF is NULL";
                   continue;  
               }
                       
               resultKey = (int) arc.resultKey.getValue().doubleValue();
               strResultKey = String.valueOf(resultKey);
               copies = Integer.parseInt((String) this.hashNumCopies.get(strResultKey));
               pageFrom = Integer.parseInt((String) this.hashPageFrom.get(strResultKey));
               pageTo = Integer.parseInt((String) this.hashPageTo.get(strResultKey));
               if (log.trace) {
                  if (pageTo > -1) {
                     trcPageFrom = pageFrom + 1;
                     trcPageTo = pageTo + 1;
                  } else {
                     trcPageFrom = pageFrom;
                     trcPageTo = pageTo;
                  }
                  log.trace("Preparing PDF for jobId=" + arc.printJobId.toString() + " resultKey=" + arc.resultKey.toString() + " copies=" + copies + " PageFrom=" + ((trcPageFrom == 0) ? "1" : trcPageFrom) + ((trcPageTo == -1) ? " to end" : " PageTo=" + trcPageTo));
               }
               
               //doing PDF Inserting before creating the disk tmpFile
               if (printerElement != null) 
               {
                  Element option_el = PrintAgentUtil.getChildElement(printerElement, "OPTIONS");
                  Element INSERTS = PrintAgentUtil.getChildElement(option_el, "INSERTS");
                  if (INSERTS != null) {
                     try {
                        PdfInserter inserter = new PdfInserter(pdf.getValue(), option_el);
                        pdf.setValue(inserter.getResultPdf());
                     } catch (PdfInserter.InsertException e) {
                        log.error(e, "Ignored error during PDF insertion");
                        insertErrorMessage = e.getMessage();
                     }
                  }
               }

//               FndBinary originalPdf = null;
//               try {
//                  originalPdf = (FndBinary) pdf.clone();
//               } catch (Exception ee) {
//                  log.error(ee, "Ignored error while cloning PDF: &1", ee.getMessage());
//               }

               File f = new File(System.getProperty("user.dir"));
               String tmpFileAddress = f.getParentFile().getParentFile().getAbsolutePath() + File.separator +"lib"+ File.separator + jobId + ".pdf";
               tmpFile = new File(tmpFileAddress);
               try {
                  tmpFile.createNewFile();
                  FileOutputStream fos = new FileOutputStream(tmpFileAddress);
                  fos.write(pdf.getValue());
                  fos.close();
               } catch (IOException e) {
                  log.trace(e.getMessage());
               }
               pdoc = new com.datalogics.PDFL.Document(tmpFileAddress);
               rec.useDefaultPrinter(pdoc);
               setConfig(pdoc);
               setDefaultPrinterParams(physicalPrinter, i, pdoc);
               if (printerElement != null) {
               rec.setDeviceName(routingPrinter);
               Element option_el = PrintAgentUtil.getChildElement(printerElement, "OPTIONS");
               enumeratePaperSources(rec,getTrayInfo(option_el, "TRAY_FIRST"),
                       getTrayInfo(option_el, "TRAY_REST"),
                       getTrayInfo(option_el, "TRAY_LAST"));
               
                  try {
                   
                  int dup_copies = -1; 
                  try
                  {    
                    dup_copies = Integer.parseInt(getTrayInfo(option_el, "COPIES"));
                  }
                  catch(Exception ex){}

                  rec.setNCopies(dup_copies);
 
                  try
                  {
                     String mode = PrintAgentUtil.getChildElementVlaue(option_el, "DUPLEX_MODE");
                    if(mode!=null)
                    {
                        mode = mode.trim().toUpperCase();
                        if (pdoc.getNumPages() > 0){
                           com.datalogics.PDFL.Duplex duplexMode = getDuplexMode(mode, pdoc.getPage(0));
                           psParams.setDuplex(duplexMode);
                        }
                    }
                  }
                  catch(Exception e){
                      log.error(e, "Defaulting to Duplex.OFF Error is"+e.getMessage());
                  }
                  
                     if(firstTray == -1 && restTray == -1 && lastTray == -1){ //Only default tray is used
                        rec.setPaperSource(-1);
                        PDFLPrintDoc(pdoc);
                     }else{ //Some specicic tray is used, the document is splitted into 3 parts (firstpage, restpages and lastpage) each printed to the default tray or the specific tray.
                        if(pageFrom == 0 || pageFrom == -1){ //The first page should be printed
                           pageRanges.clear();
                           pageRanges.add(new PageRange(0,0, PageSpec.ALL_PAGES));
                           psParams.setPageRanges(pageRanges);
                           rec.setPaperSource(firstTray);
                           PDFLPrintDoc(pdoc);
                        }
                        if (pdoc.getNumPages() >= 3) {
                           int firstPage, lastPage;
                           if(pageFrom < pdoc.getNumPages()-1 && (pageTo > 0 || pageTo == -1)){ // The document contains "rest" pages that should be printed
                              if(1 > pageFrom){ //The first page has been printed and the rest pages should be printed aswell
                                 firstPage = 1;
                              }else{
                                 firstPage = pageFrom;
                              }
                              if(pdoc.getNumPages()-2 < pageTo || pageTo == -1){ //The last page should be printed, and the rest pages should be printed aswell
                                 lastPage = pdoc.getNumPages() - 2;
                              }else{
                                 lastPage = pageTo;
                              }
                              pageRanges.clear();
                              pageRanges.add(new PageRange(firstPage,lastPage, PageSpec.ALL_PAGES));
                              psParams.setPageRanges(pageRanges);
                              rec.setPaperSource(restTray); //if restTray has not been assigned as a specific tray, it has the same value as the default tray (-1)
                              PDFLPrintDoc(pdoc);
                           }
                        }
                        if (pdoc.getNumPages() >= 2) {
                           if(pageTo == pdoc.getNumPages()-1 || pageTo == -1){ //The last page should be printed
                              pageRanges.clear();
                              pageRanges.add(new PageRange(pdoc.getNumPages() - 1,pdoc.getNumPages() - 1, PageSpec.ALL_PAGES));
                              psParams.setPageRanges(pageRanges);
                              rec.setPaperSource(lastTray); //if lastTray has not been assigned as a specific tray, it has the same value as the default tray (-1)
                              PDFLPrintDoc(pdoc);
                           }
                        }
                     }
                  } catch (Exception ex) {
                     log.error(ex, "Exception on printing with routing: &1", ex.getMessage());
                     insertErrorMessage = "Exception on printing with routing: " + ex.getMessage();
                  }
               } else {
                  try {
                     PDFLPrintDoc(pdoc);
                  } catch (Exception e) {
                     String errMsg = e.toString();
                     log.error(e, "PDFL error catched. Error message: \"&1\"", e.getMessage());
                     return errMsg;
                  }
               }
               log.trace("Document sent to printer. No errors returned.");
               boolean needExtraPrinting = true;
               if (insertErrorMessage == null && omitJobPrinting) {
                  needExtraPrinting = false;
               }
               if (!isSamePrinter && printerElement != null && needExtraPrinting) {
                  rec.setEndPage(-1);
                  rec.setDeviceName(physicalPrinter);
                  if (copies >= 0) {
                     rec.setNCopies(copies);
                  }
                  try {
                     setConfig(pdoc);
                     PDFLPrintDoc(pdoc);
                  } catch (Exception e) {
                     String errMsg = e.toString();
                     log.error(e, "PDFL error while printing to routing Printer. Error message: \"&1\"", e.getMessage());
                     return errMsg;
                  }
               }
            } finally {
               if(pdoc!=null){
                 pdoc.close();
               }
               if (tmpFile != null && tmpFile.exists()) {
                  tmpFile.delete();
               }
            }
         }
         lib.delete();
      }
      }
      return insertErrorMessage;
   }

   private void PDFLPrintDoc(com.datalogics.PDFL.Document pdoc) throws Exception {
      int tries = 0;
      while (true) {
         try {
            pdoc.print(rec);
            return;
         } catch (Exception e) {
            // Retry functionallity
            log.trace("Exception " + e.getMessage());
            if (tries < node.printRetries) {
               tries++;
               if (log.trace) {
                  log.trace("Failed to print!");
               }
               if (log.trace) {
                  log.trace("Retrying: &1", String.valueOf(tries));
               }
               try {
                  Thread.sleep(1000 * node.pollTime);
               } catch (InterruptedException ie) {
                  if (log.trace) {
                     log.trace("Sleep interupted: &1", ie.getMessage());
                  }
               }
            } else {
               throw e;
            }
         }
      }
   }

   private Element getRoutingInformation(Document routingInfoDoc, String destination) {
      try {
         NodeList destinationMappings = routingInfoDoc.getElementsByTagName("DESTINATION");
         for(int i=0;i<destinationMappings.getLength();i++){
            if(destinationMappings.item(i).getNodeType() == Node.ELEMENT_NODE){   
               Element el = (Element) destinationMappings.item(i);
               String channel = PrintAgentUtil.getChildElementVlaue(el, "CHANNEL");
               if (channel.equals(destination)) {
                  return el;
               }
            }
         }
      } catch (Exception e) {
         if (log.debug) {
            log.debug(e, "Ignored error while reading Routing info: &1", e.getMessage());
         }
         return null;
      }
      return null;
   }

   private boolean getOmitInformation(Document routingInfoDoc) {
      try {
         Element el = PrintAgentUtil.getChildElement(routingInfoDoc, "OMIT_PRINTOUT_TO_JOB_PRINTER");
         
         //Bug(#144175)
         if(el==null){
            return false;
         }else{
            String val = el.getTextContent().trim();
            val = ((val != null) && (val != ""))? val.trim().toUpperCase():"FALSE";
            if (val.equals("TRUE")) {
               return true;
            } else {
               return false;
            }
         }
         
         
         
      } catch (Exception e) {
         if (log.debug) {
            log.debug(e, "Ignored error while reading Omit info: &1", e.getMessage());
         }
         return false;
      }
      //return false;
   }

   private String getPrinterAddress(Document routingInfoDoc) {
      try {
         Element el = PrintAgentUtil.getChildElement(routingInfoDoc, "DESTINATION");
         String channel = PrintAgentUtil.getChildElementVlaue(el, "ADDRESS");
         if(channel!=null){
               channel.trim();
         }
         return channel;
      } catch (Exception e) {
         if (log.debug) {
            log.debug(e, "Ignored error while reading printer addres: &1", e.getMessage());
         }
         return null;
      }
      //return null;
   }

    private String getPrintingparametersFile(Document routingInfoDoc) {
      try {
         NodeList destinationMappings = routingInfoDoc.getElementsByTagName("DESTINATION");
         for(int i=0;i<destinationMappings.getLength();i++){
            if(destinationMappings.item(i).getNodeType() == Node.ELEMENT_NODE){
               Element el = (Element) destinationMappings.item(i);
               if(PrintAgentUtil.getChildElement(el, "PRINTING_PARAMETERS_FILE")!=null){
                  return PrintAgentUtil.getChildElementVlaue(el,"PRINTING_PARAMETERS_FILE");
               }
               return null;
            }
         }
      } catch (Exception e) {
         if (log.debug) {
            log.debug(e, "Ignored error while reading printer addres: &1", e.getMessage());
         }
         return null;
      }
      return null;
   }
    
   private String getPrintingSpoolFileName(Document routingInfoDoc) {
      try {
         NodeList destinationMappings = routingInfoDoc.getElementsByTagName("DESTINATION");
         for(int i=0;i<destinationMappings.getLength();i++){
            if(destinationMappings.item(i).getNodeType() == Node.ELEMENT_NODE){
               Element el = (Element) destinationMappings.item(i);
                if(PrintAgentUtil.getChildElement(el, "PRINTING_SPOOL_FILE_NAME")!=null){
                  return PrintAgentUtil.getChildElementVlaue(el,"PRINTING_SPOOL_FILE_NAME");
               }
               return null;  
            }
         }
      } catch (Exception e) {
         if (log.debug) {
            log.debug(e, "Ignored error while reading printer addres: &1", e.getMessage());
         }
         return null;
      }
      return null;
   } 

   private com.datalogics.PDFL.Duplex getDuplexMode(String mode, com.datalogics.PDFL.Page page) {
      com.datalogics.PDFL.Duplex duplex = com.datalogics.PDFL.Duplex.OFF;
      try {
         if (mode.equalsIgnoreCase("DUPLEX_VERTICAL")) {
            if (pageIsPortrait(page.getMediaBox())) {
               duplex = com.datalogics.PDFL.Duplex.TUMBLE_LONG;
            } else {
               duplex = com.datalogics.PDFL.Duplex.TUMBLE_SHORT;
            }
         } else if (mode.equalsIgnoreCase("DUPLEX_HORIZONTAL")) {
            if (pageIsPortrait(page.getMediaBox())) {
               duplex = com.datalogics.PDFL.Duplex.TUMBLE_SHORT;
            } else {
               duplex = com.datalogics.PDFL.Duplex.TUMBLE_LONG;
            }
         } else if (mode.equalsIgnoreCase("SIMPLEX")) {
            duplex = com.datalogics.PDFL.Duplex.OFF;
         } else if (mode.equalsIgnoreCase("DUPLEX_OFF")) {
            duplex = com.datalogics.PDFL.Duplex.OFF;
         } else if (mode.equalsIgnoreCase("DUPLEX_SHORTSIDE")) {
            duplex = com.datalogics.PDFL.Duplex.TUMBLE_SHORT;
         } else if (mode.equalsIgnoreCase("DUPLEX_LONGSIDE")) {
            duplex = com.datalogics.PDFL.Duplex.TUMBLE_LONG;
         }
      } catch (Exception e) {
         log.info("Ignored error when setting duplex. &1", e.getMessage());
      }
      return duplex;
   }

   private boolean pageIsPortrait(com.datalogics.PDFL.Rect rect) {
      return (rect.getURx() - rect.getLLx() > rect.getURy() - rect.getLLy()); // The page is standing up.
   }

   private String getTrayInfo(Element el, String attr) {
      if (el == null) {
         return "-1";
      }
      try {
         String tray = PrintAgentUtil.getChildElementVlaue(el, attr);
         if (tray != null) {
            return tray;
         }
      } catch (Exception e) {
         if (log.debug) {
            log.debug(e, "Ignored error while reading Tray info: &1", e.getMessage());
         }
         return "-1";
      }
      return "-1";
   }
   
    private void enumeratePaperSources(com.datalogics.PDFL.PrintUserParams recin,String firstTray,String restTray,String lastTray)
   {
       
         if (!firstTray.equalsIgnoreCase("-1") || !restTray.equalsIgnoreCase("-1")  || !lastTray.equalsIgnoreCase("-1") ) 
         {
             
         List enumeratePaperSources = new ArrayList();
         enumeratePaperSources = recin.enumeratePaperSources();
         String trayName; 
         
           for(int i= 0;i<enumeratePaperSources.size();i++)
           {

              trayName=(String)enumeratePaperSources.get(i);

              if( (this.firstTray == -1) && trayName.trim().toLowerCase().contains(firstTray.trim().toLowerCase()) )
              {
                 this.firstTray=recin.paperSourceIdByName((String)enumeratePaperSources.get(i));
              }

              if( (this.restTray == -1) && trayName.trim().toLowerCase().contains(restTray.trim().toLowerCase()) )
              {
                 this.restTray=recin.paperSourceIdByName((String)enumeratePaperSources.get(i));
              }

              if( (this.lastTray == -1) &&  trayName.trim().toLowerCase().contains(lastTray.trim().toLowerCase()) )
              {
                 this.lastTray=recin.paperSourceIdByName((String)enumeratePaperSources.get(i));
              }
              
           }  
       
         }
         
           if(this.firstTray == -1)
           {
               try
               {
                   this.firstTray = Integer.valueOf(firstTray).intValue();
               }
               catch(Exception ex)
               {
                   log.error("Error Setting firstTray ,value="+firstTray);
               }
           }
           
           if(this.restTray == -1)
           {
               try
               {
                   this.restTray = Integer.valueOf(restTray).intValue();
               }
               catch(Exception ex)
               {
                   log.error("Error Setting restTray ,value="+firstTray);
               }
           }
           
           if(this.lastTray == -1)
           {
               try
               {
                   this.lastTray = Integer.valueOf(lastTray).intValue();
               }
               catch(Exception ex)
               {
                   log.error("Error Setting lastTray ,value="+firstTray);
               }
           }
   }
}
