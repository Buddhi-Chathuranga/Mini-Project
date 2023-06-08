-----------------------------------------------------------------------------
--
--  Logical unit: RemotePrinterMapping
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  041209  DOZE    Create
--  140129  AsiWLK   Merged LCS-111925
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Printing_Node (
   remote_printing_node_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM REMOTE_PRINTER_MAPPING_TAB
     WHERE remote_printing_node = remote_printing_node_;
END Remove_Printing_Node;


PROCEDURE Add_Mapping (
   logical_printer_ IN VARCHAR2,
   remote_printing_node_ IN VARCHAR2 )
IS
BEGIN
   IF NOT Check_Exist___(logical_printer_, remote_printing_node_) THEN
      INSERT INTO REMOTE_PRINTER_MAPPING_TAB
        (logical_printer,
         remote_printing_node,
         rowversion)
       VALUES
        (logical_printer_,
         remote_printing_node_,
         SYSDATE);
   END IF;
END Add_Mapping;



