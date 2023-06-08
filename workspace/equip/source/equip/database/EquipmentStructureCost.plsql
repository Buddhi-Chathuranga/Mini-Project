-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentStructureCost
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131219  MAWILK  PBSA-3311, Merge common parts of Check_Insert___ and Check_Update___ into Check_Common___
--  131216  CLHASE  PBSA-3215, Moved seq_no generation from Check_Insert___ to Insert___.
--  131204  MAWILK  PBSA-1823, Hooks: refactoring and splitting.
--  121213  SHAFLK  Bug 107335, Added ORDER_CONTRACT and modified cost calculation methods. 
--  120216  MAWILK  Bug 101259,Modified Get_Object_Cost,Get_Object_Structure_Cost,Get_Object_Revenue,Get_Object_Structure_Revenue.
--  110803  PRIKLK SADEAGLE-1739, Added user_allowed_site filter to view EQUIPMENT_STRUCTURE_COST
--  110430  NEKOLK  EASTONE-17408 :Removed the Objkey from the view EQUIPMENT_COST_YEAR 
--  110127  NEKOLK  EANE-3710 added User_Allowed_Site_API.Authorized filter to View EQUIPMENT_COST_YEAR.
--  101021  NIFRSE  Bug 93384, Updated view column prompts to 'Object Site'.
--  -------------------------Project Eagle-----------------------------------
--  090730  SHAFLK Bug 85005, Modified Update_Cost_Line.
--  090602  LIAMLK Bug 82609, Added missing undefine statements.
--  080506  LIAMLK Bug 69438, Removed General_SYS.Init_Method from Get_Cost_Per_Type, Get_Total_Cost_Year.
--  071215  NIJALK Bug 69387, Added view EQUIPMENT_STRUCTURE_COST_SUM.
--  071129  SHAFLK Bug 69441, Added method Update_Cost_Line.
--  071127  LIAMLK Bug 69011, Added function Cost_Line_Exist.
--  071120  SHAFLK Bug 69282, Modified Get_Object_Structure_Revenue,Insert_Structure_Cost and Insert_Structure_Revenue. 
--  071115  SHAFLK Bug 69282, Modified Get_Object_Structure_Cost.
--  070516  LoPrlk Call ID: 144490, Altered the methods Get_Object_Cost,Get_Object_Structure_Cost, Get_Object_Revenue, 
--  070516         Get_Object_Structure_Revenue and Is_Object_Exceed_Cost.
--  060918  ILSOLK Merged Bug 60266.
--  060905  SHAFLK Bug ID:60266 - Added new method Update_Equip_Structure_Cost.
--  060111  DiAmlk Bug ID:130860 - Added new method Is_Object_Exceed_Cost.
--  050914  Japalk Removed connect By clause from Insert_Structure_Cost and Insert_Structure_Revenue.
--  050831  DiAmlk Bug ID:126234 - Modified the methods Get_Object_Cost,Get_Object_Revenue,Get_Object_Structure_Cost
--                 and Get_Object_Structure_Revenue.
--  050829  DiAmlk Bug IDs:126612,126691 - Modified the methods Get_Object_Cost,Get_Object_Revenue,Get_Object_Structure_Cost
--                 and Get_Object_Structure_Revenue.
--  050804  DiAmlk Bug ID:126086 - Modified the Method signature of Get_Object_Cost,Get_Object_Revenue,Get_Object_Structure_Cost
--                 and Get_Object_Structure_Revenue.
--  050801  DiAmlk Bug ID:126084 - Modified the view EQUIPMENT_STRUCTURE_COST.
--  050714  DiAmlk Number Fields Order_No and Line_No converted to VARCHAR2.Added new columns
--                 cost_source,rel_no and line_item_no in order to add cost and revenue coming from CO.
--                 Modified the method signature of Insert_Structure_Cost and Insert_Structure_Revenue.
--  050706  Japalk Modified the view.
--  050623  DiAmlk Bug ID:125141 - Modified the methods Unpack_Check_Insert___ and Unpack_Check_Update___.
--  050622  Japalk Added dynamic calls to PROJECT_API.
--  050620  Japalk Changed Get_Object_Cost method.
--  050617  ChAmlk Removed Fixed Price from view EQUIPMENT_COST_YEAR.
--  050610  Japlak Undo the changes done in 050608.
--  050608  DiAmlk Modified the methods Insert_Structure_Cost and Insert_Structure_Revenue.
--  050608  Japalk Added Dynamic calls to CONVERT_TO_CURRENCY method.
--  050510  Japalk Modifed Insert_Structure_Cost method.
--  050509  ChAmlk Created view EQUIPMENT_COST_YEAR. Added functions Get_Cost_Per_Type()
--                 and Get_Total_Cost_Year.
--  050426  DiAmlk Added new methods Update_Cost_Revenue,Remove_Obj_Cost,Remove_Structure_Cost and Remove_Structure_Revenue.
--                 (Relate to spec AMUT113-Cost Follow Up)
--  050406  JAPALK Created
--  140814  HASTSE  Replaced dynamic code and cleanup
--  141020  SHAFLK  PRSA-3709,Removed EQUIPMENT_ALL_OBJECT.
--  150324  NRATLK  RUBY-133, Modified Check_Insert___() to validate the passed cre_date.
--  150401  NRATLK  LCS Bug ID 121820, Modified Check_Insert___() to validate the passed cre_date.
--  160809  NiFrSE  STRSA-9401, Fix Read-only access by added UncheckedAccess annotation the the methods; Get_Object_Cost(),
--                  Get_Object_Structure_Cost(), Get_Object_Revenue() and Get_Object_Structure_Revenue().
--  161031  NiFrSE  STRSA-14584, Change call using Work_Order_Planning_Util_API to Service_Pricing_API.
--  180821  LoPrlk  SAUXXW4-1261, Added the method Translate__.
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Calculated_Totals_Rec IS RECORD (
   cost_type VARCHAR2(100),
   structure_cost NUMBER,
   object_cost NUMBER,
   structure_revenue NUMBER,
   object_revenue NUMBER,
   structure_profit_margin NUMBER,
   object_profit_margin NUMBER
   );

TYPE Calculated_Totals_Arr IS TABLE OF Calculated_Totals_Rec;

TYPE Cost_Revenue_Graph_Rec IS RECORD (
   cost_revenue_type VARCHAR2(100),
   personnel NUMBER,
   material NUMBER,
   tool_equipment NUMBER,
   external NUMBER,
   expences NUMBER,
   fixed_price NUMBER,
   direct_sales NUMBER,
   contract_invoicing NUMBER,
   total NUMBER
   );

TYPE Cost_Revenue_Graph_Arr IS TABLE OF Cost_Revenue_Graph_Rec;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Object_Cost_Revenue___ (
   personnel_cost_    OUT NUMBER,
   material_cost_     OUT NUMBER,
   tool_cost_         OUT NUMBER,
   external_cost_     OUT NUMBER,
   expense_cost_      OUT NUMBER,
   fixed_price_cost_  OUT NUMBER,
   direct_sales_cost_ OUT NUMBER,
   contr_inv_cost_    OUT NUMBER,
   mch_code_          IN  VARCHAR2,
   mch_code_contract_ IN  VARCHAR2,
   sup_mch_code_      IN  VARCHAR2,
   sup_contract_      IN  VARCHAR2,
   date_from_         IN  TIMESTAMP,
   date_to_           IN  TIMESTAMP,
   selection_         IN  VARCHAR2,
   project_no_        IN  VARCHAR2,
   currency_          IN  VARCHAR2,
   return_type_       IN  VARCHAR2 )
IS

   TYPE rowTypeCursor IS REF CURSOR;

   stmt_    VARCHAR2(2000);
   get_cost_lines_cursor_   rowTypeCursor;
   equipment_obj_cost_type_ VARCHAR2(9);

   cost_                    NUMBER;
   cost_from_structure_     NUMBER;
   revenue_                 NUMBER;
   revenue_from_structure_  NUMBER;

   cost_in_                 NUMBER;
   cost_out_                NUMBER;
   object_contract_         VARCHAR2(10);
   current_company_         VARCHAR2(20);
   from_currency_           VARCHAR2(20);
   temp_sup_mch_code_       EQUIPMENT_STRUCTURE_COST_TAB.sup_mch_code%TYPE;
   temp_sup_contract_       EQUIPMENT_STRUCTURE_COST_TAB.sup_contract%TYPE;
   cursor_opened_           VARCHAR2(5):= 'FALSE';

BEGIN

   personnel_cost_   :=0;
   material_cost_    :=0;
   tool_cost_        :=0;
   external_cost_    :=0;
   expense_cost_     :=0;
   fixed_price_cost_ :=0;
   direct_sales_cost_:=0;
   contr_inv_cost_   :=0;

   temp_sup_mch_code_ := sup_mch_code_;
   temp_sup_contract_ := sup_contract_;

   IF (sup_mch_code_ IS NOT NULL AND sup_contract_ IS NOT NULL AND
       mch_code_ IS NOT NULL AND mch_code_contract_ IS NOT NULL AND
       sup_mch_code_ = mch_code_ AND sup_contract_ = mch_code_contract_) THEN
       temp_sup_mch_code_ := NULL;
       temp_sup_contract_ := NULL;
   END IF;

   IF ( mch_code_contract_ = User_Allowed_Site_API.Authorized(mch_code_contract_) )  THEN
      IF selection_='Exclude Project Cost/Revenue' THEN
         stmt_:= 'SELECT contract,equipment_obj_cost_type,cost,cost_from_structure, revenue, revenue_from_structure, currency_code
                  FROM EQUIPMENT_STRUCTURE_COST_TAB t
                  WHERE t.mch_code     =  :mch_code_
                  AND t.contract       =  :mch_code_contract_
                  AND NVL(t.sup_mch_code,''%'') LIKE NVL(:sup_mch_code_,''%'')
                  AND NVL(t.sup_contract,''%'') LIKE NVL(:sup_contract_,''%'')
                  AND t.cre_date BETWEEN :date_from_ AND :date_to_
                  AND t.order_contract IN (SELECT site FROM user_allowed_site_pub) 
                  AND t.project_id IS NULL';
         @ApproveDynamicStatement(2006-02-06,nilase)
         OPEN  get_cost_lines_cursor_ FOR stmt_ USING  mch_code_,mch_code_contract_,temp_sup_mch_code_,temp_sup_contract_,date_from_,date_to_;
         cursor_opened_ := 'TRUE';

      ELSIF selection_='Include Project Cost/Revenue' THEN
         stmt_:= 'SELECT contract,equipment_obj_cost_type,cost,cost_from_structure, revenue, revenue_from_structure,currency_code
                  FROM EQUIPMENT_STRUCTURE_COST_TAB t
                  WHERE t.mch_code     =  :mch_code_
                  AND t.contract       =  :mch_code_contract_
                  AND NVL(t.sup_mch_code,''%'') LIKE NVL(:sup_mch_code_,''%'')
                  AND NVL(t.sup_contract,''%'') LIKE NVL(:sup_contract_,''%'')
                  AND t.cre_date BETWEEN :date_from_ AND :date_to_
                  AND t.order_contract IN (SELECT site FROM user_allowed_site_pub)';
         @ApproveDynamicStatement(2006-02-06,nilase)
         OPEN  get_cost_lines_cursor_ FOR stmt_ USING  mch_code_,mch_code_contract_,temp_sup_mch_code_,temp_sup_contract_,date_from_,date_to_;
         cursor_opened_ := 'TRUE';

      ELSIF selection_='Show Project' THEN

         IF (project_no_ IS NULL) OR (project_no_='%')  THEN
            stmt_:= 'SELECT contract,equipment_obj_cost_type,cost,cost_from_structure, revenue, revenue_from_structure,currency_code
                     FROM EQUIPMENT_STRUCTURE_COST_TAB t
                     WHERE t.mch_code     =  :mch_code_
                     AND t.contract       =  :mch_code_contract_
                     AND NVL(t.sup_mch_code,''%'') LIKE NVL(:sup_mch_code_,''%'')
                     AND NVL(t.sup_contract,''%'') LIKE NVL(:sup_contract_,''%'')
                     AND t.cre_date BETWEEN :date_from_ AND :date_to_
                     AND t.order_contract IN (SELECT site FROM user_allowed_site_pub)
                     AND t.project_id IS NOT NULL';
            @ApproveDynamicStatement(2006-02-06,nilase)
            OPEN  get_cost_lines_cursor_ FOR stmt_ USING  mch_code_,mch_code_contract_,temp_sup_mch_code_,temp_sup_contract_,date_from_,date_to_;
            cursor_opened_ := 'TRUE';

         ELSE
            stmt_:= 'SELECT contract,equipment_obj_cost_type,cost,cost_from_structure, revenue, revenue_from_structure,currency_code
                        FROM EQUIPMENT_STRUCTURE_COST_TAB t
                        WHERE t.mch_code     =  :mch_code_
                        AND t.contract       =  :mch_code_contract_
                        AND NVL(t.sup_mch_code,''%'') LIKE NVL(:sup_mch_code_,''%'')
                        AND NVL(t.sup_contract,''%'') LIKE NVL(:sup_contract_,''%'')
                        AND t.cre_date BETWEEN :date_from_ AND :date_to_
                        AND t.order_contract IN (SELECT site FROM user_allowed_site_pub)
                        AND t.project_id=:project_no_';
            @ApproveDynamicStatement(2006-02-06,nilase)
            OPEN  get_cost_lines_cursor_ FOR stmt_ USING  mch_code_,mch_code_contract_,temp_sup_mch_code_,temp_sup_contract_,date_from_,date_to_,project_no_;
            cursor_opened_ := 'TRUE';

         END IF;
       END IF;
   END IF;

   IF (cursor_opened_ = 'TRUE') THEN
      current_company_:=Site_api.Get_Company(User_Default_API.Get_Contract);
      LOOP
         FETCH get_cost_lines_cursor_ INTO object_contract_,equipment_obj_cost_type_,cost_,cost_from_structure_, revenue_, revenue_from_structure_,from_currency_;
         EXIT WHEN get_cost_lines_cursor_%NOTFOUND;

         IF (return_type_ = 'COST') THEN
            cost_in_ := cost_;
         ELSIF (return_type_ = 'REVENUE') THEN
            cost_in_ := revenue_;
         ELSIF (return_type_ = 'STRUCT_COST') THEN
            cost_in_ := nvl(cost_from_structure_,0)+ nvl(cost_,0);
         ELSIF (return_type_ = 'STRUCT_REVENUE') THEN
            cost_in_ := nvl(revenue_from_structure_,0)+ nvl(revenue_,0);
         ELSE
            cost_in_ := 0;
         END IF;

         IF  (currency_ !=  from_currency_) THEN
            cost_out_ := Service_Pricing_API.Convert_To_Currency(current_company_, nvl(cost_in_, 0), currency_, from_currency_);
         ELSE
            cost_out_ := cost_in_;
         END IF;
 
         IF equipment_obj_cost_type_ = Equipment_Obj_Cost_Type_API.DB_PERSONNEL THEN
           personnel_cost_    := personnel_cost_     + nvl(cost_out_, 0);
         ELSIF equipment_obj_cost_type_ = Equipment_Obj_Cost_Type_API.DB_MATERIAL THEN
           material_cost_     := material_cost_     + nvl(cost_out_, 0);
         ELSIF equipment_obj_cost_type_ = Equipment_Obj_Cost_Type_API.DB_EXTERNAL THEN
           external_cost_     := external_cost_     + nvl(cost_out_, 0);
         ELSIF equipment_obj_cost_type_ = Equipment_Obj_Cost_Type_API.DB_EXPENSES THEN
           expense_cost_      := expense_cost_      + nvl(cost_out_, 0);
         ELSIF equipment_obj_cost_type_ = Equipment_Obj_Cost_Type_API.DB_FIXED_PRICE THEN
           fixed_price_cost_  :=fixed_price_cost_   + nvl(cost_out_, 0);
         ELSIF equipment_obj_cost_type_ = Equipment_Obj_Cost_Type_API.DB_TOOLS_FACILITIES THEN
           tool_cost_         := tool_cost_         + nvl(cost_out_, 0);
         ELSIF equipment_obj_cost_type_ = 'D' THEN
           direct_sales_cost_ := direct_sales_cost_ + nvl(cost_out_, 0);
         ELSIF equipment_obj_cost_type_ = 'C' THEN
           contr_inv_cost_    := contr_inv_cost_    + nvl(cost_out_, 0);
         END IF;
      END LOOP;
      CLOSE get_cost_lines_cursor_;

   END IF;

END Get_Object_Cost_Revenue___;


PROCEDURE Insert_Structure___ (
   mch_code_          IN VARCHAR2,
   mch_contract_      IN VARCHAR2,
   cost_type_db_      IN VARCHAR2,
   cre_date_          IN DATE,
   amount_            IN NUMBER,
   order_contract_    IN VARCHAR2,
   percent_of_source_ IN NUMBER,
   cost_source_       IN VARCHAR2,
   source_ref1_       IN VARCHAR2,
   source_ref2_       IN VARCHAR2,
   source_ref3_       IN VARCHAR2,
   source_ref4_       IN VARCHAR2,
   cost_revenue_      IN VARCHAR2,
   row_checked_       IN VARCHAR2 )
IS  
  company_              VARCHAR2(20);
  current_company_      VARCHAR2(20);
  company_contract_     VARCHAR2(30);

  currency_code_        VARCHAR2(20);
  coverted_amount_      NUMBER;
  project_no_           VARCHAR2(30);
  order_company_        VARCHAR2(20);
  current_mch_contract_ VARCHAR2(30);
  current_mch_code_     VARCHAR2(300);
  current_equip_obj_sq_ NUMBER;
  current_sup_contract_ VARCHAR2(30);
  current_sup_mch_code_ VARCHAR2(300);
  current_func_obj_sq_  NUMBER;
  attr_                 VARCHAR2(2000);
  save_attr_            VARCHAR2(2000);
  newrec_               EQUIPMENT_STRUCTURE_COST_TAB%ROWTYPE;
  indrec_               Indicator_Rec;
  objid_                VARCHAR2(20);
  objversion_           VARCHAR2(2000);
  CURSOR get_parent_objects_(sup_contract_ VARCHAR2 ,sup_mch_code_ VARCHAR2) IS
      SELECT  contract,mch_code,sup_contract,sup_mch_code, equipment_object_seq, functional_object_seq
      FROM   Equipment_Object
      WHERE  contract = sup_contract_
      AND    mch_code = sup_mch_code_;
BEGIN
   

   current_company_  := NULL;
   company_contract_ := NULL;
   order_company_:=Site_api.Get_Company(order_contract_);

   $IF Component_Wo_SYS.INSTALLED $THEN
      IF (cost_source_ = 'WO') THEN
         IF (source_ref2_ IS NOT NULL) THEN
            project_no_ := Work_Order_API.Get_Project_No(Jt_Task_API.Get_Wo_No(source_ref2_));
         ELSIF (source_ref1_ IS NOT NULL AND source_ref1_ != '*') THEN
            project_no_ := Work_Order_API.Get_Project_No(source_ref1_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END

   ----Creating Attr String

   Client_SYS.Clear_Attr(attr_);

   Client_Sys.Add_To_Attr('CRE_DATE',cre_date_,attr_);
   Client_Sys.Add_To_Attr('PERCENT_OF_SOURCE',percent_of_source_,attr_);

   IF project_no_ IS NOT NULL THEN
      Client_Sys.Add_To_Attr('PROJECT_ID',project_no_,attr_);
   END IF;

   Client_Sys.Add_To_Attr('EQUIPMENT_OBJ_COST_TYPE_DB',cost_type_db_,attr_);

--   Client_Sys.Add_To_Attr('CURRENCY_CODE',currency_code_,attr_);
   Client_Sys.Add_To_Attr('COST_SOURCE',cost_source_,attr_);
   Client_Sys.Add_To_Attr('ROW_CHECKED',row_checked_,attr_);

   --Adding Customer Order Information when cost coming from Direct sales...
   Client_Sys.Add_To_Attr('SOURCE_REF1', source_ref1_, attr_);
   Client_Sys.Add_To_Attr('SOURCE_REF2', source_ref2_, attr_);
   Client_Sys.Add_To_Attr('SOURCE_REF3', source_ref3_, attr_);
   Client_Sys.Add_To_Attr('SOURCE_REF4', source_ref4_, attr_);
   
   Client_Sys.Add_To_Attr('ORDER_CONTRACT',order_contract_,attr_);

   save_attr_ := attr_;

   -- Look for all the parent objects in the tabel and add a cost line for each of them.
   -- Cost will be added in object's site currency.
   current_mch_contract_ := mch_contract_;
   current_mch_code_     := mch_code_;

   LOOP
      OPEN  get_parent_objects_(current_mch_contract_,current_mch_code_);
      FETCH get_parent_objects_ INTO current_mch_contract_,current_mch_code_,current_sup_contract_,current_sup_mch_code_, current_equip_obj_sq_, current_func_obj_sq_;
         EXIT WHEN get_parent_objects_%NOTFOUND;
      
      ------
      -- The coverted_amount_ only has to be calculated if company changes for object,
      --  this is if object site is on a different company than the previous site
      IF ( company_contract_ IS NULL OR company_contract_ != current_mch_contract_ ) THEN
         company_contract_ := current_mch_contract_;

         company_:=Site_API.Get_Company(company_contract_);
         IF current_company_ IS NULL OR current_company_ != company_ THEN
            current_company_ := company_;
            currency_code_ := Company_Finance_API.Get_Currency_Code(company_);
            -- Get the cost amount in Object's site currency
            coverted_amount_ := Service_Pricing_API.Convert_To_Currency(order_company_,nvl(amount_, 0),currency_code_);
         END IF;
      END IF;
      ------

      IF (mch_code_= current_mch_code_)THEN
         -- For first record we use check_insert___ to get checks etc...
         Client_Sys.Add_To_Attr('CONTRACT',current_mch_contract_,attr_);
         Client_Sys.Add_To_Attr('MCH_CODE',current_mch_code_,attr_);
         Client_Sys.Add_To_Attr('EQUIPMENT_OBJECT_SEQ',current_equip_obj_sq_,attr_);
         Client_Sys.Add_To_Attr('SUP_MCH_CODE',current_sup_mch_code_,attr_);
         Client_Sys.Add_To_Attr('SUP_CONTRACT',current_sup_contract_,attr_);
         Client_Sys.Add_To_Attr('SUP_EQU_OBJECT_SEQ',current_func_obj_sq_,attr_);
         Client_Sys.Add_To_Attr('CURRENCY_CODE',currency_code_,attr_);
         IF cost_revenue_ = 'COST' THEN
            Client_Sys.Add_To_Attr('COST',coverted_amount_,attr_);
         ELSE
            Client_Sys.Add_To_Attr('REVENUE',coverted_amount_,attr_);
         END IF;

         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      ELSE
         -- ...but for the rest we dont need the checks as we know that the objects etc exists and is correct
         newrec_.seq_no                 := NULL; -- to be set by Insert___

         newrec_.cost                   := NULL;
         newrec_.cost_from_structure    := NULL;
         newrec_.revenue                := NULL;
         newrec_.revenue_from_structure := NULL;
         newrec_.sup_mch_code           := current_sup_mch_code_;
         newrec_.sup_contract           := current_sup_contract_;
         newrec_.contract               := current_mch_contract_;
         newrec_.mch_code               := current_mch_code_;
         newrec_.currency_code          := currency_code_;

         IF cost_revenue_ = 'COST' THEN
            newrec_.cost_from_structure    := coverted_amount_;
         ELSE
            newrec_.revenue_from_structure := coverted_amount_;
         END IF;
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;


      current_mch_contract_ :=current_sup_contract_;
      current_mch_code_     := current_sup_mch_code_;

      CLOSE get_parent_objects_;
   END LOOP;

   CLOSE get_parent_objects_;

END Insert_Structure___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_structure_cost_tab%ROWTYPE,
   newrec_ IN OUT equipment_structure_cost_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
  cost_source_   EQUIPMENT_STRUCTURE_COST_TAB.cost_source%TYPE := Client_SYS.Get_Item_Value('COST_SOURCE',attr_);
  activity_seq_  NUMBER := NULL;
   
   
BEGIN
   indrec_.equipment_obj_cost_type := FALSE;
   indrec_.project_id := FALSE;
   indrec_.source_ref4 := FALSE;  
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (cost_source_ != 'WO') THEN
      newrec_.equipment_obj_cost_type := NULL;
   END IF;
   
   IF (newrec_.equipment_obj_cost_type IS NOT NULL AND cost_source_ = 'WO') THEN
      Equipment_Obj_Cost_Type_API.Exist_Db(newrec_.equipment_obj_cost_type);
   END IF;
   
   --Projects which belong to PROJ should be validated...
   IF (newrec_.project_id IS NOT NULL AND newrec_.source_ref1 IS NOT NULL) THEN
      IF (newrec_.cost_source IS NOT NULL AND newrec_.cost_source = 'WO') THEN
         $IF Component_Wo_SYS.INSTALLED $THEN
            activity_seq_ := Active_Work_Order_API.Get_Activity_Seq(wo_no_  => NVL(Jt_Task_API.Get_Wo_No(newrec_.source_ref2),NVL(newrec_.source_ref1,'*')));
         $ELSE
            NULL;
         $END
         IF ( activity_seq_ IS NOT NULL) THEN
            $IF Component_Proj_SYS.INSTALLED $THEN
               Project_API.Exist(newrec_.project_id);
            $ELSE
               NULL;
            $END
         END IF;
      END IF;
   END IF;
   
   $IF Component_Order_SYS.INSTALLED $THEN
      IF (   newrec_.cost_source IS NOT NULL AND
             newrec_.cost_source = 'CO' AND 
             newrec_.source_ref1 IS NOT NULL AND 
             newrec_.source_ref2 IS NOT NULL AND
             newrec_.source_ref3 IS NOT NULL AND 
             newrec_.source_ref4 IS NOT NULL) THEN
         Customer_Order_Line_API.Exist(order_no_     => newrec_.source_ref1, 
                                       line_no_      => newrec_.source_ref2,
                                       rel_no_       => newrec_.source_ref3, 
                                       line_item_no_ => newrec_.source_ref4);
      END IF; 
   $ELSE
      NULL;
   $END
   
   $IF Component_Wo_SYS.INSTALLED $THEN
      IF ( newrec_.source_ref1 IS NOT NULL AND
           newrec_.source_ref2 IS NOT NULL AND
           newrec_.source_ref3 IS NOT NULL AND
           newrec_.source_ref4 IS NULL AND
           newrec_.cost_source = 'WO') THEN
         IF (newrec_.source_ref1 != '*') THEN  
            Jt_Task_API.Check_Wo_Task_Exist(to_number(newrec_.source_ref1), to_number(newrec_.source_ref2));
         ELSE
            Jt_Task_API.Exist(to_number(newrec_.source_ref2));
         END IF;
         Jt_Task_Cost_Line_API.Exist(to_number(newrec_.source_ref3));
      ELSIF ( newrec_.source_ref1 IS NOT NULL AND
              newrec_.source_ref2 IS NOT NULL AND
              newrec_.source_ref3 IS NULL AND
              newrec_.source_ref4 IS NOT NULL AND
              newrec_.cost_source = 'WO') THEN
         IF (newrec_.source_ref1 != '*') THEN  
            Jt_Task_API.Check_Wo_Task_Exist(to_number(newrec_.source_ref1), to_number(newrec_.source_ref2));
         ELSE
            Jt_Task_API.Exist(to_number(newrec_.source_ref2));
         END IF;
         Jt_Task_Sales_Line_API.Exist(to_number(newrec_.source_ref4));
      END IF;
   $ELSE
      NULL;
   $END
END Check_Common___;




@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_structure_cost_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);   
BEGIN
   IF (newrec_.cre_date IS NULL) THEN
      newrec_.cre_date := Maintenance_Site_Utility_API.Get_Site_Date(newrec_.contract);
   END IF;  
   
   super(newrec_, indrec_, attr_);  
 
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT equipment_structure_cost_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.seq_no IS NULL) THEN
      SELECT Equip_Structure_Cost_Seq.NEXTVAL INTO newrec_.seq_no FROM dual;
      Client_SYS.Add_To_Attr('SEQ_NO', newrec_.seq_no, attr_);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Translate__ (
   err_tag_   IN VARCHAR2,   
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_      VARCHAR2(2000);
BEGIN
	text_ := CASE err_tag_
               WHEN 'YEAR_TOTAL' THEN
                  Language_SYS.Translate_Constant(lu_name_, 'STRCOSTYEARTOTL: Total')
               ELSE
                  ''
            END;
               
	RETURN text_;
END Translate__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Structure_Cost (
   mch_code_          IN VARCHAR2,
   mch_contract_      IN VARCHAR2,
   cost_type_db_      IN VARCHAR2,
   cre_date_          IN DATE,
   cost_amount_       IN NUMBER,
   order_contract_    IN VARCHAR2,
   percent_of_source_ IN NUMBER,
   cost_source_       IN VARCHAR2 DEFAULT 'WO',
   source_ref1_       IN VARCHAR2 DEFAULT NULL,
   source_ref2_       IN VARCHAR2 DEFAULT NULL,
   source_ref3_       IN VARCHAR2 DEFAULT NULL,
   source_ref4_       IN NUMBER   DEFAULT NULL,
   row_checked_       IN VARCHAR2 DEFAULT NULL)
IS

BEGIN
   Insert_Structure___(  mch_code_           => mch_code_,
                         mch_contract_       => mch_contract_,
                         cost_type_db_       => cost_type_db_,
                         cre_date_           => cre_date_,
                         amount_             => cost_amount_,
                         order_contract_     => order_contract_,
                         percent_of_source_  => percent_of_source_,
                         cost_source_        => cost_source_,
                         source_ref1_        => source_ref1_,
                         source_ref2_        => source_ref2_,
                         source_ref3_        => source_ref3_,
                         source_ref4_        => source_ref4_,
                         cost_revenue_       => 'COST',
                         row_checked_        => row_checked_);
END Insert_Structure_Cost;


PROCEDURE Insert_Structure_Revenue (
   mch_code_          IN VARCHAR2,
   mch_contract_      IN VARCHAR2,
   cost_type_db_      IN VARCHAR2,
   cre_date_          IN DATE,
   revenue_amount_    IN NUMBER,
   order_contract_    IN VARCHAR2,
   percent_of_source_ IN NUMBER,
   cost_source_       IN VARCHAR2 DEFAULT 'WO',
   source_ref1_       IN VARCHAR2,
   source_ref2_       IN VARCHAR2,
   source_ref3_       IN VARCHAR2 DEFAULT NULL,
   source_ref4_       IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Insert_Structure___(  mch_code_           => mch_code_,
                         mch_contract_       => mch_contract_,
                         cost_type_db_       => cost_type_db_,
                         cre_date_           => cre_date_,
                         amount_             => revenue_amount_,
                         order_contract_     => order_contract_,
                         percent_of_source_  => percent_of_source_,
                         cost_source_        => cost_source_,
                         source_ref1_        => source_ref1_,
                         source_ref2_        => source_ref2_,
                         source_ref3_        => source_ref3_,
                         source_ref4_        => source_ref4_,
                         cost_revenue_       => 'REVENUE',
                         row_checked_        => NULL);
END Insert_Structure_Revenue;


PROCEDURE Remove_Structure_Cost(
   source_ref1_ IN VARCHAR2,
   source_ref2_ IN VARCHAR2 )
IS
   CURSOR get_seq_no IS
      SELECT seq_no
      FROM  EQUIPMENT_STRUCTURE_COST_TAB
      WHERE source_ref1 = source_ref1_
      AND   source_ref2 = source_ref2_
      AND   revenue IS NULL
      AND   revenue_from_structure IS NULL;

   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   info_          VARCHAR2(2000);

BEGIN
   FOR x IN get_seq_no LOOP
      Get_Id_Version_By_Keys___(objid_,objversion_,x.seq_no);
      IF (objid_ IS NOT NULL AND objversion_ IS NOT NULL) THEN
         Remove__(info_,objid_,objversion_,'DO');
      END IF;
   END LOOP;
END Remove_Structure_Cost;


PROCEDURE Remove_Structure_Revenue(
   source_ref1_ IN VARCHAR2,
   source_ref2_ IN VARCHAR2 )
IS
   CURSOR get_seq_no IS
      SELECT seq_no
      FROM  EQUIPMENT_STRUCTURE_COST_TAB
      WHERE source_ref1 = source_ref1_
      AND   source_ref2 = source_ref2_
      AND   cost IS NULL
      AND   cost_from_structure IS NULL;

   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   info_          VARCHAR2(2000);

BEGIN
   FOR x IN get_seq_no LOOP
      Get_Id_Version_By_Keys___(objid_,objversion_,x.seq_no);
      IF (objid_ IS NOT NULL AND objversion_ IS NOT NULL) THEN
         Remove__(info_,objid_,objversion_,'DO');
      END IF;
   END LOOP;
END Remove_Structure_Revenue;


@UncheckedAccess
PROCEDURE Get_Object_Cost (
   personnel_cost_    OUT NUMBER,
   material_cost_     OUT NUMBER,
   tool_cost_         OUT NUMBER,
   external_cost_     OUT NUMBER,
   expense_cost_      OUT NUMBER,
   fixed_price_cost_  OUT NUMBER,
   direct_sales_cost_ OUT NUMBER,
   contr_inv_cost_    OUT NUMBER,
   mch_code_          IN  VARCHAR2,
   mch_code_contract_ IN  VARCHAR2,
   sup_mch_code_      IN  VARCHAR2,
   sup_contract_      IN  VARCHAR2,
   date_from_         IN  TIMESTAMP,
   date_to_           IN  TIMESTAMP,
   selection_         IN  VARCHAR2,
   project_no_        IN  VARCHAR2,
   currency_          IN  VARCHAR2 )
IS
BEGIN

   Get_Object_Cost_Revenue___ ( personnel_cost_,
                                material_cost_,
                                tool_cost_,
                                external_cost_,
                                expense_cost_,
                                fixed_price_cost_,
                                direct_sales_cost_,
                                contr_inv_cost_,
                                mch_code_,
                                mch_code_contract_,
                                sup_mch_code_,
                                sup_contract_,
                                date_from_,
                                date_to_,
                                selection_,
                                project_no_,
                                currency_,
                                'COST' );

END Get_Object_Cost;


@UncheckedAccess
PROCEDURE Get_Object_Structure_Cost (
   personnel_cost_    OUT NUMBER,
   material_cost_     OUT NUMBER,
   tool_cost_         OUT NUMBER,
   external_cost_     OUT NUMBER,
   expense_cost_      OUT NUMBER,
   fixed_price_cost_  OUT NUMBER,
   direct_sales_cost_ OUT NUMBER,
   contr_inv_cost_    OUT NUMBER,
   mch_code_          IN  VARCHAR2,
   mch_code_contract_ IN  VARCHAR2,
   sup_mch_code_      IN  VARCHAR2,
   sup_contract_      IN  VARCHAR2,
   date_from_         IN  TIMESTAMP,
   date_to_           IN  TIMESTAMP,
   selection_         IN  VARCHAR2,
   project_no_        IN  VARCHAR2,
   currency_          IN  VARCHAR2 )
IS
BEGIN

   Get_Object_Cost_Revenue___ ( personnel_cost_,
                                material_cost_,
                                tool_cost_,
                                external_cost_,
                                expense_cost_,
                                fixed_price_cost_,
                                direct_sales_cost_,
                                contr_inv_cost_,
                                mch_code_,
                                mch_code_contract_,
                                sup_mch_code_,
                                sup_contract_,
                                date_from_,
                                date_to_,
                                selection_,
                                project_no_,
                                currency_,
                                'STRUCT_COST' );

END Get_Object_Structure_Cost;


@UncheckedAccess
PROCEDURE Get_Object_Revenue (
   personnel_revenue_    OUT NUMBER,
   material_revenue_     OUT NUMBER,
   tool_revenue_         OUT NUMBER,
   external_revenue_     OUT NUMBER,
   expense_revenue_      OUT NUMBER,
   fixed_price_revenue_  OUT NUMBER,
   direct_sales_revenue_ OUT NUMBER,
   contr_inv_revenue_    OUT NUMBER,
   mch_code_             IN  VARCHAR2,
   mch_code_contract_    IN  VARCHAR2,
   sup_mch_code_         IN  VARCHAR2,
   sup_contract_         IN  VARCHAR2,
   date_from_            IN  TIMESTAMP,
   date_to_              IN  TIMESTAMP,
   selection_            IN  VARCHAR2,
   project_no_           IN  VARCHAR2,
   currency_             IN  VARCHAR2 )
IS
BEGIN

   Get_Object_Cost_Revenue___ ( personnel_revenue_,
                                material_revenue_,
                                tool_revenue_,
                                external_revenue_,
                                expense_revenue_,
                                fixed_price_revenue_,
                                direct_sales_revenue_,
                                contr_inv_revenue_,
                                mch_code_,
                                mch_code_contract_,
                                sup_mch_code_,
                                sup_contract_,
                                date_from_,
                                date_to_,
                                selection_,
                                project_no_,
                                currency_,
                                'REVENUE' );

END Get_Object_Revenue;


@UncheckedAccess
PROCEDURE Get_Object_Structure_Revenue (
   personnel_revenue_    OUT NUMBER,
   material_revenue_     OUT NUMBER,
   tool_revenue_         OUT NUMBER,
   external_revenue_     OUT NUMBER,
   expense_revenue_      OUT NUMBER,
   fixed_price_revenue_  OUT NUMBER,
   direct_sales_revenue_ OUT NUMBER,
   contr_inv_revenue_    OUT NUMBER,
   mch_code_             IN  VARCHAR2,
   mch_code_contract_    IN  VARCHAR2,
   sup_mch_code_         IN  VARCHAR2,
   sup_contract_         IN  VARCHAR2,
   date_from_            IN  TIMESTAMP,
   date_to_              IN  TIMESTAMP,
   selection_            IN  VARCHAR2,
   project_no_           IN  VARCHAR2,
   currency_             IN  VARCHAR2 )
IS
BEGIN

   Get_Object_Cost_Revenue___ ( personnel_revenue_,
                                material_revenue_,
                                tool_revenue_,
                                external_revenue_,
                                expense_revenue_,
                                fixed_price_revenue_,
                                direct_sales_revenue_,
                                contr_inv_revenue_,
                                mch_code_,
                                mch_code_contract_,
                                sup_mch_code_,
                                sup_contract_,
                                date_from_,
                                date_to_,
                                selection_,
                                project_no_,
                                currency_,
                                'STRUCT_REVENUE' );

END Get_Object_Structure_Revenue;


PROCEDURE Insert_Negative_Cost (
   source_ref1_ IN VARCHAR2,
   source_ref2_ IN VARCHAR2,
   cre_date_ IN DATE )
IS
   CURSOR rec_exists IS
      SELECT 1
      FROM EQUIPMENT_STRUCTURE_COST_TAB
      WHERE source_ref1 = source_ref1_
      AND   source_ref2 = source_ref2_;

   CURSOR get_row IS
      SELECT seq_no
      FROM EQUIPMENT_STRUCTURE_COST_TAB
      WHERE source_ref1 = source_ref1_
      AND   source_ref2 = source_ref2_;

   exists_              NUMBER := 0;
   rec_                 EQUIPMENT_STRUCTURE_COST_TAB%ROWTYPE;
   attr_                VARCHAR2(32000);
   info_                VARCHAR2(2000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);

BEGIN
   OPEN rec_exists;
   FETCH rec_exists INTO exists_;
   CLOSE rec_exists;
   IF (exists_ =1) THEN
      FOR x IN get_row LOOP
        rec_ := Get_Object_By_Keys___(x.seq_no);
      --  SELECT Equip_Structure_Cost_Seq.NEXTVAL INTO seq_no_ FROM DUAl;

        Client_Sys.Clear_Attr(attr_);
     --   Client_Sys.Add_To_Attr('SEQ_NO',seq_no_,attr_);
        Client_Sys.Add_To_Attr('CRE_DATE',cre_date_,attr_);
        Client_Sys.Add_To_Attr('PERCENT_OF_SOURCE',rec_.percent_of_source,attr_);
        Client_Sys.Add_To_Attr('COST',(-1*rec_.cost),attr_);
        Client_Sys.Add_To_Attr('COST_FROM_STRUCTURE',(-1*rec_.cost_from_structure),attr_);
        Client_Sys.Add_To_Attr('PROJECT_ID',rec_.project_id,attr_);
        Client_Sys.Add_To_Attr('EQUIPMENT_OBJ_COST_TYPE_DB',rec_.equipment_obj_cost_type,attr_);
        Client_Sys.Add_To_Attr('CONTRACT',rec_.contract,attr_);
        Client_Sys.Add_To_Attr('MCH_CODE',rec_.mch_code,attr_);
        Client_Sys.Add_To_Attr('SUP_MCH_CODE',rec_.sup_mch_code,attr_);
        Client_Sys.Add_To_Attr('SUP_CONTRACT',rec_.sup_contract,attr_);
        Client_Sys.Add_To_Attr('CURRENCY_CODE',rec_.currency_code,attr_);
        Client_Sys.Add_To_Attr('SOURCE_REF1',rec_.source_ref1,attr_);
        Client_Sys.Add_To_Attr('SOURCE_REF2',rec_.source_ref2,attr_);
        Client_Sys.Add_To_Attr('COST_SOURCE',rec_.cost_source,attr_);
        Client_Sys.Add_To_Attr('ORDER_CONTRACT',rec_.order_contract,attr_);
        Client_Sys.Add_To_Attr('ROW_CHECKED','TRUE',attr_);
        New__ (info_,objid_ ,objversion_,attr_,'DO');
      END LOOP;
   END IF;
END Insert_Negative_Cost;


@UncheckedAccess
FUNCTION Get_Cost_Per_Type (
   mch_code_          IN VARCHAR2,
   contract_          IN VARCHAR2,
   cost_type_         IN VARCHAR2,
   year_              IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_     NUMBER;
   CURSOR get_cost IS
      SELECT sum(cost) cost
      FROM   equipment_structure_cost_tab
      WHERE  mch_code = mch_code_
      AND    contract = contract_
      AND    equipment_obj_cost_type = cost_type_
      AND    to_char(cre_date, 'YYYY') = year_;
BEGIN
   OPEN get_cost;
   FETCH get_cost INTO dummy_;
   CLOSE get_cost;
   RETURN dummy_;
END Get_Cost_Per_Type;


@UncheckedAccess
FUNCTION Get_Total_Cost_Year (
   mch_code_          IN VARCHAR2,
   contract_          IN VARCHAR2,
   year_              IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_     NUMBER;
   CURSOR get_cost IS
      SELECT sum(cost) cost
      FROM   equipment_structure_cost_tab
      WHERE  mch_code = mch_code_
      AND    contract = contract_
      AND    equipment_obj_cost_type IN (Equipment_Obj_Cost_Type_API.DB_MATERIAL, 
                                         Equipment_Obj_Cost_Type_API.DB_PERSONNEL, 
                                         Equipment_Obj_Cost_Type_API.DB_TOOLS_FACILITIES, 
                                         Equipment_Obj_Cost_Type_API.DB_EXTERNAL, 
                                         Equipment_Obj_Cost_Type_API.DB_EXTERNAL)
      AND    to_char(cre_date, 'YYYY') = year_;

   CURSOR get_tot_cost IS
      SELECT sum(cost) cost
      FROM   equipment_structure_cost_tab
      WHERE  mch_code = mch_code_
      AND    contract = contract_
      AND    equipment_obj_cost_type IN (Equipment_Obj_Cost_Type_API.DB_MATERIAL, 
                                         Equipment_Obj_Cost_Type_API.DB_PERSONNEL, 
                                         Equipment_Obj_Cost_Type_API.DB_TOOLS_FACILITIES, 
                                         Equipment_Obj_Cost_Type_API.DB_EXTERNAL, 
                                         Equipment_Obj_Cost_Type_API.DB_EXTERNAL,
                                         'D')
      AND    to_char(cre_date, 'YYYY') = year_;
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      OPEN get_tot_cost;
      FETCH get_tot_cost INTO dummy_;
      CLOSE get_tot_cost;
   $ELSE
      OPEN get_cost;
      FETCH get_cost INTO dummy_;
      CLOSE get_cost;
   $END
   RETURN dummy_;
END Get_Total_Cost_Year;


PROCEDURE Remove_Obj_Cost (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2)
IS
   CURSOR get_seq_no IS
      SELECT seq_no
      FROM  EQUIPMENT_STRUCTURE_COST_TAB
      WHERE mch_code = mch_code_
      AND   contract = contract_ ;

   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   info_          VARCHAR2(2000);

BEGIN
   FOR x IN get_seq_no LOOP
      Get_Id_Version_By_Keys___(objid_,objversion_,x.seq_no);
      IF (objid_ IS NOT NULL AND objversion_ IS NOT NULL) THEN
         Remove__(info_,objid_,objversion_,'DO');
      END IF;
   END LOOP;
END Remove_Obj_Cost;


PROCEDURE Update_Cost_Revenue(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   cost_     IN NUMBER,
   revenue_  IN NUMBER,
   attr_     IN VARCHAR2)
IS
   source_ref1_      VARCHAR2(50);
   source_ref2_      VARCHAR2(50);
   source_ref3_      VARCHAR2(50);
   source_ref4_      VARCHAR2(50);
   co_contract_      VARCHAR2(15);
   cre_date_         DATE;
--   block_            VARCHAR2(10000);
BEGIN
   source_ref1_      := Client_SYS.Get_Item_Value('SOURCE_REF1',attr_);
   source_ref2_      := Client_SYS.Get_Item_Value('SOURCE_REF2',attr_);
   source_ref3_      := Client_SYS.Get_Item_Value('SOURCE_REF3',attr_);
   source_ref4_      := Client_SYS.Get_Item_Value('SOURCE_REF4',attr_);
   cre_date_         := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('REAL_SHIP_DATE',attr_));
   
   $IF Component_Order_SYS.INSTALLED $THEN
      IF ( source_ref1_ IS NOT NULL AND source_ref2_ IS NOT NULL AND source_ref3_ IS NOT NULL AND source_ref4_ IS NOT NULL) THEN
         co_contract_ := Customer_Order_Line_API.Get_Contract(order_no_     => source_ref1_, 
                                                              line_no_      => source_ref2_, 
                                                              rel_no_       => source_ref3_, 
                                                              line_item_no_ => source_ref4_);
      END IF;
   $ELSE
      NULL;
   $END

   IF (cre_date_ IS NULL) THEN
      cre_date_ := Maintenance_Site_Utility_API.Get_Site_Date(co_contract_);
   END IF;

   --Inserting Cost Coming From Customer Order...
   Insert_Structure_Cost(mch_code_          => mch_code_,
                         mch_contract_      => contract_,
                         cost_type_db_      => 'D',
                         cre_date_          => cre_date_,
                         cost_amount_       => cost_,
                         order_contract_    => co_contract_,
                         percent_of_source_ => NULL,
                         cost_source_       => 'CO',
                         source_ref1_       => source_ref1_,
                         source_ref2_       => source_ref2_,
                         source_ref3_       => source_ref3_,
                         source_ref4_       => source_ref4_);
   --Inserting Revenue Coming From Customer Order...
   Insert_Structure_Revenue (mch_code_          => mch_code_,
                             mch_contract_      => contract_,
                             cost_type_db_      => 'D',
                             cre_date_          => cre_date_,
                             revenue_amount_    => revenue_,
                             order_contract_    => co_contract_,
                             percent_of_source_ => NULL,
                             cost_source_       => 'CO',
                             source_ref1_       => source_ref1_,
                             source_ref2_       => source_ref2_,
                             source_ref3_       => source_ref3_,
                             source_ref4_       => source_ref4_);
                            
END Update_Cost_Revenue;


@UncheckedAccess
FUNCTION Is_Object_Exceed_Cost (
   cost_to_check_       IN NUMBER,
   mch_code_            IN VARCHAR2,
   mch_code_contract_   IN VARCHAR2,
   sup_mch_code_        IN VARCHAR2,
   sup_contract_        IN VARCHAR2,
   date_from_           IN DATE,
   date_to_             IN DATE,
   selection_           IN VARCHAR2,
   project_no_          IN VARCHAR2,
   currency_            IN VARCHAR2 ) RETURN VARCHAR2
IS
   personnel_cost_      NUMBER := 0;
   material_cost_       NUMBER := 0;
   tool_cost_           NUMBER := 0;
   external_cost_       NUMBER := 0;
   expense_cost_        NUMBER := 0;
   fixed_price_cost_    NUMBER := 0;
   direct_sales_cost_   NUMBER := 0;
   contr_inv_cost_      NUMBER := 0;
   total_cost_          NUMBER := 0;
BEGIN

   --Get the structure cost...
   Get_Object_Structure_Cost(personnel_cost_,material_cost_,tool_cost_,external_cost_,
                             expense_cost_,fixed_price_cost_,direct_sales_cost_, contr_inv_cost_,
                             mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,
                             date_from_,date_to_,selection_,project_no_,currency_);

   total_cost_ := NVL(personnel_cost_,0) + NVL(material_cost_,0) + NVL(tool_cost_,0)
                  + NVL(external_cost_,0) + NVL(expense_cost_,0) + NVL(fixed_price_cost_,0)
                  + NVL(direct_sales_cost_,0) + NVL(contr_inv_cost_,0);

   IF (total_cost_ IS NOT NULL AND total_cost_ < cost_to_check_) THEN
      --Get the object cost...
      Get_Object_Cost(personnel_cost_,material_cost_,tool_cost_,external_cost_,
                      expense_cost_,fixed_price_cost_,direct_sales_cost_,contr_inv_cost_,
                      mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,
                      date_from_,date_to_,selection_,project_no_,currency_);

      total_cost_ := NVL(personnel_cost_,0) + NVL(material_cost_,0) + NVL(tool_cost_,0)
                     + NVL(external_cost_,0) + NVL(expense_cost_,0) + NVL(fixed_price_cost_,0)
                     + NVL(direct_sales_cost_,0) + NVL(contr_inv_cost_,0);
   END IF;

   IF (total_cost_ IS NOT NULL AND total_cost_ >= cost_to_check_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Object_Exceed_Cost;


PROCEDURE Update_Equip_Structure_Cost (
   wo_no_ IN NUMBER,
   row_no_ IN NUMBER,
   ver_date_ IN DATE)
IS
   CURSOR get_seq_no IS
      SELECT seq_no
      FROM  EQUIPMENT_STRUCTURE_COST_TAB
      WHERE source_ref1 = to_char(wo_no_)
      AND   source_ref2 = to_char(row_no_) ;

BEGIN

   IF ver_date_ IS NOT NULL THEN
      FOR x IN get_seq_no LOOP
         UPDATE EQUIPMENT_STRUCTURE_COST_TAB
         SET cre_date = ver_date_
         WHERE seq_no = x.seq_no;
      END LOOP;
   END IF;
END Update_Equip_Structure_Cost;


@UncheckedAccess
FUNCTION Cost_Line_Exist (
   mch_code_     IN VARCHAR2,
   mch_contract_ IN VARCHAR2,
   cost_type_    IN VARCHAR2,
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR check_exist IS
      SELECT 1
      FROM Equipment_Structure_Cost_Tab
      WHERE mch_code = mch_code_
      AND contract = mch_contract_
      AND equipment_obj_cost_type = cost_type_
      AND source_ref1 = source_ref1_
      AND source_ref2 = source_ref2_;
   temp_   NUMBER := 0;
   retval_ VARCHAR2(6);
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   CLOSE check_exist;
   IF (temp_ = 1) THEN
      retval_ := 'TRUE';
   ELSE
      retval_ := 'FALSE';
   END IF;
   RETURN retval_;
END Cost_Line_Exist;


PROCEDURE Update_Cost_Line (
   mch_code_     IN VARCHAR2,
   mch_contract_ IN VARCHAR2,
   cost_type_    IN VARCHAR2,
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   cost_         IN NUMBER ) 
IS
   CURSOR check_exist(current_mch_contract_ VARCHAR2 ,current_mch_code_ VARCHAR2) IS
      SELECT seq_no,cost,cost_from_structure
      FROM Equipment_Structure_Cost_Tab
      WHERE mch_code = current_mch_code_
      AND contract = current_mch_contract_
      AND equipment_obj_cost_type = cost_type_
      AND source_ref1 = source_ref1_
      AND source_ref2 = source_ref2_;

   CURSOR get_parent_objects_(sup_contract_ VARCHAR2 ,sup_mch_code_ VARCHAR2) IS
       SELECT  contract,mch_code,sup_contract,sup_mch_code
       FROM   Equipment_Object
       WHERE  contract = sup_contract_
       AND    mch_code = sup_mch_code_;

   temp_   NUMBER := 0;
   temp_cost_  NUMBER := 0;
   temp_cost_from_structure_ NUMBER := 0;
   current_mch_contract_ VARCHAR2(30);
   current_mch_code_     VARCHAR2(300);
   current_sup_contract_ VARCHAR2(30);
   current_sup_mch_code_ VARCHAR2(300);

BEGIN

   current_mch_contract_:=mch_contract_;
   current_mch_code_:= mch_code_;

   LOOP
      OPEN  get_parent_objects_(current_mch_contract_,current_mch_code_);
      FETCH get_parent_objects_ INTO current_mch_contract_,current_mch_code_,current_sup_contract_,current_sup_mch_code_;
         EXIT WHEN get_parent_objects_%NOTFOUND;

      OPEN check_exist(current_mch_contract_,current_mch_code_);
      FETCH check_exist INTO temp_,temp_cost_,temp_cost_from_structure_;
      CLOSE check_exist;

      IF (temp_ > 0 ) THEN
         IF(mch_code_=current_mch_code_ AND temp_cost_ != 0 )THEN
            UPDATE EQUIPMENT_STRUCTURE_COST_TAB
            SET cost = cost_
            WHERE seq_no = temp_; 
         ELSIF  temp_cost_from_structure_ != 0 THEN
            UPDATE EQUIPMENT_STRUCTURE_COST_TAB
            SET COST_FROM_STRUCTURE = cost_
            WHERE seq_no = temp_; 
         END IF;         
      END IF;

      current_mch_contract_:=current_sup_contract_;
      current_mch_code_:= current_sup_mch_code_;
      CLOSE get_parent_objects_;
   END LOOP;
   
   CLOSE get_parent_objects_;
END Update_Cost_Line;


@UncheckedAccess
FUNCTION Get_Costs (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   year_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   cost_attr_     VARCHAR2(2000);
   material_      NUMBER  := 0;
   personal_      NUMBER  := 0;
   tool_facility_ NUMBER  := 0;
   expense_       NUMBER  := 0;
   external_      NUMBER  := 0;
   direct_sales_  NUMBER  := 0;
   total_cost_    NUMBER  := 0;

   CURSOR get_cost_ IS
         SELECT equipment_obj_cost_type, COST
         FROM   equipment_structure_cost_tab
         WHERE  mch_code = mch_code_
         AND    contract = contract_
         AND    to_char(cre_date, 'YYYY') = year_;
BEGIN

   FOR rec_ IN get_cost_ LOOP
      IF (rec_.equipment_obj_cost_type = Equipment_Obj_Cost_Type_API.DB_MATERIAL) THEN
         material_ := material_ + nvl(rec_.cost, 0);
      ELSIF (rec_.equipment_obj_cost_type = Equipment_Obj_Cost_Type_API.DB_PERSONNEL) THEN
         personal_ := personal_ + nvl(rec_.cost, 0);
      ELSIF (rec_.equipment_obj_cost_type = Equipment_Obj_Cost_Type_API.DB_TOOLS_FACILITIES) THEN
         tool_facility_ := tool_facility_ + nvl(rec_.cost, 0);
      ELSIF (rec_.equipment_obj_cost_type = Equipment_Obj_Cost_Type_API.DB_EXPENSES) THEN
         expense_ := expense_ + nvl(rec_.cost, 0);
      ELSIF (rec_.equipment_obj_cost_type = Equipment_Obj_Cost_Type_API.DB_EXTERNAL) THEN
         external_ := external_ + nvl(rec_.cost, 0);
      ELSIF (rec_.equipment_obj_cost_type = 'D') THEN
         direct_sales_ := direct_sales_ + nvl(rec_.cost, 0);
      END IF;
   END LOOP;

   total_cost_ := material_ + personal_ + tool_facility_ + expense_ + external_ + direct_sales_;

   Client_SYS.Clear_Attr(cost_attr_);
   Client_SYS.Add_To_Attr('MATERIAL',material_,cost_attr_);
   Client_SYS.Add_To_Attr('PERSONAL',personal_,cost_attr_);
   Client_SYS.Add_To_Attr('TOOL_FACILITY',tool_facility_,cost_attr_);
   Client_SYS.Add_To_Attr('EXPENSE',expense_,cost_attr_);
   Client_SYS.Add_To_Attr('EXTERNAL',external_,cost_attr_);
   Client_SYS.Add_To_Attr('DIRECT_SALES',direct_sales_,cost_attr_);
   Client_SYS.Add_To_Attr('TOTAL_COST',total_cost_,cost_attr_);

   RETURN cost_attr_;
END Get_Costs;

FUNCTION Calculate_Cost_Revenue( 
   mch_code_          IN  VARCHAR2 DEFAULT NULL,
   mch_code_contract_ IN  VARCHAR2 DEFAULT NULL,
   sup_mch_code_      IN  VARCHAR2 DEFAULT NULL,
   sup_contract_      IN  VARCHAR2 DEFAULT NULL,
   date_from_         IN  DATE DEFAULT NULL,
   date_to_           IN  DATE DEFAULT NULL,
   selection_         IN  VARCHAR2 DEFAULT NULL,
   project_no_        IN  VARCHAR2 DEFAULT NULL,
   total_caost_       IN  NUMBER DEFAULT NULL,
   currency_          IN  VARCHAR2 DEFAULT NULL
   
   ) RETURN Calculated_Totals_Arr PIPELINED
IS
   rec_                   Calculated_Totals_Rec; 
   personnelsingle_ NUMBER;
   materialsingle_ NUMBER;
   toolssingle_ NUMBER;
   externalsingle_ NUMBER;
   expencessingle_ NUMBER;
   fixedpricesingle_ NUMBER;
   directsalessingle_ NUMBER;
   contrinvsingle_ NUMBER;
   
   personnelcost_ NUMBER;
   materialcost_ NUMBER;
   toolscost_ NUMBER;
   externalcost_ NUMBER;
   expencescost_ NUMBER;
   fixedpricecost_ NUMBER;
   directsalescost_ NUMBER;
   contrinvcost_ NUMBER;
   
   personnelrevenuesingle_ NUMBER;
   materialrevenuesingle_ NUMBER;
   toolsrevenuesingle_ NUMBER;
   externalrevenuesingle_ NUMBER;
   expencesrevenuesingle_ NUMBER;
   fixedpricerevenuesingle_ NUMBER;
   directsalesrevenuesingle_ NUMBER;
   contrinvrevenuesingle_ NUMBER;
   
   personnelrevenue_ NUMBER;
   materialrevenue_ NUMBER;
   toolsrevenue_ NUMBER;
   externalrevenue_ NUMBER;
   expencesrevenue_ NUMBER;
   fixedpricerevenue_ NUMBER;
   directsalesrevenue_ NUMBER;
   contrinvrevenue_ NUMBER;  
    
   selection_db_value_ VARCHAR2(4000);
BEGIN
   IF selection_ = 'ExcludeProjectCostRevenue' THEN
      selection_db_value_ := 'Exclude Project Cost/Revenue';
   ELSIF selection_ = 'IncludeProjectCostRevenue' THEN
      selection_db_value_ := 'Include Project Cost/Revenue';
   ELSE
      selection_db_value_ := 'Show Project';
   END IF;
   Get_Object_Cost(personnelsingle_,materialsingle_,toolssingle_,externalsingle_,expencessingle_,fixedpricesingle_,directsalessingle_,contrinvsingle_,mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,date_from_,date_to_,selection_db_value_,project_no_,currency_);
   Get_Object_Structure_Cost(personnelcost_,materialcost_,toolscost_,externalcost_,expencescost_,fixedpricecost_,directsalescost_,contrinvcost_,mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,date_from_,date_to_,selection_db_value_,project_no_,currency_);
   Get_Object_Revenue(personnelrevenuesingle_,materialrevenuesingle_,toolsrevenuesingle_,externalrevenuesingle_,expencesrevenuesingle_,fixedpricerevenuesingle_,directsalesrevenuesingle_ ,contrinvrevenuesingle_, mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,date_from_,date_to_,selection_db_value_,project_no_,currency_);
   Get_Object_Structure_Revenue(personnelrevenue_,materialrevenue_,toolsrevenue_,externalrevenue_,expencesrevenue_,fixedpricerevenue_, directsalesrevenue_ ,contrinvrevenue_, mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,date_from_,date_to_,selection_db_value_,project_no_,currency_);
   
   rec_.cost_type:=Equipment_Obj_Cost_Type_API.DB_PERSONNEL;
   rec_.structure_cost:=personnelcost_;
   rec_.object_cost:=personnelsingle_;
   rec_.structure_revenue:=personnelrevenue_;
   rec_.object_revenue:=personnelrevenuesingle_;
   rec_.structure_profit_margin:=personnelrevenue_ - personnelcost_;
   rec_.object_profit_margin:=personnelrevenuesingle_ - personnelsingle_;
   PIPE row(rec_);
   
   rec_.cost_type:=Equipment_Obj_Cost_Type_API.DB_MATERIAL;
   rec_.structure_cost:=materialcost_;
   rec_.object_cost:= materialsingle_;
   rec_.structure_revenue:=materialrevenue_;
   rec_.object_revenue:=materialrevenuesingle_;
   rec_.structure_profit_margin:=materialrevenue_ - materialcost_;
   rec_.object_profit_margin:=materialrevenuesingle_ - materialsingle_;
   PIPE row(rec_);

   rec_.cost_type:=Equipment_Obj_Cost_Type_API.DB_TOOLS_FACILITIES;
   rec_.structure_cost:=toolscost_;
   rec_.object_cost:=toolssingle_;
   rec_.structure_revenue:=toolsrevenue_;
   rec_.object_revenue:=toolsrevenuesingle_;
   rec_.structure_profit_margin:=toolsrevenue_ - toolscost_;
   rec_.object_profit_margin:=toolsrevenuesingle_ - toolssingle_;
   PIPE row(rec_);
   
   rec_.cost_type:=Equipment_Obj_Cost_Type_API.DB_EXTERNAL;
   rec_.structure_cost:=externalcost_;
   rec_.object_cost:=externalsingle_;
   rec_.structure_revenue:=externalrevenue_;
   rec_.object_revenue:=externalrevenuesingle_;
   rec_.structure_profit_margin:=externalrevenue_ - externalcost_;
   rec_.object_profit_margin:=externalrevenuesingle_ - expencessingle_;
   PIPE row(rec_);
   
   rec_.cost_type:=Equipment_Obj_Cost_Type_API.DB_EXPENSES;
   rec_.structure_cost:=expencescost_;
   rec_.object_cost:=expencessingle_;
   rec_.structure_revenue:=expencesrevenue_;
   rec_.object_revenue:=expencesrevenuesingle_;
   rec_.structure_profit_margin:=expencesrevenue_ - expencescost_;
   rec_.object_profit_margin:=expencesrevenuesingle_ - expencessingle_;
   PIPE row(rec_);
   
   rec_.cost_type:=Equipment_Obj_Cost_Type_API.DB_FIXED_PRICE;
   rec_.structure_cost:=fixedpricecost_;
   rec_.object_cost:=fixedpricesingle_;
   rec_.structure_revenue:=fixedpricerevenue_;
   rec_.object_revenue:=fixedpricerevenuesingle_;
   rec_.structure_profit_margin:=fixedpricerevenue_ - fixedpricecost_;
   rec_.object_profit_margin:=fixedpricerevenuesingle_ - fixedpricesingle_;
   PIPE row(rec_);
   
   rec_.cost_type:='D';
   rec_.structure_cost:=directsalescost_;
   rec_.object_cost:=directsalessingle_;
   rec_.structure_revenue:=directsalesrevenue_;
   rec_.object_revenue:=directsalesrevenuesingle_;
   rec_.structure_profit_margin:=directsalesrevenue_ - directsalescost_;
   rec_.object_profit_margin:=directsalesrevenuesingle_ - directsalessingle_;
   PIPE ROW(rec_);
   
   rec_.cost_type:='C';
   rec_.structure_cost:=contrinvcost_;
   rec_.object_cost:=contrinvsingle_;
   rec_.structure_revenue:=contrinvrevenue_;
   rec_.object_revenue:=contrinvrevenuesingle_;
   rec_.structure_profit_margin:=contrinvrevenue_ - contrinvcost_;
   rec_.object_profit_margin:=contrinvrevenuesingle_ - contrinvsingle_;
   PIPE ROW(rec_);
   
   rec_.cost_type:='TT';
   rec_.structure_cost:=personnelcost_ + materialcost_ + toolscost_ + externalcost_ + expencescost_ + fixedpricecost_ + directsalescost_ + contrinvcost_;
   rec_.object_cost:=personnelsingle_ + materialsingle_ + toolssingle_ + externalsingle_ + expencessingle_ + fixedpricesingle_ + directsalessingle_ + contrinvsingle_;
   rec_.structure_revenue:=personnelrevenue_ + materialrevenue_ + toolsrevenue_ + externalrevenue_ + expencesrevenue_ + fixedpricerevenue_ +  directsalesrevenue_  + contrinvrevenue_;
   rec_.object_revenue:=personnelrevenuesingle_ + materialrevenuesingle_ + toolsrevenuesingle_ + externalrevenuesingle_ + expencesrevenuesingle_ + fixedpricerevenuesingle_ + directsalesrevenuesingle_  + contrinvrevenuesingle_;
   rec_.structure_profit_margin:=rec_.structure_revenue - rec_.structure_cost;
   rec_.object_profit_margin:=rec_.object_revenue - rec_.object_cost;
   PIPE ROW(rec_);

END Calculate_Cost_Revenue;

FUNCTION Cost_Revenue_Structure_Graph_( 
   mch_code_          IN VARCHAR2 DEFAULT NULL,
   mch_code_contract_ IN VARCHAR2 DEFAULT NULL,
   sup_mch_code_      IN VARCHAR2 DEFAULT NULL,
   sup_contract_      IN VARCHAR2 DEFAULT NULL,
   date_from_         IN DATE DEFAULT NULL,
   date_to_           IN DATE DEFAULT NULL,
   selection_         IN VARCHAR2 DEFAULT NULL,
   project_no_        IN VARCHAR2 DEFAULT NULL,
   total_caost_       IN NUMBER DEFAULT NULL,
   currency_          IN VARCHAR2 DEFAULT NULL,
   graph_type_        IN VARCHAR2 DEFAULT NULL
   ) RETURN Cost_Revenue_Graph_Arr PIPELINED
IS
   rec_                   Cost_Revenue_Graph_Rec; 
   personnelcost_ NUMBER;
   materialcost_ NUMBER;
   toolscost_ NUMBER;
   externalcost_ NUMBER;
   expencescost_ NUMBER;
   fixedpricecost_ NUMBER;
   directsalescost_ NUMBER;
   contrinvcost_ NUMBER;
   
   personnelrevenue_ NUMBER;
   materialrevenue_ NUMBER;
   toolsrevenue_ NUMBER;
   externalrevenue_ NUMBER;
   expencesrevenue_ NUMBER;
   fixedpricerevenue_ NUMBER;
   directsalesrevenue_ NUMBER;
   contrinvrevenue_ NUMBER;  
   
   selection_db_value_ VARCHAR2(4000);
BEGIN
   IF selection_ = 'ExcludeProjectCostRevenue' THEN
      selection_db_value_ := 'Exclude Project Cost/Revenue';
   ELSIF selection_ = 'IncludeProjectCostRevenue' THEN
      selection_db_value_ := 'Include Project Cost/Revenue';
   ELSE
      selection_db_value_ := 'Show Project';
   END IF;
   
   Get_Object_Structure_Cost(personnelcost_,materialcost_,toolscost_,externalcost_,expencescost_,fixedpricecost_,directsalescost_,contrinvcost_,mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,date_from_,date_to_,selection_db_value_,project_no_,currency_);
   Get_Object_Structure_Revenue(personnelrevenue_,materialrevenue_,toolsrevenue_,externalrevenue_,expencesrevenue_,fixedpricerevenue_, directsalesrevenue_ ,contrinvrevenue_, mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,date_from_,date_to_,selection_db_value_,project_no_,currency_);

   rec_.cost_revenue_type:='StructureCost';
   rec_.personnel:=personnelcost_;
   rec_.material:=materialcost_;
   rec_.tool_equipment:=toolscost_;
   rec_.external:=externalcost_;
   rec_.expences:=expencescost_;
   rec_.fixed_price:=fixedpricecost_;
   rec_.direct_sales:=directsalescost_;
   rec_.contract_invoicing:=contrinvcost_;
   rec_.total:=personnelcost_ + materialcost_ + toolscost_ + externalcost_ + expencescost_ + fixedpricecost_ + directsalescost_ + contrinvcost_;
   PIPE ROW(rec_);

   rec_.cost_revenue_type:='StructureRevenue';
   rec_.personnel:=personnelrevenue_;
   rec_.material:=materialrevenue_;
   rec_.tool_equipment:=toolsrevenue_;
   rec_.external:=externalrevenue_;
   rec_.expences:=expencesrevenue_;
   rec_.fixed_price:=fixedpricerevenue_;
   rec_.direct_sales:=directsalesrevenue_;
   rec_.contract_invoicing:=contrinvrevenue_;
   rec_.total:=personnelrevenue_ + materialrevenue_ + toolsrevenue_ + externalrevenue_ + expencesrevenue_ + fixedpricerevenue_ + directsalesrevenue_ + contrinvrevenue_;
   PIPE ROW(rec_);

   IF graph_type_ = 'BAR' THEN
      rec_.cost_revenue_type:='StructureProfitMargin';
      rec_.personnel:=personnelrevenue_ - personnelcost_;
      rec_.material:=materialrevenue_ - materialcost_;
      rec_.tool_equipment:=toolsrevenue_ - toolscost_;
      rec_.external:=expencesrevenue_ - externalcost_;
      rec_.expences:=externalrevenue_ - expencescost_;
      rec_.fixed_price:=fixedpricerevenue_ - fixedpricecost_;
      rec_.direct_sales:=directsalesrevenue_ - directsalescost_;
      rec_.contract_invoicing:=contrinvrevenue_ - contrinvcost_;
      rec_.total:=rec_.personnel + rec_.material + rec_.tool_equipment + rec_.external + rec_.expences + rec_.fixed_price + rec_.direct_sales + rec_.contract_invoicing;
      PIPE ROW(rec_);
   END IF;
   
END Cost_Revenue_Structure_Graph_;

FUNCTION Cost_Revenue_Object_Graph_(
   mch_code_          IN VARCHAR2 DEFAULT NULL,
   mch_code_contract_ IN VARCHAR2 DEFAULT NULL,
   sup_mch_code_      IN VARCHAR2 DEFAULT NULL,
   sup_contract_      IN VARCHAR2 DEFAULT NULL,
   date_from_         IN DATE DEFAULT NULL,
   date_to_           IN DATE DEFAULT NULL,
   selection_         IN VARCHAR2 DEFAULT NULL,
   project_no_        IN VARCHAR2 DEFAULT NULL,
   total_caost_       IN NUMBER DEFAULT NULL,
   currency_          IN VARCHAR2 DEFAULT NULL,
   graph_type_        IN VARCHAR2 DEFAULT NULL
   ) RETURN Cost_Revenue_Graph_Arr PIPELINED
IS
   rec_                   Cost_Revenue_Graph_Rec; 
   personnelsingle_ NUMBER;
   materialsingle_ NUMBER;
   toolssingle_ NUMBER;
   externalsingle_ NUMBER;
   expencessingle_ NUMBER;
   fixedpricesingle_ NUMBER;
   directsalessingle_ NUMBER;
   contrinvsingle_ NUMBER;
   
   personnelrevenuesingle_ NUMBER;
   materialrevenuesingle_ NUMBER;
   toolsrevenuesingle_ NUMBER;
   externalrevenuesingle_ NUMBER;
   expencesrevenuesingle_ NUMBER;
   fixedpricerevenuesingle_ NUMBER;
   directsalesrevenuesingle_ NUMBER;
   contrinvrevenuesingle_ NUMBER;
   
   selection_db_value_ VARCHAR2(4000);
BEGIN
   IF selection_ = 'ExcludeProjectCostRevenue' THEN
      selection_db_value_ := 'Exclude Project Cost/Revenue';
   ELSIF selection_ = 'IncludeProjectCostRevenue' THEN
      selection_db_value_ := 'Include Project Cost/Revenue';
   ELSE
      selection_db_value_ := 'Show Project';
   END IF;
   
   Get_Object_Cost(personnelsingle_,materialsingle_,toolssingle_,externalsingle_,expencessingle_,fixedpricesingle_,directsalessingle_,contrinvsingle_,mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,date_from_,date_to_,selection_db_value_,project_no_,currency_);
   Get_Object_Revenue(personnelrevenuesingle_,materialrevenuesingle_,toolsrevenuesingle_,externalrevenuesingle_,expencesrevenuesingle_,fixedpricerevenuesingle_,directsalesrevenuesingle_ ,contrinvrevenuesingle_, mch_code_,mch_code_contract_,sup_mch_code_,sup_contract_,date_from_,date_to_,selection_db_value_,project_no_,currency_);

   rec_.cost_revenue_type:='ObjectCost';
   rec_.personnel:=personnelsingle_;
   rec_.material:=materialsingle_;
   rec_.tool_equipment:=toolssingle_;
   rec_.external:=externalsingle_;
   rec_.expences:=expencessingle_;
   rec_.fixed_price:=fixedpricesingle_;
   rec_.direct_sales:=directsalessingle_;
   rec_.contract_invoicing:=contrinvsingle_;
   rec_.total:=personnelsingle_ + materialsingle_ + toolssingle_ + externalsingle_ + expencessingle_ + fixedpricesingle_ + directsalessingle_ + contrinvsingle_;
   PIPE ROW(rec_);

   rec_.cost_revenue_type:='ObjectRevenue';
   rec_.personnel:=personnelrevenuesingle_;
   rec_.material:=materialrevenuesingle_;
   rec_.tool_equipment:=toolsrevenuesingle_;
   rec_.external:=externalrevenuesingle_;
   rec_.expences:=expencesrevenuesingle_;
   rec_.fixed_price:=fixedpricerevenuesingle_;
   rec_.direct_sales:=directsalesrevenuesingle_;
   rec_.contract_invoicing:=contrinvrevenuesingle_;
   rec_.total:=personnelrevenuesingle_ + materialrevenuesingle_ + toolsrevenuesingle_ + externalrevenuesingle_ + expencesrevenuesingle_ + fixedpricerevenuesingle_ + directsalesrevenuesingle_ + contrinvrevenuesingle_;
   PIPE ROW(rec_);

   IF graph_type_ = 'BAR' THEN
      rec_.cost_revenue_type:='ObjectProfitMargin';
      rec_.personnel:=personnelrevenuesingle_ - personnelsingle_;
      rec_.material:=materialrevenuesingle_ - materialsingle_;
      rec_.tool_equipment:=toolsrevenuesingle_ - toolssingle_;
      rec_.external:=externalrevenuesingle_ - externalsingle_;
      rec_.expences:=expencesrevenuesingle_ - expencessingle_;
      rec_.fixed_price:=fixedpricerevenuesingle_ - fixedpricesingle_;
      rec_.direct_sales:=directsalesrevenuesingle_ - directsalessingle_;
      rec_.contract_invoicing:=contrinvrevenuesingle_ - contrinvsingle_;
      rec_.total:=rec_.personnel + rec_.material + rec_.tool_equipment + rec_.external + rec_.expences + rec_.fixed_price + rec_.direct_sales + rec_.contract_invoicing;
      PIPE ROW(rec_);
   END IF;

END Cost_Revenue_Object_Graph_;