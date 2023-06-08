-----------------------------------------------------------------------------
--
--  Logical unit: Competitiveness
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140210  MaRalk  PBSC-7093, Added method Get_Compete_Description.
--  060112  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050126  Samnlk Change the view comments in view COMPETITIVENESS.
--  -------------------------------13.3.0--------------------------------------
--  000906  CaSt  Changed comment on compete_id to uppercase
--  000711  TFU   merging from Chameleon
--  000404  TFU   Competitiveness
--  ----------------------------- 12.1
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
   FUNCTION Get_Compete_Description (
   compete_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   
   FUNCTION Base (
      compete_id_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      temp_ competitiveness_tab.compete_description%TYPE;
   BEGIN
      IF (compete_id_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'Competitiveness',
                 compete_id), compete_description), 1, 100)
         INTO  temp_
         FROM  competitiveness_tab
         WHERE compete_id = compete_id_;
      RETURN temp_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(compete_id_, 'Get_Compete_Description');
   END Base;

BEGIN
   RETURN Base(compete_id_);
END Get_Compete_Description;

