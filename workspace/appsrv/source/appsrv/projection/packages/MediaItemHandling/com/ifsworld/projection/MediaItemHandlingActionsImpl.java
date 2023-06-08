/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: MediaItemHandling
 *  Component:    APPSRV
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.appsrv.projection.util.MediaItemUtil;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

/*
 * Implementation class for all global actions defined in the MediaItemHandling projection model.
 */

@Stateless(name="MediaItemHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class MediaItemHandlingActionsImpl implements MediaItemHandlingActions {

   @Override
   public Map<String, Object> deleteMediaItem(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> returnMap = new HashMap<>();
      
      try {
         MediaItemUtil mediaUtil = new MediaItemUtil();
         mediaUtil.deleteMediaItem(parameters, connection);
      } catch (ProjectionException ex) {
         throw new ProjectionException(ex.getMessage(), ex, ex.getCustomCode());
      } catch (Exception ex) {
         throw new ProjectionException(ex.getMessage(), ex);
      }
      return returnMap;
   }
}
