package ifs.cloud.fetch.manifest;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class ArtifactManifest {

   private final File xml;
   private String component;
   private String packageId;
   ArrayList<Artifact> artifacts = new ArrayList<>();

   public ArtifactManifest(File xml) throws ManifestException {
      this.xml = xml;
      load();
   }

   private void load() throws ManifestException {
      if (xml.exists() && xml.length() > 0) {
         try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            // errors will be thrown and handled later
            builder.setErrorHandler(new ErrorHandler() {
               @Override
               public void warning(SAXParseException exception) throws SAXException {}

               @Override
               public void error(SAXParseException exception) throws SAXException {}

               @Override
               public void fatalError(SAXParseException exception) throws SAXException {}
            });
            Document doc = builder.parse(xml);
            doc.getDocumentElement().normalize();
            Node component = getElement(doc.getChildNodes(), "component");
            this.component = getElementText(getElement(component, "name"));
            this.packageId = getElementText(getElement(component, "package", true), true);
            
            Node artifacts = getElement(component, "artifacts");

            ArrayList<Node> artifactArray = getChildElements(artifacts, "artifact");
            for (Node artifact : artifactArray) {
               Artifact temp = new Artifact();
               temp.artifactName = getElementText(getElement(artifact, "filename", true), true);
               boolean idOpt = temp.artifactName != null;
               temp.id = getElementText(getElement(artifact, "id", idOpt), idOpt);
               temp.description = getElementText(getElement(artifact, "description"));
               temp.version = getElementText(getElement(artifact, "version", idOpt), idOpt);
               temp.extractPath = getElementText(getElement(artifact, "extractpath"));
               temp.explode = Boolean.valueOf(getElementText(getElement(artifact, "explode")));

               this.artifacts.add(temp);
            }
         }
         catch (ParserConfigurationException | SAXException | IOException ex) {
            throw new ManifestException(this, ex);
         }
      }
   }

   private Node getElement(NodeList childNodes, String tag) {
      for (int n = 0; n < childNodes.getLength(); n++) {
         Node temp = childNodes.item(n);
         if (tag.equals(temp.getNodeName())) {
            return temp;
         }
      }
      return null;
   }

   private String getElementText(Node node) throws ManifestException {
      return getElementText(node, false);
   }

   private String getElementText(Node node, boolean optional) throws ManifestException {
      String text = node == null ? null : node.getTextContent();
      if (!optional && (text == null || text.length() == 0))
         throw new ManifestException(this, node.getNodeName());
      return text;
   }

   private Node getElement(Node node, String tag) throws ManifestException {
      return getElement(node, tag, false);
   }

   private Node getElement(Node node, String tag, boolean optional) throws ManifestException {
      if (tag.equals(node.getNodeName())) {
         return node;
      }
      NodeList elements = node.getChildNodes();
      for (int n = 0; n < elements.getLength(); n++) {
         Node temp = elements.item(n);
         if (tag.equals(temp.getNodeName())) {
            return temp;
         }
      }
      if (!optional)
         throw new ManifestException(this, tag);
      return null;
   }

   private ArrayList<Node> getChildElements(Node node, String tag) throws ManifestException {
      ArrayList<Node> nodes = new ArrayList<>();

      NodeList elements = node.getChildNodes();
      for (int n = 0; n < elements.getLength(); n++) {
         Node temp = elements.item(n);
         if (tag.equals(temp.getNodeName())) {
            nodes.add(temp);
         }
      }
      return nodes;
   }

   public String getComponent() {
      return component;
   }

   public String getManifestName() {
      return xml.getName();
   }

   public ArrayList<Artifact> getArtifacts() {
      return artifacts;
   }

   public class Artifact {
      private String id;
      private String description;
      private String extractPath;
      private boolean explode;
      private String version;
      private String artifactName;

      public String getId() {
         return id;
      }

      public String getDescription() {
         return description;
      }

      public String getExtractpath() {
         return extractPath;
      }

      public boolean getExplode() {
         return explode;
      }

      public String getVersion() {
         return version;
      }
      
      public String getArtifactTargetName() {
         if (artifactName != null)
            return artifactName;
         StringBuilder sb = new StringBuilder().append(id).append(".zip");
         return sb.toString();
      }

      public String getArtifactName() {
         if (artifactName != null)
            return artifactName;

         StringBuilder sb = new StringBuilder().append(id).append('-').append(version).append(".zip");
         return sb.toString();
      }

      public String getPathInArtifactory() {
         StringBuilder sb = new StringBuilder();
         sb.append(component).append('/');
         sb.append(packageId != null ? packageId : id).append('/'); 
         sb.append(getArtifactName());
         return sb.toString();
      }

      public String getLocalPath() {
         StringBuilder sb = new StringBuilder().append('/').append(extractPath).append('/').append(getArtifactName());
         return sb.toString();
      }
   }
}
