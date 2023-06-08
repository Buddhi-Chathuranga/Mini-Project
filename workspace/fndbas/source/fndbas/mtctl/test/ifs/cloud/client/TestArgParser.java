package ifs.cloud.client;

import static org.junit.Assert.assertEquals;

import org.junit.Ignore;
import org.junit.Test;

import ifs.cloud.client.cli.Command;
import ifs.cloud.client.cli.Parser;
import ifs.cloud.client.cli.ReturnCode;
import ifs.cloud.client.cli.StringArg;

public class TestArgParser {
   
   @Test
   public void testNoSubCommand() {
      // first arg is command, test command take no args
      String [] args = new String [] {};
      // run should return ReturnCode.NoArgs, sub command expected
      assertEquals(new Parser().run(new Command[] { new SubCommand() }, args), ReturnCode.NoArgs.toInt());
   }
   
   @Test
   public void testSubCommandNoArgs() {
      // first arg is command, test command take no args
      String [] args = new String [] {"subCmd"};
      // run should return ReturnCode.Success
      assertEquals(new Parser().run(new Command[] { new SubCommand() }, args), ReturnCode.Success.toInt());
   }
   
   @Test
   public void testUnknownArgs() {
      // first arg is command, test command take no args
      String [] args = new String [] {"subCmd", "--test", "a"};
      // run should return ReturnCode.Failed as unknown args are passed
      assertEquals(new Parser().run(new Command[] { new SubCommand() }, args), ReturnCode.Failed.toInt());
   }
   
   @Test
   public void testArgsFormat() {
      // first arg is command, test command take no args
      String [] args = new String [] {"subCmd", "--", "testA" };
      // run should return ReturnCode.Failed as arg format is wrong
      assertEquals(new Parser().run(new Command[] { new SubCommand() }, args), ReturnCode.Failed.toInt());
   }
   
   @Test
   public void testSubCommandWithArgs() {
      // first arg is command, test command take no args
      String [] args = new String [] {"testWithArgs", "--arg1", "argValue" };
      // run should return ReturnCode.Success as arg format is wrong
      assertEquals(new Parser().run(new Command[] { new CommandWithArg() }, args), ReturnCode.Success.toInt());
   }
   
   @Test
   public void testSubCommandWithWrongArgs() {
      // first arg is command, test command take no args
      String [] args = new String [] {"testWithArgs", "--arg2", "argValue" };
      // run should return ReturnCode.Failed as arg format is wrong
      assertEquals(new Parser().run(new Command[] { new CommandWithArg() }, args), ReturnCode.Failed.toInt());
   }

   @Ignore
   class SubCommand extends Command {
      SubCommand() {
         super("subCmd");
      }
      
      @Override
      protected String shortDescription() {
         return "test";
      }

      @Override
      protected ReturnCode run() throws Exception {
         return ReturnCode.Success;
      }
   }
   
   @Ignore
   class CommandWithArg extends Command {
      StringArg arg = new StringArg("arg1", "test argument");
      
      CommandWithArg() {
         super("testWithArgs");
         addArg(arg);
      }
      
      @Override
      protected String shortDescription() {
         return "test";
      }

      @Override
      protected ReturnCode run() throws Exception {
         return ReturnCode.Success;
      }
   }
}
