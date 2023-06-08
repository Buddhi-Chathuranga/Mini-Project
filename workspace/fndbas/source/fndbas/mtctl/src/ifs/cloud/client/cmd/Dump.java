package ifs.cloud.client.cmd;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import ifs.cloud.client.cli.CliException;
import ifs.cloud.client.cli.ReturnCode;
import ifs.cloud.client.cli.StringArg;
import ifs.cloud.client.k8s.KubeException;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

public class Dump extends K8SCommand {
   private final StringArg dumpPath;
   
   public Dump() {
      super("dump");
      dumpPath = new StringArg("dumppath", "./", "path, location for the mtctl_dump folder, default - current location");
      addArg(dumpPath);
   }

   @Override
   protected final ReturnCode run() throws Exception {
      showConfig();
      File path = createDumpPath(dumpPath.getValue());
      if (path == null)
         return ReturnCode.Failed;
      return dumpDescriptionsAndLogs(path);
   }

   @Override
   protected String shortDescription() {
      return "Dump descriptions and logs";
   }
   
   private File createDumpPath(String path) {
      File file = new File(path);
      file.mkdirs();
      if (!file.exists()) {
         Logger.logln(Logger.Level.L7, "Creation of folder " + file.toString() + " failed.");
         return null;
      }     
      return file;
   }    

   private void saveContents(final String content, final File target, final String... files) {
      File f = target;
      for (int i = 0; i < files.length; i++) {
         f = new File(f, files[i]);
      }
      if (f.getParentFile() != null) {
         f.getParentFile().mkdirs();
      }
      try (Writer writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f), "utf-8"))) {
         writer.write(content);
      } catch (IOException ex) {
         Logger.logln(Level.L7, "Creation of file", f.getAbsolutePath(), "failed.", ex);
      }      
   }
   
   private String getTimestamp() {
      Format formatter;
      formatter = new SimpleDateFormat("yyyyMMdd_HHmmss");
      java.util.Date date = new java.util.Date();
      return formatter.format(date);
   } 
   
   private void dumpKubeCmdResults(StringBuilder errors, File target, String file, String...commands) {
      Logger.progln(Level.L3, "Execute", commands);
      if (kubectl.exec(commands) == 0) {
         saveContents(kubectl.getOut(), target, file);
      } else {
         collectErrors(errors, commands);
      }
   }
   
   private void dumpKubeCmdResultsForSystemNamespace(StringBuilder errors, File target, String file, String...commands) {
      Logger.progln(Level.L3, "Execute", commands);
      ArrayList<String> cmds = new ArrayList<>();
      for (String a : commands) {
         cmds.add(a);
      }
      cmds.add("-n");
      cmds.add("kube-system");
      if (kubectl.exec(cmds, true) == 0) {
         saveContents(kubectl.getOut(), target, file);
      } else {
         collectErrors(errors, commands);
      }
   }
   
   ReturnCode dumpDescriptionsAndLogs(File dumpPath) throws CliException, KubeException {
      StringBuilder errors = new StringBuilder();
      String ts = getTimestamp();
      
      Logger.progln(Level.L5, "Reading namespace for jobs");
      ArrayList<K8SHelper> helpers = new ArrayList<>();
      helpers.addAll(listJobs());
      
      Logger.progln(Level.L5, "Reading namespace for deployments");
      helpers.addAll(listDeployments());
      
      File target = new File(new File(dumpPath, (helpers.size() > 0 ? helpers.get(0).getNamespace() + "_dump" : "namespace_dump")), ts);

      dumpKubeCmdResults(errors, target, "top-pods.txt", "top", "pods", "-A");
      dumpKubeCmdResults(errors, target, "top-nodes.txt", "top", "nodes");
      dumpKubeCmdResults(errors, target, "all.txt", "get", "all");
      dumpKubeCmdResults(errors, target, "all-pods.txt", "get", "pods", "-A", "-o", "wide");
      dumpKubeCmdResults(errors, target, "secrets.txt", "get", "secrets");
      dumpKubeCmdResults(errors, target, "ingress.txt", "get", "ingress");
      dumpKubeCmdResults(errors, target, "ifs-sticky-ingress.yaml", "get", "ingress", "ifs-sticky-ingress", "-o", "yaml");
      dumpKubeCmdResultsForSystemNamespace(errors, target, "coredns.yaml", "get", "cm", "coredns", "-o", "yaml");
      dumpKubeCmdResultsForSystemNamespace(errors, target, "coredns.log", "logs", "deploy/coredns");

      for (int i = 0; i < helpers.size(); i++) {
         K8SHelper item = helpers.get(i);
         Logger.progln(Level.L5, "Description for", item.getName());
         if (kubectl.exec("describe", item.getKind(), item.getName()) == 0) {
            saveContents(kubectl.getOut(), target, item.getKind(), "descriptions", item.getName() + ".txt");
         } else {
            collectErrors(errors, "describe", item.getName());
         }
         if (item instanceof DeploymentHelper) {
            if (kubectl.exec("logs", "deploy/" + item.getName(), "-c", "linkerd-proxy") == 0) {
               Logger.progln(Level.L5, "Linkerd logs for" + item.getName());
               saveContents(kubectl.getOut(), target, item.getKind(), "linkerd_logs", item.getName() + ".log");
            } else {
               collectErrors(errors, "linkerd", "logs", item.getName());
            }
         }
      } 
      
      Logger.progln(Level.L5, "Reading namespace for pods");
      File podsOutput = new File(target, "pods");
      for (int i = 0; i < helpers.size(); i++) {
         K8SHelper item = helpers.get(i);
         listPodsFor(item);
         ArrayList<PodHelper> pods = item.getPods();
         if (pods != null) {
            for (int j = 0; j < pods.size(); j++) {
               PodHelper pod = pods.get(j);
               if (kubectl.exec("describe", "pod", pod.getName()) == 0) {
                  Logger.progln(Level.L5, "Description for pod " + pod.getName());
                  saveContents(kubectl.getOut(), podsOutput, "descriptions", pod.getName() + ".txt");
               } else {
                  collectErrors(errors, "describe", pod.getName());
               }
               if (kubectl.exec("logs", pod.getName(), "-c", item.getName()) == 0) {
                  Logger.progln(Level.L5, "Log for pod " + pod.getName());
                  saveContents(kubectl.getOut(), podsOutput, "logs", pod.getName() + ".log");
               } else {
                  collectErrors(errors, pod.getName(), "logs");
               }     
               if (kubectl.exec("logs", pod.getName(), "-c", item.getName(), "-p") == 0) {
                  Logger.progln(Level.L5, "Pre log for pod " + pod.getName());
                  saveContents(kubectl.getOut(), podsOutput, "logs", pod.getName() + "_pre.log");
               } else {
                  collectErrors(errors, pod.getName(), "logs");
               }                 
            }
         }
      }
      if (errors.length() > 0) {
         saveContents(errors.toString(), target, "k8s-errors.log");
      }
      return ReturnCode.Success;
   }

   private void collectErrors(StringBuilder errors, String... title) {
      for (int i = 0; i < title.length; i++) {
         errors.append(title[i]).append(' ');
      }
      errors.append("\n");
      errors.append(kubectl.getOut()).append("\n");
      errors.append(kubectl.getErr()).append("\n").append("\n");
   }
}
