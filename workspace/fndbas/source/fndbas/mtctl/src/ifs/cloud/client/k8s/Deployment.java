package ifs.cloud.client.k8s;

public final class Deployment extends KubeResource {   
   private final Annotations annotations = new Annotations();
   private final DeploymentStatus status = new DeploymentStatus();
   private final DeploymentSpec spec = new DeploymentSpec();
   
   public Deployment(String name, String namespace) {
      super(new Metadata(name, namespace));
      add(annotations, spec, status);
   }
   
   Deployment() {
      this(null, null);
   }
   
   @Override
   public String getKind() {
      return "deployments";
   }
   
   public final Annotations getAnnotations() {
      return annotations;
   }

   public final DeploymentStatus getStatus() {
      return status;
   }

   public boolean hasRequiredReplicaCount() {
      return status.getReplicas() >= spec.getReplicas();
   }
   
   @Override
   public String toString() {
      return "deployment:" + super.toString();
   }

   public final DeploymentSpec getSpec() {
      return spec;
   }
}