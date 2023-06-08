/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 * ---------------------------------------------------------------------------
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: ExportCompanyTemplateToFileAssistantHandling
 *  Type:         Entity
 *  Component:    ENTERP
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import javax.ejb.Stateless;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;


/*
 * Implementation class that contains Read, Update and Delete methods for Stream type entity attributes
 * which are marked with implementation = "Java" in the ExportCompanyTemplateToFileAssistantHandling projection model.
 */

@Stateless(name="ExportCompanyTemplateToFileAssistantHandlingStreamAttributesHandler")
public class ExportCompanyTemplateToFileAssistantHandlingStreamAttributesHandlerImpl implements ExportCompanyTemplateToFileAssistantHandlingStreamAttributesHandler {

   @Override
   public Map<String, Object> readExportCompanyTemplateVirtualExportFile(final Map<String, Object> parameters, final Connection connection) {      
      String fileName = "CompanyTemplates.zip";      

      InputStream inputResultStream = null;      
      ZipOutputStream zippedOutputStream = null;            
      List<InputStream> fileList = new ArrayList<>();
      List<String> templateIdList = new ArrayList<>();
      
      Map <String, Object> returnMap = new HashMap<String, Object>();
      String objkey = (String) parameters.get("Objkey");
      try {         
         ByteArrayOutputStream bos = new ByteArrayOutputStream();
         zippedOutputStream = new ZipOutputStream(bos);         

         // create query to fetch the template files
         String query = "select template_file, file_name from EXPORT_COMPANY_TEMPLATE_TO_FILE_ASSISTANT_HANDLING_EXPORT_COMPANY_TEMPLATE_FILES_VRT where parent_objkey = ?";         
         //Logger.getLogger(ExportCompanyTemplateToFileAssistantHandlingStreamAttributesHandlerImpl.class.getName()).log(Level.INFO, query);
         
         PreparedStatement statement = connection.prepareStatement(query);
         statement.setString(1, objkey);
         ResultSet resultSet = statement.executeQuery();                                    
         StringBuffer fName = new StringBuffer("TemplateId.ins");

         Integer iRowNo = new Integer(0);
         // add the template file to a file list of names and to a template list of template files
         while (resultSet.next()) {
            iRowNo = resultSet.getRow();            
            //get the template file (blob)
            fileList.add(resultSet.getBlob("template_file").getBinaryStream());            
            // get the file name of the template file
            templateIdList.add(resultSet.getString("file_name"));                                    
         }                  
         for (int i = 0; i < fileList.size(); i++) {                        
            fName.setLength(0);
            //set the file name for the template file and then add to zip-file.
            fName.append(templateIdList.get(i));            
            addToZipFile(fName.toString(), fileList.get(i), zippedOutputStream);            
         }
         zippedOutputStream.close();         
         byte[] zipBytes = bos.toByteArray();                  
         inputResultStream = new ByteArrayInputStream(zipBytes);
		} catch (IOException e) {                  
			e.printStackTrace();         
      } catch (Exception e) {         
         //Logger.getLogger(ExportCompanyTemplateToFileAssistantHandlingStreamAttributesHandlerImpl.class.getName()).log(Level.SEVERE, e.toString());         
         e.printStackTrace();
      }      
      returnMap.put("ExportFile", inputResultStream);
      returnMap.put("FileName", fileName);            
   
      return returnMap;         
   }         
   
   @Override
   public Map<String, Object> updateExportCompanyTemplateVirtualExportFile(final Map<String, Object> parameters, final Connection connection) {
      throw new UnsupportedOperationException("Not supported yet.");
   }
   @Override
   public Map<String, Object> deleteExportCompanyTemplateVirtualExportFile(final Map<String, Object> parameters, final Connection connection) {
      throw new UnsupportedOperationException("Not supported yet.");
   }

	public static void addToZipFile(String fileName, InputStream fileInputStream, ZipOutputStream zipOutputStream) throws FileNotFoundException, IOException {
      try {                  
         //Logger.getLogger(ExportCompanyTemplateToFileAssistantHandlingStreamAttributesHandlerImpl.class.getName()).log(Level.INFO, "Writing '" + fileName + "' to zip file");
         ZipEntry zipEntry = new ZipEntry(fileName);
         zipOutputStream.putNextEntry(zipEntry);

         byte[] bytes = new byte[1024];
         int length;
         while ((length = fileInputStream.read(bytes)) >= 0) {            
            zipOutputStream.write(bytes, 0, length);
         }
         zipOutputStream.closeEntry();      
         fileInputStream.close();
      } catch (Exception e) {         
         e.printStackTrace();
      }      
	}  
}