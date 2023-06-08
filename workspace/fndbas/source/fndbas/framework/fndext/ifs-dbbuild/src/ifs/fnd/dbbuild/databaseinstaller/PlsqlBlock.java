/*=====================================================================================
 * PlsqlBlock.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.ArrayList;
import java.util.List;

/**
 * A block of PL/SQL code.
 */
public class PlsqlBlock {

   private int startOffset;
   private int endOffset;
   private int previousStart = -1;
   private int previousEnd = -1;
   private PlsqlBlockType type;
   private String name;
   private String alias;
   private String prefix = "";
   private PlsqlBlock parent;
   private List<PlsqlBlock> children = new ArrayList<>();

   public PlsqlBlock(int start, int end, String name, String alias, PlsqlBlockType type) {
      this.startOffset = start;
      this.endOffset = end;
      this.name = name;
      this.type = type;
      this.alias = alias;
   }

   public PlsqlBlock getParent() {
      return parent;
   }

   /**
    * Method used to clange Plsql Block name
    * @param name
    */
   public void setName(String name) {
      this.name = name;
   }

   /**
    * Method that will return the alias of the Plsql block
    * @return
    */
   public String getAlias() {
      return this.alias;
   }

   /**
    * Return start offset of the block
    * @return
    */
   public int getStartOffset() {
      return startOffset;
   }

   /**
    * Return block type
    * @return
    */
   public PlsqlBlockType getType() {
      return type;
   }

   /**
    * Return block name
    * @return
    */
   public String getName() {
      return name;
   }

   /**
    * Return end offset of the block
    * @return int
    */
   public int getEndOffset() {
      return endOffset;
   }

   /**
    * set start offset of the block
    * @param start
    */
   public void setStartOffset(int start) {
      startOffset = start;
   }

   /**
    * set end offset of the block
    * @param end
    */
   public void setEndOffset(int end) {
      endOffset = end;
   }

   /**
    * Add child block to this block
    * @param child PlsqlBlock
    */
   public void addChild(PlsqlBlock child) {
      children.add(child);
      child.parent = this;
   }

   /**
    * Get child blocks
    * @return
    */
   public List<PlsqlBlock> getChildBlocks() {
      return children;
   }

   /**
    * Get child count
    * @return
    */
   public int getChildCount() {
      return children.size();
   }

   /**
    * Return previous start offset of this block
    * If not set will return -1
    * @return
    */
   public int getPreviousStart() {
      return previousStart;
   }

   /**
    * Method that will set previous start
    * @param preStart
    */
   public void setPreviousStart(int preStart) {
      this.previousStart = preStart;
   }

   /**
    * Return previous end offset of this block
    * If not set will return -1
    * @return
    */
   public int getPreviousEnd() {
      return previousEnd;
   }

   /**
    * Method that will set previous end
    * @param preEnd
    */
   public void setPreviousEnd(int preEnd) {
      this.previousEnd = preEnd;
   }

   /**
    * Method that will set the prefix of the block if any
    * @param prefix
    */
   public void setPrefix(String prefix) {
      this.prefix = prefix;
   }

   public void setParent(PlsqlBlock parent) {
      this.parent = parent;
   }

   /**
    * Method that will return the prefix of the block
    * @return
    */
   public String getPrefix() {
      return this.prefix;
   }

   @Override
   public String toString() {
      return toString(false);
   }

   public String toString(boolean recursive) {
      return toString(recursive, 0);
   }

   private String toString(boolean recursive, int level) {
      StringBuilder builder = new StringBuilder();
      builder.append(String.format("[%1$5d - %2$5d] ", startOffset, endOffset));
      for (int i = 0; i < level * 2; i++) {
           builder.append(" ");
       }
      builder.append(type).append(": \"").append(name).append("\"\n");
      if (recursive) {
           for (PlsqlBlock child : children) {
              builder.append(child.toString(true, level + 1));
          }
       }
      return builder.toString();
   }
}