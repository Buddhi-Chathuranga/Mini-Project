-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartInStock
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220615  SEBSA-SUPULI   MAN_W12-Fiber_Color_Batch_Tracking-1;Overtake Receive_Part_Impl___
--  220615  SEBSA-SUPULI   MAN_W12-Fiber_Color_Batch_Tracking-1;Created
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
--(+)220615  SEBSA-SUPULI   MAN_W12-1(Start)
-- Insert Aspect Lot No when creating a new Inventory Part In stock record while reciving the part
@Overtake Core
PROCEDURE Receive_Part_Impl___ (
   transaction_id_               IN OUT NUMBER,
   accounting_id_                IN OUT NUMBER,
   trans_value_                  IN OUT NUMBER,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   location_no_                  IN     VARCHAR2,
   lot_batch_no_                 IN     VARCHAR2,
   serial_no_                    IN     VARCHAR2,
   eng_chg_level_                IN     VARCHAR2,
   waiv_dev_rej_no_              IN     VARCHAR2,
   activity_seq_                 IN     NUMBER,
   handling_unit_id_             IN     NUMBER,
   transaction_                  IN     VARCHAR2,
   expiration_date_              IN     DATE,
   quantity_                     IN     NUMBER,
   quantity_reserved_            IN     NUMBER,
   catch_quantity_               IN     NUMBER,
   source_ref1_                  IN     VARCHAR2,
   source_ref2_                  IN     VARCHAR2,
   source_ref3_                  IN     VARCHAR2,
   source_ref4_                  IN     VARCHAR2,
   source_ref5_                  IN     VARCHAR2,
   source_                       IN     VARCHAR2,
   unissue_                      IN     BOOLEAN,
   unit_cost_                    IN     NUMBER,
   source_ref_type_              IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   receipt_date_                 IN     DATE,
   condition_code_               IN     VARCHAR2,
   part_ownership_               IN     VARCHAR2,
   owning_customer_no_           IN     VARCHAR2,
   cost_detail_tab_              IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   set_qty_reversed_             IN     BOOLEAN,
   issue_transaction_id_         IN     NUMBER,   
   operational_condition_db_     IN     VARCHAR2,
   part_catalog_rec_             IN     Part_Catalog_API.Public_Rec,
   availability_control_id_      IN     VARCHAR2,
   validate_hu_struct_position_  IN     BOOLEAN,
   ownership_transfer_reason_id_ IN     VARCHAR2,
   delivery_reason_id_           IN     VARCHAR2  DEFAULT NULL,
   del_note_no_                  IN     VARCHAR2  DEFAULT NULL,
   del_note_date_                IN     DATE      DEFAULT NULL)
IS
   $SEARCH
   last_calendar_date_            DATE    := Database_SYS.last_calendar_date_;
   $APPEND
   --(+)220615  SEBSA-SUPULI   MAN_W12-1(Start)
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
   c_aspect_lot_no_               shop_ord_tab.c_aspect_lot_no%TYPE;
   $END
   --(+)220615  SEBSA-SUPULI   MAN_W12-1(Finish)
   $END
BEGIN
      $PREPEND
      --(+)220615  SEBSA-SUPULI   MAN_W12-1(Start)
      $IF (Component_Shpord_SYS.INSTALLED) $THEN
      c_aspect_lot_no_ :=   Shop_Ord_API.Get_C_Aspect_Lot_No(source_ref1_, source_ref2_, source_ref3_);
      $END
      newrec_.c_aspect_lot_no := c_aspect_lot_no_;
      --(+)220615  SEBSA-SUPULI   MAN_W12-1(Finish)
      $SEARCH
      Check_And_Insert_By_Keys___(newrec_                       => newrec_,
                                  part_catalog_rec_             => local_part_catalog_rec_,
                                  set_default_avail_control_id_ => NOT receipt_for_rental_asset_trf_,
                                  validate_hu_struct_position_  => validate_hu_struct_position_);
      $END   
END Receive_Part_Impl___;
--(+)220615  SEBSA-SUPULI   MAN_W12-1(Finish)


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
