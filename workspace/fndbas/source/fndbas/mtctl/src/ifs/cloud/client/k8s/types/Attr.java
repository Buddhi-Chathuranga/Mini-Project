package ifs.cloud.client.k8s.types;

public abstract class Attr<T> {
   private T value;
   private final T defaultValue;

   // field in kubectl returned yaml
   private final String field;

   Attr(String field, T defaultValue) {
      this.field = field;
      this.defaultValue = defaultValue;
   }

   public final String getField() {
      return field;
   }

   public T getValue() {
      return value;
   }

   public void setValue(T value) {
      this.value = value;
   }

   protected void setDefault() {
      this.value = defaultValue;
   }

   abstract void setInternalValue(String value);

   @Override
   public String toString() {
      return getField() + ":" + value;
   }
}
