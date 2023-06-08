package ifs.cloud.client;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import java.util.ArrayList;

import org.junit.Ignore;
import org.junit.Test;

import ifs.cloud.client.cli.ArrayArg;
import ifs.cloud.client.cli.StringArg;
import ifs.cloud.client.k8s.Deployment;
import ifs.cloud.client.k8s.DeploymentList;
import ifs.cloud.client.k8s.Event;
import ifs.cloud.client.k8s.Events;
import ifs.cloud.client.k8s.Ingress;
import ifs.cloud.client.k8s.IngressList;
import ifs.cloud.client.k8s.KubeCtlCaller;
import ifs.cloud.client.k8s.KubeException;
import ifs.cloud.client.k8s.Pod;
import ifs.cloud.client.k8s.PodList;

public class TestK8S {
   
   @Test
   public void testExecNonZero() {
      try {
         // should throw exception with MOCK_ERROR in message
         new ExecErrorKubeCtlCaller().fetch(new DeploymentList());
      }
      catch (KubeException e) {
         assertEquals(e.getMessage(), "MOCK_ERROR");
      }
   }

   @Ignore
   class ExecErrorKubeCtlCaller extends MockKubeCtlCaller {
      
      ExecErrorKubeCtlCaller() {}
      
      @Override
      public int exec(ArrayList<String> commands) {
         return 1;
      }
      
      @Override
      public String getErr() {
         return "MOCK_ERROR";
      }
   };
   
   @Test
   public void testListDeployments() {
      try {
         DeplListKubeCtlCaller ctlcaller = new DeplListKubeCtlCaller();
         ArrayList<Deployment> depls = ((DeploymentList) ctlcaller.fetch(new DeploymentList())).getItems();
         // should return 2 deployments from mock class
         assertEquals(depls.size(), 2);
         Deployment depl = depls.get(1);
         assertEquals(depl.getMetadata().getName(), "ifsapp-proxy");
         assertEquals(depl.getStatus().getConditions().get(1).getReason(), "NewReplicaSetAvailable");
         assertEquals(depl.getStatus().getConditions().get(1).getType(), "Progressing");
      }
      catch (KubeException e) {
         fail(e.toString());
      }
   }

   @Ignore
   class MockKubeCtlCaller extends KubeCtlCaller {
      public MockKubeCtlCaller() {
         super(new ArrayArg("other", ""), new StringArg("ns", ""));
      }
   }
   
   @Ignore
   class DeplListKubeCtlCaller extends MockKubeCtlCaller {

      public DeplListKubeCtlCaller() {}

      @Override
      public int exec(ArrayList<String> commands) {
         // validate incoming commands
         assertEquals(commands.get(0), "get");
         assertEquals(commands.get(1), "deployments");
         assertEquals(commands.get(2), "-o");
         assertEquals(commands.get(3).startsWith("custom-columns="), true);
         return 0;
      }

      @Override
      public String getOut() {
         // mocked output as from kubectl (v1.20)
         String out = "C0                           C1          C2    C3       C4       C5                                                    C6            C7\r\n"
                    + "ifsapp-iam                   uppelktst   1     <none>   1        MinimumReplicasUnavailable,ProgressDeadlineExceeded   False,False   Available,Progressing\r\n"
                    + "ifsapp-proxy                 uppelktst   1     1        1        MinimumReplicasAvailable,NewReplicaSetAvailable       True,True     Available,Progressing\r\n";
         return out;
      }
   }
   
   @Test
   public void testIngress() {
      try {
         IngressKubeCtlCaller ctlcaller = new IngressKubeCtlCaller();
         ArrayList<Ingress> ingresses = ((IngressList) ctlcaller.fetch(new IngressList())).getItems();
         // should return 2 ingresses from mock class
         assertEquals(ingresses.size(), 2);
         Ingress ing = ingresses.get(1);
         assertEquals(ing.getMetadata().getName(), "ifs-sticky-ingress");
      }
      catch (KubeException e) {
         fail(e.toString());
      }
   }
   
   @Ignore
   class IngressKubeCtlCaller extends MockKubeCtlCaller {

      public IngressKubeCtlCaller() {}
      
      @Override
      public int exec(ArrayList<String> commands) {
         assertEquals(commands.get(0), "get");
         assertEquals(commands.get(1), "ingress");
         assertEquals(commands.get(2), "-o");
         assertEquals(commands.get(3).startsWith("custom-columns="), true);
         return 0;
      }
      
      @Override
      public String getOut() {
         String out = "C0                      C1\r\n" +
                      "ifs-stateless-ingress   uppelktst\r\n" +
                      "ifs-sticky-ingress      uppelktst";
         return out;
      }
   }

   @Test
   public void testEvent() {
      try {
         EventsKubeCtlCaller ctlcaller = new EventsKubeCtlCaller();
         // events use field-selector
         ArrayList<Event> events = ((Events) ctlcaller.fetch(new Events("ifsapp-odata-5bfbf67b57-7hhrh"))).getItems();
         // should return 5 events from mock class
         assertEquals(events.size(), 5);
         assertEquals(events.get(1).getType(), "Warning");
         assertEquals(events.get(3).getCount(), 83);
         assertEquals(events.get(4).getTime().getTime(), 1631166870000L);
      }
      catch (KubeException e) {
         fail(e.toString());
      }
   }
   
   @Ignore
   class EventsKubeCtlCaller extends MockKubeCtlCaller {
      public EventsKubeCtlCaller() {}
      
      @Override
      public int exec(ArrayList<String> commands) {
         assertEquals(commands.get(0), "get");
         assertEquals(commands.get(1), "events");
         assertEquals(commands.get(2), "--field-selector");
         assertEquals(commands.get(3), "involvedObject.name=ifsapp-odata-5bfbf67b57-7hhrh");
         assertEquals(commands.get(4), "-o");
         assertEquals(commands.get(5).startsWith("custom-columns="), true);
         return 0;
      }
      
      @Override
      public String getOut() {
         String out = "C0     C1        C2          C3                     C4       C5                                                                                                               C6\r\n"
                    + "272    Normal    Pulled      2021-09-09T05:38:35Z   <none>   Container image \"rnddockerdev.azurecr.io/ifs/ifsapp-odata:21.2E.0.20210811063620.0\" already present on machine   <none>\r\n"
                    + "5958   Warning   Unhealthy   2021-09-09T06:04:30Z   <none>   (combined from similar events): Startup probe failed: Readiness Check Status - DOWN\r\n"
                    + "  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\r\n"
                    + "                                 Dload  Upload   Total   Spent    Left  Speed\r\n"
                    + "\r\n"
                    + "  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r\n"
                    + "100   101  100   101    0     0    294      0 --:--:-- --:--:-- --:--:--   294\r\n"
                    + "100   101  100   101    0     0    294      0 --:--:-- --:--:-- --:--:--   294\r\n"
                    + "       <none>\r\n"
                    + "381    Warning   Unhealthy   2021-09-09T05:24:30Z   <none>   Startup probe failed: Readiness Check Status - DOWN\r\n"
                    + "  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\r\n"
                    + "                                 Dload  Upload   Total   Spent    Left  Speed\r\n"
                    + "\r\n"
                    + "  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r\n"
                    + "100   101  100   101    0     0    282      0 --:--:-- --:--:-- --:--:--   282\r\n"
                    + "100   101  100   101    0     0    282      0 --:--:-- --:--:-- --:--:--   282\r\n"
                    + "       <none>\r\n"
                    + "83     Warning   Unhealthy   2021-09-09T05:14:30Z   <none>   Startup probe failed: Readiness Check Status - DOWN\r\n"
                    + "  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\r\n"
                    + "                                 Dload  Upload   Total   Spent    Left  Speed\r\n"
                    + "\r\n"
                    + "  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r\n"
                    + "100   101  100   101    0     0    281      0 --:--:-- --:--:-- --:--:--   281\r\n"
                    + "100   101  100   101    0     0    281      0 --:--:-- --:--:-- --:--:--   281\r\n"
                    + "       <none>\r\n"
                    + "2      Warning   Unhealthy   2021-09-09T05:54:30Z   <none>   Startup probe failed: Readiness Check Status - DOWN\r\n"
                    + "  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\r\n"
                    + "                                 Dload  Upload   Total   Spent    Left  Speed\r\n"
                    + "\r\n"
                    + "  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r\n"
                    + "100   101  100   101    0     0    291      0 --:--:-- --:--:-- --:--:--   291\r\n"
                    + "100   101  100   101    0     0    291      0 --:--:-- --:--:-- --:--:--   291\r\n"
                    + "       <none>";
         return out;
      }
   }
   
   @Test
   public void testListPods() {
      try {
         PodListKubeCtlCaller ctlcaller = new PodListKubeCtlCaller();
         ArrayList<Pod> pods = ((PodList) ctlcaller.fetch(new PodList("ifs-forecast"))).getItems();
         // should return pod from mock class
         assertEquals(pods.size(), 1);
         assertEquals(pods.get(0).getStatus().getPhase(), "Pending");
         assertEquals(pods.get(0).getStatus().getStartedTime(), null);
      }
      catch (KubeException e) {
         fail(e.toString());
      }
   }
   
   @Ignore
   class PodListKubeCtlCaller extends MockKubeCtlCaller {

      public PodListKubeCtlCaller() {}

      @Override
      public int exec(ArrayList<String> commands) {
         // validate incoming commands
         assertEquals(commands.get(0), "get");
         assertEquals(commands.get(1), "pods");
         assertEquals(commands.get(2), "--selector=app=ifs-forecast");
         assertEquals(commands.get(3), "-o");
         assertEquals(commands.get(4).startsWith("custom-columns="), true);
         return 0;
      }

      @Override
      public String getOut() {
         // mocked output as from kubectl (v1.20)
         String out = "C0                              C1                  C2       C3        C4       C5       C6       C7       C8       C9       C10\r\n"
                    + "ifs-forecast-56b7899d5b-j8krq   appf-ci-prod-22r1   <none>   Pending   <none>   <none>   <none>   <none>   <none>   <none>   <none>";
         return out;
      }
   }
}
