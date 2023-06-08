/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: InventoryPartHandling
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
 * Implementation class for all global actions defined in the InventoryPartHandling projection model.
 */

@Stateless(name="InventoryPartHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class InventoryPartHandlingActionsImpl extends InventoryPartHandlingActionsFragmentsWrapper implements InventoryPartHandlingActions {
}