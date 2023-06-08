-----------------------------------------------------------------------------
--
--  Logical unit: CommissionReceiverGroup
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120508  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120508           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120508           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  070519  WaJalk   Made the column 'commission_receiver_group' uppercase.
--  060112  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  000710  JakH  Merging from Chameleon
--  000412  BjSa  Modified view comments for description
--  000412  DEHA  Attributes of field description changed (public).
--  000410  DEHA  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   commission_receiver_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ commission_receiver_group_tab.description%TYPE;
BEGIN
   IF (commission_receiver_group_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      commission_receiver_group_), 1, 50);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   commission_receiver_group_tab
   WHERE  commission_receiver_group = commission_receiver_group_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(commission_receiver_group_, 'Get_Description');
END Get_Description;
