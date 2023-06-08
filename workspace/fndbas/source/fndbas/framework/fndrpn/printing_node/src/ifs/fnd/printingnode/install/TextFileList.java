/*
 * TextFileList.java
 *
 * Modified:
 *    madrse  2008-Mar-03 - Created
 */

package ifs.fnd.printingnode.install;

import ifs.fnd.log.*;
import ifs.fnd.base.*;
import ifs.fnd.service.*;
import ifs.fnd.util.*;

import java.io.*;
import java.util.*;

/**
 * Class that represens a list of text files in one directory.
 */
public class TextFileList implements Cloneable {

   private Logger log = Installation.log;

   private ArrayList list; // ArrayList<TextFile>

   /**
    * Create a new instance of TextFileList by loading all files from the specified directory.
    */
   public TextFileList(File dir) throws FndException {
      load(dir);
   }

   private TextFileList() {
   }

   /**
    * Create a clone of this list.
    */
   public Object clone() {
      TextFileList x = new TextFileList();
      if(list != null) {
         int size = list.size();
         x.list = new ArrayList(size);
         for(int i = 0; i < size; i++) {
            TextFile file = (TextFile) list.get(i);
            x.list.add(file.clone());
   }
      }
      return x;
   }


   /**
    * Load all files from a specified directory into internal state of this file list.
    */
   public void load(File dir) throws FndException {
      if(log.trace)
         log.trace("Loading files from directory &1", dir.getAbsolutePath());

      list = new ArrayList();
      File[] files = dir.listFiles();
      for(int i = 0; i < files.length; i++) {
         File file = files[i];
         String name = file.getName();
         String text = Util.readAndTrimFile(file.getAbsolutePath());
         if(log.trace)
            log.trace("   &1", name);
         list.add(new TextFile(name, text));
      }
   }

   /**
    * Save all the files in this file list into a specified directory.
    */
   public void save(File dir) throws IOException {
      if(log.trace)
         log.trace("Saving files to directory &1", dir.getAbsolutePath());

      for(int i = 0; i < list.size(); i++) {
         TextFile file = (TextFile) list.get(i);
         String name = file.getName();
         if(log.trace)
            log.trace("   &1", name);
         File dest = new File(dir, name);
         Util.writeFile(dest.getAbsolutePath(), file.getText());
      }
   }

   /**
    * Replace all occurrences of a string with another string in the contents of all files in this list.
    * @param oldStr the old string
    * @param newStr the new string
    */
   public void replace(String oldStr, String newStr) {
      for(int i = 0; i < list.size(); i++) {
         TextFile file = (TextFile) list.get(i);
         file.replace(oldStr, newStr);
      }
   }
}
