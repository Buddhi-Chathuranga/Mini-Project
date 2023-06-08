-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentTypeOptEvent
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210614  RoJalk  SC21R2-1031, Modified Check_Insert___  and added validations related to PACK_ACC_PACK_PROPOSAL, removed the method Raise_Combination_Error___.
--  170322  Chfose  LIM-10517, Renamed Shipment_Optional_Event_API.DB_PACK_INTO_HANDLING_UNIT to Shipment_Optional_Event_API.DB_PACK_ACC_TO_HU_CAPACITY.
--  170206  MaRalk  LIM-3836, Modified Raise_Combination_Error__ to replace the module 'ORDER' with 'SHPMNT'
--  170206          in the method call Basic_Data_Translation_API.Get_Basic_Data_Translation. 
--  161209  Jhalse  LIM-9188, Removed optional event for connecting handling units from inventory
--  160930	Jhalse  LIM-8594, Added new optional event for connecting handling units from inventory to shipment.
--  151014  MaRalk  LIM-3836, Moved to the module shpmnt from order module in order to support
--  151014          generic shipment functionality.
--  130726  MaMalk  Changed the reference to ShipmentTypeEvent to CASCADE.
--  130711  MaMalk  Modified Unpack_Check_Insert___  to exclude the error raised for printing the pro forma invoice when the shipment is completed
--  130711          and also changed the message text given by constant PRPROINVNOTALLOWED.
--  130531  JeLise  Change check on DB_GENERATE_STRUCTURE to check on both DB_PACK_ACC_TO_PACKING_INSTR and 
--  130531          DB_PACK_INTO_HANDLING_UNIT in Unpack_Check_Insert___. Also added check in Unpack_Check_Insert___ 
--  130531          to make sure that it is not possible to save both PACK_ACC_TO_PACKING_INSTR and PACK_INTO_HANDLING_UNIT 
--  130531          on the same event. Added method Raise_Combination_Error___ to handle the error method.
--  130212  RoJalk  Modified Unpack_Check_Insert___ and renamed the usage NORMAL_SHIPMENT_FIXED to BLOCK_AUTO_CONNECTION.
--  130212  RoJalk  Modified Unpack_Check_Insert___ added the error message SHIPFIXEDNOTALLOWED.
--  130111  RoJalk  Modified Unpack_Check_Insert___ and included a validation for NORMAL SHIPMENT FIXED event.
--  130111  RoJalk  Modified SHIPMENT_TYPE_OPT_EVENT and changed the view comments of optional_event to be a key instead of parent key.
--  121024  MAHPLK  Modified SHIPMENT_TYPE_OPT_EVENT by adding 'ORDER BY'.
--  120814  RoJalk  Modified error message text in Unpack_Check_Insert___.
--  120726  RoJalk  Modified validations in Unpack_Check_Insert___.
--  120724  RoJalk  Modified Unpack_Check_Insert___ and added a validation for Generate Structure optional event.
--  120713  RoJalk  Modified Prepare_Insert___ and added validations.
--  120704  RoJalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT shipment_type_opt_event_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_   VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF ((newrec_.optional_event = Shipment_Optional_Event_API.DB_PACK_ACC_PACK_PROPOSAL) AND (newrec_.event NOT IN (10, 20, 30))) THEN 
      Error_SYS.Record_General(lu_name_, 'PACKACPPNOTALLOWED: The :P1 optional event cannot be executed after reported picking.', Shipment_Optional_Event_API.Decode(newrec_.optional_event));
   END IF;
   
   IF ((newrec_.optional_event = Shipment_Optional_Event_API.DB_PRINT_PRO_FORMA_INVOICE) AND (newrec_.event IN (10, 20, 30, 40))) THEN
      Error_SYS.Record_General(lu_name_, 'PRPROINVNOTALLOWED: The :P1 optional event can only be executed after the shipment has been completed.', Shipment_Optional_Event_API.Decode(newrec_.optional_event));
   END IF;

   IF ((newrec_.optional_event = Shipment_Optional_Event_API.DB_CREATE_SSCC) AND (newrec_.event IN (80, 90, 100))) THEN 
      Error_SYS.Record_General(lu_name_, 'SSSCNOTALLOWED: The :P1 optional event cannot be executed after the shipment has been closed.', Shipment_Optional_Event_API.Decode(newrec_.optional_event));
   END IF;

   IF ((newrec_.event NOT IN (10, 20, 30, 40)) AND (
        (newrec_.optional_event = Shipment_Optional_Event_API.DB_PACK_ACC_TO_PACKING_INSTR) OR 
        (newrec_.optional_event = Shipment_Optional_Event_API.DB_PACK_ACC_TO_HU_CAPACITY)   OR
        (newrec_.optional_event = Shipment_Optional_Event_API.DB_DISCONNECT_EMPTY_HUS))) THEN
      Error_SYS.Record_General(lu_name_, 'GENSTRUCTNOTALLOWED: The :P1 optional event cannot be executed after the shipment has been completed.', Shipment_Optional_Event_API.Decode(newrec_.optional_event));
   END IF;

   IF ((newrec_.optional_event = Shipment_Optional_Event_API.DB_BLOCK_AUTO_CONNECTION OR newrec_.optional_event = Shipment_Optional_Event_API.DB_CREATE_SSCC) AND 
      (newrec_.event NOT IN (10, 20, 30, 40, 50))) THEN
      Error_SYS.Record_General(lu_name_, 'SHIPFIXEDNOTALLOWED: The :P1 optional event cannot be executed after the shipment has been Delivered.', Shipment_Optional_Event_API.Decode(newrec_.optional_event));
   END IF;
   
   IF ((newrec_.optional_event = Shipment_Optional_Event_API.DB_RELEASE_QTY_NOT_RESERVED) AND (newrec_.event NOT IN (10, 20, 30, 40))) THEN
      Error_SYS.Record_General(lu_name_, 'RELEASEQTYNOTALLOWED: The :P1 optional event cannot be executed after the shipment has been Completed.', Shipment_Optional_Event_API.Decode(newrec_.optional_event));
   END IF;
   
   IF (newrec_.optional_event IN (Shipment_Optional_Event_API.DB_PACK_ACC_TO_PACKING_INSTR,
                                  Shipment_Optional_Event_API.DB_PACK_ACC_TO_HU_CAPACITY,
                                  Shipment_Optional_Event_API.DB_PACK_ACC_PACK_PROPOSAL)) THEN                             
      IF (((Check_Exist___(newrec_.shipment_type,
                           newrec_.event,
                           Shipment_Optional_Event_API.DB_PACK_ACC_TO_PACKING_INSTR)) AND (newrec_.optional_event != Shipment_Optional_Event_API.DB_PACK_ACC_TO_PACKING_INSTR)) OR                   
          ((Check_Exist___(newrec_.shipment_type,
                           newrec_.event,
                           Shipment_Optional_Event_API.DB_PACK_ACC_TO_HU_CAPACITY)) AND (newrec_.optional_event != Shipment_Optional_Event_API.DB_PACK_ACC_TO_HU_CAPACITY)) OR                            
          ((Check_Exist___(newrec_.shipment_type,
                           newrec_.event,
                           Shipment_Optional_Event_API.DB_PACK_ACC_PACK_PROPOSAL)) AND (newrec_.optional_event != Shipment_Optional_Event_API.DB_PACK_ACC_PACK_PROPOSAL))) THEN                  
                         
         Error_SYS.Record_General(lu_name_, 'OPTEVENTCOMBNOTALLOWED: Only one of the optional events :P1, :P2 and :P3 can be used for the event.', 
                                             Shipment_Optional_Event_API.Decode(Shipment_Optional_Event_API.DB_PACK_ACC_TO_PACKING_INSTR), 
                                             Shipment_Optional_Event_API.Decode(Shipment_Optional_Event_API.DB_PACK_ACC_TO_HU_CAPACITY),
                                             Shipment_Optional_Event_API.Decode(Shipment_Optional_Event_API.DB_PACK_ACC_PACK_PROPOSAL));   
                                             
      END IF;
   END IF;
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


