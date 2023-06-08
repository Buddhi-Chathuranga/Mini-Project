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

import static org.junit.Assert.fail;
import static org.powermock.api.mockito.PowerMockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest({System.class, Helper.class})
public class MtxDBInstallTest {
    private static final Logger logger = InstallerLogger.getLogger();
    private Map<String, String> envs = new HashMap<>();
    private String deliveryPath = "";
    private String propertiesFilePath = "";
    private String schemaUsername = "";
    private String schemaPassword = "";
    private String systemUsername = "";
    private String systemPassword = "";
    private String connectString = "";
    private String dbService = "";
    private String dbPort = "";
    private String dbHost = "";
    private String importFilename = "";
    private String importPath = "";
    private String importDirectory = "";
    private String datafileLocation = "";
    private String datafileSize = "";
    private String databaseId = "";
    private String logFilePath = "";

    @Before
    public void setUp() {
        mockStatic(Helper.class);
        mockStatic(System.class);
    }

    @Test
    public void setParamsTest() throws Exception {
        Map<String, Object> properties;
        properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
        InstallerLogger.setLogfileLocation(
                properties.containsKey("logFileLocation") ? (String) properties.get("logFileLocation")
                        : new File("").getAbsolutePath());
        deliveryPath = !properties.containsKey("dbInstaller.deliveryPath") ? ""
                : (String) properties.get("dbInstaller.deliveryPath");
        propertiesFilePath = deliveryPath.concat(File.separator + "mx-database" + File.separator + "install" + File.separator + "build.properties");
        schemaUsername = (String) properties.getOrDefault("ifsmaintenixdb.maintenixUser", "maintenix");
        schemaPassword = !properties.containsKey("ifsmaintenixdb.maintenixPassword") ? ""
                : (String) properties.get("ifsmaintenixdb.maintenixPassword");
        systemUsername = (String) properties.getOrDefault("ifsmaintenixdb.systemUser", "system");
        systemPassword = !properties.containsKey("ifsmaintenixdb.systemPassword") ? ""
                : (String) properties.get("ifsmaintenixdb.systemPassword");
        if (!properties.containsKey("dbInstaller.jdbcUrl")) {
            if (!properties.containsKey("ifscore.secrets.jdbcUrl.data")) connectString = "";
            else connectString = "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"));
        } else {
            connectString = "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
        }
        dbService = Helper.parseTns("SERVICE_NAME", connectString);
        dbPort = Helper.parseTns("PORT", connectString);
        dbHost = Helper.parseTns("HOST", connectString);
        importFilename = !properties.containsKey("ifsmaintenixdb.import.filename") ? ""
                : (String) properties.get("ifsmaintenixdb.import.filename");
        importPath = !properties.containsKey("ifsmaintenixdb.import.path") ? ""
                : (String) properties.get("ifsmaintenixdb.import.path");
        importDirectory = !properties.containsKey("ifsmaintenixdb.import.directory") ? ""
                : (String) properties.get("ifsmaintenixdb.import.directory");
        datafileLocation = !properties.containsKey("ifsmaintenixdb.oracle.datafile.location") ? ""
                : (String) properties.get("ifsmaintenixdb.oracle.datafile.location");
        datafileSize = !properties.containsKey("ifsmaintenixdb.oracle.datafile.size") ? ""
                : (String) properties.get("ifsmaintenixdb.oracle.datafile.size");
        databaseId = !properties.containsKey("ifsmaintenixdb.database.id") ? ""
                : (String) properties.get("ifsmaintenixdb.database.id");
        logFilePath = InstallerLogger.getLogfileLocation().concat(File.separator + "mtxdbinstall.log");
        MtxDbInstall mtxDbInstall = new MtxDbInstall(properties);
        Class c = DbDeploy.class;

        Object o = c.newInstance();
        Class[] method_arguments = new Class[2];
        method_arguments[0] = Map.class;
        method_arguments[1] = String.class;
        Method m = c.getDeclaredMethod("setParams", method_arguments);
        m.setAccessible(true);
        Whitebox.invokeMethod(mtxDbInstall, "setParams", properties);

    }

    @Test
    public void testRunDbInstall() {
        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        File script;
        String action = null;
        String directive = "cmd.exe";
        String extra = "/C";
        script = new File(deliveryPath.concat(File.separator + "mx-database" + File.separator + "install" + File.separator + "datapump-create-jasper-user.") + "bat");
        when(Helper.isPathValid(script.getAbsolutePath())).thenReturn(true);

        try {
            Map<String, Object> properties;
            properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
            deliveryPath = !properties.containsKey("dbInstaller.deliveryPath") ? ""
                    : (String) properties.get("dbInstaller.deliveryPath");
            InstallerLogger.setLogfileLocation(
                    properties.containsKey("C:\\logs") ? (String) properties.get("C:\\logs")
                            : new File("").getAbsolutePath());
            InstallerLogger.setLogfileLocation("");
            String location = script.getCanonicalPath();

            logFilePath = "logFilePath=".concat(location);
            logger.info("Running Maintenix Report database drop, logs location: " + logFilePath);
            Map<String, String> envs = new HashMap<String, String>();
            envs.put("_NOPAUSE", "TRUE");

            when(Helper.runProcessWithResult(envs, deliveryPath.concat(File.separator + "mx-database" + File.separator + "install"), false, directive, extra, script.getAbsolutePath())).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            MtxDbInstall mtxDbInstall = new MtxDbInstall(properties);

            Whitebox.invokeMethod(mtxDbInstall, "setParams", properties);
            boolean res = mtxDbInstall.runDbInstall();

        } catch (IOException e) {
            fail("Exception should not throw");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
