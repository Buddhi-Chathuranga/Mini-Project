/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: MediaLibraryRepositoryTransferService
 *  Component:    APPSRV
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.appsrv.projection.util.MediaItemUtil;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import com.ifsworld.fnd.odp.api.storage.model.StructureValue;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static com.ifsworld.fnd.fss.api.Constants.IFS_USER;
import static com.ifsworld.fnd.fss.api.Constants.SKIP_FILE_SCAN;
/*
 * Implementation class for all global actions defined in the MediaLibraryRepositoryTransferService projection model.
 */

@Stateless(name="MediaLibraryRepositoryTransferServiceActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class MediaLibraryRepositoryTransferServiceActionsImpl implements MediaLibraryRepositoryTransferServiceActions {

   @Override
   public Map<String, Object> moveFromDbToFss(final Map<String, Object> parameters, final Connection connection) {
      try {
         Map<String, Object> inputParams = new HashMap<>();

         StructureValue mediaParams = (StructureValue) parameters.get("MediaItemParameters");
         inputParams.put("ItemId",     (int) MediaItemUtil.validateNumberObject("ItemId",       mediaParams, inputParams, false));
         inputParams.put("FileName",         MediaItemUtil.validateTextObject  ("FileName",     mediaParams, inputParams, false));
         inputParams.put("FileLength", (int) MediaItemUtil.validateNumberObject("DbFileLength", mediaParams, inputParams, false));
         
         if (parameters.containsKey(IFS_USER) && parameters.get(IFS_USER) != null) {
            inputParams.put(IFS_USER, parameters.get(IFS_USER).toString());
         }
         if (parameters.containsKey(SKIP_FILE_SCAN) && parameters.get(SKIP_FILE_SCAN) != null) {
            inputParams.put(SKIP_FILE_SCAN, parameters.get(SKIP_FILE_SCAN).toString());
         }
         
         MediaItemUtil mediaItemUtil = new MediaItemUtil();
         mediaItemUtil.moveFromDbToFss(inputParams, connection);
      } catch (ProjectionException ex) {
         throw new ProjectionException(ex.getMessage(), ex, ex.getCustomCode());
      }catch (Exception e) {
         throw new ProjectionException("Error when moving media from DB to File Storage. [" + e.getMessage() + "]", e);
      }
      return null;
   }

   @Override
   public Map<String, Object> moveFromFssToDb(final Map<String, Object> parameters, final Connection connection) {
      try {
         Map<String, Object> inputParams = new HashMap<>();

         StructureValue mediaParams = (StructureValue) parameters.get("MediaItemParameters");
         inputParams.put("ItemId", (int)MediaItemUtil.validateNumberObject("ItemId", mediaParams, inputParams, false));
         
         if (parameters.containsKey(IFS_USER) && parameters.get(IFS_USER) != null) {
            inputParams.put(IFS_USER, parameters.get(IFS_USER).toString());
         }
         if (parameters.containsKey(SKIP_FILE_SCAN) && parameters.get(SKIP_FILE_SCAN) != null) {
            inputParams.put(SKIP_FILE_SCAN, parameters.get(SKIP_FILE_SCAN).toString());
         }
         
         MediaItemUtil mediaItemUtil = new MediaItemUtil();
         mediaItemUtil.moveFromFssToDb(inputParams, connection);
      } catch (ProjectionException ex) {
         throw new ProjectionException(ex.getMessage(), ex, ex.getCustomCode());
      }catch (Exception e) {
         throw new ProjectionException("Error when moving media from File Storage to DB. [" + e.getMessage() + "]", e);
      }
      return null;
   }
}