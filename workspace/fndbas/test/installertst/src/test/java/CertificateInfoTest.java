import ifs.installer.util.*;
import org.junit.*;
import org.junit.Test;

public class CertificateInfoTest {
    @Test
    public void testAddGlobalForSolutionSet(){
        String certificate="certificate";
        String privateKey="privateKey";
        CertificateInfo ci=new CertificateInfo(certificate,privateKey);
        boolean res=ci.isSet();
        Assert.assertEquals(true, res);
        
    }
}
