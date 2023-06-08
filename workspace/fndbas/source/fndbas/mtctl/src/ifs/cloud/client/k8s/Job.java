package ifs.cloud.client.k8s;

public class Job extends KubeResource {

   public Job(String name, String namespace) {
      super(new Metadata(name, namespace));
//      add(annotations, spec, status);
   }

   Job() {
      this(null, null);
   }

   @Override
   public String getKind() {
      return "jobs";
   }
   
   @Override
   public String toString() {
      return "job:" + super.toString();
   }
}
