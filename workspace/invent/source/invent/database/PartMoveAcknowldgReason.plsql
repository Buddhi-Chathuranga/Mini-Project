-----------------------------------------------------------------------------
--
--  Logical unit: PartMoveAcknowldgReason
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150504  KhVeSe  Created.        
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Ack_Reason_Desc (
   description_ OUT VARCHAR2,
   acknowledge_reason_id_ IN VARCHAR2 ) 
IS
BEGIN
   description_ := Get_Description(acknowledge_reason_id_);
END Get_Ack_Reason_Desc;

