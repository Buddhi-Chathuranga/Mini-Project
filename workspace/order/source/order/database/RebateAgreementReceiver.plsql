-----------------------------------------------------------------------------
--
--  Logical unit: RebateAgreementReceiver
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170508  AmPalk   STRMF-11515, Added Update_Modified_Date.
--  170420  ThImlk   STRMF-10694, Added Prepare_Insert___() to set the default value as 1 for the Agreement Priority.
--  170321  ThImlk   STRMF-10343, Modified the method, Copy_All_Receivers__() to correctly pass the agreement priority value, when copying.  
--  170307  AmPalk   STRMF-6615, Modified Get_Active_Agreement to return a valid agreement list based on the customer-company level settings. 
--  170216  ThImlk   STRMF-8816, Added Validate_Agreement_Priority___() and call it from Check_Update___() and Check_Insert___() to correctly validate agreement priority value.
--  170214  ThImlk   STRMF-8814, Added, Check_Update___() and modified Check_Insert___() to set values on created_date and modified_date columns.
--  090731  HimRlk   Merged Bug 81261, Modified the CURSOR get_active_agreement in Method Get_Active_Agreement to consider
--  090731           the valid_to date when getting the valid agreement.
--  081016  JeLise   Removed check regarding hierarchy_in = '*' in Validate_Hierarchy_Level.
--  080919  JeLise   Added check in Validate_Hierarchy_Level.
--  080527  JeLise   Changed from CUSTOMERNOTFROMHIERARCHY to CUSTNOTFROMHIERARCHY in Validate_Hierarchy_Level.
--  080522  AmPalk   Added Validate_Hierarchy_Level.
--  080429  JeLise   Changed Get_Active_Agreement to return null if no Active agreement is found.
--  080417  MaJalk   Added method Copy_All_Receivers__.
--  080221  RiLase   Added parameter Validation_Date to frunction Get_Active_Agreement.
--  080212  RiLase   Added function Get_Active_Agreement
--  080205  JeLise   Added Check_Exist.
--  080125  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT rebate_agreement_receiver_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   Validate_Hierarchy_Level(newrec_.agreement_id, newrec_.customer_no);
   newrec_.created_date := sysdate;
   newrec_.modified_date := sysdate;
   Validate_Agreement_Priority___(newrec_.agreement_priority);
END Check_Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     rebate_agreement_receiver_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY rebate_agreement_receiver_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF(oldrec_.agreement_priority != newrec_.agreement_priority)THEN
      newrec_.modified_date := sysdate;
   END IF;
   Validate_Agreement_Priority___(newrec_.agreement_priority);
END Check_Update___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
    super(attr_);
    Client_SYS.Add_To_Attr('AGREEMENT_PRIORITY', 1, attr_);
END Prepare_Insert___;

PROCEDURE Validate_Agreement_Priority___ (
   agreement_priority_   IN  NUMBER )
IS
BEGIN
   IF (agreement_priority_ < 1) THEN
      Error_SYS.Record_general(lu_name_, 'AGPRIORITYERROR: Agreement priority cannot be less than or equal to zero.');
   END IF;
   IF (agreement_priority_  != TRUNC(agreement_priority_) ) THEN
      Error_SYS.Record_general(lu_name_, 'AGPRIORDECIERROR: Agreement priority cannot have a decimal value.');
   END IF;
END Validate_Agreement_Priority___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_All_Receivers__
--   Copies all receiver records from one agreement to another.
PROCEDURE Copy_All_Receivers__ (
   from_agreement_id_   IN VARCHAR2,
   to_agreement_id_     IN VARCHAR2 )
IS
   attr_            VARCHAR2(32000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   newrec_          REBATE_AGREEMENT_RECEIVER_TAB%ROWTYPE;
   indrec_          Indicator_Rec;

   CURSOR    source IS
      SELECT *
      FROM REBATE_AGREEMENT_RECEIVER_TAB
      WHERE agreement_id = from_agreement_id_;
BEGIN

   -- Copy the lines
   FOR source_rec_ IN source LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO', source_rec_.customer_no, attr_);
      Client_SYS.Add_To_Attr('AGREEMENT_ID', to_agreement_id_, attr_);
      Client_SYS.Add_To_Attr('AGREEMENT_PRIORITY', source_rec_.agreement_priority, attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Copy_All_Receivers__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   agreement_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR agreement_receiver_exist IS
      SELECT 1
      FROM REBATE_AGREEMENT_RECEIVER_TAB
      WHERE agreement_id = agreement_id_;

BEGIN
   OPEN agreement_receiver_exist;
   FETCH agreement_receiver_exist INTO temp_;
   IF (agreement_receiver_exist%NOTFOUND) THEN
      temp_ := 0;
   END IF;
   CLOSE agreement_receiver_exist;
   RETURN temp_;
END Check_Exist;


@UncheckedAccess
PROCEDURE Get_Active_Agreement (
   active_agreement_list_  OUT Rebate_Agreement_API.Agreement_Info_List,
   customer_no_            IN VARCHAR2,
   company_                IN VARCHAR2,
   validation_date_        IN DATE ) 
IS
   last_calendar_date_ DATE := Database_Sys.last_calendar_date_;
   count_   NUMBER := 0;
   agreement_selection_    VARCHAR2(20) := NULL;
   agreement_id_           VARCHAR2(10) := NULL;
   hierarchy_id_           VARCHAR2(10) := NULL;
   customer_level_         NUMBER := NULL;
   reb_customer_no_        VARCHAR2(20) := NULL; 
   agreement_priority_     NUMBER := NULL;
   modified_date_          DATE := NULL;

   CURSOR get_active_agreement IS
	   SELECT ra.agreement_id, ra.hierarchy_id, ra.customer_level, 
             rar.customer_no, rar.agreement_priority, rar.modified_date
   	   FROM REBATE_AGREEMENT ra, REBATE_AGREEMENT_RECEIVER rar
   	   WHERE ra.agreement_id = rar.agreement_id
   	   AND rar.customer_no = customer_no_
         AND ra.company = company_
   	   AND ra.objstate = 'Active'
         AND rar.modified_date = (SELECT MAX(rar2.modified_date)
                                  FROM REBATE_AGREEMENT_RECEIVER rar2
                                  WHERE rar2.customer_no = customer_no_
                                  AND ra.agreement_id = rar2.agreement_id
                                  AND rar2.agreement_priority = rar.agreement_priority)
         AND TRUNC(validation_date_) BETWEEN TRUNC(ra.valid_from) AND TRUNC(NVL(ra.valid_to,last_calendar_date_))
          ORDER BY rar.agreement_priority ASC, rar.modified_date DESC;
         
   CURSOR get_all_active_agr IS
	   SELECT ra.agreement_id, ra.hierarchy_id, ra.customer_level, 
             rar.customer_no, rar.agreement_priority
   	   FROM REBATE_AGREEMENT ra, REBATE_AGREEMENT_RECEIVER rar
   	   WHERE ra.agreement_id = rar.agreement_id
   	   AND rar.customer_no = customer_no_
         AND ra.company = company_
   	   AND ra.objstate = 'Active'
         AND TRUNC(validation_date_) BETWEEN TRUNC(ra.valid_from) AND TRUNC(NVL(ra.valid_to,last_calendar_date_));

BEGIN
   
   agreement_selection_ := Multiple_Rebate_Criteria_API.Get_Customer_Agr_Selection(customer_no_, company_);
      
   IF (agreement_selection_ = 'MULTIPLE_AGREEMENTS') THEN
      FOR agreement_ IN get_all_active_agr LOOP
         count_ := count_ + 1;
         active_agreement_list_(count_).agreement_id := agreement_.agreement_id;
         active_agreement_list_(count_).hierarchy_id := agreement_.hierarchy_id;
         active_agreement_list_(count_).customer_level := agreement_.customer_level;
         active_agreement_list_(count_).customer_parent := agreement_.customer_no;
      END LOOP;
   ELSE
      OPEN get_active_agreement;
      FETCH get_active_agreement INTO agreement_id_, hierarchy_id_, customer_level_, reb_customer_no_, agreement_priority_, modified_date_;
      CLOSE get_active_agreement;
      IF (agreement_id_ IS NOT NULL) THEN
         active_agreement_list_(1).agreement_id := agreement_id_;
         active_agreement_list_(1).hierarchy_id := hierarchy_id_;
         active_agreement_list_(1).customer_level := customer_level_;
         active_agreement_list_(1).customer_parent := reb_customer_no_;
      END IF; 
   END IF;
   
END Get_Active_Agreement;


-- Validate_Hierarchy_Level
--   Check whether the receivers belong to the customer hierarchy and the level mentioned in the agreement header.
PROCEDURE Validate_Hierarchy_Level (
   agreement_id_  IN VARCHAR2,
   customer_no_   IN VARCHAR2 )
IS
   aggr_hierarchy_id_        Cust_Hierarchy_Struct_Tab.Hierarchy_Id%TYPE;
BEGIN
   aggr_hierarchy_id_ := Rebate_Agreement_API.Get_Hierarchy_Id(agreement_id_);
   IF aggr_hierarchy_id_ != '*' THEN
      IF (Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_) = aggr_hierarchy_id_) THEN
         IF (Cust_Hierarchy_Struct_API.Get_Level_No(aggr_hierarchy_id_, customer_no_) != Rebate_Agreement_API.Get_Customer_Level(agreement_id_)) THEN
            Error_SYS.Record_General(lu_name_, 'CUSTNOTFROMHIERARCHY: Customer :P1 does not belong to the customer hierarchy level mentioned in the agreement header.', customer_no_); 
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_, 'CUSTNOTFROMHIERARCHY: Customer :P1 does not belong to the customer hierarchy level mentioned in the agreement header.', customer_no_); 
      END IF;
   END IF;
END Validate_Hierarchy_Level;

-- Update_Modified_Date
-- Updates Modified_Date
PROCEDURE Update_Modified_Date (
   agreement_id_  IN VARCHAR2,
   customer_no_   IN VARCHAR2 )
IS
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   oldrec_              REBATE_AGREEMENT_RECEIVER_TAB%ROWTYPE;
   newrec_              REBATE_AGREEMENT_RECEIVER_TAB%ROWTYPE;
   indrec_              Indicator_Rec;
   attr_                VARCHAR2(32000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, customer_no_);
   oldrec_              := Lock_By_Id___(objid_, objversion_);
   newrec_              := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE', SYSDATE, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Update_Modified_Date;


PROCEDURE New (
   info_                OUT VARCHAR2,
   agreement_id_        IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   agreement_priority_  IN NUMBER)
IS
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   newrec_              REBATE_AGREEMENT_RECEIVER_TAB%ROWTYPE;
   indrec_              Indicator_Rec;
   attr_                VARCHAR2(32000);
BEGIN
   Client_SYS.Add_To_Attr('AGREEMENT_ID', agreement_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_PRIORITY', agreement_priority_, attr_);    
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   info_ := Client_SYS.Get_All_Info;
END New;


PROCEDURE Modify (
   info_                OUT VARCHAR2,
   agreement_id_        IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   agreement_priority_  IN NUMBER )
IS
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   oldrec_              REBATE_AGREEMENT_RECEIVER_TAB%ROWTYPE;
   newrec_              REBATE_AGREEMENT_RECEIVER_TAB%ROWTYPE;
   indrec_              Indicator_Rec;
   attr_                VARCHAR2(32000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, customer_no_);
   oldrec_              := Lock_By_Id___(objid_, objversion_);
   newrec_              := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_PRIORITY', agreement_priority_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   info_ := Client_SYS.Get_All_Info;
END Modify;

PROCEDURE Remove (
   info_                OUT VARCHAR2,
   agreement_id_        IN VARCHAR2,
   customer_no_         IN VARCHAR2)
IS
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);   
   remrec_              REBATE_AGREEMENT_RECEIVER_TAB%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, customer_no_);
   remrec_              := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
   info_ := Client_SYS.Get_All_Info;
END Remove;
   
