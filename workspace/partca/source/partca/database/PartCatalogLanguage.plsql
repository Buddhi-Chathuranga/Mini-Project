-----------------------------------------------------------------------------
--
--  Logical unit: PartCatalogLanguage
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201218  SBalLK  Issue SC2020R1-11830, Modified Copy() method by removing attr_ functionality to optimize the performance.
--  170207  RiHoSE  Added public methods New and Modify_Description.
--  130729  MaIklk   TIBE-1042, Removed global constants and used conditional compilation instead.
--  100917  DAYJLK   Bug 89720, Added procedures Update_Cache___ and Invalidate_Cache___, and relevant
--  100917           variables that are required for the implementation of micro cache functionality. 
--  100917           Modified functions Get_Description, and Get_Note_Id to use micro cache functions.
--  100423  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- 13.0.0 -----------------------------------
--  080524  Prawlk   Bug 74004, Changed PROCEDURE Copy to call Document_Text_API.Copy_All_Note_Texts 
--  080524           method dynamically.
--  080326  MaEelk   Bug 70852, Added method Copy to supprt Language Description in Copy Part functionality.
--  070409  IsAnlk   Added column note_id and modified Insert___ to get next note_id from Document_Text.
--  060725  NaWilk   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE New (
   part_no_       IN VARCHAR2,
   language_code_ IN VARCHAR2,
   description_   IN VARCHAR2 )
IS
   newrec_ part_catalog_language_tab%ROWTYPE;
BEGIN
   newrec_.part_no       := part_no_;
   newrec_.language_code := language_code_;
   newrec_.description   := description_;
   New___(newrec_);
END New;


PROCEDURE Modify_Description (
   part_no_       IN VARCHAR2,
   language_code_ IN VARCHAR2,
   description_   IN VARCHAR2 )
IS
   record_ part_catalog_language_tab%ROWTYPE;
BEGIN
   record_ := Lock_By_Keys___(part_no_, language_code_);
   record_.description := description_;
   Modify___(record_);
END Modify_Description;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_catalog_language_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN

   $IF (Component_Mpccom_SYS.INSTALLED) $THEN
      newrec_.note_id := Document_Text_API.Get_Next_Note_Id; 
   $END

   Client_SYS.Set_Item_Value('NOTE_ID', newrec_.note_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Method creates new instance and copies all language descriptions from the old part
PROCEDURE Copy (
   from_part_no_             IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_         part_catalog_language_tab%ROWTYPE;
   CURSOR get_lang_rec IS
      SELECT *
      FROM  part_catalog_language_tab
      WHERE part_no = from_part_no_;

   TYPE Lang_Rec_Tab IS TABLE OF get_lang_rec%ROWTYPE INDEX BY PLS_INTEGER;
   lang_rec_tab_ Lang_Rec_Tab;

BEGIN
   OPEN  get_lang_rec;
   FETCH get_lang_rec BULK COLLECT INTO lang_rec_tab_;
   CLOSE get_lang_rec;

   IF (lang_rec_tab_.COUNT = 0) THEN
      IF (error_when_no_source_ = 'TRUE') THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'PARTLANNOTEXIST: Language descriptions do not exist for Part :P1', from_part_no_);
      END IF;
   ELSE
      FOR i IN lang_rec_tab_.FIRST..lang_rec_tab_.LAST LOOP
         IF (Check_Exist___(to_part_no_, lang_rec_tab_(i).language_code)) THEN
            IF (error_when_existing_copy_ = 'TRUE') THEN
               Error_SYS.Record_Exist(lu_name_, 'PARTLANEXIST: Language description :P1 already exists for part :P2.', 
                                      lang_rec_tab_(i).language_code, to_part_no_ );
            END IF;
         ELSE
            newrec_.part_no       := to_part_no_;
            newrec_.language_code := lang_rec_tab_(i).language_code;
            newrec_.description   := lang_rec_tab_(i).description;
            New___(newrec_);
            
            $IF (Component_Mpccom_SYS.INSTALLED) $THEN             
               Document_Text_API.Copy_All_Note_Texts(lang_rec_tab_(i).note_id, newrec_.note_id);                
            $END
           
         END IF;
      END LOOP;
   END IF;
END Copy;



