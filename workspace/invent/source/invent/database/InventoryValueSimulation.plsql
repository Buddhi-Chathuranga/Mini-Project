-----------------------------------------------------------------------------
--
--  Logical unit: InventoryValueSimulation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130805  ChJalk  TIBE-892, Removed the global variable inst_CostSet_.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  060123  NiDalk  Added Assert safe annotation. 
--  060110  GeKalk  Changed the SELECT &OBJID statement to the RETURNING &OBJID in Insert___.
--  050920  NiDalk  Removed unused varibles.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040202  NaWalk  Removed the fourth variable of DBMS_SQL inside the while loop,for Unicode modification.
--  -------------------------------- 13.3.0 ----------------------------------
--  010411  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  001113  JOHW    Corrected validation for cost_set in create_simulation.
--  000925  JOHESE  Added undefines.
--  000503  NISOSE  Changed the check for valid simulation parameter in Create_Simulation.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000321  LEPE    Added EXCEPTION in Create_Simulation to close cursor cid_.
--  991115  ROOD    Changed within method Create_Simulation to send a more 
--                  informative error message to the user. 
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990520  SHVE    Bug fix for IID Decode/Encode changes.
--  990503  SHVE    General performance improvements.
--  990412  SHVE    Upgraded to performance optimized template.
--  990214  SHVE    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_VALUE_SIMULATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT Simulation_Id.nextval
      INTO newrec_.simulation_id
      FROM DUAL;

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Simulation__
--   To save the simulation created.
PROCEDURE Create_Simulation__ (
   attrib_ IN VARCHAR2 )
IS
  contract_               VARCHAR2(5);
  stat_year_no_           NUMBER;
  stat_period_no_         NUMBER;
  
  parameter1_             VARCHAR2(200);
  parameter2_             VARCHAR2(200);
  parameter1_db_          INVENTORY_VALUE_SIMULATION_TAB.parameter1%TYPE;
  parameter2_db_          INVENTORY_VALUE_SIMULATION_TAB.parameter2%TYPE;
  
  cost_set1_              NUMBER;
  cost_set2_              NUMBER;

  newrec_                 INVENTORY_VALUE_SIMULATION_TAB%ROWTYPE;
  attr_                   VARCHAR2 (32000);
  objid_                  ROWID;
  objversion_             VARCHAR2(2000);

  ptr_                    NUMBER;
  name_                   VARCHAR2(30);
  value_                  VARCHAR2(2000);

  transaction_text_       VARCHAR2(2000);

  simulation_id_          NUMBER;
  indrec_                 Indicator_Rec;
BEGIN
   transaction_text_ := Language_SYS.Translate_Constant(lu_name_,'SIMULATE1: Save the simulated values', NULL);
   Transaction_SYS.Set_Progress_Info(transaction_text_);
   ptr_ := NULL;

   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
    IF (name_ = 'CONTRACT') THEN
        contract_ := value_;
    ELSIF (name_ = 'STAT_YEAR_NO') THEN
        stat_year_no_ := Client_SYS.Attr_Value_To_Number(value_);
    ELSIF (name_ = 'STAT_PERIOD_NO') THEN
        stat_period_no_ := Client_SYS.Attr_Value_To_Number(value_);
    ELSIF (name_ = 'PARAMETER1') THEN
        parameter1_ := value_;
    ELSIF (name_ = 'COST_SET1') THEN
        cost_set1_ := Client_SYS.Attr_Value_To_Number(value_);
    ELSIF (name_ = 'PARAMETER2') THEN
        parameter2_ := value_;
    ELSIF (name_ = 'COST_SET2') THEN
        cost_set2_ := Client_SYS.Attr_Value_To_Number(value_);
    ELSE
       Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
    END IF;
   END LOOP;

   -- save simulation header info.
   IF (parameter1_ IS NULL) THEN
        parameter1_ := Language_SYS.Translate_Constant(lu_name_,'COSTSET1: Cost Set ')||cost_set1_;
   END IF;

   IF (parameter2_ IS NULL) THEN
        parameter2_ := Language_SYS.Translate_Constant(lu_name_,'COSTSET1: Cost Set ')||cost_set2_;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('STAT_YEAR_NO', stat_year_no_, attr_);
   Client_SYS.Add_To_Attr('STAT_PERIOD_NO', stat_period_no_, attr_);
   Client_SYS.Add_To_Attr('CREATE_DATE', Site_API.Get_Site_Date(contract_), attr_);
   Client_SYS.Add_To_Attr('PARAMETER1', parameter1_, attr_);
   Client_SYS.Add_To_Attr('PARAMETER2', parameter2_, attr_);
   Client_SYS.Add_To_Attr('USERID',Fnd_Session_API.Get_Fnd_User,attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   simulation_id_ := newrec_.simulation_id;

   parameter1_db_ := Inventory_Cost_Type_API.Encode(parameter1_);
   parameter2_db_ := Inventory_Cost_Type_API.Encode(parameter2_);

   Inventory_Value_Sim_Line_API.Create_Simulation_Line (
     contract_,
     stat_year_no_,
     stat_period_no_,
     simulation_id_,
     parameter1_db_,
     cost_set1_,
     parameter2_db_,
     cost_set2_);

END Create_Simulation__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Simulation
--   To save the simulation created.
PROCEDURE Create_Simulation (
   contract_ IN VARCHAR2,
   stat_year_no_ IN NUMBER,
   stat_period_no_ IN NUMBER,
   parameter1_ IN VARCHAR2,
   cost_set1_  IN NUMBER,
   parameter2_ IN VARCHAR2,
   cost_set2_  IN NUMBER )
IS
   attrib_          VARCHAR2(32000);
   batch_desc_      VARCHAR2(100);
   count_           NUMBER;

   cost_set_1_       NUMBER; 
   cost_set_2_       NUMBER;

BEGIN
   Site_API.Exist(contract_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   IF NOT Inventory_Value_API.Check_Exist(contract_, stat_year_no_, stat_period_no_) THEN
      Error_SYS.Record_General(lu_name_, 'NOREALVALUE: Simulation can not be performed since there is no Inventory Value created for the year :P1 in period :P2 for site :P3. Please update inventory part statistics and then try again.', stat_year_no_, stat_period_no_, contract_);
   END IF;

   -- check for valid simulation parameter.
   -- This is a special case where the client value is stored
   -- in the table.
   IF (parameter1_ IS NOT NULL) THEN
      Inventory_Cost_Type_API.Exist(parameter1_);
   END IF;  
   IF (parameter2_ IS NOT NULL) THEN
      Inventory_Cost_Type_API.Exist(parameter2_);
   END IF;

   IF (cost_set1_ IS NULL ) THEN
       cost_set_1_ := 0;
   ELSE
       cost_set_1_ := cost_set1_;               
   END IF;
   
   IF (cost_set2_ IS NULL ) THEN
       cost_set_2_ := 0;     
   ELSE
       cost_set_2_ := cost_set2_;       
   END IF;   
      
   --check for a valid cost set
   $IF Component_Cost_SYS.INSTALLED $THEN
      IF ((cost_set_1_ >0 OR cost_set_2_ >0)) THEN
         IF (cost_set_1_ > 0 AND cost_set_2_ >0 ) THEN
            count_ := 2;
         ELSE
            count_ := 1;
         END IF;
         WHILE (count_ > 0) LOOP
            IF (cost_set_1_ >0 ) THEN
               Cost_Set_API.Exist(contract_, cost_set_1_);                           
            END IF;
            IF (cost_set_2_ >0 ) THEN
               Cost_Set_API.Exist(contract_, cost_set_2_);               
            END IF;
            count_ := count_ -1;
         END LOOP;
      END IF;      
   $END

   Client_SYS.Clear_Attr(attrib_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attrib_);
   Client_SYS.Add_To_Attr('STAT_YEAR_NO', stat_year_no_, attrib_);
   Client_SYS.Add_To_Attr('STAT_PERIOD_NO', stat_period_no_, attrib_);
   Client_SYS.Add_To_Attr('PARAMETER1', parameter1_, attrib_);
   Client_SYS.Add_To_Attr('COST_SET1', cost_set_1_, attrib_);
   Client_SYS.Add_To_Attr('PARAMETER2', parameter2_, attrib_);
   Client_SYS.Add_To_Attr('COST_SET2', cost_set_2_, attrib_);

   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDESSIMU: Create Simulated Inventory Value');

   Transaction_SYS.Deferred_Call('Inventory_Value_Simulation_API.Create_Simulation__' ,attrib_,batch_desc_);

END Create_Simulation;



