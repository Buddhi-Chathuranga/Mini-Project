/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: MediaLibraryAttachmentHandling
 *  Component:    APPSRV
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.appsrv.projection.util.MediaItemUtil;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import javax.ejb.Stateless;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

/*
 * Implementation class for all global functions defined in the MediaLibraryAttachmentHandling projection model.
 * Note: Functions should not change database state!
 */

@Stateless(name="MediaLibraryAttachmentHandlingFunctions")
public class MediaLibraryAttachmentHandlingFunctionsImpl implements MediaLibraryAttachmentHandlingFunctions {

   @Override
   public Map<String, Object> getMediaFileStream(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> returnMap = new HashMap<>();
      try {
         MediaItemUtil mediaItemUtil = new MediaItemUtil();
         returnMap = mediaItemUtil.readMediaItem(parameters, connection); 
         returnMap.put("GetMediaFileStream", returnMap.get("MediaObject"));      
         returnMap.remove("MediaObject");
      } catch (ProjectionException ex) {
         throw new ProjectionException(ex.getMessage(), ex, ex.getCustomCode());
      }catch (Exception ex) {
         throw new ProjectionException(ex.getMessage(), ex);
      }
      return returnMap;
   }
}
