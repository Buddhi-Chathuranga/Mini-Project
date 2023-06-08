import ifs.installer.*;
import ifs.installer.component.*;
import ifs.installer.logging.*;
import ifs.installer.util.*;
import org.junit.Test;
import org.junit.*;
import org.junit.runner.*;
import org.mockito.*;
import org.powermock.api.mockito.*;
import org.powermock.core.classloader.annotations.*;
import org.powermock.modules.junit4.*;
import org.powermock.reflect.*;
import java.io.*;
import java.util.*;
import java.util.logging.*;

import static org.junit.Assert.*;
import static org.powermock.api.mockito.PowerMockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest({System.class, Helper.class})
public class InstallerTest<args> {

    private static final Logger logger = InstallerLogger.getLogger();
    private final String ACTION = "action";
    public final static String INSTALL = "install";
    public final static String MTINSTALLER = "mtinstaller";
    public final static String DELETE = "delete";
    public final static String DBINSTALLER = "dbinstaller";
    public final static String FILEXEC = "fileexec";
    public final static String MTXDBINSTALL = "mtxdbinstall";
    public final static String MTXDBUPGRADE = "mtxdbupgrade";
    public final static String MTXREPORTDBINSTALL = "mtxreportdbinstall";
    public final static String MTXREPORTDBDROP = "mtxreportdbdrop";
    private String[] userArgs;
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
    public void dbinstallerTest() throws Exception {
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

            Map<String, Object> properties ;
            properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
            InstallerLogger.setLogfileLocation(
                    properties.containsKey("C:\\logs") ? (String) properties.get("C:\\logs")
                            : new File("").getAbsolutePath());
            InstallerLogger.setLogfileLocation("");
            String location = script.getCanonicalPath();

            logFilePath = "logFilePath=".concat(location);
            System.out.println("logFilePath" +logFilePath);
            logger.info("Running database installer, logs location: "+ logFilePath.substring("logFilePath=".length()).trim());
            when(Helper.runProcessWithResult("installers", directive, extra, script.getAbsolutePath(), fileName, deliveryPath, userName, ialOwner,
                    password, syspassword, connectString, logFilePath, extlogging, waitingTime, threadMethod, initialPasswords)).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            DbDeploy dbDeploy = new DbDeploy();
            Whitebox.invokeMethod(dbDeploy, "setParams",properties,"fileexec");
            boolean obj = dbDeploy.runDbDeploy();
            Installer installer=new Installer();
            Whitebox.invokeMethod(installer, "dbinstaller","fileexec");

        } catch (IOException e) {
            fail("Exception should not throw");
        } catch (InterruptedException e) {
            fail("Exception should not throw");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //@Test
    public void deleteTest() throws Exception {
        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        File script;
        String action = null;
        String directive = "cmd.exe";
        String extra = "/C";
        envs.put("verbose", logger.getLevel() == Level.FINEST ? "on" : "off");
        script = new File("installers/mt-installer." + (Helper.IS_WINDOWS ? "cmd" : "sh"));
        logger.fine("calling mt-installer");
        try {
            when(Helper.runProcessWithResult(envs, new File("").getAbsolutePath(), false, directive, extra,
                    script.getAbsolutePath(), "delete")).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            MtInstaller mtInstaller = new MtInstaller();
            boolean result = Whitebox.invokeMethod(mtInstaller, "delete");
            assertEquals(result, true);
            new MtInstaller().delete();

        } catch (IOException e) {
            fail("Exception should not throw");
        }
    }


    @Test
    public void testCreateNamespace() throws Exception {
        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = PowerMockito.mock(ProcessResult.class);
        Process process = PowerMockito.mock(Process.class, Mockito.CALLS_REAL_METHODS);
        File script;
        String action = null;
        String directive = "cmd.exe";
        String extra = "/C";
        envs.put("verbose", logger.getLevel() == Level.FINEST ? "on" : "off");
        script = new File("installers/mt-installer." + (Helper.IS_WINDOWS ? "cmd" : "sh"));
        logger.fine("calling mt-installer");
        try {
            when(Helper.runProcessWithResult(envs, new File("").getAbsolutePath(), false, directive, extra,
                    script.getAbsolutePath(), "create-namespace")).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            MtInstaller mtInstaller = new MtInstaller();
            Whitebox.invokeMethod(mtInstaller, "createNamespace");
        } catch (IOException e) {
            fail("Exception should not throw");
        }
    }
}