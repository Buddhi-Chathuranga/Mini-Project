/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: ReportSignHandling
 *  Type:         Entity
 *  Component:    FNDBAS
 *
 * ---------------------------------------------------------------------------
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
 * Implementation class for all global actions defined in the ReportSignHandling projection model.
 */

@Stateless(name="ReportSignHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class ReportSignHandlingActionsImpl extends ReportSignHandlingActionsFragmentsWrapper implements ReportSignHandlingActions {

   @Override
   public Map<String, Object> signReportByUser(final Map<String, Object> parameters, final Connection connection) {
      String resultKey=(String)parameters.get("ResultKey");
      String id=(String)parameters.get("Id");
      byte[] report = getReport(resultKey,id,connection);      
      return DocumentSignUtil.SignDocumentWithUser(parameters, report, connection);              
   }
   
   @Override
   public Map<String, Object> signReportWithKey(final Map<String, Object> parameters, final Connection connection) {
      String resultKey=(String)parameters.get("ResultKey");
      String id=(String)parameters.get("Id");
      byte[] report = getReport(resultKey,id,connection);          
      return DocumentSignUtil.SignDocumentWithKey(parameters, report, connection);              
   }
   
    byte[] getReport(String resultKey, String id, Connection connection) {
       try (PreparedStatement pstmt = connection.prepareStatement("select pdf from pdf_archive where result_key = ? and id = ?")) {
         pstmt.setString(1, resultKey); 
         pstmt.setString(2, id);
         ResultSet resultSet = pstmt.executeQuery();
         while (resultSet.next()) {
            return resultSet.getBytes("pdf");
         }
      } 
      catch (Exception e)
      {
         throw new ProjectionException("Error when fetching the report from pdf archive view", e);
      }
      return null;
   }
}