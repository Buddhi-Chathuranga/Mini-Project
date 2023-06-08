package ifs.cloud.client.cli;

public class FlagArg extends Arg {

   private boolean value = false;
   
   public FlagArg(String name, boolean defaultValue, String help) {
      super(name, false, help);
      this.value = defaultValue;
   }
   
   @Override
   protected String type() {
      return "flag";
   }

   @Override
   protected boolean validate() {
      return super.mandatory() ? super.IsSet() : true;
   }
   
   @Override
   SetValueResult setValue(String ignored) throws CliException {
      super.setValue(null);
      this.value = true;
      return SetValueResult.ignored;
   }
   
   public boolean getValue() {
      return value;
   }
}