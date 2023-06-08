-----------------------------------------------------------------------------
--
--  Logical unit: InventValuePartDetail
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220105  MAJOSE  SC21R2-7014, Get rid of string manipulations in New() and Modify().
--  110719  MaEelk  Added user allowed site filter to INVENT_VALUE_PART_DETAIL_EXT and INVENT_VALUE_LOCGRP_DETAIL_EXT.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090902  SuSalk  Bug 85609, Description view column length increased to 200 in column comments of
--                  INVENT_VALUE_PART_DETAIL_EXT and INVENT_VALUE_LOCGRP_DETAIL_EXT views.
--  061110  LEPESE  Added method Get_Location_Group_Value__ and view INVENT_VALUE_LOCGRP_DETAIL_EXT.
--  061108  LEPESE  Added method Get_Total_Value__.
--  061024  LEPESE  Changed parent for this LU from InventoryValuePart to InventoryValue.
--  060727  RoJalk  Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  ------------------------- 13.4.0 ------------------------------------------
--  051122  LEPESE  Created view INVENT_VALUE_PART_DETAIL_EXT.
--  051117  LEPESE  Added method Remove.
--  051117  LEPESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Total_Value__ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   total_value_ NUMBER;

   CURSOR get_total_value IS
      SELECT SUM(total_value)
        FROM INVENT_VALUE_PART_DETAIL_TAB
       WHERE stat_year_no     = stat_year_no_
         AND stat_period_no   = stat_period_no_
         AND contract         = contract_
         AND part_no          = part_no_
         AND configuration_id = configuration_id_
         AND condition_code   = condition_code_
         AND lot_batch_no     = lot_batch_no_
         AND serial_no        = serial_no_;
BEGIN
   OPEN  get_total_value;
   FETCH get_total_value INTO total_value_;
   CLOSE get_total_value;

   RETURN(NVL(total_value_,0));
END Get_Total_Value__;


@UncheckedAccess
FUNCTION Get_Location_Group_Value__ (
   contract_                IN VARCHAR2,                          
   stat_year_no_            IN NUMBER,                        
   stat_period_no_          IN NUMBER,                      
   part_no_                 IN VARCHAR2,                           
   configuration_id_        IN VARCHAR2,                  
   lot_batch_no_            IN VARCHAR2,                      
   serial_no_               IN VARCHAR2,                         
   condition_code_          IN VARCHAR2,                    
   cost_source_id_          IN VARCHAR2,                    
   bucket_posting_group_id_ IN VARCHAR2,
   location_group_          IN VARCHAR2 ) RETURN NUMBER
IS
   total_value_              NUMBER;
   total_quantity_           NUMBER;
   location_group_value_     NUMBER;
   location_group_quantity_  NUMBER;
BEGIN
   total_value_ := Get_Total_Value(contract_,
                                   stat_year_no_,
                                   stat_period_no_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_,
                                   serial_no_,
                                   condition_code_,
                                   cost_source_id_,
                                   bucket_posting_group_id_);

   location_group_quantity_ := Inventory_Value_Part_API.Get_Total_Company_Owned_Qty__(
                                                                                 contract_,
                                                                                 stat_year_no_,
                                                                                 stat_period_no_,
                                                                                 part_no_,
                                                                                 configuration_id_,
                                                                                 lot_batch_no_,
                                                                                 serial_no_,
                                                                                 condition_code_,
                                                                                 location_group_);

   total_quantity_ := Inventory_Value_Part_API.Get_Total_Company_Owned_Qty__(contract_,
                                                                             stat_year_no_,
                                                                             stat_period_no_,
                                                                             part_no_,
                                                                             configuration_id_,
                                                                             lot_batch_no_,
                                                                             serial_no_,
                                                                             condition_code_,
                                                                             NULL);
   IF (total_quantity_ = 0) THEN
      total_quantity_ := 1;
   END IF;

   location_group_value_ := total_value_ * (location_group_quantity_ / total_quantity_);

   RETURN (NVL(location_group_value_,0));
END Get_Location_Group_Value__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates one specific new instance of this LU.
PROCEDURE New (
   contract_                IN VARCHAR2,
   stat_year_no_            IN NUMBER,
   stat_period_no_          IN NUMBER,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   condition_code_          IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   bucket_posting_group_id_ IN VARCHAR2,
   total_value_             IN NUMBER,
   create_date_             IN DATE )
IS
   newrec_      INVENT_VALUE_PART_DETAIL_TAB%ROWTYPE;
BEGIN
   newrec_.contract                 := contract_;
   newrec_.stat_year_no             := stat_year_no_;
   newrec_.stat_period_no           := stat_period_no_;
   newrec_.part_no                  := part_no_;
   newrec_.configuration_id         := configuration_id_;
   newrec_.lot_batch_no             := lot_batch_no_;
   newrec_.serial_no                := serial_no_;
   newrec_.condition_code           := condition_code_;
   newrec_.cost_source_id           := cost_source_id_;
   newrec_.bucket_posting_group_id  := bucket_posting_group_id_;
   newrec_.total_value              := total_value_;
   newrec_.create_date              := create_date_;

   New___(newrec_);
END New;


-- Modify_Total_Value
--   Modifies the total value attribute for one specific instance of this LU.
PROCEDURE Modify_Total_Value (
   contract_                IN VARCHAR2,
   stat_year_no_            IN NUMBER,
   stat_period_no_          IN NUMBER,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   condition_code_          IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   bucket_posting_group_id_ IN VARCHAR2,
   total_value_             IN NUMBER )
IS
   newrec_     INVENT_VALUE_PART_DETAIL_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(contract_,
                                    stat_year_no_,
                                    stat_period_no_,
                                    part_no_,
                                    configuration_id_,
                                    lot_batch_no_,
                                    serial_no_,
                                    condition_code_,
                                    cost_source_id_,
                                    bucket_posting_group_id_);

   newrec_.total_value := total_value_;

   Modify___(newrec_);
END Modify_Total_Value;


-- Remove
--   Deletes one specific instance of this LU.
PROCEDURE Remove (
   contract_                IN VARCHAR2,
   stat_year_no_            IN NUMBER,
   stat_period_no_          IN NUMBER,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   condition_code_          IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   bucket_posting_group_id_ IN VARCHAR2 )
IS
   remrec_     INVENT_VALUE_PART_DETAIL_TAB%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(contract_,
                              stat_year_no_,
                              stat_period_no_,
                              part_no_,
                              configuration_id_,
                              lot_batch_no_,
                              serial_no_,
                              condition_code_,
                              cost_source_id_,
                              bucket_posting_group_id_);

   Check_Delete___(remrec_);
   Delete___(NULL, remrec_);
END Remove;



