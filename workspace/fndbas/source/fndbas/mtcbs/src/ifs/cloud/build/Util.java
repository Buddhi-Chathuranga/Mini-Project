package ifs.cloud.build;

import java.io.File;

public class Util {

   static File createFilePath(File parent, String... paths) {
      File f = parent;
      for (String path : paths) {
         f = new File(f, path);
      }
      return f;
   }
   
   static String titleCase(String txt) {
      return Character.toUpperCase(txt.charAt(0)) + txt.substring(1).toLowerCase();
   }
}
