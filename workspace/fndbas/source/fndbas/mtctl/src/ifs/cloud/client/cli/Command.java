package ifs.cloud.client.cli;

import java.util.ArrayList;

import ifs.cloud.client.cli.Arg.SetValueResult;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public abstract class Command {

   private final String name;

   private final ArrayList<Arg> args = new ArrayList<>();
   private final StringArg logs = new StringArg("v", "verbose level");

   protected abstract ReturnCode run() throws Exception;

   protected abstract String shortDescription();
   
   protected Command(String name) {
      this.name = name;
      addArg(logs);
      logs.setVisible(false);
   }

   String getName() {
      return name;
   }
   
   ArrayList<Arg> getArgs() {
      return args;
   }

   @Override
   public String toString() {
      return shortDescription();
   }
   
   @Override
   public boolean equals(Object obj) {
      if (obj instanceof String)
         return name.equals(obj);
      return super.equals(obj);
   }

   public void addArg(Arg arg) {
      args.add(arg);
   }

   final ReturnCode run(String[] args) throws Exception {
      ParseResult pr = parseArgs(args);
      if (pr.failed()) {
         pr.showErrors();
         return ReturnCode.Failed;
      }
      Logger.setLogLevel(logs());
      return run();
   }

   private ParseResult parseArgs(String[] args) {
      ParseResult pr = new ParseResult();
      for (int i = 1; i < args.length; i++) {
         String arg = args[i];
         if (arg.startsWith("--")) {
            arg = arg.substring(2);
         }
         else if (arg.startsWith("/") || arg.startsWith("-")) {
            arg = arg.substring(1);
         }
         else {
            pr.exceptions.add(new Exception("Argument format is invalid (" + arg + ")."));
            return pr;
         }
         arg = arg.trim();
         if (arg.length() == 0) {
            pr.exceptions.add(new Exception("Argument syntax error. (pos:" + i + ")."));
            return pr;
         }
         int sep = arg.indexOf("=");
         String value = null;
         if (sep > -1) {
            value = arg.substring(sep + 1);
            arg = arg.substring(0, sep);
         }
         else {
            if (i < args.length - 1) {
               value = args[i + 1];
               i++;
            }
         }
         try {
            switch (setArgValue(arg, value)) {
            case notfound:
               pr.unknowns.add(arg);
               break;
            case accepted:
               break;
            case ignored:
               if (sep < 0 && value != null && i <= args.length - 1)
                  i--; // sep >= 0 when arg was like name=value
               break;
            }
         }
         catch (CliException ex) {
            pr.exceptions.add(ex);
         }
      }

      int argsCount = this.args.size();
      for (int j = 0; j < argsCount; j++) {
         Arg argument = this.args.get(j);
         if (!argument.validate()) {
            pr.missingMandatory.add(argument);
         }
      }
      return pr;
   }

   private SetValueResult setArgValue(String name, String value) throws CliException {
      int argsCount = this.args.size();
      for (int j = 0; j < argsCount; j++) {
         Arg argument = this.args.get(j);
         if (argument.equals(name)) {
            return argument.setValue(value);
         }
      }
      // command can take any arbitrary option 
      for (int j = 0; j < argsCount; j++) {
         Arg argument = this.args.get(j);
         if (argument.equals("other")) {
            return ((ArrayArg)argument).setValue(name, value);
         }
      }
      return SetValueResult.notfound;
   }

   public Level logs() {
      if (logs.IsSet()) {
         String l = logs.getValue().toUpperCase();
         if (l.compareTo("1") >= 0 && l.compareTo("9") <= 0) 
            l = "L" + l;
         return Logger.Level.valueOf(l);
      }
      return Logger.getLogLevel();
   }

   static class ParseResult {
      ArrayList<Arg> missingMandatory = new ArrayList<>();
      ArrayList<String> unknowns = new ArrayList<>();
      ArrayList<Throwable> exceptions = new ArrayList<>();

      boolean invalidArgs = false;

      boolean failed() {
         return invalidArgs || missingMandatory.size() > 0 || unknowns.size() > 0 || exceptions.size() > 0;
      }

      static ParseResult invalidArgs(String [] cmd) {
         Logger.logln(Level.L1, "unknown sub command");
         ParseResult pr = new ParseResult();
         pr.invalidArgs = true;
         for (int i = 0; i < cmd.length; i++) {
            pr.unknowns.add(cmd[i]);
         }
         return pr;
      }

      public void showErrors() {
         Logger.logln(Level.L7, "PARAMETER ERROR");
         if (invalidArgs)
            Logger.logln(Level.L7, "Invalid sub command.");
         for (int i = 0; i < exceptions.size(); i++) {
            Logger.logln(Level.L7, exceptions.get(i).getMessage());
         }
         for (int i = 0; i < missingMandatory.size(); i++) {
            Logger.logln(Level.L7, "Argument", "'" + missingMandatory.get(i).getName() + "'", "requires a value.");
         }
         for (int i = 0; i < unknowns.size(); i++) {
            Logger.logln(Level.L7, "Argument", "'" + unknowns.get(i) + "'", "is not valid for this command.");
         }
      }
   }
}
