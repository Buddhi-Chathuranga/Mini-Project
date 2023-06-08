package ifs.cloud.client.k8s;

import ifs.cloud.client.k8s.types.ArrayTypeDef;
import ifs.cloud.client.k8s.types.BooleanAttr;
import ifs.cloud.client.k8s.types.StringAttr;
import ifs.cloud.client.k8s.types.TypeDef;

public class Condition extends TypeDef {
   
   public static class Conditions extends ArrayTypeDef<Condition> {
      Conditions() {
         super(Condition::new, ".status.conditions");
      }
   }
   
//   private final StringAttr message = new StringAttr("message");
   private final StringAttr reason = new StringAttr("reason");
   private final BooleanAttr status = new BooleanAttr("status");
   private final StringAttr type = new StringAttr("type");
   
   Condition() {
      add(/*message, */reason, status, type);
   }

//   public String getMessage() {
//      return message.getValue();
//   }

   public String getReason() {
      return reason.getValue();
   }

   public boolean getStatus() {
      return status.getValue();
   }

   public String getType() {
      return type.getValue();
   }
}
