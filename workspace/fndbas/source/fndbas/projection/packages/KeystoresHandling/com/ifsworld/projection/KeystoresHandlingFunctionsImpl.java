/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: KeystoresHandling
 *  Type:         Entity
 *  Component:    FNDBAS
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import java.io.ByteArrayInputStream;
import javax.ejb.Stateless;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

/*
 * Implementation class for all global functions defined in the KeystoresHandling projection model.
 * Note: Functions should not change database state!
 */

@Stateless(name="KeystoresHandlingFunctions")
public class KeystoresHandlingFunctionsImpl implements KeystoresHandlingFunctions {

   @Override
   public Map<String, Object> isPasswordProtected(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> returnMap = new HashMap<>();       
      String objkey=(String)parameters.get("Objkey");
      String fileName=(String)parameters.get("FileName");

      byte[] fileData = getFileData(objkey, connection);
      if(fileData != null){
         String pfx = new String(fileData, StandardCharsets.UTF_8);
         if(fileName.endsWith(".pfx") || fileName.endsWith(".p12") || pfx.contains("ENCRYPTED")){
            //password protected
            returnMap.put("IsPasswordProtected", new ByteArrayInputStream(("{\"return\":\"true\"}").getBytes()));
            return returnMap;
         }
      }        
      returnMap.put("IsPasswordProtected", new ByteArrayInputStream(("{\"return\":\"false\"}").getBytes()));
      return returnMap;
   }
   
   byte[] getFileData(String objkey, Connection connection) throws ProjectionException {
      try (PreparedStatement pstmt = connection.prepareStatement("select file_data from KEYSTORES_HANDLING_KEYSTORE_VIRTUAL_VRT where objkey = ?")) {
         pstmt.setString(1, objkey);            
         ResultSet resultSet = pstmt.executeQuery();
         while (resultSet.next()) {
            return resultSet.getBytes("file_data");             
         }
      } 
      catch (Exception e)
      {
         throw new ProjectionException("Error when fetching the pfx file from keystore table", e);
      }
      return null;
   }
}