package ifs.cloud.client.k8s.types;

public class BooleanAttr extends Attr<Boolean> {
   public BooleanAttr(String field) {
      this(field, false);
   }

   public BooleanAttr(String field, boolean defaultValue) {
      super(field, defaultValue);
   }

   @Override
   void setInternalValue(String value) {
      if (value == null)
         setDefault();
      else
         setValue(Boolean.parseBoolean(value));
   }
}