package ifs.cloud.client.k8s;

import java.util.ArrayList;

import ifs.cloud.client.k8s.types.TypeDef;

public final class PodList extends KubeResourceList {
   private final ArrayList<Pod> items = new ArrayList<>();
   private final String filter;
   
   public PodList() {
      this(null);
   }
   
   public PodList(String filter) {
      super(new Pod());
      this.filter = filter;
   }

   public ArrayList<Pod> getItems() {
      return items;
   }
   
   @Override
   protected String[] getArgs() {
      String[] args = super.getArgs();
      if (filter != null) {
         String [] temp = new String [args.length + 1];
         System.arraycopy(args, 0, temp, 0, args.length);
         temp[args.length] = "--selector=app=" + filter;
         args = temp;
      }
      return args;
   }
   
   @Override
   protected TypeDef newItem() {
      Pod pod = new Pod();
      items.add(pod);
      return pod;
   }
   
   @Override
   protected void clear() {
      items.clear();
   }
}
