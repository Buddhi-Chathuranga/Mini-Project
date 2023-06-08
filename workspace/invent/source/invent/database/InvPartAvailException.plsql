-----------------------------------------------------------------------------
--
--  Logical unit: InvPartAvailException
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200702  BudKlk  Bug 154636(SCZ-10615), Modified the method Generate_Exception_Messages__() to always call the curosor get_project_parts.
--  200622  BudKlk  Bug 154484(SCZ-10433), Modified the method Generate_Exception_Messages__() to add a new curosor to fetch the records which have being not removed from the table and 
--  200622          created a new method Remove_Old_Messages_Auto___() to commit the removal of the exception messages.
--  190913  Asawlk  Bug 147919(SCZ-4679), Modified Generate_Exception_Messages__ by changing the datasource of the cursor get_project_parts.
--  171122  BudKlk  Bug 138047, Modified the methods Detect_Avail_Exceptions___() and Generate_Exception_Messages__() by allowing to handle the availablitiy exceptions for 
--  171010          all projects when the '#' was given.
--  170504  LEPESE  STRSC-6689, Removed call to Check_Delete___ from Remove_Old_Messages___ to enhance performance by skipping the call to Reference_SYS.Check_Restricted_Delete.
--  121220  NaLrlk  Modified Detect_Avail_Exceptions___ to include ownership parameters in method call Inventory_Part_In_Stock_API.Get_Inventory_Quantity.
--  130731  MaIklk  TIBE-858, Removed inst_Project_ global constant and used conditional compilation instead.
--  110916  Darklk  Bug 98988, Modified Generate_Exception_Messages to avoid creating another background job when it's invoked from a schedule job.
--  110203  KiSalk  Moved 'User Allowed Site' Default Where condition from client to VIEW_ALL.
--  100927  DAYJLK  Bug 93165, Modified Create_Exception_Messages___ by adding new parameters to create an exception identified 
--  100927          by USABLE QTY < DEMANDS. Modified Detect_Avail_Exceptions___ by adding new variables to detect  
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  100927          and create the new exception for the case where the total demand exceeds the quantity on hand.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  080422  NiBalk  Bug 72596, Added new private method Generate_Exception_Messages__ and moved the content of 
--  080422          Generate_Exception_Messages  to it. Then modified the method body and the parameter list of 
--  080422          Generate_Exception_Messages public method.
--  060508  HaPulk  Bug 57351, Modification in method Generate_Exception_Messages.
--  060203  ISWILK  Modified the PROCEDURE Detect_Avail_Exceptions___ to fetch 
--  060203          qty_onhand from inventory_part_in_stock_api.get_inventory_quantity
--  060203          for NO DEMAND Messages.
--  060123  NiDalk  Added Assert safe annotation. 
--  050920  NiDalk  Removed unused variables.
--  050328  IsWilk  Added PROCEDURE Validate_Params to validate the parameters when 
--  050328          runnimg the Schedule Generate Inventory Part Availability Exceptions. 
--  050117  IsWilk  Modified the PROCEDURE Generate_Exception_Messages to handle % values.
--  041130  JOHESE  Modified procedure Detect_Avail_Exceptions___
--  041123  IsWilk  Modified the PROCEDURE Detect_Avail_Exceptions___.
--  041118  IsWilk  Modified the PROCEDURE Unpack_Check_Insert___ to remove the
--  041118          static call to Project_API.
--  041117  IsWilk  Modified the PROCEDURE Detect_Avail_Exceptions___ ,
--  041117          Generate_Exception_Messages to add the Error message.
--  041109  IsWilk  Modified the PROCEDURE Detect_Avail_Exceptions___.
--  041108  IsWilk  Modified the PROCEDURE Detect_Avail_Exceptions___.
--  041020  IsWilk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Remove_Old_Messages___
--   This procedure remove the old generated Exception Messages
PROCEDURE Remove_Old_Messages___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   project_id_       IN VARCHAR2 )
IS
   remrec_ INV_PART_AVAIL_EXCEPTION_TAB%ROWTYPE;
   CURSOR     delete_msg_rec IS
      SELECT  objid, objversion
        FROM  INV_PART_AVAIL_EXCEPTION
       WHERE  contract         = contract_
         AND  part_no          = part_no_
         AND  configuration_id = configuration_id_
         AND (project_id       = project_id_ );

BEGIN

   FOR del_rec_ IN delete_msg_rec LOOP
      remrec_ := Lock_By_Id___( del_rec_.objid, del_rec_.objversion );
      Delete___( del_rec_.objid, remrec_ );
   END LOOP;

END Remove_Old_Messages___;


-- New___
--   This wil create a new record .
PROCEDURE New___ (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   exception_message_db_ IN VARCHAR2,
   project_id_           IN VARCHAR2,
   qty_onhand_           IN NUMBER,
   qty_reserved_         IN NUMBER,
   qty_in_transit_       IN NUMBER,
   total_qty_demand_     IN NUMBER,
   total_qty_supply_     IN NUMBER,
   neg_onhand_date_      IN DATE )
IS
   attr_                 VARCHAR2(32000);
   objid_                INV_PART_AVAIL_EXCEPTION.objid%TYPE;
   objversion_           INV_PART_AVAIL_EXCEPTION.objversion%TYPE;
   newrec_               INV_PART_AVAIL_EXCEPTION_TAB%ROWTYPE;
   indrec_               Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
   Client_SYS.Add_To_Attr('PROJECT_ID', project_id_, attr_);
   Client_SYS.Add_To_Attr('EXCEPTION_MESSAGE_DB', exception_message_db_, attr_);
   Client_SYS.Add_To_Attr('QTY_ONHAND', qty_onhand_, attr_);
   Client_SYS.Add_To_Attr('QTY_RESERVED', qty_reserved_, attr_);
   Client_SYS.Add_To_Attr('QTY_IN_TRANSIT', qty_in_transit_, attr_);
   Client_SYS.Add_To_Attr('TOTAL_QTY_DEMAND', total_qty_demand_, attr_);
   Client_SYS.Add_To_Attr('TOTAL_QTY_SUPPLY', total_qty_supply_, attr_);

   IF (neg_onhand_date_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NEGATIVE_ONHAND_DATE', neg_onhand_date_, attr_);
   END IF;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_ );

END New___;


-- Detect_Avail_Exceptions___
--   This will detect the Available Exceptions.
PROCEDURE Detect_Avail_Exceptions___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   project_id_       IN VARCHAR2 )
IS
   previous_project_id_     VARCHAR2(10);
   activity_seq_            NUMBER;
   has_supply_past_due_     BOOLEAN;
   has_demand_past_due_     BOOLEAN;
   neg_proj_onhand_         BOOLEAN;
   neg_proj_onhand_no_supplies_   BOOLEAN;
   total_qty_supply_        NUMBER :=0;
   total_qty_demand_        NUMBER :=0;
   total_total_demand_      NUMBER :=0;
   projected_onhand_        NUMBER :=0;
   qty_onhand_              NUMBER :=0;
   projected_onhand_no_supplies_  NUMBER :=0;
   qty_reserved_            NUMBER :=0;
   qty_in_transit_          NUMBER :=0;
   neg_onhand_date_         DATE;
   neg_onhand_no_supplies_date_   DATE;
   today_                   DATE:=TRUNC(Site_API.Get_Site_Date(contract_));
   supply_demand_tab_       Order_Supply_Demand_API.Proj_Date_Supply_Demand_Table;
   new_project_id_          VARCHAR2(10);

BEGIN

   supply_demand_tab_ := Order_Supply_Demand_API.Get_Project_Date_Supply_Demand( contract_,
                                                                                 part_no_,
                                                                                 configuration_id_,
                                                                                 project_id_ );
   -- This will check the table supply_demand_tab_ is empty or not.
   IF (supply_demand_tab_.COUNT > 0) THEN

      FOR index_ IN supply_demand_tab_.FIRST..supply_demand_tab_.LAST LOOP
         IF (supply_demand_tab_(index_).project_id != previous_project_id_ OR previous_project_id_ IS NULL) THEN
            -- New project or first iteration in loop
            IF (previous_project_id_ IS NOT NULL) THEN
               -- Finish work on previous project.
               Create_Exception_Messages___( contract_,
                                             part_no_,
                                             configuration_id_,
                                             previous_project_id_,
                                             qty_onhand_,
                                             qty_reserved_,
                                             qty_in_transit_,
                                             total_qty_demand_,
                                             total_qty_supply_,
                                             has_supply_past_due_,
                                             has_demand_past_due_,
                                             neg_proj_onhand_,
                                             neg_onhand_date_,
                                             neg_proj_onhand_no_supplies_,
                                             neg_onhand_no_supplies_date_ );
            END IF;

            -- Reset flags and accumulators for new project
            has_supply_past_due_ := FALSE;
            has_demand_past_due_ := FALSE;
            neg_proj_onhand_     := FALSE;
            neg_proj_onhand_no_supplies_ := FALSE;
            total_qty_supply_    :=0;
            total_qty_demand_    :=0;
            projected_onhand_    :=0;
            projected_onhand_no_supplies_ :=0;
            qty_onhand_          :=0;
            qty_reserved_        :=0;
            qty_in_transit_      :=0;
            previous_project_id_ :=supply_demand_tab_(index_).project_id;

            IF (previous_project_id_ = '*') THEN
               new_project_id_ := NULL;
               activity_seq_ :=0;
            ELSE
               new_project_id_ := previous_project_id_;
               activity_seq_ := NULL;
            END IF;

            -- Fetch initial inventory part in stock values for new project.
            IF new_project_id_ IS NOT NULL THEN
               Inventory_Part_In_Stock_API.Get_Inventory_Quantity(qty_onhand_         => qty_onhand_,
                                                                  qty_reserved_       => qty_reserved_,
                                                                  qty_in_transit_     => qty_in_transit_,
                                                                  contract_           => contract_,
                                                                  part_no_            => part_no_,
                                                                  configuration_id_   => configuration_id_,
                                                                  expiration_control_ => 'NOT EXPIRED',
                                                                  supply_control_db_  => 'NETTABLE',
                                                                  ownership_type1_db_ => Part_Ownership_API.DB_CONSIGNMENT,
                                                                  ownership_type2_db_ => Part_Ownership_API.DB_COMPANY_OWNED,
                                                                  include_standard_   => 'FALSE',
                                                                  include_project_    => 'TRUE',
                                                                  activity_seq_       => activity_seq_,
                                                                  project_id_         => new_project_id_);
            ELSE
               Inventory_Part_In_Stock_API.Get_Inventory_Quantity(qty_onhand_         => qty_onhand_,
                                                                  qty_reserved_       => qty_reserved_,
                                                                  qty_in_transit_     => qty_in_transit_,
                                                                  contract_           => contract_,
                                                                  part_no_            => part_no_,
                                                                  configuration_id_   => configuration_id_,
                                                                  expiration_control_ => 'NOT EXPIRED',
                                                                  supply_control_db_  => 'NETTABLE',
                                                                  ownership_type1_db_ => Part_Ownership_API.DB_CONSIGNMENT,
                                                                  ownership_type2_db_ => Part_Ownership_API.DB_COMPANY_OWNED,
                                                                  include_standard_   => 'TRUE',
                                                                  include_project_    => 'FALSE');
            END IF;
            projected_onhand_ := qty_onhand_;
            projected_onhand_no_supplies_ := qty_onhand_;
         END IF;
         -- End of new project or first iteration

         IF (supply_demand_tab_(index_).qty_supply > 0 AND supply_demand_tab_(index_).date_required < today_) THEN
            has_supply_past_due_ := TRUE;
         END IF;

         IF (supply_demand_tab_(index_).qty_demand > 0 AND supply_demand_tab_(index_).date_required < today_) THEN
            has_demand_past_due_ := TRUE;
         END IF;

         total_qty_supply_   := total_qty_supply_  + supply_demand_tab_(index_).qty_supply;
         total_qty_demand_   := total_qty_demand_  + supply_demand_tab_(index_).qty_demand;
         total_total_demand_ := total_total_demand_+ supply_demand_tab_(index_).qty_demand;
         projected_onhand_   := projected_onhand_  + supply_demand_tab_(index_).qty_supply - supply_demand_tab_(index_).qty_demand;
         projected_onhand_no_supplies_ := projected_onhand_no_supplies_ - supply_demand_tab_(index_).qty_demand;

         IF (projected_onhand_ < 0 AND NOT neg_proj_onhand_) THEN
            neg_proj_onhand_ := TRUE;
            neg_onhand_date_ := TRUNC(supply_demand_tab_(index_).date_required);
         END IF;

         IF (projected_onhand_no_supplies_ < 0 AND NOT neg_proj_onhand_no_supplies_) THEN
            neg_proj_onhand_no_supplies_ := TRUE;
            neg_onhand_no_supplies_date_ := TRUNC(supply_demand_tab_(index_).date_required);
         END IF;

      END LOOP;

      -- Don't forget the last project id OR if it's only one project per part!
      IF (previous_project_id_ IS NOT NULL) THEN
         Create_Exception_Messages___ ( contract_,
                                        part_no_,
                                        configuration_id_,
                                        previous_project_id_,
                                        qty_onhand_,
                                        qty_reserved_,
                                        qty_in_transit_,
                                        total_qty_demand_,
                                        total_qty_supply_,
                                        has_supply_past_due_,
                                        has_demand_past_due_,
                                        neg_proj_onhand_,
                                        neg_onhand_date_,
                                        neg_proj_onhand_no_supplies_,
                                        neg_onhand_no_supplies_date_ );


      END IF;
   END IF;

   IF (total_total_demand_ = 0) THEN
      Inventory_Part_In_Stock_API.Get_Inventory_Quantity(qty_onhand_         => qty_onhand_,
                                                         qty_reserved_       => qty_reserved_,
                                                         qty_in_transit_     => qty_in_transit_,
                                                         contract_           => contract_,
                                                         part_no_            => part_no_,
                                                         configuration_id_   => configuration_id_,
                                                         expiration_control_ => 'NOT EXPIRED',
                                                         supply_control_db_  => 'NETTABLE',
                                                         ownership_type1_db_ => Part_Ownership_API.DB_CONSIGNMENT,
                                                         ownership_type2_db_ => Part_Ownership_API.DB_COMPANY_OWNED,
                                                         include_standard_   => CASE project_id_ WHEN '*' THEN 'TRUE' ELSE 'FALSE' END,
                                                         include_project_    => CASE project_id_ WHEN '*' THEN 'FALSE' ELSE 'TRUE' END,
                                                         project_id_         => project_id_);

      IF (qty_onhand_ != 0 OR total_qty_supply_ !=0) THEN 
         New___( contract_,   part_no_,      configuration_id_, 'NO DEMAND',       project_id_,
                 qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_, total_qty_supply_, neg_onhand_date_ );
      END IF;
   END IF;


END Detect_Avail_Exceptions___;


-- Create_Exception_Messages___
--   This pocedure will create the Exception Messages.
PROCEDURE Create_Exception_Messages___ (
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   previous_project_id_          IN VARCHAR2,
   qty_onhand_                   IN NUMBER,
   qty_reserved_                 IN NUMBER,
   qty_in_transit_               IN NUMBER,
   total_qty_demand_             IN NUMBER,
   total_qty_supply_             IN NUMBER,
   has_supply_past_due_          IN BOOLEAN,
   has_demand_past_due_          IN BOOLEAN,
   neg_proj_onhand_              IN BOOLEAN,
   neg_onhand_date_              IN DATE,
   neg_proj_onhand_no_supplies_  IN BOOLEAN,
   neg_onhand_no_supplies_date_  IN DATE)
IS
   safety_stock_ NUMBER;
BEGIN

   safety_stock_ := Inventory_Part_Planning_API.Get_Safety_Stock (contract_, part_no_);

   IF (qty_onhand_ < safety_stock_) THEN
      New___( contract_,   part_no_,      configuration_id_, 'AVB<SAFETY STOCK', previous_project_id_,
              qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_,  total_qty_supply_,
              NULL );
   END IF;

   IF (total_qty_supply_ > 0 AND qty_onhand_ > (total_qty_demand_ + safety_stock_)) THEN
      New___( contract_,   part_no_,      configuration_id_, 'AVB COVERS',      previous_project_id_,
              qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_, total_qty_supply_,
              NULL );
   END IF;

   IF (total_qty_supply_ + qty_onhand_ > (total_qty_demand_ + safety_stock_)) THEN
      New___( contract_,   part_no_,      configuration_id_, 'EXCESS ORDERS',   previous_project_id_,
              qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_, total_qty_supply_,
              NULL );
   END IF;

   IF (total_qty_supply_ + qty_onhand_ < (total_qty_demand_ + safety_stock_)) THEN
      New___( contract_,   part_no_,      configuration_id_, 'NEED ORDERS',     previous_project_id_,
              qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_, total_qty_supply_,
              NULL );
   END IF;

   IF (has_supply_past_due_) THEN
      New___( contract_,   part_no_,      configuration_id_, 'SUPPLY PAST DUE', previous_project_id_,
              qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_, total_qty_supply_,
              NULL );
   END IF;

   IF (has_demand_past_due_) THEN
      New___( contract_,   part_no_,      configuration_id_, 'DEMAND PAST DUE', previous_project_id_,
              qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_, total_qty_supply_,
              NULL );
   END IF;

   IF (neg_proj_onhand_) THEN
      New___( contract_,   part_no_,      configuration_id_, 'NEG PROJ ONHAND', previous_project_id_,
              qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_, total_qty_supply_,
              neg_onhand_date_);
   END IF;
   IF (neg_proj_onhand_no_supplies_) THEN
      New___( contract_,   part_no_,      configuration_id_, 'USABLE QTY < DEMANDS', previous_project_id_,
              qty_onhand_, qty_reserved_, qty_in_transit_,   total_qty_demand_, total_qty_supply_,
              neg_onhand_no_supplies_date_);
   END IF;
END Create_Exception_Messages___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN

   super(attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INV_PART_AVAIL_EXCEPTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.confirmed := 'FALSE';
   newrec_.date_created := Site_API.Get_Site_Date(newrec_.contract);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INV_PART_AVAIL_EXCEPTION_TAB%ROWTYPE,
   newrec_     IN OUT INV_PART_AVAIL_EXCEPTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.confirmed != oldrec_.confirmed) THEN
      IF (newrec_.confirmed = 'TRUE') THEN
         newrec_.date_confirmed       := Site_API.Get_Site_Date(newrec_.contract);
         newrec_.confirmed_by_user_id := Fnd_Session_API.Get_Fnd_User;
      ELSE
         newrec_.date_confirmed       := NULL;
         newrec_.confirmed_by_user_id := NULL;
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     inv_part_avail_exception_tab%ROWTYPE,
   newrec_ IN OUT inv_part_avail_exception_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN

   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'CONFIRMED', newrec_.confirmed);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


PROCEDURE Remove_Old_Messages_Auto___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   project_id_       IN VARCHAR2 )
   
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

   Remove_Old_Messages___( contract_,
                           part_no_,
                           configuration_id_,
                           project_id_ );
   @ApproveTransactionStatement(2020-06-22,BudKlk)
   COMMIT;
END Remove_Old_Messages_Auto___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Confirm_Message__
--   This procedure will confirm the Generated Messages.
PROCEDURE Confirm_Message__ (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   exception_message_db_ IN VARCHAR2,
   project_id_           IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      INV_PART_AVAIL_EXCEPTION.objid%TYPE;
   objversion_ INV_PART_AVAIL_EXCEPTION.objversion%TYPE;
   oldrec_     INV_PART_AVAIL_EXCEPTION_TAB%ROWTYPE;
   newrec_     INV_PART_AVAIL_EXCEPTION_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___( contract_,
                               part_no_,
                               configuration_id_,
                               exception_message_db_,
                               project_id_ );
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('CONFIRMED_DB', 'TRUE', attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

END Confirm_Message__;


-- Generate_Exception_Messages__
--   This procedue will generate the Exception Messages.
PROCEDURE Generate_Exception_Messages__ (
   attr_ IN VARCHAR2 )
IS
   contract_            INV_PART_AVAIL_EXCEPTION_TAB.contract%TYPE;
   project_id_          INV_PART_AVAIL_EXCEPTION_TAB.project_id%TYPE;
   planner_buyer_       inventory_part_pub.planner_buyer%TYPE;
   second_commodity_    inventory_part_pub.second_commodity%TYPE;
   part_product_family_ inventory_part_pub.part_product_family%TYPE;
   part_product_code_   inventory_part_pub.part_product_code%TYPE;
   part_status_         inventory_part_pub.part_status%TYPE;
   planning_method_     inventory_part_planning_pub.planning_method%TYPE;
   
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);

   CURSOR     get_project_parts IS
      SELECT  part_no, configuration_id, project_id
        FROM  Inv_Part_Config_Project_Alt
       WHERE  planning_method LIKE planning_method_
         AND  planner_buyer LIKE planner_buyer_
         AND  part_status LIKE part_status_
         AND  (NVL(second_commodity,'%') LIKE second_commodity_)
         AND  (NVL(part_product_code,'%') LIKE part_product_code_)
         AND  (NVL(part_product_family,'%') LIKE part_product_family_)
         AND  ((project_id = project_id_ AND project_id_ != '#') OR (project_id != project_id_ AND project_id_ = '#'))
         AND  contract = contract_;

   CURSOR     get_avail_exception_parts IS
      SELECT  part_no, configuration_id, project_id
        FROM  Inv_Part_Avail_Exception_All
       WHERE  planning_method LIKE planning_method_
         AND  planner_buyer LIKE planner_buyer_
         AND  part_status LIKE part_status_
         AND  (NVL(second_commodity,'%') LIKE second_commodity_)
         AND  (NVL(part_product_code,'%') LIKE part_product_code_)
         AND  (NVL(part_product_family,'%') LIKE part_product_family_)
         AND  ((project_id = project_id_ AND project_id_ != '#') OR (project_id != project_id_ AND project_id_ = '#'))
         AND  contract = contract_;
   
   TYPE Part_Tab IS TABLE OF get_project_parts%ROWTYPE INDEX BY BINARY_INTEGER;
   part_tab_ Part_Tab;
   
   TYPE Avail_Exception_Part_Tab IS TABLE OF get_avail_exception_parts%ROWTYPE INDEX BY BINARY_INTEGER;
   avail_exception_part_tab_ Avail_Exception_Part_Tab;
BEGIN

   -- Unpack attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
     IF (name_ = 'CONTRACT') THEN
        contract_ := value_;
     ELSIF (name_ = 'PROJECT_ID') THEN
        project_id_ := value_;
     ELSIF (name_ = 'PLANNER_BUYER') THEN
        planner_buyer_ := value_;
     ELSIF (name_ = 'SECOND_COMMODITY') THEN
        second_commodity_:= value_;
     ELSIF (name_ = 'PART_PRODUCT_FAMILY') THEN
        part_product_family_ := value_;
     ELSIF (name_ = 'PART_PRODUCT_CODE') THEN
        part_product_code_ := value_;
     ELSIF (name_ = 'PART_STATUS') THEN
        part_status_ := value_;
     ELSIF (name_ = 'PLANNING_METHOD') THEN
        planning_method_ := value_;
     ELSE
        Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
     END IF;
   END LOOP;

   -- Store result from cursor in a PL/SQL table and loop over this table in order
   -- to avoid 'snapshot too old' related errors.

   IF (project_id_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'PROJECTNULL: The Project ID cannot be null.');

   ELSE      
      OPEN  get_avail_exception_parts;
      FETCH get_avail_exception_parts BULK COLLECT INTO avail_exception_part_tab_;
      CLOSE get_avail_exception_parts;
      IF (avail_exception_part_tab_.COUNT > 0) THEN
         FOR i IN avail_exception_part_tab_.FIRST .. avail_exception_part_tab_.LAST LOOP
         -- Remove old messages from the INV_PART_AVAIL_EXCEPTION  before generating the exception messages. 
         Remove_Old_Messages_Auto___( contract_,
                                     avail_exception_part_tab_(i).part_no,
                                     avail_exception_part_tab_(i).configuration_id,
                                     avail_exception_part_tab_(i).project_id );
                                 
         END LOOP;
      END IF;
      OPEN  get_project_parts;
      FETCH get_project_parts BULK COLLECT INTO part_tab_;
      CLOSE get_project_parts;
   END IF;

   IF (part_tab_.COUNT > 0) THEN
      FOR i IN part_tab_.FIRST .. part_tab_.LAST LOOP
         Detect_Avail_Exceptions___( contract_,
                                     part_tab_(i).part_no,
                                     part_tab_(i).configuration_id,
                                     part_tab_(i).project_id  );
      END LOOP;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOPARTS: No parts fulfill the selection criteria.');
   END IF;
END Generate_Exception_Messages__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Generate_Exception_Messages
--   This procedue will generate the Exception Messages.
PROCEDURE Generate_Exception_Messages (
   attr_ IN VARCHAR2 )
IS
  batch_desc_       VARCHAR2(100);
BEGIN

   IF (Transaction_SYS.Is_Session_Deferred()) THEN
      Generate_Exception_Messages__(attr_);
   ELSE
      batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'GENINVPARTAVAILEXCEP: Generate Inventory Part Availability Exceptions');
      Transaction_SYS.Deferred_Call('Inv_Part_Avail_Exception_API.Generate_Exception_Messages__', attr_, batch_desc_);
   END IF;
END Generate_Exception_Messages;


-- Validate_Params
--   Validates the parameters when running the Schedule for Generate
--   Inventory Part Availability Exceptions.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_      NUMBER;
   name_arr_   Message_SYS.name_table;
   value_arr_  Message_SYS.line_table;
   contract_   VARCHAR2(5);
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      END IF;
   END LOOP;

   IF (contract_ IS NOT NULL) THEN
      Site_API.Exist(contract_);
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

END Validate_Params;




