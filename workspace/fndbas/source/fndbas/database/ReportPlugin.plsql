-----------------------------------------------------------------------------
--
--  Logical unit: ReportPlugin
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990525  ERFO  Created for Project Orion (ToDo #3375).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  120215  LAKRLK RDTERUNTIME-184
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Get_Plugin (
   plug_in_ OUT VARCHAR2,
   prog_id_ OUT VARCHAR2,
   report_id_ IN VARCHAR2 )
IS
BEGIN
   SELECT plug_in, prog_id
   INTO   plug_in_, prog_id_
   FROM   report_plugin_tab
   WHERE  report_id = report_id_;
EXCEPTION
   WHEN no_data_found THEN
      NULL;
   WHEN too_many_rows THEN
      Error_SYS.Too_Many_Rows('Report_Plugin_API.Get_Plugin');
END Get_Plugin;


@UncheckedAccess
PROCEDURE Get_Default_Layout (
   defaul_layout_ OUT VARCHAR2,
   report_id_ IN VARCHAR2 )
IS
BEGIN
   SELECT default_layout
   INTO   defaul_layout_
   FROM   report_plugin_tab
   WHERE  report_id = report_id_;
EXCEPTION
   WHEN no_data_found THEN
      NULL;
   WHEN too_many_rows THEN
      Error_SYS.Too_Many_Rows('Report_Plugin_API.Get_Default_Layout');
END Get_Default_Layout;



