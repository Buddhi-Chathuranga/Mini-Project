-----------------------------------------------------------------------------
--
--  Logical unit: PartManufacturerUtil
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201007  LEPESE  SC2020R1-10429, added UncheckedAccess to Get_Manufacturer_Part_No.
--  201007  LEPESE  SC2020R1-10428, added UncheckedAccess to Get_Manufacturer_No.
--  201007  LEPESE  SC2020R1-10427, added UncheckedAccess to Get_Manufactured_Date.
--  201002  JaThlk  SC2020R1-1187, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Manufacturer_No (
   part_no_        IN VARCHAR2,
   serial_no_      IN VARCHAR2,
   lot_batch_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   manufacturer_no_   VARCHAR2(20);
BEGIN
   IF Validate_SYS.Is_Different(serial_no_, '*') THEN
      manufacturer_no_ := Part_Serial_Catalog_API.Get_Manufacturer_No(part_no_, serial_no_);
   ELSIF Validate_SYS.Is_Different(lot_batch_no_, '*') THEN
      manufacturer_no_ := Lot_Batch_Master_API.Get_Manufacturer_No(part_no_, lot_batch_no_);
   END IF;
   RETURN manufacturer_no_;
END Get_Manufacturer_No;

@UncheckedAccess
FUNCTION Get_Manufacturer_Part_No (
   part_no_        IN VARCHAR2,
   serial_no_      IN VARCHAR2,
   lot_batch_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   manufacturer_part_no_   VARCHAR2(80);
BEGIN
   IF Validate_SYS.Is_Different(serial_no_, '*') THEN
      manufacturer_part_no_ := Part_Serial_Catalog_API.Get_Manu_Part_No(part_no_, serial_no_);
   ELSIF Validate_SYS.Is_Different(lot_batch_no_, '*') THEN
      manufacturer_part_no_ := Lot_Batch_Master_API.Get_Manufacturer_Part_No(part_no_, lot_batch_no_);
   END IF;
   RETURN manufacturer_part_no_;
END Get_Manufacturer_Part_No;

@UncheckedAccess
FUNCTION Get_Manufactured_Date (
   part_no_        IN VARCHAR2,
   serial_no_      IN VARCHAR2,
   lot_batch_no_   IN VARCHAR2 ) RETURN DATE
IS
   manufactured_date_   DATE;
BEGIN
   IF Validate_SYS.Is_Different(serial_no_, '*') THEN
      manufactured_date_ := Part_Serial_Catalog_API.Get_Manufactured_Date(part_no_, serial_no_);
   ELSIF Validate_SYS.Is_Different(lot_batch_no_, '*') THEN
      manufactured_date_ := Lot_Batch_Master_API.Get_Manufactured_Date(part_no_, lot_batch_no_);
   END IF;
   RETURN manufactured_date_;
END Get_Manufactured_Date;

