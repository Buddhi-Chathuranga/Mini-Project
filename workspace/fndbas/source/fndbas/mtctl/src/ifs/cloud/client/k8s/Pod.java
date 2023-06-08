package ifs.cloud.client.k8s;

public final class Pod extends KubeResource {
   private final PodStatus status = new PodStatus();

   public Pod(String name, String namespace) {
      super(new Metadata(name, namespace));
      add(status);
   }

   Pod() {
      this(null, null);
   }

   @Override
   public String getKind() {
      return "pods";
   }

   public PodStatus getStatus() {
      return status;
   }
   
   @Override
   public String toString() {
      return "pod:" + super.toString();
   }
}
