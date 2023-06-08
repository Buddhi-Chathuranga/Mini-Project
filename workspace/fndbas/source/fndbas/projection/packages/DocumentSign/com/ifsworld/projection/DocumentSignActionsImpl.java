/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ----------------------------------------------------------------------------
 *
 *  Logical unit: DocumentSign
 *  Type:         Entity
 *  Component:    FNDBAS
 *
 * ----------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;
import com.ifsworld.fndbas.projection.util.DocumentSignUtil;
/*
 * Implementation class for all global actions defined in the DocumentSign projection model.
 */

@Stateless(name="DocumentSignActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class DocumentSignActionsImpl implements DocumentSignActions {

   @Override
   public Map<String, Object> signPDFByUser(final Map<String, Object> parameters, final Connection connection) {
      String lobId=(String)parameters.get("LobId");
      byte[] pdf = getPdf(lobId, connection);                
      return DocumentSignUtil.SignDocumentWithUser(parameters, pdf, connection);               
   }
   
   @Override
   public Map<String, Object> signPDFWithKey(final Map<String, Object> parameters, final Connection connection) {
      String lobId=(String)parameters.get("LobId");
      byte[] pdf = getPdf(lobId, connection);         
      return DocumentSignUtil.SignDocumentWithKey(parameters, pdf, connection);              
   }      
      
   byte[] getPdf(String lobId, Connection connection) {
       try (PreparedStatement pstmt = connection.prepareStatement("select blob_data from fnd_temp_lob_store_tab where lob_id = ?")) {
         pstmt.setString(1, lobId);            
         ResultSet resultSet = pstmt.executeQuery();
         while (resultSet.next()) {
            return resultSet.getBytes("blob_data");
         }
      } 
      catch (Exception e)
      {
         throw new ProjectionException("Error when fetching the pdf from lob table", e);
      }
      return null;
   }
   
}