-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalSpecAttr3
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  090812 ChAlLK Modified Update___ method and added two new columns to View TECHNICAL_SPEC_ATTR3 (Bug #82513).
--  060901 UsRaLK Changed TECHNICAL_SPEC_ATTR4 to match the select list of TECHNICAL_SPEC_ATTR3.
--  031016 DHSELK Added Init Method 
--  010612  Larelk Bug22173,Added General_SYS.Init_Method in Modify_Value_By_Lu_Key.  
--  091218  Kanslk Reverse-Engineering, modified view TECHNICAL_SPEC_ATTR3. 
--  130925  chanlk Corrected model file error
--  -------------------------- APPS 9 ---------------------------------------
--  131202  paskno  Hooks: refactoring and splitting.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE TECH_SPEC_ATTR4_RECORD_TYPE IS RECORD (
      technical_spec_no          NUMBER,
      lu_name                    VARCHAR2(30),
      key_ref                    VARCHAR2(600),
      technical_class            VARCHAR2(10),
      attrib_number              NUMBER,
      attrib_type                VARCHAR2(20),
      attribute                  VARCHAR2(15),
      attrib_desc                VARCHAR2(40),
      value_no                   NUMBER,
      value_text                 VARCHAR2(20),
      value                      VARCHAR2(40),
      unit                       VARCHAR2(30),
      objid                      ROWID,
      objversion              VARCHAR2(2000) ,
      objkey                   VARCHAR2(50));


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Lock___ (
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 )
IS
   row_changed EXCEPTION;
   row_deleted EXCEPTION;
   row_locked  EXCEPTION;
   PRAGMA      exception_init(row_locked, -0054);
   dummy_      NUMBER;
   CURSOR lock_control IS
      SELECT 1
      FROM   TECHNICAL_SPECIFICATION_TAB
         WHERE rowid = objid_
         AND    to_char(rowversion,'YYYYMMDDHH24MISS') = objversion_
      FOR UPDATE NOWAIT;
   CURSOR exist_control IS
      SELECT 1
      FROM   TECHNICAL_SPECIFICATION_TAB
      WHERE  rowid = objid_;
BEGIN
   OPEN lock_control;
   FETCH lock_control INTO dummy_;
   IF (lock_control%FOUND) THEN
      CLOSE lock_control;
      RETURN;
   END IF;
   CLOSE lock_control;
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RAISE row_changed;
   ELSE
      CLOSE exist_control;
      RAISE row_deleted;
   END IF;
EXCEPTION
   WHEN row_locked THEN
      Error_SYS.Record_Locked(lu_name_);
   WHEN row_changed THEN
      Error_SYS.Record_Modified(lu_name_);
   WHEN row_deleted THEN
      Error_SYS.Record_Removed(lu_name_);
END Lock___;


FUNCTION Get_Record___ (
   objid_ IN VARCHAR2 ) RETURN TECH_SPEC_ATTR4_RECORD_TYPE
IS
   lu_rec_ TECH_SPEC_ATTR4_RECORD_TYPE;
   CURSOR getrec IS
      SELECT *
      FROM   TECHNICAL_SPEC_ATTR4
      WHERE  OBJID = objid_;
BEGIN
   OPEN getrec;
   FETCH getrec INTO lu_rec_;
   IF (getrec%NOTFOUND) THEN
      Error_SYS.Record_Removed(lu_name_);
   END IF;
   CLOSE getrec;
   RETURN(lu_rec_);
END Get_Record___;


PROCEDURE Get_Objversion___ (
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
BEGIN
   SELECT to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objversion_
      FROM  TECHNICAL_SPECIFICATION_TAB
      WHERE ROWID = objid_;
END Get_Objversion___;


PROCEDURE Get_Id_Version_By_Keys___ (
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   technical_spec_no_ IN NUMBER,
   attribute_ IN VARCHAR2)
IS
   CURSOR get_version IS
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      FROM  TECHNICAL_SPECIFICATION_TAB
      WHERE technical_spec_no = technical_spec_no_
      AND   attribute = attribute_;
BEGIN
   OPEN get_version;
   FETCH get_version INTO objid_, objversion_;
   CLOSE get_version;
END Get_Id_Version_By_Keys___;


-- Unpack_Check_Update___
--   Unpack the attribute list, check all attributes from the client
--   and generate all default values before modifying the object.
PROCEDURE Unpack_Check_Update___ (
   attr_   IN OUT VARCHAR2,
   newrec_ IN OUT TECH_SPEC_ATTR4_RECORD_TYPE,
   objid_  IN     VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'TECHNICAL_SPEC_NO') THEN
         Error_SYS.Item_Update(lu_name_, 'TECHNICAL_SPEC_NO');
      ELSIF (name_ = 'TECHNICAL_CLASS') THEN
         Error_SYS.Item_Update(lu_name_, 'TECHNICAL_CLASS');
      ELSIF (name_ = 'GROUP_ORDER') THEN
         Error_SYS.Item_Update(lu_name_, 'GROUP_ORDER');
      ELSIF (name_ = 'GROUP_NAME') THEN
         Error_SYS.Item_Update(lu_name_, 'GROUP_NAME');
      ELSIF (name_ = 'SPEC_ORDER') THEN
         Error_SYS.Item_Update(lu_name_, 'SPEC_ORDER');
      ELSIF (name_ = 'ATTRIB_TYPE') THEN
         Error_SYS.Item_Update(lu_name_, 'ATTRIB_TYPE');
      ELSIF (name_ = 'ATTRIBUTE') THEN
         Error_SYS.Item_Update(lu_name_, 'ATTRIBUTE');
      ELSIF (name_ = 'VALUE_NO') THEN
         newrec_.value_no := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'VALUE_TEXT') THEN
         newrec_.value_text := value_;
      ELSIF (name_ = 'VALUE') THEN
         IF newrec_.attrib_type = '1' THEN
            newrec_.value_no := Client_SYS.Attr_Value_To_Number(value_);
            newrec_.value_text := NULL;
         ELSE
            newrec_.value_text := value_;
            newrec_.value_no := NULL;
         END IF;
         IF (TECHNICAL_OBJECT_REFERENCE_API.Check_Approved(newrec_.technical_spec_no)) THEN
            Error_SYS.Record_General( 'TechnicalSpecAttr3',
               'NOUPDATEWHENAPPROVED: Not allowed to update attribute when the specification is approved');
         END IF;
      ELSIF (name_ = 'ALT_UNIT') THEN
         IF value_ IS NOT null THEN
           newrec_.unit := value_;
         END IF;
      ELSIF (name_ = 'UNIT') THEN
         IF value_ IS NOT null THEN
           newrec_.unit := value_;
         END IF;
         -- Error_SYS.Item_Update(lu_name_, 'UNIT');
      ELSIF (name_ = 'STD_SQ') THEN
         Error_SYS.Item_Update(lu_name_, 'STD_SQ');
      ELSIF (name_ = 'ATTRIB_DESC') THEN
         Error_SYS.Item_Update(lu_name_, 'ATTRIB_DESC');
      ELSIF (name_ = 'KEY_REF') THEN
         Error_SYS.Item_Update(lu_name_, 'KEY_REF');
      ELSIF (name_ = 'GROUP_DESC') THEN
         Error_SYS.Item_Update(lu_name_, 'GROUP_DESC');
      ELSIF (name_ = 'LU_NAME') THEN
         Error_SYS.Item_Update(lu_name_, 'LU_NAME');
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   Client_SYS.Clear_Attr(attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Unpack_Check_Update___;

PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     TECH_SPEC_ATTR4_RECORD_TYPE,
   newrec_     IN OUT TECH_SPEC_ATTR4_RECORD_TYPE,
   attr_       IN OUT VARCHAR2 )
IS
  alt_value_no_ NUMBER;
  alt_unit_     VARCHAR2(30);
  org_unit_     VARCHAR2(30);
  org_value_no_  NUMBER;
  CURSOR Get_Values_Cur IS
     SELECT a.Value_No, a.Alt_Value_No, b.Unit, a.Alt_Unit
       FROM Technical_Specification_Tab a, Technical_Attrib_Tab b
       WHERE a.TECHNICAL_CLASS = b.TECHNICAL_CLASS
         AND a.ATTRIBUTE = b.ATTRIBUTE
         AND a.Rowid = Objid_;
BEGIN
      FOR Get_Values_Rec IN Get_Values_Cur LOOP
        alt_value_no_ := Get_Values_Rec.alt_value_no;
        alt_unit_ := Get_Values_Rec.alt_unit;
        org_unit_ := Get_Values_Rec.unit;
      END LOOP;
      IF (newrec_.unit != oldrec_.unit) AND (newrec_.value_no IS NOT null) THEN
        IF newrec_.unit = org_unit_ THEN
          alt_value_no_ := null;
          alt_unit_ := null;
        ELSE
          alt_value_no_ := newrec_.value_no;
          alt_unit_ := newrec_.unit;
          newrec_.value_no := Technical_Spec_Numeric_Api.Recalculate_Value(newrec_.value_no, alt_unit_, org_unit_);
        END IF;
      ELSIF (newrec_.unit = oldrec_.unit) AND (newrec_.value_no IS NOT null) THEN
        IF newrec_.unit = org_unit_ THEN
          alt_value_no_ := null;
          alt_unit_ := null;
        ELSIF alt_value_no_ IS NOT null THEN
          alt_value_no_ := newrec_.value_no;
          org_value_no_ := Technical_Spec_Numeric_Api.Recalculate_Value(newrec_.value_no, alt_unit_, org_unit_);
          newrec_.value_no := org_value_no_;
        ELSE
          alt_value_no_ := null;
          alt_unit_ := null;
        END IF;
      ELSE
        alt_value_no_ := null;
        alt_unit_ := null;
      END IF;
      UPDATE technical_specification_tab
      SET value_no = newrec_.value_no,
          value_text = newrec_.value_text,
          alt_value_no = alt_value_no_,
          alt_unit = alt_unit_,
          rowversion = sysdate
      WHERE rowid = objid_;
   
   $IF Component_Plades_SYS.INSTALLED $THEN
      IF ((newrec_.lu_name = 'PlantObject') AND (nvl(newrec_.value,chr(30)) != nvl(oldrec_.value, chr(30)))) THEN
         Plant_Sync_Cross_Ref_Attr_API.Set_Sync_Record(newrec_.lu_name, newrec_.key_ref, newrec_.attribute);
      END IF;
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Lock__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 )
IS
BEGIN
   Lock___(objid_, objversion_);
   info_ := Client_SYS.Get_All_Info;
END Lock__;

PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_ TECH_SPEC_ATTR4_RECORD_TYPE;
   newrec_ TECH_SPEC_ATTR4_RECORD_TYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      newrec_ := Get_Record___(objid_);
      Unpack_Check_Update___(attr_, newrec_, objid_);
   ELSIF (action_ = 'DO') THEN
      Lock___(objid_, objversion_);
      oldrec_ := Get_Record___(objid_);
      newrec_ := oldrec_;
      Unpack_Check_Update___(attr_, newrec_, objid_);
      Update___(objid_, oldrec_, newrec_, attr_);
      Get_Objversion___(objid_, objversion_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Modify_Value_By_Lu_Key (
   luname_ IN VARCHAR2,
   key_ref_ IN VARCHAR2,
   attribute_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
   attr_ VARCHAR2(1000);
   info_ VARCHAR2(1000);
   objid_ VARCHAR2(100);
   objversion_ VARCHAR2(100);
   technical_spec_no_ number;
   attrib_type_ varchar2(1);
   value2_ varchar2(40);
BEGIN
   SELECT technical_spec_no, attrib_type
   INTO technical_spec_no_, attrib_type_
   FROM technical_spec_attr3
   WHERE lu_name = luname_
     AND key_ref = key_ref_
     AND attribute = attribute_;
   IF attrib_type_ = '1' THEN
      value2_ := replace(value_,',','.');
   ELSE
      value2_ := value_;
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('VALUE', value2_, attr_);
   Technical_Spec_Attr3_API.Get_Id_Version_By_Keys___(objid_, objversion_, technical_spec_no_, attribute_);
   Technical_Spec_Attr3_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
EXCEPTION WHEN NO_DATA_FOUND THEN
   NULL;
END Modify_Value_By_Lu_Key;