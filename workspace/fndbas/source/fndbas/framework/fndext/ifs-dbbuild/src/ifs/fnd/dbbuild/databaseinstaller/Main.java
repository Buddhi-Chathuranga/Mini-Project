/*=====================================================================================
 * Main.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.io.*;
import java.sql.*;

/**
 * Main class for PlSqlFileReader
 * @author mabose
 */
public class Main {

    private static String lineSeparator = System.getProperty("line.separator", "\n");

    public static void main(String[] args) {
        String strInput, fileNameStr, filePath, additionalFileNameStr, additionalFilePath, temporaryFilePath, userName, passWord, connectString, fullConnectString, logFilePath;
        fileNameStr = null;
        filePath = null;
        additionalFileNameStr = "";
        additionalFilePath = "";
        userName = null;
        passWord = null;
        connectString = null;
        fullConnectString = null;
        temporaryFilePath = null;
        logFilePath = null;

        InputStreamReader reader = new InputStreamReader(System.in);
        BufferedReader bufIn = new BufferedReader(reader);
        fileNameStr = "";
        if (args.length > 0) {
            fileNameStr = args[0];
        }
        System.out.print("\nEnter filename...............: (" + fileNameStr + "): ");
        try {
            strInput = bufIn.readLine();
            if (strInput.length() > 0) {
                fileNameStr = strInput;
            }
        } catch (IOException e) {
            System.err.println(e.toString());
        } catch (NullPointerException e) {
            System.out.println();
        }
        if (args.length > 1) {
            filePath = args[1];
        }
        System.out.print("Enter file path..............: (" + filePath + "): ");
        try {
            strInput = bufIn.readLine();
            if (strInput.length() > 0) {
                filePath = strInput;
            }
        } catch (IOException e) {
            System.err.println(e.toString());
        } catch (NullPointerException e) {
            System.out.println();
        }
        if (filePath != null) {
            if (!(filePath.endsWith("/") || filePath.endsWith("\\"))) {
                filePath = filePath + "/";
            }
        }
        if (args.length > 7) {
            additionalFileNameStr = args[7];
        }
        System.out.print("Enter additional filename....: (" + additionalFileNameStr + "): ");
        try {
            strInput = bufIn.readLine();
            if (strInput.length() > 0) {
                additionalFileNameStr = strInput;
            }
        } catch (IOException e) {
            System.err.println(e.toString());
        } catch (NullPointerException e) {
            System.out.println();
        }
        if (args.length > 8) {
            additionalFilePath = args[8];
        }
        System.out.print("Enter additional file path...: (" + additionalFilePath + "): ");
        try {
            strInput = bufIn.readLine();
            if (strInput.length() > 0) {
                additionalFilePath = strInput;
            }
        } catch (IOException e) {
            System.err.println(e.toString());
        } catch (NullPointerException e) {
            System.out.println();
        }
        if (additionalFilePath != null) {
            if (!(additionalFilePath.endsWith("/") || additionalFilePath.endsWith("\\"))
                    && additionalFilePath.length() > 0) {
                additionalFilePath = additionalFilePath + "/";
            }
        }
        if (args.length > 6) {
            temporaryFilePath = args[6];
        }
        System.out.print("Enter temporary file path....: (" + temporaryFilePath + "): ");
        try {
            strInput = bufIn.readLine();
            if (strInput.length() > 0) {
                temporaryFilePath = strInput;
            }
        } catch (IOException e) {
            System.err.println(e.toString());
        } catch (NullPointerException e) {
            System.out.println();
        }
        if (temporaryFilePath != null) {
            if (!(temporaryFilePath.endsWith("/") || temporaryFilePath.endsWith("\\"))) {
                temporaryFilePath = temporaryFilePath + "/";
            }
        }
        if (args.length > 5) {
            logFilePath = args[5];
        }
        System.out.print("Enter log file path..........: (" + logFilePath + "): ");
        try {
            strInput = bufIn.readLine();
            if (strInput.length() > 0) {
                logFilePath = strInput;
            }
        } catch (IOException e) {
            System.err.println(e.toString());
        } catch (NullPointerException e) {
            System.out.println();
        }
        boolean connected = false;
        Connection con = null;
        if (args.length > 2) {
            userName = args[2];
        }
        if (args.length > 3) {
            passWord = args[3];
        }
        if (args.length > 4) {
            connectString = args[4];
        }
        while (!connected) {
            System.out.print("Enter username...............: (" + userName + "): ");
            try {
                strInput = bufIn.readLine();
                if (strInput.length() > 0) {
                    userName = strInput;
                }
            } catch (IOException e) {
                System.err.println(e.toString());
            } catch (NullPointerException e) {
                System.out.println();
            }
            System.out.print("Enter password...............: (" + passWord + "): ");
            try {
                strInput = bufIn.readLine();
                if (strInput.length() > 0) {
                    passWord = strInput;
                }
            } catch (IOException e) {
                System.err.println(e.toString());
            } catch (NullPointerException e) {
                System.out.println();
            }
            System.out.print("Enter connect string.........: (" + connectString + "): ");
            try {
                strInput = bufIn.readLine();
                if (strInput.length() > 0) {
                    connectString = strInput;
                }
            } catch (IOException e) {
                System.err.println(e.toString());
            } catch (NullPointerException e) {
                System.out.println();
            }
            String[] connectToken = connectString.split(":");

            if (connectToken.length > 2) {
//            fullConnectString = DBConnection.getConnectString(connectToken[0], connectToken[1], connectToken[2]);
// Set up a temporary file containing the db parameter. Only way to support restricted session with the Data Direct driver.
                try {
                    StringBuilder codeBlock = new StringBuilder();
                    codeBlock.append(connectToken[2]);
                    codeBlock.append(" =");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("  (DESCRIPTION =");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("    (ADDRESS_LIST =");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("      (ADDRESS = (PROTOCOL = TCP)(HOST = ");
                    codeBlock.append(connectToken[0]);
                    codeBlock.append(")(PORT = ");
                    codeBlock.append(connectToken[1]);
                    codeBlock.append("))");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("    )");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("    (CONNECT_DATA =");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("      (UR = A)");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("      (SERVICE_NAME = ");
                    codeBlock.append(connectToken[2]);
                    codeBlock.append(")");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("    )");
                    codeBlock.append(lineSeparator);

                    codeBlock.append("  )");
                    codeBlock.append(lineSeparator);
                    try (BufferedWriter output = new BufferedWriter(new FileWriter(temporaryFilePath + "tnsnames.ora"))) {
                        output.write(codeBlock.toString());
                    }
                } catch (IOException ex) {
                    System.out.println("\n!!! Error creating temporary tnsnames.ora file");
                }
                fullConnectString = "jdbc:ifsworld:oracle:TNSNamesFile=" + temporaryFilePath + "tnsnames.ora;TNSServerName=" + connectToken[2];
            } else {
                fullConnectString = connectString;
            }

            con = DBConnection.openConnection(userName, passWord, fullConnectString);
            try {
                if (!con.isClosed()) {
                    connected = true;
                } else {
                    System.out.println("\nNo connection to the database could be established. " + DbInstallerUtil.logonError);
                    System.out.println("\nRe-enter values or press Ctrl+C to abort.\n");
                }
            } catch (Exception ex) {
                System.out.println("\nNo connection to the database could be established. " + DbInstallerUtil.logonError);
                System.out.println("\nRe-enter values or press Ctrl+C to abort.\n");
            }
        }
        String threadingMethod = "0";
        while (!("Y".equals(threadingMethod) || "N".equals(threadingMethod))) {
            System.out.println("\nDo you want to deploy the objects in parallel threads?\n");
            System.out.print("(Y)es or (N)o: ");
            try {
                threadingMethod = bufIn.readLine().toUpperCase();
            } catch (Exception e) {
                System.err.println(e.toString());
            }
        }
        try {
            boolean silent = false;
            long silentWaitingTime = 0;
            PlsqlFileReader p = new PlsqlFileReader(silent);
            p.doRun(filePath + fileNameStr, temporaryFilePath, userName, passWord, fullConnectString, logFilePath, threadingMethod, silentWaitingTime, con, "");
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        } finally {
            try {
                con.close();
            } catch (Exception ex) {
                System.out.println("\n!!! Error closing database");
            }
            try {
                File tnsnamesFile = new File(temporaryFilePath + "tnsnames.ora");
                tnsnamesFile.delete();
            } catch (Exception ex) {
                System.out.println("\n!!! Error deleting temporary tnsnames.ora file");
            }
        }
        System.exit(0);
    }
}
