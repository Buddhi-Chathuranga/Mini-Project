package ifs.cloud.client.cmd;

import java.util.ArrayList;

import ifs.cloud.client.k8s.KubeResource;

public class K8SHelper {

   protected KubeResource resource;

   private ArrayList<PodHelper> pods;
   
   public K8SHelper(KubeResource resource) {
      this.setResource(resource);
   }

   public KubeResource getResource() {
      return resource;
   }

   public void setResource(KubeResource resource) {
      this.resource = resource;
   }

   public ArrayList<PodHelper> getPods() {
      return pods;
   }

   public void setPods(ArrayList<PodHelper> pods) {
      this.pods = pods;
   }

   String getName() {
      return resource.getMetadata().getName();
   }
   
   @Override
   public String toString() {
      return resource.toString();
   }

   String getNamespace() {
      return resource.getMetadata().getNamespace();
   }

   public String getKind() {
      return resource.getKind();
   }
}
