/*
 *  IFS Research & Development
 *
 * This program is protected by copyright law and by international
 * conventions. All licensing, renting, lending or copying (including
 * for private use), and all other use of the program, which is not
 * expressively permitted by IFS Research & Development (IFS), is a
 * violation of the rights of IFS. Such violations will be reported to the
 * appropriate authorities.
 *
 * VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 * TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 *
 * Copyright (C) 2020 IFS World Operations.
 *
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.Map;

/**
 *
 * @author rakuse
 *
 * Defines the syntax for SolutionSet configuration. Same class is cloned and
 * used, apart from DevStudio, by following products/teams:
 *
 * 1. Installer - IFS Cloud 2.DB Installer (CreateInstallTem.java)
 *
 * Any changes done here must be be aligned with these teams as well.
 */
public class SolutionSet {

    private String solutionSetId;
    private String solutionSetName;
    private Map<String, Boolean> coreComponents;
    private Map<String, Boolean> customComponents;

    public String getSolutionSetId() {
        return solutionSetId;
    }

    public void setSolutionSetId(String solutionSetId) {
        this.solutionSetId = solutionSetId;
    }

    public String getSolutionSetName() {
        return solutionSetName;
    }

    public void setSolutionSetName(String solutionSetName) {
        this.solutionSetName = solutionSetName;
    }

    public Map<String, Boolean> getCoreComponents() {
        return coreComponents;
    }

    public void setCoreComponents(Map<String, Boolean> components) {
        this.coreComponents = components;
    }

    public Map<String, Boolean> getCustomComponents() {
        return customComponents;
    }

    public void setCustomComponents(Map<String, Boolean> components) {
        this.customComponents = components;
    }
}
