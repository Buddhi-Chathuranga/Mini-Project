package ifs.cloud.client.k8s;

import ifs.cloud.client.k8s.types.TypeDef;

public abstract class KubeResourceList extends ResourceBase {
   private final KubeResource template;

   public KubeResourceList(KubeResource template) {
      this.template = template;
      add(template);
   }

   @Override
   public String getKind() {
      return template.getKind();
   }

   @Override
   protected String[] getArgs() {
      return new String[] { "get", this.getKind() };
   }
   
   @Override
   protected abstract TypeDef newItem();
}
