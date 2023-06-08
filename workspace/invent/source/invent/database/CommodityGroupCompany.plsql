-----------------------------------------------------------------------------
--
--  Logical unit: CommodityGroupCompany
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200518  SBalLK  Bug 153989(SCZ-10002), Added Check_Delete___(), Remove_Commodity_Group___(), Check_Remove_Commodity_Group__() and
--  200518          Do_Remove_Commodity_Group__() method to remove commodity group when basic data removed.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Exist_Inactive___
--   Checks if record exists but with planning hierarchy parameters set to null.
FUNCTION Check_Exist_Inactive___ (
   commodity_code_ IN VARCHAR2,
   company_        IN VARCHAR2 ) RETURN BOOLEAN
IS
   exist_inactive_ BOOLEAN := FALSE;
   record_         COMMODITY_GROUP_COMPANY_TAB%ROWTYPE;
BEGIN
   record_ := Get_Object_By_Keys___(commodity_code_, company_);
   IF (record_.commodity_code IS NOT NULL) THEN
      IF (Inactive___(record_)) THEN
         exist_inactive_ := TRUE;
      END IF;
   END IF;
   
   RETURN(exist_inactive_);
END Check_Exist_Inactive___;


-- Get_Attr_With_Keys_Removed___
--   Returns the attr without keys.
FUNCTION Get_Attr_With_Keys_Removed___ (
   attr_ IN VARCHAR2) RETURN VARCHAR2
IS
   new_attr_ VARCHAR2(2000);
   ptr_      NUMBER;
   name_     VARCHAR2(30);
   value_    VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ NOT IN ('COMMODITY_CODE', 'COMPANY')) THEN
         Client_SYS.Add_To_Attr(name_, value_, new_attr_);
      END IF;
   END LOOP;
   RETURN new_attr_;
END Get_Attr_With_Keys_Removed___;


FUNCTION Inactive___ (
   record_ IN COMMODITY_GROUP_COMPANY_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   inactive_ BOOLEAN := FALSE;
BEGIN
   IF ((record_.service_level_rate        IS NULL) AND
       (record_.ordering_cost             IS NULL) AND
       (record_.inventory_interest_rate   IS NULL)) THEN
      inactive_ := TRUE;
   END IF;

   RETURN inactive_;
END Inactive___;


PROCEDURE Error_If_Inactive___ (
   record_ IN COMMODITY_GROUP_COMPANY_TAB%ROWTYPE )
IS
BEGIN
   
   IF (Inactive___(record_)) THEN
      Error_SYS.Record_General(lu_name_,'INACTIVE: At least one of the columns must have a value.');
   END IF;
END Error_If_Inactive___;


PROCEDURE Modify___ (
   info_           OUT    VARCHAR2,
   objid_          IN     VARCHAR2,
   objversion_     IN OUT VARCHAR2,
   attr_           IN OUT VARCHAR2,
   action_         IN     VARCHAR2,
   check_inactive_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_ COMMODITY_GROUP_COMPANY_TAB%ROWTYPE;
   newrec_ COMMODITY_GROUP_COMPANY_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
BEGIN
   IF (action_ = 'CHECK') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, check_inactive_);
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, check_inactive_);      
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT commodity_group_company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2,
   check_inactive_ IN     BOOLEAN DEFAULT TRUE )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   Company_Invent_Info_API.Check_Hierarchy_Attributes(newrec_.service_level_rate,
                        newrec_.ordering_cost,
                        newrec_.inventory_interest_rate);
   IF (check_inactive_) THEN
      Error_If_Inactive___(newrec_);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     commodity_group_company_tab%ROWTYPE,
   newrec_ IN OUT commodity_group_company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2,
   check_inactive_ IN     BOOLEAN DEFAULT TRUE )
IS
   name_   VARCHAR2(30);
   value_  VARCHAR2(4000);   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Company_Invent_Info_API.Check_Hierarchy_Attributes(newrec_.service_level_rate,
                        newrec_.ordering_cost,
                        newrec_.inventory_interest_rate,
                        oldrec_.service_level_rate,
                        oldrec_.ordering_cost,
                        oldrec_.inventory_interest_rate);
   IF (check_inactive_) THEN
      Error_If_Inactive___(newrec_);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN commodity_group_company_tab%ROWTYPE )
IS
    CURSOR get_records IS
      SELECT COUNT(*)
      FROM   commodity_group_company_tab
      WHERE  commodity_code = remrec_.commodity_code
      AND    ((service_level_rate      IS NOT NULL) OR
              (ordering_cost           IS NOT NULL) OR
              (inventory_interest_rate IS NOT NULL));

   count_ NUMBER;
BEGIN
   IF (NOT Check_Exist_Inactive___(remrec_.commodity_code,
                                   remrec_.company)) THEN
      OPEN  get_records;
      FETCH get_records INTO count_;
      CLOSE get_records;
      Error_SYS.Record_Constraint(Commodity_Group_API.lu_name_, lu_name_, count_);
   END IF;
   super(remrec_);
END Check_Delete___;

PROCEDURE Remove_Commodity_Group___(
   commodity_code_   IN VARCHAR2,
   action_           IN VARCHAR2 )
IS
   CURSOR get_records IS
      SELECT *
      FROM commodity_group_company_tab
      WHERE commodity_code = commodity_code_;
BEGIN
   FOR record_ IN get_records LOOP
      IF ( action_ = 'CHECK' ) THEN
         Check_Delete___(record_);
      ELSIF ( action_ = 'DO' ) THEN
         Remove___(record_, lock_mode_wait_ => FALSE);
      END IF;
   END LOOP;
END Remove_Commodity_Group___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   attr_with_keys_removed_ VARCHAR2(2000);
   commodity_code_         COMMODITY_GROUP_COMPANY_TAB.commodity_code%TYPE;
   company_                COMMODITY_GROUP_COMPANY_TAB.company%TYPE;
BEGIN
   commodity_code_ := Client_SYS.Get_Item_Value('COMMODITY_CODE',attr_);
   company_ := Client_SYS.Get_Item_Value('COMPANY',attr_);
   IF ((action_ IN ('CHECK','DO')) AND Check_Exist_Inactive___(commodity_code_,company_)) THEN
      attr_with_keys_removed_ := Get_Attr_With_Keys_Removed___(attr_);
      Get_Id_Version_By_Keys___(objid_, objversion_, commodity_code_, company_);
      Modify__(info_,objid_,objversion_,attr_with_keys_removed_,action_); 
   ELSE      
   super(info_, objid_, objversion_, attr_, action_);
   END IF;
END New__;


@Overtake Base
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   attr_           VARCHAR2(2000);
   new_objversion_ COMMODITY_GROUP_COMPANY.objversion%TYPE := objversion_;
BEGIN
   -- Using Modify__ to null all planning hierarchy attributes in order to simulate deletion of record.
   Client_SYS.Add_To_Attr('SERVICE_LEVEL_RATE',       to_char(NULL), attr_);
   Client_SYS.Add_To_Attr('ORDERING_COST',            to_char(NULL), attr_);
   Client_SYS.Add_To_Attr('INVENTORY_INTEREST_RATE',  to_char(NULL), attr_);
   Modify___(info_, objid_, new_objversion_, attr_, action_, FALSE);
END Remove__;

PROCEDURE Check_Remove_Commodity_Group__(
   commodity_code_ IN VARCHAR2)
IS
BEGIN
   Remove_Commodity_Group___( commodity_code_, 'CHECK');
END Check_Remove_Commodity_Group__;

PROCEDURE Do_Remove_Commodity_Group__(
   commodity_code_ IN VARCHAR2)
IS
BEGIN
   Remove_Commodity_Group___( commodity_code_, 'DO');
END Do_Remove_Commodity_Group__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


