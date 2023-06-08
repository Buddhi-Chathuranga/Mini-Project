package ifs.cloud.client.k8s;

import java.util.ArrayList;

import ifs.cloud.client.k8s.types.Attr;
import ifs.cloud.client.k8s.types.TypeDef;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public abstract class ResourceBase extends TypeDef {

   protected ResourceBase() {}

   public abstract String getKind();

   protected abstract String[] getArgs();

   protected abstract void clear();

   final void fetch(KubeCtlCaller caller) throws KubeException {
      clear();
      ArrayList<String> commands = new ArrayList<>();
      for (String a : getArgs()) {
         commands.add(a);
      }
      commands.add("-o");
      StringBuilder sb = new StringBuilder();
      sb.append("custom-columns=").append(asColumnList());
      commands.add(sb.toString());
      if (caller.exec(commands) != 0)
         throw new KubeException(caller.getErr());
      parse(caller.getOut());
   }

   protected boolean parse(String out) {
      Logger.logln(Level.L1, "parse response");
      // first line is a header
      String[] lines = out.split("\n");
      // create a lengths array based on the header line
      int[] widths = calulateColumnWidths(lines[0]);
      Logger.logln(Level.L1, "columns", widths);
      for (int k = 1; k < lines.length; k++) {
         parseLine(lines[k], widths);
      }
      Logger.logln(Level.L1, lines.length - 1, "records fetched");
      return lines.length > 0;
   }

   protected TypeDef parseLine(String line, int[] widths) {
      Logger.logln(Level.L1, "parse::", line);
      TypeDef item = newItem();
      ArrayList<Attr<?>> itemAttrs = item.getAttrs();
      int begin = 0;
      for (int i = 0; i < itemAttrs.size(); i++) {
         Attr<?> attr = itemAttrs.get(i);
         String temp = widths[i] > -1 ? line.substring(begin, begin + widths[i]) : line.substring(begin);
         begin += widths[i];
         if (temp != null)
            temp = temp.trim();
         if ("".equals(temp) || "<none>".equals(temp) || "<nil>".equals(temp))
            temp = null;
         item.setAttrValue(attr, temp);
      }
      item.updated();
      return item;
   }
}
