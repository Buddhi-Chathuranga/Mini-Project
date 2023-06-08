package ifs.cloud.client.k8s;

import java.util.ArrayList;

import ifs.cloud.client.k8s.types.TypeDef;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public class Events extends ResourceBase {
   private final ArrayList<Event> items = new ArrayList<>();

   private final String filter;

   public Events(String filter) {
      this.filter = filter;
      add(new Event());
   }

   @Override
   public String getKind() {
      return "events";
   }

   @Override
   protected String[] getArgs() {
      String[] args = new String[filter != null ? 4 : 2];
      args[0] = "get";
      args[1] = getKind();
      if (filter != null) {
         args[2] = "--field-selector";
         args[3] = "involvedObject.name=" + filter;
      }
      return args;
   }

   @Override
   protected void clear() {
      items.clear();
   }

   @Override
   protected TypeDef newItem() {
      Event event = new Event();
      items.add(event);
      return event;
   }

   @Override
   protected boolean parse(String out) {
      Logger.logln(Level.L1, "parse response");
      // first line is a header
      String[] lines = out.split("\n");
      // create a lengths array based on the header line
      int[] widths = calulateColumnWidths(lines[0]);
      widths[5] = -1; // read all for message
      for (int i = 1; i < lines.length; i++) {
         Event event = (Event) parseLine(lines[i], widths);
         String msg = event.getMessage();
         // try to ignore rest of multiline message
         if (msg != null && msg.length() > 0) {
            int index = lines[i].indexOf(msg);
            do {
               int endIndex = lines[i].indexOf("<none>", index);
               if (endIndex != -1) {
                  break;
               }
               index = 0;
               i++;
            } while (i < lines.length);
            // try to ignore stats in message
            index = msg.indexOf(" % Total ");
            if (index > -1) {
               msg = msg.substring(0, index).trim();
            }
            index = msg.indexOf("<none>");
            if (index > -1) {
               msg = msg.substring(0, index).trim();
            }
            event.setMessage(msg);
         }
      }
      return true;
   }

   public ArrayList<Event> getItems() {
      return items;
   }
}
