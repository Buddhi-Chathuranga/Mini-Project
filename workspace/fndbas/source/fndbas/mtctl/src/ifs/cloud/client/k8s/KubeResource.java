package ifs.cloud.client.k8s;

/* root class for all kubectl objects */
public abstract class KubeResource extends ResourceBase {
   protected final Metadata metadata;

   public Metadata getMetadata() {
      return metadata;
   }

   protected String[] getArgs() {
      return new String[] { "get", getKind(), metadata.getName() };
   }

   protected KubeResource(Metadata metadata) {
      this.metadata = metadata;
      add(metadata);
   }

   KubeResource() {
      this(new Metadata());
   }

   @Override
   public String toString() {
      return metadata.toString();
   }

   @Override
   protected void clear() {}
}
