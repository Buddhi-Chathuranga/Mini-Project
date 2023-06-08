-----------------------------------------------------------------------------
--
--  Logical unit: ObjectProperty
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960903  JaPa  Created
--  960919  JaPa  New function for creating/updating properties.
--  980218  JaPa  Added function for handling of lists. Separator character
--                as parameter to list handling functions.
--  010612  Larelk Bug 22173,Added General_SYS.Init_Method in method Set_Value,Add_Value.
--  020313  bojose bug 28588 increased var lenght attr_ from 200 to2600 in func. Set_Value and Add_Value
--  020609  jagr  Added parameters to methods Add_Value and Set_Value. Added
--                attributes VALIDATION_ENABLED and VALIDATION_METHOD. Added
--                method Validate_Property_Value___.
--  050901  AsWiLk When validation_enabled is checked the property_value should be validated. (Bug#53081)
--  060721  UtGulk Modified Validate_Property_Value___() to make code assert safe (Bug 58228). 
--  100324  PKULLK Updated Validate_Property_Value___ to make dynamic SQL statement 'assert safe' (Bug 84970).
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk Merge rose method documentatio
--  -------------------------- APPS 9 ---------------------------------------
--  131125  paskno  Hooks: refactoring and splitting.
--  140122  jagrno  Modified OBJVERSION from "property_value" to 
--                  "rtrim(rpad(property_value||chr(31)||validation_enabled||chr(31)||validation_method,2000))".
--  -------------------------- STRIKE ---------------------------------------
--  171004   LoPrlk  STRSA-21776, Added the method Remove_Property.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Trim___ (
   text_ IN VARCHAR2,
   sep_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   str_ VARCHAR2(2000) := rtrim(ltrim(replace(text_,' '),sep_),sep_);
BEGIN
   WHILE nvl(instr(str_, sep_||sep_),0) > 0 LOOP
      str_ := replace(str_, sep_||sep_, sep_);
   END LOOP;
   RETURN str_;
END Trim___;


-- Validate_Property_Value___
--   - This new method will call upon the entered validation method if validation
--   has been enabled (TRUE). Do the following to call the validation method:
--   - Check that the logical unit (convert package name to LU name) is installed.
--   - Create dynamic statement:
--   - Validation package+method(
--   - ObjectLu
--   - ObjektKey
--   - PropertyName
--   - PropertyValue)
--   - Execute dynamic statement
--   - This method is called from both UnpackCheckInsert (if validations enabled)
--   and UnpackCheckUpdate (if validations enabled and value has changed).
PROCEDURE Validate_Property_Value___ (
   newrec_ IN OBJECT_PROPERTY_TAB%ROWTYPE )
IS
   package_ VARCHAR2(30);
   oldrec_  OBJECT_PROPERTY_TAB%ROWTYPE;
   stmt_    VARCHAR2(2000);
BEGIN
   IF (newrec_.validation_enabled = 'TRUE') THEN
      oldrec_ := Get_Object_By_Keys___(newrec_.object_lu, newrec_.object_key, newrec_.property_name);
      IF (newrec_.property_value != nvl(oldrec_.property_value, ' ')) OR (NVL(oldrec_.validation_enabled, ' ') = 'FALSE') OR (NVL(newrec_.validation_enabled, ' ') = 'TRUE') THEN
         IF (newrec_.validation_method IS NOT NULL) THEN
            Assert_SYS.Assert_Is_Package_Method(newrec_.validation_method);
            package_ := substr(newrec_.validation_method, 1, instr(UPPER(newrec_.validation_method), '_API.') + 3);
            IF (Transaction_SYS.Package_Is_Active(package_)) THEN
               stmt_ := 'BEGIN '||newrec_.validation_method||'(:object_lu, :object_key, :property_name, :property_value); END;';
               @ApproveDynamicStatement(2010-03-24,pkullk)
               EXECUTE IMMEDIATE stmt_ USING IN newrec_.object_lu, newrec_.object_key, newrec_.property_name, newrec_.property_value;
            ELSE
               Trace_SYS.Message('Package '||package_||' is not installed.');
            END IF;
         END IF;
      END IF;
   END IF;
END Validate_Property_Value___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALIDATION_ENABLED', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     object_property_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY object_property_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- execute custom validations
   IF (newrec_.property_value IS NOT NULL) THEN
      Validate_Property_Value___(newrec_);
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Value
--   Gets the value for the given property and class/object.
@UncheckedAccess
FUNCTION Get_Value (
   object_lu_     IN VARCHAR2,
   object_key_    IN VARCHAR2,
   property_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lu_rec_ OBJECT_PROPERTY_TAB%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(object_lu_, object_key_, property_name_);
   RETURN lu_rec_.property_value;
END Get_Value;


-- Set_Value
--   Sets the value of the property to PropertyValue.
--   Overrides the old value if it exists or creates a new one.
PROCEDURE Set_Value (
   object_lu_          IN VARCHAR2,
   object_key_         IN VARCHAR2,
   property_name_      IN VARCHAR2,
   property_value_     IN VARCHAR2,
   validation_enabled_ IN VARCHAR2 DEFAULT 'FALSE',
   validation_method_  IN VARCHAR2 DEFAULT NULL )
IS
   newrec_      OBJECT_PROPERTY_TAB%ROWTYPE;
   lu_rec_      OBJECT_PROPERTY_TAB%ROWTYPE;
   attr_        VARCHAR2(2600);
   indrec_      Indicator_Rec;
   objid_       VARCHAR2(20);
   objversion_  VARCHAR2(2000);   
BEGIN


   Trace_SYS.message('OBJECT_PROPERTY_API.Set_Value('||object_lu_||','||object_key_||','||property_name_||')');
   Trace_SYS.field('. property_value_', property_value_);
   Client_SYS.Clear_Attr(attr_);
   IF (NOT Check_Exist___(object_lu_, object_key_, property_name_)) THEN   
      Trace_SYS.message('. create new record');
      newrec_.object_lu := object_lu_;
      indrec_.object_lu := TRUE;
      newrec_.object_key := object_key_;
      indrec_.object_key := TRUE;
      newrec_.property_name := property_name_;
      indrec_.property_name := TRUE;
      IF property_value_ is not null THEN
         newrec_.property_value := property_value_;
         indrec_.property_value := TRUE;
      END IF;
      newrec_.validation_enabled := validation_enabled_;
      indrec_.validation_enabled := TRUE;
      IF (validation_method_ IS NOT NULL) THEN
         newrec_.validation_method := validation_method_;
         indrec_.validation_method := TRUE;
      END IF;
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      Trace_SYS.message('. property exists');
      Get_Id_Version_By_Keys___(objid_, objversion_, object_lu_, object_key_, property_name_);
      lu_rec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := lu_rec_;
      newrec_.property_value := property_value_;
      IF ((lu_rec_.validation_enabled = 'FALSE') AND (validation_enabled_ = 'TRUE')) THEN
         newrec_.validation_enabled := validation_enabled_;
      END IF;
      IF (((lu_rec_.validation_method IS NULL) AND (validation_method_ IS NOT NULL)) OR (lu_rec_.validation_method != validation_method_)) THEN
         newrec_.validation_method := validation_method_;
      END IF;
      Update___ (objid_, lu_rec_, newrec_, attr_, objversion_);
   END IF;
END Set_Value;


-- Add_Value
--   Adds the value of the argument PropertyValue to
--   a comma separated list of values if the property already exists,
--   creates a new one with this value otherwise. Check for duplicates.
PROCEDURE Add_Value (
   object_lu_          IN VARCHAR2,
   object_key_         IN VARCHAR2,
   property_name_      IN VARCHAR2,
   property_value_     IN VARCHAR2,
   separator_          IN VARCHAR2 DEFAULT ',',
   validation_enabled_ IN VARCHAR2 DEFAULT 'FALSE',
   validation_method_  IN VARCHAR2 DEFAULT NULL )
IS
   newrec_      OBJECT_PROPERTY_TAB%ROWTYPE;
   lu_rec_      OBJECT_PROPERTY_TAB%ROWTYPE;
   attr_        VARCHAR2(2600);
   value_       VARCHAR2(2000);
   indrec_      Indicator_Rec;
   objid_       VARCHAR2(20);
   objversion_  VARCHAR2(2000);      

BEGIN

   Trace_SYS.message('OBJECT_PROPERTY_API.Add_Value('||object_lu_||','||object_key_||','||property_name_||')');
   Trace_SYS.field('. property_value_', property_value_);

   value_ := Trim___(property_value_, separator_);
   Client_SYS.Clear_Attr(attr_);
   IF (NOT Check_Exist___(object_lu_, object_key_, property_name_)) THEN   
      newrec_.object_lu := object_lu_;
      indrec_.object_lu := TRUE;
      newrec_.object_key := object_key_;
      indrec_.object_key := TRUE;
      newrec_.property_name := property_name_;
      indrec_.property_name := TRUE;
      IF value_ is not null THEN
         newrec_.property_value := property_value_;
         indrec_.property_value := TRUE;
      END IF;
      newrec_.validation_enabled := validation_enabled_;
      indrec_.validation_enabled := TRUE;
      IF (validation_method_ IS NOT NULL) THEN
         newrec_.validation_method := validation_method_;
         indrec_.validation_method := TRUE;
      END IF;
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSIF value_ is not null THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, object_lu_, object_key_, property_name_);
      lu_rec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := lu_rec_;
      newrec_.property_value := Trim___(lu_rec_.property_value, separator_);
      indrec_.property_value := TRUE;
      IF lu_rec_.property_value is null THEN
         newrec_.property_value := value_;
         indrec_.property_value := TRUE;
      ELSIF instr(separator_||lu_rec_.property_value||separator_, separator_||value_||separator_) = 0 THEN
         newrec_.property_value := lu_rec_.property_value || separator_ || value_;
         indrec_.property_value := TRUE;
      END IF;
      IF ((lu_rec_.validation_enabled = 'FALSE') AND (validation_enabled_ = 'TRUE')) THEN
         newrec_.validation_enabled := validation_enabled_;
         indrec_.validation_enabled := TRUE;
      END IF;
      IF (((lu_rec_.validation_method IS NULL) AND (validation_method_ IS NOT NULL)) OR (lu_rec_.validation_method != validation_method_)) THEN
         newrec_.validation_method := validation_method_;
         indrec_.validation_method := TRUE;
      END IF;
      Update___ (objid_, lu_rec_, newrec_, attr_, objversion_);
   END IF;
END Add_Value;


@UncheckedAccess
FUNCTION List_Intersect (
   list1_     IN VARCHAR2,
   list2_     IN VARCHAR2,
   separator_ IN VARCHAR2 DEFAULT ',' ) RETURN VARCHAR2
IS
   lst1_   VARCHAR2(2000) := separator_||Trim___(list1_,separator_)||separator_;
   lst2_   VARCHAR2(2000) := separator_||Trim___(list2_,separator_)||separator_;
   result_ VARCHAR2(2000) := NULL;
   from_   NUMBER         := 2;
   to_     NUMBER;
   group_  VARCHAR2(200);
BEGIN
   LOOP
      to_ := nvl(instr(lst1_, separator_, from_), 0);
      EXIT WHEN to_ = 0;
      IF to_ > from_ THEN
         group_ := substr(lst1_, from_, to_ - from_);
         IF nvl(instr(lst2_, separator_||group_||separator_), 0) > 0 THEN
            IF result_ is null THEN
               result_ := group_;
            ELSE
               result_ := result_ || separator_ || group_;
            END IF;
         END IF;
      END IF;
      from_ := to_ + 1;
   END LOOP;
   RETURN result_;
END List_Intersect;


@UncheckedAccess
FUNCTION Is_In_List (
   list_      IN VARCHAR2,
   element_   IN VARCHAR2,
   separator_ IN VARCHAR2 DEFAULT ',' ) RETURN BOOLEAN
IS
BEGIN
   IF nvl(instr(separator_||Trim___(list_,separator_)||separator_,
                separator_||Trim___(element_,separator_)||separator_), 0) > 0
   THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_In_List;


@UncheckedAccess
FUNCTION Get_Position (
   list_      IN VARCHAR2,
   element_   IN VARCHAR2,
   separator_ IN VARCHAR2 DEFAULT ',' ) RETURN NUMBER
IS
   lst_    VARCHAR2(2000) := separator_||Trim___(list_,separator_)||separator_;
   pos_    NUMBER := 1;
   from_   NUMBER := 2;
   to_     NUMBER;
BEGIN
   LOOP
      to_ := nvl(instr(lst_, separator_, from_), 0);
      EXIT WHEN to_ = 0;
      IF substr(lst_,from_,to_-from_) = Trim___(element_,separator_) THEN
         RETURN pos_;
      END IF;
      pos_ := pos_ + 1;
      from_ := to_ + 1;
   END LOOP;
   RETURN 0;
END Get_Position;


@UncheckedAccess
FUNCTION Get_Element (
   list_      IN VARCHAR2,
   position_  IN NUMBER,
   separator_ IN VARCHAR2 DEFAULT ',' ) RETURN VARCHAR2
IS
   lst_    VARCHAR2(2000) := separator_||Trim___(list_,separator_)||separator_;
   from_   NUMBER;
   to_     NUMBER;
BEGIN
   IF position_ > 0 THEN
      from_ := instr(lst_, separator_, 1, position_) + 1;
      to_   := nvl(instr(lst_, separator_, from_), 0);
      RETURN substr(lst_, from_, to_-from_);
   ELSE
      RETURN null;
   END IF;
END Get_Element;


@UncheckedAccess
FUNCTION Trim_List (
   list_      IN VARCHAR2,
   separator_ IN VARCHAR2 DEFAULT ',' ) RETURN VARCHAR2
IS
BEGIN
   RETURN Trim___(list_,separator_);
END Trim_List;


PROCEDURE Remove_Property (
   object_lu_     IN VARCHAR2,
   object_key_    IN VARCHAR2,
   property_name_ IN VARCHAR2 )
IS
   remrec_        object_property_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(object_lu_, object_key_, property_name_) THEN
      remrec_.object_lu       := object_lu_;
      remrec_.object_key      := object_key_;
      remrec_.property_name   := property_name_;

      Remove___(remrec_);
   END IF;
END Remove_Property;
