package ifs.cloud.client.k8s;

import java.util.ArrayList;

import ifs.cloud.client.k8s.types.TypeDef;

public final class JobList extends KubeResourceList {
   private final ArrayList<Job> items = new ArrayList<>();

   public JobList() {
      super(new Job());
   }

   public ArrayList<Job> getItems() {
      return items;
   }
   
   @Override
   protected TypeDef newItem() {
      Job depl = new Job();
      items.add(depl);
      return depl;
   }
   
   @Override
   protected void clear() {
      items.clear();
   }
}
