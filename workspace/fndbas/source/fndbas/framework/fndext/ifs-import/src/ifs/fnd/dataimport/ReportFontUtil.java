/*
 * ==================================================================================
 * File:              ReportFontUtil.java
 * Software Package:  ReportFontUtility
 *
 * ==================================================================================
 * Date        Sign    History
 * 2020-Feb-03 CHAALK  Created
 */
 
package ifs.fnd.dataimport;

import ifs.fnd.dataimport.fop.fonts.apps.TTFReader;
import ifs.fnd.dataimport.fop.fonts.TTFFile;
import ifs.fnd.dataimport.fop.fonts.FontFileReader;

import java.io.ByteArrayInputStream;
import java.io.StringWriter;
import java.io.InputStream;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.*;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.OutputKeys;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Comment;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Implementation of the <code>ReportFontHandlingUtil</code> handler.
 */
public class ReportFontUtil {

   private ResultSet  reportFontInfoArray;
   private Document docUserConfig=null;
   private boolean error = false;
   private ArrayList arrFileList;
   private ArrayList arrFontList;
   private HashMap<String, String> hashList;
   private boolean isBoldAvailable, isItalicAvailable, isBoldItalicAvailable;
   private String boldFontFileName, boldFontTripletName, italicFontFileName, italicFontTripletName, regulerFontFlieName, regulerFontTripletName, boldItalicFontFileName, boldItalicFontTripletName;
   
   Connection conn = null;
   private ImportReports.OutputMessageStream debugStream = null;
   
   private static final String stmt_GETFONTLIST(ArrayList fileList){
      String inFileList = "";
      for (int i=0; i < fileList.size(); i++ ){
         inFileList = inFileList + "'" + fileList.get(i).toString().toUpperCase() + "',";
      }
      //remove last unwanted ,
      inFileList = inFileList.substring(0,inFileList.length()-1);
      return "SELECT font_name, file_name FROM report_font_definition_tab WHERE UPPER(file_name) in (" + inFileList + ")";
   }   
   
   private static final String stmt_GETFONTINFO(ArrayList fontList){
      String inFontList = "";
      if (!fontList.get(0).equals("*")){
         for (int i=0; i < fontList.size(); i++ ){
            inFontList = inFontList + "'" + fontList.get(i).toString().toUpperCase() + "',";
         }
         inFontList = inFontList.substring(0,inFontList.length()-1);
         return "SELECT font_name, encoding, lock_font FROM report_font_tab WHERE UPPER(font_name) in (" + inFontList + ") ORDER BY font_name";
      }
      else{
         return "SELECT font_name, encoding, lock_font FROM report_font_tab ORDER BY font_name";
      }
   }

   private static final String stmt_GETFONTDEFINITIONS(String fontName){
         return "SELECT file_name, data FROM report_font_definition_tab WHERE UPPER(font_name) = '" + fontName.toUpperCase() + "' ORDER BY font_name";
   }

   private static final String stmt_GETFONTCONFIGXML(String xmlFileName){
      return "SELECT file_name, data FROM report_font_config_xml_tab WHERE UPPER(file_name) = '" + xmlFileName.toUpperCase() + "'";
   }
   
   private static final String stmt_IMPORTFONTMATRIX =
      "DECLARE \n"
         + "BEGIN \n"
         + "	Report_Font_Config_Xml_API.Import_XML_File(:FileName, :Xml, :RetValue);\n"
         + "END;";    
   
   public ReportFontUtil() {
   }

   public ReportFontUtil(Connection conn, ImportReports.OutputMessageStream debugStream) {
      this.conn = conn;
      this.debugStream = debugStream;
   }
   /**
    * <p><b>Remarks:</b>
    * @param String fileList
    * @return void
    * @throws IfsException
    */
   public boolean createXMLFiles(String fileList) throws ImportException {     
      
      setFontNameList(fileList);
      loadFontInfo();
      createFontMatrix();
      saveUserConfigFile();
      closeResultSet(reportFontInfoArray,"finish adding font matrix.");
      return error;
   }
   
   private void createFontMatrix() {
      byte[] font;
      boolean isTTC = false; 
      boolean isCid;
      String fontExt, fontFileName, fontName;
      TTFReader ttfReader;
      InputStream fontStream;
      TTFFile ttf = null;
      org.w3c.dom.Document doc= null;
      boolean emptyFontInfo = true;
      CallableStatement pstmt = null;
      Statement stmt = null;
      ResultSet fontDefinitions = null;
      try
      {
         while(reportFontInfoArray.next())
         {
            emptyFontInfo = false;
            stmt = conn.createStatement();
            fontDefinitions = stmt.executeQuery(stmt_GETFONTDEFINITIONS(reportFontInfoArray.getString("font_name")));

            isBoldAvailable = false;
            isItalicAvailable = false;
            isBoldItalicAvailable = false;
            boldFontFileName = "";
            boldFontTripletName = "";
            italicFontFileName = "";
            italicFontTripletName = "";
            regulerFontFlieName = "";
            regulerFontTripletName = "";
            boldItalicFontFileName = "";
            boldItalicFontTripletName = "";
            while(fontDefinitions.next())
            {
               font = null;
               fontFileName = "";
               fontName = "";
               isCid = true;
               doc = null;

               font = fontDefinitions.getBytes("data");
               fontFileName = fontDefinitions.getString("file_name");
               isCid = Boolean.valueOf(reportFontInfoArray.getString("encoding"));
               fontName = reportFontInfoArray.getString("font_name");

               fontStream = new ByteArrayInputStream(font);
               ttfReader = new TTFReader();
               FontFileReader reader = new FontFileReader(fontStream);
               fontExt = fontFileName.substring(fontFileName.indexOf('.'), fontFileName.length());
               isTTC = fontExt.equalsIgnoreCase("ttc");
               if (isTTC){
                  ttf = new TTFFile();
                  ttf.readFont(reader, fontName); 
                  if (ttf != null){
                     //we do !isCid becasue by default the isCid is false in the DB and true only for WinAnci.So here we need to pass the inverse
                     doc = ttfReader.constructFontXML(ttf, fontName, null, null, null, !isCid, fontName);
                  }
               }
               else{
                  ttf = new TTFFile();
                  ttf.readFont(reader, null);
                  if (ttf != null){
                     //we do !isCid becasue by default the isCid is false in the DB and true only for WinAnci.So here we need to pass the inverse
                     doc = ttfReader.constructFontXML(ttf, null, null, null, null, !isCid, null);
                  }
               }

               if (doc != null){
                  pstmt = conn.prepareCall(stmt_IMPORTFONTMATRIX);
                  pstmt.setString(1, getXmlFileName(fontFileName));
                  pstmt.setBlob(2, readBytes(docToString(doc).getBytes("UTF-8")));
                  pstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
                  pstmt.execute();                     
                  String retValue = pstmt.getString(3);
               }
               //Creation of the user config file for Sazanami Gothic is treated specially
               if (!"Sazanami Gothic".equals(reportFontInfoArray.getString("font_name"))){
                  createUserConfigXML(fontFileName,font);
               }
            }
            //Creation of the user config file for Sazanami Gothic is treated specially
            if (!"Sazanami Gothic".equals(reportFontInfoArray.getString("font_name"))){
               createDefaultUserConfigXML();
            }
         }
         createSazanamiGothicUserConfig();
      }
      catch (Exception e)
      {
         logInfo("ERROR: There was an error in generating the font matrix file." + e.getMessage());
         error = true;
      }
      finally{
         closeStatement(pstmt,"generating the font matrix.");
         pstmt = null;
         closeStatement(stmt,"generating the font matrix.");
         stmt = null;
         closeResultSet(fontDefinitions,"generating the font matrix.");
         fontDefinitions = null;
      }
      if (emptyFontInfo)
      {
         logInfo("ERROR: Font is missing. Please install the font file.");
         error = true;
      }   
   }
   
   //Create the user config file for Sazanami Gothic
   private void createSazanamiGothicUserConfig() {
      Document doc = null;
      doc = getUserConfigFile();
      Element fonts = (Element)doc.getDocumentElement().getElementsByTagName("fonts").item(0);

      //Normal
      createDefaultElement(fonts, getXmlFileName("sazanami-gothic.ttf"), "sazanami-gothic.ttf", "Sazanami Gothic","","" );
      //Bold
      createDefaultElement(fonts, getXmlFileName("sazanami-gothicbd.ttf"), "sazanami-gothicbd.ttf", "Sazanami Gothic","","bold" );
      //Italic
      createDefaultElement(fonts, getXmlFileName("sazanami-gothicit.ttf"), "sazanami-gothicit.ttf", "Sazanami Gothic","italic","" );
      //BoldItalic
      createDefaultElement(fonts, getXmlFileName("sazanami-gothicbdit.ttf"), "sazanami-gothicbdit.ttf", "Sazanami Gothic", "italic", "bold" );
      //Add Gothic font mapped to same Sazanami Gothic font to fix fields using Gothic font in layouts
      //Normal
      createDefaultElement(fonts, getXmlFileName("sazanami-gothic.ttf"), "sazanami-gothic.ttf", "Gothic","","" );
      //Bold
      createDefaultElement(fonts, getXmlFileName("sazanami-gothicbd.ttf"), "sazanami-gothicbd.ttf", "Gothic","","bold" );
      //Italic
      createDefaultElement(fonts, getXmlFileName("sazanami-gothicit.ttf"), "sazanami-gothicit.ttf", "Gothic","italic","" );
      //BoldItalic
      createDefaultElement(fonts, getXmlFileName("sazanami-gothicbdit.ttf"), "sazanami-gothicbdit.ttf", "Gothic", "italic", "bold" );
	  
      updateUserConfigXML(doc);
   }
   
   private void createUserConfigXML(String fontFileName, byte[] fontData) {
      Document doc = null;
      doc = getUserConfigFile();
      doc = editUserConfigFile(doc, fontFileName, fontData);
      updateUserConfigXML(doc);
      
   }
   
   private Document editUserConfigFile(Document doc, String fontFileName, byte[] fontData) {
      java.awt.Font font = null;
      String xmlFileName = null;
      String ttfFileName = null;
      Boolean isCurrentItalic = false;
      Boolean isCurrentBold = false;
      String fontName = null;

      try {
         font = java.awt.Font.createFont(java.awt.Font.TRUETYPE_FONT, new ByteArrayInputStream(fontData));
      }
      catch (java.io.IOException ex) {
         return doc;
      }
      catch (java.awt.FontFormatException ex) {
         return doc;
      }
      //doc = removeDuplicateFonts(doc, font);
      ttfFileName = "db://" + fontFileName;
      xmlFileName = "db://" + getXmlFileName(fontFileName);
      Element fonts = (Element)doc.getDocumentElement().getElementsByTagName("fonts").item(0);
      Element newFont = doc.createElement("font");
      newFont.setAttribute("metrics-file", xmlFileName);
      newFont.setAttribute("kerning", "no");
      newFont.setAttribute("embed-file", ttfFileName);

      Element newFontTriplet = doc.createElement("font-triplet");
      String triplet = font.getFamily().trim();
      newFontTriplet.setAttribute("name", triplet);
      fontName =  font.getFontName(Locale.ENGLISH).toUpperCase();
      if ((fontName.indexOf("ITALIC") > 0) || (fontName.indexOf("OBLIQUE") > 0)) {
         newFontTriplet.setAttribute("style", "italic");
         isCurrentItalic = true;
      } else {
         newFontTriplet.setAttribute("style", "normal");
      }
      if ((fontName.indexOf("BOLD") > 0) || (fontName.indexOf("SEMIBOLD") > 0)
               || (fontName.indexOf("DEMIBOLD") > 0) || (fontName.indexOf("EXTRABOLD") > 0)
               || (fontName.indexOf("ULTRABOLD") > 0)) {
         newFontTriplet.setAttribute("weight", "bold");
         isCurrentBold = true;
      }
      else {
         newFontTriplet.setAttribute("weight", "normal");
      }
      
      if ((isCurrentItalic)&&(isCurrentBold))
      {
         isBoldItalicAvailable = true;
         boldItalicFontFileName = fontFileName;
         boldItalicFontTripletName = triplet;
      }
      else if (isCurrentItalic){
         isItalicAvailable = true;
         italicFontFileName = fontFileName;
         italicFontTripletName = triplet;
      }
      else if (isCurrentBold){
         isBoldAvailable = true;
         boldFontFileName = fontFileName;
         boldFontTripletName = triplet;
      }
      else{
         regulerFontFlieName = fontFileName;
         regulerFontTripletName = triplet;
      }
      
      newFont.appendChild(newFontTriplet);
      Comment newFontComment = doc.createComment(font.getFamily());
      fonts.appendChild(newFontComment);
      fonts.appendChild(doc.createTextNode("\n"));
      fonts.appendChild(newFont);
      return doc;  
   }
   
   private void updateUserConfigXML(org.w3c.dom.Document doc) {
      String userConfigFile = null;
      try{
         TransformerFactory transformerFactory = TransformerFactory.newInstance();
         Transformer transformer = transformerFactory.newTransformer();
         transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
         transformer.setOutputProperty(OutputKeys.METHOD, "xml");
         transformer.setOutputProperty(OutputKeys.INDENT, "yes");
         transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
         DOMSource source = new DOMSource(doc);
         StreamResult result = new StreamResult(new StringWriter());
         transformer.transform(source, result);
         userConfigFile = result.getWriter().toString();

         DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
         DocumentBuilder builder = factory.newDocumentBuilder(); 
         docUserConfig = builder.parse(new ByteArrayInputStream(userConfigFile.getBytes("UTF-8")));
      }
      catch(Exception ex){
         logInfo("ERROR: Error in updating the user config  XML file.");
      }
   }
   
   private void createDefaultElement(Element fonts, String xmlFileName, String ttfFileName, String triplet, String style, String weight)
   {
      try{
         Document doc = fonts.getOwnerDocument();

         Element newFont = doc.createElement("font");
         newFont.setAttribute("metrics-file", "db://" + xmlFileName);
         newFont.setAttribute("kerning", "no");
         newFont.setAttribute("embed-file", "db://" + ttfFileName);

         Element newFontTriplet = doc.createElement("font-triplet");
         newFontTriplet.setAttribute("name", triplet);
         newFontTriplet.setAttribute("style", "".equals(style)?"normal":style);
         newFontTriplet.setAttribute("weight", "".equals(weight)?"normal":weight);

         newFont.appendChild(newFontTriplet);
         Comment newFontComment = doc.createComment(triplet + " " + weight + " " + style + " Default");

         fonts.appendChild(newFontComment);
         fonts.appendChild(doc.createTextNode("\n"));
         fonts.appendChild(newFont);
      }
      catch (Exception e){
         logInfo("ERROR: Error in creating default font. Font file = " + ttfFileName + " Name = " + triplet + " Style = " + style + " weight = " + weight);
         error = true;
      }
   }

   
   private void createDefaultUserConfigXML() {
      Document doc = null;
      doc = getUserConfigFile();
      Element fonts = (Element)doc.getDocumentElement().getElementsByTagName("fonts").item(0);
      if ((regulerFontFlieName.isEmpty()) || ("".equals(regulerFontFlieName)) || (regulerFontFlieName == null)){
         if (isBoldAvailable){
            createDefaultElement(fonts, getXmlFileName(boldFontFileName), boldFontFileName, boldFontTripletName,"","" );
         }
         else if (isItalicAvailable){
            createDefaultElement(fonts, getXmlFileName(italicFontFileName), italicFontFileName, italicFontTripletName,"","" );
         }
         else if (isBoldItalicAvailable){
            createDefaultElement(fonts, getXmlFileName(boldItalicFontFileName), boldItalicFontFileName, boldItalicFontTripletName,"","" );
         }
         else{
            logInfo("WARNING: There is no valid reguler font to default to.");
         }
      }
      
      if (isBoldAvailable == false){
         if ((regulerFontFlieName.isEmpty()) || ("".equals(regulerFontFlieName)) || (regulerFontFlieName == null)){
             if (isBoldItalicAvailable){
                createDefaultElement(fonts, getXmlFileName(boldItalicFontFileName), boldItalicFontFileName, boldItalicFontTripletName,"","bold" );
             } else if (isItalicAvailable){
                createDefaultElement(fonts, getXmlFileName(italicFontFileName), italicFontFileName, italicFontTripletName,"","bold" );
             }
             else {
                logInfo("WARNING: There is no valid bold font to default to.");
             }
         }
         else {
            createDefaultElement(fonts, getXmlFileName(regulerFontFlieName), regulerFontFlieName, regulerFontTripletName,"","bold" );
         }
      }
      
      if (isItalicAvailable == false){
         if ((regulerFontFlieName.isEmpty()) || ("".equals(regulerFontFlieName)) || (regulerFontFlieName == null)){
             if (isBoldItalicAvailable){
                createDefaultElement(fonts, getXmlFileName(boldItalicFontFileName), boldItalicFontFileName, boldItalicFontTripletName,"italic","" );
             } else if (isBoldAvailable){
                createDefaultElement(fonts, getXmlFileName(boldFontFileName), boldFontFileName, boldFontTripletName,"italic","" );
             }
             else {
                logInfo("WARNING: There is no valid italic font to default to.");
             }
         }
         else {
            createDefaultElement(fonts, getXmlFileName(regulerFontFlieName), regulerFontFlieName, regulerFontTripletName,"italic","" );
         }
      }
      
      if (isBoldItalicAvailable == false){
         if(isBoldAvailable == true){
            createDefaultElement(fonts, getXmlFileName(boldFontFileName), boldFontFileName, boldFontTripletName, "italic", "bold" );
         }
         else if (isItalicAvailable == true){
            createDefaultElement(fonts, getXmlFileName(italicFontFileName), italicFontFileName, italicFontTripletName, "italic", "bold" );
         }
         else {
            if ((regulerFontFlieName.isEmpty()) || ("".equals(regulerFontFlieName)) || (regulerFontFlieName == null)){
               logInfo("WARNING: There is no valid bold italic font to default to.");
            }
            else{
               createDefaultElement(fonts, getXmlFileName(regulerFontFlieName), regulerFontFlieName, regulerFontTripletName, "italic", "bold" );
            }
         }
      } 
      updateUserConfigXML(doc);
   }
   
   private Document getUserConfigFile(){
      try {
         if (docUserConfig != null){
            return docUserConfig;
         }
         else{
            String tempStr = getFileTemplate();
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder(); 
            return builder.parse(new ByteArrayInputStream(tempStr.getBytes("UTF-8")));
         }
      }
      catch (Exception e) {
         logInfo("ERROR: Error in retrieving userconfig file.");
         error = true;
      }
      return null;
   }
   
   private String getFileTemplate() {
      String xmlString =
         "<!-- edited with XML Spy v3.5 NT (http://www.xmlspy.com) by  () fully created by installer-->"
         + "\n <!--<!DOCTYPE configuration SYSTEM \"config.dtd\">-->"
         + "\n <!--"
         + "\n this file contains templates which allow an user easy"
         + "\n configuration of Fop. Actually normally you don't need this configuration"
         + "\n file, but if you need to change configuration, you should"
         + "\n always use this file and *not* config.xml."
         + "\n Usage: java org.apache.fop.apps.Fop -c userconfig.xml -fo fo-file -pdf pdf-file"
         + "\n -->"
         + "\n <configuration>"
         + "\n <!--  "
         + "\n basedir: normally the base directory is the directory where the fo file is"
         + "\n          located. if you want to specify your own, uncomment this entry"
         + "\n -->"
         + "<entry>"
         + "<key>baseDir</key>"
         + "<value>db://</value>"
         + "</entry>"
         + "\n <!--"
         + "\n************************************************************************"
         + "\n                        HYPHENATION                                      "
         + "\n************************************************************************"
         + "\n -->"
         + "\n <!--"
         + "\n hyphenation directory"
         + " \n if you want to specify your own directory with hyphenation pattern"
         + "\n then uncomment the next entry and add the directory name"
         + "\n -->"
         + "\n <!--"
         + "\n <entry>"
         + "\n <key>hyphenation-dir</key>"
         + "\n <value>/java/xml-fop/hyph</value>"
         + "\n </entry>"
         + "\n -->"
         + "\n <!--"
         + "\n ************************************************************************"
         + "\n                    Add fonts here                                       "
         + "\n ************************************************************************"
         + "\n -->"
         + "<fonts>"
         + "</fonts>"
         + "</configuration>";
      return xmlString;
   }   
   
   private String getXmlFileName(String fontFileName){
      return fontFileName.substring(0, fontFileName.lastIndexOf('.')) + ".xml";
   }

   private String docToString(org.w3c.dom.Node node) {
      try {
         javax.xml.transform.Source source = new javax.xml.transform.dom.DOMSource(node);
         StringWriter stringWriter = new StringWriter();
         javax.xml.transform.Result result = new javax.xml.transform.stream.StreamResult(stringWriter);
         javax.xml.transform.TransformerFactory factory = javax.xml.transform.TransformerFactory.newInstance();
         javax.xml.transform.Transformer transformer = factory.newTransformer();
         transformer.transform(source, result);
         return stringWriter.getBuffer().toString();
      }
      catch (javax.xml.transform.TransformerConfigurationException e)
      {
         logInfo("ERROR: Error in transformr configaration when transforming doc to string.");
         error = true;
      }
      catch (javax.xml.transform.TransformerException e)
      {
         logInfo("ERROR: Error in transforming doc to string.");
         error = true;
      }
      return null;
   }
   
   private Document removeDuplicateFonts(Document doc, java.awt.Font font) {

      try {
         NodeList oldFonts = doc.getDocumentElement().getElementsByTagName("fonts"); 
         for(int i=0;i<oldFonts.getLength();i++){
            if(oldFonts.item(i).getNodeType() == Node.ELEMENT_NODE){
               oldFonts = ((Element)oldFonts.item(i)).getElementsByTagName("font");
               break;
            }
         }
         
         for (int s = 0; s < oldFonts.getLength(); s++) {
            if(oldFonts.item(s).getNodeType() == Node.ELEMENT_NODE){   
               Element font1 = (Element) oldFonts.item(s);
               NodeList font2 = font1.getChildNodes();
               Element triplet;
               int x;
               if (font2.getLength() == 1) {
                  x = 0;
               }
               else {
                 x = 1;
               }
               for (; x < font2.getLength(); x = x + 2) {
                  triplet = (Element) font2.item(x);
                  if (triplet.getAttribute("name").equalsIgnoreCase(font.getFamily())) {
                     ((Element)oldFonts).removeChild(triplet);
                     
                     for(int commentCount=0; commentCount < oldFonts.getLength(); commentCount ++)                     
                     {
                        if (triplet.getAttribute("name").equals(((Element)oldFonts.item(commentCount)).getNodeValue())){
                           ((Element)oldFonts).removeChild(oldFonts.item(commentCount));
                        }
                     }
                  }
               }
            }
         }
         return doc;
      }
      catch (Exception e) {
         return doc;
      }

   }
   
   private void loadFontInfo() {
      Statement stmt = null;
      ResultSet reportFontConfigXmlArray = null;
      try{
         //read font details including binary file & styles
         stmt = conn.createStatement();
         reportFontInfoArray = stmt.executeQuery(stmt_GETFONTINFO(arrFontList));
         //read UserConfig
         arrFileList.add("userconfig.xml");
         stmt = conn.createStatement();
         if (!arrFontList.get(0).equals("*")){
            reportFontConfigXmlArray = stmt.executeQuery(stmt_GETFONTCONFIGXML("userconfig.xml"));
            while(reportFontConfigXmlArray.next()){
               if("userconfig.xml".toUpperCase().equals(reportFontConfigXmlArray.getString("file_name").toUpperCase())){
                  DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                  DocumentBuilder builder = factory.newDocumentBuilder(); 
                  docUserConfig = builder.parse(new ByteArrayInputStream(reportFontConfigXmlArray.getBytes("data")));               
               }
            }
         }
         else{
            docUserConfig = null;
         }
      }
      catch(Exception e){
         reportFontInfoArray = null;
         logInfo("ERROR: Error in retrieving font information or user config information to generate font matrix files " + e.getMessage());
         error = true;
      }
      finally{
         closeStatement(stmt,"loading font info.");
         stmt = null;
         closeResultSet(reportFontConfigXmlArray,"loading font info.");
         reportFontConfigXmlArray = null;
      }
   }
   
   //save UserConfig to DB
   private void saveUserConfigFile() {
      CallableStatement pstmt =  null;
      try{
         pstmt = conn.prepareCall(stmt_IMPORTFONTMATRIX);
         pstmt.setString(1, "userconfig.xml");
         pstmt.setBlob(2, readBytes(docToString(docUserConfig).getBytes("UTF-8")));
         pstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
         pstmt.execute();                     
         String retValue = pstmt.getString(3);
      }
      catch(Exception e){
         logInfo("ERROR: There was an error in importing the userconfig file.");
         error = true;
      }
      finally{
         closeStatement(pstmt,"importing the userconfig file.");
         pstmt = null;
      }
   }
   
   //set the file name & font name lists
   private void setFontNameList(String strFileList) {
      arrFileList = new ArrayList();
      arrFontList = new ArrayList();
      String fileName=null;
      Statement stmt = null;
      ResultSet rs = null;
      if (strFileList.equals("*"))
      {
         arrFileList.add("*");
         arrFontList.add("*");
      }
      else
      {
         while(!strFileList.equals(""))
         {
            if (strFileList.indexOf(";")>0)
            {
               fileName = strFileList.substring(0, strFileList.indexOf(";"));
               strFileList = strFileList.substring(strFileList.indexOf(";")+1);
            }
            else
            {
               fileName = strFileList.substring(0);
               strFileList = "";
            }
            arrFileList.add(fileName);            
         }

         try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(stmt_GETFONTLIST(arrFileList));
            hashList = new HashMap<String, String>();
            while (rs.next()) {
               hashList.put(rs.getString("file_name"), rs.getString("font_name"));
               if (!arrFontList.contains(rs.getString("font_name")))
               {
                  arrFontList.add(rs.getString("font_name"));
               }
            }
         }
         catch (Exception e)
         {
            logInfo("ERROR: Error in retrieving font definition information to generate font matrix files " + e.getMessage());
            error = true;
         }
         finally{
            closeResultSet(rs,"retrieving font definition information.");
            rs = null;
            closeStatement(stmt,"retrieving font definition information.");
            stmt = null;
         }
      }
   }
   private InputStream readBytes(byte[] file) throws Exception {
      return new ByteArrayInputStream(file);
   }
   
   private void logInfo(String msg) {
      if (this.debugStream != null) {
         this.debugStream.println(msg);
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

   private void closeStatement(Statement stmt,String message){
     if (stmt!=null){
        try{
           stmt.close();
           stmt = null;
        }
        catch(Exception e){
           logInfo("Error closing statement at " + message);
           logInfo("Error: " + e.getMessage());                                 
        }
     }
   }
   
   private void closeResultSet(ResultSet rs,String message){
     if (rs!=null){
        try{
           rs.close();
           rs = null;
        }
        catch(Exception e){
           logInfo("Error closing result set at " + message);
           logInfo("Error: " + e.getMessage());                                 
        }
     }
   }
   
}