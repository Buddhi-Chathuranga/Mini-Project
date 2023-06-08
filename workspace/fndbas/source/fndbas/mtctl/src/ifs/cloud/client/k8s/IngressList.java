package ifs.cloud.client.k8s;

import java.util.ArrayList;

import ifs.cloud.client.k8s.types.TypeDef;

public class IngressList extends KubeResourceList {
   private final ArrayList<Ingress> items = new ArrayList<>();
   
   public IngressList() {
      super(new Ingress());
   }

   public ArrayList<Ingress> getItems() {
      return items;
   }
   
   @Override
   protected TypeDef newItem() {
      Ingress ingress = new Ingress();
      items.add(ingress);
      return ingress;
   }
   
   @Override
   protected void clear() {
      items.clear();
   }
}
