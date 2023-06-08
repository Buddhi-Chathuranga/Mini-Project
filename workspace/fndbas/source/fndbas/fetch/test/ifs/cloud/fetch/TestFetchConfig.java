package ifs.cloud.fetch;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import org.junit.Test;

public class TestFetchConfig {

   @Test
   public void testArgs() {
      
      String [] args = {
            "--repo-name", "repo",
            "--host", "artifactory.host",
            "--user", "artifactory.user",
            "--password", "artifactory.pass",
            "--build-home", System.getProperty("java.io.tmpdir"),
            "--hide-progress", "false",
            "--force-download", "false" };
      
      try {
         new FetchConfig(args);
      }
      catch (FetchException e) {
         fail(e.toString());
      }
   }
   
   @Test
   public void testMandatoryArgs() {
      
      try {
         new FetchConfig(new String [] { "--repo-name", "repo" });
      }
      catch (FetchException e) {
         assertEquals(true, e.getMessage().startsWith("Required arguments are missing."));
      }
   }

}
