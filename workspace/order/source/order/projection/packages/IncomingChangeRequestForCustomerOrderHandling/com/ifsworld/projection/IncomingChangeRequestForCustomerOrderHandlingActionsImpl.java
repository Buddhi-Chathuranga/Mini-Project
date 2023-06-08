/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: IncomingChangeRequestForCustomerOrderHandling
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
 * Implementation class for all global actions defined in the IncomingChangeRequestForCustomerOrderHandling projection model.
 */

@Stateless(name="IncomingChangeRequestForCustomerOrderHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class IncomingChangeRequestForCustomerOrderHandlingActionsImpl extends IncomingChangeRequestForCustomerOrderHandlingActionsFragmentsWrapper implements IncomingChangeRequestForCustomerOrderHandlingActions {
}