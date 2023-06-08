package ifs.cloud.client.cli;

public abstract class Arg {
   public enum SetValueResult {
      accepted, ignored, notfound,
   }

   private final String name;
   private boolean set = false;
   private final boolean mandatory;
   private final String help;
   private boolean visible = true; // for usage listing
   protected abstract boolean validate();
   protected abstract String type();
   
   Arg(String name, boolean mandatory, String help) {
      this.name = name;
      this.mandatory = mandatory;
      this.help = help;
   }

   @Override
   public boolean equals(Object obj) {
      if (obj instanceof String)
         return name.compareToIgnoreCase((String) obj) == 0;
      return super.equals(obj);
   }

   SetValueResult setValue(String value) throws CliException {
      set = true;
      return SetValueResult.accepted;
   }

   public final boolean mandatory() {
      return mandatory;
   }

   public final boolean IsSet() {
      return set;
   }
   
   public final String getName() {
      return name;
   }
   
   public final String getType() {
      return type();
   }
   
   String shortDescription() {
      StringBuilder sb = new StringBuilder();
      if (mandatory) sb.append("(required) ");
      sb.append(help);
      return sb.toString();
   }
   
   boolean isVisible() {
      return visible;
   }
   
   public void setVisible(boolean set) {
      visible = set;
   }
}
