/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: UserSettings
 *  Component:    FNDBAS
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
 * Implementation class for all global actions defined in the UserSettings projection model.
 */

@Stateless(name="UserSettingsActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class UserSettingsActionsImpl extends UserSettingsActionsFragmentsWrapper implements UserSettingsActions {
   
}
