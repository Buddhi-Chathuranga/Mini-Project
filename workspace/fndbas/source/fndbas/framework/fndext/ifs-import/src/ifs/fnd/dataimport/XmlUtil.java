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
 * File        : XmlUtil.java
 * Description :
 * Notes       :
 * ----------------------------------------------------------------------------
 * Modified
 *   HEDJSE 2004-Nov-29 - Created.
 * ----------------------------------------------------------------------------
 *
 * Revision 1.4  2005/10/27 09:09:56  munalk
 * Task to import reports
 *
 * Revision 1.3  2005/07/01 07:35:24  hedjse
 * Added Ant task for configuring JBoss data sources.
 *
 * Revision 1.2  2005/05/31 07:03:49  hedjse
 * Added Ant task for editing any XML document.
 *
 * Revision 1.1  2005/04/20 19:03:23  marese
 * Merged fndext with fndbas
 *
 * Revision 1.1  2005/01/28 17:36:51  marese
 * Initial checkin
 *
 * Revision 1.2  2005/01/17 14:55:38  hedjse
 * Added setNodeText(Node,String) method
 *
 * Revision 1.1  2004/11/29 19:15:13  hedjse
 * Added Ant task for exploding .ear-files.
 *
 */
package ifs.fnd.dataimport;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.FactoryConfigurationError;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMConfiguration;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.bootstrap.DOMImplementationRegistry;
import org.w3c.dom.ls.DOMImplementationLS;
import org.w3c.dom.ls.LSOutput;
import org.w3c.dom.ls.LSSerializer;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * Utility methods for XML processing.
 */
public final class XmlUtil {

    /**
     * Private constructor to disable instantiation.
     */
    private XmlUtil() {
    }
    private static final String FORMAT_PRETTY_PRINT = "format-pretty-print";

    /**
     * Utility method for creating an
     * <code>Element</code> with a simple text value.
     *
     * @param doc the <code>Document</code> object that will own the created
     * element.
     * @param elementName the name of the element to create.
     * @param textValue the text value for the element to create. May be
     * <code>null</code>.
     * @return The newly created element. The element needs to be appended to
     * a <code>Node</code> as a child element.
     */
    public static Element createTextElement(Document doc, String elementName, String textValue) {
        Element e = doc.createElement(elementName);
        if (textValue != null) {
            e.appendChild(doc.createTextNode(textValue));
        }
        return e;
    }

    /**
     * Utility method for getting the value of a node's attribute.
     *
     * @param node the node to get the attribute value for.
     * @param attributeName the name of the attribute to get the value for.
     * @return a <code>String</code> with the attribute's value, or
     * <code>null</code> if there is no attribute with the given name.
     */
    public static String getNodeAttributeValue(Node node, String attributeName) {
        NamedNodeMap attrs = node.getAttributes();
        if (attrs != null) {
            Node attr = attrs.getNamedItem(attributeName);
            if (attr != null) {
                return attr.getNodeValue();
            }
        }

        return null;
    }

    /**
     * Utility method to get the text value for a Node.
     *
     * @param node the <code>Node</code> to get the value for.
     * @return a <code>String</code> with the text, or <code>null</code> if
     * there is no text value for the node.
     */
    public static String getNodeText(Node node) {
        NodeList l = node.getChildNodes();
        if (l.getLength() > 0) {
            return l.item(0).getNodeValue();
        }
        return null;
    }

    /**
     * Utility method to get the text value for a sub-node to the given node.
     *
     * @param node the node to search for sub-nodes in.
     * @param subNodeName the name of the sub-node to get the text for.
     */
    public static String getNodeText(Node node, String subNodeName) {
        NodeList nodeList = node.getChildNodes();
        for (int i = 0; i < nodeList.getLength(); i++) {
            Node subNode = nodeList.item(i);
            if (subNodeName.equals(subNode.getNodeName())) {
                return getNodeText(subNode);
            }
        }
        return null;
    }

    /**
     * Parses an XML Document from an InputStream. This method does not close
     * the input stream.
     *
     * @param in an <code>InputStream</code> for the XML document to parse.
     * @return a <code>Document</code> for the XML document.
     * @throws ParserConfigurationException if there is a problem parsing the
     * XML document.
     * @throws SAXException if there is a problem parsing the XML document.
     * @throws IOException if there is a problem parsing the XML document.
     */
    public static Document parseXml(InputStream in) throws ParserConfigurationException, SAXException, IOException {
        // Parse input stream.
        DocumentBuilderFactory bFactory = DocumentBuilderFactory.newInstance();
        bFactory.setIgnoringElementContentWhitespace(true);
        DocumentBuilder builder = bFactory.newDocumentBuilder();
        builder.setEntityResolver(new EntityResolver() {

            @Override
            public InputSource resolveEntity(String publicId, String systemId) throws SAXException, IOException {
                if (systemId.endsWith(".dtd")) {
                    return new InputSource(new ByteArrayInputStream(new byte[0]));
                }
                return null;
            }
        });
        return builder.parse(in);
    }

    /**
     * Serializes a
     * <code>Document</code> to a
     * <code>File</code>.
     *
     * @param document the <code>Document</code> to serialize.
     * @param file the <code>File</code> to write to.
     * @throws IOException if there is an I/O error writing to the
     * <code>File</code>.
     */
    public static void serializeXml(Document document, File file) throws IOException {
        OutputStream out = new FileOutputStream(file);
        serializeXml(document, out);
        out.close();
    }

    /**
     * Serializes a
     * <code>Document</code> to an
     * <code>OutputStream</code>.
     *
     * @param document the <code>Document</code> to serialize.
     * @param out the <code>OutputStream</code> to write to. The output stream
     * is flushed but not closed by this method.
     * @throws IOException if there is an I/O error writing to the
     * <code>OutputStream</code>.
     */
    public static void serializeXml(Document document, OutputStream out) throws IOException {
        /*OutputFormat format = new OutputFormat(document);
        format.setLineSeparator(LineSeparator.Windows);
        format.setIndenting(true);
        format.setLineWidth(0);
        format.setPreserveSpace(false);
        OutputStreamWriter ow = new OutputStreamWriter(out);
        XMLSerializer serializer = new XMLSerializer(ow, format);
        serializer.asDOMSerializer();
        serializer.serialize(document);
        ow.flush();*/

        OutputStreamWriter ow = new OutputStreamWriter(out);

        try {
            DOMImplementation implementation = DOMImplementationRegistry.newInstance().getDOMImplementation("XML 3.0");
            if (implementation == null) {
                throw new IOException("No DOM implementation found implementing XML 3.0");
            }
            DOMImplementationLS feature = (DOMImplementationLS) implementation.getFeature("LS", "3.0");
            LSSerializer serializer = feature.createLSSerializer();
            DOMConfiguration domConfig = serializer.getDomConfig();
            if (domConfig.canSetParameter(FORMAT_PRETTY_PRINT, Boolean.TRUE)) {
                domConfig.setParameter(FORMAT_PRETTY_PRINT, Boolean.TRUE);
            }
            LSOutput output = feature.createLSOutput();
            output.setEncoding("UTF-8");
            output.setCharacterStream(ow);
            serializer.write(document, output);

        } catch (ClassNotFoundException ex) {
            throw new IOException(ex);
        } catch (InstantiationException ex) {
            throw new IOException(ex);
        } catch (IllegalAccessException ex) {
            throw new IOException(ex);
        } catch (ClassCastException ex) {
            throw new IOException(ex);
        }
    }

    /**
     * Serializes a
     * <code>Element</code> to an
     * <code>OutputStream</code>.
     *
     * @param element the <code>Element</code> to serialize.
     * @param out the <code>OutputStream</code> to write to. The output stream
     * is flushed but not closed by this method.
     * @throws IOException if there is an I/O error writing to the
     * <code>OutputStream</code>.
     */
    public static void serializeXml(Element element, OutputStream out) throws IOException {
        try {
            DOMImplementation implementation = DOMImplementationRegistry.newInstance().getDOMImplementation("XML 3.0");
            if (implementation == null) {
                throw new IOException("No DOM implementation found implementing XML 3.0");
            }
            DOMImplementationLS feature = (DOMImplementationLS) implementation.getFeature("LS", "3.0");
            LSSerializer serializer = feature.createLSSerializer();
            LSOutput output = feature.createLSOutput();
            output.setEncoding("UTF-8");
            output.setCharacterStream(new OutputStreamWriter(out));
            serializer.write(element, output);

        } catch (ClassNotFoundException ex) {
            throw new IOException(ex);
        } catch (InstantiationException ex) {
            throw new IOException(ex);
        } catch (IllegalAccessException ex) {
            throw new IOException(ex);
        } catch (ClassCastException ex) {
            throw new IOException(ex);
        }
    }

    /**
     * Utility method for setting the text value for a node.
     *
     * @param node the node to set the text value for.
     * @param value the node's new value to set.
     */
    public static void setNodeText(Node node, String value) {
        NodeList l = node.getChildNodes();
        if (l.getLength() > 0) {
            l.item(0).setNodeValue(value);
        }
    }

    /**
     * Utility method for setting the text value for a sub-node to the given
     * node.
     *
     * @param node the node to search for sub-nodes in.
     * @param subNodeName the name of the sub-node to get the text for.
     * @param value the node's new value to set.
     */
    public static void setNodeText(Node node, String subNodeName, String value) {
        NodeList nodeList = node.getChildNodes();
        for (int i = 0; i < nodeList.getLength(); i++) {
            Node subNode = nodeList.item(i);
            if (subNodeName.equals(subNode.getNodeName())) {
                setNodeText(subNode, value);
                return;
            }
        }
    }

    /**
     * Parses an XML file into a Document.
     */
    public static Document parse(File xmlFile) throws Exception {
        Document document = null;
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            builder.setEntityResolver(new EntityResolver() {

                @Override
                public InputSource resolveEntity(String publicId, String systemId) {
                    if (systemId.endsWith(".dtd")) {
                        return new InputSource(new ByteArrayInputStream(new byte[0]));
                    } else {
                        return null;
                    }
                }
            });
            document = builder.parse(xmlFile);
        } catch (FactoryConfigurationError e) {
            throw new Exception(e.getMessage(), e);
        } catch (ParserConfigurationException e) {
            throw new Exception(e.getMessage(), e);
        } catch (SAXException e) {
            throw new Exception(e.getMessage(), e);
        } catch (IOException e) {
            throw new Exception(e.getMessage(), e);
        }
        return document;
    }
}
