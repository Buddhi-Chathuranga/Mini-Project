package ifs.cloud.client.k8s.types;

public class StringAttr extends Attr<String> {
   public StringAttr(String field) {
      super(field, null);
   }

   @Override
   void setInternalValue(String value) {
      setValue(value);
   }
}