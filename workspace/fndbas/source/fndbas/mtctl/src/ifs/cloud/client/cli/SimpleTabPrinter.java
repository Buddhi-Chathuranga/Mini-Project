package ifs.cloud.client.cli;

import java.util.ArrayList;

public abstract class SimpleTabPrinter {
   private final int levels;
   private final int columnSpacing;
   private final ArrayList<TextRow> rows = new ArrayList<>();

   public SimpleTabPrinter(int levels) {
      this(levels, 2);
   }

   public SimpleTabPrinter(int levels, int columnSpacing) {
      this.levels = levels;
      this.columnSpacing = columnSpacing;
   }

   public TextRow createRow(int level) {
      TextRow row = new TextRow(level);
      rows.add(row);
      return row;
   }
   
   public void removeRow(TextRow row) {
      rows.remove(row);
   }

   private String fill(String str, int max) {
      if (max > 0) {
         StringBuilder sb = new StringBuilder(str);
         while (sb.length() < max)
            sb.append(' ');
         return sb.toString();
      }
      return str;
   }

   public void print() {
      Widths[] widths = new Widths[levels];
      for (int i = 0; i < levels; i++) {
         widths[i] = calculateWidths(rows, i);
      }
      for (int i = 0; i < rows.size(); i++) {
         TextRow row = rows.get(i);
         int indent = row.calculateIndent(widths);
         printRow(row, indent, widths[row.level].widths);
      }
   }

   private void printRow(TextRow row, int indent, int[] widths) {
      ArrayList<String> columns = row.getColumns();
      if (columns.size() == 0) {
         /* empty line */
         printLn();
         return;
      }
      if (widths.length == 1) {
         /* single column */
         printLn(fill(columns.get(0), indent));
      }
      else {
         StringBuilder sb = new StringBuilder(fill("", indent));
         for (int j = 0; j < columns.size(); j++) {
            String col = columns.get(j);
            sb.append(fill(col, widths[j]));
         }
         printLn(sb.toString());
      }
   }
   
   public abstract void printLn();
   
   public abstract void printLn(String text);
   
   private Widths calculateWidths(ArrayList<TextRow> rows, int level) {
      int colCount = 0;
      for (int i = 0; i < rows.size(); i++) {
         TextRow row = rows.get(i);
         if (row.level == level) {
            ArrayList<String> columns = row.getColumns();
            if (colCount < columns.size()) {
               colCount = columns.size();
            }
         }
      }
      int[] widths = new int[colCount];
      for (int i = 0; i < colCount; i++) {
         widths[i] = 0;
      }
      for (int i = 0; i < rows.size(); i++) {
         TextRow row = rows.get(i);
         if (row.level == level) {
            ArrayList<String> columns = row.getColumns();
            for (int j = 0; j < columns.size(); j++) {
               String col = columns.get(j);
               int len = col.length() + columnSpacing;
               if (widths[j] < len) {
                  widths[j] = len;
               }
            }
         }
      }
      return new Widths(widths);
   }

   private class Widths {
      private final int[] widths;

      Widths(int[] widths) {
         this.widths = widths;
      }
   }

   public class TextRow {
      private final ArrayList<String> columns = new ArrayList<>();
      private final int level;
      private int indent = 0;
      private int leftAlignRow = -1;
      private int leftAlignColumn = -1;

      TextRow(int level) {
         this.level = level;
      }

      int calculateIndent(Widths[] widths) {
         if (leftAlignRow != -1) {
            int[] w = widths[leftAlignRow].widths;
            int indent = this.indent;
            for (int i = 0; i < leftAlignColumn; i++) {
               indent += w[i];
            }
            return indent;
         }
         return this.indent;
      }

      public void add(String... strings) {
         for (int i = 0; i < strings.length; i++) {
            columns.add(strings[i]);
         }
      }

      /* Convenient method to add one column with multiple strings */
      public void addColumn(Object... args) {
         if (args.length > 1) {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < args.length; i++) {
               if (sb.length() > 0)
                  sb.append(' ');
               sb.append(args[i]);
            }
            columns.add(sb.toString());
         }
         else {
            columns.add(args[0].toString());
         }
      }

      ArrayList<String> getColumns() {
         return columns;
      }

      public void setIndent(int indent) {
         this.indent = indent;
      }

      public void leftAlignWith(int rowIndex, int columnIndex) {
         this.leftAlignRow = rowIndex;
         this.leftAlignColumn = columnIndex;
      }
   }
}
