-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectGrant
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000302  ERFO  Added methods New_Grant and Remove_Grant.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE New_Grant (
   po_id_ IN VARCHAR2,
   role_ IN VARCHAR2 )
IS
BEGIN
   INSERT INTO pres_object_grant_tab
      (po_id, role, rowversion)
   VALUES
      (po_id_, role_, sysdate);
EXCEPTION
   WHEN dup_val_on_index THEN
      NULL;
END New_Grant;


PROCEDURE Remove_Grant (
   po_id_ IN VARCHAR2,
   role_ IN VARCHAR2 )
IS
BEGIN
   DELETE
      FROM pres_object_grant_tab
      WHERE po_id = po_id_
      AND   role = role_;
END Remove_Grant;
