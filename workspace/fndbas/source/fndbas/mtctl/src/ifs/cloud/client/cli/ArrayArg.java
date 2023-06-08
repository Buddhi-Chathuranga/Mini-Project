package ifs.cloud.client.cli;

import java.util.ArrayList;

public class ArrayArg extends Arg {

   public static class KeyValue {
      private final String name;
      private final String value;
      
      public KeyValue(String name, String value) {
         this.name = name;
         this.value = value;
      }

      public final String getName() {
         return name;
      }

      public final String getValue() {
         return value;
      }
   }
   
   ArrayList<KeyValue> values = new ArrayList<>();
   
   public ArrayArg(String name, String help) {
      this(name, false, help);
   }

   public ArrayArg(String name, boolean mandatory, String help) {
      super(name, mandatory, help);
   }
   
   SetValueResult setValue(String name, String value) throws CliException {
      values.add(new KeyValue(name, value));
      return super.setValue(value);
   }
   
   public ArrayList<KeyValue> getValues() {
      return values;
   }
   
   @Override
   protected boolean validate() {
      return super.mandatory() ? super.IsSet() : true;
   }

   @Override
   protected String type() {
      return "string";
   }

}
