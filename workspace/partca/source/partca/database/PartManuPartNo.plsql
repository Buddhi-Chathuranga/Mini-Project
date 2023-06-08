-----------------------------------------------------------------------------
--
--  Logical unit: PartManuPartNo
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201228  SBalLK  Issue SC2020R1-11830, Modified Set_Preferred_Manu_Part() and Copy() methods by removing attr_ functionality to optimize the performance.
--  160621  ApWilk  Bug 129909, Modified Insert___() by changing the PREFERRED_MANU_PART as PREFERRED_MANU_PART_DB to align with the client referred value
--  160621          in order to display the Preferred Manufacturer's Part value upon saving the record.
--  140328  jagrno  Added override of Raise_Record_Not_Exist___.
--  131101  UdGnlk  PBSC-679, Modified the base view comments to align with model file errors. 
--  130729  MaIklk  TIBE-1045, Removed inst_PurchPartSuppManufPart_ global constant and used conditional compilation instead.
--  120416  GayDLK  Bug 101515, Modified Unpack_Check_Insert___() by adding a check to see whether the 
--  120416          created manufacturer's part no is valid.
--  110517  SuSalk  Bug 95937, Modified Update___ to clear the values of approved_date and approved_user when
--  110517          the value of approved is other than 1(Yes). 
--  110314  BhKalk  BBIRD-2001 Added method Get_Manu_Part_Count.
--  110311  Hasplk  Corrected dynamic call in Update___ method.
--  110211  Hasplk  BP-4068, Modified method Update___ to propagate changes to PurchPartSuppManufPart LU.
--  100423  KRPELK  Merge Rose Method Documentation.
--  100309  SuSalk  Bug 89069, Made preferred_manu_part attribute updatable and mandatory,
--  100309          and Modified Set_Preferred_Manu_Part, Unpack_Check_Update___, Update___,
--  100309          Unpack_Check_Insert___, Insert___ and Validate_Items___ methods accordingly.
--  091027  KAYOLK  Removed the COMMIT in the method Set_Preferred_Manu_Part().
--  090929  MaJalk  Removed unused views. 
--  ------------------------------- 13.0.0 ----------------------------------
--  090415  HoInlk  Bug 81528, Enabled LoV for columns Part No and Manufacturer No in PART_MANU_PART_NO.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050620  RoJalk  Bug 51743, changed the length of preferred_manufacturer_ to VARCHAR2(20) and used the method call
--  050620          Get_Preferred_Manufacturer_Db to get preferred_manufacturer_ in Update___  and Delete___.
--  050119  KeFelk  Changed Error_SYS.Record_Not_Exist to Error_SYS.Record_Exist in Copy
--  050119          and added another parameter to the relevant error msg.
--  041612  KeFelk  Removed default data in Copy Parameters.
--  041211  JaBalk  Modified procedure Copy.
--  041210  KanGlk  Added procedure Copy
--  040224  LoPrlk  Removed substrb from code. &VIEW and &VIEW4 were altered.
--  -----------------------------12.3.0-------------------------
--  030225  AnLaSe  Used Design to update file after changing rowversion to date.
--  030221  Shvese  Changed rowversion from number to date.
--  *****************TSO Merge***********************************************
--  021108  sijono  Call ID: 89992, Added attribute mtbf_mttr_unit.
--  021025  viasno  Call ID 90048, Made attributes approved_date and approved_user not insertable.
--  021016  MAEELK  Call ID 89855, Added extra condition to the cursor written in Check_Set_Preferred___
--                  in order to check whether there is a preferred manufactured part exist in the table.
--  021015  ARAMLK  Modified Unpack_Check_Update___. Set preferred_manu_part value depending on the approved value.
--  021009  chbalk  Call ID 86015, changed the parameter to call the Part_Manu_Part_Hist_API.Generate_History.
--  020620  jagrno  Corrections:
--                  - Removed method Het_Id_Version_By_Keys.
--                  - Minor changes to view PART_MANU_PART_NO2.
--                  - Remove NATO stock number info from view PART_MANU_PART_NO4.
--  020613  jagr    Corrected error in Set_Preferred_Manu_Part.
--  020605  ToFj    Updated in accordance with spec
--  020515  pask    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2,
   manu_part_no_    IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'NOTEXIST: Manufacturer part number :P1 does not exist for manufacturer :P2 of part number :P3.', manu_part_no_, manufacturer_no_, part_no_);
   super(part_no_, manufacturer_no_, manu_part_no_);
END Raise_Record_Not_Exist___;



-- Validate_Items___
--   - General attribute validations.
PROCEDURE Validate_Items___ (
   newrec_ IN OUT part_manu_part_no_tab%ROWTYPE,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.approved = '3' AND newrec_.preferred_manu_part = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'NOTAPPROVED: A part must be approved before it can be preferred');
   END IF;
   IF (newrec_.manufacturer_mtbf < 0) THEN
      Error_SYS.Record_General(lu_name_, 'MTBFBELZERO: The manufacturers MTBF cannot be a negative figure.');
   END IF;
   IF (newrec_.manufacturer_mttr < 0) THEN
      Error_SYS.Record_General(lu_name_, 'MTTRBELZERO: The manufacturers MTTR cannot be a negative figure.');
   END IF;
   IF (newrec_.experienced_mttr < 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXPMTTRBELZERO: The experienced MTTR cannot be a negative figure.');
   END IF;
   IF (newrec_.experienced_mtbf < 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXPMTBFBELZERO: The experienced MTBF cannot be a negative figure.');
   END IF;
   IF (newrec_.catalog_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'CATPRCBELZERO: The Catalog Price cannot be a negative figure.');
   END IF;
END Validate_Items___;


-- Get_Preferred_Object___
--   - Returns record for given part number and preference.
FUNCTION Get_Preferred_Object___ (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 DEFAULT NULL ) RETURN part_manu_part_no_tab%ROWTYPE
IS
   CURSOR Get_Preferred_Manufacturer_ (
      manufacturer_no_ VARCHAR2) IS
      SELECT   *
         FROM  part_manu_part_no_tab
         WHERE part_no = part_no_
         AND   manufacturer_no = manufacturer_no_
         AND   preferred_manu_part = 'TRUE';
   --
   preferred_rec_ part_manu_part_no_tab%ROWTYPE;
   pref_manuf_    part_manu_part_no_tab.manufacturer_no%TYPE;
BEGIN
   IF (manufacturer_no_ IS NULL) THEN
      pref_manuf_ := Part_Manufacturer_API.Get_Preferred_Manufacturer(part_no_);
   ELSE
      pref_manuf_ := manufacturer_no_;
   END IF;
   IF (pref_manuf_ IS NOT NULL) THEN
      OPEN Get_Preferred_Manufacturer_(pref_manuf_);
      FETCH Get_Preferred_Manufacturer_ INTO preferred_rec_;
      CLOSE Get_Preferred_Manufacturer_;
   END IF;
   RETURN(preferred_rec_);
END Get_Preferred_Object___;


-- Part_Manufacturer_Exist___
--   - Checks if given manufacturer is valid for given part number and returns
--   either TRUE or FALSE depending on the result.
FUNCTION Part_Manufacturer_Exist___ (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR Part_Manufacturer_Exist_ IS
      SELECT   'x'
         FROM  part_manu_part_no_tab
         WHERE part_no = part_no_
         AND   manufacturer_no = manufacturer_no_;
   --
   dummy_   VARCHAR2(1);
   found_   BOOLEAN;
BEGIN
   OPEN Part_Manufacturer_Exist_;
   FETCH Part_Manufacturer_Exist_ INTO dummy_;
   found_ := Part_Manufacturer_Exist_%FOUND;
   CLOSE Part_Manufacturer_Exist_;
   RETURN(found_);
END Part_Manufacturer_Exist___;


-- Check_Set_Preferred___
--   Checks if the entry should be set to preferred automatically.
FUNCTION Check_Set_Preferred___ (
   newrec_ IN part_manu_part_no_tab%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR exist_part_ IS
      SELECT    1
         FROM   part_manu_part_no_tab
         WHERE  part_no = newrec_.part_no
         AND    manufacturer_no = newrec_.manufacturer_no
         AND    preferred_manu_part = 'TRUE';
   --
   dummy_ NUMBER;
   found_ BOOLEAN;
BEGIN
   OPEN exist_part_;
   FETCH exist_part_ INTO dummy_;
   found_ := NOT exist_part_%FOUND;
   CLOSE exist_part_;
   RETURN found_;
END Check_Set_Preferred___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('APPROVED', Part_Manu_Approved_API.Decode('1'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_manu_part_no_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(newrec_, indrec_, attr_);
   Error_SYS.Check_Valid_Key_String('MANU_PART_NO', newrec_.manu_part_no);    
   -- do additional validations   
   Validate_Items___(newrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_manu_part_no_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- server defaults
   newrec_.preferred_manu_part := 'FALSE';
   newrec_.date_created := sysdate;
   Client_SYS.Add_To_Attr('DATE_CREATED', newrec_.date_created, attr_);
   newrec_.user_created := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('USER_CREATED', newrec_.user_created, attr_);
   newrec_.date_changed := newrec_.date_created;
   Client_SYS.Add_To_Attr('DATE_CHANGED', newrec_.date_changed, attr_);
   newrec_.user_changed := newrec_.user_created;
   Client_SYS.Add_To_Attr('USER_CHANGED', newrec_.user_changed, attr_);
   IF (newrec_.approved = '1') THEN
      -- check if the entry should be set as preferred
      IF (Check_Set_Preferred___(newrec_)) THEN
         newrec_.preferred_manu_part := 'TRUE';
      END IF;
      -- Check if we need the approved date, ignore if date is set
      IF (newrec_.approved_date IS NULL) THEN
         newrec_.approved_date := sysdate;
         Client_SYS.Add_To_Attr('APPROVED_DATE', newrec_.approved_date, attr_);
         newrec_.approved_user := newrec_.user_changed;
         Client_SYS.Add_To_Attr('APPROVED_USER', newrec_.approved_user, attr_);
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('PREFERRED_MANU_PART_DB', newrec_.preferred_manu_part, attr_);
   --
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     part_manu_part_no_tab%ROWTYPE,
   newrec_     IN OUT part_manu_part_no_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   history_purpose_        VARCHAR2(100);
   preferred_manufacturer_ VARCHAR2(20);   
BEGIN
   -- server defaults
   newrec_.date_changed := sysdate;
   newrec_.user_changed := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('DATE_CHANGED', newrec_.date_changed, attr_);
   Client_SYS.Add_To_Attr('USER_CHANGED', newrec_.user_changed, attr_);
   Client_SYS.Add_To_Attr('PREFERRED_MANU_PART_DB', newrec_.preferred_manu_part, attr_);

   IF ((newrec_.preferred_manu_part = 'TRUE') AND (oldrec_.preferred_manu_part = 'FALSE')) THEN
      UPDATE part_manu_part_no_tab 
         SET preferred_manu_part = 'FALSE',
             date_changed = newrec_.date_changed,
             user_changed = newrec_.user_changed,
             rowversion = newrec_.date_changed
       WHERE part_no = newrec_.part_no
         AND manufacturer_no = newrec_.manufacturer_no
         AND preferred_manu_part = 'TRUE';
   END IF;

   -- Set approved date if needed
   IF (newrec_.approved != oldrec_.approved) THEN
      IF (newrec_.approved = '1') THEN
         newrec_.approved_date := sysdate;
         Client_SYS.Add_To_Attr('APPROVED_DATE', newrec_.approved_date, attr_);
         newrec_.approved_user := newrec_.user_changed;
         Client_SYS.Add_To_Attr('APPROVED_USER', newrec_.approved_user, attr_);
      ELSE
         newrec_.approved_date := NULL;
         newrec_.approved_user := NULL;
         Client_SYS.Add_To_Attr('APPROVED_DATE', newrec_.approved_date, attr_);
         Client_SYS.Add_To_Attr('APPROVED_USER', newrec_.approved_user, attr_);
      END IF;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   --
   IF (newrec_.approved != oldrec_.approved) THEN
      history_purpose_ := Language_SYS.Translate_Constant('PartManuPartNo', 'PMPNROWAPP: The approval state has changed from :P1 to :P2.', NULL, Part_Manu_Approved_API.Decode(oldrec_.approved), Part_Manu_Approved_API.Decode(newrec_.approved));
      preferred_manufacturer_ := Part_Manufacturer_API.Get_Preferred_Manufacturer_Db (oldrec_.part_no, oldrec_.manufacturer_no);
      Part_Manu_Part_Hist_API.Generate_History(oldrec_.part_no,
                                               oldrec_.manufacturer_no,
                                               oldrec_.manu_part_no,
                                               oldrec_.preferred_manu_part,
                                               oldrec_.approved,
                                               oldrec_.approved_date,
                                               oldrec_.approved_user,
                                               oldrec_.approved_note,
                                               history_purpose_,
                                               preferred_manufacturer_);
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         Purch_Part_Supp_Manuf_Part_API.Modify_Pref_Parts_On_Approve(newrec_.part_no, newrec_.manufacturer_no, newrec_.manu_part_no, oldrec_.approved, newrec_.approved); 
      $END
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN part_manu_part_no_tab%ROWTYPE )
IS
   history_purpose_        VARCHAR2(100);
   preferred_manufacturer_ VARCHAR2(20);
BEGIN
   super(objid_, remrec_);
   -- generate history
   history_purpose_ := Language_SYS.Translate_Constant('PartManuPartNo', 'PMPNROWDEL: Manufacturer Part Number has been removed');
   preferred_manufacturer_ := Part_Manufacturer_API.Get_Preferred_Manufacturer_Db (remrec_.part_no, remrec_.manufacturer_no);
   Part_Manu_Part_Hist_API.Generate_History(remrec_.part_no,
                                            remrec_.manufacturer_no,
                                            remrec_.manu_part_no,
                                            remrec_.preferred_manu_part,
                                            remrec_.approved,
                                            remrec_.approved_date,
                                            remrec_.approved_user,
                                            remrec_.approved_note,
                                            history_purpose_,
                                            preferred_manufacturer_);
   --
END Delete___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     part_manu_part_no_tab%ROWTYPE,
   newrec_ IN OUT part_manu_part_no_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.approved = '3') THEN
      newrec_.preferred_manu_part := 'FALSE';
   END IF;
   -- do additional validations
   Validate_Items___(newrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Checks if given instance exists.
@UncheckedAccess
FUNCTION Check_Exist (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2,
   manu_part_no_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(part_no_, manufacturer_no_, manu_part_no_) THEN
      RETURN ('TRUE');
   ELSE
      RETURN ('FALSE');
   END IF;
END Check_Exist;


-- Get_Preferred_Manufacturer
--   - Returns the preferred manufacturer part number of given combination of part
--   number and manufacturer.
--   - Returns the preferred manufacturer and manufacturer part number of given
--   part number.
@UncheckedAccess
FUNCTION Get_Preferred_Manufacturer (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   preferred_rec_ part_manu_part_no_tab%ROWTYPE;
BEGIN
   preferred_rec_ := Get_Preferred_Object___(part_no_, manufacturer_no_);
   RETURN(preferred_rec_.manu_part_no);
END Get_Preferred_Manufacturer;


-- Get_Preferred_Manufacturer
--   - Returns the preferred manufacturer part number of given combination of part
--   number and manufacturer.
--   - Returns the preferred manufacturer and manufacturer part number of given
--   part number.
@UncheckedAccess
PROCEDURE Get_Preferred_Manufacturer (
   manufacturer_no_ OUT VARCHAR2,
   manu_part_no_    OUT VARCHAR2,
   part_no_         IN  VARCHAR2 )
IS
   preferred_rec_ part_manu_part_no_tab%ROWTYPE;
BEGIN
   preferred_rec_ := Get_Preferred_Object___(part_no_, manufacturer_no_);
   manufacturer_no_ := preferred_rec_.manufacturer_no;
   manu_part_no_ := preferred_rec_.manu_part_no;
END Get_Preferred_Manufacturer;


-- Part_Manufacturer_Exist
--   - Checks if given manufacturer is valid for given part number. An error is
--   raised if the manufacturer is not valid for given part.
--   - Checks if given manufacturer is valid for given part number and returns
--   either 'TRUE' or 'FALSE' depending on the result.
@UncheckedAccess
PROCEDURE Part_Manufacturer_Exist (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Part_Manufacturer_Exist___(part_no_, manufacturer_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'PARTMANUFNOTEXIST: Manufacturer :P1 is not valid for part :P2.', manufacturer_no_, part_no_);
   END IF;
END Part_Manufacturer_Exist;


-- Part_Manufacturer_Exist
--   - Checks if given manufacturer is valid for given part number. An error is
--   raised if the manufacturer is not valid for given part.
--   - Checks if given manufacturer is valid for given part number and returns
--   either 'TRUE' or 'FALSE' depending on the result.
@UncheckedAccess
FUNCTION Part_Manufacturer_Exist (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   retval_ VARCHAR2(5);
BEGIN
   IF (Part_Manufacturer_Exist___(part_no_, manufacturer_no_)) THEN
      retval_ := 'TRUE';
   ELSE
      retval_ := 'FALSE';
   END IF;
   RETURN(retval_);
END Part_Manufacturer_Exist;


-- Set_Preferred_Manu_Part
--   Will set the currently select manu_part to the preferred one.
--   Will remove the flag on the old record
PROCEDURE Set_Preferred_Manu_Part (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2,
   manu_part_no_    IN VARCHAR2 )
IS
   newrec_        part_manu_part_no_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, manufacturer_no_, manu_part_no_ );
   newrec_.preferred_manu_part := Fnd_Boolean_API.DB_TRUE;
   Modify___(newrec_);
END Set_Preferred_Manu_Part;


-- Copy
--   Method creates new instance and copies all editable attributes
--   from old manufacturer part
PROCEDURE Copy (
   from_part_no_             IN VARCHAR2,
   from_manufacturer_no_     IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   to_manufacturer_no_       IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 ) 
IS
   newrec_       part_manu_part_no_tab%ROWTYPE;
   oldrec_found_ BOOLEAN := FALSE;

   CURSOR    get_part_manufacturer_part IS
      SELECT *
        FROM part_manu_part_no_tab
       WHERE part_no         = from_part_no_
         AND manufacturer_no = from_manufacturer_no_;
BEGIN

   FOR manufact_part_rec_ IN get_part_manufacturer_part LOOP
      --check whether manu_part_no already exist for to_part_no and to_manufacturer_no_
      IF (Check_Exist___(to_part_no_, to_manufacturer_no_, manufact_part_rec_.manu_part_no)) THEN
         IF(error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Exist(lu_name_, 'MANFACTPARTEXIST: Manufacturer Part :P1 exist for part :P2 for manufacturer :P3.', manufact_part_rec_.manu_part_no, to_part_no_, to_manufacturer_no_);
         END IF;
      ELSE
         newrec_     := NULL;
         newrec_.part_no              := to_part_no_;
         newrec_.manufacturer_no      := to_manufacturer_no_;
         newrec_.manu_part_no         := manufact_part_rec_.manu_part_no;
         newrec_.comm_gen_description := manufact_part_rec_.comm_gen_description;
         newrec_.approved_note        := manufact_part_rec_.approved_note;
         newrec_.manufacturer_mtbf    := manufact_part_rec_.manufacturer_mtbf;
         newrec_.manufacturer_mttr    := manufact_part_rec_.manufacturer_mttr;
         newrec_.experienced_mtbf     := manufact_part_rec_.experienced_mtbf;
         newrec_.experienced_mttr     := manufact_part_rec_.experienced_mttr;
         newrec_.mtbf_mttr_unit       := manufact_part_rec_.mtbf_mttr_unit;
         newrec_.catalog_price        := manufact_part_rec_.catalog_price;
         newrec_.catalog_currency     := manufact_part_rec_.catalog_currency;
         newrec_.approved             := manufact_part_rec_.approved;
         New___(newrec_);
      END IF;
      oldrec_found_ := TRUE;
   END LOOP;

   --check whether manu_part_no doesn't exist for from_part_no and from_manufacturer_no_   
   IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN
      Error_SYS.Record_Not_Exist(lu_name_,'MANFACTPARTNOTEXIST: Manufacturer Part does not exist for Part :P1 and Manufacturer :P2', from_part_no_, from_manufacturer_no_);
   END IF;
END Copy;


@UncheckedAccess
FUNCTION Get_Manu_Part_Count (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM part_manu_part_no_tab
      WHERE part_no = part_no_
      AND   manufacturer_no = manufacturer_no_;  
BEGIN
   OPEN get_count;
   FETCH get_count INTO temp_;
   CLOSE get_count;
   RETURN temp_;
END Get_Manu_Part_Count;


-- Get_Preferred_Manu_Part
--   Will return the preferred manu part no for the given
--   part_no and manufacturer_no
@UncheckedAccess
FUNCTION Get_Preferred_Manu_Part (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_manu_part_no_tab.manu_part_no%TYPE;
   CURSOR get_attr IS
      SELECT manu_part_no
      FROM part_manu_part_no_tab
      WHERE  part_no = part_no_
      AND manufacturer_no = manufacturer_no_
      AND preferred_manu_part = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Preferred_Manu_Part;



