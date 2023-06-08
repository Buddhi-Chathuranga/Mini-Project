package ifs.cloud.fetch.jfrog;

import static org.junit.Assert.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

import org.junit.Test;

import ifs.cloud.fetch.manifest.ArtifactManifest;
import ifs.cloud.fetch.manifest.ArtifactManifest.Artifact;
import ifs.cloud.fetch.manifest.ManifestException;

public class TestUpdatedArtifactManifest {

   /* alternate structure for artifact manifest */
   private final String artifact = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n"
         + "<component>\r\n"
         + "   <name>fndbas</name>\r\n"
         + "   <package>ifs-build</package>\r\n"
         + "   <artifacts>\r\n"
         + "      <artifact>\r\n"
         + "         <id>apache-ant</id>\r\n"
         + "         <version>1.8.2</version>\r\n"
         + "         <filename>apache-ant-1.8.2.zip</filename>\r\n"
         + "         <description>Apache Ant</description>\r\n"
         + "         <extractpath>\\tools</extractpath>\r\n"
         + "         <explode>true</explode>\r\n"
         + "      </artifact>\r\n"
         + "   </artifacts>\r\n"
         + "</component>";
   
   @Test
   public void testLoadArtifactManifest() {
      try {
         File artifactFile = File.createTempFile("test", ".xml");
         try (FileOutputStream fos = new FileOutputStream(artifactFile)) {
            fos.write(artifact.getBytes());
         }
         
         ArtifactManifest manifest = new ArtifactManifest(artifactFile);
         assertEquals("fndbas", manifest.getComponent());
         ArrayList<Artifact> artifacts = manifest.getArtifacts();
         assertNotNull(artifacts);
         assertEquals(1, artifacts.size());
         Artifact artifact = artifacts.get(0);
         assertEquals("apache-ant-1.8.2.zip", artifact.getArtifactName());
         assertEquals("fndbas/ifs-build/apache-ant-1.8.2.zip", artifact.getPathInArtifactory());
      }
      catch (IOException | ManifestException e) {
         fail(e.toString());
      }
   }

}
