-----------------------------------------------------------------------------
--
--  Logical unit: CostTypeSourceIndicator
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140424  DipeLK  PBFI-6782 ,Added create company tool support from the developer studio
--  131126  MAWILK  PBSA-586, Hooks: Renamed Get_Cost_Source_Id() to Get_Latest_Cost_Source_Id().
--  130812  MaIklk  TIBE-928, Removed global variables and used conditional compilation instead.
--  101026  JoAnse  Added labor_site to Get_Labor_Sfr_Cost_Source and Get_Labor_Oh_Sfr_Cost_Source.
--                  Changed Get_Cost_Source_Id___ so that labor_site_ is handled.
--  100426  Ajpelk  Merge rose method documentation
-- ----------------------------Eagle------------------------------------------
--  090304  PraWlk  Bug 79553, Added parameter emp_cat_name_ to Get_Project_Labor_Cost_Source and 
--  090304          modified Validate_Combinations___ for transaction_cost_type PROJECT - LABOR.
--  080428  HoInlk  Bug 73185, Modified Validate_Combinations___ to consider cost_source_indicator
--  080428          'WORK CENTER' for transaction cost types 'SUBCONTRACTING' and 'SUBCONTRACTING OVERHEAD'.
--  061218  RaKalk  Added method Get_Sales_Oh_Cost_Source
--  061218  RaKalk  Modified Validate_Combinations___ method to add valid combinations for SALES OVERHEAD
--  --------------------------------- 13.4.0 --------------------------------
--  060330  JoAnSe  Returned '*' in Get_Cost_Source_Id___ when no data found.
--  060309  JoAnSe  Changed LUs checked for some of the inst_XXX constants used.
--  060308  RIBRUS  B136859 Change package name CompanyEmpCatCostSourceAPI to CompEmpCatCostSourceAPI in GetCostSourceId.
--  060120  JaJalk  Added Assert safe annotation.
--  060104  IsAnlk  Added General_Sys.Init to methods.
--  051130  JoEd    Fixed some dynamic calls in Get_Cost_Source_Id___.
--  051125  JoEd    Added Get_Project_Labor_Cost_Source.
--                  Added validation for transaction cost type 'Project - Labor'.
--  051116  JoEd    Changed column title (prompt) for fixed_value.
--  051104  HaPulk  Dropped view COST_TYPE_SOURCE_INDICATOR_ECT.
--  051103  JoAnSe  Added cost_source_date_ to cost source methods
--  051101  JoEd    Added check on cost_source_id before returning * in Get_Cost_Source_Id___.
--  051021  JoAnSe  Corrected view comments
--  051012  JoAnSe  Replaced emp_cat_id_ with emp_cat_name_
--  051005  JoAnSe  Added logic for retrieving cost source for 'Work Order - Labor'.
--  051004  JoAnSe  Changed Purchase_Buyer_API.Get_Cost_Source_Id to Get_Current_Cost_Source_Id
--                  Set cost_source_id_ to '*' when NULL in Get_Cost_Source_Id___
--  050926  JoAnSe  Renamed transaction cost type for Shop Order and Shop Floor Reporting.
--  050628  JoAnSe  Added handling for Fixed Value, Machine Overhead 1 and 2.
--  050617  JoAnSe  Added new Get-methods for additional transaction cost types.
--  050526  JoAnSe  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Cost_Source_Rec IS RECORD
   (contract             VARCHAR2(5),
    company              VARCHAR2(20),
    buyer_code           VARCHAR2(20),
    labor_site           VARCHAR2(5),
    labor_class_no       VARCHAR2(10),
    work_center_no       VARCHAR2(5),
    org_code             VARCHAR2(10),
    emp_cat_name         VARCHAR2(40),
    maintenance_org_code VARCHAR2(8),
    part_no              VARCHAR2(25),
    requisitioner_code   VARCHAR2(20),
    project_id           VARCHAR2(10),
    cost_source_date     DATE);


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Cost_Source_Id___
--   Return the cost source id for the specified transaction cost type given
--   the possible cost sources in cost source rec
FUNCTION Get_Cost_Source_Id___ (
    transaction_cost_type_db_ IN VARCHAR2,
    cost_source_rec_          IN Cost_Source_Rec ) RETURN VARCHAR2
IS
   company_                  VARCHAR2(20);
   cost_source_date_         DATE;
   cost_source_id_           VARCHAR2(20);
   pub_rec_                  Public_Rec;

BEGIN
   IF (cost_source_rec_.company IS NOT NULL) THEN
      company_ := cost_source_rec_.company;
   ELSE
      company_ := Site_API.Get_Company(cost_source_rec_.contract);
   END IF;

   IF (cost_source_rec_.cost_source_date IS NOT NULL) THEN
      cost_source_date_ := cost_source_rec_.cost_source_date;
   ELSE
      cost_source_date_ := TRUNC(Site_API.Get_Site_Date(cost_source_rec_.contract));
   END IF;
   
   pub_rec_ := Get(company_, transaction_cost_type_db_);

   -- IF company has not been updated records might not exist in the table
   -- in this case return cost_source_id = '*'
   IF pub_rec_.cost_source_indicator IS NULL THEN
      RETURN '*';
   END IF;

   CASE pub_rec_.cost_source_indicator
      WHEN 'FIXED VALUE' THEN
         cost_source_id_ := pub_rec_.fixed_value;
      WHEN 'SITE' THEN
         cost_source_id_ := Site_Cost_Source_API.Get_Cost_Source_Id(cost_source_rec_.contract,
                                                                    cost_source_date_);
      WHEN 'PURCHASER' THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            cost_source_id_ := Purchase_Buyer_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                 cost_source_rec_.buyer_code,
                                                                                 cost_source_date_);                     
         $ELSE
            NULL;
         $END
      WHEN 'LABOR CLASS' THEN
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            cost_source_id_ := Labor_Class_Cost_Source_API.Get_Cost_Source_Id(cost_source_rec_.labor_site,
                                                                              cost_source_rec_.labor_class_no,
                                                                              cost_source_date_);       
         $ELSE
            NULL;
         $END                                                                                 
      WHEN 'WORK CENTER' THEN
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            cost_source_id_ := Work_Center_Cost_Source_API.Get_Cost_Source_Id(cost_source_rec_.contract,
                                                                              cost_source_rec_.work_center_no,
                                                                              cost_source_date_);  
         $ELSE
            NULL;
         $END
      WHEN 'ORGANIZATIONAL UNIT' THEN
         $IF (Component_Person_SYS.INSTALLED) $THEN
            cost_source_id_ := Company_Org_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                              cost_source_rec_.org_code,
                                                                              cost_source_date_);                   
         $ELSE
            NULL;
         $END
      WHEN 'EMPLOYEE CATEGORY' THEN
         $IF (Component_Person_SYS.INSTALLED) $THEN
            cost_source_id_ := Comp_Emp_Cat_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                               cost_source_rec_.emp_cat_name,
                                                                               cost_source_date_);                    
         $ELSE
            NULL;
         $END
      WHEN 'MAINTENANCE ORGANIZATION' THEN
         $IF (Component_Mscom_SYS.INSTALLED) $THEN
            cost_source_id_ := Organization_Cost_Source_API.Get_Latest_Cost_Source_Id(cost_source_rec_.contract,
                                                                               cost_source_rec_.maintenance_org_code,
                                                                               cost_source_date_);                     
         $ELSE
            NULL;
         $END
      WHEN 'ABC CLASS FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               abc_class_ VARCHAR2(1);
            BEGIN
               abc_class_       := Inventory_Part_API.Get_Abc_Class(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Abc_Class_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                abc_class_,
                                                                                cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'PLANNER FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               buyer_code_ VARCHAR2(20);
            BEGIN
               buyer_code_      := Inventory_Part_API.Get_Planner_Buyer(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Inv_Part_Plan_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                    buyer_code_,
                                                                                    cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'ACCOUNTING GROUP FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               accounting_group_ VARCHAR2(5);
            BEGIN
               accounting_group_ := Inventory_Part_API.Get_Accounting_Group(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_   := Acc_Group_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                 accounting_group_,
                                                                                 cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'PRODUCT FAMILY FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               product_family_ VARCHAR2(5);
            BEGIN
               product_family_  := Inventory_Part_API.Get_Part_Product_Family(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Inv_Prod_Fam_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                   product_family_,
                                                                                   cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'PRODUCT CODE FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               product_code_ VARCHAR2(5);
            BEGIN
               product_code_    := Inventory_Part_API.Get_Part_Product_Code(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Inv_Prod_Code_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                    product_code_,
                                                                                    cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'PART TYPE FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               type_code_db_ VARCHAR2(20);
            BEGIN
               type_code_db_    := Inventory_Part_API.Get_Type_Code_Db(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Inv_Part_Type_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                    type_code_db_,
                                                                                    cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'COMMODITY GROUP 1 FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               commodity_code_ VARCHAR2(5);
            BEGIN
               commodity_code_  := Inventory_Part_API.Get_Prime_Commodity(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Comm_Group_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                 commodity_code_,
                                                                                 cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'COMMODITY GROUP 2 FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               commodity_code_ VARCHAR2(5);
            BEGIN
               commodity_code_  := Inventory_Part_API.Get_Second_Commodity(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Comm_Group_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                 commodity_code_,
                                                                                 cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'ASSET CLASS FOR INVENTORY PART' THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            DECLARE
               asset_class_ VARCHAR2(2);
            BEGIN
               asset_class_     := Inventory_Part_API.Get_Asset_Class(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Asset_Class_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                  asset_class_,
                                                                                  cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'PURCHASE GROUP FOR PURCHASE PART' THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            DECLARE
               stat_grp_ VARCHAR2(6);
            BEGIN
               stat_grp_        := Purchase_Part_API.Get_Stat_Grp(cost_source_rec_.contract, cost_source_rec_.part_no);
               cost_source_id_  := Pur_Part_Group_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                                     stat_grp_,
                                                                                     cost_source_date_);
            END;
         $ELSE
            NULL;
         $END
      WHEN 'PURCHASE REQUISITIONER' THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            cost_source_id_ := Pur_Requiser_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                               cost_source_rec_.requisitioner_code,
                                                                               cost_source_date_);                     
         $ELSE
            NULL;
         $END
      WHEN 'PROJECT' THEN
         $IF (Component_Prjrep_SYS.INSTALLED) $THEN
            cost_source_id_ := Project_Cost_Source_API.Get_Cost_Source_Id(company_,
                                                                          cost_source_rec_.project_id,
                                                                          cost_source_date_);                      
         $ELSE
            NULL;
         $END
      ELSE
         Error_SYS.Record_General(lu_name_, 'IND_NOT_HANDLED: Cost Source Indicator :P1 not handled', Cost_Source_Indicator_API.Decode(pub_rec_.cost_source_indicator));
   END CASE;

   IF (cost_source_id_ IS NULL) THEN
      cost_source_id_:= '*';
   END IF;

   -- if cost source becomes a star check the mandatory cost source flag on Company.
   IF (cost_source_id_ = '*') THEN
      IF (Company_Distribution_Info_API.Get_Mandatory_Cost_Source_Db(company_) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'CS_INCOMPLETE: Cost Source set up is not complete for Transaction Cost Type ":P1".', Transaction_Cost_Type_API.Decode(transaction_cost_type_db_));
      END IF;
   END IF;

   RETURN cost_source_id_;
END Get_Cost_Source_Id___;

-- Validate_Combinations___
--   Check that the values specified for transaction_cost_type and
--   cost_source_indicator are an allowed combination.
PROCEDURE Validate_Combinations___ (
   newrec_ IN COST_TYPE_SOURCE_INDICATOR_TAB%ROWTYPE )
IS
   invalid_comb EXCEPTION;

BEGIN

   -- Check allowed combinations of Transaction Cost Type and Cost Source Indicator
   CASE newrec_.transaction_cost_type
      WHEN 'PURCHASED MATERIAL' THEN
         IF ((newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'PURCHASER',
                                                    'PURCHASE GROUP FOR PURCHASE PART',
                                                    'PURCHASE REQUISITIONER')) AND
             (NOT Inventory_Part_Related___(newrec_.cost_source_indicator))) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'MATERIAL OVERHEAD' THEN
         IF ((newrec_.cost_source_indicator NOT IN ('FIXED VALUE','SITE')) AND
             (NOT Inventory_Part_Related___(newrec_.cost_source_indicator))) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'DELIVERY OVERHEAD' THEN
         IF ((newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'PURCHASER',
                                                    'PURCHASE GROUP FOR PURCHASE PART',
                                                    'PURCHASE REQUISITIONER')) AND
            (NOT Inventory_Part_Related___(newrec_.cost_source_indicator))) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'SHOP ORDER - LABOR' THEN
         IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'LABOR CLASS', 'WORK CENTER')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'SHOP ORDER - LABOR OVERHEAD' THEN
         IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'LABOR CLASS', 'WORK CENTER')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'SHOP FLOOR REPORTING - LABOR' THEN
         IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'LABOR CLASS', 'WORK CENTER',
                                                   'ORGANIZATIONAL UNIT', 'EMPLOYEE CATEGORY')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'SHOP FLOOR REPORTING - LABOR OVERHEAD' THEN
         IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'LABOR CLASS', 'WORK CENTER',
                                                   'ORGANIZATIONAL UNIT', 'EMPLOYEE CATEGORY')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'MACHINE' THEN
         IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'WORK CENTER')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'MACHINE OVERHEAD 1' THEN
            IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'WORK CENTER')) THEN
               RAISE invalid_comb;
            END IF;
      WHEN 'MACHINE OVERHEAD 2' THEN
            IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'WORK CENTER')) THEN
               RAISE invalid_comb;
            END IF;
      WHEN 'GENERAL OVERHEAD' THEN
         IF ((newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE')) AND
             (NOT Inventory_Part_Related___(newrec_.cost_source_indicator))) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'SUBCONTRACTING' THEN
         IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'WORK CENTER')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'SUBCONTRACTING OVERHEAD' THEN
         IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'SITE', 'WORK CENTER')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'WORK ORDER - LABOR' THEN
         IF (newrec_.cost_source_indicator NOT IN ('FIXED VALUE', 'MAINTENANCE ORGANIZATION')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'PROJECT - LABOR' THEN
         IF (newrec_.cost_source_indicator NOT IN ('ORGANIZATIONAL UNIT', 'PROJECT', 'EMPLOYEE CATEGORY')) THEN
            RAISE invalid_comb;
         END IF;
      WHEN 'SALES OVERHEAD' THEN
         IF (NOT (newrec_.cost_source_indicator IN ('FIXED VALUE', 'SITE') OR Inventory_Part_Related___(newrec_.cost_source_indicator))) THEN
            RAISE invalid_comb;
         END IF;
   END CASE;

   -- Additional checks for Fixed Value
   IF ((newrec_.cost_source_indicator = 'FIXED VALUE') AND
       (newrec_.fixed_value IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'SPECIFY_FIXED_VAL: A Fixed Cost Source must be specified when Cost Source Indicator is ":P1"', Cost_Source_Indicator_API.Decode(newrec_.cost_source_indicator));
   ELSIF ((newrec_.cost_source_indicator != 'FIXED VALUE') AND
          (newrec_.fixed_value IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'NO_FIXED_VAL: A Fixed Cost Source may not be specified when Cost Source Indicator is ":P1"', Cost_Source_Indicator_API.Decode(newrec_.cost_source_indicator));
   END IF;

EXCEPTION
   WHEN invalid_comb THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_COMB: Cost Source Indicator ":P1" may not be used for Cost Type ":P2"',
                               Cost_Source_Indicator_API.Decode(newrec_.cost_source_indicator),
                               Transaction_Cost_Type_API.Decode(newrec_.transaction_cost_type));

END Validate_Combinations___;


-- Inventory_Part_Related___
--   Check if the specified cost_source_indicator is related to attributes
--   found on Inventory Part.
FUNCTION Inventory_Part_Related___ (
   cost_source_indicator_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF cost_source_indicator_ IN ('ABC CLASS FOR INVENTORY PART',
                                 'PLANNER FOR INVENTORY PART',
                                 'ACCOUNTING GROUP FOR INVENTORY PART',
                                 'PRODUCT FAMILY FOR INVENTORY PART',
                                 'PRODUCT CODE FOR INVENTORY PART',
                                 'PART TYPE FOR INVENTORY PART',
                                 'COMMODITY GROUP 1 FOR INVENTORY PART',
                                 'COMMODITY GROUP 2 FOR INVENTORY PART',
                                 'ASSET CLASS FOR INVENTORY PART') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Inventory_Part_Related___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cost_type_source_indicator_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   Validate_Combinations___(newrec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cost_type_source_indicator_tab%ROWTYPE,
   newrec_ IN OUT cost_type_source_indicator_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Combinations___(newrec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Material_Cost_Source
--   Retrieve and return the cost source used for
--   'Purchased Material' costs
FUNCTION Get_Material_Cost_Source (
   contract_           IN VARCHAR2,
   company_            IN VARCHAR2,
   buyer_code_         IN VARCHAR2,
   requisitioner_code_ IN VARCHAR2,
   part_no_            IN VARCHAR2,
   cost_source_date_   IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract           := contract_;
   cost_source_rec_.company            := company_;
   cost_source_rec_.buyer_code         := buyer_code_;
   cost_source_rec_.requisitioner_code := requisitioner_code_;
   cost_source_rec_.part_no            := part_no_;
   cost_source_rec_.cost_source_date   := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('PURCHASED MATERIAL', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Material_Cost_Source;


-- Get_Material_Oh_Cost_Source
--   Retrieve and return the cost source used for
--   'Material Overhead' costs
FUNCTION Get_Material_Oh_Cost_Source (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.part_no          := part_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('MATERIAL OVERHEAD', cost_source_rec_);
   RETURN cost_source_id_;
END Get_Material_Oh_Cost_Source;


-- Get_Delivery_Oh_Cost_Source
--   Retrieve and return the cost source used for
--   'Delivery Overhead' costs
FUNCTION Get_Delivery_Oh_Cost_Source (
   contract_           IN VARCHAR2,
   company_            IN VARCHAR2,
   buyer_code_         IN VARCHAR2,
   requisitioner_code_ IN VARCHAR2,
   part_no_            IN VARCHAR2,
   cost_source_date_   IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract           := contract_;
   cost_source_rec_.company            := company_;
   cost_source_rec_.buyer_code         := buyer_code_;
   cost_source_rec_.requisitioner_code := requisitioner_code_;
   cost_source_rec_.part_no            := part_no_;
   cost_source_rec_.cost_source_date   := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('DELIVERY OVERHEAD', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Delivery_Oh_Cost_Source;


-- Get_Labor_So_Cost_Source
--   Retrieve and return the cost source used for
--   'Shop Order - Labor' costs
FUNCTION Get_Labor_So_Cost_Source (
   contract_         IN VARCHAR2,
   labor_class_no_   IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.labor_site       := contract_;
   cost_source_rec_.labor_class_no   := labor_class_no_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('SHOP ORDER - LABOR', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Labor_So_Cost_Source;


-- Get_Labor_Oh_So_Cost_Source
--   Retrieve and return the cost source used for
--   'Shop Order - Labor Overhead' costs
FUNCTION Get_Labor_Oh_So_Cost_Source (
   contract_         IN VARCHAR2,
   labor_class_no_   IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.labor_site       := contract_;
   cost_source_rec_.labor_class_no   := labor_class_no_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('SHOP ORDER - LABOR OVERHEAD', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Labor_Oh_So_Cost_Source;


-- Get_Labor_Sfr_Cost_Source
--   Retrieve and return the cost source used for
--   'Shop Floor Reporting - Labor' costs
FUNCTION Get_Labor_Sfr_Cost_Source (
   contract_         IN VARCHAR2,
   labor_site_       IN VARCHAR2,
   labor_class_no_   IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   company_          IN VARCHAR2,
   org_code_         IN VARCHAR2,
   emp_cat_name_     IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   -- In employee reporting mode the employee could be connected to another site than the operation
   cost_source_rec_.labor_site       := labor_site_;
   cost_source_rec_.labor_class_no   := labor_class_no_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.company          := company_;
   cost_source_rec_.org_code         := org_code_;
   cost_source_rec_.emp_cat_name     := emp_cat_name_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('SHOP FLOOR REPORTING - LABOR', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Labor_Sfr_Cost_Source;


-- Get_Labor_Oh_Sfr_Cost_Source
--   Retrieve and return the cost source used for
--   'Shop Floor Reporting - Labor Overhead' costs
FUNCTION Get_Labor_Oh_Sfr_Cost_Source (
   contract_         IN VARCHAR2,
   labor_site_       IN VARCHAR2,
   labor_class_no_   IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   company_          IN VARCHAR2,
   org_code_         IN VARCHAR2,
   emp_cat_name_     IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   -- In employee reporting mode the employee could be connected to another site than the operation
   cost_source_rec_.labor_site       := labor_site_;
   cost_source_rec_.labor_class_no   := labor_class_no_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.company          := company_;
   cost_source_rec_.org_code         := org_code_;
   cost_source_rec_.emp_cat_name     := emp_cat_name_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('SHOP FLOOR REPORTING - LABOR OVERHEAD', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Labor_Oh_Sfr_Cost_Source;


-- Get_Machine_Cost_Source
--   Retrieve and return the cost source used for 'Machine' costs
FUNCTION Get_Machine_Cost_Source (
   contract_         IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('MACHINE', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Machine_Cost_Source;


-- Get_Machine_Oh1_Cost_Source
--   Retrieve and return the cost source used for
--   'Machine Overhead 1' costs
FUNCTION Get_Machine_Oh1_Cost_Source (
   contract_         IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('MACHINE OVERHEAD 1', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Machine_Oh1_Cost_Source;


-- Get_Machine_Oh2_Cost_Source
--   Retrieve and return the cost source used for
--   'Machine Overhead 2' costs
FUNCTION Get_Machine_Oh2_Cost_Source (
   contract_         IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('MACHINE OVERHEAD 2', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Machine_Oh2_Cost_Source;


-- Get_General_Oh_Cost_Source
--   Retrieve and return the cost source used for
--   'General Overhead' costs
FUNCTION Get_General_Oh_Cost_Source (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN

   cost_source_rec_.contract         := contract_;
   cost_source_rec_.part_no          := part_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('GENERAL OVERHEAD', cost_source_rec_);
   RETURN cost_source_id_;

END Get_General_Oh_Cost_Source;


-- Get_Subcontracting_Cost_Source
--   Retrieve and return the cost source used for
--   'Subcontracting' costs
FUNCTION Get_Subcontracting_Cost_Source (
   contract_         IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('SUBCONTRACTING', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Subcontracting_Cost_Source;


-- Get_Subcontract_Oh_Cost_Source
--   Retrieve and return the cost source used for
--   'Subcontracting Overhead' costs
FUNCTION Get_Subcontract_Oh_Cost_Source (
   contract_         IN VARCHAR2,
   work_center_no_   IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.work_center_no   := work_center_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('SUBCONTRACTING OVERHEAD', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Subcontract_Oh_Cost_Source;


-- Get_Work_Ord_Labor_Cost_Source
--   Retrieve and return the cost source used for
--   'Work Order - Labor' costs
FUNCTION Get_Work_Ord_Labor_Cost_Source (
   contract_         IN VARCHAR2,
   org_code_         IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN

   cost_source_rec_.contract             := contract_;
   cost_source_rec_.maintenance_org_code := org_code_;
   cost_source_rec_.cost_source_date     := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('WORK ORDER - LABOR', cost_source_rec_);
   RETURN cost_source_id_;

END Get_Work_Ord_Labor_Cost_Source;


-- Get_Project_Labor_Cost_Source
--   Retrieve and return the cost source used for
--   'Project - Labor' costs.
FUNCTION Get_Project_Labor_Cost_Source (
   company_          IN VARCHAR2,
   org_code_         IN VARCHAR2,
   project_id_       IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT SYSDATE,
   emp_cat_name_     IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
BEGIN
   cost_source_rec_.company              := company_;
   cost_source_rec_.org_code             := org_code_;
   cost_source_rec_.project_id           := project_id_;
   cost_source_rec_.cost_source_date     := cost_source_date_;
   cost_source_rec_.emp_cat_name         := emp_cat_name_;  

   RETURN Get_Cost_Source_Id___('PROJECT - LABOR', cost_source_rec_);

END Get_Project_Labor_Cost_Source;


-- Get_Sales_Oh_Cost_Source
--   Retrieve and return the cost source used for 'Sales Overhead' costs
FUNCTION Get_Sales_Oh_Cost_Source (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   cost_source_date_ IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   cost_source_rec_ Cost_Source_Rec;
   cost_source_id_  VARCHAR2(20);
BEGIN
   cost_source_rec_.contract         := contract_;
   cost_source_rec_.part_no          := part_no_;
   cost_source_rec_.cost_source_date := cost_source_date_;

   cost_source_id_ := Get_Cost_Source_Id___('SALES OVERHEAD', cost_source_rec_);
   RETURN cost_source_id_;
END Get_Sales_Oh_Cost_Source;



