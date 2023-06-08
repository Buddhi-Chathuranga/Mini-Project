-----------------------------------------------------------------------------
--
--  Logical unit: PartManufacturer
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201222  SBalLK  Issue SC2020R1-11830, Modified Reset_Pref_Manufacturer___(), Set_Preferred_Manufacturer() and Copy() methods by
--  201222          removing attr_ functionality to optimize the performance.
--  100423  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060120  JaBalk  Modified Copy to pass PREFERRED_MANUFACTURER_DB instead of PREFERRED_MANUFACTURER.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050908  SaMelk  Remove SUBSTRB from PART_MANUFACTURER and PART_MANUFACTURER_LOV.
--  050620  RoJalk  Bug 51743, Removed the method Validate_Items___. Added Reset_Pref_Manufacturer___
--  050620          which is called from Update___ and Insert___.Removed the code related to Bug Id 40649 from Prepare_Insert___.
--  050620          Modified Set_Preferred_Manufacturer and removed direct UPDATE statements. Associated the LU with
--  050620          FndBoolean IID to get the preferred_manufacturer column. Added Get_Preferred_Manufacturer_Db and modified
--  050620          Get_Preferred_Manufacturer to include decode statement.Added PART_MANUFACTURER_LOV and added undefines.
--  050620          Method name changed from Check_Set_Preferred_Manuf___ to Manufacturer_Exists___.
--  050209  KeFelk  Added logic to Copy() in order to deal when to_part alraedy have a Preferred Manufacturer.
--  050119  KeFelk  Changed Error_SYS.Record_Not_Exist to Error_SYS.Record_Exist in Copy.
--  041216  KeFelk  Removed default data in Copy Parameters.
--  041211  JaBalk  Modified procedure Copy to Initialize variables newrec_,objid_ and objversion_ to NULL.
--  041209  KanGlk  Added procedure Copy
--  040429  ChFolk  Bug 40649, Added FUNCTION Not_Preferred_Manuf_Exist. Modified method Check_Delete___.
--  040429          Modified methods Prepare_Insert___ and Insert___ to set the first created manufacturer is preferred.
--  040224  LoPrlk  Removed substrb from code. &VIEW was altered.
--  040113  ISANLK  Removed Public cursor Get_All_Manufacturers.
--  040102  ISANLK  Merged derived column Name to aviod the red codes.
--  ----------------------12.3.0---------------------------------------
--  031002  ThGulk Changed substr to substrb, instr to instrb, length to lengthb.
--  030229  GeKaLk  Modified PART_MANUFACTURER view to add manufacturer name.
--  030225  AnLaSe  Used Design to update file after changing rowversion to use type date.
--  030221  Shvese  Changed rowversion from number to date.
--  *****************TSO Merge***********************************************
--  021011  SAABLK  Call ID 89445 - Made preferred_manufacturer insertable.
--  020722  ThAjLK  Call Id 86603 - Modified the Function Get_Preferred_Manufacturer(part_no)
--  020620  jagrno  Minor corrections.
--  020613  jagr    Corrected error in Set_Preferred_Manufacturer.
--  020605  ToFj    Updated in accordance with spec
--  020515  pask    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Manufacturer_Exists___ (
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR exist_part_ IS
      SELECT    1
      FROM   part_manufacturer_tab
      WHERE  part_no = part_no_;
   --
   dummy_ NUMBER;
   found_ BOOLEAN;
BEGIN
   OPEN exist_part_;
   FETCH exist_part_ INTO dummy_;
   found_ := NOT exist_part_%FOUND;
   CLOSE exist_part_;
   RETURN found_;
END Manufacturer_Exists___;


-- Reset_Pref_Manufacturer___
--   This method will set preferred_manufacturer 'FALSE' for all records for a given part_no.
PROCEDURE Reset_Pref_Manufacturer___ (
   part_no_ IN VARCHAR2 )
IS
   newrec_            part_manufacturer_tab%ROWTYPE;
   CURSOR get_manufacturer_no IS
      SELECT manufacturer_no
      FROM   part_manufacturer_tab
      WHERE  part_no = part_no_
      AND    preferred_manufacturer = 'TRUE'
      FOR UPDATE;
BEGIN
   FOR manufacturer_no_rec IN get_manufacturer_no LOOP
      newrec_ := Lock_By_Keys___(part_no_, manufacturer_no_rec.manufacturer_no);
      newrec_.preferred_manufacturer := Fnd_Boolean_API.DB_FALSE;
      Modify___(newrec_);
   END LOOP;
END Reset_Pref_Manufacturer___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PREFERRED_MANUFACTURER_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('QUALIFIED_MANUFACTURER_DB', 'FALSE', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_manufacturer_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.qualified_manufacturer IS NULL) THEN
      newrec_.qualified_manufacturer := Fnd_Boolean_API.DB_FALSE;
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_manufacturer_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- server defaults
   newrec_.date_created := sysdate;
   Client_SYS.Add_To_Attr('DATE_CREATED', newrec_.date_created, attr_);
   newrec_.user_created := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('USER_CREATED', newrec_.user_created, attr_);
   newrec_.date_changed := newrec_.date_created;
   Client_SYS.Add_To_Attr('DATE_CHANGED', newrec_.date_changed, attr_);
   newrec_.user_changed := newrec_.user_created;
   Client_SYS.Add_To_Attr('USER_CHANGED', newrec_.user_changed, attr_);

   IF (Manufacturer_Exists___(newrec_.part_no)) THEN
      newrec_.preferred_manufacturer := 'TRUE';
      Client_SYS.Add_To_Attr('PREFERRED_MANUFACTURER_DB', newrec_.preferred_manufacturer, attr_);
   ELSE
      IF (newrec_.preferred_manufacturer = 'TRUE') THEN
         Reset_Pref_Manufacturer___ (newrec_.part_no);
      END IF;
   END IF;

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     part_manufacturer_tab%ROWTYPE,
   newrec_     IN OUT part_manufacturer_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   -- server defaults
   newrec_.date_changed := sysdate;
   newrec_.user_changed := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('DATE_CHANGED', newrec_.date_changed, attr_);
   Client_SYS.Add_To_Attr('USER_CHANGED', newrec_.user_changed, attr_);

   IF ((oldrec_.preferred_manufacturer = 'FALSE') AND (newrec_.preferred_manufacturer = 'TRUE')) THEN
      Reset_Pref_Manufacturer___(newrec_.part_no);
   END IF;
   --
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN part_manufacturer_tab%ROWTYPE )
IS
BEGIN
   IF (remrec_.preferred_manufacturer = 'TRUE' AND (Not_Preferred_Manuf_Exist(remrec_.part_no) = 'TRUE')) THEN
      Error_SYS.Record_General(lu_name_, 'DEL_PREF_MANUF_: It is not possible to remove the preferred manufacturer when other Manufacturers exist.');
   END IF;
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   part_no_ IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'NOTEXIST: Manufacturer :P1 does not exist for part :P2.', manufacturer_no_, part_no_);
   super(part_no_, manufacturer_no_);
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Set_Preferred_Manufacturer
--   Will set the currently select manufacturer to the preferred one
--   for the given Part No. Will reset any old rows to FALSE
PROCEDURE Set_Preferred_Manufacturer (
   part_no_         IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 )
IS
   newrec_       part_manufacturer_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, manufacturer_no_);
   newrec_.preferred_manufacturer := Fnd_Boolean_API.DB_TRUE;
   Modify___(newrec_);
END Set_Preferred_Manufacturer;


-- Not_Preferred_Manuf_Exist
--   This method returns 'TRUE' when one or more manufacturers exist for
--   the given part in addition to the preferred manufacturer.
--   Otherwise it returns 'FALSE'.
@UncheckedAccess
FUNCTION Not_Preferred_Manuf_Exist (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_  NUMBER := 0;

   CURSOR not_preferred_manuf_exist IS
      SELECT 1
      FROM part_manufacturer_tab
      WHERE part_no = part_no_
      AND preferred_manufacturer = 'FALSE';
BEGIN
   OPEN not_preferred_manuf_exist;
   FETCH not_preferred_manuf_exist INTO dummy_;
   CLOSE not_preferred_manuf_exist;
   IF (dummy_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Not_Preferred_Manuf_Exist;


-- Copy
--   Method creates new instance and copies all editable attributes
--   from old manufacturer part
PROCEDURE Copy (
   from_part_no_             IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_                    part_manufacturer_tab%ROWTYPE;
   oldrec_found_              BOOLEAN:= FALSE;
   preferred_manufacturer_no_ part_manufacturer_tab.manufacturer_no%TYPE;

   CURSOR get_part_manufacturer IS
      SELECT manufacturer_no, preferred_manufacturer, note, qualified_manufacturer
        FROM part_manufacturer_tab
       WHERE part_no = from_part_no_
    ORDER BY preferred_manufacturer desc;
BEGIN

   preferred_manufacturer_no_ := Get_Preferred_Manufacturer(to_part_no_);
   
   FOR manufact_rec_ IN get_part_manufacturer LOOP
      oldrec_found_ := TRUE;
      IF (Check_Exist___(to_part_no_, manufact_rec_.manufacturer_no)) THEN
         IF(error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Exist(lu_name_, 'MANFACTEXIST: Manufacturer :P1 exist for part :P2.', manufact_rec_.manufacturer_no, to_part_no_);
         END IF;   
      ELSE      
         --Initialize variables
         newrec_ := NULL;
         newrec_.part_no                := to_part_no_;
         newrec_.manufacturer_no        := manufact_rec_.manufacturer_no;
         newrec_.note                   := manufact_rec_.note;
         newrec_.qualified_manufacturer := manufact_rec_.qualified_manufacturer;
         newrec_.preferred_manufacturer := manufact_rec_.preferred_manufacturer;
         IF (newrec_.preferred_manufacturer  = Fnd_Boolean_API.DB_TRUE AND preferred_manufacturer_no_ IS NOT NULL) THEN
           newrec_.preferred_manufacturer := Fnd_Boolean_API.DB_FALSE;
         END IF;
         New___(newrec_);
         
         Part_Manu_Part_No_API.Copy(from_part_no_,
                                    manufact_rec_.manufacturer_no,
                                    to_part_no_,
                                    manufact_rec_.manufacturer_no, 
                                    error_when_no_source_,
                                    error_when_existing_copy_);
      END IF;
   END LOOP;
   
   IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN 
      Error_SYS.Record_Not_Exist(lu_name_,'MANFACTNOTEXIST: Manufacturer does not exist for part :P1', from_part_no_);        
   END IF;      

END Copy;


-- Get_Preferred_Manufacturer
--   Will return the preferred Manufacturer for the give Part No
@UncheckedAccess
FUNCTION Get_Preferred_Manufacturer (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_manufacturer_tab.manufacturer_no%TYPE;
   CURSOR get_attr IS
      SELECT manufacturer_no
      FROM part_manufacturer_tab
      WHERE part_no = part_no_
      AND   preferred_manufacturer = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Preferred_Manufacturer;

@UncheckedAccess
FUNCTION Approval_Connection_Available (
   lu_name_ IN VARCHAR2,
   service_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Object_Connection_SYS.Is_Connection_Aware(lu_name_, service_name_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Approval_Connection_Available;
