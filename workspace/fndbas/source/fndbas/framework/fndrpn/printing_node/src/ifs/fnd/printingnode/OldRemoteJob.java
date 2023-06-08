/*
 * RemoteJob.java
 *
 * Modified:
 *    madrse  2008-Feb-14 - Rewritten to use java access provider
 *    asiwlk  2009-july-8 - Corrected the number of pages printed with tray options		
 *    madilk  2010-Oct-21 - 93483 - Print Agent ignores the selection of pages to print as set in the Print Report dialog
 *    hamalk  2011-mar-14 - Print Order Problem
 *    NaBaLK  2012-09-13  - Corrections to support individual settings from Print Dialog (Bug#104774)
 *    CHAALK  2015-06-30  - Patch Merge - Print jobs failing in Print Agent intermittently (Bug#121794) 
 *	   MADILK  2016-12-14  - TEREPORT-2326 - Merging 132493 - Invalid values for copies, printFrom and printTo options hang the Print Agent
 *    CHAALK  2017-Jul-06 - Remove jdom and use org.w3c.dom conversion
 */

package ifs.fnd.printingnode;

import ifs.fnd.log.*;
import ifs.fnd.base.*;
import ifs.fnd.record.*;
import ifs.fnd.util.Str;

import ifs.client.application.remoteprintingnode.*;
import ifs.client.application.pdfarchive.*;
import ifs.client.application.printjobcontents.*;
import ifs.client.application.reportpdfinsert.*;

import ifs.fnd.printingnode.printagentutility.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Element;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;

import java.io.*;
import java.util.*;

import com.datalogics.apdfl.jni.*;


/*
 * Class representing a remote printing job.
 */
class OldRemoteJob implements PDFLConstants{

   private Logger log = LogMgr.getFrameworkLogger();

   private PrintJobHandler handler;

   private RemotePrintingNode node;

   private HashMap mappings;

   private int jobId;
   private int copies;
   private int pageFrom;
   private int pageTo;
   private String printerId;
   private Element printerElement;
   private String routingPrinter;
   private boolean omitJobPrinting;

   private String insertErrorMessage;
   
   private Hashtable hashNumCopies, hashPageFrom, hashPageTo;

   OldRemoteJob(int jobId, String printerId, int copies, int pageFrom, int pageTo, RemotePrintingNode node) throws IfsException {
      //Parameters copies, pageFrom, pageTo are no longer passed to PDFL but only for backward compatibility
      this.node = node;
      this.mappings = node.getMappings();
      handler = PrintJobHandlerFactory.getHandler();
      this.jobId = jobId;
      this.printerId = printerId;
      this.copies = copies;
      this.pageFrom = pageFrom;     
      this.pageTo = pageTo;
   }

   int getId() {
      return jobId;
   }
   
   public String getPrinterId() {
      return printerId;
   }

   public String toString() {
      return "[jobId=" + jobId + " printerId=" + printerId + " copies=" + copies + " pageFrom=" + (pageFrom+1) + " pageTo=" + (pageTo+1) + "]";
   }

   /**
    * The method will try to print out as many sub-jobs as possible.
    * @return the last error message or null if no errors where generated.
    */
   String perform() throws IfsException {
      int resultKey, posIndex, endPosIndex;
      int fromPageStart, fromPageEnd, toPageStart, toPageEnd;
      int printFromPage=1, printToPage=-1;
      
      String strResultKey, strCopies;
      
      if(log.trace)
         log.trace("Fetching Routing Info for job &1", String.valueOf(jobId));
      byte[] xmlInfo = handler.getRoutingInfo((double)jobId);
      if(xmlInfo != null) {
         try {
            if(log.debug)
               log.debug("Got Routing Info: &1", new String(xmlInfo));
            ByteArrayInputStream inputStream = new ByteArrayInputStream(xmlInfo);
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();               
            Document routingInfoDoc = builder.parse(inputStream);
            printerElement = getRoutingInformation(routingInfoDoc , "PRINTER");
            routingPrinter = getPrinterAddress(routingInfoDoc);
            omitJobPrinting = getOmitInformation(routingInfoDoc);
         }
         catch (Exception e) {
            log.error(e, "Error while parsing routing info: &1", e.getMessage());
         }
      }
      else if(log.debug)
         log.debug("No Routing Info found.");

      if(log.trace)
         log.trace("Querying PdfArchive for job &1", String.valueOf(jobId));
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
               arr = (PdfArchiveArray)handler.queryPdfArchive(query);
               //Retrieve the attributes for each result key in print job
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
      
      this.hashNumCopies = new Hashtable();
      this.hashPageFrom = new Hashtable();
      this.hashPageTo = new Hashtable();
      
      for (int i=0; i< pjcArr.getLength(); i++)
      {
         posIndex = -1;
         String instanceAttr = pjcArr.get(i).instanceAttr.getValue();
         resultKey = (int)pjcArr.get(i).resultKey.getValue().doubleValue();
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
         
         	if (posIndex > -1){
            	strCopies = instanceAttr.substring(posIndex+7,endPosIndex);
              	printOption = "copies=" + strCopies;
               	noOfCopies = Integer.parseInt(strCopies);
               	if(log.trace) {log.trace("PrintJob number of copies  &1", noOfCopies);};  
         	}
         
         	//Pages
         	posIndex = instanceAttr.indexOf("PAGES(");         
            if (posIndex > -1) {
            	fromPageStart = instanceAttr.indexOf("(",posIndex) + 1;
            	fromPageEnd  = instanceAttr.indexOf(",",posIndex);
            	toPageStart  = fromPageEnd +2;
            	toPageEnd  = instanceAttr.indexOf(")",posIndex);
            	if (fromPageStart == fromPageEnd + 1) {
                  	printFromPage = 0;
                  	tempStr = instanceAttr.substring(toPageStart, toPageEnd);
                  	printOption = "pageTo=" + tempStr;
                  	printToPage = Integer.parseInt(tempStr) - 1;
               	} else if (toPageStart == toPageEnd) {
                  	tempStr = instanceAttr.substring(fromPageStart, fromPageEnd);
                  	printOption = "pageFrom=" + tempStr;
                  	printFromPage = Integer.parseInt(tempStr) - 1;
                  	printToPage   = -1;
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
      }
      
      if(log.trace)
         log.trace("Fetched &1 PdfArchive row(s)", String.valueOf(arr.size()));
      boolean isSamePrinter = false;
      String physicalPrinter = (String) mappings.get(printerId);
      if(routingPrinter != null) {
         routingPrinter = (String)this.mappings.get(routingPrinter);
         isSamePrinter = physicalPrinter.equals(routingPrinter);
      }
      else
         isSamePrinter = true;
         
      if(arr.getLength()>1){
          PdfArchiveArray arr_tmp = arr;
          PdfArchive tempElement;
          double element1, element2;
          int arrayLength = arr_tmp.getLength();
          for (int i = 0; i < arrayLength; i++){        
             for (int j = arrayLength-1; j > i; j--){
              element1 = Double.parseDouble(arr_tmp.get(j-1).resultKey.toString());  
              element2 = Double.parseDouble(arr_tmp.get(j).resultKey.toString());  
                if(element1 > element2){
                  tempElement = arr_tmp.get(j);
                  arr_tmp.set(j, arr_tmp.get(j-1));
                  arr_tmp.set(j-1,tempElement);
                }
             }        
          }
          arr = arr_tmp;          
      } 
      try {
         if(!Str.isEmpty(physicalPrinter)) {

            PDJNI.PDFLInit(null, null, "..\\..\\Unicode", 0);
            PDJNI.setMemoryFS();
            int trcPageFrom, trcPageTo;
            for(int i = 0; i < arr.getLength(); i++) {
               PdfArchive arc = arr.get(i);
               FndBinary pdf = arc.pdf;
               resultKey = (int)arc.resultKey.getValue().doubleValue();
               strResultKey = String.valueOf(resultKey);
               copies = Integer.parseInt((String)this.hashNumCopies.get(strResultKey));
               pageFrom = Integer.parseInt((String)this.hashPageFrom.get(strResultKey));
               pageTo = Integer.parseInt((String)this.hashPageTo.get(strResultKey));
               if(log.trace)
               {
                  if (pageTo > -1)
                  {
                     trcPageFrom = pageFrom + 1;
                     trcPageTo = pageTo + 1;
                  }
                  else
                  {
                     trcPageFrom = pageFrom;
                     trcPageTo = pageTo;
                  }   
                  log.trace("Preparing PDF for jobId=" + arc.printJobId.toString() + " resultKey=" + arc.resultKey.toString() + " copies=" + copies + " pageFrom=" + trcPageFrom + " PageTo=" + trcPageTo);
               }
               FndBinary originalPdf = null;
               try{
                  originalPdf = (FndBinary)pdf.clone();
               }
               catch(Exception ee) {
                  log.error(ee, "Ignored error while cloning PDF: &1", ee.getMessage());
               }

               // Insert nested PDF components if defined in OPTIONS (bug 61770)
               if(printerElement != null) {
                  Element option_el = PrintAgentUtil.getChildElement(printerElement,"OPTIONS");
                  if(option_el != null) {
                     try {
                        PdfInserter inserter = new PdfInserter(pdf.getValue(), option_el);
                        pdf.setValue(inserter.getResultPdf());
                     }
                     catch(PdfInserter.InsertException e) {
                        log.error(e, "Ignored error during PDF insertion");
                        insertErrorMessage = e.getMessage();
                     }
                  }
               }

               PDDoc pdoc;
               PDDoc OriginalPdoc = null;

               ASPathName memPath = PDJNI.ASPathFromPlatformPath("PrintJob_" + jobId + ".pdf");
               ASFileHolder memFileHolder = new ASFileHolder();
               PDJNI.ASFileSysOpenFile(PDJNI.ASGetDefaultFileSys(), memPath,
                       (short) (PDFLConstants.ASFILE_READ | PDFLConstants.ASFILE_CREATE),
                       memFileHolder);
               ASFile memASFile = memFileHolder.getValue();
               /* This call makes a copy of the pdf data, so pdf is safe to
                  modify/delete subsequent to this call */
               memASFile.setFIMData(pdf.getValue());

               /* With the file now created, open an ASStm to read from this file and
                  create a PDDoc from it. */
               ASStm memFileStm = memASFile.stmRdOpen((short) 0);

               pdoc = PDJNI.PDDocOpenFromASFile(memASFile, null, true);

               ASPathName memPath1 = null;
               ASFile memASFile1 = null;
               if(!isSamePrinter){
                  memPath1 = PDJNI.ASPathFromPlatformPath("PrintJob_" + jobId + "_Orig.pdf");
                  ASFileHolder memFileHolder1 = new ASFileHolder();
                  PDJNI.ASFileSysOpenFile(PDJNI.ASGetDefaultFileSys(), memPath1,
                          (short) (PDFLConstants.ASFILE_READ | PDFLConstants.ASFILE_CREATE),
                          memFileHolder1);
                  memASFile1 = memFileHolder1.getValue();
                  memASFile1.setFIMData(originalPdf.getValue());
                  ASStm memFileStm1 = memASFile1.stmRdOpen((short) 0);
                  OriginalPdoc = PDJNI.PDDocOpenFromASFile(memASFile1, null, true);
               }

               PDFLPrintUserParamsRec rec = new PDFLPrintUserParamsRec();
               PDPrintParamsRec psParams = new PDPrintParamsRec();

               psParams.shrinkToFit = false;
               psParams.emitPS = true;
               psParams.psLevel = 2;
               psParams.emitShowpage = true;
               psParams.emitTTFontsFirst = false;
               psParams.setPageSize = false;  //changed from dll
               psParams.emitDSC = true;
               psParams.setupProcsets = true;
               psParams.emitColorSeps = false;
               psParams.binaryOK = true;
               psParams.emitRawData = false;
               psParams.TTasT42 = true;
               psParams.scale = 100;
               psParams.emitExternalStreamRef = true;
               psParams.emitHalftones = false;
               psParams.centerCropBox = true;  //changed from dll
               psParams.emitSeparableImagesOnly = false;
               psParams.emitDeviceExtGState = true;
               psParams.useFontAliasNames = false;
               psParams.emitPageRotation = false;
               psParams.reverse = false;
               psParams.emitPageClip = true;
               psParams.emitTransfer = true;
               psParams.emitBG = true;
               psParams.emitUCR = true;
               psParams.rotateAndCenter = true;
               
               // new params from dll
                 //psParams.size = sizeof(rec);
               psParams.ranges = null;				/* entire document */
               psParams.numRanges = 0;				/* ignored if ranges == NULL */
               psParams.outputType = PDOutput_PS;
               psParams.incBaseFonts = kIncludeNever;
               psParams.incEmbeddedFonts = kIncludeOncePerDoc;
               psParams.incType1Fonts = kIncludeOncePerDoc;
               psParams.incType3Fonts = kIncludeOnEveryPage;
               psParams.incTrueTypeFonts = kIncludeOncePerDoc;
               psParams.incCIDFonts = kIncludeOncePerDoc;
               psParams.incProcsets = kIncludeOncePerDoc;
               psParams.incOtherResources = kIncludeOncePerDoc;
               psParams.fontPerDocVM = 0;
               psParams.saveVM = true;
               psParams.transparencyQuality = 80;   
               psParams.bitmapResolution = 250;
               

               rec.printParams = psParams;
               rec.emitToFile = false;
               rec.emitToPrinter = true;               
               
               rec.startPage = pageFrom;
               rec.endPage   = pageTo;

               rec.cancelProc = null;
               rec.clientData = "printpdf";
// added from dll
               rec.paperWidth = -1;
               rec.paperHeight = -1;
               
               rec.inFileName = "PrintJob_" + jobId +"_"+ i + ".pdf";;
               rec.outFileName = null;
               rec.driverName = "winspool";
               rec.deviceName = physicalPrinter;
               rec.portName = "Ne04";
               rec.psLevel = 2;
               rec.shrinkToFit = 0;
               rec.binaryOK = 0;
               rec.emitHalftones = 0;
               if (copies >= 0) {
                  rec.nCopies = copies;
               }
 

               //if(!isSamePrinter && printerElement != null) {
               //
               //   PDFLPrintDoc(OriginalPdoc, rec);
               //}

               if(printerElement != null) {
                  try {
                     rec.deviceName = routingPrinter;

                     Element pel = PrintAgentUtil.getChildElement(printerElement,"OPTIONS");
                     int firstTray = getTrayInfo(pel,"TRAY_FIRST");
                     int restTray = getTrayInfo(pel,"TRAY_REST");
                     int lastTray = getTrayInfo(pel,"TRAY_LAST");

                     int dup_copies = getTrayInfo(pel,"COPIES");
                     if(dup_copies != -1)
                        rec.nCopies = dup_copies;
                     short duplexMode = getDuplexMode(pel,"DUPLEX_MODE");
                     if(duplexMode != -1)
                        rec.duplex = duplexMode;


                     if(firstTray == -1 && restTray == -1 && lastTray == -1)
                        PDFLPrintDoc(pdoc, rec);
                     if(firstTray == -1 && restTray == -1 && lastTray != -1) {
                        rec.startPage = 0 ;
                        rec.endPage = pdoc.getNumPages() -2;
                        rec.bin = 0;
                        PDFLPrintDoc(pdoc, rec);
						if (pdoc.getNumPages() >= 2) {
                        rec.startPage = pdoc.getNumPages() -1;
                        rec.endPage = pdoc.getNumPages() -1;
                        rec.bin = lastTray;
                        PDFLPrintDoc(pdoc, rec);
						}
                     }

                     if(firstTray != -1 && restTray == -1 && lastTray == -1) {
                        rec.startPage = 0 ;
                        rec.endPage = 0;
                        rec.bin = firstTray;
                        PDFLPrintDoc(pdoc, rec);

						if (pdoc.getNumPages() >= 2) {
							rec.startPage = 1 ;
							rec.endPage = pdoc.getNumPages() -1;
							rec.bin = 0;
							PDFLPrintDoc(pdoc, rec);
						}
                     }
                     if(firstTray == -1 && restTray != -1 && lastTray == -1) {
                        rec.startPage = 0 ;
                        rec.endPage = 0;
                        rec.bin = 0;
                        PDFLPrintDoc(pdoc, rec);

                        if(pdoc.getNumPages() >= 3) {
                           rec.startPage = 1 ;
                           rec.endPage = pdoc.getNumPages() -2;
                           rec.bin = restTray;
                           PDFLPrintDoc(pdoc, rec);
                        }
						
						if (pdoc.getNumPages() >= 2) {
							rec.startPage = pdoc.getNumPages() -1 ;
							rec.endPage = pdoc.getNumPages() -1;
							rec.bin = 0;
							PDFLPrintDoc(pdoc, rec);
						}
                     }
                     if(firstTray != -1 && restTray != -1 && lastTray != -1) {
                        rec.startPage = 0 ;
                        rec.endPage = 0;
                        rec.bin = firstTray;
                        PDFLPrintDoc(pdoc, rec);

                        if(pdoc.getNumPages() >= 3) {
                           rec.startPage = 1 ;
                           rec.endPage = pdoc.getNumPages() -2;
                           rec.bin = restTray;
                           PDFLPrintDoc(pdoc, rec);
                        }
						
						if (pdoc.getNumPages() >= 2) {
							rec.startPage = pdoc.getNumPages() -1 ;
							rec.endPage = pdoc.getNumPages() -1;
							rec.bin = lastTray;
							PDFLPrintDoc(pdoc, rec);
						}
                     }

                     if(firstTray != -1 && restTray == -1 && lastTray != -1) {
                        rec.startPage = 0 ;
                        rec.endPage = 0;
                        rec.bin = firstTray;
                        PDFLPrintDoc(pdoc, rec);

                        if(pdoc.getNumPages() >= 3) {
                           rec.startPage = 1 ;
                           rec.endPage = pdoc.getNumPages() -2;
                           rec.bin = 0;
                           PDFLPrintDoc(pdoc, rec);
                        }
						
						 if (pdoc.getNumPages() >= 2) {
							rec.startPage = pdoc.getNumPages() - 1;
							rec.endPage = pdoc.getNumPages() - 1;
							rec.bin = lastTray;
							PDFLPrintDoc(pdoc, rec);
						}
                     }

					 //Start Bug 84568 part2
					 if (firstTray == -1 && restTray != -1 && lastTray != -1)
					 {
						 rec.startPage = 0;
						 rec.endPage = 0;
						 rec.bin = 0;
						 PDFLPrintDoc(pdoc, rec);

						 if (pdoc.getNumPages() >= 3) {
							 rec.startPage = 1;
							 rec.endPage = pdoc.getNumPages() - 2;
							 rec.bin = restTray;
							 PDFLPrintDoc(pdoc, rec);
						 }

						 if (pdoc.getNumPages() >= 2) {

                        rec.startPage = pdoc.getNumPages() -1 ;
                        rec.endPage = pdoc.getNumPages() -1;
                        rec.bin = lastTray;
                        PDFLPrintDoc(pdoc, rec);
                     }
				 }
				 if (firstTray != -1 && restTray != -1 && lastTray == -1)
				 {
					 rec.startPage = 0;
					 rec.endPage = 0;
					 rec.bin = firstTray;
					 PDFLPrintDoc(pdoc, rec);

					 if (pdoc.getNumPages() >= 3){
						 rec.startPage = 1;
						 rec.endPage = pdoc.getNumPages() - 2;
						 rec.bin = restTray;
						 PDFLPrintDoc(pdoc, rec);
					 }

					 if (pdoc.getNumPages() >= 2){
						 rec.startPage = pdoc.getNumPages() - 1;
						 rec.endPage = pdoc.getNumPages() - 1;
						 rec.bin = 0;
						 PDFLPrintDoc(pdoc, rec);
					 }
				 }
				 //End Bug 84568 part2
                  }
                  catch(Exception ex) {
                     log.error(ex, "Exception on printing with routing: &1", ex.getMessage());
                     insertErrorMessage = "Exception on printing with routing: " + ex.getMessage();
                  }
               }
               else {
                  PDFLPrintDoc(pdoc, rec);
               }

               boolean needExtraPrinting = true;
               if(insertErrorMessage == null && omitJobPrinting)
                  needExtraPrinting = false;
               if(!isSamePrinter && printerElement != null && needExtraPrinting) {
                  rec.endPage = -1;
                  rec.deviceName = physicalPrinter;
                  if (copies >= 0)
                     rec.nCopies = copies;
                  PDFLPrintDoc(OriginalPdoc, rec);
               }


               pdoc.close();

               // Close the temporary in-memory file.
               memASFile.close();

               // Delete the temporary in-memory file.
               PDJNI.ASFileSysRemoveFile(PDJNI.ASGetDefaultFileSys(), memPath);

               // Release the path, recommended cleanup by Datalogics
               PDJNI.ASFileSysReleasePath(PDJNI.ASGetDefaultFileSys(),memPath);

               if(!isSamePrinter) {
                  OriginalPdoc.close();
                  memASFile1.close();
                  PDJNI.ASFileSysRemoveFile(PDJNI.ASGetDefaultFileSys(), memPath1);
                  PDJNI.ASFileSysReleasePath(PDJNI.ASGetDefaultFileSys(),memPath1);
               }
            }
            PDJNI.PDFLTerm();
         }
      }
      catch (PDFLException e) {
         // Both e.getMessage() and e.getCause() may be empty, use toString()
         String errMsg = e.toString();
         log.error(e, "PDFL error catched. Error message: \"&1\"", e.getMessage());
         return errMsg;
      }

      return insertErrorMessage;
   }

   private int getTrayInfo(Element el, String attr) {
      if(el == null)
         return -1;
      try {
         String tray = null;
         tray = PrintAgentUtil.getChildElementVlaue(el,attr);
         if(tray != null)
            return Integer.parseInt(tray);
      }
      catch (Exception e) {
         if(log.debug)
            log.debug(e, "Ignored error while reading Tray info: &1", e.getMessage());
         return -1;
      }
      return -1;
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
      }
      catch (Exception e) {
         if(log.debug)
            log.debug(e, "Ignored error while reading Routing info: &1", e.getMessage());
         return null;
      }
      return null;
   }

   private boolean getOmitInformation(Document routingInfoDoc) {
      try {
               Element el = PrintAgentUtil.getChildElement(routingInfoDoc,"OMIT_PRINTOUT_TO_JOB_PRINTER");
               String val = el.getTextContent().trim();
               val = ((val != null) && (val != ""))? val.trim().toUpperCase():"FALSE";
               val = val.trim().toUpperCase();
               if(val.equals("TRUE"))
                  return true;
               else
                  return false;
      }
      catch (Exception e) {
         if(log.debug)
            log.debug(e, "Ignored error while reading Omit info: &1", e.getMessage());
         return false;
      }
   }

   private String getPrinterAddress(Document routingInfoDoc) {
      try {
         Element el = PrintAgentUtil.getChildElement(routingInfoDoc,"DESTINATION");
         String channel = PrintAgentUtil.getChildElementVlaue(el,"ADDRESS");
         return channel;
      }
      catch (Exception e) {
         if(log.debug)
            log.debug(e, "Ignored error while reading printer addres: &1", e.getMessage());
         return null;
      }
   }
   
   private short getDuplexMode(Element el, String attr){
      short duplexMode = -1;
      try {
         String mode = PrintAgentUtil.getChildElementVlaue(el,attr);
         mode = mode.trim().toUpperCase();
         if(mode.equalsIgnoreCase("DUPLEX_VERTICAL"))
            duplexMode = com.datalogics.apdfl.jni.PDFLConstants.kDMDUP_VERTICAL;
         if(mode.equalsIgnoreCase("DUPLEX_HORIZONTAL"))
            duplexMode = com.datalogics.apdfl.jni.PDFLConstants.kDMDUP_HORIZONTAL;
         if(mode.equalsIgnoreCase("SIMPLEX"))
            duplexMode = com.datalogics.apdfl.jni.PDFLConstants.kDMDUP_SIMPLEX;

      }
      catch (Exception e) {
         return duplexMode;
      }
      return duplexMode;
   }

   private void PDFLPrintDoc(PDDoc doc, PDFLPrintUserParamsRec rec) throws PDFLException{
      int tries = 0;
      while(true)
         try{
            PDJNI.PDFLPrintDoc(doc, rec);
            return;
         }
         catch (PDFLException e) {
            // Retry functionallity
            if(tries<node.printRetries){
               tries++;
               if(log.trace)
                  log.trace("Failed to print!");            
               if(log.trace)
                  log.trace("Retrying: &1", String.valueOf(tries));            
               try {
                  Thread.sleep(1000 * node.pollTime); 
               }
               catch (InterruptedException ie) {
                  if(log.trace)
                     log.trace("Sleep interupted: &1", ie.getMessage());
               }
            }else{
               throw e;
            }
         }
   }
}

