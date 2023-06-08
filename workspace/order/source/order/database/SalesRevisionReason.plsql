-----------------------------------------------------------------------------
--
--  Logical unit: SalesRevisionReason
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160627  IzShlk  STRSC-1967, Removed overriden exist method and check_insert method for block for use which will be replace by data validity 
--  140210  MaRalk  PBSC-7093, Added method Get_Reason_Description.
--  121129  Maabse  Added BLOCKED_FOR_USE
--  121123  Maabse  Create
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
   
   Client_SYS.Add_To_Attr('USED_BY_ENTITY', Reason_Used_By_API.Decode('BO'), attr_);
   
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
   FUNCTION Get_Reason_Description (
   reason_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   
   FUNCTION Base (
      reason_id_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      temp_ sales_revision_reason_tab.reason_description%TYPE;
   BEGIN
      IF (reason_id_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'SalesRevisionReason',
                 reason_id), reason_description), 1, 35)
         INTO  temp_
         FROM  sales_revision_reason_tab
         WHERE reason_id = reason_id_;
      RETURN temp_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(reason_id_, 'Get_Reason_Description');
   END Base;

BEGIN
   RETURN Base(reason_id_);
END Get_Reason_Description;

