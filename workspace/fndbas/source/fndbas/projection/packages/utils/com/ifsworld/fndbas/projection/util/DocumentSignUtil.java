/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ifsworld.fndbas.projection.util;

import com.ifsworld.digitalsigner.DocumentSigner;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import com.ifsworld.fnd.odp.api.storage.model.StructureValue;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import javax.imageio.ImageIO;

/**
 *
 * @author maiklk
 */
public class DocumentSignUtil {
   
   private DocumentSignUtil(){
      
   }
   public static Map<String, Object> SignDocumentWithUser(final Map<String, Object> parameters, byte[] document, final Connection connection) {
      Map<String, Object> returnMap = new HashMap<>();              
      String certifyStr = (String)parameters.get("Certify");
      boolean certify=Boolean.parseBoolean(certifyStr);
      Object visualProp = parameters.get("VisualProp");
      DocumentSigner documentSigner = new DocumentSigner();
      if(visualProp != null){
         setVisibleSignatureProperties(documentSigner, visualProp, connection);
      }    
      try { 
         byte[] signedPdf = documentSigner.signPDFByUser(document, certify, (String)parameters.get("Reason"), connection);
         returnMap.put("SignPDFByUser",signedPdf );     
      } catch (Exception ex) {
         throw new ProjectionException(ex.getMessage());   
      }
      return returnMap;
   }
   
   public static Map<String, Object> SignDocumentWithKey(final Map<String, Object> parameters, byte[] document, final Connection connection) {
      Map<String, Object> returnMap = new HashMap<>();
           
      String keystoreId=(String)parameters.get("KeystoreId");
      String certifyStr = (String)parameters.get("Certify");
      boolean certify=Boolean.parseBoolean(certifyStr);
      Object visualProp = parameters.get("VisualProp");
      DocumentSigner documentSigner = new DocumentSigner();
      if(visualProp != null){
         setVisibleSignatureProperties(documentSigner, visualProp, connection);
      }  
      try {  
         byte[] signedPdf = documentSigner.signPDFWithKey(document, keystoreId, certify, (String)parameters.get("Reason"), connection);
         returnMap.put("SignPDFWithKey",signedPdf );  
      }
      catch (Exception ex) {
         throw new ProjectionException(ex.getMessage());   
      }
      return returnMap;
   }
   
   private static void setVisibleSignatureProperties(DocumentSigner documentSigner, Object visualProp, Connection connection){
      StructureValue structValue =(StructureValue)visualProp;
      Object[] arr = structValue.getAttributes();
      if(arr.length > 0){         
         Long pageLongVal = (Long)arr[0];
         int page = pageLongVal.intValue();          
         Long preferredSizeLongVal = (Long)arr[1];
         int preferredSize = preferredSizeLongVal.intValue();
         String signImageName = (String)arr[2];
         byte[] imageInByte = getImage(signImageName, connection);
         InputStream in = new ByteArrayInputStream(imageInByte);
         BufferedImage image = null;
         try {
            image = ImageIO.read(in);
         } catch (IOException ex) {
            throw new ProjectionException("Error when fetching the signature image", ex);
         }
         String watermarkImageName = (String)arr[3];
         byte[] watermarkByte = getImage(watermarkImageName, connection);
         InputStream watermarkStream = new ByteArrayInputStream(watermarkByte);
         BufferedImage watermarkImage = null;
         try {
            watermarkImage = ImageIO.read(watermarkStream);
         } catch (IOException ex) {
            throw new ProjectionException("Error when fetching the warter mark image", ex);
         }
         BigDecimal xBigDecimal = (BigDecimal)arr[4];
         double x = xBigDecimal.doubleValue();        
         BigDecimal yBigDecimal = (BigDecimal)arr[5];
         double y = yBigDecimal.doubleValue();         
         Long zoomPercentLongVal = (Long)arr[6];
         int zoomPercent = zoomPercentLongVal.intValue();
         String style = (String)arr[7];
         documentSigner.setVisibleSignatureProperties(image, page, x, y, zoomPercent, preferredSize, style, watermarkImage);
      }
   }
   
   private static byte[] getImage(String imageName, Connection connection){
      try (PreparedStatement pstmt = connection.prepareStatement("select image from report_signatures_tab where image_name = ?")) {
         pstmt.setString(1, imageName);            
         ResultSet resultSet = pstmt.executeQuery();
         while (resultSet.next()) {
            return resultSet.getBytes("image");
         }
      } 
      catch (Exception e){
         throw new ProjectionException("Error when fetching the image from report signature table", e);
      }
      return null;
   }
}
