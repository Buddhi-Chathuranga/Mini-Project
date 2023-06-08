package ifs.cloud.fetch.jfrog;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.io.File;
import java.io.IOException;

import org.junit.BeforeClass;
import org.junit.Test;

import ifs.cloud.fetch.FetchException;
import ifs.cloud.fetch.FileInfo;
import ifs.cloud.fetch.IBytesReceiver;
import ifs.cloud.fetch.jfrog.MockJFrogServer.MockFileInfo;

public class TestJFrogClient {

   // a mocked JFrog http server
   private static MockJFrogServer server = new MockJFrogServer();

   @BeforeClass
   public static void setup() {
      server.start();
      try {
         // let the server start
         Thread.sleep(1000);
      }
      catch (InterruptedException e) {
         fail(e.toString());
      }
   }
   
   private JFrogClient createClient() {
      JFrogClient client = new JFrogClient();
      client.setHost(MockJFrogServer.HOST);
      client.setProtocol(MockJFrogServer.PROTOCOL);
      client.setPort(MockJFrogServer.LISTEN_PORT);
      client.setRepoName(MockJFrogServer.REPO);
      return client;
   }

   /**
    * test for file meta detail parser functionality
    */
   @Test
   public void testGetFileInfo() {
      try (JFrogClient client = createClient()) {
         FileInfo fi = client.getFileInfo("file");
         assertNotNull(fi);
         assertEquals(MockJFrogServer.PATH, fi.getPath());
         assertEquals(MockJFrogServer.FILE_SIZE, fi.getSize());
         assertEquals(MockJFrogServer.MIME_TYPE, fi.getType());
      }
      catch (FetchException e) {
         fail(e.toString());
      }
      catch (IOException e) {
         fail(e.toString());
      }
   }

   @Test
   public void testDownloadFile() {
      try (JFrogClient client = createClient()) {
         /* downloaded file contents are collected in string builder */
         StringBuilder sb = new StringBuilder();
         client.downloadFile(new MockFileInfo(), new IBytesReceiver() {
            @Override
            public void accept(byte[] bs) {
               sb.append(new String(bs));
            }
         });
         assertEquals(MockJFrogServer.FILE_CONTENT, sb.toString());
      }
      catch (FetchException | IOException e) {
         fail(e.toString());
      }
   }
   
   /**
    * test if httpExeption 404 is raised if a wrong file is requested
    */
   @Test
   public void testDownloadBadFile() {
      try (JFrogClient client = createClient()) {
         StringBuilder sb = new StringBuilder();
         client.downloadFile(new MockFileInfo(MockJFrogServer.BAD_PATH), new IBytesReceiver() {
            @Override
            public void accept(byte[] bs) {
               sb.append(new String(bs));
            }
         });
         fail("Should throw 404 exception");
      }
      catch (HttpException e) {
         assertEquals(e.getCode(), 404);
      }
      catch (FetchException | IOException e) {
         fail(e.toString());
      }
   }
   
   /**
    * test for file meta cache functionality
    */
   @Test
   public void testFileChanged() {
      try (JFrogClient client = createClient()) {
         String tmp = System.getProperty("java.io.tmpdir");
         client.setCachePath(new File(tmp));
         client.downloadFile(new MockFileInfo(), new IBytesReceiver() {
            @Override
            public void accept(byte[] bs) {
            }
         });
         FileInfo fi = client.getFileInfo("file");
         assertEquals(false, client.isFileChanged(fi));
      }
      catch (FetchException | IOException e) {
         fail(e.toString());
      }
   }
}
