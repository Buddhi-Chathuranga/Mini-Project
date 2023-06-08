-----------------------------------------------------------------------------
--
--  Logical unit: FndLayer
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   rec_ IN OUT Fnd_Layer_TAB%ROWTYPE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(50);
   attr_       VARCHAR2(2000);
BEGIN
   Insert___ (objid_, objversion_, rec_, attr_);
END New;

PROCEDURE Register (
   rec_ IN OUT Fnd_Layer_TAB%ROWTYPE )
IS
   already_exists EXCEPTION;
   PRAGMA EXCEPTION_INIT(already_exists, -20112);
BEGIN
   New___(rec_);
EXCEPTION
   WHEN already_exists THEN
      Modify___(rec_);
END Register;

FUNCTION Get_Max_Ordinal return number
IS
   max_ordinal_ number;
BEGIN

   SELECT NVL(MAX(ORDINAL),0)
     INTO max_ordinal_
     FROM FND_LAYER_TAB;

   return max_ordinal_;
END Get_Max_Ordinal;

@UncheckedAccess
PROCEDURE List_Fnd_Layers (
   fnd_layers_list_ OUT VARCHAR2)
IS
   temp_ VARCHAR2(32000);
   CURSOR get_list IS
   SELECT layer_id 
   FROM   fnd_layer_tab
   ORDER BY use_for_development DESC;
   
   layer_id_       VARCHAR2(100);
BEGIN
      OPEN get_list;
      LOOP
         FETCH get_list INTO layer_id_;
         EXIT WHEN get_list%NOTFOUND;  
         temp_ := temp_||layer_id_||Client_SYS.field_separator_;
      END LOOP;
      CLOSE get_list;
      fnd_layers_list_ := temp_;
END List_Fnd_Layers;