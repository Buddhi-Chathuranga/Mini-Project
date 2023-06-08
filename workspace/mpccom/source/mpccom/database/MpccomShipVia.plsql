-----------------------------------------------------------------------------
--
--  Logical unit: MpccomShipVia
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  150108  Erlise   Added Procedure Exist_With_Wildcard.
--  130603  MaMalk   Added attribute Transport_Unit_Type and also added missing public_rec and get methods
--  130603           for all the public attributes.
--  101206  UTSWLk   Added public attribute ext_transport_calendar_id.
--  100429  Ajpelk   Merge rose method documentation
------------------------------Eagle------------------------------------------
--  070426  ChBalk   Made SUBSTR the variable which holds the value from Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060816  MaMalk   Replaced the method call Basic_Data_Translation_API.Insert_Prog_Translation with 
--  060816           Basic_Data_Translation_API.Insert_Basic_Data_Translation.  
--  060728  ChJalk   Added Function Get_Description_Per_Language and removed call to Mpccom_Ship_Via_Desc_API.
--  060724  ChBalk   Added attribute Description and  public method GetDescription to the class,
--                   and moved mpccom_ship_via_lov, mpccom_ship_via_pub views from Mpccom_Ship_Via_Desc_API  
--                   during the process of making ship via code language independent.
--                   Added Get_Mode_Of_Transport public method.
--  -------------------------------13.4.0--------------------------------------
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040224  SaNalk  Removed SUBSTRB.
--  -----------------------Version 13.3.0--------------------------------------
--  030918  NAWALK  Changed the Prompt 'Mode of transport' into 'Ship Via Code'.
--  000925  JOHESE  Added undefines.
--  000418  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  990506  DAZA    General performance improvements. Added NOCHECK to VIEW2.
--  990412  FRDI    Upgraded to performance optimized template.
--  981012  JOED    Added mode_of_transport
--  971121  TOOS    Upgrade to F1 2.0
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970430  PEKR    Changed Get_Home_Company to Get_Language in VIEW.
--  970313  MAGN    Changed tablename ship_via to mpccom_ship_via_tab.
--  970226  MAGN    Uses column rowversion as objversion(timestamp).
--  961214  JOKE    Modified with new workbench default templates.
--  961202  JOBE    Additional modifications for compatibility with workbench.
--  961111  JOKE    Modified for compatibility with workbench.
--  960813  MAOS    Put procedure Internal_Check_Delete in comments.
--  960813  MAOS    Removed Get_Description_Vendor.
--  960517  AnAr    Added purpose comment to file.
--  960430  SHVE    Replaced selects to Customer_address and Oeorder_header with
--                  calls to functions in the respective LU's.
--  960412  SHVE    Added View from old track. Changed view name from GEN_SHIP_VIA_CODE_LANG_LOV to
--                  MPCCOM_SHIP_VIA_LANG_LOV
--  960320  SHVE    Changed Internal_Check_Delete___(select from Vendor_location)
--  960307  SHVE    Changed LU Name GenShipViaCode.
--  960215  SHVE    Changed LU prompt, replaced GEN_SHIP_VIA_CODE_LOV with VIEW2.
--  951027  SHVE    Created a View for LOV.
--  951011  SHVE    Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MPCCOM_SHIP_VIA_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.ext_transport_calendar_id);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     MPCCOM_SHIP_VIA_TAB%ROWTYPE,
   newrec_     IN OUT MPCCOM_SHIP_VIA_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN 
      IF (NVL(oldrec_.ext_transport_calendar_id,database_SYS.string_null_) != newrec_.ext_transport_calendar_id) THEN
         Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.ext_transport_calendar_id);
      END IF;

      IF (oldrec_.ext_transport_calendar_id IS NOT NULL)
          AND (oldrec_.ext_transport_calendar_id != newrec_.ext_transport_calendar_id)
          AND (Work_Time_Calendar_Desc_API.Get_Max_End_Date(oldrec_.ext_transport_calendar_id) > Work_Time_Calendar_Desc_API.Get_Max_End_Date(newrec_.ext_transport_calendar_id)) THEN

         Client_SYS.Add_Info(lu_name_, 'CAL_EARLIEREND: The end date for calendar :P1 is earlier than for calendar :P2. This may affect outstanding orders.', 
                                       newrec_.ext_transport_calendar_id, oldrec_.ext_transport_calendar_id);
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT mpccom_ship_via_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Check_Not_Generated(newrec_.ext_transport_calendar_id);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     mpccom_ship_via_tab%ROWTYPE,
   newrec_ IN OUT mpccom_ship_via_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.ext_transport_calendar_id IS NOT NULL) 
       AND (newrec_.ext_transport_calendar_id != NVL(oldrec_.ext_transport_calendar_id, database_SYS.string_null_)) THEN
      Work_Time_Calendar_API.Check_Not_Generated(newrec_.ext_transport_calendar_id);
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
FUNCTION Get_Ext_Transport_Calendar_Id (
   ship_via_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (ship_via_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   RETURN super(ship_via_code_);
END Get_Ext_Transport_Calendar_Id;


@UncheckedAccess
FUNCTION Get_Description (
   ship_via_code_ IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   CURSOR get_description IS
      SELECT description
        FROM MPCCOM_SHIP_VIA_TAB
       WHERE ship_via_code = ship_via_code_;

   description_      MPCCOM_SHIP_VIA_TAB.description%TYPE;
BEGIN
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('MPCCOM',
                                                                                'MpccomShipVia',
                                                                                ship_via_code_,
                                                                                language_code_), 1, 35);
   
   IF (description_ IS NULL) THEN
      OPEN get_description;
      FETCH get_description INTO description_;
      CLOSE get_description;
   END IF;
   RETURN description_;
END Get_Description;


@UncheckedAccess
FUNCTION Get_Description_Per_Language (
   ship_via_code_ IN VARCHAR2,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_      MPCCOM_SHIP_VIA_TAB.description%TYPE;
BEGIN
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('MPCCOM',
                                                                                'MpccomShipVia',
                                                                                ship_via_code_,
                                                                                language_code_), 1, 35);
   RETURN description_;
END Get_Description_Per_Language;


-- Get_Control_Type_Value_Desc
--   Gets the description for specific ship via code.
--   This method is exclusively used when setting up and
--   modifying the accounting rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;


-- Exist_With_Wildcard
--   Give an error if the given contract is not allowed for given site.
--   Contract parameter support wildcards
PROCEDURE Exist_With_Wildcard (
   ship_via_code_ IN VARCHAR2)
IS
   dummy_ NUMBER;
   exist_ BOOLEAN;

   CURSOR exist_control IS
      SELECT 1
      FROM MPCCOM_SHIP_VIA_TAB
      WHERE ship_via_code LIKE NVL(ship_via_code_, '%');
BEGIN
   IF (INSTR(NVL(ship_via_code_,'%'), '%') = 0) THEN
      --No wildcard
      Exist(ship_via_code_);
   ELSE
      --Wildcard
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      exist_ := exist_control%FOUND;
      CLOSE exist_control;

      IF (NOT exist_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'WILDNOTEXIST: Search criteria :P1 does not match any Ship Via Code.', ship_via_code_);
      END IF;
   END IF;
END Exist_With_Wildcard;
