package ifs.cloud.client.k8s;

import ifs.cloud.client.k8s.types.IntAttr;
import ifs.cloud.client.k8s.types.TypeDef;

public class DeploymentSpec extends TypeDef {

   private final IntAttr replicas = new IntAttr(".spec.replicas");

   DeploymentSpec() {
      add(replicas);
   }
   
   public final int getReplicas() {
      return replicas.getValue();
   }
   
   @Override
   public String toString() {
      return "replicas:" + replicas;
   }
}
