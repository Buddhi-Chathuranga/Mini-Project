/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: InventoryPartPlanningDataHandling
 *  Type:         Entity
 *  Component:    INVENT
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.io.InputStream;
import java.sql.Connection;
import java.util.Map;

/*
 * Implementation class for all global actions defined in the InventoryPartPlanningDataHandling projection model.
 */

@Stateless(name="InventoryPartPlanningDataHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class InventoryPartPlanningDataHandlingActionsImpl extends InventoryPartPlanningDataHandlingActionsFragmentsWrapper implements InventoryPartPlanningDataHandlingActions {
}