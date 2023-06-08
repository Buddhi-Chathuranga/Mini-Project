/*
 * XmlConfigFile.java
 *
 * Modified:
 *    madrse  2008-Mar-03 - Created
 *    CHAALK  2017-Jul-06 - Remove jdom and use org.w3c.dom conversion
 */

package ifs.fnd.printingnode.install;

import ifs.fnd.log.*;
import ifs.fnd.base.*;
import ifs.fnd.service.*;
import ifs.fnd.util.*;

import java.io.*;
import java.util.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import org.w3c.dom.Element;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
/**
 * Class that represents Print Agent XML configuration file.
 */
public class XmlConfigFile {

   /**
    * The name of IFS Print Agent XML cnfiguration file.
    */
   public static final String XML_CONFIG_FILENAME = "ifs-printagent-config.xml";


   private Logger log = Installation.log;

   private Document doc;

   private String id;

   private String fileName;

   public String getId() {
      return id;
   }

   public String getFileName() {
      return fileName;
   }

   /**
    * Create a new instance of XmlConfigFile by parsing the XML config file from the specified directory.
    * @param dir the directory containing the configuration file
    */
   public XmlConfigFile(File dir) throws SystemException {
      this.id = dir.getName();
      File file = new File(dir, XML_CONFIG_FILENAME);
      this.fileName = file.getAbsolutePath();;
      try {
         DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
         DocumentBuilder builder = factory.newDocumentBuilder();               
         doc = builder.parse(file);
      }
      catch (Exception e) {
         log.error(e, "Error in parsing configuration file &1: &2", fileName, e.getMessage());
         throw new SystemException(e, "PARSECONFIG: Failed to parse configuration file &1: &2", fileName, e.toString());
      }
   }

   /**
    * Set the value for the specified parameter.
    * @param path a path to the parameter in syntax "A/B/C"
    * @param value the parameter value to set
    */
   public void setParameter(String path, String value) throws SystemException {
      NodeList elementList = doc.getDocumentElement().getElementsByTagName(path);
      for(int i=0;i<elementList.getLength();i++){
         if(elementList.item(i).getNodeType() == Node.ELEMENT_NODE){
            elementList.item(i).setTextContent(value);
         }
      }
   }

   /**
    * Get the value for the specified parameter.
    * @param path a path to the parameter in syntax "A/B/C"
    * @return the parameter value, or null if not found
    */
   public String getParameter(String path) throws SystemException {
      NodeList elementList = doc.getDocumentElement().getElementsByTagName(path);
      for(int i=0;i<elementList.getLength();i++){
         if(elementList.item(i).getNodeType() == Node.ELEMENT_NODE){
            return elementList.item(i).getTextContent().trim();
         }
      }
      return null;
   }

   /**
    * Save the current state of configuration parameters to the specified XML file.
    */
   public void save() throws SystemException {
      try {
         Transformer transformer = TransformerFactory.newInstance().newTransformer();
         Result output = new StreamResult(new File(fileName));
         Source input = new DOMSource(doc);
         transformer.transform(input, output);
      }
      catch (Exception e) {
         log.error("XMLSAVE: Error saving XML configuration file &1: ", fileName, e.getMessage());
      }
   }
}
