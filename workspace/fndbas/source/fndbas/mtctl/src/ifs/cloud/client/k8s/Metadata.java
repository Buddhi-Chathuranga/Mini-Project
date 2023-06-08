package ifs.cloud.client.k8s;

import ifs.cloud.client.k8s.types.StringAttr;
import ifs.cloud.client.k8s.types.TypeDef;

public final class Metadata extends TypeDef {
   private final StringAttr name = new StringAttr(".metadata.name");
   private final StringAttr namespace = new StringAttr(".metadata.namespace");

   public Metadata(String name, String namespace) {
      this();
      setAttrValue(this.namespace, namespace);
      setAttrValue(this.name, name);
   }
   
   Metadata() {
      add(name, namespace);
   }
   
   public String getNamespace() {
      return namespace.getValue();
   }

   public String getName() {
      return name.getValue();
   }
   
   @Override
   public String toString() {
      return name.getValue() + "@" + namespace.getValue();
   }
}
