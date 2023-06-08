package ifs.cloud.client.k8s;

import java.util.Date;

import ifs.cloud.client.k8s.types.DummyAttr;
import ifs.cloud.client.k8s.types.IntAttr;
import ifs.cloud.client.k8s.types.StringAttr;
import ifs.cloud.client.k8s.types.TimeAttr;

public class Event extends ResourceBase {
   private final IntAttr count = new IntAttr(".count", -1);
   private final StringAttr type = new StringAttr(".type");
   private final StringAttr reason = new StringAttr(".reason");
   private final TimeAttr time = new TimeAttr(".lastTimestamp");
   private final StringAttr message = new StringAttr(".message");

   Event() {
      add(count, type, reason, time, new DummyAttr(), message, new DummyAttr());
   }

   @Override
   public String getKind() {
      return "events";
   }

   @Override
   protected String[] getArgs() {
      return null;
   }

   @Override
   protected void clear() {}

   public int getCount() {
      return count.getValue();
   }

   public String getType() {
      return type.getValue();
   }

   public String getReason() {
      return reason.getValue();
   }

   public String getMessage() {
      return message.getValue();
   }
   
   public Date getTime() {
      return time.getValue();
   }
   
   void setMessage(String msg) {
      setAttrValue(message, msg);
   }
}

