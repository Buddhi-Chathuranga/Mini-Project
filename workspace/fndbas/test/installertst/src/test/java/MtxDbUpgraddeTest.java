import org.junit.Test;
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

import java.io.*;
import java.util.*;
import java.util.logging.*;

import static org.junit.Assert.*;
import static org.powermock.api.mockito.PowerMockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest({System.class, Helper.class})
public class MtxDbUpgraddeTest {
    private String logFilePath = "";
    private String dbService = "";
    private String dbPort = "";
    private String dbHost = "";
    private String bundlePath = "";
    private String schemaUsername = "";
    private String schemaPassword = "";
    private String connectString = "";
    private static final Logger logger = InstallerLogger.getLogger();
    private Map<String, String> envs = new HashMap<>();
    private Map<String, Object> properties;

    @Before
    public void setUp() {
        mockStatic(Helper.class);
        mockStatic(System.class);
    }

    @Test
    public void testSetParams() throws Exception {
        Map<String, Object> properties;
        properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
        InstallerLogger.setLogfileLocation(
                properties.containsKey("logFileLocation") ? (String) properties.get("logFileLocation")
                        : new File("").getAbsolutePath());
        String deliveryPath = !properties.containsKey("dbInstaller.deliveryPath") ? ""
                : (String) properties.get("dbInstaller.deliveryPath");
        bundlePath = deliveryPath.concat(File.separator + "mx-database" + File.separator + "install" + File.separator + "upgrade" + File.separator + "bundle");
        schemaUsername = "-u ".concat((String) properties.getOrDefault("ifsmaintenixdb.maintenixUser", "maintenix"));
        schemaPassword = !properties.containsKey("ifsmaintenixdb.maintenixPassword") ? ""
                : "-P ".concat((String) properties.get("ifsmaintenixdb.maintenixPassword"));
        if (!properties.containsKey("dbInstaller.jdbcUrl")) {
            if (!properties.containsKey("ifscore.secrets.jdbcUrl.data")) connectString = "";
            else connectString = "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"));
        } else {
            connectString = "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
        }
        dbService = Helper.parseTns("SERVICE_NAME", connectString);
        dbPort = Helper.parseTns("PORT", connectString);
        dbHost = Helper.parseTns("HOST", connectString);
        logFilePath = InstallerLogger.getLogfileLocation().concat(File.separator + "mtxdbupg.log");
        MtxDbUpgrade mtxDbUpgrade = new MtxDbUpgrade(properties);
        Whitebox.invokeMethod(mtxDbUpgrade, "setParams", properties);
    }

    @Test
    public void testRunDbUpgrade() throws IOException {

        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        File script;
        String directive = "cmd.exe";
        String extra = "/C";
        String bundlePath;

        envs.put("verbose", logger.getLevel() == Level.FINEST ? "on" : "off");
        script = new File("installers/mtx-db-upgrade." + ("cmd"));
        properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
        String deliveryPath = !properties.containsKey("dbInstaller.deliveryPath") ? ""
                : (String) properties.get("dbInstaller.deliveryPath");
        bundlePath = deliveryPath.concat(File.separator + "mx-database" + File.separator + "install" + File.separator + "upgrade" + File.separator + "bundle");
        System.out.println(bundlePath);
        InstallerLogger.setLogfileLocation(
                properties.containsKey("C:\\logs") ? (String) properties.get("C:\\logs")
                        : new File("").getAbsolutePath());
        logFilePath = InstallerLogger.getLogfileLocation().concat(File.separator + "mtxdbupg.log");
        when(Helper.isPathValid(bundlePath)).thenReturn(true);
        new File(bundlePath).isDirectory();

        try {
            logger.info("Running Maintenix database upgrade, logs location: " + logFilePath);
            when(Helper.runProcessWithResult("installers", directive, extra, script.getAbsolutePath(),
                    "-f", logFilePath, "-b", bundlePath,
                    "-c", dbHost, "-p", dbPort, "-S", dbService, schemaUsername, schemaPassword)).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
            MtxDbUpgrade mtxDbUpgrade = new MtxDbUpgrade(properties);

            Whitebox.invokeMethod(mtxDbUpgrade, "setParams", properties);
            boolean actual = mtxDbUpgrade.runDbUpgrade();
            Assert.assertEquals(false, actual);
        } catch (IOException | InterruptedException e) {
            fail("Exception should not throw");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
