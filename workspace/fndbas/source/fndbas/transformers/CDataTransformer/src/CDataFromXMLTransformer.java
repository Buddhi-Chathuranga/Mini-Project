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
import ifs.fnd.connect.readers.ConnectReader;
import ifs.fnd.connect.xml.Transformer;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.xml.sax.InputSource;
import java.io.StringReader;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import java.io.IOException;
import org.w3c.dom.CharacterData;

/**
 * Example String Transformer.
 *
 * IMPORTANT !!!
 * Do not place this class inside a package. It should be
 * in the default package.
 *
 * This example class implement the ifs.fnd.connect.xml.Transformer interface
 * that defines two methods: init() and transform(). This interface is for
 * transformation of Strings.
 *
 * The example shows how to create a transformer packed to a jar file.
 * The final jar file is created to the subdirectory 'dist' and from there
 * can be loaded in Setup IFS Connect feature in Solution Manager.
 * When creating a jar file it is important to add an attribute with name
 * 'Transformer-class' to the MANIFEST.MF file. This attribute has to
 * define the main Transformer class (this class). The final jar file
 * can also contain some other classes used for the transformation.
 * See build.xml for building details.
 *
 * @author UDLELK
 */
public class CDataFromXMLTransformer implements Transformer {

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
      String cData = "";
      InputSource is = new InputSource();
      is.setCharacterStream(new StringReader(str));
      try{
         DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
         Document doc = db.parse(is);
         NodeList nodes = doc.getElementsByTagName("*");
         for (int i = 0; i < nodes.getLength(); i++) {
            Element node = (Element) nodes.item(i);
            cData = getCharacterDataFromElement(node);
         }
      }      
     catch (ParserConfigurationException e){
        throw new ConnectReader.PermanentFailureException("Error when getting CData from XML: &1", e.toString());  
      }
      catch(SAXException e){
         throw new ConnectReader.PermanentFailureException("Error when getting CData from XML: &1", e.toString()); 
      }
      catch(IOException e){
         throw new ConnectReader.PermanentFailureException("Error when getting CData from XML: &1", e.toString());
      }
      return cData;
   }

   private static String getCharacterDataFromElement(Element e) {
     NodeList childList = e.getChildNodes();
     String cData = "";
     for(int j=0; j<childList.getLength(); j++){
        Node child = childList.item(j);
        if (child instanceof CharacterData) {
           CharacterData cd = (CharacterData) child;
           if(cd.getNodeName().equalsIgnoreCase("#cdata-section"))
              return cd.getData();
        }  
     }
     return cData;
   }      
}
