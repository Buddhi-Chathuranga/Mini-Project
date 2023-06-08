import ifs.installer.*;
import ifs.installer.logging.*;
import ifs.installer.util.*;
import org.junit.*;
import org.junit.runner.*;
import org.mockito.*;
import org.powermock.core.classloader.annotations.*;
import org.powermock.modules.junit4.*;
import org.junit.Test;
import java.io.*;
import java.util.logging.*;

import static org.junit.Assert.*;
import static org.powermock.api.mockito.PowerMockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest({System.class, Helper.class})
public class ValidatorTest {
    private static final Logger logger = InstallerLogger.getLogger();

    @Before
    public void setUp() {
        mockStatic(Helper.class);
        mockStatic(System.class);
    }

    //@Test
    public void testIsHelmInstalled() {
        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        String[] command = new String[]{"cmd.exe", "/C", "helm", "version"};

        try {
            when(Helper.runProcessWithResult(new File("").getAbsolutePath(), command)).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            Validator validator = new Validator();
            boolean result = validator.isHelmInstalled();
            assertEquals(true, result);


            when(process.exitValue()).thenReturn(1);
            result = validator.isHelmInstalled();
            assertEquals(false, result);

        } catch (IOException e) {
            fail("Exception should not throw");
        } catch (InterruptedException e) {
            fail("Exception should not throw");
        }
        try {
            when(Helper.runProcessWithResult(new File("").getAbsolutePath(), command)).thenThrow(new IOException());
            Validator validator = new Validator();
            validator.isHelmInstalled();

        } catch (IOException e) {
            assertTrue(true);
        } catch (InterruptedException e) {
            fail();
        }
    }

    //@Test
    public void testIsKubectlInstalled() {

        when(System.getProperty("os.name")).thenReturn("WINDOWS");
        ProcessResult processResult = mock(ProcessResult.class);
        Process process = mock(Process.class, Mockito.CALLS_REAL_METHODS);
        String[] command = new String[]{"cmd.exe", "/C", "kubectl", "version", "--client"};

        try {
            when(Helper.runProcessWithResult(new File("").getAbsolutePath(), command)).thenReturn(processResult);
            when(processResult.getProcess()).thenReturn(process);
            when(process.exitValue()).thenReturn(0);
            Validator validator = new Validator();
            boolean result = validator.isKubectlInstalled();
            assertEquals(true, result);


            when(process.exitValue()).thenReturn(1);
            result = validator.isKubectlInstalled();
            assertEquals(false, result);

        } catch (IOException e) {
            fail("Exception should not throw");
        } catch (InterruptedException e) {
            fail("Exception should not throw");
        }

        try {
            when(Helper.runProcessWithResult(new File("").getAbsolutePath(), command)).thenThrow(new IOException());
            Validator validator = new Validator();
            validator.isKubectlInstalled();

        } catch (IOException e) {
            assertTrue(true);
        } catch (InterruptedException e) {
            fail();
        }
    }
}