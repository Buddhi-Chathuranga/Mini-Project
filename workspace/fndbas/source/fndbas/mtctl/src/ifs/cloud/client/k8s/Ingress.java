package ifs.cloud.client.k8s;

public class Ingress extends KubeResource {

   public Ingress(Metadata metadata) {
      super(metadata);
   }

   public Ingress() {}

   @Override
   public String getKind() {
      return "ingress";
   }

}
