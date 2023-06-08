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

public class PayloadTransformer implements Transformer {

   /**
    * Initialization that is performed once when the transformer class is loaded.
    * @throws IfsException
    */
   @Override
   public void init() throws IfsException {
   }

   /**
    * Transform a String to another String.
    * Note that the framework will create a new instance
    * each time transformation occurs.
    * @param str  String to be transformed
    * @return     String after transformation
    * @throws IfsException
    */
   @Override
   public String transform(String str) throws IfsException {
      //String str1 = "200#742#{\"@odata.context\":\"https://cmbpde2185.corpnet.ifsworld.com:4";
      int fistHash = str.indexOf("#");
      String strRest = str.substring(fistHash+1);
      int secondHash = strRest.indexOf("#");
      String contLength = strRest.substring(0, secondHash);
      int len = Integer.valueOf(contLength);
      String contentFull = strRest.substring(secondHash+1);
      byte[] contentArray = contentFull.getBytes();
      byte[] contents = new byte[len];
      
      for (int i=0; i<len; i++){
         contents[i] = contentArray[i];
      }
      String retStr = new String(contents);
      return retStr;
   }
}

