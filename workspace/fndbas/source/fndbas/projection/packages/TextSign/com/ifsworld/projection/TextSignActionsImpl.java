/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: TextSign
 *  Type:         Projection
 *  Component:    FNDBAS
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import java.io.ByteArrayInputStream;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.io.InputStream;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import com.ifsworld.digitalsigner.DocumentSigner;
/*
 * Implementation class for all global actions defined in the TextSign projection model.
 */

@Stateless(name="TextSignActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class TextSignActionsImpl implements TextSignActions {

   @Override
   public Map<String, Object> signTextWithKey(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> returnMap = new HashMap<>();
      try {
         String signText=(String)parameters.get("SignText");
         String keyStoreId=(String)parameters.get("KeyStoreId");
         DocumentSigner documentSigner = new DocumentSigner();
         String returnValue = documentSigner.signTextWithKey(signText, keyStoreId, connection);
         returnMap.put("SignTextWithKey",new ByteArrayInputStream(("{\"return\":\"" + returnValue + "\"}").getBytes()));        
      } catch (Exception ex) {
         throw new ProjectionException(ex.getMessage());         
      }
      return returnMap;
   }
}