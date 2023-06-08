package ifs.cloud.client;

import ifs.cloud.client.cli.Command;
import ifs.cloud.client.cli.Parser;
import ifs.cloud.client.cmd.MaintenanceModeCommand;
import ifs.cloud.client.cmd.StartCommand;
import ifs.cloud.client.cmd.StatusCommand;
import ifs.cloud.client.cmd.StopCommand;
import ifs.cloud.client.cmd.WaitCommand;
import ifs.cloud.client.cmd.Dump;

public class Client {
   public static void main(String[] args) {
      Command[] commands = new Command[] { 
            new StartCommand(),
            new StopCommand(),
            new WaitCommand(),
            new StatusCommand(),
            new MaintenanceModeCommand(),
            new Dump()
            };
      System.exit(new Parser().run(commands, args));
   }
}