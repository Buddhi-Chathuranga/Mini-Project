-----------------------------------------------------------------------------
--
--  Logical unit: PartyListItem
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131127  ChAmlk  Hooks: Created
--  110526  NEKOLK  EASTONE-21461 : Corrected General_SYS.Init_Method to Exist.
--  110131  ChAmlk  Added method Get_Contractor_Rec_List.
--  050410  ChAmlk  Added method Get_Contractor_List and Valid_Contractors_Exist. 
--  040810  ChAmlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate___ (
   newrec_ IN OUT PARTY_LIST_ITEM_TAB%ROWTYPE )
IS

BEGIN
   
   IF (newrec_.party_type = 'CUSTOMER') THEN
      Customer_Info_API.Exist(newrec_.party_id);
   ELSIF (newrec_.party_type = 'SUPPLIER') THEN
      Supplier_Info_API.Exist(newrec_.party_id);
   ELSIF (newrec_.party_type = 'CONTRACTOR') THEN
      Supplier_Info_API.Exist(newrec_.party_id);
   ELSIF (newrec_.party_type = 'MANUFACTURER') THEN
      Manufacturer_Info_API.Exist(newrec_.party_id);
   ELSIF (newrec_.party_type = 'ASSET_MANAGER') THEN      
      Person_Info_API.Exist(newrec_.party_id);
   ELSE
      Owner_Info_API.Exist(newrec_.party_id);
   END IF;

   IF (newrec_.valid_to < newrec_.valid_from) THEN
      ERROR_SYS.Record_General(lu_name_, 'PARTYVALIDFROMINV: The Valid To date cannot be earlier than Valid From date');
   END IF;
END Validate___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', SYSDATE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     party_list_item_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY party_list_item_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate___(newrec_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Contractor_List (
   list_id_     IN VARCHAR2,
   plan_start_  IN DATE,
   plan_finish_ IN DATE) RETURN VARCHAR2
IS
   contractor_list_      VARCHAR2(2000) := NULL;
   valid_from_           DATE;
   valid_to_             DATE;
   CURSOR get_cont_list IS
      SELECT party_id
      FROM   party_list_item_tab
      WHERE  list_id = list_id_
      AND    party_type = 'CONTRACTOR'
      AND    TRUNC(valid_from_)  BETWEEN valid_from AND valid_to 
      AND    TRUNC(valid_to_) BETWEEN valid_from AND valid_to;

BEGIN
   valid_from_ := plan_start_;
   valid_to_   := plan_finish_;
   IF (valid_from_ IS NULL AND valid_to_ IS NULL) THEN
      valid_from_ := SYSDATE;
      valid_to_   := SYSDATE;
   ELSIF (valid_from_ IS NULL AND valid_to_ IS NOT NULL) THEN
      valid_from_ := valid_to_;
   ELSIF (valid_from_ IS NOT NULL AND valid_to_ IS NULL) THEN
      valid_to_ := valid_from_;
   END IF;

   FOR get_cont_list_ IN get_cont_list LOOP
      IF (contractor_list_ IS NULL) THEN
         contractor_list_ := get_cont_list_.party_id;
      ELSE
         contractor_list_ := contractor_list_ || ', '|| get_cont_list_.party_id;
      END IF;
   END LOOP;

   RETURN contractor_list_;

END Get_Contractor_List;


@UncheckedAccess
FUNCTION Get_Contractor_Rec_List (
   list_id_     IN VARCHAR2,
   plan_start_  IN DATE,
   plan_finish_ IN DATE) RETURN VARCHAR2
IS
   contractor_list_      VARCHAR2(32000) := NULL;
   valid_from_           DATE;
   valid_to_             DATE;
   CURSOR get_cont_list IS
      SELECT party_id
      FROM   party_list_item_tab
      WHERE  list_id = list_id_
      AND    party_type = 'CONTRACTOR'
      AND    TRUNC(valid_from_)  BETWEEN valid_from AND valid_to 
      AND    TRUNC(valid_to_) BETWEEN valid_from AND valid_to;
BEGIN
   valid_from_ := plan_start_;
   valid_to_   := plan_finish_;
   IF (valid_from_ IS NULL AND valid_to_ IS NULL) THEN
      valid_from_ := SYSDATE;
      valid_to_   := SYSDATE;
   ELSIF (valid_from_ IS NULL AND valid_to_ IS NOT NULL) THEN
      valid_from_ := valid_to_;
   ELSIF (valid_from_ IS NOT NULL AND valid_to_ IS NULL) THEN
      valid_to_ := valid_from_;
   END IF;

   FOR get_cont_list_ IN get_cont_list LOOP
      IF (contractor_list_ IS NULL) THEN
         contractor_list_ := get_cont_list_.party_id;
      ELSE
         contractor_list_ := contractor_list_ ||Client_SYS.field_separator_|| get_cont_list_.party_id;
      END IF;
   END LOOP;

   RETURN contractor_list_||Client_SYS.field_separator_;
END Get_Contractor_Rec_List;


@UncheckedAccess
FUNCTION Valid_Contractors_Exist (
  list_id_        IN VARCHAR2,
  plan_start_     IN DATE,
  plan_finish_    IN DATE) RETURN VARCHAR2
IS
   valid_from_       DATE;
   valid_to_         DATE;
   dummy_            NUMBER;
   CURSOR get_cont_list IS
      SELECT DISTINCT 1
      FROM   party_list_item_tab
      WHERE  list_id = list_id_
      AND    party_type = 'CONTRACTOR'
      AND    TRUNC(valid_from_)  BETWEEN valid_from AND valid_to 
      AND    TRUNC(valid_to_) BETWEEN valid_from AND valid_to;

BEGIN

   valid_from_ := plan_start_;
   valid_to_   := plan_finish_;
   IF (valid_from_ IS NULL AND valid_to_ IS NULL) THEN
      valid_from_ := SYSDATE;
      valid_to_   := SYSDATE;
   ELSIF (valid_from_ IS NULL AND valid_to_ IS NOT NULL) THEN
      valid_from_ := valid_to_;
   ELSIF (valid_from_ IS NOT NULL AND valid_to_ IS NULL) THEN
      valid_to_ := valid_from_;
   END IF;

   OPEN get_cont_list;
   FETCH get_cont_list INTO dummy_;
   CLOSE get_cont_list;
   IF (dummy_ >= 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;

END Valid_Contractors_Exist;



