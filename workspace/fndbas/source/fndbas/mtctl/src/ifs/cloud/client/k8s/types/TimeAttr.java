package ifs.cloud.client.k8s.types;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeAttr extends Attr<Date> {

   private final String pattern = "yyyy-MM-dd'T'HH:mm:ssX";
   private final DateFormat df = new SimpleDateFormat(pattern);

   public TimeAttr(String field) {
      super(field, null);
   }

   @Override
   void setInternalValue(String value) {
      try {
         if (value != null)
            setValue(df.parse(value));
      }
      catch (ParseException ex) {
         throw new RuntimeException(ex);
      }
   }
}
