/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: CustomerHandling
 *  Type:         Entity
 *  Component:    ENTERP
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
 * Implementation class for all global actions defined in the CustomerHandling projection model.
 */

@Stateless(name="CustomerHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class CustomerHandlingActionsImpl extends CustomerHandlingActionsFragmentsWrapper implements CustomerHandlingActions {
}