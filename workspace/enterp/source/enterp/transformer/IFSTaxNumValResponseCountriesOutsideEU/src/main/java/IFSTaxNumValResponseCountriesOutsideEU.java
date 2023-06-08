/*
 *                  IFS Research & Development
 *
 * This program is protected by copyright law and by international
 * conventions. All licensing, renting, lending or copying (including
 * for private use), and all other use of the program, which is not
 * expressively permitted by IFS Research & Development (IFS), is a
 * violation of the rights of IFS. Such violations will be reported to the
 * appropriate authorities.
 *
 * VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 * TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 */

import ifs.fnd.base.IfsException;
import ifs.fnd.connect.xml.Transformer;
import org.json.JSONObject;
import org.json.JSONException;

/**
 * IFS Tax Number Validation Response from Countries Outside EU
 *
 * IMPORTANT !!!
 * Do not place this class inside a package. It should be
 * in the default package.
 */
public class IFSTaxNumValResponseCountriesOutsideEU implements Transformer {

   @Override
   public void init() throws IfsException {
   }

   @Override
   public String transform(String sIn) throws IfsException {
      String isValidTaxIdNumber;
      StringBuilder sb = new StringBuilder();
      try {
         isValidTaxIdNumber = fetchResultFromResponse(sIn);
      } catch (JSONException ex) {
         isValidTaxIdNumber = "FALSE";
      }

      sb.append("<TAX_ID_NUMBER_VALIDATION_RESPONSE>\r\n");
      sb.append("<RESPONSE>").append(isValidTaxIdNumber).append("</RESPONSE>\r\n");
      sb.append("</TAX_ID_NUMBER_VALIDATION_RESPONSE>\r\n");
      return sb.toString();
   }

   private String fetchResultFromResponse(String response) throws JSONException {
      String isValidTaxIdNumber;
      try {
         JSONObject responseObj = new JSONObject(response);
         JSONObject targetObj = (JSONObject) responseObj.get("target");
         String vatNumber = (String) targetObj.get("vatNumber");
         if (vatNumber.length() == 0) {
            isValidTaxIdNumber = "FALSE";
         } else {
            isValidTaxIdNumber = "TRUE";
         }
      } catch (JSONException ex) {
         isValidTaxIdNumber = "FALSE";
         return isValidTaxIdNumber;
      }
      return isValidTaxIdNumber;
   }
}
