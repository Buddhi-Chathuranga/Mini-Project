/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *  Date    Sign    History
 *  ------  ------  ---------------------------------------------------------
 *  211208  Chwilk  FI21R2-8072, Removed SOAPAction.
 *  220113  Chwilk  FI21R2-8424, Fixed for when no TAX_ID_TYPE is sent.
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: TaxIdNumbersValidation
 *  Type:         Entity
 *  Component:    ENTERP
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import java.io.IOException;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import static java.nio.charset.StandardCharsets.UTF_8;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/*
 * Implementation class for all global actions defined in the TaxIdNumbersValidation projection model.
 */

@Stateless(name="TaxIdNumbersValidationActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class TaxIdNumbersValidationActionsImpl implements TaxIdNumbersValidationActions {

   @Override
   public Map<String, Object> validateTaxIdNumbersCheckTaxService(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> returnParameters = new HashMap<>();
      String fullSelection = getParameter(parameters, "FullSelection");
      String projectionName = getParameter(parameters, "ProjectionName");
      String selection = fullSelection;
      String currentSelection;
      String tax_id_numbers_with_invalid_characters = "";
      String tax_id_numbers_with_no_country_code = "";
      String tax_id_numbers_with_not_eu_country_code = "";
      String tax_id_numbers_it_invalid_1 = "";
      String tax_id_numbers_it_invalid_2 = "";
      String tax_id_numbers_it_invalid_3 = "";
      String tax_id_numbers_invalid = "";
      String tax_id_types_invalid = "";
      String no_tax_id_types = "";
      String network_error = "";
      String returnValue;
      String taxIdType;
      
      while (selection.indexOf("\u001e") > 0) {
         currentSelection = selection.substring(0, selection.indexOf("\u001e"));
         int firstPosition = ("^" + currentSelection).indexOf("^TAX_ID_NUMBER=") + 14;
         int secondPosition = ("^" + currentSelection).indexOf("^", firstPosition + 1)-1;
         String taxIdNumber = currentSelection.substring(firstPosition, secondPosition);
         int firstPositionIt = ("^" + currentSelection).indexOf("^COUNTRY_CODE=") + 13;
         int secondPositionIt = ("^" + currentSelection).indexOf("^", firstPositionIt + 1)-1;
         String countryCode = currentSelection.substring(firstPositionIt, secondPositionIt);
         if (("^" + currentSelection).indexOf("^TAX_ID_TYPE=") != -1) {
            int firstPositionTaxIdType = ("^" + currentSelection).indexOf("^TAX_ID_TYPE=") + 12;
            int secondPositionTaxIdType = ("^" + currentSelection).indexOf("^", firstPositionTaxIdType + 1)-1;
            taxIdType = currentSelection.substring(firstPositionTaxIdType, secondPositionTaxIdType);
         } else {
            taxIdType = null;
         }
		 	
         String validity = getTaxIdNumberBasicValidation(taxIdNumber, countryCode, taxIdType, connection);
         if (validity.equals("INVALID_CHARACTERS")) {
            tax_id_numbers_with_invalid_characters = appendCharacter(tax_id_numbers_with_invalid_characters) + taxIdNumber;
         }
         else if (validity.equals("NO_COUNTRY_CODE")) {
            tax_id_numbers_with_no_country_code = appendCharacter(tax_id_numbers_with_no_country_code) + taxIdNumber;
         }
         else if (validity.equals("NOT_EU_COUNTRY_CODE")) {
            tax_id_numbers_with_not_eu_country_code = appendCharacter(tax_id_numbers_with_not_eu_country_code) + taxIdNumber;
         }
         else if (validity.equals("IT_INVALID_1")) {
            tax_id_numbers_it_invalid_1 = appendCharacter(tax_id_numbers_it_invalid_1) + taxIdNumber;
         }
         else if (validity.equals("IT_INVALID_2")) {
            tax_id_numbers_it_invalid_2 = appendCharacter(tax_id_numbers_it_invalid_2) + taxIdNumber;
         }
         else if (validity.equals("IT_INVALID_3")) {
            tax_id_numbers_it_invalid_3 = appendCharacter(tax_id_numbers_it_invalid_3) + taxIdNumber;
         } 
         else if (validity.equals("USE_CHECK_VAT_SERVICE")) {
            validity = validateTaxIdNo(taxIdNumber);
         } 
         else if (validity.equals("NO_VALID_TAX_ID_TYPE")) {
            tax_id_types_invalid = appendCharacter(tax_id_types_invalid) + taxIdType;
         } 
         else if (validity.equals("NO_TAX_ID_TYPE")) {
            no_tax_id_types = "NO_TAX_ID_TYPE";
         }
         if (validity.equals("NETWORK_ERROR")) {
            network_error = "ERROR";
         }
         if (validity.equals("INVALID")) {
            tax_id_numbers_invalid = appendCharacter(tax_id_numbers_invalid) + taxIdNumber;
         }
         if (validity.equals("VALID")) {
            updateValidatedDate(currentSelection, projectionName, connection);
         }
         selection = selection.substring(selection.indexOf("\u001e")+1);
      }

      returnValue = "{\"MsgTaxIdNumbersWithInvalidCharacters\":\"" + tax_id_numbers_with_invalid_characters + 
                    "\",\"MsgTaxIdNumbersWithNoCountryCode\":\"" + tax_id_numbers_with_no_country_code + 
                    "\",\"MsgTaxIdNumbersWithNotEuCountryCode\":\"" + tax_id_numbers_with_not_eu_country_code + 
                    "\",\"MsgTaxIdNumbersInvalid\":\"" + tax_id_numbers_invalid + 
                    "\",\"MsgTaxIdNumbersItInvalid1\":\"" + tax_id_numbers_it_invalid_1 + 
                    "\",\"MsgTaxIdNumbersItInvalid2\":\"" + tax_id_numbers_it_invalid_2 + 
                    "\",\"MsgTaxIdNumbersItInvalid3\":\"" + tax_id_numbers_it_invalid_3 +
                    "\",\"MsgTaxIdTypesInvalid\":\"" + tax_id_types_invalid +
                    "\",\"MsgNoTaxIdTypes\":\"" + no_tax_id_types +	
                    "\",\"MsgNetworkError\":\"" + network_error + "\"}";

      returnParameters.put("ValidateTaxIdNumbersCheckTaxService", new java.io.ByteArrayInputStream(returnValue.getBytes(UTF_8)));
      return returnParameters;
   }
   
   private void updateValidatedDate(String selection, String projectionName, Connection connection) {
      try {
         CallableStatement callableStatement = connection.prepareCall("{ call Tax_Id_Num_Validation_Util_API.Update_Validated_Date(?, ?) }");
         callableStatement.setString(1, selection);
         callableStatement.setString(2, projectionName);
         callableStatement.execute();
      } catch (SQLException ex) {
         throw new ProjectionException("Error when updating Validated Date. [" + ex.getMessage() + "]", ex);
      }
   }
         
   private String appendCharacter(String value) {
      if (value.equals("")) {
         return "";
      }
      else {
         return value + ", ";
      }
   }
   
   private String getTaxIdNumberBasicValidation(String taxIdNumber, String countryCode, String taxIdType, Connection connection) {      
      String validity = "";
      try {
         CallableStatement callableStatement = connection.prepareCall("{ ? = call Tax_Id_Num_Validation_Util_API.Validate_Tax_Id_Number(?, ?, ?) }");
         callableStatement.setString(2, taxIdNumber);
         callableStatement.setString(3, countryCode);
         callableStatement.setString(4, taxIdType);
         callableStatement.registerOutParameter(1, java.sql.Types.VARCHAR);
         callableStatement.execute();
         validity = callableStatement.getString(1);
      } catch (SQLException ex) {
         throw new ProjectionException("Error when validating Tax ID Number. [" + ex.getMessage() + "]", ex);
      }
      return validity; 
   }
   
   public String validateTaxIdNo(String taxIdNumber) {
      String validity;
      
      String countryCode = taxIdNumber.substring(0, 2);
      String taxIdNo = taxIdNumber.substring(2, taxIdNumber.length());
      
      try {
         SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
         SOAPConnection soapConnection = soapConnectionFactory.createConnection();

         String url = "http://ec.europa.eu/taxation_customs/vies/services/checkVatService";
         SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(countryCode, taxIdNo), url);

         validity = processSOAPResponse(soapResponse);

         soapConnection.close();
      } catch (Exception e) {
         return "NETWORK_ERROR";
      }
      
      return validity;
   }
   
   private SOAPMessage createSOAPRequest(String countryCode, String taxId) throws Exception {
      MessageFactory messageFactory = MessageFactory.newInstance();
      SOAPMessage soapMessage = messageFactory.createMessage();
      SOAPPart soapPart = soapMessage.getSOAPPart();

      String serverURI = "http://ec.europa.eu/";

      SOAPEnvelope envelope = soapPart.getEnvelope();
      envelope.addNamespaceDeclaration("tns1", "urn:ec.europa.eu:taxud:vies:services:checkVat:types");
      envelope.addNamespaceDeclaration("impl", "urn:ec.europa.eu:taxud:vies:services:checkVat");

      SOAPBody soapBody = envelope.getBody();
      QName bodyQName = new QName("urn:ec.europa.eu:taxud:vies:services:checkVat:types", "checkVat", "tns1");
      SOAPElement soapBodyElem = soapBody.addChildElement(bodyQName);

      SOAPElement soapBodyElem1 = soapBodyElem.addChildElement(new QName("urn:ec.europa.eu:taxud:vies:services:checkVat:types", "countryCode", "tns1"));
      soapBodyElem1.addTextNode(countryCode);
      SOAPElement soapBodyElem2 = soapBodyElem.addChildElement(new QName("urn:ec.europa.eu:taxud:vies:services:checkVat:types", "vatNumber", "tns1"));
      soapBodyElem2.addTextNode(taxId);

      soapMessage.saveChanges();
      
      return soapMessage;
   }

   private String processSOAPResponse(SOAPMessage soapResponse) throws Exception {
      TransformerFactory transformerFactory = TransformerFactory.newInstance();
      Transformer transformer = transformerFactory.newTransformer();
      Source source = soapResponse.getSOAPPart().getContent();
      StringWriter stringWriter = new StringWriter();
      StreamResult streamResult = new StreamResult(stringWriter);
      transformer.transform(source, streamResult);
      
      return getValidity(stringWriter.toString());
   }
   
   private String getValidity(String xml) throws ParserConfigurationException, IOException, SAXException {
      String validity;
      
      DocumentBuilder documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
      InputSource inputSource = new InputSource();
      inputSource.setCharacterStream(new StringReader(xml));
      Document document = documentBuilder.parse(inputSource);
      validity = document.getElementsByTagName("valid").item(0).getTextContent();
      if (validity.equals("true")) {
         validity = "VALID";
      }
      else if (validity.equals("false")) {
         validity = "INVALID";
      }
      return validity;
   }
   
   private String getParameter(Map<String, Object> parameters, String parameterName) {
      String parameterValue = "";
      for (String key : parameters.keySet()) {
         if (parameterName.equals(key)) {
            parameterValue = parameters.get(key).toString();
         }
      }
      return parameterValue;
   }
}