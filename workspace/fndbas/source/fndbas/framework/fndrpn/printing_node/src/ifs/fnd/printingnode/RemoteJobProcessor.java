/*
 * RemoteJobProcessor.java
 * 
 * Modified:
 *    DDESLK  2019-02-07     - IFS Print Agent java multithreading support and crash log improvements (Bug#144941)
 *    MABALK  2019-10-10  - Error message of 'Manual decision needed' of the in Print Agent. (DUXZREP-178)
 */
package ifs.fnd.printingnode;

import ifs.client.application.remoteprintingnode.PrintJobHandler;
import ifs.client.application.remoteprintingnode.PrintJobHandlerFactory;
import ifs.fnd.ap.ManualDecision;
import ifs.fnd.ap.ManualDecisionCollection;
import ifs.fnd.ap.ManualDecisionException;
import ifs.fnd.base.IfsException;
import ifs.fnd.log.LogMgr;
import ifs.fnd.log.Logger;
import ifs.fnd.record.FndNumber;
import ifs.fnd.record.FndText;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 *
 * @author dasvse
 */
public class RemoteJobProcessor extends Thread {

   PrintJobHandler pjHandler;
   String version;
   String printParamsConfigFile;
   String printerConfFileDir;
   int pollTime;
   String nodeName;
   RemotePrintingNode node;
   Thread parentThread;

   boolean crashedJobs;

   public RemoteJobProcessor(String vers, String confFile, RemotePrintingNode node, boolean crashedJobs) throws IfsException {
      pjHandler = PrintJobHandlerFactory.getHandler();
      version = vers;
      printParamsConfigFile = confFile;
      printerConfFileDir = node.printerConfFileDir;
      pollTime = node.pollTime;
      nodeName = node.getName();
      this.node = node;
      this.crashedJobs = crashedJobs;
   }

   public void run() {
      Logger log = LogMgr.getFrameworkLogger();
      try {
         node.initJavaAccessProviderThread();
         if (this.crashedJobs) {
            getCrashedJobs();
         } else {
            if (log.debug) {
               log.debug("Getting remote job.");
            }
            int jobId = -1;
            String errMsg = null;
            OldRemoteJob oldJob = null;
            RemoteJob job = null;

            if (version != null && version.equalsIgnoreCase("8.1")) {
               oldJob = getOldRemoteJob();
               if (oldJob != null) {
                  try {
                     jobId = oldJob.getId();
                     if (log.trace) {
                        log.trace("Found job " + "[jobId=" + oldJob.getId() + " printerId=" + oldJob.getPrinterId() + "]");
                     }

                     if (!this.crashedJobs) {
                        synchronized (this) {
                           this.notify(); // Will wake up lock.wait()
                           this.node.oldJobs.add(oldJob);

                        }
                     }

                     errMsg = oldJob.perform();

                     //node.setOldRemoteJob(oldJob);
                     if (!this.crashedJobs) {
                        synchronized (this) {
                           if (errMsg == null) {
                              this.node.oldJobs.remove(oldJob);
                           }
                        }
                     }

                  } catch (Exception ex) {
                     errMsg = "ERROR jobId=" + job.getId() + " " + ex.getMessage();
                  }
               }
            } else {
               job = getRemoteJob(this.printParamsConfigFile, this.printerConfFileDir);

               if (job != null) {
                  try {
                     jobId = job.getId();
                     if (log.trace) {
                        log.trace("Found job " + "[jobId=" + job.getId() + " printerId=" + job.getPrinterId() + "]");
                     }
                     synchronized (this) {
                        this.notify(); // Will wake up lock.wait()
                        this.node.Jobs.add(job);
                     }
                     errMsg = job.perform();

                     synchronized (this) {
                        if (errMsg == null) {
                           this.node.Jobs.remove(job);
                        }
                     }

                  } catch (Exception ex) {
                     // catch all the Exception which could get escape
                     errMsg = "ERROR jobId=" + job.getId() + " " + ex.getCause().getMessage();
                     log.debug(errMsg);
                  }
               }
            }
            if (job != null || oldJob != null) {
               if (errMsg != null) {
                  pjHandler.abortJob(jobId, errMsg);
               } else {

                  synchronized (this) {

                     File[] crashFileList = getFileList(String.valueOf(jobId));

                     for (File file : crashFileList) {
                        file.delete();
                     }

                     File logFile = new File(node.crashedDir + File.separator + node.currentLogFile);

                     FileWriter fw = new FileWriter(logFile, true);
                     String line = "";
                     ArrayList<String> lines = new ArrayList<String>();
                     BufferedReader reader = new BufferedReader(new FileReader(logFile));
                     if (logFile.exists()) {

                        FileReader fr = new FileReader(logFile);
                        BufferedReader br = new BufferedReader(fr);
                        String ch;
                        List<String> tmp = new CopyOnWriteArrayList<String>();
                        do {
                           ch = br.readLine();
                           if (ch != null) {
                              tmp.add(ch);
                           }

                        } while (ch != null);

                        Collections.reverse(tmp);

                        for (String st : tmp) {
                           if (st != null) {
                              String lineArr[] = st.split(",");
                              if (lineArr[2].equals(String.valueOf(jobId))) {
                                 tmp.remove(st);
                                 //break;
                              }
                           }
                        }

                        Collections.reverse(tmp);
                        logFile.delete();

                        try {
                           fw = new FileWriter(logFile);
                           for (String linex : tmp) {
                              if (linex != null) {
                                 fw.write(linex + "\n");
                              }

                           }
                           fw.close();
                        } catch (IOException e) {
                           e.printStackTrace();
                        }
                        fw.close();

                     }
                  }
                  pjHandler.completeJob(jobId);
               }
            } else {
               if (log.debug) {
                  log.debug("No jobs found.");
               }
               try {
                  Thread.sleep(1000 * pollTime);
               } catch (InterruptedException ex) {
                  log.debug("sleep Interrupted");
               }
            }
         }
      } catch (Exception ex) {
        if (ex.getCause() instanceof ManualDecisionException){
               ManualDecisionCollection decisions = ((ManualDecisionException)ex.getCause()).getDecisions();
               if (decisions != null) {
               Iterator iterator = decisions.iterator();
               while (iterator.hasNext())
                  log.error(((ManualDecision)iterator.next()).getMessage());
               }
        } else {
               log.debug("error=" + ex.getMessage());
               // FATAL ERROR!  Clear job so it can be reused.
        }
      }

   }

   /**
    * @return new RemoteJob to perform or null if not found
    */
   private RemoteJob getRemoteJob(String printParamsConfigFileName, String printerConfFileDir) throws IfsException {
      FndNumber fndJobId = new FndNumber();
      FndNumber fndCopies = new FndNumber();
      FndNumber fndPrintFrom = new FndNumber();
      FndNumber fndPrintTo = new FndNumber();
      FndText fndPprinterId = new FndText();

      pjHandler.getRemoteJob(fndJobId, fndPprinterId, fndCopies, fndPrintFrom, fndPrintTo, nodeName);

      if (fndJobId.isNull()) {
         return null;
      }
      int jobId = fndJobId.getValue().intValue();
      int copies = fndCopies.isNull() ? -1 : fndCopies.getValue().intValue();
      int printFrom = fndPrintFrom.isNull() ? 1 : fndPrintFrom.getValue().intValue();
      int printTo = fndPrintTo.isNull() ? -1 : fndPrintTo.getValue().intValue();
      String printerId = fndPprinterId.getValue();
      RemoteJob job = new RemoteJob(jobId, printerId, copies, printFrom, printTo, this.node, printParamsConfigFileName, printerConfFileDir);

      return job;
   }

   private OldRemoteJob getOldRemoteJob() throws IfsException {
      FndNumber fndJobId = new FndNumber();
      FndNumber fndCopies = new FndNumber();
      FndNumber fndPrintFrom = new FndNumber();
      FndNumber fndPrintTo = new FndNumber();
      FndText fndPprinterId = new FndText();

      pjHandler.getRemoteJob(fndJobId, fndPprinterId, fndCopies, fndPrintFrom, fndPrintTo, nodeName);

      if (fndJobId.isNull()) {
         return null;
      }
      int jobId = fndJobId.getValue().intValue();
      int copies = fndCopies.isNull() ? -1 : fndCopies.getValue().intValue();
      int printFrom = fndPrintFrom.isNull() ? 1 : fndPrintFrom.getValue().intValue();
      int printTo = fndPrintTo.isNull() ? -1 : fndPrintTo.getValue().intValue();
      String printerId = fndPprinterId.getValue();
      OldRemoteJob job = new OldRemoteJob(jobId, printerId, copies, printFrom, printTo, this.node);

      return job;

   }

   /**
    * Method to find the crashed PDF files of the print job
    *
    * @param printJobId
    * @return file array of PDFs of the relevant print job
    */
   private File[] getFileList(final String printJobId) {
      File dir = new File(node.crashedPDFDir);
      File[] fileList = dir.listFiles(new FilenameFilter() {
         public boolean accept(File dir, String name) {
            return name.startsWith("PrintJob_" + printJobId);
         }
      });
      return fileList;
   }

   /**
    * Method to find the crashed jobs upon restart and print them
    *
    * @throws FileNotFoundException
    * @throws IOException
    * @throws IfsException
    */
   void getCrashedJobs() throws FileNotFoundException, IOException, IfsException {

      Logger log = LogMgr.getFrameworkLogger();
      File logFile = new File(node.crashedDir + File.separator + node.currentLogFile);
      if (logFile.exists()) {

         FileReader fr = new FileReader(logFile);
         BufferedReader br = new BufferedReader(fr);
         String ch;

         List<String> tmp = new ArrayList<String>();
         List<String> crashList = new CopyOnWriteArrayList<String>();
         do {
            ch = br.readLine();
            tmp.add(ch);
         } while (ch != null);

         for (int i = tmp.size() - 1; i >= 0; i--) {
            try {
               if ((tmp.get(i)) != null) {
                  String con[] = tmp.get(i).split(",");
                  if (con[0].equals("C")) {
                     crashList.add(tmp.get(i));
                  } else if ((con[0].equals("R")) || ((con[0].equals("E")))) {
                     break;
                  }
               }
            } catch (Exception ex) {
               log.debug("error=" + ex.getMessage());
            }
         }

         Collections.reverse(crashList);

         int lastJobId = 0;

         if (crashList.size() > 0) {
            for (String jobDetail : crashList) {

               String jobElements[] = jobDetail.split(",");

               int jobid = Integer.parseInt(jobElements[2]);
               String printerId = jobElements[4];
               int copies = Integer.parseInt(jobElements[5]);
               int pageFrom = Integer.parseInt(jobElements[6]);
               int pageTo = Integer.parseInt(jobElements[7]);
               RemotePrintingNode node = this.node;

               if (lastJobId == jobid) {
                  continue;
               } else {
                  RemoteJob job = new RemoteJob(jobid, printerId, copies, pageFrom, pageTo, node, this.printParamsConfigFile, this.printerConfFileDir);
                  String errMsg = null;

                  boolean jobSuccess = false;
                  int noOfRetries = 0;

                  do {

                     if (noOfRetries == 3) {
                        errMsg = "Print Job: " + jobid + " crashing. Retried 03 Times";
                        pjHandler.abortJob(jobid, errMsg);

                        StringBuilder builder = new StringBuilder();
                        FileWriter fw = new FileWriter(logFile, true);
                        if (logFile.exists()) {
                           BufferedReader reader = new BufferedReader(new FileReader(logFile));
                           SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
                           String dateTime = format.format(new Date());
                           builder.append("E,");
                           builder.append(dateTime + ",");
                           builder.append(jobid + ",");   // Print Job Details
                           builder.append("Print Job: " + jobid + " crashing. Retried 03 Times" + ",");
                           builder.append('\n');
                        }
                        fw.write(builder.toString());
                        fw.close();

                        break;
                     }

                     noOfRetries++;

                     try {
                        errMsg = job.perform();
                        if (errMsg != null) {
                           pjHandler.abortJob(jobid, errMsg);
                        } else {
                           jobSuccess = true;
                           pjHandler.completeJob(jobid);
                           File[] crashFileList = getFileList(String.valueOf(jobid));
                           for (File file : crashFileList) {
                              file.delete();
                              StringBuilder builder = new StringBuilder();
                              FileWriter fw = new FileWriter(logFile, true);
                              if (logFile.exists()) {
                                 BufferedReader reader = new BufferedReader(new FileReader(logFile));
                                 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
                                 String dateTime = format.format(new Date());
                                 builder.append("R,");
                                 builder.append(dateTime + ",");
                                 builder.append(jobid + ",");   // Print Job Details
                                 builder.append("RE-PRINTED SUCCESSFULLY" + ",");
                                 builder.append('\n');
                              }
                              fw.write(builder.toString());
                              fw.close();
                           }
                        }
                     } catch (Exception ex) {
                        log.error("ERROR jobId=" + job.getId() + " " + ex.getMessage());
                     }
                  } while (!jobSuccess && noOfRetries <= node.printRetries);
               }
               lastJobId = jobid;
            }
         }

      }

   }

}
