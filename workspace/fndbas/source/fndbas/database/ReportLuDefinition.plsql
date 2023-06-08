-----------------------------------------------------------------------------
--
--  Logical unit: ReportLuDefinition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140129  AsiWLK   Merged LCS-111925
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Enable_Custom_Fields_for_Lu (
   report_id_       IN VARCHAR2,
   lu_name_         IN VARCHAR2,
   block_xpath_     IN VARCHAR2)
IS
   block_xpath_tem_ VARCHAR2(1000);
BEGIN
   
   --validate block_xpath_ to 
   block_xpath_tem_ := TRIM(both '/' from block_xpath_);
   IF (INSTR(block_xpath_tem_,report_id_,1,1) != 1) THEN
         block_xpath_tem_ := report_id_||'/'|| block_xpath_tem_;
   END IF;
 
   INSERT
      INTO report_lu_definition_tab (
         REPORT_ID,LU_NAME,BLOCK_XPATH,ROWVERSION)
      VALUES (
         upper(report_id_),lu_name_,block_xpath_tem_,SYSDATE
         );
   
   
END Enable_Custom_Fields_for_Lu;


PROCEDURE Clear_Custom_Fields_For_Report (
   report_id_       IN VARCHAR2)
IS
   
BEGIN
   DELETE
      FROM report_lu_definition_tab
      WHERE upper(report_id_)= upper(report_id);   
   
   
END Clear_Custom_Fields_For_Report;


@UncheckedAccess
FUNCTION Get_Block_Xpaths (
   report_id_ IN VARCHAR2,
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_str_           VARCHAR2(32000);
   
   CURSOR getrec IS
      SELECT *
      FROM   REPORT_LU_DEFINITION_TAB
      WHERE  report_id = report_id_
       AND   lu_name = lu_name_;
       
BEGIN
    FOR lu_rec_ IN getrec LOOP 
       IF return_str_ IS NULL THEN
         return_str_:=lu_rec_.block_xpath;
       ELSE
         return_str_:=return_str_||';'||lu_rec_.block_xpath;  
       END IF;     
         
    END LOOP;  
    RETURN return_str_;
EXCEPTION
   WHEN OTHERS THEN
      RETURN null;
END Get_Block_Xpaths;



