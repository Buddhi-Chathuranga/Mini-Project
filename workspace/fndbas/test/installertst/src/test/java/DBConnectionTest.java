import ifs.installer.util.*;
import org.junit.Test;
import org.junit.runner.*;
import org.powermock.core.classloader.annotations.*;
import org.powermock.modules.junit4.*;

import java.security.*;
import java.sql.*;

import static org.mockito.Matchers.*;
import static org.mockito.Mockito.mock;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.powermock.api.mockito.PowerMockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest(DriverManager.class)
public class DBConnectionTest {
   // @Test
    public void testOpenConnection(){
        mockStatic(DriverManager.class);
        Connection connection = mock(Connection.class);
        mockStatic(AccessController.class);
        try {
            when(DriverManager.getConnection(anyString(), anyObject())).thenReturn(connection);
            DBConnection.openConnection("sys","password","");
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

    }

}
