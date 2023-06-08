-----------------------------------------------------------------------------
--
--  Logical unit: InventoryValueComparator
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180811  RasDlk   Bug 143514, Modified Check_Update___ and Check_Insert___ by changing the translatable constant CONDITIONCODEMUSTBE.
--  110715  MaEelk   Added user allowed site filter to INVENTORY_VALUE_COMPARATOR.
--  090925  MaEelk   Removed unused view INVENTORY_VALUE_COMPARATOR_LOV
--  --------------------------------- 14.0.0 ------------------------------------
--  060614  KaDilk   Added VIEW_LOV.
--  060605  ChBalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   condition_code_   INVENTORY_VALUE_COMPARATOR_TAB.condition_code%TYPE;
   contract_         INVENTORY_VALUE_COMPARATOR_TAB.contract%TYPE;
   part_no_          INVENTORY_VALUE_COMPARATOR_TAB.part_no%TYPE;
BEGIN
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   part_no_ := Client_SYS.Get_Item_Value('PART_NO', attr_);
   super(attr_);
   Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(contract_), attr_);
   -- IF part not condition code enabled, then default condition code is '*'.
   IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_) = 'NOT_ALLOW_COND_CODE') THEN
      condition_code_ := '*';
   ELSE
      condition_code_ := Condition_Code_API.Get_Default_Condition_Code();
   END IF;
   Client_SYS.Add_To_Attr('CONDITION_CODE', condition_code_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_value_comparator_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.company != Site_API.Get_Company(newrec_.contract)) THEN
      Error_SYS.Record_General(lu_name_, 'COMPANYCHANGED: It is not allowed to save a record against the respective site and company, since Site :P1 does not belong to Company :P2.', newrec_.contract, newrec_.company);
   END IF;
   IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.part_no) = 'NOT_ALLOW_COND_CODE') THEN
      IF (newrec_.condition_code != '*') THEN
         Error_SYS.Record_General(lu_name_, 'CONDITIONCODEMUSTBE: Condition Code must be * when the part :P1 is condition code not allowed ', newrec_.part_no);
      END IF;
   END IF;
   IF (newrec_.comparison_value < 0) THEN
      Error_SYS.Record_General(lu_name_, 'COMPVALCANTBENEGATIV: Comparison Value cannot be a negative value.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     inventory_value_comparator_tab%ROWTYPE,
   newrec_ IN OUT inventory_value_comparator_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.company != Site_API.Get_Company(newrec_.contract)) THEN
      Error_SYS.Record_General(lu_name_, 'COMPANYCHANGED: It is not allowed to save a record against the respective site and company, since Site :P1 does not belong to Company :P2.', newrec_.contract, newrec_.company);
   END IF;
   IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.part_no) = 'NOT_ALLOW_COND_CODE') THEN
      IF (newrec_.condition_code != '*') THEN
         Error_SYS.Record_General(lu_name_, 'CONDITIONCODEMUSTBE: Condition Code must be * when the part :P1 is condition code not allowed ', newrec_.part_no);
      END IF;
   END IF;
   IF (newrec_.comparison_value < 0) THEN
      Error_SYS.Record_General(lu_name_, 'COMPVALCANTBENEGATIV: Comparison Value cannot be a negative value.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


