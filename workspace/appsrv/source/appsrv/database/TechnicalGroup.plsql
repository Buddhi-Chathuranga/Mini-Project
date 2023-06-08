-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalGroup
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131126  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  100422  Ajpelk Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  060925  UsRaLK Bug #60602: removed group order check from Unpack_Check_Insert___ and Unpack_Check_Update___.
--  060203  NeKolk Call 132689 Modified FUNCTION Get_Grp_Attr
--  050907  NeKolk AMUT 115: Isolation and Permits Added FUNCTION Get_Grp_Attr
--  000629  JoSc  Replaced module declaration PLADES with APPSR
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Grp_Attr
--   Returns group attr..
@UncheckedAccess
FUNCTION Get_Grp_Attr (
   technical_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_  VARCHAR2(32000);

   CURSOR get_attr IS
      SELECT group_name
      FROM TECHNICAL_GROUP_TAB
      WHERE technical_class = technical_class_
      ORDER BY GROUP_ORDER;

BEGIN
  FOR grp_attr IN get_attr LOOP
    attr_ := attr_ ||grp_attr.group_name ||'^';
  END LOOP;
  RETURN attr_;
END Get_Grp_Attr;

@UncheckedAccess
FUNCTION Get_Grpdtl_Attr (
   technical_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   
   FUNCTION Core (
      technical_class_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      attr_  VARCHAR2(32000);
   
      CURSOR get_attr IS
         SELECT group_name
         FROM TECHNICAL_GROUP_TAB
         WHERE technical_class = technical_class_
         ORDER BY GROUP_ORDER;
   
   BEGIN
     FOR grp_attr IN get_attr LOOP
       attr_ := attr_ ||grp_attr.group_name ||' - ' || TECHNICAL_GROUP_API.Get_Description(grp_attr.group_name)||'^';
     END LOOP;
     RETURN attr_;
   END Core;

BEGIN
   RETURN Core(technical_class_);
END Get_Grpdtl_Attr;

@UncheckedAccess
FUNCTION Get_Description (
   group_name_  IN VARCHAR2   ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(1000);
   CURSOR get_disc IS
      SELECT group_desc
      FROM   TECHNICAL_GROUP_TAB
      WHERE group_name = group_name_;
BEGIN
   OPEN get_disc;
   FETCH get_disc INTO temp_;
   CLOSE get_disc;
   RETURN temp_;
END Get_Description;



