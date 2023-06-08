-----------------------------------------------------------------------------
--
--  Logical unit: DiscreteCharacteristic
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190614  PAWELK   Bug 148539, (MFZ-1257) Modified Check_Delete___() by assigning characteristic_code value to key_.
--  151222  JoAnse   STRMF-2175, Added Modify_Description called when replicating description from Configuration Characteristic.
--  140807  Matkse   PRSC-318, Removed override of Prepare_Insert___ since method call to Characteristic_API.New__ is no longer 
--                   possible due to restrictions in access to CRUD operations on LU Characteristic. (All it did was the same as default behaviour anyways.)
--  121214  NipKlk   Bug 107385, Added explicit dynamic calls to Reference_SYS.Check_Restricted_Delete from Check_Delete___ and 
--  121214           Reference_SYS.Do_Cascade_Delete from Delete___ to check if any LU has a reference towards Characteristic.
--  120525  JeLise   Made description private.
--  120507  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100429  Ajpelk   Merge rose method documentation
--  100916  GayDLK   Bug 92479, Replaced lu_name_ with Characteristic_API.lu_name_ to have a more meaningful 
--  100916           error message in Insert___().
--  ---------------------------Eagle------------------------------------------
--  070921  NuVelk Removed methods Get_Transfer_To_Cbs and Get_Transfer_To_Cbs_Db.
--  070312  NuVelk Add methods Get_Transfer_To_Cbs and Get_Transfer_To_Cbs_Db. Made modifications to VIEW, 
--  070312         Unpack_Check_Insert___, Insert___, Unpack_Check_Update___, Update___, New, and Get to 
--  070312         reflect changes made by adding the column, transfer_to_cbs in the parent LU Characteristic.         
--  060125  MarSlk Bug 55573, Added method Check_Update_Search_Type___ to check 
--  060125         the characteristic values before updating the search type.
--  060125         The method is called from Unpack_Check_Update___.
--  060111  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111           and added UNDEFINE according to the new template.
--  040223  SaNalk Removed SUBSTRB.
--  ------------------------------- 13.3.0 ----------------------------------
--  001215  PERK  Changed view comments
--  001124  PERK  Added method new
--  001101  PERK  Added rowtype to where-condition in check_exist___
--  001015  PERK  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Update_Search_Type___
--   Raises an exception when the searh type is modified from alpha to
--   numeric if non numeric data exists for the given characteristic_code.
PROCEDURE Check_Update_Search_Type___ (
   characteristic_code_ IN VARCHAR2,
   search_type_db_      IN VARCHAR2 )
IS
   CURSOR get_characteristic_value(characteristic_code_ IN VARCHAR2) IS
      SELECT characteristic_value
      FROM   DISCRETE_CHARAC_VALUE_TAB
      WHERE  characteristic_code = characteristic_code_;
BEGIN
   IF (search_type_db_ = 'N') THEN
      FOR characteristic_value IN get_characteristic_value(characteristic_code_) LOOP
         Discrete_Charac_Value_API.Check_Characteristic_Value(characteristic_value.characteristic_value,
                                                              search_type_db_);
      END LOOP;
   END IF;
END Check_Update_Search_Type___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CHARACTERISTIC_TAB%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   super(remrec_);
   key_ := remrec_.characteristic_code||'^';
   Reference_SYS.Check_Restricted_Delete('Characteristic', key_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CHARACTERISTIC_TAB%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   super(objid_, remrec_);
   Reference_SYS.Do_Cascade_Delete('Characteristic', key_);
END Delete___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     characteristic_tab%ROWTYPE,
   newrec_ IN OUT characteristic_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Check_Update_Search_Type___(newrec_.characteristic_code, newrec_.search_type);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ characteristic_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Record_Exist(Characteristic_API.lu_name_);
   super(rec_);
END Raise_Record_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new discrete characteristic
PROCEDURE New (
   characteristic_code_ IN VARCHAR2,
   description_         IN VARCHAR2,
   search_type_db_      IN VARCHAR2 )
IS
   newrec_       CHARACTERISTIC_TAB%ROWTYPE;
   objid_        DISCRETE_CHARACTERISTIC.objid%TYPE;
   objversion_   DISCRETE_CHARACTERISTIC.objversion%TYPE;
   attr_         VARCHAR2(2000);
   indrec_       Indicator_Rec;
BEGIN

   IF NOT (Check_Exist___(characteristic_code_)) THEN
      Prepare_Insert___(attr_);

      IF (characteristic_code_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('CHARACTERISTIC_CODE', characteristic_code_, attr_);
      END IF;

      IF (description_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('DESCRIPTION', description_, attr_);
      END IF;

      IF (search_type_db_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('SEARCH_TYPE_DB', search_type_db_, attr_);
      END IF;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END New;

-- Modify_Description
--   Modifies the description for an existing characteristic.
PROCEDURE Modify_Description (
   characteristic_code_ IN VARCHAR2,
   description_         IN VARCHAR2 )
IS
   newrec_  characteristic_tab%ROWTYPE;
BEGIN
   IF (Check_Exist___(characteristic_code_)) THEN
      newrec_ := Get_Object_By_Keys___(characteristic_code_);   
      newrec_.description := description_;
      Modify___(newrec_);  
   END IF;
END Modify_Description;

@UncheckedAccess
FUNCTION Get_Description (
   characteristic_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ characteristic_tab.description%TYPE;
BEGIN
   IF (characteristic_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('MPCCOM', 'DiscreteCharacteristic',
              characteristic_code), description), 1, 35)
      INTO  temp_
      FROM  characteristic_tab
      WHERE characteristic_code = characteristic_code_
      AND   rowtype LIKE '%DiscreteCharacteristic';
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(characteristic_code_, 'Get_Description');
END Get_Description;
