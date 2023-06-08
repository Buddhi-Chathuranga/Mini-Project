package ifs.cloud.client.cmd;

import ifs.cloud.client.cli.ReturnCode;

public class StopCommand extends WaitableK8SCommand {

   public StopCommand() {
      super("stop");
   }

   @Override
   protected final ReturnCode run() throws Exception {
      showConfig();
      return super.scaleAllDeployments(0);
   }

   @Override
   protected String shortDescription() {
      return "Stop deployments";
   }
}
