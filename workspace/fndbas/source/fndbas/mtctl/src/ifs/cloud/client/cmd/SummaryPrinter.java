package ifs.cloud.client.cmd;

import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.TimeUnit;

import ifs.cloud.client.cli.SimpleTabPrinter;
import ifs.cloud.client.cli.SimpleTabPrinter.TextRow;
import ifs.cloud.client.k8s.ContainerStatus;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

final class SummaryPrinter {
   private final ArrayList<DeploymentHelper> dlist;

   SummaryPrinter(ArrayList<DeploymentHelper> dlist) {
      this.dlist = dlist;
   }

   void print() {
      Logger.logln(Level.L9, "Deployments/Pods status");
      Logger.logln(Level.L9, "Namespace:", dlist.get(0).getNamespace());
      Logger.logln(Level.L9);
      SimpleTabPrinter stp = new SimpleTabPrinter(3) {
         public void printLn() {
            Logger.logln(Level.L9);
         };
         
         public void printLn(String text) {
            Logger.logln(Level.L9, text);
         };
      };
      TextRow header2 = stp.createRow(2);
      header2.add("DEPLOYMENT STATUS");
      TextRow header1 = stp.createRow(1);
      header1.add("", "POD NAME", "READY", "AGE", "CONTAINER STATUS");
      
      int podCount = 0;
      long now = new Date().getTime();
      for (int i = 0; i < dlist.size(); i++) {
         DeploymentHelper depl = dlist.get(i);
         TextRow row = stp.createRow(0);
         row.addColumn(depl.getName(), depl.getStatus().toString());
         ArrayList<PodHelper> pods = depl.getPods();
         if (pods != null) {
            for (int j = 0; j < pods.size(); j++) {
               row = stp.createRow(1);
               row.addColumn("");
               PodHelper pod = pods.get(j);
               row.addColumn(pod.getName());
               row.addColumn(pod.getReadyCount() + "/" + pod.getTotalCount());
               Date started = pod.getStartedTime();
               row.addColumn(started != null ? timeAsAge(now - started.getTime()) : "-");
               ArrayList<ContainerStatus> statuses = pod.getContainerStatuses();
               if (statuses != null) {
                  for (int k = 0; k < statuses.size(); k++) {
                     ContainerStatus status = statuses.get(k);
                     String statusStr;
                     if (status.isReady())
                        statusStr = "READY";
                     else if (status.isStarted()) {
                        statusStr = (status.getRestarts() > 1) ? status.getRestarts() + " RESTARTS" : "STARTED";
                        statusStr += ", NOT READY";
                     }
                     else {
                        statusStr = "NOT STARTED";
                        if (status.getRestarts() > 1)
                           statusStr += " (" + status.getRestarts() + " restarts)";
                     }
                     row.addColumn(status.getName(), statusStr);
                  }
               }
               podCount++;
            }
         }
         stp.createRow(0);
      }
      if (podCount == 0) {
         stp.removeRow(header1);
         stp.removeRow(header2);
      }
      stp.print();
   }

   private String timeAsAge(long time) {
      long seconds = TimeUnit.SECONDS.convert(time, TimeUnit.MILLISECONDS);
      int hours = (int)(seconds / 3600);
      int mins = (int)(seconds / 60 % 60);
      int secs = (int)(seconds % 60);
      if (hours > 23) {
         int days = hours / 24;
         hours = hours % 24;
         return days + "d" + hours + "h";
      }
      if (hours != 0) {
         return hours + "h" + mins + "m";
      }
      if (mins != 0) {
         return mins + "m" + secs + "s";
      }
      return secs + "s";
   }

   void printSimple() {
      Logger.logln(Level.L9, "Namespace:", dlist.get(0).getNamespace());
      for (int i = 0; i < dlist.size(); i++) {
         DeploymentHelper depl = dlist.get(i);
         Logger.logln(Level.L9);
         Logger.logln(Level.L9, "  Deployment:", depl.getName(), depl.getStatus().toString());
         ArrayList<PodHelper> pods = depl.getPods();
         if (pods != null) {
            for (int j = 0; j < pods.size(); j++) {
               PodHelper pod = pods.get(j);
               Logger.logln(Level.L9, "   Pod:", pod.getName(), pod.getReadyCount() + "/" + pod.getTotalCount());
               ArrayList<ContainerStatus> statuses = pod.getContainerStatuses();
               if (statuses != null) {
                  for (int k = 0; k < statuses.size(); k++) {
                     ContainerStatus status = statuses.get(k);
                     String statusStr;
                     if (status.isReady())
                        statusStr = "READY";
                     else if (status.isStarted())
                        statusStr = "STARTED, NOT READY";
                     else
                        statusStr = "NOT STARTED";
                     Logger.logln(Level.L9, "     Container:", status.getName(), statusStr);
                  }
               }
            }
         }
      }
   }
}
