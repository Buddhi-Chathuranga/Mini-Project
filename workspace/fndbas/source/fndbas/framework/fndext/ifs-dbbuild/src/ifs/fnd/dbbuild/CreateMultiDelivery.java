/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ifs.fnd.dbbuild;

import ifs.fnd.dbbuild.databaseinstaller.DbBuildException;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 *
 * @author stdafi
 */
public final class CreateMultiDelivery {
   //Input parameters
   private String _mergeType = "";
   private String _deliveryPath = "";
   private String _deliveryDestPath = "";
   
   private static final String lineSeparator = System.getProperty("line.separator", "\n");
   private boolean installtemadvance = false;
   private boolean noinstalltemadvance = false;
   private static boolean masterTem = false;   
   
   private static String databaseFolderPath = ""; 
   
   /**
    * Creates a new instance of DbMergeFilesTask
   * @param args
    */
   public CreateMultiDelivery(String[] args) {
      parseArgs(args);
   }   

   /**
   //     * Main
   //    * @param args
   //
   * @param args */
   public static void main(String[] args) {    
      if (args.length != 3) {
         System.out.println("Invalid amount of parameters, should be 3");
         System.exit(1);
      } 
      CreateMultiDelivery p = new CreateMultiDelivery(args);
      System.out.println("Merging of delivery started.");
      p.createMultiDelivery();
      System.out.println("Merging of delivery finished.");
   }   

   public void parseArgs(String[] args){
      String key = "";
      String value = "";
      for (String arg : args) {
         if (arg.contains("=")) {
            key = arg.substring(0,arg.indexOf("="));
            value = arg.substring(arg.indexOf("=")+1);
            switch (key.toLowerCase()) {
               case "mergetype":
                  _mergeType = value;
                  break;
               case "deliverypath":
                  _deliveryPath = value;
                  break;   
               case "deliverydestpath":
                  _deliveryDestPath = value;
                  break;   
               default:
                 break; 
            }
         }
      }
   } 

   public void createMultiDelivery() {      
      installtemadvance = false;
      noinstalltemadvance = false;

      boolean createOk = true;
      boolean temFileFound = false;
      
      List<String> deliveries = new ArrayList<>();
      List<File> foundDeliveries = new ArrayList<>();
      List<File> definedDeliveries = new ArrayList<>();
      
      boolean found = false;
      System.out.print(lineSeparator);
      
      File deliveryid = new File(_deliveryDestPath + "/database/deliveryid.txt");
      if (deliveryid.exists()) {
         try {
            deliveryid.delete();
         } catch(Exception e) {
            System.err.println("Error deleting file " + deliveryid.getName() + lineSeparator + e.toString() + lineSeparator);
            createOk = false;
         } 
      }
      
      if (_mergeType.equals("maintem") || _mergeType.equals("mergetem")) {
         databaseFolderPath = _deliveryDestPath + File.separator + "database";

         File deliveryHome = new File(_deliveryPath);
         File[] subFolders = deliveryHome.listFiles();

         List<File> sortedSubFolders = new ArrayList<>();
         if (subFolders != null)
            sortedSubFolders.addAll(Arrays.asList(subFolders));
         Collections.sort(sortedSubFolders);            

         //Verifying that the deliveries contains subfolders and deliveries database folders can be merged (if selected).
         if (sortedSubFolders.size() > 0) {
            found = true;
            for (File folder : sortedSubFolders) {
               if (folder.isDirectory()) {
                  foundDeliveries.add(folder);
                  File[] dbFolders = folder.listFiles();
                  for (File dbFolder : dbFolders) {
                     if (dbFolder.getName().toLowerCase().equals("database") && _mergeType.equals("mergetem")) {
                        File[] files = dbFolder.listFiles();
                        for (File file : files) {
                           if (file.getName().toLowerCase().equals("install.tem")) {
                              temFileFound = true;
                              String line = "";
                              //Check if we have a mixed types of install.tem in the deliveries. 
                              //If true, the db part of the deliveries can't be merged.
                              try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                                 while ((line = reader.readLine()) != null){
                                    if (line.toLowerCase().trim().contains("-- installtemadvance")) {
                                       installtemadvance = true;
                                       break;
                                    }                                    
                                    if (line.toLowerCase().trim().contains("-- noinstalltemadvance")) {
                                       noinstalltemadvance = true;
                                       break;
                                    }
                                    if (line.toLowerCase().trim().contains("-- [master_tem]")) {
                                       masterTem = true;
                                       break;
                                    }
                                 }
                              } catch (Exception ex) {
                                 System.err.println("Error when reading " + file.getName() + lineSeparator + ex.toString() + lineSeparator);
                                 createOk = false;
                              }                           
                              break;
                           }
                        }
                        break;
                     }
                  }
               }
            }
            if (found) {
               if (masterTem) {
                  System.out.println("Delivery containing master install.tem, created by earlier merge process of deliveries, cannot be included in a new merge process." + lineSeparator);            
                  createOk = false;
               }
               if (installtemadvance && noinstalltemadvance) {
                  System.out.println("Mixed versions of install.tem (advance/noadvance) in the deliveries, merge of db code cannot be executed" + lineSeparator);            
                  createOk = false;
               }
               if (createOk) {
                  //Copy the deliveries to one folder
                  File deliveriesFile = new File(_deliveryPath + File.separator + "deliveries.txt");
                  if (deliveriesFile.exists()) {
                     String line = "";
                     //Read in which order the deliveries should be merged/deployed 
                     try (BufferedReader reader = new BufferedReader(new FileReader(deliveriesFile))) {
                        while ((line = reader.readLine()) != null){
                           if (!foundDeliveries.contains(new File(deliveryHome + File.separator + line))) {
                              System.err.println(_deliveryPath + " doesn't contain all deliveries defined in deliveries.txt" + lineSeparator);
                              createOk = false;
                              break;
                           } else {
                              definedDeliveries.add(new File(deliveryHome + File.separator + line));
                           }
                        }
                     } catch (Exception ex) {
                        System.err.println("Error when reading " + deliveriesFile.getName() + lineSeparator + ex.toString() + lineSeparator);
                        createOk = false;
                     }
                     if (createOk && foundDeliveries.size() != definedDeliveries.size()) {
                        System.err.println(deliveriesFile.getName() + " doesn't contain all deliveries in folder " + _deliveryPath + lineSeparator);
                        createOk = false;
                     }
                     if (createOk) {
                        foundDeliveries.clear();
                        foundDeliveries = definedDeliveries;
                     }
                  }
                  if (createOk) {
                     for (File folder : foundDeliveries) {
                        if (folder.isDirectory()) {
                           try {
                              if (_mergeType.equals("mergetem")) {
                                 copyFolder(new File(_deliveryPath + File.separator + folder.getName()), new File(_deliveryDestPath));
                              } else {
                                 copyFolder(new File(_deliveryPath + File.separator + folder.getName()), new File(_deliveryDestPath), folder.getName());
                              }
                              deliveries.add(folder.getName());    
                           } catch (IOException ex) {
                              System.err.println("Error when copying the folders " + ex.getMessage() + lineSeparator); 
                              createOk = false;
                           }
                        }
                     }
                  }
               }
            }
         }

         if (createOk) {
            try {
               File outputFile = new File(_deliveryDestPath + File.separator + "Merged_Deliveries.log");
               try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
                  for (String delivery : deliveries) {
                     output.write(_deliveryPath + File.separator + delivery + lineSeparator);
                  }
                  output.close();
               }
            } catch (IOException ex) {
               System.out.print("Error when merging deliveries " + ex.getMessage() + lineSeparator);
               createOk = false;
            }  
         }

         if (createOk) {
             CreateInstallTem p = new CreateInstallTem();

            if (_mergeType.equals("mergetem"))
            {
               if (temFileFound) {
                  try {
                     p.mergedDelivery(databaseFolderPath);
                     System.out.println("Merging of multi deliveries ready" + lineSeparator);
                  } catch (DbBuildException ex) {
                     System.out.print("Error when merging deliveries " + ex.getMessage() + lineSeparator);
                     createOk = false;
                  }
               } else {
                  System.out.println("Merging of multi deliveries ready, no new tem file created" + lineSeparator);
               }                  
            }
            else
            {
               try {
                  p.createMainTemp(databaseFolderPath, deliveries);
                  
                  for (String delivery : deliveries) {
                     File subDir = new File(databaseFolderPath + File.separator + delivery);
                     if (subDir.exists()) 
                     {
                        File[] listFile = subDir.listFiles();
                        for (File file : listFile) {
                           if (file.getName().toLowerCase().equals("deliveryid.txt")) {
                              BufferedWriter outFile = new BufferedWriter(new FileWriter(databaseFolderPath + File.separator + "deliveryid.txt", true));
                              FileInputStream inFile = new FileInputStream(file);
                              Integer b = null;
                              while ((b = inFile.read()) != -1)
                                outFile.write(b);
                              inFile.close();
                              outFile.close();
                           }
                        }
                     }
                  } 
                  System.out.println("Merging of multi deliveries ready" + lineSeparator);
               } catch (IOException ex) {
                  System.out.print("Error when merging deliveries " + ex.getMessage() + lineSeparator);
                  createOk = false;
               }                    
            }

         } else {
            System.err.println("Error merging deliveries" + lineSeparator);
         }
      } else {
         System.out.println("Only maintem and mergetem are supported as execution type." + lineSeparator);
         createOk = false;
      }
      if (!createOk)
         Runtime.getRuntime().exit(-1);
   }   
   
   private static void copyFolder(File sourceFolder, File destinationFolder) throws IOException
   {
      if (sourceFolder.isDirectory()) 
      {
         //Verify if destinationFolder is already present; If not then create it
         if (!destinationFolder.exists()) 
         {
            destinationFolder.mkdirs();
         }

         //Get all files from source directory
         String files[] = sourceFolder.list();

         //Iterate over all files and copy them to destinationFolder one by one
         for (String file : files) 
         {
            File srcFile = new File(sourceFolder, file);
            File destFile = new File(destinationFolder, file);

            //Recursive function call
            copyFolder(srcFile, destFile);
         }
      }
      else
      {
         if (sourceFolder.getParentFile().getName().toLowerCase().equals("database")) {
            if (sourceFolder.getName().toLowerCase().equals("install.ini") || 
                sourceFolder.getName().toLowerCase().equals("deliveryregistration.sql") ||
                sourceFolder.getName().toLowerCase().equals("deliveryid.txt") ||
                sourceFolder.getName().substring(sourceFolder.getName().lastIndexOf(".") + 1).toLowerCase().equals("tem")) {
                  //If deliveryid.txt, check if the file is created, then that version should be used
                 if (sourceFolder.getName().substring(sourceFolder.getName().lastIndexOf(".") + 1).toLowerCase().equals("tem")) {
                     String line = "";
                     boolean copyOk = true;
                     try (BufferedReader reader = new BufferedReader(new FileReader(sourceFolder))) {
                        //If install.tem is norefresh version, copy and rename the file to installnorefresh.tem.
                        if (sourceFolder.getName().toLowerCase().equals("install.tem"))
                        {
                           while ((line = reader.readLine()) != null){
                              if (line.replaceAll(" ","").toLowerCase().contains("[type:norefresh]")) {
                                 Files.copy(sourceFolder.toPath(), new File(destinationFolder.getParent() + File.separator + "installnorefresh.tem").toPath(), StandardCopyOption.REPLACE_EXISTING);
                                 copyOk = false;
                                 break;
                              }            
                           }
                        }
                        line = "";
                        if (copyOk)
                        {
                           BufferedReader reader2 = new BufferedReader(new FileReader(sourceFolder));
                           while ((line = reader2.readLine()) != null){
                              if (line.toLowerCase().trim().contains("-- noinstalltemadvance") || line.toLowerCase().trim().contains("-- installtemadvance")) {
                                 Files.copy(sourceFolder.toPath(), destinationFolder.toPath(), StandardCopyOption.REPLACE_EXISTING);
                                 break;  
                              }             
                           }
                        }
                     } catch (Exception ex) {
                        throw new IOException("Error when reading " + sourceFolder.getName() + lineSeparator + ex.toString());
                     } 
                     //If file not already exist, copy it. define.tem (last version) should always be copied.
                     if (copyOk && (!destinationFolder.exists() || sourceFolder.getName().toLowerCase().equals("define.tem"))) {
                        Files.copy(sourceFolder.toPath(), destinationFolder.toPath(), StandardCopyOption.REPLACE_EXISTING);                        
                     }
                  //Merge install.ini and DeliveryRegistration.sql. Install.ini will be redone, DeliveryRegistration.sql used as is.
                  } else {
                     BufferedWriter outFile = new BufferedWriter(new FileWriter(destinationFolder, true));
                     FileInputStream inFile = new FileInputStream(sourceFolder);
                     Integer b = null;
                     while ((b = inFile.read()) != -1)
                       outFile.write(b);
                     inFile.close();
                     outFile.close();
                  }   
            } else {
               Files.copy(sourceFolder.toPath(), destinationFolder.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
         } else {
           Files.copy(sourceFolder.toPath(), destinationFolder.toPath(), StandardCopyOption.REPLACE_EXISTING);
         }
      }
   }   
   
   private static void copyFolder(File sourceFolder, File destinationFolder, String deliveryName) throws IOException
   {
      if (sourceFolder.isDirectory()) 
      {
         //Verify if destinationFolder is already present; If not then create it
         if (sourceFolder.getParentFile().getName().toLowerCase().equals(deliveryName.toLowerCase()) && sourceFolder.getName().toLowerCase().equals("database")) {  
            destinationFolder = new File(destinationFolder.getCanonicalPath() + File.separator + deliveryName);
         }

         if (!destinationFolder.exists()) 
            destinationFolder.mkdirs();

         //Get all files from source directory
         String files[] = sourceFolder.list();

         //Iterate over all files and copy them to destinationFolder one by one
         for (String file : files) 
         {
            File srcFile = new File(sourceFolder, file);
            File destFile = new File(destinationFolder, file);

            //Recursive function call
            copyFolder(srcFile, destFile, deliveryName);
         }
         if (sourceFolder.getParentFile().getParentFile() != null && sourceFolder.getParentFile().getParentFile().getName().toLowerCase().equals(deliveryName.toLowerCase()) && 
                 sourceFolder.getParentFile().getName().toLowerCase().equals("database") && sourceFolder.getName().toLowerCase().equals("_utils")) {
            if (!new File(databaseFolderPath + File.separator + "_utils").exists())
               new File(databaseFolderPath + File.separator + "_utils").mkdir();
            
            for (String file : files) {
               File srcFile = new File(sourceFolder, file);
               File destFile = new File(databaseFolderPath + File.separator + "_utils", file);

               Files.copy(srcFile.toPath(), destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            if (new File(sourceFolder.getParent() + File.separator + "define.tem").exists())
               Files.copy(new File(sourceFolder.getParent() + File.separator + "define.tem").toPath(), new File(databaseFolderPath + File.separator + "define.tem").toPath(), StandardCopyOption.REPLACE_EXISTING);
         }
      }
      else
      {
         //Copy the file content from one place to another 
         Files.copy(sourceFolder.toPath(), destinationFolder.toPath(), StandardCopyOption.REPLACE_EXISTING);
      }
   }    
}

