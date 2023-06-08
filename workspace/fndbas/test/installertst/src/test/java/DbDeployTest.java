//package ifs.installer.test;

import ifs.installer.*;
import ifs.installer.component.*;
import ifs.installer.logging.*;
import ifs.installer.util.*;
import org.junit.*;
import org.junit.runner.*;
import org.mockito.*;
import org.powermock.core.classloader.annotations.*;
import org.powermock.modules.junit4.*;
import org.powermock.reflect.*;
import org.junit.Test;
import java.io.*;
import java.lang.reflect.*;
import java.util.*;
import java.util.logging.*;

import static org.junit.Assert.*;
import static org.powermock.api.mockito.PowerMockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest({System.class, Helper.class})
public class DbDeployTest {
    private static final Logger logger = InstallerLogger.getLogger();
    private Map<String, String> envs = new HashMap<>();
    private String fileName = "";
    private String deliveryPath = "";
    private String userName = "";
    private String ialOwner = "";
    private String password = "";
    private String syspassword = "";
    private String connectString = "";
    private String logFilePath = "";
    private String extlogging = "";
    private String waitingTime = "";
    private String threadMethod = "";
    private String initialPasswords = "";

    @Before
    public void setUp() {
        mockStatic(Helper.class);
        mockStatic(System.class);

    }

    @Test
    public void testSetParams() throws Exception {

        Map<String, Object> properties ;
        properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
        InstallerLogger.setLogfileLocation(
                properties.containsKey("logFileLocation") ? (String) properties.get("logFileLocation")
                        : new File("").getAbsolutePath());
        if (!properties.containsKey("dbInstaller.fileName")) fileName = "";
        else fileName = "fileName=".concat((String) properties.get("dbInstaller.fileName"));
        userName = "userName=".concat((String) properties.getOrDefault("dbInstaller.userName", "ifsapp"));
        password = !properties.containsKey("dbInstaller.password") ?
                !properties.containsKey("dbInstaller.ifsappPassword") ? ""
                        : "password=".concat((String) properties.get("dbInstaller.ifsappPassword"))
                : "password=".concat((String) properties.get("dbInstaller.password"));
        //this property should be removed, kind of depricated
        if ("".equals(password)) {
            password = !properties.containsKey("ifscore.passwords.ifsappPassword.data") ? ""
                    : "password=".concat((String) properties.get("ifscore.passwords.ifsappPassword.data"));
        }
        syspassword = !properties.containsKey("dbInstaller.sysPassword") ? ""
                : "sysPassword=".concat((String) properties.get("dbInstaller.sysPassword"));
        connectString = !properties.containsKey("dbInstaller.jdbcUrl") ?
                !properties.containsKey("ifscore.secrets.jdbcUrl.data") ? ""
                        : "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"))
                : "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
        logFilePath = "logFilePath=".concat(InstallerLogger.getLogfileLocation());
        extlogging = !properties.containsKey("dbInstaller.extLogging") ? ""
                : "extLogging=".concat((String) properties.get("dbInstaller.extLogging"));
        waitingTime = !properties.containsKey("dbInstaller.waitingTime") ? ""
                : "waitingTime=".concat((String) properties.get("dbInstaller.waitingTime"));
        threadMethod = !properties.containsKey("dbInstaller.threadMethod") ? ""
                : "threadMethod=".concat((String) properties.get("dbInstaller.threadMethod"));

        initialPasswords = !properties.containsKey("dbInstaller.ifsappPassword") ? ""
                : "APPLICATION_OWNER=".concat((String) properties.get("dbInstaller.ifsappPassword")).concat(";");
        initialPasswords = initialPasswords + (!properties.containsKey("ifscore.passwords.ifsiamPassword.data") ? ""
                : "IFSIAMSYS=".concat((String) properties.get("ifscore.passwords.ifsiamPassword.data")).concat(";"));
        initialPasswords = initialPasswords + (!properties.containsKey("ifscore.passwords.ifssysPassword.data") ? ""
                : "IFSSYS=".concat((String) properties.get("ifscore.passwords.ifssysPassword.data")).concat(";"));
        initialPasswords = initialPasswords + (!properties.containsKey("ifscore.passwords.ifsmonPassword.data") ? ""
                : "IFSMONITORING=".concat((String) properties.get("ifscore.passwords.ifsmonPassword.data")).concat(";"));

        initialPasswords = "initialPasswords=" + initialPasswords;
        DbDeploy dbDeploy = new DbDeploy();
        Class c = DbDeploy.class;

        Object o = c.newInstance();
        Class[] method_arguments = new Class[2];
        method_arguments[0] = Map.class;
        method_arguments[1] = String.class;
        Method m = c.getDeclaredMethod("setParams", method_arguments);
        m.setAccessible(true);
        try {
            Whitebox.invokeMethod(dbDeploy, "setParams", properties, "fileexec");
        } catch (Exception e) {
        }

    }

    @Test
    public void testRunDbDeploy() {
        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        File script;
        String action = null;
        String directive = "cmd.exe";
        String extra = "/C";
        envs.put("verbose", logger.getLevel() == Level.FINEST ? "on" : "off");
        script = new File("installers/db-deploy." + (true ? "cmd" : "sh"));
        logger.fine("calling db-deploy");
        try {
            Map<String, Object> properties;
            properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
            System.out.println(properties);
            InstallerLogger.setLogfileLocation(
                    properties.containsKey("C:\\logs") ? (String) properties.get("C:\\logs")
                            : new File("").getAbsolutePath());
            InstallerLogger.setLogfileLocation("");
            String location = script.getCanonicalPath();

            logFilePath = "logFilePath=".concat(location);
            System.out.println("logFilePath" + logFilePath);
            //Behaviour of the mocks
            when(Helper.runProcessWithResult("installers", directive, extra, script.getAbsolutePath(), fileName, deliveryPath, userName, ialOwner,
                    password, syspassword, connectString, logFilePath, extlogging, waitingTime, threadMethod, initialPasswords)).thenReturn(processResult);
            System.out.println(directive);
            System.out.println(extra);

            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            DbDeploy dbDeploy = new DbDeploy();
            Whitebox.invokeMethod(dbDeploy, "setParams", properties, "fileexec");
            boolean obj = dbDeploy.runDbDeploy();
            assertEquals(true, obj);

        } catch (IOException e) {
            fail("Exception should not throw");
        } catch (InterruptedException e) {
            fail("Exception should not throw");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
