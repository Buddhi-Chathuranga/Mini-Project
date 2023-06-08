/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 * ---------------------------------------------------------------------------
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: FssMigrationHandling
 *  Component:    FNDBAS
 *
 * ---------------------------------------------------------------------------
 */
package com.ifsworld.projection;

import static com.ifsworld.fnd.fss.api.Constants.FILE_LENGTH;
import static com.ifsworld.fnd.fss.api.Constants.IFS_USER;
import com.ifsworld.fnd.fss.api.FileHandlerUtil;
import com.ifsworld.fnd.fss.api.FileStorageRequest;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import java.io.InputStream;
import javax.ejb.Stateless;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;


/*
 * Implementation class that contains Read, Update and Delete methods for Stream type entity attributes
 * which are marked with implementation = "Java" in the FssMigrationHandling projection model.
 */
@Stateless(name = "FssMigrationHandlingStreamAttributesHandler")
public class FssMigrationHandlingStreamAttributesHandlerImpl implements FssMigrationHandlingStreamAttributesHandler {

   @Override
   public Map<String, Object> readFileInfoVirtualFileData(final Map<String, Object> parameters, final Connection connection) {
      throw new UnsupportedOperationException("Not supported yet.");
   }

   @Override
   public Map<String, Object> updateFileInfoVirtualFileData(final Map<String, Object> parameters, final Connection connection) {
      final String fileInfoQuery = "SELECT * FROM FSS_MIGRATION_HANDLING_FILE_INFO_VIRTUAL_VRT WHERE objkey = ?";
      try (final PreparedStatement pstmt = connection.prepareStatement(fileInfoQuery)) {
         pstmt.setString(1, parameters.get("Objkey").toString());
         final ResultSet resultSet = pstmt.executeQuery();
         final Map<String, Object> inputParameters = new HashMap<>();
         Map<String, Object> outputParameters = new HashMap<>();
         inputParameters.put(IFS_USER, parameters.get(IFS_USER).toString());
         inputParameters.put(FILE_LENGTH, parameters.get("FileLength"));
         if (resultSet.next()) {
            FileStorageRequest fileStorageRequest = 
                    new FileStorageRequest(resultSet.getString("file_id"), resultSet.getString("bucket_name"), resultSet.getString("file_name"), inputParameters)
                            .setFileData((InputStream) parameters.get("FileData"));
            outputParameters = FileHandlerUtil.uploadFile(fileStorageRequest);
         }
         return outputParameters;
      } catch (SQLException e) {
         throw new ProjectionException("Error in reading file info from database" + e.getMessage());
      } catch (Exception e) {
         throw new ProjectionException("Failed to upload file to FSS. " + e.getMessage());
      }
   }

   @Override
   public Map<String, Object> deleteFileInfoVirtualFileData(final Map<String, Object> parameters, final Connection connection) {
      throw new UnsupportedOperationException("Delete of file data not allowed.");
   }
}
