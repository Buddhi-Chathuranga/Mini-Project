/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ----------------------------------------------------------------------------
 *
 *  Logical unit: KeystoresHandling
 *  Type:         Projection
 *  Component:    FNDBAS
 *
 * ----------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.fnd.odp.api.exception.ProjectionException;
//import ifs.fnd.util.Str;
import java.io.ByteArrayInputStream;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;
import com.ifsworld.digitalsigner.ConnectSecurityManager;
/*
 * Implementation class for all global actions defined in the KeystoresHandling projection model.
 */

@Stateless(name="KeystoresHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class KeystoresHandlingActionsImpl implements KeystoresHandlingActions {

   @Override
   public Map<String, Object> importKeystore(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> returnMap = new HashMap<>();     
      String objkey=(String)parameters.get("Objkey");
      ConnectSecurityManager manager = new ConnectSecurityManager();
      Map<String, Object> keystoreMap = getKeystoreRec(objkey, connection);
      if(!keystoreMap.isEmpty()){        
         byte[] fileData = (byte[]) keystoreMap.get("FileData");
         String fileType = "SIGN"; // not used yet so hardcoded for now
         Date expireDate = new Date();
         String userName = (String)keystoreMap.get("UserName");
         String type = (String)keystoreMap.get("Type");
         if("KEYSTORE".equals(type)){
            userName = "*";
         }
         String description = (String)keystoreMap.get("Description");
         String keystoreId = (String)keystoreMap.get("KeystoreId");
         if(!"*".equals(userName)){
            keystoreId = "UserCertificate";
         }
         String fileName = (String)keystoreMap.get("FileName");
         String password = (String)keystoreMap.get("Password");
         Map<String, Object> otherParams = new HashMap<>();
         otherParams.put("expireDate", expireDate);
         otherParams.put("fileType", fileType);
         try {
            if(fileName!= null && fileData!=null && fileData.length>0) {
               fileName = fileName.toLowerCase();
               if(Pattern.compile("pfx$|p12$").matcher(fileName).find()) {
                  fileData = manager.processPfx(fileData, password, otherParams, connection);
                  expireDate = (Date)otherParams.get("expireDate");
                  fileType = (String)otherParams.get("fileType");
               }
               else if(Pattern.compile("pem$|key$").matcher(fileName).find()) {
                  fileData = manager.processPem(fileData, otherParams, userName, password, connection);
                  expireDate = (Date)otherParams.get("expireDate");
                  fileType = (String)otherParams.get("fileType");
                  if("KeyStore".equals(fileType)) {
                     fileName += ".pfx";
                  }
                  else if(!"Certificate".equals(fileType)) {                     
                     expireDate = null;
                  }
               }
               else if(Pattern.compile("cer$|crt$|cert$").matcher(fileName).find()) {
                  manager.verifyCertificate(fileData, otherParams);
                  expireDate = (Date)otherParams.get("expireDate");
                  fileType = "Certificate";
               }
            }
            else {  // not pfx supplied. Generate a new.
               fileData = manager.generateSelfSignedKeystore(userName, otherParams, connection);
               expireDate = (Date)otherParams.get("expireDate");
               fileType = "Keystore";
               if(fileName == null ||  fileName.isEmpty()) {
                  fileName = "*".equals(userName) ? keystoreId+".pfx" : userName+".pfx";
               }
            }
         } catch(Exception ex){
            throw new ProjectionException("Error when importing the certificate.", ex);
         }
         // Add the record to db
         newKeystore(keystoreId, userName, description, fileType, fileName, expireDate, fileData, connection);
         returnMap.put("ImportKeystore", new ByteArrayInputStream(("{\"return\":\"true\"}").getBytes()));
         return returnMap;
      }      
      returnMap.put("ImportKeyStore", new ByteArrayInputStream(("{\"return\":\"false\"}").getBytes()));
      return returnMap;
   }
   
   private Map<String, Object> getKeystoreRec(String objkey, Connection connection){
      Map<String, Object> returnMap = new HashMap<>(); 
      try (PreparedStatement pstmt = connection.prepareStatement("select user_name,description,keystore_id,file_name,password,file_data,type from KEYSTORES_HANDLING_KEYSTORE_VIRTUAL_VRT where objkey = ?")) {
         pstmt.setString(1, objkey);            
         ResultSet resultSet = pstmt.executeQuery();
         while (resultSet.next()) {
            //return resultSet.getBytes("file_data");
             if(returnMap.isEmpty()){
                   returnMap.put("UserName", resultSet.getString("user_name")); 
                   returnMap.put("Description", resultSet.getString("description"));  
                   returnMap.put("KeystoreId", resultSet.getString("keystore_id")); 
                   returnMap.put("FileName", resultSet.getString("file_name"));  
                   returnMap.put("Password", resultSet.getString("password"));  
                   returnMap.put("FileData", resultSet.getBytes("file_data")); 
                   returnMap.put("Type", resultSet.getString("type")); 
              }
         }
      } 
      catch (Exception e)
      {
         throw new ProjectionException("Error when fetching keystore record", e);
      }
      return returnMap;
   }
   
   private void newKeystore(String keystoreId, String userName, String description, String type, String fileName, Date expireDate, byte[] pfx, Connection connection)
   {
      CallableStatement stmt = null;
      try {         
         stmt = connection.prepareCall("{call Fnd_Keystore_API.New_Keystore(?, ?, ?, ?, ?, ?, ?)}");
         stmt.setString(1, keystoreId);
         stmt.setString(2, userName);
         stmt.setString(3, description);
         stmt.setString(4, type);
         stmt.setString(5, fileName);
         if(expireDate != null){
            java.sql.Date sqlDate = new java.sql.Date(expireDate.getTime());
            stmt.setDate(6, sqlDate);
         }
         else{
            stmt.setDate(6, null);
         }
         stmt.setBytes(7, pfx);
         stmt.execute();
      }      
      catch (Exception e)
      {
         throw new ProjectionException("Error when adding keystore record", e);
      }
      finally
      {
         if (stmt != null) { 
            try {
               stmt.close();
            } catch (SQLException ex) {
               throw new ProjectionException("Error when closing the connection on keystore record add", ex);
            }
         }
      }          
   }
}