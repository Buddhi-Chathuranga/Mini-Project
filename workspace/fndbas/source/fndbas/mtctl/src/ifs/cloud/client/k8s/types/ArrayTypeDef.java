package ifs.cloud.client.k8s.types;

import java.util.ArrayList;
import java.util.function.Supplier;

import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public abstract class ArrayTypeDef<T extends TypeDef> extends TypeDef {
   private final Supplier<T> supplier;
   private final ArrayList<T> items = new ArrayList<>();

   protected ArrayTypeDef(Supplier<T> supplier, String commonName) {
      this.supplier = supplier;
      T template = supplier.get();
      ArrayList<Attr<?>> templateAttrs = template.getAttrs();
      for (int i = 0; i < templateAttrs.size(); i++) {
         StringArrayAttr aah = new StringArrayAttr(commonName, templateAttrs.get(i));
         super.add(aah);
      }
   }

   public ArrayList<T> getItems() {
      return items;
   }

   @Override
   public void updated() {
      ArrayList<Attr<?>> attrs = getAttrs();
      int expectedItemCount = 0;
      for (int i = 0; i < attrs.size(); i++) {
         StringArrayAttr attr = (StringArrayAttr) attrs.get(0);
         expectedItemCount = ((StringArrayAttr) attr).count();
         if (expectedItemCount > 0)
            break;
      }
      Logger.logln(Level.L1, getClass(), "expectedItemCount", expectedItemCount);
      if (expectedItemCount > 0) {
         for (int i = 0; i < expectedItemCount; i++) {
            items.add(supplier.get());
         }
         for (int j = 0; j < attrs.size(); j++) {
            StringArrayAttr aah = (StringArrayAttr) attrs.get(j);
            String[] value = aah.getValue();
            if (value != null) {
               for (int i = 0; i < expectedItemCount; i++) {
                  Logger.logln(Level.L1, getClass(), i, value[i]);
                  T item = items.get(i);
                  item.setAttrValue(item.findAttr(aah.attr.getField()), value[i]);
               }
            }
         }
      }
      super.updated();
   }

   private static class StringArrayAttr extends Attr<String[]> {
      private final Attr<?> attr;

      StringArrayAttr(String commonName, Attr<?> attr) {
         super(commonName + "[*]." + attr.getField(), null);
         this.attr = attr;
      }

      void setInternalValue(String value) {
         if (value == null || "<none>".equals(value))
            super.setDefault();
         else
            setValue(value.split(","));
      }
      
      public int count() {
         String[] value = super.getValue();
         return value == null ? 0 : value.length;
      }
   }

   // class ArrayAttr extends Attr<String[]> {
   //
   // public ArrayAttr(String field) {
   // super(field, null);
   // }
   //
   // void setInternalValue(String value) {
   // if (value == null || "<none>".equals(value))
   // super.setDefault();
   // else
   // setValue(value.split(","));
   // }
   // }
}
