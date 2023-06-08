/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: CustomerOrdersHandling
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
 * Implementation class for all global actions defined in the CustomerOrdersHandling projection model.
 */

@Stateless(name="CustomerOrdersHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class CustomerOrdersHandlingActionsImpl extends CustomerOrdersHandlingActionsFragmentsWrapper implements CustomerOrdersHandlingActions {
}