-----------------------------------------------------------------------------
--
--  Logical unit: TypeDesignation
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950717  SLKO    Recreated according to the new definition of the LU.
--                  For the previous history trace look into MSTYPED.PKY
--                  and MSTYPED.APY files from the STD_0100ALPHA2 release.
--  950724  SLKO    Changes according to the new standard of the LU definition.
--  950731  SLKO    Added checking for NULL value in the Get_Description
--                  procedure.
--  950822  TOWI    Moving in generated view-body from script view.gen.
--                  Moving in generated view-comments from script
--                  viewcomm.gen
--                  Objversion padded with blanks.
--  950829  TOWI    Added function Get_Description
--  
--  950831  TOWI    Added EXIT at end of file and modified procedure Exist not
--                  to validate NULL values.
--  951021  OYME    Recreated using Base Table to Logical Unit Generator UH-Speci
--  951101  JOSC    Corrected some procedure calls with capital letters.
--  960129  ADBR    Added Has_Documents.
--  960520  JOSC    Added INIT procedure.
--  960522  JOSC    Removed SYS4 dependencies and added call to Init_Method.
--  960607  ADBR    Overloaded with Has_Documents and Has_Technical_Data functio
--  960919  ADBR    Created from Rose model using Developer's Workbench.
--  961106  ADBR    Upgraded to 1.2.2.
--  961219  ADBR    Merged with new templates.
--  970402  CAJO    Adjusted to new templates in Foundation1 1.2.2C.
--  970919  CAJO    Converted to F1 2.0. Changed table name to type_designation_tab.
--  971025  STSU    Added methods Check_Exist and Create_Type_Designation.
--  990113  MIBO    SKY.0208 AND SKY.0209 Removed all calls to Get_Instance___
--                  in Get-statements.
--  990408  MIBO    Template changes due to performance improvement.
--  991006  OSRY    Rock1424:B Changed mch_type from 5 to 20 characters.
--  000512  RECASE  Added key_ref and lu_name to the view TYPE_DESIGNATION, as they are keys to characteristics. 
--  000523  RECASE  Deleted call for EQUIPMENT_OBJECT_UTIL_API.Create_Attr_Template in INSERT__.
--  010426  UDSULK  Added the General_SYS.Init_Method to Has_Document.
--  040423  UDSULK  Unicode Modification-substr removal-4.
--  -------------------------Project Eagle-------------------------------------
--  091019  LoPrlk  EAME-182: Remove unused internal variables in EQUIP.
--  091026  Hidilk  Added view comments for lu_name and key_ref fields
--  131130  NEKOLK  PBSA-1820: Hooks: Refactored and split code.
--  170831  japelk  Data Validity changes, Overridden method Raise_Record_Access_Blocked___ is added.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     TYPE_DESIGNATION_TAB%ROWTYPE,
   newrec_     IN OUT TYPE_DESIGNATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Type_Designation_Util_API.Check_Type_Status(newrec_.type, newrec_.mch_type);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
  
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Raise_Record_Access_Blocked___ (
    type_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Access_Blocked(lu_name_, 'ACCESSBLOCKED: Type Designation :P1 is blocked for use.', type_);
   super(type_);
END Raise_Record_Access_Blocked___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Has_Document (
   rcode_ OUT VARCHAR2,
   type_ IN VARCHAR2 )
IS
BEGIN
   rcode_ := NULL;
   IF Maintenance_Document_Ref_API.Exist_Obj_Reference('TypeDesignation', type_) = 'TRUE' THEN
      rcode_ := 'TRUE';
   ELSE
      rcode_ := 'FALSE';
   END IF;
END Has_Document;


@UncheckedAccess
FUNCTION Check_Exist (
   type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(type_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE Create_Type_Designation (
   type_        IN VARCHAR2,
   description_ IN VARCHAR2,
   mch_type_    IN VARCHAR2 )
IS
   newrec_      TYPE_DESIGNATION_TAB%ROWTYPE;
BEGIN
   newrec_.type := type_;
   newrec_.descr := description_;
   newrec_.mch_type := mch_type_;
   New___(newrec_);
END Create_Type_Designation;



