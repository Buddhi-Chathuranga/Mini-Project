/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: SupplierHandling
 *  Type:         EntityWithState
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
 * Implementation class for all global actions defined in the SupplierHandling projection model.
 */

@Stateless(name="SupplierHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class SupplierHandlingActionsImpl extends SupplierHandlingActionsFragmentsWrapper implements SupplierHandlingActions {
}