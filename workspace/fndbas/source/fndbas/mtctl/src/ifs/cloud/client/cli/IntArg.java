package ifs.cloud.client.cli;

public class IntArg extends Arg {

   private int value;

   public IntArg(String name, String help) {
      this(name, false, help);
   }

   public IntArg(String name, boolean mandatory, String help) {
      super(name, mandatory, help);
   }

   @Override
   final SetValueResult setValue(String value) throws CliException {
      if (value == null)
         throw new CliException("A number values is required for " + getName() + " argument.");
      try {
         this.value = Integer.parseInt(value);
         return super.setValue(value);
      }
      catch (NumberFormatException ex) {
         throw new CliException("Number format is invalid for " + getName() + " argument.", ex);
      }
   }

   @Override
   protected final boolean validate() {
      return super.mandatory() ? super.IsSet() : true;
   }

   public final int getValue() {
      return value;
   }
   
   @Override
   public String toString() {
      return getName() + ":" + value;
   }
   
   @Override
   protected String type() {
      return "number";
   }
}
