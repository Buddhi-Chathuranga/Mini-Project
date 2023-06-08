-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartLanguageDesc
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210113  MaEelk  SC2020R1-12091, Modified Copy and replaced Unpack___, Check_Insert___ and Insert___ with New___.
--  170207  RiHoSE  Added public methods New and Modify_Description.
--  150122  MaRalk  PRSC-5351, Added Check_Catalog_No_Ref___ custom validation to check exist of sales part.  
--  110708  MaMalk  Added user allowed site filteration to SALES_PART_LANGUAGE_DESC.
--  090925  MaMalk  Removed unused view SALES_PART_LANGUAGE_DESC_PUB.
--  ------------------------- 14.0.0 ----------------------------------------
--  080306  MaMalk Bug 70852, Added method Copy to copy sales part language descriptions from one sales part to another.
--  060601  MiErlk  Enlarge Identity - Changed view comments - Description.
--  060119  MaHplk Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  ----------------------------13.3.0-------------------------------------------
--  020103  JICE  Added public view for Sales Configurator export
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  980527  JOHW  Removed uppercase on COMMENT ON COLUMN &VIEW..catalog_desc
--  971125  TOOS  Upgrade to F1 2.0
--  971104  RoNi  note_id.nextval changed to Document_Text_API.Get_Next_Note_Id
--  970508  JoAn  Changed reference for language_code to ApplicationLanguage
--  970312  RaKu  Changed table name.
--  970219  JOED  Changed objversion.
--  960216  SVLO  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE New (
   contract_      IN VARCHAR2,
   catalog_no_    IN VARCHAR2,
   language_code_ IN VARCHAR2,
   catalog_desc_  IN VARCHAR2 )
IS
   newrec_ SALES_PART_LANGUAGE_DESC_TAB%ROWTYPE;
BEGIN
   newrec_.contract      := contract_;
   newrec_.catalog_no    := catalog_no_;
   newrec_.language_code := language_code_;
   newrec_.catalog_desc  := catalog_desc_;
   New___(newrec_);
END New;


PROCEDURE Modify_Description (
   contract_      IN VARCHAR2,
   catalog_no_    IN VARCHAR2,
   language_code_ IN VARCHAR2,
   catalog_desc_  IN VARCHAR2 )
IS
   record_ SALES_PART_LANGUAGE_DESC_TAB%ROWTYPE;
BEGIN
   record_ := Lock_By_Keys___(contract_, catalog_no_, language_code_);
   record_.catalog_desc := catalog_desc_;
   Modify___(record_);
END Modify_Description;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_PART_LANGUAGE_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT Document_Text_API.Get_Next_Note_Id INTO newrec_.note_id FROM DUAL;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN SALES_PART_LANGUAGE_DESC_TAB%ROWTYPE )
IS
BEGIN
   Document_Text_API.Remove_Note(remrec_.note_id);
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_part_language_desc_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (indrec_.contract = FALSE) THEN
      newrec_.contract := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   END IF;
   super(newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

-- Check_Catalog_No_Ref___
--   Perform validation on the CatalogNoRef reference.
PROCEDURE Check_Catalog_No_Ref___ (
   newrec_ IN OUT sales_part_language_desc_tab%ROWTYPE )
IS
BEGIN
   Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, Sales_Part_API.Get_Sales_Type_Db(newrec_.contract, newrec_.catalog_no));  
END;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Copy the sales part language descriptions from one part to another
PROCEDURE Copy (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_        SALES_PART_LANGUAGE_DESC_TAB%ROWTYPE;
   oldrec_found_  BOOLEAN := FALSE;
  
   CURSOR    get_lang_rec IS
      SELECT *
      FROM  SALES_PART_LANGUAGE_DESC_TAB
      WHERE catalog_no = from_part_no_
      AND   contract = from_contract_;
BEGIN

   FOR oldrec_ IN get_lang_rec LOOP
      oldrec_found_ := TRUE;
      IF (Check_Exist___(to_contract_, to_part_no_, oldrec_.language_code)) THEN
         IF (error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Exist(lu_name_, 'SPLANGEXIST: Language description :P1 already exists for part :P2 on site :P3.', oldrec_.language_code, to_part_no_, to_contract_);
         END IF;
      ELSE
         newrec_       := NULL;
         
         newrec_.contract := to_contract_;
         newrec_.catalog_no := to_part_no_;
         newrec_.language_code := oldrec_.language_code;
         newrec_.catalog_desc := oldrec_.catalog_desc;                         
         New___(newrec_);
                  
         IF ((oldrec_.note_id IS NOT NULL) AND (newrec_.note_id IS NOT NULL)) THEN
            Document_Text_API.Copy_All_Note_Texts(oldrec_.note_id,
                                                  newrec_.note_id);
         END IF;
         
      END IF;
   END LOOP;

   IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'SPLANGNOTEXIST: Language descriptions do not exist for Part :P1 on Site :P2', from_part_no_, from_contract_);
   END IF;
END Copy;



