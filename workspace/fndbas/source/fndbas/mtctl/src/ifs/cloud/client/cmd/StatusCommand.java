package ifs.cloud.client.cmd;

import ifs.cloud.client.cli.ReturnCode;

public class StatusCommand extends K8SCommand {

   public StatusCommand() {
      super("status");
   }

   @Override
   protected final ReturnCode run() throws Exception {
      showConfig();
      return super.listNamespaceStatus();
   }

   @Override
   protected String shortDescription() {
      return "List deployment status";
   }
}
