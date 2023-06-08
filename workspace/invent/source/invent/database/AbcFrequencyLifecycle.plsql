-----------------------------------------------------------------------------
--
--  Logical unit: AbcFrequencyLifecycle
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200930  AwWelk  SC2020R1-10260 merged Bug 155541. Modification in New__() to try and fetch FREQUENCY_CLASS_DB & LIFECYCLE_STAGE_DB directly
--  200930		     Removed overriden prepare insert which fetched all site config as default
--  141123  AwWelk  PRSC-1070, Modified New_A_B_Swap__() to raise the record exist error message if a duplicate record 
--  141123          entered for same planning_method_a_b_swap.
--  141122  AwWelk  GEN-232, Modified Prepare_Insert___(), New_A_B_Swap__() to use all_sites_config_.
--  141007  AwWelk  GEN-151, Added validations by allowing to save user allowed sites only.
--  141006  AwWelk  GEN-148, Modified the New__() to correctly invoke Modify___() as per App8 logic.
--  140922  AwWelk  GEN-30, Made the changes to add contract column as a primary key column.
--  140602  AwWelk  PBSC-1070, Modified New_A_B_Swap__() to avoid seemingly duplicate record insertion from client.
--  121010  NaLrlk  Bug 105715, Modified view comments in ABC_FREQUENCY_LIFE_PLAN_A view to synchronize with model.
--  120918  AyAmlk  Bug 101353, Added a new attribute set_safety_stock_to_zero in order to change the safety stock to zero 
--  120918          automatically when the planning method is changed from B to A.
--  120213  MaEelk  Added NOCHECK to ABC_FREQUENCY_LIFE_PLAN_A.FREQUENCY_CLASS,ABC_FREQUENCY_LIFE_PLAN_A.LIFECYCLE_STAGE,
--  120213          ABC_FREQUENCY_LIFE_PLAN_B.FREQUENCY_CLASS and ABC_FREQUENCY_LIFE_PLAN_B.LIFECYCLE_STAGE.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
all_sites_config_ CONSTANT VARCHAR2(1) := '*';

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist_Inactive___ (
   abc_class_           IN VARCHAR2,
   company_             IN VARCHAR2,
   contract_            IN VARCHAR2,
   frequency_class_db_  IN VARCHAR2,
   lifecycle_stage_db_  IN VARCHAR2) RETURN BOOLEAN
IS
   exist_inactive_   BOOLEAN := FALSE;
   record_           ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE;
BEGIN
   record_ := Get_Object_By_Keys___(abc_class_, company_, contract_, frequency_class_db_, lifecycle_stage_db_);
   IF (record_.abc_class IS NOT NULL) THEN
      IF (Inactive___(record_)) THEN
         exist_inactive_ := TRUE;
      END IF;
   END IF;

   RETURN(exist_inactive_);
END Check_Exist_Inactive___;

PROCEDURE Check_Contract_Ref___ (
newrec_ IN OUT abc_frequency_lifecycle_tab%ROWTYPE )
IS
BEGIN
   IF ((newrec_.contract IS NOT NULL) AND (newrec_.contract != '*'))THEN
      Site_API.Exist(newrec_.contract); 
      IF newrec_.company != Site_API.Get_Company(newrec_.contract) THEN
         Error_SYS.Record_General(lu_name_,'WRONGCOMPANY: Site :P1 does not belong to company :P2.', newrec_.contract, newrec_.company);
      END IF;
   END IF;
END Check_Contract_Ref___;




FUNCTION Get_Attr_With_Keys_Removed___ (
   attr_ IN VARCHAR2) RETURN VARCHAR2
IS
   new_attr_   VARCHAR2(2000);
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ NOT IN ('ABC_CLASS', 'COMPANY', 'CONTRACT', 'FREQUENCY_CLASS', 'LIFECYCLE_STAGE', 'FREQUENCY_CLASS_DB', 'LIFECYCLE_STAGE_DB')) THEN
         Client_SYS.Add_To_Attr(name_, value_, new_attr_);
      END IF;
   END LOOP;
   RETURN new_attr_;
END Get_Attr_With_Keys_Removed___;


FUNCTION Inactive___ (
   record_ IN ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   inactive_   BOOLEAN := FALSE;
BEGIN
   IF ((record_.service_level_rate        IS NULL) AND
       (record_.ordering_cost             IS NULL) AND
       (record_.inventory_interest_rate   IS NULL)) THEN

      inactive_ := TRUE;
   END IF;

   RETURN inactive_;
END Inactive___;


PROCEDURE Error_If_Inactive___ (
   record_ IN ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE )
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
   oldrec_ ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE;
   newrec_ ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
BEGIN
   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);
      newrec_ := oldrec_;     
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


PROCEDURE Modify___ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2,
   a_b_swap_   IN     VARCHAR2 )
IS
   oldrec_ ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE;
   newrec_ ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
BEGIN
   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);      
      newrec_ := oldrec_;     
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, FALSE);      
      
      IF (a_b_swap_ = 'A') THEN
         Check_Planning_Method___(newrec_.abc_class, newrec_.company, newrec_.contract, newrec_.frequency_class,
                                  newrec_.lifecycle_stage, a_b_swap_);
         newrec_.planning_method_a_b_swap := 'A';
      ELSIF (a_b_swap_ = 'B') THEN
         Check_Planning_Method___(newrec_.abc_class, newrec_.company, newrec_.contract, newrec_.frequency_class,
                                  newrec_.lifecycle_stage, a_b_swap_);
         newrec_.planning_method_a_b_swap := 'B';
      END IF;
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, FALSE);
         
      IF (a_b_swap_ = 'A') THEN
         Check_Planning_Method___(newrec_.abc_class, newrec_.company, newrec_.contract, newrec_.frequency_class,
                                  newrec_.lifecycle_stage, a_b_swap_);
         newrec_.planning_method_a_b_swap := 'A';
      ELSIF (a_b_swap_ = 'B') THEN
         Check_Planning_Method___(newrec_.abc_class, newrec_.company, newrec_.contract, newrec_.frequency_class,
                                  newrec_.lifecycle_stage, a_b_swap_);
         newrec_.planning_method_a_b_swap := 'B';
      ELSIF (a_b_swap_ = 'N') THEN
         newrec_.planning_method_a_b_swap := NULL;
      END IF;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify___;


PROCEDURE Check_Planning_Method___ (
   abc_class_       IN VARCHAR2,
   company_         IN VARCHAR2,
   contract_        IN VARCHAR2,
   frequency_class_ IN VARCHAR2,
   lifecycle_stage_ IN VARCHAR2,
   planning_method_ IN VARCHAR2 )
IS
   planning_method_a_b_swap_  VARCHAR2(1);

   CURSOR get_planning_method IS
      SELECT planning_method_a_b_swap
      FROM ABC_FREQUENCY_LIFECYCLE_TAB
      WHERE abc_class = abc_class_
      AND   company = company_
      AND   contract = contract_
      AND   frequency_class = frequency_class_
      AND   lifecycle_stage = lifecycle_stage_;
BEGIN
   OPEN  get_planning_method;
   FETCH get_planning_method INTO planning_method_a_b_swap_;
   CLOSE get_planning_method;
   IF planning_method_a_b_swap_ != planning_method_ THEN
      Client_SYS.Add_Warning(lu_name_, 'ABEXIST: This combination of ABC, Frequency and Lifecycle already exist as value for interchange from :P1 to :P2.', planning_method_, planning_method_a_b_swap_);
   END IF;
END Check_Planning_Method___;


PROCEDURE Check_A_B_Swap___ (
   planning_method_a_b_swap_ IN VARCHAR2 )
IS
BEGIN
   -- Allowed values are 'A', 'B' and null
   IF (nvl(planning_method_a_b_swap_, '*') NOT IN ('A', 'B', '*')) THEN
      Error_SYS.Record_General(lu_name_,'ABSWAP: Invalid planning method.');
   END IF;
END Check_A_B_Swap___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE,
   newrec_     IN OUT ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN

   IF (NVL(oldrec_.planning_method_a_b_swap, Database_SYS.string_null_) = 'A') THEN
      IF (NVL(newrec_.planning_method_a_b_swap, Database_SYS.string_null_) != 'A') THEN
         newrec_.set_safety_stock_to_zero := NULL;
      END IF;
   ELSE
      IF (NVL(newrec_.planning_method_a_b_swap, Database_SYS.string_null_) = 'A') AND (newrec_.set_safety_stock_to_zero IS NULL) THEN
         newrec_.set_safety_stock_to_zero := 'FALSE';
      END IF;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;
   

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT abc_frequency_lifecycle_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2,
   check_inactive_ IN BOOLEAN DEFAULT TRUE )
IS
BEGIN

   IF (newrec_.planning_method_a_b_swap = 'A') AND (indrec_.planning_method_a_b_swap) AND NOT (indrec_.set_safety_stock_to_zero) THEN
      newrec_.set_safety_stock_to_zero := 'FALSE';
   END IF;
   super(newrec_, indrec_, attr_);
   IF (newrec_.planning_method_a_b_swap = 'A') THEN
      Error_SYS.Check_Not_Null(lu_name_, 'SET_SAFETY_STOCK_TO_ZERO', newrec_.set_safety_stock_to_zero);
   ELSE
      IF (newrec_.set_safety_stock_to_zero IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOZEROSAFETYSTOCK: The safety stock cannot be set to zero when the planning method does not swap from B to A.');
      END IF;
   END IF;

   Company_Invent_Info_API.Check_Hierarchy_Attributes(newrec_.service_level_rate,
                                                      newrec_.ordering_cost,
                                                      newrec_.inventory_interest_rate);

   Check_A_B_Swap___(newrec_.planning_method_a_b_swap);
   IF (check_inactive_) THEN
      Error_If_Inactive___(newrec_);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     abc_frequency_lifecycle_tab%ROWTYPE,
   newrec_ IN OUT abc_frequency_lifecycle_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2,
   check_inactive_ IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Company_Invent_Info_API.Check_Hierarchy_Attributes(newrec_.service_level_rate,
                                                      newrec_.ordering_cost,
                                                      newrec_.inventory_interest_rate,
                                                      oldrec_.service_level_rate,
                                                      oldrec_.ordering_cost,
                                                      oldrec_.inventory_interest_rate);

   IF NVL(oldrec_.planning_method_a_b_swap, Database_SYS.string_null_) !=
      NVL(newrec_.planning_method_a_b_swap, Database_SYS.string_null_) THEN
      Check_A_B_Swap___(newrec_.planning_method_a_b_swap);
   END IF;
   IF (check_inactive_) THEN
      Error_If_Inactive___(newrec_);
   END IF;
END Check_Update___;


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
   abc_class_              ABC_FREQUENCY_LIFECYCLE_TAB.abc_class%TYPE;
   company_                ABC_FREQUENCY_LIFECYCLE_TAB.company%TYPE;
   contract_               ABC_FREQUENCY_LIFECYCLE_TAB.contract%TYPE;
   frequency_class_db_     ABC_FREQUENCY_LIFECYCLE_TAB.frequency_class%TYPE;
   lifecycle_stage_db_     ABC_FREQUENCY_LIFECYCLE_TAB.lifecycle_stage%TYPE;
BEGIN
    IF (action_ IN ('CHECK', 'DO')) THEN
         abc_class_ := Client_SYS.Get_Item_Value('ABC_CLASS',attr_);
         company_ := Client_SYS.Get_Item_Value('COMPANY',attr_);
         contract_ := Client_SYS.Get_Item_Value('CONTRACT',attr_);
         frequency_class_db_  := NVL(Client_SYS.Get_Item_Value('FREQUENCY_CLASS_DB', attr_), Inv_Part_Frequency_Class_API.Encode(Client_SYS.Get_Item_Value('FREQUENCY_CLASS', attr_)));
         lifecycle_stage_db_  := NVL(Client_SYS.Get_Item_Value('LIFECYCLE_STAGE_DB', attr_), Inv_Part_Lifecycle_Stage_API.Encode(Client_SYS.Get_Item_Value('LIFECYCLE_STAGE', attr_)));    
    END IF;

    IF (action_ IN ('CHECK', 'DO') AND Check_Exist_Inactive___(abc_class_, company_, contract_, frequency_class_db_, lifecycle_stage_db_)) THEN
         attr_with_keys_removed_ := Get_Attr_With_Keys_Removed___(attr_);
         Get_Id_Version_By_Keys___(objid_, objversion_, abc_class_, company_, contract_, frequency_class_db_, lifecycle_stage_db_);
         Modify___(info_, objid_, objversion_, attr_with_keys_removed_, action_);
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
   new_objversion_ ABC_FREQUENCY_LIFECYCLE.objversion%TYPE := objversion_;
BEGIN

   -- Using Modify__ to null all planning hierarchy attributes in order to simulate deletion of record.
   Client_SYS.Add_To_Attr('SERVICE_LEVEL_RATE',       to_char(NULL), attr_);
   Client_SYS.Add_To_Attr('ORDERING_COST',            to_char(NULL), attr_);
   Client_SYS.Add_To_Attr('INVENTORY_INTEREST_RATE',  to_char(NULL), attr_);
   Modify___(info_, objid_, new_objversion_, attr_, action_, FALSE);

END Remove__;


PROCEDURE New_A_B_Swap__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2,
   a_b_swap_   IN     VARCHAR2 )
IS
   abc_class_              VARCHAR2(1);
   company_                VARCHAR2(20);
   frequency_class_db_     VARCHAR2(20);
   lifecycle_stage_db_     VARCHAR2(20);
   newrec_                 ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE;
   oldrec_                 ABC_FREQUENCY_LIFECYCLE_TAB%ROWTYPE;
   attr_with_keys_removed_ VARCHAR2(2000);
   indrec_                 Indicator_Rec;
BEGIN
   abc_class_           := Client_SYS.Get_Item_Value('ABC_CLASS', attr_);
   company_             := Client_SYS.Get_Item_Value('COMPANY', attr_);
   frequency_class_db_  := Inv_Part_Frequency_Class_API.Encode(Client_SYS.Get_Item_Value('FREQUENCY_CLASS', attr_));
   lifecycle_stage_db_  := Inv_Part_Lifecycle_Stage_API.Encode(Client_SYS.Get_Item_Value('LIFECYCLE_STAGE', attr_));
   -- Getting the record to update
   Get_Id_Version_By_Keys___(objid_, objversion_, abc_class_, company_, all_sites_config_, frequency_class_db_, lifecycle_stage_db_);
   -- IF this combination doesn't exist in the table - create it!
   IF objversion_ IS NULL THEN
      Client_SYS.Add_To_Attr('CONTRACT', all_sites_config_, attr_);
      Client_SYS.Add_To_Attr('PLANNING_METHOD_A_B_SWAP', a_b_swap_, attr_);
      IF (action_ = 'CHECK') THEN         
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_, FALSE);         
      ELSIF (action_ = 'DO') THEN         
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_, FALSE);
         Insert___(objid_, objversion_, newrec_, attr_);         
      END IF;
      info_ := Client_SYS.Get_All_Info;
   ELSE
      -- Removing keys from attr_ since keys can't be updated
      oldrec_ := Get_Object_By_Keys___(abc_class_, company_, all_sites_config_, frequency_class_db_, lifecycle_stage_db_);
      IF (oldrec_.planning_method_a_b_swap IS NOT NULL AND (oldrec_.planning_method_a_b_swap = a_b_swap_))THEN 
         Error_SYS.Record_Exist('AbcFrequencyLifecycle');
      END IF;
      attr_with_keys_removed_ := Get_Attr_With_Keys_Removed___(attr_);
      Modify___(info_, objid_, objversion_, attr_with_keys_removed_, action_, a_b_swap_);
   END IF;
END New_A_B_Swap__;


PROCEDURE Modify_A_B_Swap__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2,
   a_b_swap_   IN     VARCHAR2 )
IS
BEGIN
   Modify___(info_, objid_, objversion_, attr_, action_, a_b_swap_);
END Modify_A_B_Swap__;


PROCEDURE Remove_A_B_Swap__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   attr_           VARCHAR2(2000);
   new_objversion_ ABC_FREQUENCY_LIFECYCLE.objversion%TYPE := objversion_;
BEGIN
   -- Using Modify__ to null all planning hierarchy attributes in order to simulate deletion of record.
   Client_SYS.Add_To_Attr('PLANNING_METHOD_A_B_SWAP', to_char(NULL), attr_);
   Modify___(info_, objid_, new_objversion_, attr_, action_, 'N');
END Remove_A_B_Swap__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


