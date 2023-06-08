/*=====================================================================================
 * DbInstallerWatcher.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.sql.*;
import java.util.HashMap;
import java.util.Iterator;

/**
 *
 * @author mabose
 */
public class DbInstallerWatcher {

    private int threadCounterAll, threadCounterInternal, sessionCounter, compileErrorCounter;
    public int maxSessions;
    private HashMap<String, String> components = new HashMap<>();

    /**
     * Constructor
     * @param con Connection
     */
    public DbInstallerWatcher(Connection con) {
        maxSessions = DbPrepareDeploy.getNumOfSessions(con);
    }

    public void addThread(String component) {
        components.put(component, "Running");
    }

    public void completeThread(String component) {
        if (components.containsKey(component)) {
            components.put(component, "Completed");
        }
    }

    public String removeThread() {
        if (components.containsValue("Completed")) {
            Iterator componentlist = components.keySet().iterator();
            boolean found = false;
            String component = "-1";
            while (componentlist.hasNext()
                    && !found) {
                component = componentlist.next().toString();
                if (components.get(component).equals("Completed")) {
                    found = true;
                }
            }
            if (found) {
                components.remove(component);
                return component;
            } else {
                return "-1";
            }
        }
        return "-1";
    }

    /**
     * Method for returning the number of open threads
     * @return int
     */
    public int getThreadCounterAll() {
        return threadCounterAll;
    }

    /**
     * Method for returning the number of open threads
     * @return int
     */
    public int getThreadCounterInternal() {
        return threadCounterInternal;
    }

    /**
     * Method for returning the number of counted sessions
     * @return int
     */
    public int getSessionCounter() {
        return sessionCounter;
    }

    /**
     * Method for returning the number of compilation errors
     * @return int
     */
    public int getCompileErrorCounter() {
        return compileErrorCounter;
    }

    /**
     * Method for resetting the number of open threads, sessions and errors
     */
    public void resetThreadCounters() {
        threadCounterAll = 0;
        threadCounterInternal = 0;
        sessionCounter = 0;
        compileErrorCounter = 0;
    }

    /**
     * Method that increases the number of open threads by one
     */
    public void addToThreadCounterAll() {
        threadCounterAll++;
    }

    /**
     * Method that increases the number of open threads by one
     */
    public void addToThreadCounterInternal() {
        threadCounterInternal++;
    }

    /**
     * Method that increases the number of counted sessions by one
     */
    public void addToSessionCounter() {
        sessionCounter++;
    }

    /**
     * Method that increases the number of counted compilation errors by one
     */
    public void addCompileErrorCounter() {
        compileErrorCounter++;
    }

    /**
     * Method that decreases the number of open threads by one
     */
    public void removeFromThreadCounterAll() {
        threadCounterAll--;
        if (threadCounterAll < 0) {
            threadCounterAll = 0;
        }
    }

    /**
     * Method that decreases the number of open threads by one
     */
    public void removeFromThreadCounterInternal() {
        threadCounterInternal--;
        if (threadCounterInternal < 0) {
            threadCounterInternal = 0;
        }
    }

    /**
     * Method that decreases the number of counted sessions by one
     */
    public void removeFromSessionCounter() {
        sessionCounter--;
        if (sessionCounter < 0) {
            sessionCounter = 0;
        }
    }

    /**
     * Method that decreases the number of counted compilation errors by one
     */
    public void removeCompileErrorCounter() {
        compileErrorCounter--;
        if (compileErrorCounter < 0) {
            compileErrorCounter = 0;
        }
    }
}
