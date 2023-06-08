package ifs.cloud.client.k8s;

import java.util.ArrayList;
import java.util.Date;

import ifs.cloud.client.k8s.ContainerStatus.ContainerStatuses;
import ifs.cloud.client.k8s.types.StringAttr;
import ifs.cloud.client.k8s.types.TimeAttr;
import ifs.cloud.client.k8s.types.TypeDef;

public class PodStatus extends TypeDef {
   
   public static enum PodPhase { Pending, Running, Succeeded, Failed, Unknown }

   public static class PodPhaseAttr extends StringAttr {

      private PodPhase phase;
      
      public PodPhaseAttr() {
         super(".status.phase");
      }
      
      @Override
      public void setValue(String value) {
         phase = PodPhase.valueOf(value);
         super.setValue(value);
      }
      
      public PodPhase getPhase() {
         return phase;
      }
   }
   
   private final StringAttr hostIP = new StringAttr(".status.hostIP");
   // private final StringAttr phase = new StringAttr(".status.phase");
   private final PodPhaseAttr phase = new PodPhaseAttr();
   private final StringAttr podIP = new StringAttr(".status.podIP");
   private final TimeAttr started = new TimeAttr(".status.startTime");
   private final StringAttr reason = new StringAttr(".status.reason");
   private final ContainerStatuses containerStatuses = new ContainerStatuses();

   PodStatus() {
      add(hostIP, phase, podIP, started, reason);
      add(containerStatuses);
   }

   public String getHostIP() {
      return hostIP.getValue();
   }

   public PodPhase getPhase() {
      return phase.getPhase();
   }

   public String getPodIP() {
      return podIP.getValue();
   }

   public Date getStartedTime() {
      return started.getValue();
   }

   public String getReason() {
      return reason.getValue();
   }
   
   public ArrayList<ContainerStatus> getContainerStatuses() {
      return containerStatuses.getItems();
   }
}