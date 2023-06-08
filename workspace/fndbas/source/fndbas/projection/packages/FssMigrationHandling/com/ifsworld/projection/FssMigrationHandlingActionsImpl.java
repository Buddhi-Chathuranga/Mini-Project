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

import static com.ifsworld.fnd.fss.api.Constants.IFS_USER;
import com.ifsworld.fnd.fss.api.FileHandlerUtil;
import com.ifsworld.fnd.fss.api.FileStorageRequest;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

/*
 * Implementation class for all global actions defined in the FssMigrationHandling projection model.
 */
@Stateless(name = "FssMigrationHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class FssMigrationHandlingActionsImpl implements FssMigrationHandlingActions {

   @Override
   public Map<String, Object> removeFileData(final Map<String, Object> parameters, final Connection connection) {
      final Map<String, Object> inputParameters = new HashMap<>();
      inputParameters.put(IFS_USER, parameters.get(IFS_USER).toString());
      FileStorageRequest fileStorageRequest = new FileStorageRequest(parameters.get("FileId").toString(), parameters.get("BucketName").toString(), inputParameters);

      try {
         return FileHandlerUtil.deleteFile(fileStorageRequest);
      } catch (Exception e) {
         throw new ProjectionException("Failed to remove the file from File Storage Service." + e.getMessage());
      }
   }
}
