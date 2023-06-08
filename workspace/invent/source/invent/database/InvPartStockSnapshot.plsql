-----------------------------------------------------------------------------
--
--  Logical unit: InvPartStockSnapshot
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  161115  RALASE  LIM-9449, Changed Get_Configuration_Id, Get_Part_No, Get_Lot_Batch_No, Get_Serial_No, Get_Eng_Chg_Level and Get_Waiv_Dev_Rej_No
--                            to return a mixed value when there exists more than one kind.                               
--  161019  Chfose  LIM-9213, Reworked how the 'compiled view'-methods fetches its data in order to greatly improve the performance.
--  160819  Maeelk  LIM-8414, Changed the return type of Get_Activity_Seq from VARCHAR2 to NUMBER;
--  160809  Chfose  LIM-7338, Added new get-methods for Part_Ownership, Owner, Owner_Name, Availability Control ID & Condition_Code.
--  160517  Chfose  STRSC-2349, Added UncheckedAccess to Get_Lot_Batch_No.
--  160511  JeLise  LIM-7338, Added new methods Get_Part_No, Get_Configuration_Id, Get_Lot_Batch_No, Get_Serial_No, 
--  160511          Get_Eng_Chg_Level, Get_Waiv_Dev_Rej_No, Get_Activity_Seq and Get_Quantity.
--  160307  Chfose  LIM-6169, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


TYPE Inv_Part_Stock_Rec IS RECORD (
   contract             inventory_part_in_stock_tab.contract%TYPE,
   part_no              inventory_part_in_stock_tab.part_no%TYPE,
   configuration_id     inventory_part_in_stock_tab.configuration_id%TYPE,
   location_no          inventory_part_in_stock_tab.location_no%TYPE,
   lot_batch_no         inventory_part_in_stock_tab.lot_batch_no%TYPE,
   serial_no            inventory_part_in_stock_tab.serial_no%TYPE,
   eng_chg_level        inventory_part_in_stock_tab.eng_chg_level%TYPE,
   waiv_dev_rej_no      inventory_part_in_stock_tab.waiv_dev_rej_no%TYPE,
   activity_seq         inventory_part_in_stock_tab.activity_seq%TYPE,
   handling_unit_id     inventory_part_in_stock_tab.handling_unit_id%TYPE,
   quantity             inventory_part_in_stock_tab.qty_onhand%TYPE);
   
TYPE Inv_Part_Stock_Tab IS TABLE OF Inv_Part_Stock_Rec INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_ CONSTANT VARCHAR2(11) := Database_SYS.string_null_;
mixed_value_ CONSTANT VARCHAR2(3)  := '...';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


PROCEDURE Insert_Snapshot___ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   inv_part_stock_tab_  IN Inv_Part_Stock_Tab )
IS
BEGIN
   Handl_Unit_Snapshot_Type_API.Exist_Db(source_ref_type_db_);
   
   IF (inv_part_stock_tab_.COUNT > 0) THEN
      FORALL i IN inv_part_stock_tab_.FIRST .. inv_part_stock_tab_.LAST
         INSERT INTO inv_part_stock_snapshot_tab
            (source_ref1,
             source_ref2,
             source_ref3,
             source_ref4,
             source_ref5,
             source_ref_type,
             contract,
             part_no,
             configuration_id,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             activity_seq,
             handling_unit_id,
             quantity,
             rowversion,
             rowkey)
         VALUES
            (source_ref1_,
             source_ref2_,
             source_ref3_,
             source_ref4_,
             source_ref5_,
             source_ref_type_db_,
             inv_part_stock_tab_(i).contract,
             inv_part_stock_tab_(i).part_no,
             inv_part_stock_tab_(i).configuration_id,
             inv_part_stock_tab_(i).location_no,
             inv_part_stock_tab_(i).lot_batch_no,
             inv_part_stock_tab_(i).serial_no,
             inv_part_stock_tab_(i).eng_chg_level,
             inv_part_stock_tab_(i).waiv_dev_rej_no,
             inv_part_stock_tab_(i).activity_seq,
             inv_part_stock_tab_(i).handling_unit_id,
             inv_part_stock_tab_(i).quantity,
             sysdate,
             sys_guid());
   END IF;
END Insert_Snapshot___;


PROCEDURE Delete_Snapshot___ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2)
IS
BEGIN       
   DELETE FROM inv_part_stock_snapshot_tab
         WHERE source_ref1       = source_ref1_
           AND source_ref2       = source_ref2_
           AND source_ref3       = source_ref3_
           AND source_ref4       = source_ref4_
           AND source_ref5       = source_ref5_
           AND source_ref_type   = source_ref_type_db_;
END Delete_Snapshot___;


FUNCTION Get_Inv_Part_Stock___ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN Inv_Part_Stock_Tab
IS
   CURSOR get_inv_part_stock IS
      SELECT contract, part_no, configuration_id, location_no, lot_batch_no,
             serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, 
             handling_unit_id, quantity
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_;
      
   inv_part_stock_tab_ Inv_Part_Stock_Tab;
BEGIN
   OPEN get_inv_part_stock;
   FETCH get_inv_part_stock BULK COLLECT INTO inv_part_stock_tab_;
   CLOSE get_inv_part_stock;
   
   RETURN inv_part_stock_tab_;
END Get_Inv_Part_Stock___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Insert_Snapshot (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   inv_part_stock_tab_  IN Inv_Part_Stock_Tab)
IS
BEGIN
   Delete_Snapshot___(source_ref1_,
                      source_ref2_,
                      source_ref3_,
                      source_ref4_,
                      source_ref5_,
                      source_ref_type_db_);
             
   Insert_Snapshot___(source_ref1_,
                      source_ref2_,
                      source_ref3_,
                      source_ref4_,
                      source_ref5_,
                      source_ref_type_db_,
                      inv_part_stock_tab_);
END Insert_Snapshot;


PROCEDURE Delete_Snapshot (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS
BEGIN
   Delete_Snapshot___(source_ref1_,
                      source_ref2_,
                      source_ref3_,
                      source_ref4_,
                      source_ref5_,
                      source_ref_type_db_);
END Delete_Snapshot;


PROCEDURE Delete_Old_Snapshots (
   source_ref_type_db_  IN VARCHAR2,
   amount_of_days_      IN NUMBER )
IS
BEGIN
   DELETE FROM inv_part_stock_snapshot_tab
      WHERE source_ref_type   = source_ref_type_db_
        AND rowversion < sysdate - amount_of_days_;
END Delete_Old_Snapshots;


@UncheckedAccess
FUNCTION Get_Part_No (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_part_no IS
      SELECT DISTINCT part_no
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_;
      
   TYPE Part_No_Tab IS TABLE OF get_part_no%ROWTYPE INDEX BY PLS_INTEGER;
   part_no_tab_      Part_No_Tab;
   result_           VARCHAR2(25);
BEGIN
   OPEN get_part_no;
   FETCH get_part_no BULK COLLECT INTO part_no_tab_;
   CLOSE get_part_no;
   
   IF (part_no_tab_.COUNT = 1) THEN
      result_ := part_no_tab_(1).part_no;
   ELSIF (part_no_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Part_No;


@UncheckedAccess
FUNCTION Get_Configuration_Id (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_configuration_id IS
      SELECT DISTINCT configuration_id
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_;
      
   TYPE Configuration_Id_Tab IS TABLE OF get_configuration_id%ROWTYPE INDEX BY PLS_INTEGER;
   configuration_id_tab_      Configuration_Id_Tab;
   result_                    VARCHAR2(50);
BEGIN
   OPEN get_configuration_id;
   FETCH get_configuration_id BULK COLLECT INTO configuration_id_tab_;
   CLOSE get_configuration_id;
   
   IF (configuration_id_tab_.COUNT = 1) THEN
      result_ := configuration_id_tab_(1).configuration_id;
   ELSIF (configuration_id_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Configuration_Id;


@UncheckedAccess
FUNCTION Get_Lot_Batch_No (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_lot_batch_no IS
      SELECT DISTINCT lot_batch_no
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_;
      
   TYPE Lot_Batch_No_Tab IS TABLE OF get_lot_batch_no%ROWTYPE INDEX BY PLS_INTEGER;
   lot_batch_no_tab_      Lot_Batch_No_Tab;
   result_                VARCHAR2(20);
BEGIN
   OPEN get_lot_batch_no;
   FETCH get_lot_batch_no BULK COLLECT INTO lot_batch_no_tab_;
   CLOSE get_lot_batch_no;
   
   IF (lot_batch_no_tab_.COUNT = 1) THEN
      result_ := lot_batch_no_tab_(1).lot_batch_no;
   ELSIF (lot_batch_no_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Lot_Batch_No;


@UncheckedAccess
FUNCTION Get_Serial_No (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_serial_no IS
      SELECT DISTINCT serial_no
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_;
      
   TYPE Serial_No_Tab IS TABLE OF get_serial_no%ROWTYPE INDEX BY PLS_INTEGER;
   serial_no_tab_      Serial_No_Tab;
   result_             VARCHAR2(50);
BEGIN
   OPEN get_serial_no;
   FETCH get_serial_no BULK COLLECT INTO serial_no_tab_;
   CLOSE get_serial_no;
   
   IF (serial_no_tab_.COUNT = 1) THEN
      result_ := serial_no_tab_(1).serial_no;
   ELSIF (serial_no_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Serial_No;


@UncheckedAccess
FUNCTION Get_Eng_Chg_Level (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_eng_chg_level IS
      SELECT DISTINCT eng_chg_level
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_;
      
   TYPE Eng_Chg_Level_Tab IS TABLE OF get_eng_chg_level%ROWTYPE INDEX BY PLS_INTEGER;
   eng_chg_level_tab_      Eng_Chg_Level_Tab;
   result_                 VARCHAR2(6);
BEGIN
   OPEN get_eng_chg_level;
   FETCH get_eng_chg_level BULK COLLECT INTO eng_chg_level_tab_;
   CLOSE get_eng_chg_level;
   
   IF (eng_chg_level_tab_.COUNT = 1) THEN
      result_ := eng_chg_level_tab_(1).eng_chg_level;
   ELSIF (eng_chg_level_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Eng_Chg_Level;


@UncheckedAccess
FUNCTION Get_Waiv_Dev_Rej_No (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   
   CURSOR get_waiv_dev_rej_no IS
      SELECT DISTINCT waiv_dev_rej_no
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_;
      
   TYPE Waiv_Dev_Rej_No_Tab IS TABLE OF get_waiv_dev_rej_no%ROWTYPE INDEX BY PLS_INTEGER;
   waiv_dev_rej_no_tab_      Waiv_Dev_Rej_No_Tab;
   result_                   VARCHAR2(15);
BEGIN
   OPEN get_waiv_dev_rej_no;
   FETCH get_waiv_dev_rej_no BULK COLLECT INTO waiv_dev_rej_no_tab_;
   CLOSE get_waiv_dev_rej_no;
   
   IF (waiv_dev_rej_no_tab_.COUNT = 1) THEN
      result_ := waiv_dev_rej_no_tab_(1).waiv_dev_rej_no;
   ELSIF (waiv_dev_rej_no_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Waiv_Dev_Rej_No;


@UncheckedAccess
FUNCTION Get_Activity_Seq (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_activity_seq IS
      SELECT DISTINCT activity_seq
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_;
      
   TYPE Activity_Seq_Tab IS TABLE OF get_activity_seq%ROWTYPE INDEX BY PLS_INTEGER;
   activity_seq_tab_      Activity_Seq_Tab;
   result_                NUMBER;
BEGIN
   OPEN get_activity_seq;
   FETCH get_activity_seq BULK COLLECT INTO activity_seq_tab_;
   CLOSE get_activity_seq;
   
   IF (activity_seq_tab_.COUNT = 1) THEN
      result_ := activity_seq_tab_(1).activity_seq;
   END IF;
   
   RETURN result_;
END Get_Activity_Seq;


@UncheckedAccess
FUNCTION Get_Quantity (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN NUMBER 
IS
   CURSOR get_quantity IS
      SELECT SUM(quantity) quantity
      FROM inv_part_stock_snapshot_tab
      WHERE source_ref1     = source_ref1_
      AND   source_ref2     = source_ref2_
      AND   source_ref3     = source_ref3_
      AND   source_ref4     = source_ref4_
      AND   source_ref5     = source_ref5_
      AND   source_ref_type = source_ref_type_db_
      AND   location_no     = location_no_
      GROUP BY part_no;
      
   TYPE Quantity_Tab IS TABLE OF get_quantity%ROWTYPE INDEX BY PLS_INTEGER;
   quantity_tab_ Quantity_Tab;
   result_       NUMBER;
BEGIN
   OPEN get_quantity;
   FETCH get_quantity BULK COLLECT INTO quantity_tab_;
   CLOSE get_quantity;
   
   IF (quantity_tab_.COUNT = 1) THEN
      result_ := quantity_tab_(1).quantity;
   END IF;
   
   RETURN result_;
END Get_Quantity;


@UncheckedAccess
FUNCTION Get_Part_Ownership (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_part_ownership IS
      SELECT DISTINCT part_ownership
        FROM inv_part_stock_snapshot_ext
       WHERE source_ref1         = source_ref1_
         AND source_ref2         = source_ref2_
         AND source_ref3         = source_ref3_
         AND source_ref4         = source_ref4_
         AND source_ref5         = source_ref5_
         AND source_ref_type_db  = source_ref_type_db_
         AND location_no         = location_no_;

   TYPE Part_Ownership_Tab IS TABLE OF get_part_ownership%ROWTYPE INDEX BY PLS_INTEGER;
   part_ownership_tab_  Part_Ownership_Tab;
   result_              VARCHAR2(20);
BEGIN
   OPEN get_part_ownership;
   FETCH get_part_ownership BULK COLLECT INTO part_ownership_tab_;
   CLOSE get_part_ownership;
   
   IF (part_ownership_tab_.COUNT = 1) THEN
      result_ := part_ownership_tab_(1).part_ownership;
   ELSIF (part_ownership_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Part_Ownership;


@UncheckedAccess
FUNCTION Get_Owner (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_owner IS
      SELECT DISTINCT owning_customer_no, owning_vendor_no
        FROM inv_part_stock_snapshot_ext
       WHERE source_ref1         = source_ref1_
         AND source_ref2         = source_ref2_
         AND source_ref3         = source_ref3_
         AND source_ref4         = source_ref4_
         AND source_ref5         = source_ref5_
         AND source_ref_type_db  = source_ref_type_db_
         AND location_no         = location_no_;

   TYPE Owner_Tab IS TABLE OF get_owner%ROWTYPE INDEX BY PLS_INTEGER;
   owner_tab_     Owner_Tab;
   result_        VARCHAR2(20);
BEGIN
   OPEN get_owner;
   FETCH get_owner BULK COLLECT INTO owner_tab_;
   CLOSE get_owner;
   
   IF (owner_tab_.COUNT = 1) THEN
      result_ := NVL(owner_tab_(1).owning_customer_no, owner_tab_(1).owning_vendor_no);
   ELSIF (owner_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Owner;


@UncheckedAccess
FUNCTION Get_Owner_Name (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_owner IS
      SELECT DISTINCT owning_customer_no, owning_vendor_no
        FROM inv_part_stock_snapshot_ext
       WHERE source_ref1         = source_ref1_
         AND source_ref2         = source_ref2_
         AND source_ref3         = source_ref3_
         AND source_ref4         = source_ref4_
         AND source_ref5         = source_ref5_
         AND source_ref_type_db  = source_ref_type_db_
         AND location_no         = location_no_;

   TYPE Owner_Tab IS TABLE OF get_owner%ROWTYPE INDEX BY PLS_INTEGER;
   owner_tab_     Owner_Tab;
   result_        VARCHAR2(200);
BEGIN
   OPEN get_owner;
   FETCH get_owner BULK COLLECT INTO owner_tab_;
   CLOSE get_owner;
   
   IF (owner_tab_.COUNT = 1) THEN
      IF (owner_tab_(1).owning_customer_no IS NOT NULL) THEN
         $IF Component_Order_SYS.INSTALLED $THEN      
            result_ := Cust_Ord_Customer_API.Get_Name(owner_tab_(1).owning_customer_no);
         $ELSIF Component_Purch_SYS.INSTALLED $THEN
            IF (owner_tab_(1).owning_vendor_no IS NOT NULL) THEN
               result_ := Supplier_API.Get_Vendor_Name(owner_tab_(1).owning_vendor_no);
            END IF;  
         $ELSE
            NULL;
         $END
      ELSIF (owner_tab_(1).owning_vendor_no IS NOT NULL) THEN
         $IF Component_Purch_SYS.INSTALLED $THEN      
            result_ := Supplier_API.Get_Vendor_Name(owner_tab_(1).owning_vendor_no);
         $ELSE
            NULL;
         $END
      END IF; 
   ELSIF (owner_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Owner_Name;


@UncheckedAccess
FUNCTION Get_Availability_Control_Id (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_avail_control_id IS
      SELECT DISTINCT availability_control_id
        FROM inv_part_stock_snapshot_ext
       WHERE source_ref1         = source_ref1_
         AND source_ref2         = source_ref2_
         AND source_ref3         = source_ref3_
         AND source_ref4         = source_ref4_
         AND source_ref5         = source_ref5_
         AND source_ref_type_db  = source_ref_type_db_
         AND location_no         = location_no_;

   TYPE Avail_Control_Id_Tab IS TABLE OF get_avail_control_id%ROWTYPE INDEX BY PLS_INTEGER;
   avail_control_id_tab_   Avail_Control_Id_Tab;
   result_                 VARCHAR2(25);
BEGIN
   OPEN get_avail_control_id;
   FETCH get_avail_control_id BULK COLLECT INTO avail_control_id_tab_;
   CLOSE get_avail_control_id;
   
   IF (avail_control_id_tab_.COUNT = 1) THEN
      result_ := avail_control_id_tab_(1).availability_control_id;
   ELSIF (avail_control_id_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Availability_Control_Id;


@UncheckedAccess
FUNCTION Get_Condition_Code (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_condition_code IS
      SELECT DISTINCT condition_code
        FROM inv_part_stock_snapshot_ext
       WHERE source_ref1         = source_ref1_
         AND source_ref2         = source_ref2_
         AND source_ref3         = source_ref3_
         AND source_ref4         = source_ref4_
         AND source_ref5         = source_ref5_
         AND source_ref_type_db  = source_ref_type_db_
         AND location_no         = location_no_;

   TYPE Condition_Code_Tab IS TABLE OF get_condition_code%ROWTYPE INDEX BY PLS_INTEGER;
   condition_code_tab_  Condition_Code_Tab;
   result_              VARCHAR2(20);
BEGIN
   OPEN get_condition_code;
   FETCH get_condition_code BULK COLLECT INTO condition_code_tab_;
   CLOSE get_condition_code;
   
   IF (condition_code_tab_.COUNT = 1) THEN
      result_ := condition_code_tab_(1).condition_code;
   ELSIF (condition_code_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Condition_Code;


@UncheckedAccess
FUNCTION Get_Project_Id (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_project_id IS
      SELECT DISTINCT project_id
        FROM inv_part_stock_snapshot_ext
       WHERE source_ref1         = source_ref1_
         AND source_ref2         = source_ref2_
         AND source_ref3         = source_ref3_
         AND source_ref4         = source_ref4_
         AND source_ref5         = source_ref5_
         AND source_ref_type_db  = source_ref_type_db_
         AND location_no         = location_no_;
       
   TYPE Project_Id_Tab IS TABLE OF get_project_id%ROWTYPE INDEX BY PLS_INTEGER;
   project_id_tab_   Project_Id_Tab;
   result_           VARCHAR2(10);
BEGIN
   OPEN get_project_id;
   FETCH get_project_id BULK COLLECT INTO project_id_tab_;
   CLOSE get_project_id;
   
   IF (project_id_tab_.COUNT = 1) THEN
      result_ := project_id_tab_(1).project_id;
   ELSIF (project_id_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Project_Id;


@UncheckedAccess
FUNCTION Get_Program_Id (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   $IF Component_Proj_SYS.INSTALLED $THEN
      CURSOR get_program_id IS
         SELECT DISTINCT Activity_API.Get_Program_Id(activity_seq) program_id
           FROM inv_part_stock_snapshot_ext
          WHERE source_ref1         = source_ref1_
            AND source_ref2         = source_ref2_
            AND source_ref3         = source_ref3_
            AND source_ref4         = source_ref4_
            AND source_ref5         = source_ref5_
            AND source_ref_type_db  = source_ref_type_db_
            AND location_no         = location_no_;

      TYPE Program_Id_Tab IS TABLE OF get_program_id%ROWTYPE INDEX BY PLS_INTEGER;
      program_id_tab_   Program_Id_Tab;
   $END
   result_           VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      OPEN get_program_id;
      FETCH get_program_id BULK COLLECT INTO program_id_tab_;
      CLOSE get_program_id;

      IF (program_id_tab_.COUNT = 1) THEN
         result_ := program_id_tab_(1).program_id;
      ELSIF (program_id_tab_.COUNT > 1) THEN
         result_ := mixed_value_;
      END IF;
   $END   
   RETURN result_;
END Get_Program_Id;


@UncheckedAccess
FUNCTION Get_Activity_No (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   $IF Component_Proj_SYS.INSTALLED $THEN
      CURSOR get_activity_no IS
         SELECT DISTINCT Activity_API.Get_Activity_No(activity_seq) activity_no
           FROM inv_part_stock_snapshot_ext
          WHERE source_ref1         = source_ref1_
            AND source_ref2         = source_ref2_
            AND source_ref3         = source_ref3_
            AND source_ref4         = source_ref4_
            AND source_ref5         = source_ref5_
            AND source_ref_type_db  = source_ref_type_db_
            AND location_no         = location_no_;

      TYPE Activity_No_Tab IS TABLE OF get_activity_no%ROWTYPE INDEX BY PLS_INTEGER;
      activity_no_tab_  Activity_No_Tab;
   $END
   result_           VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      OPEN get_activity_no;
      FETCH get_activity_no BULK COLLECT INTO activity_no_tab_;
      CLOSE get_activity_no;

      IF (activity_no_tab_.COUNT = 1) THEN
         result_ := activity_no_tab_(1).activity_no;
      ELSIF (activity_no_tab_.COUNT > 1) THEN
         result_ := mixed_value_;
      END IF;
   $END
   RETURN result_;
END Get_Activity_No;


@UncheckedAccess
FUNCTION Get_Sub_Project_Id (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   location_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   $IF Component_Proj_SYS.INSTALLED $THEN
      CURSOR get_sub_project_id IS
         SELECT DISTINCT Activity_API.Get_Sub_Project_Id(activity_seq) sub_project_id
           FROM inv_part_stock_snapshot_ext
          WHERE source_ref1         = source_ref1_
            AND source_ref2         = source_ref2_
            AND source_ref3         = source_ref3_
            AND source_ref4         = source_ref4_
            AND source_ref5         = source_ref5_
            AND source_ref_type_db  = source_ref_type_db_
            AND location_no         = location_no_;

     TYPE Sub_Project_Id_Tab IS TABLE OF get_sub_project_id%ROWTYPE INDEX BY PLS_INTEGER;
     sub_project_id_tab_   Sub_Project_Id_Tab;
  $END
  result_               VARCHAR2(10);
BEGIN
  $IF Component_Proj_SYS.INSTALLED $THEN
      OPEN get_sub_project_id;
      FETCH get_sub_project_id BULK COLLECT INTO sub_project_id_tab_;
      CLOSE get_sub_project_id;

      IF (sub_project_id_tab_.COUNT = 1) THEN
         result_ := sub_project_id_tab_(1).sub_project_id;
      ELSIF (sub_project_id_tab_.COUNT > 1) THEN
         result_ := mixed_value_;
      END IF;
   $END   
   RETURN result_;
END Get_Sub_Project_Id;

