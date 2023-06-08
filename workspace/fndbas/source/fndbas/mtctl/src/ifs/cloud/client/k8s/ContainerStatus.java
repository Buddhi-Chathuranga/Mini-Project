package ifs.cloud.client.k8s;

import ifs.cloud.client.k8s.types.ArrayTypeDef;
import ifs.cloud.client.k8s.types.BooleanAttr;
import ifs.cloud.client.k8s.types.IntAttr;
import ifs.cloud.client.k8s.types.StringAttr;
import ifs.cloud.client.k8s.types.TypeDef;

public class ContainerStatus extends TypeDef {

   public static class ContainerStatuses extends ArrayTypeDef<ContainerStatus> {
      ContainerStatuses() {
         super(ContainerStatus::new, ".status.containerStatuses");
      }
   }

   private final StringAttr name = new StringAttr("name");
   private final BooleanAttr ready = new BooleanAttr("ready");
   private final BooleanAttr started = new BooleanAttr("started");
   private final StringAttr image = new StringAttr("image");
   private final IntAttr restartCount = new IntAttr("restartCount");

   ContainerStatus() {
      add(name, ready, started, image, restartCount);
   }

   public String getName() {
      return name.getValue();
   }

   public boolean isReady() {
      return ready.getValue();
   }

   public boolean isStarted() {
      return started.getValue();
   }

   public String getImageName() {
      return image.getValue();
   }

   public int getRestarts() {
      return restartCount.getValue();
   }

   @Override
   public String toString() {
      return "container:" + name;
   }
}
