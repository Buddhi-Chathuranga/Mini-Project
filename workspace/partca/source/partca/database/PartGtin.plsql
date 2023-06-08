-----------------------------------------------------------------------------
--
--  Logical unit: PartGtin
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201222  SBalLK  Issue SC2020R1-11830, Modified Reset_Default_Gtin___(), Set_Default_Gtin__() and New() methods by
--  201222          removing attr_ functionality to optimize the performance.
--  190925  DaZase  SCSPRING20-118, Added Raise_Default_Gtin_Error___() to solve MessageDefinitionValidation issue.
--  190819  ErRalk  Bug 149226(SCZ-6170), Moved error message IDENTYGTINEXISTS into Check_Common___ and modified condition to not 
--  190819          able to save the same GTIN for both package level and part level. 
--  120323  NaLrlk  Modified Unpack_Check_Insert___ to avoid the IDENTYGTINEXISTS error when current part is identified gtin part. 
--  120314  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method at Set_Default_Gtin__
--  120112  NaLrlk  SCE23 - Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_             CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

db_false_            CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Reset_Default_Gtin___ (
   part_no_ IN VARCHAR2 )
IS
   newrec_       part_gtin_tab%ROWTYPE;
   gtin_no_      part_gtin_tab.gtin_no%TYPE;

   CURSOR get_default_gtin IS
      SELECT gtin_no
      FROM   part_gtin_tab
      WHERE  part_no      = part_no_
      AND    default_gtin = db_true_
      FOR UPDATE;
BEGIN
   OPEN get_default_gtin;
   FETCH get_default_gtin INTO gtin_no_;
   IF (get_default_gtin%FOUND) THEN
      newrec_ := Lock_By_Keys___(part_no_, gtin_no_);
      newrec_.default_gtin := db_false_;
      Modify___(newrec_);
   END IF;
   CLOSE get_default_gtin;
END Reset_Default_Gtin___;

PROCEDURE Raise_Default_Gtin_Error___ 
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DEFAULTGTINERR: A default GTIN must be used for identification.');
END Raise_Default_Gtin_Error___;   

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('USED_FOR_IDENTIFICATION_DB', db_true_, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_GTIN_DB', db_false_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_gtin_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF Get_Default_Gtin_No(newrec_.part_no) IS NOT NULL THEN
      IF (newrec_.default_gtin = db_true_) THEN
         Reset_Default_Gtin___ (newrec_.part_no);
      END IF;
   ELSIF (newrec_.used_for_identification = db_true_) THEN
      newrec_.default_gtin := db_true_;
   END IF;
   Client_SYS.Add_To_Attr('USED_FOR_IDENTIFICATION_DB', newrec_.used_for_identification, attr_);
   Client_SYS.Add_To_Attr('IDENTIFICATION_DATE_CHANGED', newrec_.identification_date_changed, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_GTIN_DB', newrec_.default_gtin, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     part_gtin_tab%ROWTYPE,
   newrec_     IN OUT part_gtin_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF ((oldrec_.default_gtin = db_false_) AND (newrec_.default_gtin = db_true_)) THEN
      Reset_Default_Gtin___(newrec_.part_no);
   END IF;
   IF (newrec_.used_for_identification != oldrec_.used_for_identification) THEN
      newrec_.identification_date_changed := SYSDATE;
   END IF;
   Client_SYS.Add_To_Attr('IDENTIFICATION_DATE_CHANGED', newrec_.identification_date_changed, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_GTIN_DB', newrec_.default_gtin, attr_);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_gtin_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT indrec_.identification_date_changed THEN 
     newrec_.identification_date_changed := SYSDATE;
   END IF;
   IF NOT indrec_.auto_created_gtin THEN
      newrec_.auto_created_gtin          := db_false_;
   END IF;
   IF NOT indrec_.used_for_identification THEN
      newrec_.used_for_identification    := db_true_;
   END IF;
   IF NOT indrec_.default_gtin THEN
      newrec_.default_gtin               := db_false_;
   END IF;

   super(newrec_, indrec_, attr_);

   Gtin_Factory_Util_API.Validate_Gtin_Digits(newrec_.gtin_no, newrec_.gtin_series);
   IF (newrec_.used_for_identification = db_false_ AND newrec_.default_gtin = db_true_) THEN
      Raise_Default_Gtin_Error___;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     part_gtin_tab%ROWTYPE,
   newrec_ IN OUT part_gtin_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_   VARCHAR2(4000);   
BEGIN
   
   super(oldrec_, newrec_, indrec_, attr_);

   IF ((newrec_.used_for_identification = db_false_) AND (oldrec_.used_for_identification = db_true_)) THEN
      IF (newrec_.default_gtin = db_true_) THEN
         newrec_.default_gtin := db_false_;
      END IF;
   END IF;
   IF (newrec_.default_gtin  != oldrec_.default_gtin) THEN
      IF (newrec_.used_for_identification = db_false_ AND newrec_.default_gtin = db_true_) THEN
         Raise_Default_Gtin_Error___;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     part_gtin_tab%ROWTYPE,
   newrec_ IN OUT part_gtin_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   identified_gtin_part_  part_gtin_tab.part_no%TYPE;
BEGIN
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (Validate_SYS.Is_Changed(oldrec_.used_for_identification, newrec_.used_for_identification) AND newrec_.used_for_identification = db_true_) THEN   
      identified_gtin_part_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(newrec_.gtin_no);
      IF (identified_gtin_part_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'IDENTYGTINEXISTS: This GTIN is used for identifying another part catalog entry :P1. You cannot use the same GTIN for identification of this part.', identified_gtin_part_);
      END IF;   
   END IF;  
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Set_Default_Gtin__
--   Will set the given GTIN no to the default one.
PROCEDURE Set_Default_Gtin__ (
   part_no_ IN VARCHAR2,
   gtin_no_ IN VARCHAR2 ) 
IS
   newrec_       part_gtin_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, gtin_no_);
   newrec_.default_gtin := db_true_;
   Modify___(newrec_);
END Set_Default_Gtin__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Part_Via_Identified_Gtin
--   Return part no for specified gtin no if the given GTIN
--   is checked with used_for_identification.
@UncheckedAccess
FUNCTION Get_Part_Via_Identified_Gtin (
   gtin_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_part_no IS
      SELECT part_no
      FROM   part_gtin_tab
      WHERE  gtin_no = gtin_no_
      AND    used_for_identification = db_true_;
   part_no_ part_gtin_tab.part_no%TYPE;
BEGIN
   OPEN get_part_no;
   FETCH get_part_no INTO part_no_;
   IF (get_part_no%NOTFOUND) THEN
      part_no_ := Part_Gtin_Unit_Meas_API.Get_Part_Via_Identified_Gtin(gtin_no_);
   END IF;
   CLOSE get_part_no;
   RETURN part_no_;
END Get_Part_Via_Identified_Gtin;


-- Get_Default_Gtin_No
--   Return default Gtin for specified part no.
@UncheckedAccess
FUNCTION Get_Default_Gtin_No (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   gtin_no_ part_gtin_tab.gtin_no%TYPE;
   CURSOR get_gtin_no IS
      SELECT gtin_no
      FROM   part_gtin_tab
      WHERE  part_no = part_no_
      AND    default_gtin = db_true_;
BEGIN
   OPEN get_gtin_no;
   FETCH get_gtin_no INTO gtin_no_;
   CLOSE get_gtin_no;
   RETURN gtin_no_;
END Get_Default_Gtin_No;


-- New
--   Inserts new Part Gtin record
PROCEDURE New (
   part_no_                     IN VARCHAR2,
   gtin_no_                     IN VARCHAR2,
   gtin_series_db_              IN VARCHAR2,
   used_for_identification_db_  IN VARCHAR2,
   auto_created_gtin_db_        IN VARCHAR2,
   default_gtin_db_             IN VARCHAR2 )
IS
   newrec_      part_gtin_tab%ROWTYPE;
BEGIN
   newrec_.part_no                 := part_no_;
   newrec_.gtin_no                 := gtin_no_;
   newrec_.gtin_series             := gtin_series_db_;
   newrec_.used_for_identification := used_for_identification_db_;
   newrec_.auto_created_gtin       := auto_created_gtin_db_;
   newrec_.default_gtin            := default_gtin_db_;
   New___(newrec_);
END New;



