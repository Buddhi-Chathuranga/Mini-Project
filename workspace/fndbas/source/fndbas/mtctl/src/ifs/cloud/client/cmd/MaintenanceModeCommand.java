package ifs.cloud.client.cmd;

import java.util.ArrayList;

import ifs.cloud.client.cli.CliException;
import ifs.cloud.client.cli.ReturnCode;
import ifs.cloud.client.cli.StringArg;
import ifs.cloud.client.k8s.Ingress;
import ifs.cloud.client.k8s.IngressList;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public class MaintenanceModeCommand extends K8SCommand {

   private StringArg mode;
   private final String html = "<html><head><title>IFS Cloud</title></head>"
         + "<body>"
         + "<center>"
         + "  <div><h1>Maintenance Mode</h1></div>"
         + "  <div><small>IFS Cloud<small></div>"
         + "</center>"
         + "</body>"
         + "</html>";
   
   public MaintenanceModeCommand() {
      super("maintenance");
      mode = new StringArg("mode", true, "mode is one of set(on) or reset(off)") {
         public SetValueResult setValue(String value) throws CliException {
            value = value.toLowerCase();
            if ("set".compareTo(value) == 0 || "reset".compareTo(value) == 0) {
               super.setValue(value);
               return SetValueResult.accepted;
            }
            if ("on".compareTo(value) == 0) {
               super.setValue("set");
               return SetValueResult.accepted;
            }
            if ("off".compareTo(value) == 0) {
               super.setValue("reset");
               return SetValueResult.accepted;
            }
            throw new CliException("Mode must be one of 'set' or 'reset");
         };
      };
      addArg(mode);
   }

   @Override
   protected ReturnCode run() throws Exception {
      // showConfig();
      boolean set = "set".compareTo(this.mode.getValue()) == 0;
      Logger.logln(Level.L5, "Mode:", this.mode.getValue());
      StringBuilder sb = new StringBuilder();
      sb.append("nginx.ingress.kubernetes.io/server-snippet");
      if (set) {
         sb.append("=return 200");
         sb.append(" '").append(html).append("';");
      }
      else {
         sb.append('-');
      }
      String anno = sb.toString();
      IngressList ingresslist = (IngressList) kubectl.fetch(new IngressList());
      ArrayList<Ingress> items = ingresslist.getItems();
      int count = items.size();
      int failed = 0;
      for (int i = 0; i < count; i++) {
         String ingressName = items.get(i).getMetadata().getName();
         Logger.logln(Level.L5, "Update ingress", ingressName);
         ArrayList<String> cmd = new ArrayList<>();
         cmd.add("annotate");
         cmd.add("ingress");
         cmd.add("--overwrite");
         cmd.add(ingressName);
         cmd.add(anno);
         failed += kubectl.exec(cmd);
         Logger.logln(Level.L5, "Ingress", ingressName, "updated");
      }
      return failed == 0 ? ReturnCode.Success : CmdReturnCode.PartiallyFailed;
   }

   @Override
   protected String shortDescription() {
      return "Set or reset maintenance mode";
   }
}
