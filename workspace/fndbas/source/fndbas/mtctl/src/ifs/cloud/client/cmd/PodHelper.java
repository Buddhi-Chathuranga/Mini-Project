package ifs.cloud.client.cmd;

import java.util.ArrayList;
import java.util.Date;

import ifs.cloud.client.k8s.ContainerStatus;
import ifs.cloud.client.k8s.Event;
import ifs.cloud.client.k8s.Pod;
import ifs.cloud.client.k8s.PodStatus.PodPhase;

class PodHelper {
   private final Pod pod;
   private ArrayList<Event> events;
   private int readyCount = -1;
   
   int getReadyCount() {
      return readyCount;
   }

   int getTotalCount() {
      return totalCount;
   }

   private int totalCount = -1;
   
   PodHelper(Pod pod) {
      this.pod = pod;
   }

   ArrayList<ContainerStatus> getContainerStatuses() {
      return pod.getStatus().getContainerStatuses();
   }

   String getName() {
      return pod.getMetadata().getName();
   }

   @Override
   public String toString() {
      return pod + "(" + pod.getStatus().getPodIP() + ")";
   }
   
   void setEvents(ArrayList<Event> events) {
      this.events = events;
   }

   ArrayList<Event> getEvents() {
      return events;
   }

   void setReadyCount(int ready) {
      this.readyCount = ready;
   }

   void setTotalCount(int count) {
      this.totalCount = count;
   }
   
   Date getStartedTime() {
      return this.pod.getStatus().getStartedTime();
   }
   
   PodPhase getPhase() {
      return this.pod.getStatus().getPhase();
   }
   
   String getReason() {
      return this.pod.getStatus().getReason();
   }
}