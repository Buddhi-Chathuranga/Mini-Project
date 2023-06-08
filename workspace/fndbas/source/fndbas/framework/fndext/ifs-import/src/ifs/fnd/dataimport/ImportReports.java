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
 * File        : ImportReports.java
 * Description :
 * Notes       :
 * ----------------------------------------------------------------------------
 * Created
 *   MUNALK 2005-Oct-27 - Created.
 *   MADRSE 2012-Apr-16 - RDTERUNTIME-2112: Run database tasks using current value of directory ID for application owner
 *   CHAALK 2017-Oct-20 - Patch merge Bug 138391
 *   CHAALK 2018-Jun-08 - Could not generate report Database Exception error when previewing reports (Bug# 142407)
 *   CHAALK 2019-Feb-28 - Bug 147162 : IFS Report Designer reports show standard reports in Italics font due to corrupted userconfig file
 *   CHAALK 2020-Feb-03 - Modified to remove sta jar useage  and make import depending on folder exists rather than selecting from installer
 * ----------------------------------------------------------------------------
 *
 * 2016/02/18   CHAALK Fixed bug 127411
 * Exception in adding Sazanami Gothic Font Styles error seen in install log
 *
 * 2015/11/23   CHAALK  Fixed bug 125843
 * Font mapping doesn't work for Sazanami Gothic font
 *
 * 2015/09/28   NaBaLK  Bug#124773
 * Avoid deleting Font config XML files until created correctly
 *
 * 2015/09/19   NaBaLK
 * Import Base fonts only when missing
 *
 * 2015/08/28   NaBaLK
 * Simplified Font Implementation support
 *
 * Revision 1.13 2012/02/20 11:00 chaalk
 * "Font_name is not found or can't be created" error shown for imported ttc files - bugID 101324
 *
 * Revision 1.13  2011/05/13 16:58:00  lakrlk
 * IFS branding Automation of Company Logo installation -bugID 92542
 *
 * Revision 1.12  2011/03/11 16:56:00  lakrlk
 * EACS-1957: Update SVN with RPL Import Installer files.
 *
 * Revision 1.11  2010/07/26 16:39:00  subslk
 * EACS-905: Delivery1 for EAGLE core
 *
 * Revision 1.10  2010/04/21 16:58:00  subslk
 * Added new method to remove duplicate entries from userconfig file - bugId 88755
 *
 * Revision 1.10  2010/06/07 16:39:00  subslk
 * Modified code support the RDL report title and page format
 *
 * Revision 1.9  2010/05/14 11:39:00  subslk
 * Modified code to solve the compatible issues with Java 1.5
 *
 * Revision 1.9  2010/04/09 14:03:00  subslk
 * Update Font instalation - bugId 89348
 *
 * Revision 1.8  2009/05/27 16:17:00  subslk
 * Update Font instalation.  - bugId 81573
 *
 * Revision 1.7  2009/05/26 16:17:00  subslk
 * Update Font instalation.  - bugId 82755
 *
 * Revision 1.6  2005/11/03 08:54:28  jehuse
 * Updated Report Definition entity -  Changed attribute Schema to SchemaData
 *
 * Revision 1.5  2005/11/01 10:34:15  munalk
 * support report font instalation.
 *
 * Revision 1.4  2005/11/01 04:27:06  munalk
 * Temporally remove importing report fonts.
 *
 * Revision 1.3  2005/10/31 10:25:45  munalk
 * support report font instalation.
 *
 * Revision 1.2  2005/10/31 09:13:40  munalk
 * support report font instalation.
 *
 * Revision 1.1  2005/10/27 09:09:56  munalk
 * Task to import reports
 *
 *
 *
 */
package ifs.fnd.dataimport;

import org.w3c.dom.*;

import java.io.*;
import java.util.*;
import java.util.regex.*;
import java.awt.Font;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;



public class ImportReports {
   
   static final String dbA4 = "A4";
   static final String dbLetter = "LETTER";
   static final String dbOther = "OTHER";
   static final String dbDynamic = "DYNAMIC";

   static final String clientA4 = "A4";
   static final String clientLetter = "Letter";
   static final String clientOther = "Other";
   static final String clientDynamic = "Dynamic A4/Letter";

   static final String dbLayoutOther = "OTHER";
   static final String dbLayoutDesigner = "DESIGNER";
   static final String dbLayoutCrystal = "CRYSTAL";
   
   /* Mandatory file path to the config file directory */
   private String debugFilePath = null;
   /* Mandatory file path to report directory */
   private String reportDir = null;
   /* Default is "false". Setting this to "true" implies setting failonerror to "false" */
   private boolean quiet = false;
   /* Instance 1st used for updating base image path in fnd_settings  */
   private boolean importReportLayouts = true;
   private boolean importReportSchemas = true;
   private boolean importReportFonts = true;
   // By passing false to includeFontFileImports we can only update the userconfig.xml to include font details in other locations (e.g. jar file)
   private boolean includeFontFileImports = true;
   private OutputMessageStream debugStream = null;
   private boolean isFontFileNew;
   private String loginId;
   private String password;
   private String connectString;


   Connection conn = null;

   private static final String stmt_REMOVELAYOUTDIRECT =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Layout_API.Remove_Layout_Direct(:LayoutName);\n"
        + "END;";

   private static final String stmt_GETLAYOUTCOUNT =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Layout_API.Get_Layout_Count(:LayoutName, :ReportId, :LayoutCount);\n"
        + "END;";

   private static final String stmt_IMPORTLAYOUT =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Layout_API.Import_Layout(:ReportId, :LayoutName, :DataSize, :Layout, :LayoutVersion, :RetValue);\n"
        + "END;";    
   
   private static final String stmt_REMOVECRLAYOUT =
     "DECLARE \n"
        + "BEGIN \n"
        + "	:LayoutRemoved := Report_Layout_Cr_API.Remove_Layout(:ReportId, :LayoutName, :Language);\n"
        + "END;";    
      
   private static final String stmt_IMPORTCRLAYOUT =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Layout_Cr_API.Import_Layout(:ReportId, :LayoutName, :Language, :DataSize, :Layout, :LayoutVersion, :RetValue);\n"
        + "END;"; 

   private static final String stmt_ISLAYOUTDEFINITIONEXISTS =
     "DECLARE \n"
        + "BEGIN \n"
        + "	:LayoutExists := Report_Layout_Definition_API.Check_Definition_Exist(:ReportId, :LayoutName);\n"
        + "END;";    

   private static final String stmt_GETLAYOUTTITLE =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Layout_Definition_API.Get_Layout_Title(:ReportId, :LayoutName, :LayoutTitle);\n"
        + "END;"; 

   private static final String stmt_ADDLAYOUTDEFINITION =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Layout_Definition_API.Add_Layout(:ReportId, :LayoutName, :LayoutTitle, :OrderBy, :PaperFormat, :InUse, :LayoutType, :DesignTime);\n"
        + "END;"; 

   private static final String stmt_MODIFYLAYOUTDEFINITION =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Layout_Definition_API.Modify_Layout_Definition(:ReportId, :LayoutName, :LayoutTitle, :PaperFormat, :RetValue, :PaperFormatDb);\n"
        + "END;";

   private static final String stmt_REMOVESCHEMALAYOUTS =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Schema_API.Remove_Schema_And_Layouts(:ReportId, :LayoutList, :RetValue );\n"
        + "END;";

   private static final String stmt_IMPORTSCHEMA =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Schema_API.Import_Schema(:ReportId, :DataSize, :Schema, :SchemaVersion, :RetValue);\n"
        + "END;";    

   private static final String stmt_UPDATEREPORTFONT =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Font_API.Update_Report_Font(:FontName, :IsBase);\n"
        + "END;";    

   private static final String stmt_UPDATEFONTDEFINITION =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Font_Definition_API.Update_Font_Definition(:FontName, :FileName, :Font, :IsBase, :IsNewFont);\n"
        + "END;";    

   private static final String stmt_UPDATEFONTSTYLE =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Font_Style_API.Update_Font_Style(:FontName, :FileName, :Style, :IsBase);\n"
        + "END;";    

   private static final String stmt_UPDATESAZANAMIFONTSTYLE =
     "DECLARE \n"
        + "BEGIN \n"
        + "	Report_Font_Style_API.Update_Sazanami_Gothic_Style();\n"
        + "END;";  
   
   private static final String stmt_IMPORTCRQRLAYOUT =
     "DECLARE \n"
        + "BEGIN \n"
        + " Report_Layout_Cr_Qr_API.Add_New_Layout(:LayoutName, :Layout);\n"
        + "END;";

   private static final String stmt_REMOVECRQRLAYOUT =
     "DECLARE \n"
        + "BEGIN \n"
        + " :LayoutRemoved := Report_Layout_Cr_Qr_API.Remove_Layout(:LayoutName);\n"
        + "END;";
   
   private static final String stmt_IMPORTCRQRDEFINITION =
     "DECLARE \n"
        + "BEGIN \n"
        + " Quick_Report_API.Import_Reports__(:ImportXML);\n"
        + "END;";
    

   /**
    * Creates a new instance of DbMergeFilesTask
    * @param connectString
    * @param loginId
    * @param password
    * @param reportDir
    * @param debugFilePath
    * @param quiet
    */
   public ImportReports(String connectString, String loginId, String password, String reportDir, String debugFilePath) {
      this.connectString = connectString;
      this.loginId = loginId; 
      this.password = password;
      this.reportDir = reportDir;
      this.debugFilePath = debugFilePath + "/" + "import_reportFiles.log";
   }   
   
   public void execute() throws ImportException {
      boolean error1 = false;
      boolean error2 = false;
      boolean error3 = false;
      boolean error4 = false;
      try {

         //-------------------------------------
         //  Validatate prerequisites
         //-------------------------------------
         if (reportDir == null || (reportDir != null && reportDir.length() == 0)) {
            throw new ImportException("WARNING: IMPORT: Mandatory report path is Null.");
         }

         //---------------------------------------
         //  Create the database application
         //---------------------------------------

         if (debugFilePath != null) {
            File file = new File(debugFilePath);
            debugStream = new OutputMessageStream(new FileOutputStream(file, true));
            System.setErr(debugStream);
            logNewLine();
         }

         if (includeFontFileImports){
            logInfo("### Report initializing... ###");
         }
         logInfo("Trying to connect to the database");
         Properties props = new Properties();
         props.setProperty("user", loginId);
         props.setProperty("password", password);
         conn = DriverManager.getConnection(connectString, props);
         conn.setAutoCommit(true);
         try {
            if (conn.isClosed()) {
               throw new ImportException("ERROR: No connection to the database could be established (1)! Connect string " + connectString);
            }
         }
         catch (Exception e) {
            throw new ImportException("ERROR: No connection to the database could be established (2)! Connect string " + connectString);
         }
         logInfo("Connected successfull");

         java.sql.Date date = new java.sql.Date(new java.util.Date().getTime());
         FileInputStream fis;
         int schemasSkipped = 0;
         int layoutsSkipped = 0;
         int schemasImported = 0;
         int layoutsImported = 0;
         String message = "";
         String errorFiles = "";

         java.io.File repDirFile = new java.io.File(reportDir);
         if (!repDirFile.exists()) {
            logInfo(reportDir + " does not exist. Please ignore this message if you do not have any layouts to import in your delivery." ) ;
            return;
         }
         //Import items if there are items in the folders
         setImportLayouts(reportDir);
         setImportSchemas(reportDir);
         setImportFonts(reportDir);            
         //---------------------------------------
         //  Import Schema
         //---------------------------------------
         if (importReportSchemas) {
            error1 = importSchema();
         }


         //---------------------------------------
         //  Import layouts
         //---------------------------------------
         if (importReportLayouts) {
            error2 = importLayouts();
         }

         //---------------------------------------
         //  Import Font
         //---------------------------------------

         //Always import base fonts files (inside reports\fonts\base\ttf)
         logNewLine();
         logInfo("### Importing Base Font Files... ###");
         error3 = importFontFiles(reportDir + File.separator + "fonts" + File.separator + "base" + File.separator + "ttf", "ttf", true);

         if (importReportFonts) {
            if (includeFontFileImports){
               error3 = importFontDefinition(reportDir + File.separator + "fonts") == true ? true : error3;
            }
            else{
               error3 = importFontDefinition(reportDir) == true ? true : error3;
            }
         }
         try{
            logInfo("### Creating Font Matrix Files And Report Font Config File... ###");
            ReportFontUtil reportFontUtil = new ReportFontUtil(conn, debugStream);          
            error3 = reportFontUtil.createXMLFiles("*") == true ? true : error3;
         }
         catch (Exception e)
         {
            logInfo("Error on creating config XML files: " + e.getMessage());
            error3 = true;
         }
      } catch (Exception ee) {
         if (includeFontFileImports){
            logInfo("Error on importing Reports : " + ee.getMessage());
         }
         else{
            logInfo("Error on importing external fonts : " + ee.getMessage());
         }
         error3 = true;
         if(conn!=null) {
            logInfo(ee.getCause().getMessage());
            logInfoFail();
         }
         if (!quiet) {
            throw new ImportException(ee.getMessage());
         }
      } finally {
         if(conn!=null) {
            try {
               conn.close();
               conn = null;
               logNewLine();
               logInfo("Database connection successfull closed");
            }
            catch (Exception e) {
               logInfo("Error closing database connection.");
               logInfo("Error: " + e.getMessage());
            }
         }

         if (includeFontFileImports){
            if (error1 || error2 || error3 || error4) {
               logInfoFail();
               throw new ImportException("WARNING: IMPORT: Error has occurred while importing Reports data (See log file).");
            } else {
               logInfoSuccess();
            }
         }
         if (debugStream != null) {
            debugStream.close();
         }
      }
   }
    
   private boolean importLayouts() {
      boolean error = false;
      boolean newrdl = false;
      boolean newrpl = false;
      CallableStatement pstmt = null;
      logNewLine();
      logInfo("### Importing Layout's... ###");

      java.io.File layoutDirFile = new java.io.File(reportDir + "//layouts");
      if (!layoutDirFile.exists()) {
         logInfo(layoutDirFile + " does not exist. Please ignore this message if you do not have any layouts to import in your delivery.");
      } else {
         String[] suffixtypes = {".XSL", ".RDL", ".RPL"};
         java.io.File[] xslFiles = layoutDirFile.listFiles(new SuffixFilters(suffixtypes));

         for (int i = 0; i < xslFiles.length; i++) {
            String reportId = null;
            String[] reportIdList = {""};
            newrdl = false;
            newrpl = false;
            String reportTitle = null;
            String combined = null;
            double reportHight = 0.0;
            double reportWidth = 0.0;
            int minAllowedXslSize = 350; //this is the minimum allowed file size in bytes.
            if (xslFiles[i].length() < minAllowedXslSize) {
               try {
                  int layoutCount = 0;
                  pstmt = null;
                  try{
                     pstmt = conn.prepareCall(stmt_GETLAYOUTCOUNT);
                     pstmt.setString(1, xslFiles[i].getName());
                     pstmt.setString(2, null);
                     pstmt.registerOutParameter(3, java.sql.Types.INTEGER);
                     pstmt.execute();
                     layoutCount = pstmt.getInt(3);
                  }
                  catch (Exception e) {
                     logInfo("Could not get layout count for file " + xslFiles[i].getName() + e.getMessage());
                     continue;
                  }
                  finally{
                     closeStatement(pstmt,"getting layout count.");
                     pstmt = null;
                  }

                  if (layoutCount == 1) {
                      try {
                         pstmt = conn.prepareCall(stmt_REMOVELAYOUTDIRECT);
                         pstmt.setString(1, xslFiles[i].getName());
                         pstmt.execute();
                      } catch (Exception e) {
                          logInfo("ERROR : Exception when removing layout " + xslFiles[i].getName() + " " + e.getMessage());
                      }
                      finally{
                         closeStatement(pstmt,"removing layout.");
                         pstmt = null;
                      }

                      logInfo("File " + xslFiles[i].getName() + " was found to be smaller than " + minAllowedXslSize + " bytes. - layout was removed");
                      continue;
                  } else if (layoutCount == 0) {   
                      logInfo("File " + xslFiles[i].getName() + " was found to be smaller than " + minAllowedXslSize + " bytes. - layout was not imported");
                      continue;
                  } else {
                      logInfo("File " + xslFiles[i].getName() + " was found to be smaller than " + minAllowedXslSize + " bytes. - layout was not imported");
                      logInfo("Multiple layouts with this layout name were found. Couldn't identify the obsolete report. - existing database entries left unchanged");
                      continue;
                  }
               } catch (Exception e) {
                   logInfo("File " + xslFiles[i].getName() + " smaller than " + minAllowedXslSize + "bytes and unable to delete layout:\n" + e.getMessage());
                   continue;
               }
            }

            Document xsl;
            try {
               xsl = XmlUtil.parse(xslFiles[i]);
               if (xslFiles[i].getName().indexOf(".xsl") > 0) { // check if the file is an xsl file
                  NodeList elements = xsl.getDocumentElement().getElementsByTagName("xsl:template");
                  if (elements.getLength() == 0) {
                     logInfo("ERROR: Could not find 'template' element in file " + xslFiles[i].getName() + "\n");
                     error = true;
                     continue;
                  }
                  reportId = elements.item(0).getAttributes().getNamedItem("match").getNodeValue();
                  Pattern p = Pattern.compile("tns:(.*)_REQUEST");
                  Matcher m = p.matcher(reportId);
                  m.find();
                  reportId = m.group(1);
               } else if (xslFiles[i].getName().indexOf(".rdl") > 0) {

                  String propertyname = "";
                  String propertyvalue = "";

                  Element documentele = xsl.getDocumentElement();
                  NodeList elements = xsl.getDocumentElement().getElementsByTagName("report-id");
                  NodeList eletitle = xsl.getDocumentElement().getElementsByTagName("report-title");
                  NodeList elecomb = xsl.getDocumentElement().getElementsByTagName("combined");

                  NodeList properties = xsl.getDocumentElement().getElementsByTagName("properties").item(0).getChildNodes();

                  for (int j = 0; j < properties.getLength(); j++) {
                     propertyname = properties.item(j).getNodeName();
                     propertyvalue = properties.item(j).getTextContent();
                     if ("height".equals(propertyname)) {
                        reportHight = getNumericValue(propertyvalue);
                     }
                     if ("width".equals(propertyname)) {
                        reportWidth = getNumericValue(propertyvalue);
                     }
                  }

                  if (elements.getLength() == 1) {
                     reportId = elements.item(0).getTextContent();
                  } else {
                     logInfo("ERROR: " + elements.getLength() + "Can not find proper 'report-id' element  in  file " + xslFiles[i].getName() + "\n");
                     error = true;
                     continue;
                  }
                  if (eletitle.getLength() == 1) {
                     reportTitle = eletitle.item(0).getTextContent();
                  } else {
                     logInfo(eletitle.getLength() + "Can not find proper 'report-title' element  in  file " + xslFiles[i].getName() + "\n");
                     reportTitle = null;
                  }
                  if (elecomb.getLength() == 1) {
                     combined = elecomb.item(0).getTextContent();
                  } else {
                     combined = null;
                  }

                  if (reportTitle == null || reportTitle.equals("")) {
                     // database check for similar xsl report title
                     try {
                        String xsllayoutname = xslFiles[i].getName();
                        xsllayoutname = xsllayoutname.substring(0, xsllayoutname.indexOf(".rdl") + 1) + "xsl";
                        pstmt = conn.prepareCall(stmt_GETLAYOUTTITLE);
                        pstmt.setString(1, reportId.toUpperCase());
                        pstmt.setString(2, xsllayoutname);
                        pstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
                        pstmt.execute();
                        reportTitle = pstmt.getString(3);

                        if (reportTitle == null || reportTitle.equals("")) {
                           reportTitle = (reportHight > reportWidth) ? "Portrait" : "Landscape";
                        }
                     } catch (Exception ex) {
                        logInfo("Unable to retrieve layout title from the database ,Default title used for the layout" + xslFiles[i].getName() + "\n");
                        reportTitle = (reportHight > reportWidth) ? "Portrait" : "Landscape";
                     }
                     finally{
                        closeStatement(pstmt,"getting layout title.");
                        pstmt = null;
                     }

                  }

                  //if new rdl  then create report definition
                  int layoutCount = 0;
                  pstmt = conn.prepareCall(stmt_GETLAYOUTCOUNT);
                  pstmt.setString(1, xslFiles[i].getName());
                  pstmt.setString(2, reportId.toUpperCase());
                  pstmt.registerOutParameter(3, java.sql.Types.INTEGER);
                  pstmt.execute();
                  layoutCount = pstmt.getInt(3);
                  closeStatement(pstmt,"getting RPL layout count - line 1");
                  pstmt = null;                        
                  if (layoutCount == 0){
                     newrdl = true;
                  }

                  if (newrdl) {
                     try {
                        String paperFormat = "A4";
                        if ((reportHight == 29.7 && reportWidth == 21) || (reportHight == 21 && reportWidth == 29.7)) {
                           paperFormat = dbA4;
                        } else if ((reportHight == 27.94 && reportWidth == 21.59) || (reportHight == 21.59 && reportWidth == 27.94)) {
                           paperFormat = dbLetter;
                        } else if (((reportHight == 27.94 && reportWidth == 21) || (reportHight == 21 && reportWidth == 27.94)) && combined != null) {
                           paperFormat = dbDynamic;
                        } else {
                           paperFormat = dbOther;
                        }
                        pstmt = conn.prepareCall(stmt_ADDLAYOUTDEFINITION);
                        pstmt.setString(1, reportId.toUpperCase());
                        pstmt.setString(2, xslFiles[i].getName());
                        pstmt.setString(3, reportTitle);
                        pstmt.setString(4, null);
                        pstmt.setString(5, paperFormat.toUpperCase());
                        pstmt.setString(6, "TRUE");
                        pstmt.setString(7, dbLayoutDesigner.toUpperCase());
                        pstmt.setString(8, "TRUE");
                        pstmt.execute();
                        logInfo("New RDL Report definition created from file " + xslFiles[i].getName());
                        newrdl = false;
                     } catch (Exception e) {
                        logInfo("Error :Unable to add new RDL report layout definition " + xslFiles[i].getName() + " : " + e.toString());
                     }
                     finally{
                        closeStatement(pstmt,"adding new RDL layout definition.");
                        pstmt = null;
                     }                            
                  }
               } else if (xslFiles[i].getName().indexOf(".rpl") > 0) {
                  //deal with importing rpl files.
                  Element documentele = xsl.getDocumentElement();
                  NodeList eleid = xsl.getDocumentElement().getElementsByTagName("report-id");
                  NodeList eletitle = xsl.getDocumentElement().getElementsByTagName("report-title");

                  if (eleid.getLength() == 1) {  // if report_id missing  report is not imported
                     reportId = eleid.item(0).getTextContent();
                  } else {
                     logInfo("ERROR: " + eleid.getLength() + "Can not find proper 'report-id' element  in  file " + xslFiles[i].getName() + "\n");
                     error = true;
                     continue;
                  }
                  if (eletitle.getLength() == 1) {
                     reportTitle = eletitle.item(0).getTextContent();
                  } else {
                     logInfo(eletitle.getLength() + "Can not find proper 'report-title' element  in  file " + xslFiles[i].getName() + "\n");
                     reportTitle = null;
                  }
                  if (reportTitle == null || reportTitle.equals("")) {
                     // database check for similar rdl report title
                     try {
                        String xsllayoutname = xslFiles[i].getName();
                        xsllayoutname = xsllayoutname.substring(0, xsllayoutname.indexOf(".rpl") + 1) + "rdl";// Check if similar rdl reports are available in the  database
                        pstmt = conn.prepareCall(stmt_GETLAYOUTTITLE);
                        pstmt.setString(1, reportId.toUpperCase());
                        pstmt.setString(2, xsllayoutname);
                        pstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
                        pstmt.execute();
                        reportTitle = pstmt.getString(3);

                        if (reportTitle == null || reportTitle.equals("")) {
                           reportTitle = "Other";
                        }                                
                     } catch (Exception ex) {
                        logInfo("Unable to retrieve report title from the database ,Default title used for the layout" + xslFiles[i].getName() + "\n");
                        reportTitle = "Other";
                     }
                     finally{
                        closeStatement(pstmt,"getting RPL layout title");
                        pstmt = null;
                     }                            
                  }


                  if (reportId.indexOf(",")>0)
                     reportIdList = reportId.split(","); // Some RPLs might contain multiple reportIds (comma separated)
                  for(int loop=0;loop<reportIdList.length;loop++){
                     if(!reportIdList[loop].isEmpty())
                        reportId = reportIdList[loop];
                     try { // check if the layout already imported in database - may be in a reconfiguration
                        logInfo("Query database for  report layout :" + xslFiles[i].getName() + "\n ");
                        int layoutCount = 0;
                        pstmt = conn.prepareCall(stmt_GETLAYOUTCOUNT);
                        pstmt.setString(1, xslFiles[i].getName());
                        pstmt.setString(2, reportId.toUpperCase());
                        pstmt.registerOutParameter(3, java.sql.Types.INTEGER);
                        pstmt.execute();
                        layoutCount = pstmt.getInt(3);                            
                        if (layoutCount == 0){
                           newrpl = true;
                        }
                     } catch (Exception e) {
                        logInfo("File" + xslFiles[i].getName() + " No layouts with this layout name were found.");
                        continue;
                     }
                     finally{
                        closeStatement(pstmt,"getting RPL layout count");
                        pstmt = null;
                     }                        

                     if (newrpl) {
                        try {
                           pstmt = conn.prepareCall(stmt_ADDLAYOUTDEFINITION);
                           pstmt.setString(1, reportId.toUpperCase());
                           pstmt.setString(2, xslFiles[i].getName());
                           pstmt.setString(3, reportTitle);
                           pstmt.setString(4, null);
                           pstmt.setString(5, dbOther.toUpperCase());
                           pstmt.setString(6, "TRUE");
                           pstmt.setString(7, dbLayoutOther.toUpperCase());
                           pstmt.setString(8, "TRUE");
                           pstmt.execute();
                           logInfo("New RPL Report layout definition for report " +reportId+" created from file " + xslFiles[i].getName() + "\n");
                           newrpl = false;
                        } catch (Exception e) {
                           logInfo("Error :Unable to add new report layout definition " + xslFiles[i].getName() + " : " + e.toString());
                        }
                        finally{
                           closeStatement(pstmt,"adding new RPL layout definition");
                           pstmt = null;
                        }
                     }
                  }
               } else {
                  logInfo("ERROR: File format not recognized for file " + xslFiles[i].getName() + "\n ");
                  error = true;
                  continue;

               }
            }
            catch (java.lang.Exception ex) {
               logInfo("ERROR: Could not parse file " + xslFiles[i].getName() + "\n" + ex.getMessage());
               error = true;
               continue;
            }
            int dataSize = (int) xslFiles[i].length();
            String retValue;
            String paperFormat;
            for(int loop=0;loop<reportIdList.length;loop++){
               if(!reportIdList[loop].isEmpty())
                  reportId = reportIdList[loop];

               try {
                  int layoutCount = 0;
                  pstmt = conn.prepareCall(stmt_GETLAYOUTCOUNT);
                  pstmt.setString(1, xslFiles[i].getName());
                  pstmt.setString(2, reportId.toUpperCase());
                  pstmt.registerOutParameter(3, java.sql.Types.INTEGER);
                  pstmt.execute();
                  layoutCount = pstmt.getInt(3);   
                  closeStatement(pstmt,"getting layout count - line 2");
                  pstmt = null;                                            

                  if (layoutCount > 0){
                     //adding paper format
                     paperFormat = null;
                     if ((reportHight == 29.7 && reportWidth == 21) || (reportHight == 21 && reportWidth == 29.7)) {
                         paperFormat = dbA4;
                     } else if ((reportHight == 27.94 && reportWidth == 21.59) || (reportHight == 21.59 && reportWidth == 27.94)) {
                         paperFormat = dbLetter;
                     } else if (((reportHight == 27.94 && reportWidth == 21) || (reportHight == 21 && reportWidth == 27.94)) && combined != null) {
                         paperFormat = dbDynamic;
                     } else {
                         paperFormat = dbOther;
                     }
                     retValue = null;
                     pstmt = conn.prepareCall(stmt_MODIFYLAYOUTDEFINITION);
                     pstmt.setString(1, reportId.toUpperCase());
                     pstmt.setString(2, xslFiles[i].getName());
                     pstmt.setString(3, reportTitle);
                     pstmt.setString(4, null);
                     pstmt.registerOutParameter(5, java.sql.Types.VARCHAR);
                     pstmt.setString(6, paperFormat);
                     pstmt.execute();
                     retValue = pstmt.getString(5);
                     closeStatement(pstmt,"updating layout definition");
                     pstmt = null;                                                

                     if ("OVERWRITE".equals(retValue)){
                        logInfo(reportId + " (" + xslFiles[i].getName() + ") " + " layout was locked and therefore layout definition was not updated.");
                     }
                     else if ("LAYOUTNULL".equals(retValue)){
                        logInfo(reportId + " (" + xslFiles[i].getName() + ") " + " layout title is null and therefore layout definition was not updated.");
                     }
                     else if ("NOT_FOUND".equals(retValue)){
                        logInfo(reportId + " (" + xslFiles[i].getName() + ") " + " layout definition does not exists.");
                     }
                     else if ("UPDATED".equals(retValue)){
                        logInfo(reportId + " (" + xslFiles[i].getName() + ") " + " layout definition was overwritten : title and format = " + reportTitle + " , " + paperFormat);
                     }
                     else {
                        logInfo("ERROR: error with modifying existing RDL layout definition " + xslFiles[i].getName());
                        error = true;
                        continue;
                     }

                     byte[] xmlInBytes = readFile(xslFiles[i]);
                     retValue = null;
                     int layoutVersion = 0;
                     pstmt = conn.prepareCall(stmt_IMPORTLAYOUT);
                     pstmt.setString(1, reportId.toUpperCase());
                     pstmt.setString(2, xslFiles[i].getName());
                     pstmt.setInt(3, dataSize);
                     pstmt.setBlob(4, readBytes(xmlInBytes));
                     pstmt.registerOutParameter(5, java.sql.Types.INTEGER);                        
                     pstmt.registerOutParameter(6, java.sql.Types.VARCHAR);
                     pstmt.execute();
                     layoutVersion = pstmt.getInt(5);
                     retValue = pstmt.getString(6);
                     closeStatement(pstmt,"updating layout");
                     pstmt = null;                                                
                     if ("MODIFY".equals(retValue.toUpperCase())){
                        logInfo(reportId + " (" + xslFiles[i].getName() + ") " + " layout was overwritten : New version = " + layoutVersion + "\n");
                     }
                     else {
                        logInfo("There was an error in overwritten the layout " +  xslFiles[i].getName() + " for report ID " + reportId);
                     }
                  } else {
                     byte[] xmlInBytes = readFile(xslFiles[i]);
                     retValue = null;
                     int layoutVersion = 0;
                     pstmt = conn.prepareCall(stmt_IMPORTLAYOUT);
                     pstmt.setString(1, reportId.toUpperCase());
                     pstmt.setString(2, xslFiles[i].getName());
                     pstmt.setInt(3, dataSize);
                     pstmt.setBlob(4, readBytes(xmlInBytes));
                     pstmt.registerOutParameter(5, java.sql.Types.INTEGER);                        
                     pstmt.registerOutParameter(6, java.sql.Types.VARCHAR);
                     pstmt.execute();
                     layoutVersion = pstmt.getInt(5);
                     retValue = pstmt.getString(6);
                     closeStatement(pstmt,"importing layout");
                     pstmt = null;                                                
                     if ("IMPORT".equals(retValue.toUpperCase())){
                        logInfo(reportId + " (" + xslFiles[i].getName() + ") " + " layout was imported"  + "\n");
                     }
                     else {
                        logInfo("There was an error in importing the layout " +  xslFiles[i].getName() + " for report ID " + reportId);
                     }
                  }
               } catch (Exception ee) {
                  logInfo(reportId + " (" + xslFiles[i].getName() + ") " + " layout failed to import");
                  logError("ERROR: Exception on importing Layouts : " + ee.getMessage());
                  logNewLine();
                  error = true;
                  continue;
               }
            }
         }
      }
      error = importCrystalLayout(error);
      return error;
   }
   private boolean importCrystalLayout(boolean error){
      error = importCrOrLayouts(error);
      error = importCrQrLayouts(error);
      return error;
   }
   
   private boolean importCrOrLayouts(boolean error){
      CallableStatement pstmt = null;
      boolean layoutDefExists = false;
      int minAllowedFileSize = 350; //this is the minimum allowed file size in bytes.
      java.io.File crORlayoutDir = new java.io.File(reportDir + "//layouts//crystal//operation");
      if (crORlayoutDir.exists()) {
         logNewLine();
         logInfo("### Importing Crystal Operational Report Layouts... ###");
         java.io.File[] orReportDirs = crORlayoutDir.listFiles();
         Document xsl;
         String reportId = "";
         String layoutName = "";
         String layoutTitle = "";
         String paperFormat = "";
         NodeList element = null;
         for (int i = 0; i < orReportDirs.length; i++) {
            if (orReportDirs[i].isDirectory()){
               
               try{
                  reportId = orReportDirs[i].getName().toUpperCase();
                  xsl = XmlUtil.parse(new File(orReportDirs[i].getAbsolutePath() + "//" + reportId + ".xml"));
                  element = xsl.getDocumentElement().getElementsByTagName("LAYOUT_NAME");
                  layoutName = element.getLength() == 1?element.item(0).getTextContent():"";
                  element = null;
                  //No need of continuing as layout is not there in the export xml
                  if ((layoutName == null) || (layoutName == "")){
                     logInfo("Layout name is not in export xml for report " + reportId + ".Skiping import of report.");
                     continue;
                  }
                  element = xsl.getDocumentElement().getElementsByTagName("LAYOUT_TITLE");
                  layoutTitle = element.getLength() == 1?element.item(0).getTextContent():"Crystal";
                  element = null;
                  element = xsl.getDocumentElement().getElementsByTagName("PAPER_FORMAT");
                  paperFormat = element.getLength() == 1?element.item(0).getTextContent().toUpperCase():"A4";
                  element = null;
                  
                  pstmt = conn.prepareCall(stmt_ISLAYOUTDEFINITIONEXISTS);
                  pstmt.setString(2, reportId);
                  pstmt.setString(3, layoutName);
                  pstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
                  pstmt.execute();
                  layoutDefExists = "TRUE".equals(pstmt.getString(1))?true:false;
                  closeStatement(pstmt,"getting Crystal layout definition");
                  pstmt = null;   

                  //if new layout then create report definition and import layouts
                  if (!layoutDefExists) {
                     try {
                        pstmt = conn.prepareCall(stmt_ADDLAYOUTDEFINITION);
                        pstmt.setString(1, reportId);
                        pstmt.setString(2, layoutName);
                        pstmt.setString(3, layoutTitle);
                        pstmt.setString(4, null);
                        pstmt.setString(5, paperFormat);
                        pstmt.setString(6, "TRUE");
                        pstmt.setString(7, dbLayoutCrystal.toUpperCase());
                        pstmt.setString(8, "TRUE");
                        pstmt.execute();
                        logInfo("New Crystal Report layout definition created from file " + layoutName);
                        layoutDefExists = false;
                     } catch (Exception e) {
                        logInfo("ERROR: Unable to add new Crystal report layout definition " + layoutName + " : " + e.toString());
                        error = true;
                        continue;
                     }
                     finally{
                        closeStatement(pstmt,"Adding new Crystal layout definition.");
                        pstmt = null;
                     }
                     //Add the new layouts
                     java.io.File[] orReportLayout = orReportDirs[i].listFiles();
                     for (int j = 0; j < orReportLayout.length; j++) {
                        if (orReportLayout[j].isDirectory()){
                           java.io.File currentLayout = new java.io.File(orReportLayout[j].getAbsolutePath() + "//" + layoutName);
                           if (currentLayout.length() > minAllowedFileSize){
                              error = importCrOrLayout(currentLayout, reportId, layoutName, orReportLayout[j].getName(), error);
                           }
                           //The current file size is less than the minimum allowed file size
                           //Assuming the file is obsolete and removing the file from table
                           else{
                              error = removeCrOrLayout(reportId,layoutName,orReportLayout[j].getName(),minAllowedFileSize,error);
                           }
                        }
                     }
                  //if exsisting layout then update report definition and import layouts if preventOverwrite is FALSE    
                  } else if (layoutDefExists){
                     String retValue = null;
                     switch (paperFormat.toUpperCase()) {
                        case "A4":
                           paperFormat = dbA4;
                           break;
                        case "LETTER":
                           paperFormat = dbLetter;
                           break;
                        case "OTHER":
                           paperFormat = dbOther;
                           break;
                        case "DYNAMIC":
                           paperFormat = dbDynamic;
                           break;
                        default:
                           paperFormat = dbA4;
                     }                     
                     pstmt = conn.prepareCall(stmt_MODIFYLAYOUTDEFINITION);
                     pstmt.setString(1, reportId);
                     pstmt.setString(2, layoutName);
                     pstmt.setString(3, layoutTitle);
                     pstmt.setString(4, null);
                     pstmt.registerOutParameter(5, java.sql.Types.VARCHAR);
                     pstmt.setString(6, paperFormat);
                     pstmt.execute();
                     retValue = pstmt.getString(5);
                     closeStatement(pstmt,"updating Crystal layout definition");
                     pstmt = null;                                                

                     if ("OVERWRITE".equals(retValue)){
                        logInfo(reportId + " (" + layoutName + ") " + " layout was locked with prevent overwrite and therefore layout definition was not updated.");
                     }
                     else if ("LAYOUTNULL".equals(retValue)){
                        logInfo(reportId + " (" + layoutName + ") " + " layout title is null and therefore layout definition was not updated.");
                     }
                     else if ("NOT_FOUND".equals(retValue)){
                        logInfo(reportId + " (" + layoutName + ") " + " layout definition does not exists.");
                     }
                     else if ("UPDATED".equals(retValue)){
                        logInfo(reportId + " (" + layoutName + ") " + " layout definition was overwritten : title and format = " + layoutTitle + " , " + paperFormat);
                     }
                     else {
                        logInfo("ERROR: Error when modifying existing Crystal Report layout definition for layout " + layoutName);
                        error = true;
                        continue;
                     }
                     //Update the new layouts if preventOverwrite is FALSE
                     //Even if there is a new layout it will not import if the report definition is locked
                     //We can move this check to DB but then for each layout there will be DB calls even when report definition is locked
                     //Here no DB call is made if report definition is lock
                     if (!"OVERWRITE".equals(retValue)){
                        //scan through the language folders within the report ID folder, get layout and import
                        java.io.File[] orReportLayout = orReportDirs[i].listFiles();
                        retValue = null;
                        for (int j = 0; j < orReportLayout.length; j++) {
                           if (orReportLayout[j].isDirectory()){
                              java.io.File currentLayout = new java.io.File(orReportLayout[j].getAbsolutePath() + "//" + layoutName);
                              if (currentLayout.length() > minAllowedFileSize){
                                 error = importCrOrLayout(currentLayout, reportId, layoutName, orReportLayout[j].getName(), error);
                              }
                              //The current file size is less than the minimum allowed file size
                              //Assuming the file is obsolete and removing the file from table
                              else{
                                 error = removeCrOrLayout(reportId,layoutName,orReportLayout[j].getName(),minAllowedFileSize,error);
                              }                              
                           }
                        }
                     }
                     else{
                        logInfo(reportId + " (" + layoutName + ") " + " layout definition was locked with prevent overwrite and therefore layouts were not imported/updated.");
                     }
                  }
               }
               catch (Exception e){
                  error = true;
                  logInfo("ERROR: " + e.getMessage());
               }
            }
            xsl = null;
            reportId = "";
            layoutName = "";
            layoutTitle = "";
            paperFormat = "";
            element = null; 
            layoutDefExists = false;
         }
      }
      return error;
   }
   
   private boolean importCrOrLayout(File currentLayout, String reportId, String layoutName, String language, boolean error) throws Exception{
      CallableStatement pstmt = null;
      byte[] layoutInBytes = readFile(currentLayout);
      int layoutVersion = 0;
      String retValue = null;
      pstmt = conn.prepareCall(stmt_IMPORTCRLAYOUT);
      pstmt.setString(1, reportId);
      pstmt.setString(2, layoutName);
      pstmt.setString(3, language);
      pstmt.setInt(4, (int)currentLayout.length());
      pstmt.setBlob(5, readBytes(layoutInBytes));
      pstmt.registerOutParameter(6, java.sql.Types.INTEGER);                        
      pstmt.registerOutParameter(7, java.sql.Types.VARCHAR);
      pstmt.execute();
      layoutVersion = pstmt.getInt(6);
      retValue = pstmt.getString(7);
      closeStatement(pstmt,"importing Crystal layout");
      pstmt = null;                                                
      if ("MODIFY".equals(retValue.toUpperCase())){
         logInfo(reportId + " (" + layoutName + ") " + " layout was overwritten for language " + language + ".New version = " + layoutVersion + "\n");
      }
      else if ("IMPORT".equals(retValue.toUpperCase())){
         logInfo(reportId + " (" + layoutName + ") " + " layout was imported for language " + language + "\n");
      }
      else {
         error = true;
         logInfo("ERROR: There was an error in importing/overwriting the layout " +  layoutName + " for report ID " + reportId + " for language " + language);
      }
      return error;
   }
   
   private boolean removeCrOrLayout(String reportId, String layoutName, String language, int minAllowedFileSize, boolean  error){
      try{
         CallableStatement pstmt = null;
         pstmt = conn.prepareCall(stmt_REMOVECRLAYOUT);
         pstmt.setString(2, reportId);
         pstmt.setString(3, layoutName);
         pstmt.setString(4, language);
         pstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
         pstmt.execute();
         String retValue = pstmt.getString(1);
         if ("TRUE".equals(retValue)){
            logInfo("File " + layoutName + " for language " + language + " was found to be smaller than " + minAllowedFileSize + " bytes. - layout was removed");
         }
      }
      catch (Exception e) {
         error = true;
         logInfo("ERROR: Exception when removing crystal layout " + layoutName + " for language " + language + ". " + e.getMessage());
      }
      return error;      
   }
   
   private boolean importCrQrLayouts(boolean error){
      CallableStatement pstmt = null;
      int minAllowedFileSize = 350; //this is the minimum allowed file size in bytes.
      java.io.File crQRlayoutDir = new java.io.File(reportDir + "//layouts//crystal//quick");
      if (crQRlayoutDir.exists()) {
         logNewLine();
         logInfo("### Importing Crystal Quick Report Layouts... ###");         
         String description = "";
         String layoutName = "";
         String qrId = "";
         String retValue = "";
         Document xsl = null;     
         NodeList element = null;
         java.io.File[]  qrConfigFiles = crQRlayoutDir.listFiles(new SuffixFilter(".XML"));
         for (int i = 0; i < qrConfigFiles.length; i++) {
            try{
               java.io.File currentLayout = new java.io.File(qrConfigFiles[i].getAbsolutePath());
               xsl = XmlUtil.parse(currentLayout);
               element = xsl.getDocumentElement().getElementsByTagName("DESCRIPTION");
               description = element.getLength() >= 1?element.item(0).getTextContent():"[Description not fond]";
               element = null;   
               element = xsl.getDocumentElement().getElementsByTagName("FILE_NAME");
               layoutName = element.getLength() >= 1?element.item(0).getTextContent():"";
               element = null;
               element = xsl.getDocumentElement().getElementsByTagName("QUICK_REPORT_ID");
               qrId = element.getLength() == 1?element.item(0).getTextContent():"";
               element = null;               
               if ((layoutName == null) || (layoutName == "")){
                  logInfo("Layout name is not in export xml for crystal quick report " + description + ".Skiping import of report.");
                  continue;
               }
               //Import QR definition
               pstmt = conn.prepareCall(stmt_IMPORTCRQRDEFINITION);
               byte[] layoutDef = readFile(currentLayout);
               pstmt.setBlob(1, readBytes(layoutDef));
               pstmt.execute();
               closeStatement(pstmt,"Importing Crystal Quick Report definition");
               pstmt = null; 
               logInfo("Quick Report " + description + " succesfully imported.");
               //Import QR layout
               currentLayout = new java.io.File(qrConfigFiles[i].getParent() + "//" + layoutName.replace("\\", "//"));
               if (currentLayout.length() > minAllowedFileSize){
                  byte[] layoutInBytes = readFile(currentLayout);
                  pstmt = conn.prepareCall(stmt_IMPORTCRQRLAYOUT);
                  pstmt.setString(1, layoutName);  
                  pstmt.setBlob(2, readBytes(layoutInBytes));
                  pstmt.execute();
                  closeStatement(pstmt,"Importing Crystal Quick Report layout");
                  pstmt = null;                
                  logInfo("Crystal Quick Report layout " + layoutName + " succesfully imported.");
               }
               //The current file size is less than the minimum allowed file size
               //Assuming the file is obsolete and removing the file from table
               else{
                  try{
                     pstmt = conn.prepareCall(stmt_REMOVECRQRLAYOUT );
                     pstmt.setString(2, layoutName);
                     pstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
                     pstmt.execute();
                     retValue = pstmt.getString(1);
                     if ("TRUE".equals(retValue)){
                        logInfo("File " + layoutName + " was found to be smaller than " + minAllowedFileSize + " bytes. - layout was removed");
                     }
                     retValue = null;                                 
                  }
                  catch (Exception e) {
                     error = true;
                     logInfo("ERROR: Exception when removing crystal quick report layout " + layoutName + ". " + e.getMessage());
                  }
               }
            }
            catch (Exception e){
               if (e.getMessage().contains("FND_RECORD_EXIST")){
                  logInfo("Crystal Quick Report " + description + " with Id " + qrId + " already exists. Layout not imported.");
                  continue;
               }
               else{
                  error = true;
                  logInfo("ERROR: " + e.getMessage());
               }
            }
            description = "";
            layoutName = "";
            qrId = "";
            retValue = "";
            xsl = null;     
            element = null;            
         }
      }
      return error;
   }
   
   private double getNumericValue(String svalue) {
      StringBuilder charbuf = new StringBuilder();
      char chartemp;
      double value = 0.0;
      try {
         for (int i = 0; i < svalue.length(); i++) {
            chartemp = svalue.charAt(i);
            if ((chartemp >= '1' && chartemp <= '9') || chartemp == '0' || chartemp == '.') {
               charbuf.append(chartemp);
            } else {
               break;
            }
         }
         value = Double.parseDouble(charbuf.toString().trim());

      } catch (Exception e) {
         value = 0.0;
      }
      return value;
   }

   private boolean importSchema() {
      //private boolean importSchema(ReportSchemaHandler schemaHandler) throws InvalidUsernamePasswordException {
      boolean error = false;
      String retValue;
      logNewLine();
      CallableStatement pstmt = null;
      logInfo("### Importing Schema's... ###");

      java.io.File schemaDirFile = new java.io.File(reportDir + "//schemas");
      if (!schemaDirFile.exists()) {
         logInfo(schemaDirFile + " does not exist. Please ignore this message if you do not have any schemas to import in your delivery.");
      } else {
         java.io.File[] xsdFiles = schemaDirFile.listFiles(new SuffixFilter(".XSD"));
         for (int i = 0; i < xsdFiles.length; i++) {
            String reportId = null;

            int minAllowedXsdSize = 350; //this is the minimum allowed file size in bytes.
            if (xsdFiles[i].length() < minAllowedXsdSize) {
               //generate reportID from File name
               reportId = xsdFiles[i].getName().substring(0, xsdFiles[i].getName().length() - 4);
               for (int y = 1; y < reportId.length(); y++) {
                  if (reportId.charAt(y) == reportId.toUpperCase().charAt(y)) {
                     reportId = reportId.substring(0, y) + "_" + reportId.substring(y);
                     y = y + 2;
                  }
               }
               try {
                  retValue = null;
                  pstmt = conn.prepareCall(stmt_REMOVESCHEMALAYOUTS);
                  pstmt.setString(1, reportId.toUpperCase());
                  pstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
                  pstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
                  pstmt.execute();
                  String layoutList = pstmt.getString(2);
                  retValue = pstmt.getString(3);

                  if ("SCHEMAZERO".equals(retValue)){
                     logInfo(reportId + " (" + xsdFiles[i].getName() + ") was found to be smaller than " + minAllowedXsdSize + " bytes. - Schema was not imported");
                     continue;
                  }
                  else if ("SCHEMAMULTI".equals(retValue)) {
                     logInfo(reportId + " (" + xsdFiles[i].getName() + ") was found to be smaller than " + minAllowedXsdSize + " bytes. - Schema was not imported");
                     logInfo("Multiple report_id's with this schema name were found. Couldn't identify the obsolete schema. - existing database entries left unchanged");
                     continue;
                  }
                  else {
                     if ((layoutList != null) && (layoutList != "")){
                        StringTokenizer layouts = new StringTokenizer(layoutList,",");
                        String layout;
                        logInfo("Deleting layouts for the obsolute schema " + xsdFiles[i].getName());
                        while (layouts.hasMoreTokens()){
                           layout = null;
                           layout = layouts.nextToken();
                           if (layout.toUpperCase().contains("#ERROR#")){
                              logInfo("ERROR : There was an error when removing " + layout + " layout for obsolete schema " + reportId);
                           }
                           else{
                              logInfo("(" + layout + ") for obsolete schema " + reportId + " was deleted succesfully.");   
                           }
                        }
                     }
                     if ("SCHEMAERROR".equals(retValue)){
                        logInfo("ERROR : Exception when removing schema " + xsdFiles[i].getName() + " for reportId  " + reportId);
                     }
                     else if ("SCHEMADELETED".equals(retValue)){
                        logInfo(reportId + " (" + xsdFiles[i].getName() + ") was found to be smaller than " + minAllowedXsdSize + " - Schema and layouts was removed");
                        continue;
                     }
                  }
               }
               catch (Exception e) {
                   logInfo("File (" + xsdFiles[i].getName() + ") smaller than " + minAllowedXsdSize + " bytes and unable to delete layout:\n" + e.getMessage());
                   continue;
               }
               finally{
                  closeStatement(pstmt,"removing schemas and layouts");
                  pstmt = null;
               }
            }
            Document xsd;
            try {
               xsd = XmlUtil.parse(xsdFiles[i]);
            } catch (java.lang.Exception ex) {
               //errorFiles += xsdFiles[i].getName() + " ";
               logInfo("ERROR: Could not parse file " + xsdFiles[i].getName() + "\n" + ex.getMessage());
               error = true;
               continue;
            }

            NodeList children = xsd.getChildNodes();
            Node report = null;
            int nodeIndex = 0;
            while ((report == null) && (nodeIndex < children.getLength())) {
               if ((children.item(nodeIndex) instanceof ProcessingInstruction) && children.item(nodeIndex).getNodeName().equals("report")) {
                  report = children.item(nodeIndex);
               }
               nodeIndex++;
            }

            if (nodeIndex == children.getLength()) {
               //errorFiles += xsdFiles[i].getName() + " ";
               logInfo("WARNING: Could not find 'report' instruction in file " + xsdFiles[i].getName());
               continue;
            }

            reportId = report.getNodeValue();
            Pattern p = Pattern.compile("package=\"(.*?)\"");
            Matcher m = p.matcher(reportId);
            m.find();
            reportId = m.group(1);
            int dataSize = (int) xsdFiles[i].length();
            try {
               int schemaVersion = 0;
               byte[] xmlInBytes = readFile(xsdFiles[i]);
               pstmt = conn.prepareCall(stmt_IMPORTSCHEMA);
               pstmt.setString(1, reportId.toUpperCase());
               pstmt.setInt(2, dataSize);
               pstmt.setBlob(3, readBytes(xmlInBytes));
               pstmt.registerOutParameter(4, java.sql.Types.INTEGER);                        
               pstmt.registerOutParameter(5, java.sql.Types.VARCHAR);
               pstmt.execute();
               schemaVersion = pstmt.getInt(4);
               retValue = pstmt.getString(5);
               if ("IMPORT".equals(retValue.toUpperCase())){
                  logInfo(reportId + " (" + xsdFiles[i].getName() + ") " + " schema was imported");
               }
               else if ("MODIFY".equals(retValue.toUpperCase())){
                  logInfo(reportId + " (" + xsdFiles[i].getName() + ") " + " schema was overwritten : New version = " + schemaVersion);
               }
               else {
                  logInfo("There was an error in importing the schema " +  xsdFiles[i].getName() + " for report ID " + reportId);
               }                   
            } catch (Exception e) {
               logInfo(reportId + " (" + xsdFiles[i].getName() + ") " + " schema failed to import");
               logError("ERROR: Error on importing Schema : " + e.getMessage());
               logNewLine();
               error = true;
               continue;
            }
            finally{
               closeStatement(pstmt,"importing schema");
               pstmt = null;
            }                
         }
      }
      return error;
   }

   private boolean importFontDefinition(String fontDir) {
        
      boolean error3 = false;
      //If includeFontFileImports=true we assume that other fonts (directly inside reports\fonts\ttf) are in the database and the ttfs should be imported
      if (includeFontFileImports){
         logInfo("### Importing Font Files... ###");
         error3 = importFontFiles(fontDir + File.separator + "ttf", "ttf", false);

      }
      //Remove Obsolete xml folder if exists
      try{
         java.io.File xmlDir = new java.io.File("xml");
         if(xmlDir.exists() && xmlDir.isDirectory())
         {
            if (deleteXMLDirectory(new java.io.File(fontDir + File.separator + "xml" )))
               logInfo("### Obsolete XML files removed successfully ###");
            else
               logInfo("WARNING: " +" Error during removing obsolete XML files");
         }
      }
      catch (Exception e)
      {
         logInfo("WARNING: " +" Error during removing obsolete XML files");
      }
      return error3;
   }

   private boolean importFontFiles(String fontDir, String type, boolean isBase) {
      boolean error3 = false;
      java.io.File fontDirFile = new java.io.File(fontDir);

      if (!fontDirFile.exists()) {
         if(isBase)
         {
            logInfo("Base Fonts Folder " + fontDir + " does not exist. Please ignore this message if you do not have any fonts to import in your delivery.");
            return false;
         }
         else{
            logInfo("Custom Fonts Folder "+ fontDir + " does not exist. Please ignore this message if you do not have any fonts to import in your delivery.");
            return false;
         }
      }

      java.io.File[] fontFiles = null;

      if (type.equalsIgnoreCase("ttf")) {
         FilenameFilter filter = new FilenameFilter() {

            @Override
            public boolean accept(File dir, String name) {
            if ((name.toLowerCase().endsWith(".ttf")) || (name.toLowerCase().endsWith(".ttc"))) {// add ttc support
               return true;
            }
               return false;
            }
         };
         fontFiles = fontDirFile.listFiles(filter);
      } else {
         fontFiles = fontDirFile.listFiles(new SuffixFilter(".XML"));
      }

      if(fontFiles.length <=0)
      {
         if(!isBase)
         {
            logInfo("### No Custom Fonts Found in location "+ fontDir);
         }
      }

      FileInputStream tempFont = null;
      Font font = null;

      for (int i = 0; i < fontFiles.length; i++) {
         try {
            tempFont = new FileInputStream(fontFiles[i]); 
            font = java.awt.Font.createFont(java.awt.Font.TRUETYPE_FONT, tempFont);

            updateReportFont(font, isBase);

            updateFontDefinition(fontFiles[i], font, isBase);
            //Creation of the Sazanami Gothic styles are treated specially
            if (!"Sazanami Gothic".equals(font.getFamily())){
               updateFontStyle(font, fontFiles[i].getName(), isBase);
            }

            if (isFontFileNew)
               logInfo("Font File " + fontFiles[i].getName() + " was loaded successfully");
            else if (!isBase)
               logInfo("Font File " + fontFiles[i].getName() + " was updated successfully");
         } catch (Exception e) {
            logInfo("Exception on importing file " + fontFiles[i].getName() + " : " + e.getMessage());
            error3 = true;
         }
      }
      try{
         updateSazanamiGothicFontStyle();
      }
      catch (Exception e) {
         logInfo("Exception in adding Sazanami Gothic Font Styles : " + e.getMessage());
          error3 = true;
      }
      return error3;
   }

   private void updateReportFont (java.awt.Font font, boolean isBase) throws Exception {  
      CallableStatement pstmt = null;
      try{
         pstmt = conn.prepareCall(stmt_UPDATEREPORTFONT);
         pstmt.setString(1, font.getFamily());
         pstmt.setString(2, isBase?"TRUE":"FALSE");
         pstmt.execute();
      }
      catch (Exception e){
         logInfo("Exception in updating report font : " + e.getMessage());
      }
      finally{
         closeStatement(pstmt,"updating report font.");
		 pstmt = null;
      }
   }
    
   private void updateFontDefinition (java.io.File fontFile, java.awt.Font font, boolean isBase) {
      CallableStatement pstmt = null;
      try{
         pstmt = conn.prepareCall(stmt_UPDATEFONTDEFINITION);
         pstmt.setString(1, font.getFamily());
         pstmt.setString(2, fontFile.getName());
         byte[] fontInBytes = readFileBytes(fontFile);
         pstmt.setBlob(3, readBytes(fontInBytes));
         pstmt.setString(4,isBase?"TRUE":"FALSE");
         pstmt.registerOutParameter(5, java.sql.Types.VARCHAR);
         pstmt.execute();
         isFontFileNew = pstmt.getString(5).toUpperCase() == "TRUE"?true:false;
      }
      catch (Exception e){
         logInfo("Exception in updating font definition : " + e.getMessage());         
      }
      finally{
         closeStatement(pstmt,"updating font definition.");
         pstmt = null;
      }
   }
    
    private void updateFontStyle (java.awt.Font font, String fileName, boolean isBase) {
      CallableStatement pstmt = null;
      try{
         pstmt = conn.prepareCall(stmt_UPDATEFONTSTYLE);
         pstmt.setString(1, font.getFamily());
         pstmt.setString(2, fileName);
         pstmt.setString(3, decodeStyle(font.getFontName(Locale.ENGLISH)));
         pstmt.setString(4,isBase?"TRUE":"FALSE");
         pstmt.execute();
      }
      catch (Exception e){
         logInfo("Exception in updating font style : " + e.getMessage());                  
      }
      finally{
         closeStatement(pstmt,"updating font style.");
         pstmt = null;
      }
   }
    
   private void updateSazanamiGothicFontStyle () {
      CallableStatement pstmt = null;
      try{
         pstmt = conn.prepareCall(stmt_UPDATESAZANAMIFONTSTYLE);
         pstmt.execute();       
         logInfo("Sazanami Gothic Font Style was successfully added.");
      }
      catch (Exception e){
         logInfo("Exception in updating Sazanami Gothic font style : " + e.getMessage());                           
      }
      finally{
         closeStatement(pstmt,"updating Sazanami Gothic font style.");
         pstmt = null;
      }
   }
    
    private String decodeStyle(String fontFaceName) {
      boolean isCurrentItalic=false;
      boolean isCurrentBold=false;

      if ((fontFaceName.toUpperCase().indexOf("ITALIC") > 0) || (fontFaceName.toUpperCase().indexOf("OBLIQUE") > 0)) 
      {
         isCurrentItalic = true;
      }

      if ((fontFaceName.toUpperCase().indexOf("BOLD") > 0) || (fontFaceName.toUpperCase().indexOf("SEMIBOLD") > 0)
              || (fontFaceName.toUpperCase().indexOf("DEMIBOLD") > 0) || (fontFaceName.toUpperCase().indexOf("EXTRABOLD") > 0)
              || (fontFaceName.toUpperCase().indexOf("ULTRABOLD") > 0)) 
      {
         isCurrentBold = true;
      }

      if ((isCurrentItalic)&&(isCurrentBold))
      {
         return "Bold Italic";
      }
      else if (isCurrentItalic){
         return "Italic";
      }
      else if (isCurrentBold){
         return "Bold";
      }
      else{
         return "Regular";
      }
   }
    
   private boolean deleteXMLDirectory(java.io.File dir) {
       if (dir.isDirectory()) 
       { 
         File[] files = dir.listFiles();

          for (File file : files) {
            boolean success = deleteXMLDirectory(file);
            if (!success)
            {
               return false;
            }
         } 
      }
      return dir.delete();
   }

   private byte[] readFileBytes(File file) throws Exception {
      InputStream inStream = null;
      inStream = new BufferedInputStream(new FileInputStream(file));
      byte[] fileData = new byte[(int)file.length()];
      int res = inStream.read(fileData);

      if (inStream != null)
         inStream.close();

      return fileData;
   }

   private byte[] readFile(File file) throws Exception {
      FileInputStream fi = new FileInputStream(file);
      StringBuilder sb = new StringBuilder();

      while (true) {
         int cnt = fi.available();
         if (cnt == 0) {
            break;
         }
         byte[] b = new byte[cnt];
         int res = fi.read(b);
         String s = new String(b, 0, res, "UTF-8");
         sb.append(s);
         b = null;
         s = null;
      }
      fi.close();
      return (sb.toString().getBytes("UTF-8"));
   }
    
   private InputStream readBytes(byte[] file) {
      return new ByteArrayInputStream(file);
   }

   public void setReportDir(String propertyValue) {
      this.reportDir = propertyValue;
   }


   public void setDebugFilePath(String propertyValue) {
      this.debugFilePath = propertyValue;
   }

   public void setImportLayouts(String reportDir) {
      java.io.File layoutDirFile = new java.io.File(reportDir + "//layouts");
      if (!layoutDirFile.exists()) {
         this.importReportLayouts = false;
         logInfo(reportDir + "/layouts folder does not exist. Please ignore this message if you do not have any layouts to import in your delivery.");
      }
      else{
         String[] suffixtypes = {".XSL", ".RDL", ".RPL"};
         java.io.File[] layoutFiles = layoutDirFile.listFiles(new SuffixFilters(suffixtypes));
         this.importReportLayouts = layoutFiles.length > 0 ? true : false;
         if (this.importReportLayouts == false){
           logInfo("No layouts were found to be imported under folder " + reportDir + "/layouts"); 
         }          
      }
   }

   public void setImportSchemas(String reportDir) {
      java.io.File schemaDirFile = new java.io.File(reportDir + "//schemas");
      if (!schemaDirFile.exists()) {
         this.importReportSchemas = false;
         logInfo(reportDir + "/schemas folder does not exist. Please ignore this message if you do not have any schemas to import in your delivery.");
      }
      else{
         String[] suffixtypes = {".XSL", ".RDL", ".RPL"};
         java.io.File[] schemaFiles = schemaDirFile.listFiles(new SuffixFilter(".XSD"));
         this.importReportSchemas = schemaFiles.length > 0 ? true : false;
         if (this.importReportSchemas == false){
           logInfo("No schemas were found to be imported under folder " + reportDir + "/schemas"); 
         }          
      }
   }

   public void setImportFonts(String reportDir) {
      java.io.File fontDirFile = new java.io.File(reportDir + "//fonts//ttf");
      if (!fontDirFile.exists()) {
         this.importReportFonts = false;
         logInfo(reportDir + "/fonts/ttf folder does not exist. Please ignore this message if you do not have any custom fonts.");
      }
      else {
         String[] suffixtypes = {".TTF", ".TTC"};
         java.io.File[] fontFiles = fontDirFile.listFiles(new SuffixFilters(suffixtypes));
         this.importReportFonts = fontFiles.length > 0 ? true : false;
         if (this.importReportFonts == false){
           logInfo("No custom fonts were found to be imported under folder " + reportDir + "/fonts/ttf");
         }          
      }
   }

   public void setQuiet(String propertyValue) {
      if (propertyValue != null) {
         if ("TRUE".equalsIgnoreCase(propertyValue)) {
            quiet = true;
         }
         if ("FALSE".equalsIgnoreCase(propertyValue)) {
            quiet = false;
         }
      }
   }
    
   public void setIncludeFontFileImports(String propertyValue) {
      if (propertyValue.toUpperCase().compareTo("TRUE") == 0) {
         this.includeFontFileImports = true;
      } else {
         this.includeFontFileImports = false;
      }
   }
    
   public void setLoginId(String propertyValue) {
      this.loginId = propertyValue;
   }

   public void setPassword(String propertyValue) {
      this.password = propertyValue;
   }

   public void setConnectString(String propertyValue) {
      this.connectString = propertyValue;
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

   private void logInfoSuccess() {
      if (debugStream != null) {
         logNewLine();
         logNewLine();
         debugStream.printEr("###########################################################");
         debugStream.printEr("#                                                         #");
         debugStream.printEr("#  All schemas/layouts/fonts were imported SUCCESSFULLY.  #");
         debugStream.printEr("#                                                         #");
         debugStream.printEr("###########################################################");
      }
   }

   private void logInfoFail() {
      if (debugStream != null) {
         logNewLine();
         logNewLine();
         debugStream.printEr("######################################################################################");
         debugStream.printEr("#                                                                                    #");
         debugStream.printEr("#  Some issues were found when importing schemas/layouts/fonts. See log for details. #");
         debugStream.printEr("#                                                                                    #");
         debugStream.printEr("######################################################################################");
      }
   }

   private void logNewLine() {
      if (debugStream != null) {
         debugStream.newLine();
      }
   }

   private void closeStatement(CallableStatement pstmt,String message){
      if (pstmt!=null){
         try{
            pstmt.close();
            pstmt = null;
         }
         catch(Exception e){
            logInfo("Error closing statement at " + message);
            logInfo("Error: " + e.getMessage());                                 
         }
      }
   }
    

   private class SuffixFilter implements FileFilter {
      private String suff;

      public SuffixFilter(String suff) {
         this.suff = suff;
      }

      @Override
      public boolean accept(java.io.File f) {
         if (f.isDirectory()) {
            return false;
         }
         return (f.getPath().toUpperCase().endsWith(suff));
      }
   }

    //modify SuffixFilters class
   private class SuffixFilters implements FileFilter {
      private String[] suff;
      private boolean match;

      public SuffixFilters(String[] suff) {
         this.suff = suff;
      }

      @Override
      public boolean accept(java.io.File f) {
         if (f.isDirectory()) {
            return false;
         }
         match = false;
         int i = 0;
         do {
            match = f.getPath().toUpperCase().endsWith(suff[i]);
            i++;
         } while (!match && i < suff.length);
         return match;
      }
   }

   class OutputMessageStream extends java.io.PrintStream {

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
