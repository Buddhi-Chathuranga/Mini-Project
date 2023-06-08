package ifs.cloud.client.k8s.types;

public class IntAttr extends Attr<Integer> {
   public IntAttr(String field) {
      this(field, 0);
   }

   public IntAttr(String field, int defaultValue) {
      super(field, defaultValue);
   }

   void setInternalValue(String value) {
      if (value == null)
         setDefault();
      else
         setValue(Integer.parseInt(value));
   }
}