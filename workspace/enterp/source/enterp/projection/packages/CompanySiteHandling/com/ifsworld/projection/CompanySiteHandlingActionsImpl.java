/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: CompanySiteHandling
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
 * Implementation class for all global actions defined in the CompanySiteHandling projection model.
 */

@Stateless(name="CompanySiteHandlingActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class CompanySiteHandlingActionsImpl extends CompanySiteHandlingActionsFragmentsWrapper implements CompanySiteHandlingActions {
}