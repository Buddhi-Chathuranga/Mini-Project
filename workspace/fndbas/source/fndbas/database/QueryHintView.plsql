-----------------------------------------------------------------------------
--
--  Logical unit: QueryHintView
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030219  HAAR  Created (ToDo#4152).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Invalidate__ (
   attr_      OUT VARCHAR2,
   view_name_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     QUERY_HINT_VIEW_TAB%ROWTYPE;
   oldrec_     QUERY_HINT_VIEW_TAB%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys___ (view_name_);
   newrec_ := oldrec_;
   newrec_.timestamp := NULL;
   Update___ (objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Client_SYS.Add_To_Attr('TIMESTAMP', '', attr_);
   Client_SYS.Add_To_Attr('INVALID_QUERY_HINT', Query_Hint_View_API.Invalid_Query_Hint__(view_name_), attr_);
END Invalidate__;


@UncheckedAccess
FUNCTION Invalid_Query_Hint__ (
   view_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   last_ddl_time_ DATE;
   timestamp_     DATE;
   --
   CURSOR get_views IS
      SELECT o.last_ddl_time, d.timestamp
      FROM   user_objects o,
             query_hint_view_tab d
      WHERE  o.object_name = view_name_
      AND    o.object_type = 'VIEW'
      AND    o.object_name = d.view_name(+);
   --
BEGIN
   OPEN  get_views;
   FETCH get_views INTO last_ddl_time_, timestamp_;
   CLOSE get_views;
   IF (last_ddl_time_ > nvl(timestamp_, to_date('10000101', 'YYYYMMDD'))) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Invalid_Query_Hint__;


PROCEDURE Parse__ (
   attr_      OUT VARCHAR2,
   stmt_      OUT VARCHAR2,
   view_name_ IN  VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   parsed_     VARCHAR2(5);
   newrec_     QUERY_HINT_VIEW_TAB%ROWTYPE;
   oldrec_     QUERY_HINT_VIEW_TAB%ROWTYPE;
BEGIN
   stmt_ := Query_Hint_Utility_API.Parse_Query_Hint_View_(view_name_);
   IF (stmt_ IS NULL) THEN
      parsed_ := 'TRUE';
   ELSE
      parsed_ := 'FALSE';
   END IF;
   oldrec_ := Lock_By_Keys___ (view_name_);
   newrec_ := oldrec_;
   newrec_.parsed := parsed_;
   Update___ (objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Client_SYS.Add_To_Attr('PARSED_DB', parsed_, attr_);
   Client_SYS.Add_To_Attr('INVALID_QUERY_HINT', Query_Hint_View_API.Invalid_Query_Hint__(view_name_), attr_);
END Parse__;


PROCEDURE Rebuild__ (
   attr_          OUT VARCHAR2,
   view_name_     IN  VARCHAR2,
   remove_manual_ IN  VARCHAR2 )
IS
BEGIN
   Query_Hint_Utility_API.Rebuild_View_Query_Hints_(attr_, view_name_, remove_manual_);
END Rebuild__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


