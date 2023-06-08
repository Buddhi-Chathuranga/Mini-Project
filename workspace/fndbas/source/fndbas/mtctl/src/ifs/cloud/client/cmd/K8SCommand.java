package ifs.cloud.client.cmd;

import java.util.ArrayList;
import java.util.Comparator;

import ifs.cloud.client.cli.ArrayArg;
import ifs.cloud.client.cli.CliException;
import ifs.cloud.client.cli.Command;
import ifs.cloud.client.cli.ReturnCode;
import ifs.cloud.client.cli.StringArg;
import ifs.cloud.client.k8s.Condition;
import ifs.cloud.client.k8s.ContainerStatus;
import ifs.cloud.client.k8s.Deployment;
import ifs.cloud.client.k8s.DeploymentList;
import ifs.cloud.client.k8s.Event;
import ifs.cloud.client.k8s.Events;
import ifs.cloud.client.k8s.Job;
import ifs.cloud.client.k8s.JobList;
import ifs.cloud.client.k8s.KubeCtlCaller;
import ifs.cloud.client.k8s.KubeException;
import ifs.cloud.client.k8s.Pod;
import ifs.cloud.client.k8s.PodList;
import ifs.cloud.client.k8s.PodStatus.PodPhase;
import ifs.cloud.client.logger.Logger;
import ifs.cloud.client.logger.Logger.Level;

abstract class K8SCommand extends Command {
   protected final KubeCtlCaller kubectl;

   protected K8SCommand(String name) {
      super(name);
      ArrayArg kubeOptions = new ArrayArg("other", "any option to kubectl (for help run kubectl options)");
      kubeOptions.setVisible(false);
      addArg(kubeOptions);
      StringArg namespace = new StringArg("namespace", "target namespace (defaults to kubectl default namespace)");
      addArg(namespace);
      this.kubectl = new KubeCtlCaller(kubeOptions, namespace);
   }

   private void sleepOneMinute() {
      try {
         for (int i = 0; i < 12; i++) {
            Logger.logCont(Level.L5, '.');
            Thread.sleep(5000);
         }
      }
      catch (InterruptedException ex) {}
      Logger.logEndCont(Level.L5);
   }

   protected ReturnCode waitForDeploymentReady(int timeout) throws KubeException {
      Logger.logln(Level.L5, "Wait for deployment status");
      // wait
      boolean success = false;
      ArrayList<DeploymentHelper> dlist = null;
      long timeoutAt = System.currentTimeMillis() + (1000 * timeout);
      while (true) {
         Logger.progln(Level.L5, "Check status");
         Logger.progln(Level.L3, "Reading namespace status");
         boolean ok = true;
         dlist = queryDeploymentStatus(refreshDeploymentList(dlist));
         for (int i = 0; i < dlist.size(); i++) {
            ok &= dlist.get(i).isCompleted();
         }
         if (ok) {
            success = true;
            break;
         }
         if (timeoutAt <= System.currentTimeMillis()) {
            break;
         }
         Logger.log(Level.L5, "Waiting");
         sleepOneMinute();
      }
      if (!success)
         Logger.logln(Level.L6, "Time out waiting for pod status.");
      queryFailedDeployments(dlist);
      showSummary(dlist);
      return success ? ReturnCode.Success : CmdReturnCode.Timeout;
   }

   private ArrayList<DeploymentHelper> refreshDeploymentList(ArrayList<DeploymentHelper> dlist) throws KubeException {
      ArrayList<DeploymentHelper> temp = listDeployments();
      if (dlist == null) {
         return temp;
      }
      else {
         /* copy incompleted - refreshed items to original array */
         for (int i = 0; i < temp.size(); i++) {
            DeploymentHelper item = temp.get(i);
            for (int j = 0; j < dlist.size(); j++) {
               if (dlist.get(j).equals(item)) {
                  if (!dlist.get(j).isCompleted()) {
                     dlist.set(j, item);
                  }
                  break;
               }
            }
         }
      }
      return dlist;
   }

   private ArrayList<DeploymentHelper> queryDeploymentStatus(ArrayList<DeploymentHelper> items) throws KubeException {
      int count = items.size(), failed = 0;
      for (int i = 0; i < count; i++) {
         DeploymentHelper item = items.get(i);
         if (!item.isCompleted()) {
            // spec replicas == 0 when deployment was stopped/disabled
            if (item.getSpecReplicaCount() == 0 && item.getStatusReplicaCount() <= 0) {
               item.setCompleted();
            } else
            // if started replica count equals to the requested
            if (item.hasRequiredReplicaCount()) {
               int replicas = item.getStatusReplicaCount();
               Logger.logln(Level.L4);
               Logger.logln(Level.L4, item.getName(), replicas > 0 ? "is ready" : "disabled");
               if (replicas > 0) {
                  // check status of started pods
                  listPodsFor(item);
                  if (queryPodStates(item, false)) {
                     item.setCompleted();
                  }
               }
               else {
                  item.setCompleted();
               }
            }
         }
         if (!item.isCompleted()) {
            failed++;
         }
      }
      if (failed > 0) {
         Logger.logln(Level.L5, failed, "deployments not started");
      }
      return items;
   }

   // return true if all pods have all containers running
   private boolean queryPodStates(DeploymentHelper deploymentHelper, boolean loadEvents) throws KubeException {
      Logger.logln(Level.L4, "Query for pod states of", deploymentHelper.getName());
      int running = 0;
      ArrayList<PodHelper> pods = deploymentHelper.getPods();
      for (int j = 0; j < pods.size(); j++) {
         PodHelper pod = pods.get(j);
         String podName = pod.getName();
         Logger.logln(Level.L4, podName, "started", pod.getStartedTime());
         // containers in each pod, all must be running/ready
         ArrayList<ContainerStatus> statuses = pod.getContainerStatuses();
         int ready = 0, containerCount = statuses == null ? 0 : statuses.size();
         for (int k = 0; k < containerCount; k++) {
            ContainerStatus contStatus = statuses.get(k);
            Logger.logln(Level.L4, podName, contStatus.getName(), "image", contStatus.getImageName());
            Logger.logln(Level.L4, podName, contStatus.getName(), "restarts", contStatus.getRestarts());
            if (!contStatus.isStarted())
               Logger.logln(Level.L3, podName, contStatus, "not started");
            else {
               if (contStatus.isReady())
                  ready++;
               else
                  Logger.logln(Level.L3, podName, contStatus, "not ready");
            }
         }
         pod.setReadyCount(ready);
         pod.setTotalCount(containerCount);
         Logger.logln(Level.L4, podName, ready, "of", containerCount, "running");
         if (ready == containerCount && pod.getPhase() == PodPhase.Running)
            running++;
         if (ready != containerCount) {
            if (loadEvents) {
               listEventsFor(pod);
               ArrayList<Event> events = pod.getEvents();
               for (int k = 0; k < events.size(); k++) {
                  Event event = events.get(k);
                  Logger.logln(Level.L4, podName, "EVENT:", event.getType(), event.getMessage(), "[", event.getTime(), event.getReason(), "]");
               }
            }
         }
      }
      Logger.logln(Level.L1, deploymentHelper);
      return (running >= deploymentHelper.getSpecReplicaCount());
   }

   private boolean queryFailedDeployments(ArrayList<DeploymentHelper> dlist) throws KubeException {
      boolean failed = false;
      if (dlist != null) {
         for (int i = 0; i < dlist.size(); i++) {
            DeploymentHelper deployment = dlist.get(i);
            if (!deployment.isCompleted()) {
               Logger.logln(Level.L4, deployment.getName(), "is not ready");
               ArrayList<Condition> conditions = deployment.getStatusConditions();
               if (conditions != null) {
                  for (int j = 0; j < conditions.size(); j++) {
                     Condition cond = conditions.get(j);
                     if (!cond.getStatus()) {
                        Logger.logln(Level.L3, cond.getReason(), cond.getStatus(), deployment.getName());
                        // get events of failed pods
                        listPodsFor(deployment);
                        queryPodStates(deployment, true);
                        failed = true;
                     }
                  }
               }
            }
         }
      }
      return failed;
   }

   ReturnCode listNamespaceStatus() throws KubeException {
      Logger.progln(Level.L3, "Reading namespace status");
      ArrayList<DeploymentHelper> dlist = queryDeploymentStatus(listDeployments());
      boolean failed = queryFailedDeployments(dlist);
      showSummary(dlist);
      return failed ? CmdReturnCode.PartiallyFailed : ReturnCode.Success;
   }

   private void showSummary(ArrayList<DeploymentHelper> dlist) {
      if (dlist != null && dlist.size() > 0) {
         dlist.sort(new Comparator<DeploymentHelper>() {
            @Override
            public int compare(DeploymentHelper depl1, DeploymentHelper depl2) {
               int u1 = depl1.getStatus().uid();
               int u2 = depl2.getStatus().uid();
               if (u1 == u2) {
                  return depl1.getName().compareTo(depl2.getName());
               }
               return u1 - u2;
            }
         });
         new SummaryPrinter(dlist).print();
      }
   }

   protected boolean scale(Deployment deployment, int scale) throws CliException {
      Logger.logln(Level.L3, "Current available replicas", deployment.getStatus().getAvailableReplicas());
      int defReplicas = deployment.getAnnotations().getDefaultReplicas();
      if (defReplicas == -1) {
         // annotation does not exists
         throw new CliException(deployment.getMetadata().getName() + " default replica count is not set.");
      }
      if (scale == -1)
         scale = defReplicas;
      Logger.logln(Level.L3, "Requested replica count", scale);
      if (scale == deployment.getStatus().getAvailableReplicas()) {
         Logger.logln(Level.L6, deployment, "not scaled");
         return false;
      }
      // kubectl scale deployment ifsapp-proxy --replicas=n
      String name = deployment.getMetadata().getName();
      Logger.progln(Level.L3, "Update", name);
      if (kubectl.exec("scale", "deployment", name, "--replicas=" + scale) == 0) {
         Logger.logln(Level.L5, kubectl.getOut());
         return true;
      }
      throw new CliException(kubectl.getErr());
   }

   protected ArrayList<JobsHelper> listJobs() throws KubeException {
      Logger.progln(Level.L3, "Fetch jobs");
      ArrayList<JobsHelper> jobs = new ArrayList<JobsHelper>();
      ArrayList<Job> items = ((JobList)kubectl.fetch(new JobList())).getItems();
      int count = items.size();
      for (int i = 0; i < count; i++) {
         jobs.add(new JobsHelper(items.get(i)));
      }
      return jobs;
   }
   
   protected ArrayList<DeploymentHelper> listDeployments() throws KubeException {
      Logger.progln(Level.L3, "Fetch deployments");
      ArrayList<DeploymentHelper> depl = new ArrayList<DeploymentHelper>();
      DeploymentList dlist = (DeploymentList) kubectl.fetch(new DeploymentList());
      ArrayList<Deployment> items = dlist.getItems();
      int count = items.size();
      for (int i = 0; i < count; i++) {
         depl.add(new DeploymentHelper(items.get(i)));
      }
      return depl;
   }

   protected ArrayList<PodHelper> listPodsFor(K8SHelper helper) throws KubeException {
      Logger.progln(Level.L3, "Fetch pods for", helper);
      ArrayList<PodHelper> pods = new ArrayList<>();
      ArrayList<Pod> items = ((PodList) kubectl.fetch(new PodList(helper.getName()))).getItems();
      int count = items.size();
      for (int i = 0; i < count; i++) {
         pods.add(new PodHelper(items.get(i)));
      }
      helper.setPods(pods);
      return pods;
   }

   private void listEventsFor(PodHelper pod) throws KubeException {
      Logger.logln(Level.L3, "Fetch pod events...");
      pod.setEvents(((Events) kubectl.fetch(new Events(pod.getName()))).getItems());
   }
   
   protected void showConfig() throws KubeException {
      ArrayList<String> cmd = new ArrayList<>();
      cmd.add("config");
      cmd.add("view");
      cmd.add("--minify");
      if (kubectl.exec(cmd, true) != 0) {
         throw new KubeException(kubectl.getErr());
      }
   }  
}