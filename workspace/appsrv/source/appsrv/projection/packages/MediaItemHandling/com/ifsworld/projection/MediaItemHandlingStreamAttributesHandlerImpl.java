/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 * ---------------------------------------------------------------------------
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: MediaItemHandling
 *  Type:         Entity
 *  Component:    APPSRV
 *
 * ---------------------------------------------------------------------------
 * Date    Sign    Comment
 * ----------------------------------------------------------------------------
 * 210125  DEEKLK  AM2020R1-7316, Created.
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
 * which are marked with implementation = "Java" in the MediaItemHandling projection model.
 */
@Stateless(name = "MediaItemHandlingStreamAttributesHandler")
public class MediaItemHandlingStreamAttributesHandlerImpl implements MediaItemHandlingStreamAttributesHandler {

   @Override
   public Map<String, Object> updateMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {
      try {
         MediaItemUtil mediaUtil = new MediaItemUtil();
         return mediaUtil.updateMediaItem(parameters, connection);
      } catch (ProjectionException ex) {
         throw new ProjectionException(ex.getMessage(), ex, ex.getCustomCode());
      } catch (Exception ex) {
         throw new ProjectionException(ex.getMessage(), ex);
      }
   }

   @Override
   public Map<String, Object> readMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> returnMap = new HashMap<>();
      try {
         MediaItemUtil mediaUtil = new MediaItemUtil();
         returnMap = mediaUtil.readMediaItem(parameters, connection);
      } catch (ProjectionException ex) {
         throw new ProjectionException(ex.getMessage(), ex, ex.getCustomCode());
      }  catch (Exception ex) {
         throw new ProjectionException(ex.getMessage(), ex);
      }
         return returnMap;
   }

   @Override
   public Map<String, Object> deleteMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {
      throw new ProjectionException("Not supported yet.");
   }
}
