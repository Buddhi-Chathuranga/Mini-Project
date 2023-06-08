package ifs.cloud.client.k8s.types;

public class DummyAttr extends StringAttr {

   public DummyAttr() {
      super("_");
   }
   
   @Override
   public void setValue(String value) {}
}
