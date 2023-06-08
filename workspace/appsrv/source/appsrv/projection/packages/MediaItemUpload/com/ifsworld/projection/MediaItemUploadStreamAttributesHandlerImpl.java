/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 * ---------------------------------------------------------------------------
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: MediaItemUpload
 *  Type:         Entity
 *  Component:    APPSRV
 *
 * ---------------------------------------------------------------------------
 * Date    Sign    Comment
 * ----------------------------------------------------------------------------
 * 210125  DEEKLK  AM2020R1-7316, Moved all global actions into MediaItemUtil.
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
 * Implementation class that contains Read, Update and Delete methods for Stream type entity attributes
 * which are marked with implementation = "Java" in the MediaItemUpload projection model.
 */
@Stateless(name = "MediaItemUploadStreamAttributesHandler")
public class MediaItemUploadStreamAttributesHandlerImpl implements MediaItemUploadStreamAttributesHandler {

   @Override
   public Map<String, Object> updateMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {
      try {
         MediaItemUtil mediaUtil = new MediaItemUtil();
         return mediaUtil.updateMediaItem(parameters, connection);
      } catch (ProjectionException ex) {
         throw new ProjectionException(ex.getMessage(), ex, ex.getCustomCode());
      }catch (Exception ex) {
         throw new ProjectionException(ex.getMessage(), ex);
      }
   }

   @Override
   public Map<String, Object> readMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {
      // We dont read files on the assistants
      throw new ProjectionException("Not supported.");
   }

   @Override
   public Map<String, Object> deleteMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {
      // We delete attached media items from a separate page
      throw new ProjectionException("Not supported.");
   }

}
