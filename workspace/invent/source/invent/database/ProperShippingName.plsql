-----------------------------------------------------------------------------
--
--  Logical unit: ProperShippingName
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200717  AjShLK   Bug 152999(SCZ-9246), Modified Get_Proper_Shipping_Name method to support language translation for different languages.
--  120525  JeLise   Made description private.
--  110914  JeLise   Added check on newrec_.un_no in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  090518  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('N_O_S_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT proper_shipping_name_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_   VARCHAR2(30);
   value_  VARCHAR2(4000);
   ndummy_ INTEGER;
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (newrec_.un_no IS NOT NULL) THEN
      name_   := 'UN_NO';
      value_  := newrec_.un_no;
      ndummy_ := TO_NUMBER(newrec_.un_no);
      IF (LENGTH(ndummy_) < 4) THEN
         IF ((SUBSTR(newrec_.un_no,1,1) != '0') AND (LENGTH(ndummy_) = 3) OR
            (SUBSTR(newrec_.un_no,1,2) != '00') AND (LENGTH(ndummy_) = 2) OR
            (SUBSTR(newrec_.un_no,1,3) != '000') AND (LENGTH(ndummy_) = 1) OR
            (LENGTH(newrec_.un_no) < 4)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDUN: UN Number :P1 must be a four digit integer value.', newrec_.un_no);
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     proper_shipping_name_tab%ROWTYPE,
   newrec_ IN OUT proper_shipping_name_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_   VARCHAR2(30);
   value_  VARCHAR2(4000);
   ndummy_ INTEGER;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.un_no IS NOT NULL) THEN
      name_   := 'UN_NO';
      value_  := newrec_.un_no;
      ndummy_ := TO_NUMBER(newrec_.un_no);
      IF (LENGTH(ndummy_) < 4) THEN
         IF ((SUBSTR(newrec_.un_no,1,1) != '0') AND (LENGTH(ndummy_) = 3) OR
            (SUBSTR(newrec_.un_no,1,2) != '00') AND (LENGTH(ndummy_) = 2) OR
            (SUBSTR(newrec_.un_no,1,3) != '000') AND (LENGTH(ndummy_) = 1) OR
            (LENGTH(newrec_.un_no) < 4)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDUN: UN Number :P1 must be a four digit integer value.', newrec_.un_no);
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Get_Proper_Shipping_Name
--   Fetches the ProperShippingName attribute for a record.
@UncheckedAccess
FUNCTION Get_Proper_Shipping_Name (
   proper_shipping_name_id_   IN VARCHAR2 ,
   language_code_             IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   temp_ proper_shipping_name_tab.proper_shipping_name%TYPE;
BEGIN
   IF (proper_shipping_name_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      proper_shipping_name_id_, language_code_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT proper_shipping_name
      INTO  temp_
      FROM  proper_shipping_name_tab
      WHERE proper_shipping_name_id = proper_shipping_name_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(proper_shipping_name_id_, 'Get_Proper_Shipping_Name');
END Get_Proper_Shipping_Name;



