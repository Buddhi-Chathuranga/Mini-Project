-----------------------------------------------------------------------------
--
--  Logical unit: CompositePageDataSource
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
@Override
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     composite_page_data_source_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, remrec_);
   Pres_Object_Util_API.Remove_Pres_Object('hudDataSource'||remrec_.id);
   Pres_Object_Util_API.Remove_Pres_Object('lobbyDataSource'||remrec_.id);
   --Add post-processing code here
END Delete___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Datasource_Config (
   value_  OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   --SOLSETFW
   SELECT value INTO value_
     FROM composite_page_data_source_tab c
    WHERE rowkey = rowkey_
      AND (component IS NULL 
           OR EXISTS (SELECT 1 FROM module_tab m
                       WHERE c.component = m.module
                         AND m.active = 'TRUE'));
EXCEPTION
   WHEN no_data_found THEN
      value_ := NULL;
END Get_Datasource_Config;