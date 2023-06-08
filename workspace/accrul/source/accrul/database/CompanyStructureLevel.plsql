-----------------------------------------------------------------------------
--
--  Logical unit: CompanyStructureLevel
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211224  Tiralk  FI21R2-8199, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     company_structure_level_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY company_structure_level_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   Company_Structure_API.Validate_Structure_Modify(newrec_.structure_id);
   IF instr(newrec_.level_id, '&') > 0 OR instr(newrec_.level_id, '''') > 0 OR instr(newrec_.level_id, '^') > 0 THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHAR: You have entered an invalid character in this field.');
   END IF; 
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@IgnoreUnitTest DMLOperation
PROCEDURE Insert_Level__ (
   structure_id_  IN VARCHAR2,
   level_no_      IN VARCHAR2 )
IS
   level_above_rec_  company_structure_level_tab%ROWTYPE;
   level_above_      company_structure_level_tab.level_above%TYPE;
   newrec_           company_structure_level_tab%ROWTYPE;
   max_level_no_     NUMBER;
   level_id_         NUMBER;
   
   CURSOR max_level_no IS
      SELECT MAX(level_no)
      FROM   company_structure_level_tab
      WHERE  structure_id = structure_id_;
   
BEGIN
   OPEN  max_level_no;
   FETCH max_level_no INTO max_level_no_;
   CLOSE max_level_no;
   
   IF (level_no_ = 0) THEN
      IF (max_level_no_ IS NOT NULL) THEN
         level_id_   := max_level_no_ + 1;
         
         -- If creating New Top Node, update existing Top Node first
         UPDATE company_structure_level_tab
         SET    level_above = level_id_
         WHERE  structure_id = structure_id_
         AND    level_above IS NULL;
         
         -- Update all records by increasing level_no
         UPDATE company_structure_level_tab
         SET    level_no = level_no + 1
         WHERE  structure_id = structure_id_;
         
         newrec_.bottom_level := Fnd_Boolean_API.DB_FALSE;
      ELSE
         -- Insert Top Node
         level_id_            := 1;
         newrec_.bottom_level := Fnd_Boolean_API.DB_TRUE;
      END IF;
      
      newrec_.level_no  := '1';
      level_above_      := NULL;
      newrec_.structure_id := structure_id_;
      newrec_.level_id     := level_id_;
      newrec_.description  := '<'||level_id_||'>';
      newrec_.level_above  := level_above_;
      New___(newrec_);
   ELSIF (max_level_no_ <= level_no_) THEN
      level_above_rec_  := Lock_By_Keys___(structure_id_,
                                           max_level_no_);
      level_above_      := level_above_rec_.level_id;
      
      -- Update bottom level of existing last record before insert a new level
      UPDATE company_structure_level_tab
      SET    bottom_level = 'FALSE'
      WHERE  structure_id = structure_id_
      AND    level_no     = max_level_no_;

      level_id_            := max_level_no_ + 1;
      newrec_.bottom_level := Fnd_Boolean_API.DB_TRUE;
      newrec_.level_no     := level_id_;
      newrec_.structure_id := structure_id_;
      newrec_.level_id     := level_id_;
      newrec_.description  := '<'||level_id_||'>';
      newrec_.level_above  := level_above_;
      New___(newrec_);
   END IF;  
   
END Insert_Level__;


@IgnoreUnitTest DMLOperation
PROCEDURE Delete_Unused_Levels__ (
   structure_id_  IN VARCHAR2 )
IS
   max_level_no_   NUMBER;
   
   CURSOR max_level_no IS
      SELECT MAX(level_no)
      FROM   company_structure_item_tab
      WHERE  structure_id = structure_id_;
BEGIN
   OPEN  max_level_no;
   FETCH max_level_no INTO max_level_no_;
   CLOSE max_level_no;

   DELETE
   FROM  company_structure_level_tab
   WHERE structure_id = structure_id_
   AND   level_no     > max_level_no_;

   UPDATE company_structure_level_tab
   SET    bottom_level = 'TRUE'
   WHERE  structure_id = structure_id_
   AND    level_no     = max_level_no_;
END Delete_Unused_Levels__;


@IgnoreUnitTest DMLOperation
PROCEDURE Copy__ (
   source_structure_id_ IN  VARCHAR2,
   new_structure_id_    IN  VARCHAR2 )
IS 
BEGIN
   INSERT INTO company_structure_level_tab (
         structure_Id,
         level_no,
         level_id,
         description,
         bottom_level,
         level_above,
         rowversion )
   SELECT
         new_structure_id_,
         level_no,
         level_id,
         description,
         bottom_level,
         level_above,
         SYSDATE
   FROM  company_structure_level_tab
   WHERE structure_id = source_structure_id_;
END Copy__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Modify_Level_Id_Info
--   Modifies Level_Id and Description.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify_Level_Id_Info (
   structure_id_  IN VARCHAR2,
   level_no_      IN VARCHAR2,
   level_id_      IN VARCHAR2,
   description_   IN VARCHAR2)
IS
   record_ company_structure_level_tab%ROWTYPE;
BEGIN
   record_              := Lock_By_Keys___(structure_id_, level_no_);
   record_.level_id     := level_id_;
   record_.description  := description_;
   Modify___(record_);
END Modify_Level_Id_Info;