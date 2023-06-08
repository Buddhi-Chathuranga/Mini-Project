/*
 * PrintAgentUtil.java
 *
 * CHAALK 2017-Jul-06 - Remove jdom and use org.w3c.dom conversion
 */

package ifs.fnd.printingnode.printagentutility;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


public abstract class PrintAgentUtil  {

   public static String getChildElementVlaue(Element element, String elementName)
   {
      if (element != null){
         NodeList elementList = element.getElementsByTagName(elementName);
         for(int i=0;i<elementList.getLength();i++){
            if(elementList.item(i).getNodeType() == Node.ELEMENT_NODE){
               return elementList.item(i).getTextContent().trim();
            }
         }
      }
      return null;
   }
   
   public static Element getChildElement(Document document, String elementName)
   {
      NodeList  nodeList = document.getElementsByTagName(elementName);
      for(int i=0;i<nodeList.getLength();i++){
         if(nodeList.item(i).getNodeType() == Node.ELEMENT_NODE){
            return (Element)nodeList.item(i);
         }
      }
      return null;
   }

   public static Element getChildElement(Element element, String elementName)
   {
      if (element != null){
         NodeList  nodeList = element.getElementsByTagName(elementName);
         for(int i=0;i<nodeList.getLength();i++){
            if(nodeList.item(i).getNodeType() == Node.ELEMENT_NODE){
               return (Element)nodeList.item(i);
            }
         }
      }
      return null;
   }
   
}
