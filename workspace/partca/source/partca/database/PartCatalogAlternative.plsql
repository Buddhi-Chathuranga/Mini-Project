-----------------------------------------------------------------------------
--
--  Logical unit: PartCatalogAlternative
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210104  SBalLK  Issue SC2020R1-11830, Modified both Create_Mutual_Part___(), Create_Alternative(), Remove_Mutual_Property(), and Copy(),
--  210104          methods by removing attr_ functionality to optimize the performance.
--  140416  ChJalk  Modified Create_Mutual_Part___ method to initialize the rowkey.
--  140415  JeLise  Changed the parameters in call to Get_Object_By_Keys___ in Create_Mutual_Part___ to 
--  140415          get the correct newrec_ and oldrec_.
--  130729  MaIklk  TIBE-1040, Removed global constants and used conditional compilation instead.
--  100423  KRPELK  Merge Rose Method Documentation.
--  100120  HimRlk   Moved method calls to Transaction_SYS.Logical_Unit_Is_Installed to Global constants.
--  090529  SaWjlk  Bug 83173, Removed the prog text duplications.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060123  JaJalk  Added Assert safe annotation.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050916  NaLrlk  Removed unused variables.
--  050119  KeFelk  Changed Error_SYS.Record_Not_Exist to Error_SYS.Record_Exist in Copy.
--  041216  KeFelk  Removed default data in Copy Parameters.
--  041214  KeFelk  Removed public cursor Get_All_Alternative_Part.
--  041211  JaBalk  Added copy method
--  040217  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  -----------------------EDGE - Package Group 3 Unicode Changes----------------------------
--  040127  IsAnlk  Made Get_All_Alternative_Part public cursor obselete and it should remove after changing MFGSTD files.
--  031204  LaBolk  Added block comments in Unpack_Check_Insert___.
--  -----------------------------12.3.0-------------------------
--  031017  jagrno  Corrected error in method Create_Alternative.
--  031013  PrJalk  Bug Fix 106224, Changed incorrect General_Sys.Init_Method calls.
--  031007  MaEelk  Call ID 104218, attr_ was set to be VARCHAR2(32000) in Create_Mutual_Part___
--  030718  JOHESE  Added check in Unpack_Check_Insert___
--  030502  DAYJLK  Call 96814, Modified method Create_Alternative to create new
--  030502          alternative part only if the part doesn't exist.
--  030312  KiSalk  Added parameter 'mutual_' to procedure 'Create_Alternative'.
--  030225  AnLaSe  Used Design to update file after changing rowversion to use type date.
--                  Removed commented code with note call 87120.
--  030220  Shvese  Changed rowversion from number to date.
--  *******************TSO Merge*********************************************
--  020806  GeKa    Added public methods Remove_Mutual_Part and Remove_Mutual_Property.
--  020630  sijo    Added some dynamic calls in Check_Delete___.
--  020614  sijo    Added method Create_Alternative.
--  020507  sijo    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Create_Mutual_Part___
--   - Create mutual part. Used when create alternate parts in part catalog.
PROCEDURE Create_Mutual_Part___ (
   part_no_             IN VARCHAR2,
   alternative_part_no_ IN VARCHAR2 )
IS
   newrec_     part_catalog_alternative_tab%ROWTYPE;
   oldrec_     part_catalog_alternative_tab%ROWTYPE;
   update_rec_ BOOLEAN := FALSE;
BEGIN
   oldrec_ := Get_Object_By_Keys___(alternative_part_no_, part_no_);
   IF (NOT Check_Exist___(part_no_, alternative_part_no_)) THEN
      newrec_.part_no             := part_no_;
      newrec_.alternative_part_no := alternative_part_no_;
      newrec_.mutual              := Fnd_Boolean_API.DB_TRUE;
      newrec_.source_reference    := oldrec_.source_reference;
      newrec_.note_text           := oldrec_.note_text;
      New___(newrec_);
   ELSE
      newrec_ := Lock_By_Keys___(part_no_, alternative_part_no_);
      IF ( oldrec_.note_text IS NOT NULL AND newrec_.note_text IS NULL) THEN
         newrec_.note_text := oldrec_.note_text;
         update_rec_ := TRUE;
      END IF;
      IF (oldrec_.source_reference IS NOT NULL AND newrec_.source_reference IS NULL) THEN
          newrec_.source_reference := oldrec_.source_reference;
          update_rec_ := TRUE;
      END IF;
      IF(update_rec_ OR newrec_.mutual = Fnd_Boolean_API.DB_FALSE) THEN
         newrec_.mutual := Fnd_Boolean_API.DB_TRUE;
         Modify___(newrec_);
      END IF;
   END IF;
END Create_Mutual_Part___;


-- Remove_Mutual_Part___
--   - Remove mutual part. Used when deleting alternate parts/update mutual checkbox
--   on alternate parts in part catalog.
PROCEDURE Remove_Mutual_Part___ (
   part_no_             IN VARCHAR2,
   alternative_part_no_ IN VARCHAR2 )
IS
   remrec_     part_catalog_alternative_tab%ROWTYPE;
   objid_      VARCHAR2(200);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, alternative_part_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   --
   DELETE
      FROM  part_catalog_alternative_tab
      WHERE rowid = objid_;
END Remove_Mutual_Part___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'MUTUAL', 'TRUE', attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_catalog_alternative_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- server defaults
   newrec_.dt_cre       := sysdate;
   Client_SYS.Add_To_Attr('DT_CRE', newrec_.dt_cre, attr_);
   newrec_.user_created := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('USER_CREATED', newrec_.user_created, attr_);
   newrec_.dt_chg       := newrec_.dt_cre;
   Client_SYS.Add_To_Attr('DT_CHG', newrec_.dt_chg, attr_);
   newrec_.user_sign    := newrec_.user_created;
   Client_SYS.Add_To_Attr('USER_SIGN', newrec_.user_sign, attr_);
      
   super(objid_, objversion_, newrec_, attr_);
     -- create corresponding line if mutal checked
   IF (newrec_.mutual = 'TRUE') THEN
      Create_Mutual_Part___(newrec_.alternative_part_no, newrec_.part_no);
   END IF;

   Client_SYS.Add_To_Attr('MUTUAL', newrec_.mutual, attr_ );
   Client_SYS.Add_To_Attr('INFORMATION', newrec_.information, attr_ );
   Client_SYS.Add_To_Attr('NOTE_TEXT', newrec_.note_text, attr_ );
   Client_SYS.Add_To_Attr('SOURCE_REFERENCE', newrec_.source_reference, attr_ );
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     part_catalog_alternative_tab%ROWTYPE,
   newrec_     IN OUT part_catalog_alternative_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   -- server defaults
   newrec_.dt_chg    := sysdate;
   Client_SYS.Add_To_Attr('DT_CHG', newrec_.dt_chg, attr_);
   newrec_.user_sign := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('USER_SIGN', newrec_.user_sign, attr_);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
    -- create/remove corresponding line if mutal checked/unchecked
   IF newrec_.mutual = 'TRUE' THEN
      Create_Mutual_Part___(newrec_.alternative_part_no, newrec_.part_no);
   END IF;

   Client_SYS.Add_To_Attr('MUTUAL', newrec_.mutual, attr_ );
   Client_SYS.Add_To_Attr('NOTE_TEXT', newrec_.note_text, attr_ );
   Client_SYS.Add_To_Attr('SOURCE_REFERENCE', newrec_.source_reference, attr_ );
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN part_catalog_alternative_tab%ROWTYPE )
IS
BEGIN
   super(remrec_);
   -- check if alternate is used in Eng Part Rev Alternative (PDMCON)
   $IF (Component_Pdmcon_SYS.INSTALLED) $THEN
      Eng_Part_Rev_Alternative_API.Check_If_Alternate_Used(remrec_.part_no, remrec_.alternative_part_no);
   $END
   -- Check if alternate is used in Purchase Part Alternative (PURCH)
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Purchase_Part_Alternative_API.Check_If_Alternate_Used(remrec_.part_no, remrec_.alternative_part_no); 
   $END
   -- Check if alternate is used in Substitute Sales Part (ORDER)
   $IF (Component_Order_SYS.INSTALLED) $THEN
      Substitute_Sales_Part_API.Check_If_Alternate_Used(remrec_.part_no, remrec_.alternative_part_no); 
   $END
   -- Check if alternate is used in Alternate Component (MFGSTD)
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      Alternate_Component_API.Check_If_Alternate_Used(remrec_.part_no, remrec_.alternative_part_no);
   $END
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_catalog_alternative_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.alternative_part_no = newrec_.part_no) THEN
      Error_SYS.Record_General(lu_name_, 'ALTNOTSAME: The part cannot be an alternative to itself.');
   END IF;
   super(newrec_, indrec_, attr_);

   IF Part_Catalog_API.Get_Position_Part_Db(newrec_.alternative_part_no) = 'POSITION PART' THEN
      Error_SYS.Record_General(lu_name_, 'POSITIONPART: Position parts are not allowed as part catalog alternates.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     part_catalog_alternative_tab%ROWTYPE,
   newrec_ IN OUT part_catalog_alternative_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.alternative_part_no = newrec_.part_no) THEN
      Error_SYS.Record_General(lu_name_, 'ALTNOTSAME: The part cannot be an alternative to itself.');
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'DT_CRE', newrec_.dt_cre);
   Error_SYS.Check_Not_Null(lu_name_, 'USER_CREATED', newrec_.user_created);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Alternative_Part_Exist
--   - has two functionalities. User can send '%' to alt_part_no_
--   and then IF any record exist for part_no_, TRUE is returned. If user sends a particular alt_part_no_
--   then TRUE is returned when both part_no_ and alt_part_no_ exists. - SaKaLk
@UncheckedAccess
FUNCTION Check_Alternative_Part_Exist (
   part_no_             IN VARCHAR2,
   alternative_part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR temp_rec IS
      SELECT part_no
      FROM part_catalog_alternative
      WHERE part_no = part_no_
      AND alternative_part_no LIKE alternative_part_no_;
   dummy_ part_catalog_alternative_tab.part_no%TYPE;
BEGIN
   OPEN temp_rec;
   FETCH temp_rec INTO dummy_;
   IF (temp_rec%FOUND) THEN
      CLOSE temp_rec;
      RETURN('TRUE');
   END IF;
   CLOSE temp_rec;
   RETURN('FALSE');
END Check_Alternative_Part_Exist;


-- Is_The_Part_Legal
--   This function gives the value TRUE if the part is a legal alternative part.
@UncheckedAccess
FUNCTION Is_The_Part_Legal (
   part_no_             IN VARCHAR2,
   alternative_part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(part_no_, alternative_part_no_)) THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Is_The_Part_Legal;


-- Delete_Alternative
--   Remove the part catalog alternative.
PROCEDURE Delete_Alternative (
   alternative_part_no_ IN VARCHAR2 )
IS
BEGIN
   DELETE
      FROM  part_catalog_alternative_tab
      WHERE alternative_part_no = alternative_part_no_;
   DELETE
      FROM  part_catalog_alternative_tab
      WHERE part_no = alternative_part_no_;
END Delete_Alternative;


-- Create_Alternative
--   - Add new alternative for given part.
PROCEDURE Create_Alternative (
   part_no_             IN VARCHAR2,
   alternative_part_no_ IN VARCHAR2,
   mutual_              IN VARCHAR2 DEFAULT 'FALSE' )
IS
   attr_       VARCHAR2(32000);
   newrec_     part_catalog_alternative_tab%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   -- Create new alternative only if the part does not exist
   IF (NOT (Check_Exist___(part_no_, alternative_part_no_))) THEN
      Prepare_Insert___(attr_);
      Unpack___(newrec_, indrec_, attr_);
      newrec_.part_no             := part_no_;
      newrec_.alternative_part_no := alternative_part_no_;
      newrec_.mutual              := mutual_;
      New___(newrec_);
   END IF;
   -- Handle creation of a mutual alternate when non-mutual already exists
   IF (mutual_ = 'TRUE') THEN
      IF (NOT (Check_Exist___(alternative_part_no_, part_no_))) THEN
         Prepare_Insert___(attr_);
         Unpack___(newrec_, indrec_, attr_);
         newrec_.part_no             := alternative_part_no_;
         newrec_.alternative_part_no := part_no_;
         newrec_.mutual              := mutual_;
         New___(newrec_);
      END IF;
   END IF;
END Create_Alternative;


-- Remove_Mutual_Part
--   Remove mutual part.
PROCEDURE Remove_Mutual_Part (
   part_no_ IN VARCHAR2,
   alternative_part_no_ IN VARCHAR2 )
IS
BEGIN
  Remove_Mutual_Part___(part_no_,alternative_part_no_);
END Remove_Mutual_Part;


-- Remove_Mutual_Property
--   Remove mutual property with out deleting the mutual part.
PROCEDURE Remove_Mutual_Property (
   part_no_             IN VARCHAR2,
   alternative_part_no_ IN VARCHAR2 )
IS
   newrec_     part_catalog_alternative_tab%ROWTYPE;
BEGIN
   IF Check_Alternative_Part_Exist(part_no_, alternative_part_no_) = 'TRUE' THEN
      newrec_ := Lock_By_Keys___(part_no_, alternative_part_no_);
      newrec_.mutual := Fnd_Boolean_API.DB_FALSE;
      Modify___(newrec_);
   END IF;
END Remove_Mutual_Property;


-- Copy
--   Method creates new instance and copies all editable attributes
--   from old alternative part
PROCEDURE Copy (
   from_part_no_             IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_       part_catalog_alternative_tab%ROWTYPE;
   oldrec_found_ BOOLEAN:= FALSE;

   CURSOR    get_alternate_parts IS
      SELECT *
        FROM part_catalog_alternative_tab
       WHERE part_no = from_part_no_;
BEGIN

   FOR alt_part_rec_ IN get_alternate_parts LOOP
      IF (Check_Exist___(to_part_no_, alt_part_rec_.alternative_part_no)) THEN
         IF(error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Exist(lu_name_, 'ALTERNATEPARTEXIST: Alternative part :P1 exist for Part :P2',alt_part_rec_.alternative_part_no, to_part_no_);
         END IF;
      ELSE
         --Initialize variables
         newrec_         := alt_part_rec_;
         newrec_.part_no := to_part_no_;
         New___(newrec_);
      END IF;
      oldrec_found_ := TRUE;
   END LOOP;

   IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'ALTPARTNOTEXIST: Alternative part does not exist for Part :P1', from_part_no_);
   END IF;
END Copy;



