-----------------------------------------------------------------------------
--
--  Logical unit: FreightPriceListZone
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130121  RavDlk   SC2020R1-12047,Removed unnecessary packing and unpacking of attrubute string in Copy_All_Zone_Info__
--  111116  ChJalk   Modified the view FREIGHT_PRICE_LIST_ZONE to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111025  ChJalk   Modified the view FREIGHT_PRICE_LIST_ZONE to use the user allowed company filter.
--  110907  MaMalk   Modified the text for message constant AMOUNTSREQUIRED.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  091009  UtSwlk   Added procedure Copy_All_Zone_Info__.
--  090403  MaHplk   Modified column name full_truck_price  to fix_deliv_freight.
--  090324  MaHplk   Modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  090316  MaHplk   Added Full Truck Price to LU.
--  090108  ShKolk   Modified the validations of min_freight_amount and freight_free_amount.
--  090102  ShKolk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     freight_price_list_zone_tab%ROWTYPE,
   newrec_ IN OUT freight_price_list_zone_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   IF (NVL(newrec_.min_freight_amount,0) = 0 AND 
       NVL(newrec_.freight_free_amount,0) = 0 AND
       NVL(newrec_.fix_deliv_freight,0) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'AMOUNTSREQUIRED: Either Minimum Freight Amount or Freight Free Amount should have a value.');
   END IF;
   IF (newrec_.min_freight_amount < 0 OR newrec_.freight_free_amount < 0) THEN
      Error_SYS.Record_General(lu_name_, 'FREIGHTAMTNEG: Amount should not be a negative value.');
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_All_Zone_Info__
--   Copies all Zone Info records from one freight price list to another.
--   Copies all Zone Info records from one freight price list to another.
PROCEDURE Copy_All_Zone_Info__ (
   price_list_no_    IN VARCHAR2,
   to_price_list_no_ IN VARCHAR2 )
IS
   newrec_       FREIGHT_PRICE_LIST_ZONE_TAB%ROWTYPE;

   CURSOR    source IS
      SELECT *
      FROM   freight_price_list_zone_tab
      WHERE  price_list_no = price_list_no_;
BEGIN
   
   -- Copy all lines
   FOR source_rec_ IN source LOOP
      IF NOT(Check_Exist___(to_price_list_no_, source_rec_.freight_map_id, source_rec_.zone_id )) THEN
         -- Copy the line
         newrec_.price_list_no := to_price_list_no_;
         newrec_.freight_map_id := source_rec_.freight_map_id;
         newrec_.zone_id := source_rec_.zone_id;
         newrec_.min_freight_amount := source_rec_.min_freight_amount;
         newrec_.freight_free_amount := source_rec_.freight_free_amount;
         newrec_.fix_deliv_freight := source_rec_.fix_deliv_freight;
         New___(newrec_);
      END IF;
   END LOOP;
END Copy_All_Zone_Info__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


