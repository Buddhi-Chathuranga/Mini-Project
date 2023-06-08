 package ifs.cloud.client.k8s;

import ifs.cloud.client.k8s.types.IntAttr;
import ifs.cloud.client.k8s.types.TypeDef;

public class Annotations extends TypeDef {
   private final IntAttr defaultReplicas = new IntAttr(".metadata.annotations.ifs\\.default\\.replicas", -1);

   Annotations() {
      add(defaultReplicas);
   }

   public int getDefaultReplicas() {
      return defaultReplicas.getValue();
   }
}
