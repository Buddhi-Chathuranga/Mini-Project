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

public class TestArtifactManifest {

   private final String artifact = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n"
         + "<component>\r\n"
         + "  <name>fndbas</name>\r\n"
         + "  <artifacts>\r\n"
         + "     <artifact>\r\n"
         + "      <id>ifsinstaller</id>\r\n"
         + "      <description>binary files for ifsinstaller</description>\r\n"
         + "      <version>1.0.1</version>\r\n"
         + "      <extractpath>\\</extractpath>\r\n"
         + "     <explode>true</explode>\r\n"
         + "    </artifact>   \r\n"
         + "  </artifacts>\r\n"
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
         assertEquals("ifsinstaller-1.0.1.zip", artifact.getArtifactName());
         assertEquals("fndbas/ifsinstaller/ifsinstaller-1.0.1.zip", artifact.getPathInArtifactory());
      }
      catch (IOException | ManifestException e) {
         fail(e.toString());
      }
   }

}
