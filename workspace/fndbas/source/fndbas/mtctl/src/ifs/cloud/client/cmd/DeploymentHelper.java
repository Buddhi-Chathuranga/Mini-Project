package ifs.cloud.client.cmd;

import java.util.ArrayList;

import ifs.cloud.client.k8s.Condition;
import ifs.cloud.client.k8s.Deployment;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

class DeploymentHelper extends K8SHelper {

   private boolean completed = false;
   
   public static enum DeploymentStatus {
      
      DISABLED(0, "DISABLED"),
      STOPPED(1, "STOPPED"),
      NOT_READY(2, "NOT_READY"),
      READY(3, "READY");
      
      private final int uid;
      private final String desc;
      
      private DeploymentStatus(int uid, String desc) {
         this.uid = uid;
         this.desc = desc;
      }

      public int uid() {
         return this.uid;
      }
      
      public String toString() {
         return this.desc;
      }
   }

   DeploymentHelper(Deployment depl) {
      super(depl);
   }

   boolean isCompleted() {
      return completed;
   }

   boolean hasRequiredReplicaCount() {
      return ((Deployment)getResource()).hasRequiredReplicaCount();
   }

   int getStatusReplicaCount() {
      return ((Deployment)getResource()).getStatus().getReplicas();
   }
   
   int getStatusAvailableReplicaCount() {
      return ((Deployment)getResource()).getStatus().getAvailableReplicas();
   }

   void setCompleted() {
      Logger.logln(Level.L4, getName(), "deployment completed");
      this.completed = true;
   }

   ArrayList<Condition> getStatusConditions() {
      return ((Deployment)getResource()).getStatus().getConditions();
   }
   
   @Override
   public boolean equals(Object obj) {
      if (obj == this) return true;
      if (obj instanceof DeploymentHelper) {
         return ((DeploymentHelper)obj).getName().equals(this.getName());
      }
      return super.equals(obj);
   }
   
   /**
    * replica count set during IFS installation
    * @return
    */
   public int getDefaultReplicaCount() {
      return ((Deployment)getResource()).getAnnotations().getDefaultReplicas();
   }
   
   public int getSpecReplicaCount() {
      return ((Deployment)getResource()).getSpec().getReplicas();
   }
   
   public DeploymentStatus getStatus() {
      if (getDefaultReplicaCount() <= 0)
         return DeploymentStatus.DISABLED;
      if (getStatusReplicaCount() <= 0) 
         return DeploymentStatus.STOPPED;
      return completed ? DeploymentStatus.READY : DeploymentStatus.NOT_READY;
   }
}