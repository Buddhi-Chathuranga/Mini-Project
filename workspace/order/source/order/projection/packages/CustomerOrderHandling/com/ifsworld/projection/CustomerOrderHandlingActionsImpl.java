/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: CustomerOrderHandling
 *  Type:         Entity
 *  Component:    ORDER
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
 * Implementation class for all global actions defined in the CustomerOrderHandling projection model.
 */

@Stateless(name="CustomerOrderHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class CustomerOrderHandlingActionsImpl extends CustomerOrderHandlingActionsFragmentsWrapper implements CustomerOrderHandlingActions {
}