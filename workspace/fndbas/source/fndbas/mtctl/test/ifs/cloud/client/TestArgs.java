package ifs.cloud.client;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;

import org.junit.Ignore;
import org.junit.Test;

import ifs.cloud.client.cli.ArrayArg;
import ifs.cloud.client.cli.ArrayArg.KeyValue;
import ifs.cloud.client.cli.Command;
import ifs.cloud.client.cli.IntArg;
import ifs.cloud.client.cli.Parser;
import ifs.cloud.client.cli.PathArg;
import ifs.cloud.client.cli.ReturnCode;
import ifs.cloud.client.cli.StringArg;

public class TestArgs {

   @Test
   public void testMandatoryArgs() {
      // first arg is command, mandatort strarg is not passed
      String [] args = new String [] {"testArgs", "--intarg", "22"};
      // run should return ReturnCode.Failed, strarg missing
      assertEquals(new Parser().run(new Command[] { new CommandWithArg() }, args), ReturnCode.Failed.toInt());
   }
   
   @Test
   public void testArgs() {
      // all args are given
      String [] args = new String [] {"testArgs", "--strarg", "str", "--intarg", "0"};
      // run should return ReturnCode.Success
      assertEquals(new Parser().run(new Command[] { new CommandWithArg() }, args), ReturnCode.Success.toInt());
   }
   
   @Test
   public void testArgValues() {
      // all args given
      String [] args = new String [] {"testArgs", "--strarg", "XX", "--intarg", "22"};
      assertEquals(new Parser().run(new Command[] { new CommandCheckArg() }, args), ReturnCode.Success.toInt());
   }
   
   @Test
   public void testPathArgsValues() {
      // all args given
      String [] args = new String [] {"testPath", "--pathArg", "C:\\"};
      // path must be valid (in most cases)
      assertEquals(new Parser().run(new Command[] { new CommandWithPathArg() }, args), ReturnCode.Success.toInt());
   }
   
   @Test
   public void testPathArgsWrongValues() {
      // all args given
      String [] args = new String [] {"testPath", "--pathArg", "C:\\thisisainvalidfilepath"};
      // path must not exist (in most cases)
      assertEquals(new Parser().run(new Command[] { new CommandWithPathArg() }, args), ReturnCode.Failed.toInt());
   }
   
   @Test
   public void testOtherArgsValues() {
      String [] args = new String [] {"others", "--arg1", "value1", "--arg2", "value2"};
      assertEquals(new Parser().run(new Command[] { new CommandWithArrayArg() }, args), ReturnCode.Success.toInt());      
   }
   
   @Ignore
   abstract class TestCommand extends Command {
      TestCommand(String cmd) {
         super(cmd);
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
   class CommandWithArg extends TestCommand {
      StringArg strArg = new StringArg("strarg", true, "test string argument");
      IntArg intArg = new IntArg("intarg", true, "test int argument");
      
      CommandWithArg() {
         super("testArgs");
         addArg(strArg);
         addArg(intArg);
      }
   }
   
   @Ignore
   class CommandWithPathArg extends TestCommand {
      PathArg pathArg = new PathArg("patharg", "test int argument");
      
      CommandWithPathArg() {
         super("testPath");
         addArg(pathArg);
      }
   }
   
   @Ignore
   class CommandWithArrayArg extends TestCommand {
      // when the arg name is 'other', it can accept any arg that is not already handled
      ArrayArg arrayArgs = new ArrayArg("other", "Any other arg");
      
      CommandWithArrayArg() {
         super("others");
         addArg(arrayArgs);
      }
      
      @Override
      protected ReturnCode run() throws Exception {
         ArrayList<KeyValue> values = arrayArgs.getValues();
         if (values.size() == 2 && "arg1".compareTo(values.get(0).getName()) == 0 && "value1".compareTo(values.get(0).getValue()) == 0 &&
               "arg2".compareTo(values.get(1).getName()) == 0 && "value2".compareTo(values.get(1).getValue()) == 0)
            return ReturnCode.Success;
         return ReturnCode.Failed;
      }
   }
   
   @Ignore
   class CommandCheckArg extends CommandWithArg {
      @Override
      protected ReturnCode run() throws Exception {
         return 22 == intArg.getValue() && "XX".compareTo(strArg.getValue()) == 0 ? ReturnCode.Success : ReturnCode.Failed;
      }
   }
}
