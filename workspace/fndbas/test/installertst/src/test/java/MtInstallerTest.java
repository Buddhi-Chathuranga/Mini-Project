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
@PrepareForTest({System.class, Helper.class})
public class MtInstallerTest {


    private static final Logger logger = InstallerLogger.getLogger();
    private Map<String, String> envs = new HashMap<>();

    @Before
    public void setUp() {
        mockStatic(Helper.class);
        mockStatic(System.class);
    }

    //@Test
    public void testRunMtInstaller() throws NoSuchMethodException {
        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        File script;
        String action = null;
        String directive = "cmd.exe";
        String extra = "/C";
        envs.put("verbose", logger.getLevel() == Level.FINEST ? "on" : "off");
        script = new File("installers/mt-installer." + "cmd");
        logger.fine("calling mt-installer");
        try {
            when(Helper.runProcessWithResult(envs, new File("").getAbsolutePath(), false, directive, extra,
                    script.getAbsolutePath(), "mtinstaller")).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            MtInstaller mtInstaller = new MtInstaller();
            boolean obj = Whitebox.invokeMethod(mtInstaller, "runMtInstaller", "mtinstaller");

            assertEquals(true, obj);
        } catch (IOException e) {
            fail("Exception should not throw");
        } catch (InterruptedException e) {
            fail("Exception should not throw");
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    //@Test
    public void testRunDelete() throws Exception {
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

        } catch (IOException e) {
            fail("Exception should not throw");
        }
    }

    //@Test
    public void testStop() throws Exception {
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
                    script.getAbsolutePath(), "stop")).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            MtInstaller mtInstaller = new MtInstaller();
            boolean bool = Whitebox.invokeMethod(mtInstaller, "stop");
            assertEquals(bool, true);

        } catch (IOException e) {
            fail("Exception should not throw");
        }
    }

    //@Test
    public void testDryRun() throws Exception {
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
                    script.getAbsolutePath(), "dryrun")).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            MtInstaller mtInstaller = new MtInstaller();
            boolean res = Whitebox.invokeMethod(mtInstaller, "dryRun");
            assertEquals(res, true);

        } catch (IOException e) {
            fail("Exception should not throw");
        }
    }

    //@Test
    public void testInstall() throws Exception {
        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        ProcessResult processResult1 = mock(ProcessResult.class);

        Process process1 = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);

        File script;
        String action = null;
        String directive = "cmd.exe";
        String extra = "/C";
        envs.put("verbose", logger.getLevel() == Level.FINEST ? "on" : "off");
        script = new File("installers/mt-installer." + (Helper.IS_WINDOWS ? "cmd" : "sh"));
        logger.fine("calling mt-installer");
        try {
            MtInstaller mtInstaller = new MtInstaller();
            testRunMtInstaller();
            when(Helper.runProcessWithResult(envs, new File("").getAbsolutePath(), false, directive, extra,
                    script.getAbsolutePath(), "create-namespace")).thenReturn(processResult1);
            when(processResult1.getProcess()).thenReturn(process1);
            when(process1.exitValue()).thenReturn(0);
            Whitebox.invokeMethod(mtInstaller, "createNamespace");
            envs = new HashMap<>();
            String ip = Whitebox.invokeMethod(mtInstaller, "getKubernetesIp", (envs.getOrDefault("kubeconfigFlag", "")));
            String helmArgs = envs.get("helmArgs");
            helmArgs = "--set ifscore.networkpolicy.allowKubernetes=".concat(ip).concat("/24 ") + helmArgs;
            envs.put("helmArgs", helmArgs);
            String[] kc = new String[0];
            String result = "";
            when(Helper.runProcessWithResult(new File("").getCanonicalPath(), "kubectl", "get", "endpoints",
                    "--namespace", "default", "kubernetes", "-o", "yaml", kc[0], kc[1]).getResult()).thenReturn(result);
            mtInstaller.install(true);
        } catch (IOException e) {
            fail("Exception should not throw");
        } catch (InterruptedException e) {
            fail("Exception should not throw");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testCreateNamespace() throws Exception {
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
                    script.getAbsolutePath(), "create-namespace")).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            MtInstaller mtInstaller = new MtInstaller();
            Whitebox.invokeMethod(mtInstaller, "createNamespace");
        } catch (IOException e) {
            fail("Exception should not throw");
        }
    }

    @Test
    public void testAddGlobalForSolutionSet() throws IOException {
        Map<String, Object> props;
        props = ArgumentParser.parse("--values", "src"+File.separator+"test"+File.separator+"resources"+File.separator+"solutionset.yaml");
        try {
            new MtInstaller().addGlobalForSolutionSet(new HashMap<>(), props, "");
        } catch (Exception e) {
            fail("Exception should not throw");
        }
    }

}
