package ifs.cloud.client;

import static org.junit.Assert.assertEquals;

import org.junit.Ignore;
import org.junit.Test;

import ifs.cloud.client.cli.SimpleTabPrinter;
import ifs.cloud.client.cli.SimpleTabPrinter.TextRow;

public class TestTabPrinter {

   @Test
   public void testTabPrinter() {
      MockTabPrinter mtp = new MockTabPrinter();
      mtp.createRow(0).add("title1", "title2");
      mtp.createRow(0).add("value 11", "value 20");
      mtp.createRow(0).add("value 11", "value 21");
      mtp.print();
      // expected output - columns aligned
      String out = "title1    title2    \r\n"
                 + "value 11  value 20  \r\n"
                 + "value 11  value 21  \r\n";
      assertEquals(out, mtp.toString());
   }
   
   @Test
   public void testTabPrinterAppendColumn() {
      MockTabPrinter mtp = new MockTabPrinter();
      TextRow row = mtp.createRow(0);
      row.add("title1", "title2");
      row.addColumn("new", "title");
      mtp.createRow(0).add("value 10", "value 20", "value 30");
      mtp.createRow(0).add("value 11", "value 21", "value 31");
      mtp.print();
      // expected output - columns aligned
      String out = "title1    title2    new title  \r\n"
                 + "value 10  value 20  value 30   \r\n"
                 + "value 11  value 21  value 31   \r\n";
      assertEquals(out, mtp.toString());
   }
   
   @Test
   public void testTabPrinterMultiLevel() {
      MockTabPrinter mtp = new MockTabPrinter();
      TextRow row = mtp.createRow(0);
      row.add("title1", "title2");
      row.addColumn("new", "title");
      mtp.createRow(0).add("value 10", "value 20", "value 30");
      // 2nd and 4th rows should align separately
      mtp.createRow(1).add("value 112", "value 212", "value 312");
      mtp.createRow(0).add("value 11", "value 21", "value 31");
      mtp.createRow(1).add("value 122", "value 222", "value 322");
      mtp.print();
      // expected output - columns aligned
      String out = "title1    title2    new title  \r\n"
                 + "value 10  value 20  value 30   \r\n"
                 + "value 112  value 212  value 312  \r\n"
                 + "value 11  value 21  value 31   \r\n"
                 + "value 122  value 222  value 322  \r\n";
      assertEquals(out, mtp.toString());
   }
   
   @Ignore
   class MockTabPrinter extends SimpleTabPrinter {

      StringBuilder sb = new StringBuilder();
      public MockTabPrinter() {
         super(3);
      }

      public void printLn() {
         sb.append("\r\n");
      };
      
      public void printLn(String text) {
         sb.append(text).append("\r\n");
      };
      
      @Override
      public String toString() {
         return sb.toString();
      }
   };
}
