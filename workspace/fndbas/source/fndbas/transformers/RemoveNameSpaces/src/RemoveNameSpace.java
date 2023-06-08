/*
 *                 IFS Research & Development
 *
 *  This program is protected by copyright law and by international
 *  conventions. All licensing, renting, lending or copying (including
 *  for private use), and all other use of the program, which is not
 *  expressively permitted by IFS Research & Development (IFS), is a
 *  violation of the rights of IFS. Such violations will be reported to the
 *  appropriate authorities.
 *
 *  VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 *  TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 * ----------------------------------------------------------------------------
 * File        : RemoveNameSpace.java
 * Description :
 * Notes       :
 * ----------------------------------------------------------------------------
 * Modified    :
 *    den 9 mars 2006   jahese       Created
 *    2009-10-21        UDLELK       Bug 86424 : Rewritten to handle any number of XsiNill
 * ----------------------------------------------------------------------------
 *
 */

import ifs.fnd.base.IfsException;
import ifs.fnd.tc.framework.xml.Transformer;

public class RemoveNameSpace implements Transformer
{
    
    public void init() throws IfsException {}
    
    public String transform(String sIn) throws IfsException 
    {
        String str = removeNamespace(sIn, ifsNamespace);
        str = removeNamespace(str, fndasNamespace);
        str = removeNamespace(str, xsiNamespace);
        str = removeXsiNill(str);
        return str;
    }
    
    private String removeNamespace(String str, String ns) 
    {
       return replace(str,ns);
    }
    
    private String removeXsiNill(String str) 
    {
        String xsiNill = " xsi:nil=\"1";
        return replace(str,xsiNill);
    }

    private String replace(String str, String substr) {
      if (str == null || substr == null)
         return null;
      if (str.length() == 0 || substr.length() == 0)
         return str;

      StringBuffer buf = null;
      int i = 0, j, skip;

      while (true) {         
         j = str.indexOf(substr, i);         
         if (j < 0) {
            if (buf == null)
               return str;
            else {
               buf.append(str.substring(i));
               return buf.toString();
            }
         }
         else {
            skip = str.indexOf("\"", j + substr.length());        
            if (buf == null)               
               buf = new StringBuffer(10 + str.length());
            
            buf.append(str.substring(i, j));                    
            i = skip + 1;                  
         }
      }
   }

    public final String ifsNamespace = " xmlns=\"urn:ifs";
    public final String fndasNamespace = " xmlns:fndas=\"urn:ifs";
    public final String xsiNamespace = " xmlns:xsi=\"http";
}
