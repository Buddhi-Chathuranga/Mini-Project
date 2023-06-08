package ifs.cloud.client.cli;

import java.io.File;

public class PathArg extends StringArg {

   public PathArg(String name, String help) {
      super(name, help);
   }

   public PathArg(String name, boolean mandatory, String help) {
      super(name, mandatory, help);
   }

   public PathArg(String name, String defaultValue, String help) {
      super(name, defaultValue, help);
   }

   @Override
   public SetValueResult setValue(String value) throws CliException {
      File path = new File(value);
      if (!path.exists())
         throw new CliException(value + " is not a valid path for " + getName());
      return super.setValue(value);   
   }
   
   @Override
   protected String type() {
      return "path";
   }
}
