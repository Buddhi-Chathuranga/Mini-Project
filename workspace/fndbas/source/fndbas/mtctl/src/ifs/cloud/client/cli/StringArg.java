package ifs.cloud.client.cli;

public class StringArg extends Arg {
   private String value;

   public StringArg(String name, String help) {
      this(name, false, null, help);
   }

   public StringArg(String name, boolean mandatory, String help) {
      this(name, mandatory, null, help);
   }

   public StringArg(String name, String defaultValue, String help) {
      this(name, false, defaultValue, help);
   }
   
   private StringArg(String name, boolean mandatory, String defaultValue, String help) {
      super(name, mandatory, help);
      this.value = defaultValue;
   }
   
   @Override
   public SetValueResult setValue(String value) throws CliException {
      this.value = value;
      return super.setValue(value);
   }

   @Override
   protected boolean validate() {
      return super.mandatory() ? (super.IsSet() && value != null && value.length() > 0) : true;
   }

   public String getValue() {
      return value;
   }
   
   @Override
   public String toString() {
      return getName() + ":" + value;
   }
   
   @Override
   protected String type() {
      return "string";
   }
}
