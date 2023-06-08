package ifs.cloud.client.cmd;

import java.util.ArrayList;

import ifs.cloud.client.cli.CliException;
import ifs.cloud.client.cli.IntArg;
import ifs.cloud.client.cli.ReturnCode;
import ifs.cloud.client.k8s.Deployment;
import ifs.cloud.client.k8s.DeploymentList;
import ifs.cloud.client.k8s.KubeException;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public abstract class WaitableK8SCommand extends K8SCommand {
   private final static int DEFAULT_TIMEOUT = 600; // 10 minutes
   private IntArg timeout;
   
   public WaitableK8SCommand(String name) {
      super(name);
      timeout = new IntArg("timeout", "wait timeout to complete the command (seconds)");
      addArg(timeout);
   }

   ReturnCode waitForDeployments() throws CliException, KubeException {
      int timeout = (this.timeout.IsSet() ? this.timeout.getValue() : DEFAULT_TIMEOUT);
      return waitForDeploymentReady(timeout);
   }

   ReturnCode scaleAllDeployments(int scale) throws CliException, KubeException {
      Logger.logln(Level.L4, "Setting scale of all deployments");
      Logger.progln(Level.L4, "Fetch namespace");
      DeploymentList dlist = (DeploymentList) kubectl.fetch(new DeploymentList());
      int changed = 0;
      ArrayList<Deployment> items = dlist.getItems();
      for (int i = 0; i < items.size(); i++) {
         Deployment item = items.get(i);
         if ("ifsapp-db".equals(item.getMetadata().getName())) {
            if (scale == 0) 
               Logger.logln(Level.L5, "deployment ifsapp-db is not affected by stop command");
         } else {
            if (scale(item, scale))
               changed++;            
         }
      }
      Logger.logln(Level.L5, changed, "deployments updated");
      if (changed > 0 && timeout.IsSet()) {
         Logger.progln(Level.L4, "Wait for deployments to stabilize");
         try {
            Thread.sleep(10000);
         }
         catch (InterruptedException ex) {}
         return waitForDeploymentReady(timeout.getValue());
      }
      return ReturnCode.Success;
   }

}
