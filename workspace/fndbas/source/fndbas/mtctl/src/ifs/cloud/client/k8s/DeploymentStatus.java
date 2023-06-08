package ifs.cloud.client.k8s;

import java.util.ArrayList;

import ifs.cloud.client.k8s.Condition.Conditions;
import ifs.cloud.client.k8s.types.IntAttr;
import ifs.cloud.client.k8s.types.TypeDef;

public class DeploymentStatus extends TypeDef {
   private final IntAttr availableReplicas = new IntAttr(".status.availableReplicas", -1);
   private final IntAttr replicas = new IntAttr(".status.replicas", -1);
   private final Conditions conditions = new Conditions();
   
   DeploymentStatus() {
      add(availableReplicas, replicas);
      add(conditions);
   }

   public int getAvailableReplicas() {
      return availableReplicas.getValue();
   }

   public int getReplicas() {
      return replicas.getValue();
   }

   public ArrayList<Condition> getConditions() {
      return conditions.getItems();
   }
}
