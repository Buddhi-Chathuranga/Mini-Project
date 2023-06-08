package ifs.cloud.client.cli;

import java.util.ArrayList;
import java.util.Comparator;

import ifs.cloud.client.cli.Command.ParseResult;
import ifs.cloud.client.cli.SimpleTabPrinter.TextRow;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public class Parser {
   public Parser() {}

   public int run(Command[] commands, String[] args) {
      Logger.logln(Level.L9, "IFS Cloud Applications - Middletier Controller");
      try {
         if (args.length >= 1) {
            Logger.logln(Level.L1, "args:", args);
            String subCmd = args[0];
            if (isUsageHelp(commands, subCmd))
               return ReturnCode.Success.toInt();
            for (Command cmd : commands) {
               if (cmd.equals(subCmd)) {
                  Logger.logln(Level.L1, "sub command impl:", cmd.getClass().getSimpleName());
                  Logger.logln(Level.L9, cmd);
                  return cmd.run(args).toInt();
               }
            }
            // new Usage(commands).run();
         }
         ParseResult.invalidArgs(args).showErrors();
         return ReturnCode.NoArgs.toInt();
      }
      catch (Exception ex) {
         Logger.logln(Level.L7, "ERROR");
         Logger.logln(Level.L7, Logger.toMessage(ex));
         Logger.logln(Level.L1, ex);
         return ReturnCode.Exception.toInt();
      }
   }

   private boolean isUsageHelp(Command[] commands, String cmd) throws Exception {
      Usage usage = new Usage(commands);
      if (usage.equals(cmd)) {
         usage.run();
         return true;
      }
      return false;
   }

   private class Usage extends Command {
      private Command[] commands;

      protected Usage(Command[] commands) {
         super("usage");
         this.commands = commands;
      }

      @Override
      protected ReturnCode run() throws Exception {
         Logger.logln(Level.L9, "USAGE");
         Logger.logln(Level.L9, " mtctl sub-command <options>");
         Logger.logln(Level.L9, "  sub-commands");
         
         SimpleTabPrinter stp = new SimpleTabPrinter(2, 1) {
            public void printLn() {
               Logger.logln(Level.L9);
            };
            
            public void printLn(String text) {
               Logger.logln(Level.L9, text);
            };
         };
         for (int i = 0; i < commands.length; i++) {
            TextRow row = stp.createRow(0);
            row.setIndent(2);
            row.add(commands[i].getName(), commands[i].shortDescription());
            ArrayList<Arg> args = commands[i].getArgs();
            args.sort(new Comparator<Arg>() {
               @Override
               public int compare(Arg o1, Arg o2) {
                  return o1.getName().compareTo(o2.getName());
               }
            });
            row = stp.createRow(1);
            row.setIndent(2);
            row.leftAlignWith(0, 1); // align to column 1 of 0 level rows
            row.add("options");
            for (int j = 0; j < args.size(); j++) {
               Arg a = args.get(j);
               if (a.isVisible()) {
                  row = stp.createRow(1);
                  row.setIndent(2);
                  row.leftAlignWith(0, 1); // align to column 1 of 0 level rows
                  row.add(a.getName(), a.getType(), a.shortDescription());
               }
            }
         }
         stp.print();
         return null;
      }

      @Override
      public boolean equals(Object obj) {
         if (!super.equals(obj))
            return "help".equals(obj);
         return true;
      }

      @Override
      protected String shortDescription() {
         return "usage";
      }
   }
}
