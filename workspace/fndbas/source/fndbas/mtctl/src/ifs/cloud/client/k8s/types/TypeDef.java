package ifs.cloud.client.k8s.types;

import java.util.ArrayList;

import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

/* root class for handling attribute collection */
public abstract class TypeDef {
   private ArrayList<Attr<?>> attrs = new ArrayList<>();
   private ArrayList<TypeDef> composite = new ArrayList<>();

   public TypeDef() {}

   protected TypeDef newItem() {
      return this;
   }

   protected void add(Attr<?>... attrs) {
      for (int i = 0; i < attrs.length; i++) {
         this.attrs.add(attrs[i]);
      }
   }

   protected void add(TypeDef... res) {
      for (int i = 0; i < res.length; i++) {
         attrs.addAll(res[i].attrs);
         composite.add(res[i]);
      }
   }

   public ArrayList<Attr<?>> getAttrs() {
      return attrs;
   }

   protected int[] calulateColumnWidths(String header) {
      int[] widths = new int[attrs.size()];
      widths[widths.length - 1] = -1;
      int size = attrs.size() - 1;
      int prev = header.indexOf("C" + size);
      while (size-- > 0) {
         int index = header.indexOf("C" + size); 
         widths[size] = prev - index;
         prev = index;
      }
      return widths;
   }

   protected String asColumnList() {
      StringBuilder sb = new StringBuilder();
      for (int i = 0; i < this.attrs.size(); i++) {
         if (sb.length() > 0)
            sb.append(',');
         Attr<?> attr = this.attrs.get(i);
         sb.append('C').append(i).append(':');
         sb.append(attr.getField());
      }
      return sb.toString();
   }

   public void updated() {
      for (int i = 0; i < composite.size(); i++) {
         composite.get(i).updated();
      }
   }

   public void setAttrValue(Attr<?> attr, String value) {
      Logger.logln(Level.L1, attr.getField(), ':', value);
      attr.setInternalValue(value);
   }

   public Attr<?> findAttr(String field) {
      for (int i = 0; i < attrs.size(); i++) {
         Attr<?> attr = attrs.get(i);
         if (attr.getField().equals(field))
            return attr;
      }
      return null;
   }
   
   @Override
   public String toString() {
      StringBuilder sb = new StringBuilder();
      sb.append(getClass().getSimpleName()).append("\n");
      for (int i = 0; i < attrs.size(); i++) {
         sb.append(attrs.get(i).toString()).append("\n");
      }
      return sb.toString();
   }
}
