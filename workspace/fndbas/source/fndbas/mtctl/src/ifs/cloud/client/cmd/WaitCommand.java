package ifs.cloud.client.cmd;

import ifs.cloud.client.cli.ReturnCode;

public final class WaitCommand extends WaitableK8SCommand {

   public WaitCommand() {
      super("wait");
   }

   @Override
   protected ReturnCode run() throws Exception {
      showConfig();
      return super.waitForDeployments();
   }

   @Override
   protected String shortDescription() {
      return "Wait for deployments";
   }
}
