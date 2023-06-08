/*=====================================================================================
 * DbPrepareDeploy.java
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
import java.util.Iterator;
import java.util.logging.*;

/**
 *
 * @author mabose
 */
public class DbPrepareDeploy {

    private static String lineSeparator = System.getProperty("line.separator", "\n");

    public static int getNumOfSessions(Connection con) {
        int numOfSessions = DbInstallerUtil.defaultMaxSessions;
        if (con!=null) {
            Statement stmt = null;
            try {
                if (!con.isClosed()) {
                    stmt = con.createStatement();
                    stmt.setEscapeProcessing(false);
                    ResultSet rs;
                    for ( rs = stmt.executeQuery("SELECT NVL(MIN(TO_NUMBER(VALUE)),0) FROM v$parameter WHERE name IN ('processes', 'sessions')"); rs.next();) {
                        numOfSessions = rs.getInt(1) / 5;
                        if (numOfSessions < 1) {
                            numOfSessions = DbInstallerUtil.defaultMaxSessions;
                        }
                    }
                    rs.close();
                }
            } catch (SQLException | NumberFormatException ex) {
                numOfSessions = DbInstallerUtil.defaultMaxSessions;
            } finally {
                try {
                    if (stmt!=null) {
                        stmt.close();
                    }
                } catch (SQLException ex) {
                }
            }
        }
        return numOfSessions;
    }

    /**
     * Method that loads the dependencies between the components, source module_dependency_tab
     * @param con Connection
     * @param logger Logger
     * @param errorLogger Logger
     * @param dbInstallerWatcher DbInstallerWatcher
     * @return boolean
     */
    public static boolean loadDependenciesFromDb(Connection con, Logger logger, Logger errorLogger, DbInstallerWatcher dbInstallerWatcher) {
        if (DbInstallerUtil.dependeciesLoaded) {
            for (Iterator components = DbInstallerUtil.componentsMap.keySet().iterator(); components.hasNext();) {
                String component = components.next().toString();
                if (DbInstallerUtil.componentsMap.get(component).equals("Done")) {
                    DbInstallerUtil.componentsMap.put(component, "AlreadyExists");
                }
            }
        } else {
            if (con!=null) {
                boolean dependeciesLoaded = true;
                Statement stmt = null;
                try {
                    stmt = con.createStatement();
                    stmt.setEscapeProcessing(false);
                    ResultSet rs;
                    for (rs = stmt.executeQuery("SELECT module FROM module_tab WHERE NVL(VERSION, '*') != '*'"); rs.next();) {
                        String module = rs.getString("MODULE").toUpperCase();
                        DbInstallerUtil.componentsMap.put(module, "AlreadyExists");
                    }
                    rs.close();
                } catch (SQLException sqle) {
                    dependeciesLoaded = false;
                    if (sqle.getMessage().contains("ORA-00942")) {
                        logger.info(new StringBuilder("This user does not have access to the component information! Threaded deployment is not possible").append(lineSeparator).toString());
                    }
                } catch (Exception e) {
                    dependeciesLoaded = false;
                } finally {
                    try {
                        if (stmt!=null) {
                            stmt.close();
                        }
                    } catch (SQLException ex) {
                    }
                }
                if (dependeciesLoaded) {
                    try {
                        stmt = con.createStatement();
                        stmt.setEscapeProcessing(false);
                        String query = "SELECT COUNT(*) "
                                    +  "FROM module_dependency_tab START WITH dependent_module IN "
                                    +  "(SELECT module FROM module_tab m "
                                    +  " WHERE NOT EXISTS "
                                    +  "(SELECT 1 "
                                    +  " FROM module_dependency_tab "
                                    +  " WHERE module = m.module "
                                    +  " AND dependency = 'STATIC')) "
                                    +  "CONNECT BY PRIOR MODULE = dependent_module AND dependency = 'STATIC'";
                        ResultSet rs;
                        rs = stmt.executeQuery(query);                        rs.close();
                    } catch (SQLException sqle) {
                        dependeciesLoaded = false;
                        if (sqle.getMessage().contains("ORA-01436")) {
                            logger.warning(new StringBuilder(lineSeparator).append("!!!Error loading component dependencies").append(lineSeparator).append("Infinite component dependency loop! Threaded deployment is not possible").append(lineSeparator).toString());
                            errorLogger.warning(new StringBuilder(lineSeparator).append("!!!Error loading component dependencies").append(lineSeparator).append("Infinite component dependency loop! Threaded deployment is not possible").append(lineSeparator).toString());
                            dbInstallerWatcher.addCompileErrorCounter();
                        }
                    } catch (Exception e) {
                        dependeciesLoaded = false;
                    } finally {
                        try {
                            if (stmt!=null) {
                                stmt.close();
                            }
                        } catch (SQLException ex) {
                        }
                    }
                }
                if (dependeciesLoaded) {
                    try {
                        stmt = con.createStatement();
                        stmt.setEscapeProcessing(false);
                        String query = "SELECT m.module \"MODULE\", NVL(md.dependent_module, 'NONE.') \"DEPENDENT_MODULE\", NVL(md.dependency, 'NONE') \"DEPENDENCY\" "
                                + "FROM module_tab m, module_dependency_tab md "
                                + "WHERE md.module (+) = m.module "
                                + "AND md.dependency (+) = 'STATIC' "
                                + "AND version != '*' "
                                + "UNION "
                                + "SELECT m.module \"MODULE\", 'FNDBAS' \"DEPENDENT_MODULE\", 'STATIC' \"DEPENDENCY\" "
                                + "FROM module_tab m, module_dependency_tab md "
                                + "WHERE md.module = m.module "
                                + "AND md.dependency = 'STATIC' "
                                + "AND NOT EXISTS "
                                + "(SELECT 1 "
                                + " FROM module_tab m2, module_dependency_tab md2 "
                                + " WHERE md2.dependent_module = m2.module "
                                + " AND md2.dependency = 'STATIC' "
                                + " AND md2.module = m.module)";
                        ResultSet rs;
                        for (rs = stmt.executeQuery(query); rs.next();) {
                            String module = rs.getString("MODULE").toUpperCase();
                            String dependentModule = rs.getString("DEPENDENT_MODULE").toUpperCase();
                            String dependency = rs.getString("DEPENDENCY").toUpperCase();
                            if ("NONE.".equals(dependentModule)) {
                                DbInstallerUtil.dependencyMap.put(module, dependentModule);
                            } else {
                                if (DbInstallerUtil.dependencyMap.containsKey(module)) {
                                    if (!DbInstallerUtil.dependencyMap.get(module).equals("NONE.")) {
                                        DbInstallerUtil.dependencyMap.put(module, DbInstallerUtil.dependencyMap.get(module) + (dependentModule + "." + dependency + ";"));
                                    }
                                } else {
                                    DbInstallerUtil.dependencyMap.put(module, (dependentModule + "." + dependency + ";"));
                                }
                            }
                        }
                        rs.close();
                        for (Iterator dependencies = DbInstallerUtil.dependencyMap.keySet().iterator(); dependencies.hasNext();) {
                            String componentCandidate = dependencies.next().toString();
                            String dependencyElements = DbInstallerUtil.dependencyMap.get(componentCandidate).toUpperCase();
                            if (!dependencyElements.contains(".STATIC")
                                    && !"FNDBAS".equals(componentCandidate.toUpperCase())) {
                                dependencyElements = "FNDBAS.STATIC;";
                                // A component cannot have only dynamic dependencies, at least a static dependency to Fndbas must exist
                                DbInstallerUtil.dependencyMap.put(componentCandidate.toUpperCase(), dependencyElements);
                            }
                        }
                    } catch (SQLException sqle) {
                        dependeciesLoaded = false;
                        if (sqle.getMessage().contains("ORA-00942")) {
                            logger.info(new StringBuilder("This user does not have access to the component dependencies information! Threaded deployment is not possible").append(lineSeparator).toString());
                        }
                    } catch (Exception e) {
                        dependeciesLoaded = false;
                    } finally {
                        try {
                            if (stmt!=null) {
                                stmt.close();
                            }
                        } catch (SQLException ex) {
                        }
                    }
                }
                DbInstallerUtil.dependeciesLoaded = dependeciesLoaded;
            }
        }
        return DbInstallerUtil.dependeciesLoaded;
    }
}
