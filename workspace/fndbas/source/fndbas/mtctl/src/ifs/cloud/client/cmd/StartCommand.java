package ifs.cloud.client.cmd;

import ifs.cloud.client.cli.ReturnCode;

public class StartCommand extends WaitableK8SCommand {

   public StartCommand() {
      super("start");
   }

   @Override
   protected final ReturnCode run() throws Exception {
      showConfig();
      return super.scaleAllDeployments(-1);
   }
   
   @Override
   protected String shortDescription() {
      return "Start deployments";
   }
}
