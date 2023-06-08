import ifs.installer.*;
import ifs.installer.component.*;
import ifs.installer.logging.*;
import ifs.installer.util.*;
import org.junit.Test;
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
@PrepareForTest({System.class,Helper.class})
public class DataImportTest {

    private String deliveryPath = "";
    private String userName = "";
    private String password = "";
    private String connectString = "";
    private String logFilePath = "";
    private String transRuntime = "";
    private String transImportAttributes = "";
    private String transImportTranslations = "";
    private static final Logger logger = InstallerLogger.getLogger();
    private Map<String, String> envs = new HashMap<>();
    @Before
    public void setUp() {
        mockStatic(Helper.class);
        mockStatic(System.class);
    }

    @Test
    public void TestSetParams() throws Exception {
        try {
            Map<String, Object> properties ;
            properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
            InstallerLogger.setLogfileLocation(
                    properties.containsKey("logFileLocation") ? (String) properties.get("logFileLocation")
                            : new File("").getAbsolutePath());
            deliveryPath = "deliveryPath=".concat((String) properties.getOrDefault("dbInstaller.deliveryPath", Helper.getDefaultDeliveryDir()));
            userName = "userName=".concat((String) properties.getOrDefault("ifscore.users.ifsappUser.data", "ifsapp"));
            password = !properties.containsKey("dbInstaller.ifsappPassword") ?
                    !properties.containsKey("ifscore.passwords.ifsappPassword.data") ? ""
                            : "password=".concat((String) properties.get("ifscore.passwords.ifsappPassword.data"))
                    : "password=".concat((String) properties.get("dbInstaller.ifsappPassword"));
            connectString = !properties.containsKey("dbInstaller.jdbcUrl") ?
                    !properties.containsKey("ifscore.secrets.jdbcUrl.data") ? ""
                            : "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"))
                    : "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
            logFilePath = "logFilePath=".concat(InstallerLogger.getLogfileLocation());
            transRuntime = !properties.containsKey("dbInstaller.transRuntime") ? ""
                    : "transRuntime=".concat((String) properties.get("dbInstaller.transRuntime"));
            transImportAttributes = !properties.containsKey("dbInstaller.transImportAttributes") ? ""
                    : "transImportAttributes=".concat((String) properties.get("dbInstaller.transImportAttributes"));
            transImportTranslations = !properties.containsKey("dbInstaller.transImportTranslations") ? ""
                    : "transImportTranslations=".concat((String) properties.get("dbInstaller.transImportTranslations"));
            DataImport dataImport = new DataImport(properties);
            Whitebox.invokeMethod(dataImport, "setParams", properties);

        } catch (Exception e) {
        }
}

    @Test
    public void testRunDataImport() throws NoSuchMethodException {
        mockStatic(Helper.class);
        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        File script;
        String action = null;
        String directive = "cmd.exe";
        String extra = "/C";
        envs.put("verbose", logger.getLevel() == Level.FINEST ? "on" : "off");
        script = new File("installers/db-import-data." + (Helper.IS_WINDOWS ? "cmd" : "sh"));
        logger.fine("calling db-import-data");
        try {
            Map<String, Object> properties;
            properties = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");

            InstallerLogger.setLogfileLocation(
                    properties.containsKey("C:\\logs") ? (String) properties.get("C:\\logs")
                            : new File("").getAbsolutePath());
            when(Helper.getDefaultDeliveryDir()).thenReturn("C:\\");
            deliveryPath = "deliveryPath=".concat((String) properties.getOrDefault("dbInstaller.deliveryPath", Helper.getDefaultDeliveryDir()));
            userName = "userName=".concat((String) properties.getOrDefault("ifscore.users.ifsappUser.data", "ifsapp"));
            password = !properties.containsKey("dbInstaller.ifsappPassword") ?
                    !properties.containsKey("ifscore.passwords.ifsappPassword.data") ? ""
                            : "password=".concat((String) properties.get("ifscore.passwords.ifsappPassword.data"))
                    : "password=".concat((String) properties.get("dbInstaller.ifsappPassword"));
            connectString = !properties.containsKey("dbInstaller.jdbcUrl") ?
                    !properties.containsKey("ifscore.secrets.jdbcUrl.data") ? ""
                            : "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"))
                    : "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
            logFilePath = "logFilePath=".concat(InstallerLogger.getLogfileLocation());
            transRuntime = !properties.containsKey("dbInstaller.transRuntime") ? ""
                    : "transRuntime=".concat((String) properties.get("dbInstaller.transRuntime"));
            transImportAttributes = !properties.containsKey("dbInstaller.transImportAttributes") ? ""
                    : "transImportAttributes=".concat((String) properties.get("dbInstaller.transImportAttributes"));
            transImportTranslations = !properties.containsKey("dbInstaller.transImportTranslations") ? ""
                    : "transImportTranslations=".concat((String) properties.get("dbInstaller.transImportTranslations"));
            logger.info("Running data import, logs location: " + logFilePath.substring("logFilePath=".length()).trim());

            when(Helper.runProcessWithResult("installers", directive, extra, script.getAbsolutePath(), deliveryPath, userName,
                    password, connectString, logFilePath, transRuntime, transImportAttributes, transImportTranslations)).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);

               DataImport dataImport = new DataImport(properties);
            boolean obj = Whitebox.invokeMethod(dataImport, "runDataImport");

            assertEquals(true, obj);

        } catch (IOException e) {
            fail("Exception should not throw");
        } catch (InterruptedException e) {
            fail("Exception should not throw");
        } catch (Exception e) {
            e.printStackTrace();
        }

   }
   // Test commit
}
