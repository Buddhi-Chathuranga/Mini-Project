package ifs.cloud.client.k8s;

import java.util.ArrayList;

import ifs.cloud.client.k8s.types.TypeDef;

public final class DeploymentList extends KubeResourceList {
   private final ArrayList<Deployment> items = new ArrayList<>();

   public DeploymentList() {
      super(new Deployment());
   }

   public ArrayList<Deployment> getItems() {
      return items;
   }
   
   @Override
   protected TypeDef newItem() {
      Deployment depl = new Deployment();
      items.add(depl);
      return depl;
   }
   
   @Override
   protected void clear() {
      items.clear();
   }
}
