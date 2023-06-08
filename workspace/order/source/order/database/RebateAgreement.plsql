-----------------------------------------------------------------------------
--
--  Logical unit: RebateAgreement
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220105  KaPblk   SC21R2-6605, Modified Prepare_Insert___() by adding IGNORE_INV_CUST_DB. 
--  201108  RasDlk   SCZ-11661, Modified Prepare_Insert___() by adding ALL_SALES_PART_LEVEL.
--  190506  WaSalk   Bug 146756 (SCZ-3247), Modified Get_Agreement_Id___() to check the existence of the agreement id.
--  190506  MaEelk   SCUXXW4-19141, Added validations over Agreement_Type in Check_Update___.
--  181119  MaEelk   SCUXXW4-8282, Generated value of to_agreement_id_ was taken out from Copy_Agreement__ when a value had not been passed into this method.
--  181107  MiKulk   SCUXXW4-9350, Removed the method Activate_Allowed, since the Aurena logic could be handled within client.
--  181020  MiKulk   SCUXXW4-9350, Added method Activate_Allowed.
--  170508  AmPalk   STRMF-11515, Modified Activate__ to update receivers Modified_Date.
--  170324  ThImlk   STRMF-10497, Modified Check_Common___() to add a currency_code validation check.
--  170307  AmPalk   STRMF-6615, Added Agrrement_Info_Rec and Agreement_Info_List.
--  170213  ThImlk   STRMF-8789, Removed the method, Validate_Agr_For_Active___() and related logic, as it's no longer needed.
--  161215  ThImlk   STRMF-8397, Added REBATE_CRITERIA value to Copy_Agreement__() and Prepare_Insert___().
--  161208  ThImlk   STRMF-8327, Added a new method, Get_Rebate_Unit_Meas(). Added CURRENCY_CODE value to Copy_Agreement__().
--  161107  ThImlk   STRMF-7685, Added default value for SALES_REBATE_PART_BASIS in Prepare_Insert___().
--  161107           Also added SALES_REBATE_PART_BASIS value to Copy_Agreement__().
--  161107  RaKAlk   STRMF-7973, Added column agreement_type.
--  161107  RaKalk   STRMF-7687, Modified Copy_Agreement__ to copy deals per sales part.
--  140521  RoJalk   Modified Set_Valid_To___ and changed the Update___ to be done by keys.
--  120405  NaLrlk   Modified Update___ to change from default values when hierarchy_id/customer_level are null.
--  111215  MaMalk   Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110526  ShKolk   Added General_SYS for Validate_Calc_Periods__().
--  091228  AmPalk   Bug 85942, Added Get_Rowstate.
--  091002  DaZase   Added length on view comment for pay_term_id.
--  090730  HimRlk   Merged Bug 81244, Method Set_Valid_To was made an implementation method and modified Finite_State_Machine___ accordingly.
--  090730  HimRlk   Merged Bug 81244, Added Validate_Agr_For_Active___. Modified Unpack_Check_Update___ and Activate__ accordingly.
--  090130  KiSalk   Added hierarchy level check in Unpack_Check_Update___.
--  081211  MaJalk   Changed company reference from Company LU to CompanyFinance LU.
--  081023  JeLise   Added check on assortment_id in Unpack_Check_Update___.
--  081015  JeLise   Added check on hierarchy_id in Unpack_Check_Update___.
--  080918  JeLise   Added validations of assortment_id in Unpack_Check_Insert___, Unpack_Check_Update___ and Activate_.
--  080918           Also added structure_level to Copy_Agreement__.
--  080916  JeLise   Added attribute structure_level.
--  080812  AmPalk   Added Set_Valid_To.
--  080528  JeLise   Added call to Rebate_Agreement_Assort_API.Copy_All_Rebate_Assortments__ in Copy_Agreement__.
--  080519  JeLise   Changed default value for SALES_REBATE_BASIS_ASSORT in Prepare_Insert___. "Added" code to
--  080519           Is_Deal_Per_Assortment and Is_Deal_Per_Rebate_Group
--  080515  JeLise   Added sales_rebate_basis_assort and assortment_id.
--  080513  JeLise   Added method Get_Agreement_Id___.
--  080508  AmPalk   Added Validate_Calc_Periods__.
--  080508  JeLise   Added check on newrec_.customer_level in Unpack_Check_Insert___ to make sure it is not left empty.
--  080507  JeLise   Added check on newrec_.valid_to in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  080430  Mikulk   Added deafult value for SALES_REBATE_BASIS in Prepare_Insert___.
--  080422  JeLise   Added more values to attr_ in Prepare_Insert___.
--  080418  MaJalk   Added method Copy_Agreement__.
--  080416  MaJalk   Added view VIEWJOIN.
--  080414  JeLise   Removed Check_Not_Null on sales_rebate_basis.
--  080407  JeLise   Added sales_rebate_basis.
--  080402  JeLise   Added default values for hierarchy_id and customer_level in Insert___ and Update___.
--  080328  MaHplk   Modified cursors in Active__ method to use table instead of views.
--  080327  JeLise   Removed currency_code.
--  080302  RiLase   Commented cursor in Activate__.
--  080229  RiLase   Fixed >= and <= problems in cursors.
--  080227  JeLise   Fixed red code in IFS/Design.
--  080225  RiLase   Added function Is_Deal_Per_Assortment and Is_Deal_Per_Rebate_Group.
--  080222  RiLase   Added cursor get_active_agreement in Activate__.
--  080212  RiLase   Added check for active agreement in Activate__.
--  080207  JeLise   Reorder the columns in the view.
--  080124  RiLase   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Agrrement_Info_Rec IS RECORD
( agreement_id                   VARCHAR2(10),
  customer_level                 NUMBER,
  hierarchy_id                   VARCHAR2(10),
  customer_parent                VARCHAR2(20)
 );
TYPE Agreement_Info_List IS TABLE OF Agrrement_Info_Rec
     INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Agreement_Id___ RETURN NUMBER
IS
   agreement_id_  NUMBER;
   exist_         BOOLEAN := TRUE;
BEGIN
   WHILE (exist_) LOOP
      SELECT Rebate_Agreement_No_Seq.NEXTVAL INTO agreement_id_ FROM dual;
      exist_ := Check_Exist___(agreement_id_);
   END LOOP;
   RETURN agreement_id_;
END Get_Agreement_Id___;

PROCEDURE Set_Valid_To___ (
   rec_  IN OUT REBATE_AGREEMENT_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_       REBATE_AGREEMENT_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.rowstate = 'Active') THEN
      Client_SYS.Add_To_Attr('VALID_TO', TRUNC(SYSDATE), attr_);
   ELSIF (rec_.rowstate = 'Closed') THEN
      Client_SYS.Add_To_Attr('VALID_TO', TO_DATE(NULL), attr_);
   END IF;
   oldrec_ := rec_;
   Unpack___(rec_, indrec_, attr_);
   Check_Update___(oldrec_, rec_, indrec_, attr_);
   Update___(objid_, oldrec_, rec_, attr_, objversion_, TRUE);
END Set_Valid_To___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   authorize_code_     REBATE_AGREEMENT_TAB.authorize_code%TYPE := User_Default_Api.Get_Authorize_Code;
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('AUTHORIZE_CODE', authorize_code_, attr_);
   Client_SYS.Add_To_Attr('PERIOD_SETTLEMENT_INTERVAL', Calculation_Period_API.Decode('MONTH'), attr_);
   Client_SYS.Add_To_Attr('FINAL_SETTLEMENT_INTERVAL', Calculation_Period_API.Decode('YEAR'), attr_);
   Client_SYS.Add_To_Attr('SALES_REBATE_PART_BASIS', Rebate_Sales_Part_Basis_API.Decode('SPECIFIC_SALES_PART_SALES'), attr_);
   Client_SYS.Add_To_Attr('SALES_REBATE_BASIS', Rebate_Sales_Basis_API.Decode('SPECIFIC_REBATE_GROUP_SALES'), attr_);
   Client_SYS.Add_To_Attr('SALES_REBATE_BASIS_ASSORT', Rebate_Sales_Basis_Assort_API.Decode('SPECIFIC_ASSORT_NODE_SALES'), attr_);
   Client_SYS.Add_To_Attr('REBATE_CRITERIA', Rebate_Criteria_API.Decode('PERCENTAGE'), attr_);
   Client_SYS.Add_To_Attr('ALL_SALES_PART_LEVEL', Rebate_All_Sales_Level_API.Decode('INCLUDE_SALES_PART'), attr_);
   Client_SYS.Add_To_Attr('IGNORE_INV_CUST_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', SYSDATE, attr_);
END Prepare_Insert___;

   
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REBATE_AGREEMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.agreement_id IS NULL) THEN
      newrec_.agreement_id := Get_Agreement_Id___;
   END IF;
   Client_SYS.Add_To_Attr('AGREEMENT_ID', newrec_.agreement_id, attr_);
   newrec_.created_date := trunc(sysdate);
   Client_SYS.Add_To_Attr('CREATED_DATE', newrec_.created_date, attr_);
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);

   -- Set default hierarchy_id and customer_level, since they are necessary on the rebate agreement grp deal lines
   IF newrec_.hierarchy_id IS NULL THEN
      newrec_.hierarchy_id := '*';
      Client_SYS.Add_To_Attr('HIERARCHY_ID', newrec_.hierarchy_id, attr_);
   END IF;
   IF newrec_.hierarchy_id = '*' AND newrec_.customer_level IS NULL THEN
      newrec_.customer_level := 0;
      Client_SYS.Add_To_Attr('CUSTOMER_LEVEL', newrec_.customer_level, attr_);
   END IF;

   -- IF hierarchy_id is not null then customer_level must have a value too.
   IF newrec_.hierarchy_id IS NOT NULL AND newrec_.customer_level IS NULL THEN
      Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_LEVEL', newrec_.customer_level);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     REBATE_AGREEMENT_TAB%ROWTYPE,
   newrec_     IN OUT REBATE_AGREEMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   -- Set default hierarchy_id and customer_level, since they are necessary on the rebate agreement grp deal lines
   IF newrec_.hierarchy_id IS NULL THEN
      newrec_.hierarchy_id := '*';
      Client_SYS.Add_To_Attr('HIERARCHY_ID', newrec_.hierarchy_id, attr_);
      newrec_.customer_level := 0;
      Client_SYS.Add_To_Attr('CUSTOMER_LEVEL', newrec_.customer_level, attr_);
   END IF;
   IF newrec_.hierarchy_id = '*' AND newrec_.customer_level IS NULL THEN
      newrec_.customer_level := 0;
      Client_SYS.Add_To_Attr('CUSTOMER_LEVEL', newrec_.customer_level, attr_);
   END IF;
   -- IF hierarchy_id is not null then customer_level must have a value too.
   IF newrec_.hierarchy_id IS NOT NULL AND newrec_.customer_level IS NULL THEN
      Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_LEVEL', newrec_.customer_level);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     rebate_agreement_tab%ROWTYPE,
   newrec_ IN OUT rebate_agreement_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.agreement_type IS NULL THEN
      IF newrec_.assortment_id IS NOT NULL THEN
         newrec_.agreement_type := Rebate_Agreement_Type_API.DB_ASSORTMENT;
      ELSE
         newrec_.agreement_type := Rebate_Agreement_Type_API.DB_REBATE_GROUP;
      END IF;
   ELSE
      IF newrec_.agreement_type != Rebate_Agreement_Type_API.DB_ASSORTMENT AND
         newrec_.assortment_id IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_,'INVTYPEASSORTMENT: Agreement type must be set to Assortment in order to connect the agreement with an assortment.');
      END IF;
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   IF (indrec_.hierarchy_id) THEN
      Customer_Hierarchy_API.Exist(newrec_.hierarchy_id);
   END IF;
   -- Check if valid_to is earlier than valid_from
   IF newrec_.valid_to < newrec_.valid_from THEN
      Error_SYS.Record_General(lu_name_, 'EARLY_VALID_TO: The Valid To date cannot be earlier than Valid From date.');
   END IF;

   IF newrec_.assortment_id IS NOT NULL AND newrec_.structure_level IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'STRUCTURE_LEVEL: Assortment Level must have a value when Assortment ID is entered.');
   END IF;
   Validate_Calc_Periods__(newrec_.final_settlement_interval, newrec_.period_settlement_interval);   
   Iso_Currency_API.Exist(newrec_.currency_code);

END Check_Common___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     rebate_agreement_tab%ROWTYPE,
   newrec_ IN OUT rebate_agreement_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   last_cal_date_    DATE := Database_SYS.last_calendar_date_;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF oldrec_.agreement_type != newrec_.agreement_type THEN
      IF (newrec_.agreement_type != Rebate_Agreement_Type_API.DB_SALES_PART) AND (Rebate_Agr_Sales_Part_Deal_API.Check_Exist(newrec_.agreement_id) > 0)THEN
         Error_SYS.Record_General(lu_name_, 'PARTSEXIST: Remove the entered lines in Deal per Sales Part tab in order to change the Rebate Type'); 
      ELSIF (newrec_.agreement_type != Rebate_Agreement_Type_API.DB_REBATE_GROUP) AND (Rebate_Agreement_Grp_Deal_API.Check_Exist(newrec_.agreement_id) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'REBATEGROUPSSEXIST: Remove the entered lines in Deal per Rebate Group Tab in order to change the Rebate Type');      
      ELSIF (newrec_.agreement_type != Rebate_Agreement_Type_API.DB_ASSORTMENT) AND (Rebate_Agreement_Assort_API.Check_Exist(newrec_.agreement_id) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'ASSORTMENTSEXIST: Remove the entered lines in Deal per Assortmnt Tab in order to change the Rebate Type');
      ELSIF (newrec_.agreement_type != Rebate_Agreement_Type_API.DB_ALL) AND (Rebate_Agr_All_Deal_API.Check_Exist(newrec_.agreement_id) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'DEALFORALLSPSEXIST: Remove the entered lines in Deal for All Sales Parts tab in order to change the Rebate Type');    
      END IF;
   END IF;
   
   IF oldrec_.hierarchy_id != newrec_.hierarchy_id THEN
      IF newrec_.hierarchy_id = '*' THEN
         newrec_.customer_level := 0;
      END IF;
      IF (oldrec_.customer_level = newrec_.customer_level) THEN
         Customer_Hierarchy_Level_API.Exist(newrec_.hierarchy_id, newrec_.customer_level);
      END IF;
      IF Rebate_Agreement_Receiver_API.Check_Exist(newrec_.agreement_id) = 1 OR
         Rebate_Agreement_Grp_Deal_API.Check_Exist(newrec_.agreement_id) = 1 OR
         Rebate_Agreement_Assort_API.Check_Exist(newrec_.agreement_id) = 1 THEN

         Error_SYS.Record_General(lu_name_, 'HIERARCHY: Hierarchy ID can be changed when no Receivers or Deal lines exist.');
      END IF;
   ELSIF (oldrec_.customer_level != newrec_.customer_level) THEN
      IF (Rebate_Agreement_Receiver_API.Check_Exist(newrec_.agreement_id) = 1) THEN
         Error_SYS.Record_General(lu_name_, 'CUSTLEVELERR: Customer hierarchy level cannot be changed when Receivers exist.');
      END IF;
      IF (newrec_.customer_level > Rebate_Agreement_Grp_Deal_API.Get_Minimum_Customer_Level(newrec_.agreement_id)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDHEADLEVEL: The hierarchy level cannot be greater than the level in the deal lines.');
      END IF;
   END IF;

   IF nvl(oldrec_.assortment_id, '*') != newrec_.assortment_id OR nvl(oldrec_.structure_level, 0) != newrec_.structure_level THEN
      IF newrec_.rowstate != 'Planned' OR Rebate_Agreement_Assort_API.Check_Exist(newrec_.agreement_id) = 1 THEN
         Error_SYS.Record_General(lu_name_, 'ASSORTMENT: Assortment can only be changed when the Agreement is in status Planned and no Deal lines exist.');
      END IF;
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_Agreement__
--   Copies an Existing agreement to a new one.
PROCEDURE Copy_Agreement__ (
   to_agreement_id_     IN OUT VARCHAR2,
   agreement_id_        IN     VARCHAR2,
   valid_from_date_     IN     DATE,
   to_agreement_desc_   IN     VARCHAR2,
   to_currency_code_    IN     VARCHAR2,
   to_company_          IN     VARCHAR2,
   to_valid_from_date_  IN     DATE,
   currency_rate_       IN     NUMBER,
   copy_doc_text_       IN     NUMBER,
   copy_notes_          IN     NUMBER )
IS
   attr_                    VARCHAR2(20000);
   copyrec_                 REBATE_AGREEMENT_TAB%ROWTYPE;
   newrec_                  REBATE_AGREEMENT_TAB%ROWTYPE;
   new_company_             REBATE_AGREEMENT_TAB.company%TYPE;
   new_note_id_             REBATE_AGREEMENT_TAB.note_id%TYPE;
   currtype_                VARCHAR2(10);
   conv_factor_             NUMBER;
   temp_currency_rate_      NUMBER;
   rate_                    NUMBER;
   objid_                   VARCHAR2(2000);
   objversion_              VARCHAR2(2000);
   from_currency_code_      VARCHAR2(3);
   dummy_                   NUMBER;
   company_                 REBATE_AGREEMENT_TAB.company%TYPE;
   indrec_                  Indicator_Rec;

   CURSOR get_attr IS
      SELECT *
      FROM REBATE_AGREEMENT_TAB
      WHERE agreement_id = agreement_id_;
   CURSOR user_company (company_ VARCHAR2) IS
      SELECT 1
      FROM COMPANY_FINANCE_AUTH_PUB
      WHERE company = company_;
BEGIN
   company_ := Rebate_Agreement_API.Get_Company(agreement_id_);
   OPEN user_company(company_);
   FETCH user_company INTO dummy_;
   IF (user_company%NOTFOUND) THEN
      CLOSE user_company;
      Error_SYS.Record_General(lu_name_, 'VALIDCOMPANY: Agreement :P1 belongs to company :P2. It is not allowed to copy agreements from companies that you are not connected to.', agreement_id_, company_);
   END IF;
   CLOSE user_company;

   IF (to_valid_from_date_ IS NOT NULL) AND (valid_from_date_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'VALIDFROMDATE: The Valid From must be entered on the source agreement when using Valid From on the destination agreement.');
   END IF;

   -- Check if from agreement exist
   IF (NOT Check_Exist___(agreement_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOAGREEMENTEXIST: Rebate Agreement :P1 does not exist.', agreement_id_);
   END IF;

   -- From Rebate Agreement
   OPEN get_attr;
   FETCH get_attr INTO copyrec_;
   CLOSE get_attr;

   Prepare_Insert___(attr_);

   IF (to_agreement_id_ IS NOT NULL ) THEN
      -- Check if to agreement already exists
      IF (Check_Exist___(to_agreement_id_)) THEN
         Error_SYS.Record_General(lu_name_, 'AGREEMENTEXIST: Rebate Agreement :P1 already exist.', to_agreement_id_);
      END IF;
      Client_SYS.Add_To_Attr('AGREEMENT_ID', to_agreement_id_, attr_);
   END IF;

   IF (to_company_ IS NOT NULL ) THEN
      Company_Finance_API.Exist(to_company_);
      new_company_ := to_company_;
   ELSE
      new_company_ := copyrec_.company;
   END IF;

   Client_SYS.Add_To_Attr('DESCRIPTION',        to_agreement_desc_, attr_);   
   Client_SYS.Add_To_Attr('COMPANY',            new_company_, attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_TYPE_DB',  copyrec_.agreement_type, attr_);
   Client_SYS.Add_To_Attr('AUTHORIZE_CODE',     copyrec_.authorize_code, attr_);
   Client_SYS.Add_To_Attr('HIERARCHY_ID',       copyrec_.hierarchy_id, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL',     copyrec_.customer_level, attr_);
   Client_SYS.Add_To_Attr('PAY_TERM_ID',        copyrec_.pay_term_id, attr_);
   Client_SYS.Add_To_Attr('SALES_REBATE_PART_BASIS_DB',  copyrec_.sales_rebate_part_basis, attr_);
   Client_SYS.Add_To_Attr('SALES_REBATE_BASIS_DB', copyrec_.sales_rebate_basis, attr_);
   Client_SYS.Add_To_Attr('SALES_REBATE_BASIS_ASSORT_DB', copyrec_.sales_rebate_basis_assort, attr_);
   Client_SYS.Add_To_Attr('PAY_TERM_ID',        copyrec_.pay_term_id, attr_);
   Client_SYS.Set_Item_Value('VALID_FROM',      NVL(to_valid_from_date_, copyrec_.valid_from), attr_);
   Client_SYS.Add_To_Attr('FINAL_SETTLEMENT_INTERVAL_DB',   copyrec_.final_settlement_interval, attr_);
   Client_SYS.Add_To_Attr('PERIOD_SETTLEMENT_INTERVAL_DB',  copyrec_.period_settlement_interval, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID',      copyrec_.assortment_id, attr_);
   Client_SYS.Add_To_Attr('STRUCTURE_LEVEL',    copyrec_.structure_level, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE',      NVL(to_currency_code_,copyrec_.currency_code), attr_);
   Client_SYS.Add_To_Attr('REBATE_CRITERIA_DB',      copyrec_.rebate_criteria, attr_);
   Client_SYS.Add_To_Attr('UNIT_OF_MEASURE',      copyrec_.unit_of_measure, attr_);

   IF (copy_notes_ = 1) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', copyrec_.note_text, attr_);
   END IF;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   to_agreement_id_ := newrec_.agreement_id;
   new_note_id_ := Client_SYS.Get_Item_Value('NOTE_ID', attr_);

   IF (copy_doc_text_ = 1) THEN
      -- Copy document texts to the new agreement
      Document_Text_API.Copy_All_Note_Texts(copyrec_.note_id, new_note_id_);
   END IF;

   IF (currency_rate_ IS NULL) THEN
      from_currency_code_ := Company_Finance_API.Get_Currency_Code(copyrec_.company);
      IF (from_currency_code_ = to_currency_code_) THEN
         temp_currency_rate_ := 1;
      ELSE
         Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, copyrec_.company, from_currency_code_, SYSDATE, 'CUSTOMER', NULL);
         -- Currence rate for Source agreement's currency to base currency
         temp_currency_rate_ := rate_ / conv_factor_;
         Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, copyrec_.company, to_currency_code_, SYSDATE, 'CUSTOMER', NULL);
         -- Currence rate for new agreement's currency from Source agreement's currency
         temp_currency_rate_ := temp_currency_rate_ * conv_factor_ / rate_ ;
      END IF;
   ELSE
      temp_currency_rate_ := currency_rate_;
   END IF;

   -- Copy all rows on Rebate Agreement - Receivers.
   Rebate_Agreement_Receiver_API.Copy_All_Receivers__(agreement_id_, to_agreement_id_);

   -- Copy all rows on Rebate Agreement - Deal Per Rebate Group.
   Rebate_Agreement_Grp_Deal_API.Copy_All_Rebate_Group_Deals__(agreement_id_, to_agreement_id_, valid_from_date_, to_valid_from_date_, temp_currency_rate_);   
   -- Copy all rows on Rebate Agreement - Deal Per Assortment.
   Rebate_Agreement_Assort_API.Copy_All_Rebate_Assortments__(agreement_id_, to_agreement_id_, valid_from_date_, to_valid_from_date_, temp_currency_rate_);
   -- Copy all rows on Rebate Agreement - Deal Per Sales Part.
   Rebate_Agr_Sales_Part_Deal_API.Copy_All_Sales_Part_Deals__(agreement_id_, to_agreement_id_, valid_from_date_, to_valid_from_date_, temp_currency_rate_);
   -- Copy all rows on Rebate Agreement - All Sales Part.
   Rebate_Agr_All_Deal_API.Copy_All_Deals__(agreement_id_, to_agreement_id_, valid_from_date_, to_valid_from_date_, temp_currency_rate_);
END Copy_Agreement__;


PROCEDURE Validate_Calc_Periods__ (
   final_stlmt_interval_ IN VARCHAR2,
   prel_stlmt_interval_  IN VARCHAR2)
IS
BEGIN
   IF (final_stlmt_interval_ = 'HALF_YEAR' AND prel_stlmt_interval_ = 'YEAR') OR
      (final_stlmt_interval_ = 'QUARTER' AND (prel_stlmt_interval_ IN ('HALF_YEAR', 'YEAR'))) OR
      (final_stlmt_interval_ = 'MONTH' AND (prel_stlmt_interval_ IN ('QUARTER', 'HALF_YEAR', 'YEAR')))
      THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDINVERVELS: The final settlement interval must be grater than the periodic settlement interval.');
   END IF;
END Validate_Calc_Periods__;


@Override
PROCEDURE Activate__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ REBATE_AGREEMENT_TAB%ROWTYPE;
   state_ VARCHAR2(20);
   CURSOR get_assortment_state(assortment_id_ VARCHAR2) IS
      SELECT objstate
      FROM assortment_structure
      WHERE assortment_id = assortment_id_;
      
   CURSOR get_valid_customers(agreement_id_ VARCHAR2) IS 
      SELECT customer_no
      FROM REBATE_AGREEMENT_RECEIVER_TAB
      WHERE agreement_id = agreement_id_;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
      
      -- Check to see that the Assortment is in state 'Active'
      OPEN get_assortment_state(rec_.assortment_id);
      FETCH get_assortment_state INTO state_;
      CLOSE get_assortment_state;
      IF state_ != 'Active' THEN
         Error_SYS.State_General('RebateAgreement', 'ASSORTMENTSTATE: The Assortment ":P1" is not Active and cannot be used in this agreement.', rec_.assortment_id);
      END IF; 
      
      FOR c_ IN get_valid_customers(rec_.agreement_id) LOOP
         Rebate_Agreement_Receiver_API.Update_Modified_Date(rec_.agreement_id, c_.customer_no);
      END LOOP;
      
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
END Activate__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Is_Deal_Per_Rebate_Group (
   agreement_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Get_Assortment_Id(agreement_id_) IS NOT NULL) THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;
END Is_Deal_Per_Rebate_Group;


@UncheckedAccess
FUNCTION Is_Deal_Per_Assortment (
   agreement_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Get_Assortment_Id(agreement_id_) IS NOT NULL) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Deal_Per_Assortment;


-- Get_Rowstate
--   Return the current state (DB value).
@UncheckedAccess
FUNCTION Get_Rowstate (
   agreement_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ REBATE_AGREEMENT_TAB.rowstate%TYPE;
   CURSOR get_attr IS
      SELECT rowstate
      FROM REBATE_AGREEMENT_TAB
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Rowstate;

@UncheckedAccess
FUNCTION Get_Rebate_Unit_Meas (
   company_         IN VARCHAR2,
   rebate_criteria_ IN VARCHAR2) RETURN VARCHAR2
IS
   rebate_criteria_db_  REBATE_AGREEMENT_TAB.rebate_criteria%TYPE;
   unit_of_measure_     REBATE_AGREEMENT_TAB.unit_of_measure%TYPE;
BEGIN
   rebate_criteria_db_ := Rebate_Criteria_API.Encode(rebate_criteria_);
   IF (rebate_criteria_db_ = Rebate_Criteria_API.DB_AMOUNT_PER_NET_WEIGHT)THEN
      unit_of_measure_ := Company_Invent_Info_API.Get_Uom_For_Weight(company_);
   ELSIF (rebate_criteria_db_ = Rebate_Criteria_API.DB_AMOUNT_PER_NET_VOLUME)THEN
      unit_of_measure_ := Company_Invent_Info_API.Get_Uom_For_Volume(company_);
   ELSE 
      unit_of_measure_ := NULL; 
   END IF;   
   RETURN unit_of_measure_;
END Get_Rebate_Unit_Meas;


