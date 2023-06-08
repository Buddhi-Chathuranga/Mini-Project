-----------------------------------------------------------------------------
--
--  Logical unit: EnterpAddressCountry
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050903  Gepelk  IIDARDI124N. Argentinean Sales Tax
--  060605  Machlk  Added new parameters to PROCEDURE Set_Lov_Reverence.
--  060712  Kagalk  FIPL610A - Added column Detailed_Address.
--  111202  Chgulk  SFI-700, Merged Bug 99562.
--  120214  Umdolk  SFI-2071, Modified Sync_Addr_Countries___ to update project
--  121122  Nudilk  Bug 166926,Corrected in Sync_Addr_Countries___
--  211222  Kavflk  CRM21R2-425,Added BUSINESS_LEAD in Sync_Addr_Countries___.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
 
-------------------- PRIVATE DECLARATIONS -----------------------------------
       
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Sync_Addr_Countries___ (
   oldrec_ IN enterp_address_country_tab%ROWTYPE,
   newrec_ IN enterp_address_country_tab%ROWTYPE,
   action_ IN VARCHAR2 )
IS
   state_change_flag_    BOOLEAN;
   county_change_flag_   BOOLEAN;
   city_change_flag_     BOOLEAN;
BEGIN
   state_change_flag_  := FALSE;
   county_change_flag_ := FALSE;
   city_change_flag_   := FALSE;
   IF (action_ = 'Modify__') THEN
      IF (oldrec_.state_presentation != newrec_.state_presentation) THEN
         state_change_flag_ := TRUE;   
      END IF;
      IF (oldrec_.county_presentation != newrec_.county_presentation) THEN
         county_change_flag_ := TRUE;   
      END IF;
      IF (oldrec_.city_presentation != newrec_.city_presentation) THEN
         city_change_flag_ := TRUE;   
      END IF;
   ELSIF (action_ = 'New__') THEN
      state_change_flag_  := TRUE;
      county_change_flag_ := TRUE;
      city_change_flag_   := TRUE;
   END IF;
   IF (state_change_flag_ OR county_change_flag_ OR city_change_flag_) THEN
      Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                       newrec_.state_presentation,
                                                       newrec_.county_presentation,
                                                       newrec_.city_presentation,
                                                       'COMPANY',
                                                       state_change_flag_,
                                                       county_change_flag_,
                                                       city_change_flag_);
      Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                       newrec_.state_presentation,
                                                       newrec_.county_presentation,
                                                       newrec_.city_presentation,
                                                       'CUSTOMER',
                                                       state_change_flag_,
                                                       county_change_flag_,
                                                       city_change_flag_);
      Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                       newrec_.state_presentation,
                                                       newrec_.county_presentation,
                                                       newrec_.city_presentation,
                                                       'CUSTOMS',
                                                       state_change_flag_,
                                                       county_change_flag_,
                                                       city_change_flag_);
      Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                       newrec_.state_presentation,
                                                       newrec_.county_presentation,
                                                       newrec_.city_presentation,
                                                       'SUPPLIER',
                                                       state_change_flag_,
                                                       county_change_flag_,
                                                       city_change_flag_);
      Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                       newrec_.state_presentation,
                                                       newrec_.county_presentation,
                                                       newrec_.city_presentation,
                                                       'FORWARDER',
                                                       state_change_flag_,
                                                       county_change_flag_,
                                                       city_change_flag_);
      Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                       newrec_.state_presentation,
                                                       newrec_.county_presentation,
                                                       newrec_.city_presentation,
                                                       'MANUFACTURER',
                                                       state_change_flag_,
                                                       county_change_flag_,
                                                       city_change_flag_);
      Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                       newrec_.state_presentation,
                                                       newrec_.county_presentation,
                                                       newrec_.city_presentation,
                                                       'OWNER',
                                                       state_change_flag_,
                                                       county_change_flag_,
                                                       city_change_flag_);
      Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                       newrec_.state_presentation,
                                                       newrec_.county_presentation,
                                                       newrec_.city_presentation,
                                                       'PERSON',
                                                       state_change_flag_,
                                                       county_change_flag_,
                                                       city_change_flag_);
      $IF Component_Proj_SYS.INSTALLED $THEN
         Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                          newrec_.state_presentation,
                                                          newrec_.county_presentation,
                                                          newrec_.city_presentation,
                                                          'PROJECT',
                                                          state_change_flag_,
                                                          county_change_flag_,
                                                          city_change_flag_);                                                                  
      $END 
      $IF Component_Crm_SYS.INSTALLED $THEN
         Enterp_Addr_Country_Util_API.Sync_Addr_Countries(newrec_.country_code,
                                                          newrec_.state_presentation,
                                                          newrec_.county_presentation,
                                                          newrec_.city_presentation,
                                                          'BUSINESS_LEAD',
                                                          state_change_flag_,
                                                          county_change_flag_,
                                                          city_change_flag_);
      $END 
   END IF;
END Sync_Addr_Countries___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT enterp_address_country_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
BEGIN
   newrec_.detailed_address := NVL(newrec_.detailed_address, 'FALSE');
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALIDATE_STATE_CODE', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('VALIDATE_COUNTY_CODE', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('VALIDATE_CITY_CODE', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DETAILED_ADDRESS', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT enterp_address_country_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   temprec_ enterp_address_country_tab%ROWTYPE;
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Sync_Addr_Countries___(temprec_, newrec_, 'New__');
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     enterp_address_country_tab%ROWTYPE,
   newrec_     IN OUT enterp_address_country_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   key_ VARCHAR2(2000);
   CURSOR get_state IS
      SELECT state_code
      FROM   county_code_tab
      WHERE  country_code = oldrec_.country_code;

   CURSOR get_county IS
      SELECT state_code, county_code
      FROM   city_code_tab
      WHERE  country_code = oldrec_.country_code;
BEGIN
   key_ := oldrec_.country_code || '^';
   IF (newrec_.state_presentation = 'NOTUSED' AND oldrec_.state_presentation != 'NOTUSED') THEN
      Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
   END IF;
   IF (newrec_.state_presentation != 'NOTUSED' AND oldrec_.state_presentation = 'NOTUSED') THEN
      Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
   END IF;
   FOR state_val IN get_state LOOP
      key_ := oldrec_.country_code || '^' || state_val.state_code || '^';
      IF (newrec_.county_presentation = 'NOTUSED' AND oldrec_.county_presentation != 'NOTUSED') THEN
         Reference_SYS.Check_Restricted_Delete('StateCodes', key_);
      END IF;
      IF (newrec_.county_presentation != 'NOTUSED' AND oldrec_.county_presentation = 'NOTUSED') THEN
         Reference_SYS.Check_Restricted_Delete('StateCodes', key_);
      END IF;
   END LOOP;
   FOR county_val IN get_county LOOP
      key_ := oldrec_.country_code || '^' || county_val.state_code || '^' || county_val.county_code || '^';
      IF (newrec_.city_presentation = 'NOTUSED' AND oldrec_.city_presentation != 'NOTUSED') THEN
         Reference_SYS.Check_Restricted_Delete('CountyCode', key_);
      END IF;
      IF (newrec_.city_presentation != 'NOTUSED' AND oldrec_.city_presentation = 'NOTUSED') THEN
         Reference_SYS.Check_Restricted_Delete('CountyCode', key_);
      END IF;
   END LOOP;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Sync_Addr_Countries___(oldrec_, newrec_, 'Modify__');
END Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

