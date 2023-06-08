-----------------------------------------------------------------------------
--
--  Logical unit: PackagingGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise   Made description private.
--  090518  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   rec_ IN PACKAGING_GROUP_TAB%ROWTYPE )
IS
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   newrec_       PACKAGING_GROUP_TAB%ROWTYPE;
   oldrec_       PACKAGING_GROUP_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PACKAGING_GROUP', rec_.packaging_group, attr_);

   IF (Check_Exist___(rec_.packaging_group_id)) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.packaging_group_id);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   ELSE
      Client_SYS.Add_To_Attr('PACKAGING_GROUP_ID', rec_.packaging_group_id, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;

   Basic_Data_Translation_API.Insert_Prog_Translation('INVENT',
                                                      lu_name_,
                                                      rec_.packaging_group_id,
                                                      rec_.packaging_group);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Packaging_Group (
   packaging_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ PACKAGING_GROUP_TAB.packaging_group%TYPE;
   CURSOR get_attr IS
      SELECT packaging_group
      FROM PACKAGING_GROUP_TAB
      WHERE packaging_group_id = packaging_group_id_;
BEGIN
   temp_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', lu_name_, packaging_group_id_ ), 1, 200);
   IF (temp_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Packaging_Group;
