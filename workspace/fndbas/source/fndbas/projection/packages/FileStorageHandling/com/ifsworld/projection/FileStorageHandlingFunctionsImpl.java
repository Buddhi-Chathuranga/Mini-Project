/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: FileStorageHandling
 *  Component:    FNDBAS
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import static com.ifsworld.fnd.fss.api.Constants.FILE_ID;
import static com.ifsworld.fnd.fss.api.Constants.LU_NAME;
import static com.ifsworld.fnd.fss.api.Constants.SCAN_STATUS;
import com.ifsworld.fnd.fss.api.FileHandlerUtil;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import java.io.ByteArrayInputStream;
import javax.ejb.Stateless;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

/*
 * Implementation class for all global functions defined in the FileStorageHandling projection model.
 * Note: Functions should not change database state!
 */

@Stateless(name="FileStorageHandlingFunctions")
public class FileStorageHandlingFunctionsImpl implements FileStorageHandlingFunctions {
   
   @Override
   public Map<String, Object> getFileScanStatus(final Map<String, Object> parameters, final Connection connection) {
      final Map<String, Object> inputParameters = new HashMap<>();
      inputParameters.put(FILE_ID, parameters.get("FileId").toString());
      inputParameters.put(LU_NAME, parameters.get("BucketName").toString());
      final Map<String, Object> returnMap = new HashMap<>();
      try {
         final Map<String, Object> outputParameters = FileHandlerUtil.getFileProperties(inputParameters);
         returnMap.put("GetFileScanStatus", new ByteArrayInputStream(("{\"return\": \"" + outputParameters.get(SCAN_STATUS).toString() + "\"}").getBytes()));
         return returnMap;
      } catch (Exception e) {
         throw new ProjectionException("Failed to get file scan status from File Storage Service." + e.getMessage());
      }
   }
}