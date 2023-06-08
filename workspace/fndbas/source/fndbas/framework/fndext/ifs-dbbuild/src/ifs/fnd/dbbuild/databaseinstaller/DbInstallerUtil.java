/*=====================================================================================
 * DbInstallerUtil.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import ifs.fnd.dbbuild.DatabaseInstaller;
import java.sql.*;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.logging.*;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;
import org.netbeans.api.lexer.Token;
import org.netbeans.api.lexer.TokenSequence;

/**
 *
 * @author mabose
 */
public class DbInstallerUtil {

    public static HashMap<String, String> dependencyMap = new HashMap<>();
    public static HashMap<String, String> componentsMap = new HashMap<>();
    public static HashMap<String, String> passwordsMap = new HashMap<>();
    public static int defaultMaxThreads = 1500;
    public static int defaultMaxSessions = 40;
    public static int defaultMaxSelectedRows = 1000;
    public static boolean dependeciesLoaded = false;
    public static boolean askQuestionsMultiRun = true;
    public static boolean multiRun = false;
    public static long silentWaitingTime;
    public static DatabaseInstaller databaseInstaller;
    public static String logonError;
    private static String lineSeparator = System.getProperty("line.separator", "\n");
    private static String listSqlPlus = "DEFINE,DEF,DEFI,DEFIN,UNDEFINE,UNDEF,PROMPT,SHOW,EXECUTE,EXEC,SET,";
    private static String listPlSqlKeywords = "%FOUND,READ,OUT,%ROWTYPE,"
            + "BFILE,BINARY_INTEGER,BLOB,BOOLEAN,CHAR,CLOB,DATE,FLOAT,INTEGER,LONG,"
            + "MLSLABEL,NCHAR,NCLOB,NUMBER,NVARCHAR2,PLS_INTEGER,RAW,ROWID,VARCHAR2,"
            + "WHEN,PACKAGE,CREATE,FUNCTION,IS,RETURN,RETURNING,BEGIN,END,EXCEPTION,WHEN,THEN,"
            + "PROCEDURE,EXIT,BODY,REPLACE,ACCESS,ACTIVATE,ADD,ADMIN,AFTER,ALL,ALLOCATE,ALL_ROWS,"
            + "ALTER,ANALYZE,AND,ANY,ARRAY,AS,ASC,AT,AUDIT,AUTHENTICATED,AUTHORIZATION,AUTOEXTEND,"
            + "AUTOMATIC,BACKUP,BECOME,BEFORE,BETWEEN,BITMAP,BLOCK,BY,CACHE,CANCEL,CASCADE,CAST,"
            + "CFILE,CHAINED,CHANGE,CHARACTER,CHAR_CS,CHECK,CHECKPOINT,CHOOSE,CHUNK,CLEAR,CLUSTER,"
            + "COALESCE,COLUMN,COLUMNS,COMMENT,COMMIT,COMPATIBILITY,COMPILE,COMPLETE,COMPRESS,"
            + "COMPUTE,CONNECT,CONSTRAINT,CONSTRAINTS,CONTENTS,CONTINUE,CONTROLFILE,COST,CURRENT,"
            + "CURSOR,CYCLE,DANGLING,DATABASE,DATAFILE,DBA,DEALLOCATE,DEBUG,DEFERRABLE,DEFERRED,"
            + "DEGREE,DELETE,DESC,DIRECTORY,DISABLE,DISCONNECT,DISTINCT,DISTRIBUTED,DOUBLE,DROP,"
            + "EACH,ENABLE,ENFORCE,ENTRY,ESCAPE,ESTIMATE,EVENTS,EXCEPTIONS,EXCHANGE,EXCLUDING,"
            + "EXCLUSIVE,EXISTS,EXPIRE,EXPLAIN,EXTENT,EXTENTS,EXTERNALLY,FAST,FILE,"
            + "FIRST_ROWS,FLUSH,FORCE,FOREIGN,FOUND,FREELIST,FREELISTS,FROM,FULL,GLOBAL,GLOBAL_NAME,"
            + "GRANT,GROUP,GROUPS,HASH,HASHKEYS,HAVING,HEADER,HEAP,IDENTIFIED,IDLE_TIME,IMMEDIATE,"
            + "IN,INCLUDING,INCREMENT,INDEX,INDEXED,INDEXES,INDICATOR,IND_PARTITION,INITIAL,"
            + "INITIALLY,INITRANS,INSERT,INSTANCE,INSTANCES,INSTEAD,INTERSECT,INTO,IS NULL,ISOLATION,"
            + "ISOLATION_LEVEL,KEEP,KEY,KILL,LAYER,LESS,LEVEL,LIBRARY,LIKE,LIMIT,LINK,LIST,"
            + "LOB,LOCAL,LOCK,LOGFILE,LOGGING,MASTER,MAXEXTENTS,MEMBER,MERGE,MINEXTENTS,MINIMUM,MINUS,"
            + "MINVALUE,MODE,MODIFY,MOUNT,MOVE,MULTISET,NATIONAL,NCHAR_CS,NEEDED,NESTED,NETWORK,"
            + "NEXT,NLS_CALENDAR,NLS_CHARACTERSET,NLS_ISO_CURRENCY,NLS_LANGUAGE,NLS_NUMERIC_,"
            + "NLS_SORT,NLS_TERRITORY,NOARCHIVELOG,NOAUDIT,NOCACHE,NOCOMPRESS,NOCYCLE,NOFORCE,"
            + "NOLOGGING,NOMAXVALUE,NOMINVALUE,NONE,NOORDER,NOOVERIDE,NOPARALLEL,NORESETLOGS,"
            + "NOREVERSE,NORMAL,NOSORT,NOT,NOTHING,NOWAIT,NULL,NUMERIC,OBJECT,OF,OFF,OFFLINE,OID,"
            + "OIDINDEX,OLD,ON,ONLINE,ONLY,OPCODE,OPEN,OPTIMAL,OPTIMIZER_GOAL,OPTION,OR,ORDER,"
            + "OVERFLOW,OWN,PARALLEL,PARTITION,PASSWORD,PCTFREE,PCTINCREASE,PCTUSED,PERMANENT,"
            + "PLAN,PLSQL_DEBUG,PRECISION,PRESERVE,PRIMARY,PRIOR,PRIVATE,PRIVILEGE,PRIVILEGES,"
            + "PROFILE,PUBLIC,PURGE,QUEUE,QUOTA,RANGE,REBUILD,RECOVER,RECOVERABLE,RECOVERY,REF,"
            + "REFERENCES,REFERENCING,REFRESH,RENAME,RESET,RESETLOGS,RESIZE,RESOURCE,RESTRICTED,"
            + "REUSE,REVERSE,REVOKE,ROLE,ROLES,ROLLBACK,ROW,ROWLABEL,ROWNUM,ROWS,RULE,SAMPLE,"
            + "SAVEPOINT,SCHEMA,SCOPE,SELECT,SEQUENCE,SERIALIZABLE,SESSION,SHARE,SHARED,"
            + "SHARED_POOL,SHRINK,SIZE,SNAPSHOT,SOME,SORT,SPECIFICATION,SPLIT,SQLERROR,SQL_TRACE,"
            + "STANDBY,START,STATEMENT_ID,STATISTICS,STOP,STORAGE,STORE,STRUCTURE,SUCCESSFUL,"
            + "SWITCH,SYNONYM,SYSDBA,SYSOPER,SYSTEM,TABLE,TABLES,TABLESPACE,TEMPORARY,THAN,THE,"
            + "TIME,TIMESTAMP,TO,TRACE,TRACING,TRANSACTION,TRANSITIONAL,TRIGGER,TRIGGERS,TRUNCATE,"
            + "TYPE,UNDER,UNDO,UNION,UNIQUE,UNLIMITED,UNLOCK,UNRECOVERABLE,UNTIL,UNUSABLE,UNUSED,"
            + "UPDATABLE,UPDATE,USAGE,USE,USING,VALIDATE,VALIDATION,VALUE,VALUES,VARCHAR,VARRAY,"
            + "VARYING,VIEW,WHENEVER,WHERE,WITH,WITHOUT,WORK,ARRAYLEN,CASE,CLOSE,CONSTANT,CURRVAL,"
            + "DEBUGOFF,DEBUGON,DECLARE,DEFAULT,DEFINTION,DELAY,DIGITS,DISPOSE,DO,ELSE,ELSIF,"
            + "EXCEPTION_INIT,FALSE,FETCH,FOR,FORM,GENERIC,GOTO,IF,INTERFACE,LIMITED,LOOP,NEXTVAL,"
            + "PRAGMA,RAISE,RECORD,RELEASE,ROWTYPE,SIGNTYPE,SPACE,SQL,STATEMENT,SUBTYPE,TASK,"
            + "TERMINATE,TRUE,VIEWS,WHILE,ASCENDING,OTHERS,DESCENDING,NOCOPY,NATURAL,"
            + "JAVA,SOURCE,NAMED,BULK,COLLECT,EDITIONABLE,NONEDITIONABLE,";

    public static boolean isRunningThreads() {
      boolean runningThreads = false;
      for (Iterator components = DbInstallerUtil.componentsMap.values().iterator(); components.hasNext();) {
         String componentState = components.next().toString();
         if (!("Done".equals(componentState) || "Last".equals(componentState) || "LastAlreadyExists".equals(componentState))) {
            runningThreads = true;
            break;
         }
      }
      return runningThreads;
    }

    public static int getLineNoForOffset(Document doc, int offset) {
        int count = 1;
        try {
            int nextPos;
            String s = doc.getText(0, doc.getLength());
            for (int startPos = 0; startPos < s.length(); startPos = nextPos + 1) {
                nextPos = s.indexOf('\n', startPos);
                if (((offset >= startPos) && (offset <= nextPos)) || (nextPos == -1)) {
                    break;
                }

                count++;
            }
        } catch (BadLocationException ex) {
            System.err.println(ex.toString());
        }
        return count;
    }

    public static String readLine(TokenSequence<PlsqlTokenId> ts, Token<PlsqlTokenId> token) {
        String line = token.toString();
        while (ts.moveNext()) {
            token = ts.token();
            if (token.id() == PlsqlTokenId.WHITESPACE && token.text().toString().contains("\n")) {
                ts.movePrevious();
                break;
            }
            line = line + token.toString();
        }
        return line;
    }

    public static String getListSqlPlus() {
        return listSqlPlus;
    }

    public static String getListPlSqlKeywords() {
        return listPlSqlKeywords;
    }
    public static void processDbmsOutputMessages(boolean outputs, Connection con, Logger logger, Logger errorLogger, DbInstallerWatcher dbInstallerWatcher, String fileName) {
        if (outputs &&
                con!=null) {
            String text = "BEGIN DBMS_OUTPUT.GET_LINE(?, ?); END;";
            CallableStatement stmt;
            stmt = null;
            try {
                if (!con.isClosed()) {
                    stmt = con.prepareCall(text);
                    stmt.registerOutParameter(1, java.sql.Types.VARCHAR);
                    stmt.registerOutParameter(2, java.sql.Types.NUMERIC);
                    int status = 0;
                    while (status == 0) {
                        stmt.execute();
                        String output = stmt.getString(1);
                        status = stmt.getInt(2);
                        if (status == 0 && outputs) {
                            logger.info(output);
                        }
                    }
                }
            } catch (SQLException e) {
                logger.warning("!!!Error while displaying dbms_output:");
                logger.warning(e.toString());
                StringBuilder errorMsg = new StringBuilder();
                String timeStamp = DbInstallerUtil.getDbTimestamp(con);
                errorMsg.append(lineSeparator).append("!!!Error deploying file ").append(fileName).append(" at ").append(timeStamp).append(lineSeparator);
                errorMsg.append("!!!Error while displaying dbms_output:").append(lineSeparator).append(e.toString()).append(lineSeparator);
                errorMsg.append(e.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                errorLogger.warning(errorMsg.toString());
                dbInstallerWatcher.addCompileErrorCounter();
            } finally {
                try {
                    if (stmt!=null) {
                        stmt.close();
                    }
                } catch (SQLException e) {
                }
            }
        }
    }
    public static String getDbTimestamp(Connection con) {
        String timeStamp = "empty";
        Statement stmt = null;
        if (con != null) {
            try {
                stmt = con.createStatement();
                stmt.setEscapeProcessing(false);
                String statement = "SELECT TO_CHAR(SYSDATE, value || ' HH24:MI:SS') FROM nls_session_parameters WHERE parameter = 'NLS_DATE_FORMAT'";
                ResultSet rs = stmt.executeQuery(statement);
                rs.next();
                timeStamp = rs.getString(1);
                rs.close();
            } catch (Exception ex) {
                timeStamp = "empty";
            } finally {
                try {
                    stmt.close();
                } catch (Exception ex) {
                   timeStamp = "empty";
                }
            }
        } else {
            timeStamp = "empty";
        }
        if ("empty".equals(timeStamp)) {
            Format formatter;
            formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();
            timeStamp = formatter.format(date);
        }
        return timeStamp;
    }
}
