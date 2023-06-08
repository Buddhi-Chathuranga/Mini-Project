package ifs.cloud.client.k8s;

import java.util.ArrayList;

import ifs.cloud.client.cli.ArrayArg;
import ifs.cloud.client.cli.ArrayArg.KeyValue;
import ifs.cloud.client.cli.StringArg;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public class KubeCtlCaller {

   private final StringArg namespace;
   private final ArrayArg kubeOptions;
         
   private int exitCode;
   private String out;
   private String err;

   public KubeCtlCaller(ArrayArg kubeOptions, StringArg namespace) {
      this.namespace = namespace;
      this.kubeOptions = kubeOptions;
   }

   public final ResourceBase fetch(ResourceBase resource) throws KubeException {
      resource.fetch(this);
      Logger.logln(Level.L2, resource);
      return resource;
   }

   private ArrayList<String> prepareArgs(ArrayList<String> args, boolean dontAddExtraArgs) {
      ArrayList<String> commands = new ArrayList<>();
      commands.add("kubectl");
      if (!dontAddExtraArgs) {
         if (kubeOptions.IsSet()) {
            ArrayList<KeyValue> otherOptions = kubeOptions.getValues();
            for (int i = 0; i < otherOptions.size(); i++) {
               KeyValue kv = otherOptions.get(i);
               String name = kv.getName();
               name = (name.length() == 1) ? "-" + name : "--" + name;
               commands.add(name);
               String value = kv.getValue();
               if (value != null)
                  commands.add(value);
            }
         }
      }
      commands.addAll(args);
      if (!dontAddExtraArgs && namespace.IsSet()) {
         commands.add("-n");
         commands.add(namespace.getValue());
      }
      return commands;
   }
   
   public int exec(String ...commands) {
      ArrayList<String> cmds = new ArrayList<>();
      for (String a : commands) {
         cmds.add(a);
      }
      return exec(cmds);
   }
   
   public int exec(ArrayList<String> commands, boolean dontAddExtraArgs) {
      commands = prepareArgs(commands, dontAddExtraArgs);
      Logger.logln(Level.L1, "execute", commands);
      ProcessExecuter ea = new ProcessExecuter(commands);
      this.exitCode = ea.run(true);
      Logger.logln(Level.L1, "execute", "exitcode:", this.exitCode);
      this.out = trim(ea.getOutput(false));
      Logger.logln(Level.L1, "execute", "out:", this.out);
      this.err = trim(ea.getError(false));
      Logger.logln(Level.L1, "execute", "err:", this.err);
      return this.exitCode;      
   }
   
   public int exec(ArrayList<String> commands) {
      return exec(commands, false);
   }

   private String trim(String str) {
      return str == null ? null : str.trim();
   }

   public String getOut() {
      return out;
   }

   public String getErr() {
      return err;
   }
}
