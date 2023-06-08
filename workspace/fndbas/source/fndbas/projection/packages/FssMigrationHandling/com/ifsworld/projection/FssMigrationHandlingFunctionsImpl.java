/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: FssMigrationHandling
 *  Component:    FNDBAS
 *
 * ---------------------------------------------------------------------------
 */
package com.ifsworld.projection;

import static com.ifsworld.fnd.fss.api.Constants.FILE_DATA;
import static com.ifsworld.fnd.fss.api.Constants.FILE_EXTENSION;
import static com.ifsworld.fnd.fss.api.Constants.FILE_LENGTH;
import static com.ifsworld.fnd.fss.api.Constants.FILE_TYPE;
import static com.ifsworld.fnd.fss.api.Constants.FILE_NAME;
import static com.ifsworld.fnd.fss.api.Constants.IFS_USER;
import com.ifsworld.fnd.fss.api.FileHandlerUtil;
import com.ifsworld.fnd.fss.api.FileStorageRequest;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import java.io.ByteArrayInputStream;
import javax.ejb.Stateless;
import java.io.InputStream;
import java.sql.Connection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.json.Json;
import javax.json.JsonObjectBuilder;

/*
 * Implementation class for all global functions defined in the FssMigrationHandling projection model.
 * Note: Functions should not change database state!
 */
@Stateless(name = "FssMigrationHandlingFunctions")
public class FssMigrationHandlingFunctionsImpl implements FssMigrationHandlingFunctions {

   @Override
   public Map<String, Object> getFileData(final Map<String, Object> parameters, final Connection connection) {
      final Map<String, Object> inputParameters = new HashMap<>();
      inputParameters.put(IFS_USER, parameters.get(IFS_USER).toString());
      FileStorageRequest fileStorageRequest = new FileStorageRequest(parameters.get("FileId").toString(), parameters.get("BucketName").toString(), inputParameters);
      try {
         final Map<String, Object> outputParameters = FileHandlerUtil.downloadFile(fileStorageRequest);
         final InputStream returnInputStream = (InputStream) outputParameters.get(FILE_DATA);
         final Map<String, Object> returnMap = new HashMap<>();
         if (returnInputStream != null) {
            returnMap.put("GetFileData", returnInputStream);
         } else {
            returnMap.put("GetFileData", null);
         }
         return returnMap;
      } catch (Exception e) {
         throw new ProjectionException("Failed to get the file from File Storage Service. " + e.getMessage());
      }
   }

   @Override
   public Map<String, Object> getFileProperties(final Map<String, Object> parameters, final Connection connection) {
      final Map<String, Object> inputParameters = new HashMap<>();
      inputParameters.put(IFS_USER, parameters.get(IFS_USER).toString());
      FileStorageRequest fileStorageRequest = new FileStorageRequest(parameters.get("FileId").toString(), parameters.get("BucketName").toString(), inputParameters);
      try {
         final Map<String, Object> outputParameters = FileHandlerUtil.getFileProperties(fileStorageRequest);
         final Map<String, Object> returnMap = new LinkedHashMap();
         if (outputParameters != null) {
            final JsonObjectBuilder returnObject = Json.createObjectBuilder();
            returnObject.add("FileName", outputParameters.get(FILE_NAME).toString());
            returnObject.add("FileExtension", outputParameters.get(FILE_EXTENSION).toString());
            returnObject.add("FileType", outputParameters.get(FILE_TYPE).toString());
            returnObject.add("FileLength", outputParameters.get(FILE_LENGTH).toString());
            returnMap.put("GetFileProperties", new ByteArrayInputStream(returnObject.build().toString().getBytes()));
         } else {
            returnMap.put("GetFileProperties", null);
         }
         return returnMap;
      } catch (Exception e) {
         throw new ProjectionException("Failed to get file properties from File Storage Service. " + e.getMessage());
      }
   }
}
