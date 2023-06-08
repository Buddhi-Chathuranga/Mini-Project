/*
 * TextFile.java
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
 * Class that represents the name and contents of a text file.
 */
public class TextFile implements Cloneable {

   private Logger log = Installation.log;

   private String name;
   private String text;

   public TextFile(String name, String text) {
      this.name = name;
      this.text = text;
   }

   public String getName() {
      return name;
   }

   public String getText() {
      return text;
   }

   /**
    * Replace all occurrences of a string with another string in the contents of this file.
    * @param oldStr the old string
    * @param newStr the new string
    */
   public void replace(String oldStr, String newStr) {
      text = Str.replace(text, oldStr, newStr);
   }

   public Object clone() {
      return new TextFile(name, text);
   }
}
