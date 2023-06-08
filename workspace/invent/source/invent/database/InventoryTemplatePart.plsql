-----------------------------------------------------------------------------
--
--  Logical unit: InventoryTemplatePart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  111117  NipKlk  Bug 99628, Added procedure Validate_Delete___ to check if other parts exist when deleting
--                  the default template part, Modified Check_Delete___ method to call Validate_Delete___.      
--  111114  NipKlk  Bug 99628, Modified insert___ to call Default_Part_exist() to check if there is a default  
--  111114          template part in the table, Modified Prepare_Insert___ to set 'FALSE' to default_template_part attribute.
--  110708  MaEelk  Added user allowed site filter to INVENTORY_TEMPLATE_PART, INVENTORY_TEMPLATE_PART_LOV 
--  110708          and INVENTORY_TEMPLATE_PART_LOV2.
--  110505  Jeguse  EASTONE-16139, Modified in Insert___ and Get_Default_Template
--  110415  MatKse  EASTONE-14024, Modified Update___ to reset the default_template_part column to FALSE
--                  for all rows in INVENTORY_TEMPLATE_PART_TAB before updating to new default template.
--  090811  Asawlk  Bug 84050, Added public method Check_Exist().
--  060110  GeKalk  Changed the SELECT &OBJID statement to the RETURNING &OBJID in Insert___.
--  -------------------------13.3.0---------------------------------- 
--  030221  AnLaSe  Changed datatype from NUMBER to DATE for rowversion in 
--                  INVENTORY_TEMPLATE_PART_TAB.
--  **************************** TSO Merge ********************************** 
--  021106  paskno  Call ID: 87314, added new methods Parts_Exist and Default_Part_Exist.
--  020624  paskno  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Delete___
--   Checks whether other parts exist or not when deleting the default part.
PROCEDURE Validate_Delete___(
   remrec_ IN INVENTORY_TEMPLATE_PART_TAB%ROWTYPE )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   INVENTORY_TEMPLATE_PART_TAB
      WHERE  default_template_part = 'FALSE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) AND (remrec_.default_template_part = 'TRUE') THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_ , 'DELETEDEFAULTPART: It is not possible to remove the default template part when other template parts exist.');
   END IF;
   CLOSE exist_control;
END Validate_Delete___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEFAULT_TEMPLATE_PART', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_TEMPLATE_PART_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (Default_Part_Exist('DUMMY')='TRUE') THEN
      IF (newrec_.default_template_part = 'TRUE') THEN
         UPDATE INVENTORY_TEMPLATE_PART_TAB
            SET default_template_part = 'FALSE',
                rowversion = SYSDATE
          WHERE default_template_part = 'TRUE';
      END IF;
   ELSE
      newrec_.default_template_part := 'TRUE';
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_TEMPLATE_PART', newrec_.default_template_part , attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INVENTORY_TEMPLATE_PART_TAB%ROWTYPE,
   newrec_     IN OUT INVENTORY_TEMPLATE_PART_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.default_template_part = 'TRUE') THEN
      UPDATE inventory_template_part_tab
         SET default_template_part = 'FALSE',
             rowversion            = SYSDATE
      WHERE  default_template_part = 'TRUE';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INVENTORY_TEMPLATE_PART_TAB%ROWTYPE )
IS
BEGIN
   Validate_Delete___(remrec_);
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Default_Template
--   - Returns part no and contract of the row checked as default.
PROCEDURE Get_Default_Template (
   part_no_  OUT VARCHAR2,
   contract_ OUT VARCHAR2 )
IS
   CURSOR c_default IS
      SELECT part_no, contract
      FROM   INVENTORY_TEMPLATE_PART_TAB
      WHERE  default_template_part = 'TRUE';
BEGIN
   OPEN  c_default;
   FETCH c_default INTO part_no_, contract_;
   IF (c_default%NOTFOUND) THEN
      CLOSE c_default;
      Error_SYS.Record_General(lu_name_, 'NODEFAULT: No Inventory Template Part is checked as default, not possible to create new inventory part.');
   END IF;
   CLOSE c_default;
   IF (User_Allowed_Site_API.Is_Authorized (contract_) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'USERSITE: Default Inventory Template Part is defined on site :P1 which is not connected to user :P2, not possible to create new inventory part.', contract_, Fnd_Session_API.Get_Fnd_User);
   END IF;
END Get_Default_Template;


-- Set_Default_Template
--   - Checks of the row to be used as default.
PROCEDURE Set_Default_Template (
   info_     OUT VARCHAR2,
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   CURSOR c_default_exist IS
      SELECT part_no, contract
         FROM INVENTORY_TEMPLATE_PART_TAB
         WHERE default_template_part = 'TRUE';
   --
   newrec_                INVENTORY_TEMPLATE_PART_TAB%ROWTYPE;
   objversion_            VARCHAR2(2000);
   attr_                  VARCHAR2(2000);
   def_part_              INVENTORY_TEMPLATE_PART_TAB.part_no%TYPE;
   def_contract_          INVENTORY_TEMPLATE_PART_TAB.contract%TYPE;
BEGIN
   OPEN c_default_exist;
   FETCH c_default_exist INTO def_part_, def_contract_;
   IF (c_default_exist%FOUND) THEN
      Client_SYS.Add_Warning(lu_name_, 'DEFEXIST: Default Template Part (:P1) already exist, the template will be changed to (:P2).', def_part_||','||def_contract_, part_no_||','||contract_);
      newrec_ := Lock_By_Keys___(def_contract_, def_part_);
      newrec_.default_template_part := 'FALSE';
      Update___ (NULL, NULL, newrec_, attr_, objversion_, TRUE);
   END IF;
   CLOSE c_default_exist;
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.default_template_part := 'TRUE';
   Update___ (NULL, NULL, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
END Set_Default_Template;


-- Parts_Exist
--   - Checks wherever any parts exists.
PROCEDURE Parts_Exist
IS
   CURSOR c_parts_exist IS
      SELECT 1
         FROM INVENTORY_TEMPLATE_PART_TAB;
         --
   dummy_ NUMBER;
BEGIN
   OPEN c_parts_exist;
   FETCH c_parts_exist INTO dummy_;
   IF (c_parts_exist%NOTFOUND) THEN
      CLOSE c_parts_exist;
      Error_SYS.Record_General(lu_name_, 'NOPARTSEXIST: No Inventory Template Part exist, the part is needed to copy data to new inventory part.');
   END IF;
   CLOSE c_parts_exist;
END Parts_Exist;


-- Default_Part_Exist
--   - Checks wherever any default part is given.
@UncheckedAccess
FUNCTION Default_Part_Exist (
   dummy_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR c_default_template IS
      SELECT 1
         FROM INVENTORY_TEMPLATE_PART_TAB
         WHERE default_template_part = 'TRUE';
         --
   dummy2_  NUMBER;
   retval_  VARCHAR2(5):= 'FALSE';
BEGIN
   OPEN c_default_template;
   FETCH c_default_template INTO dummy2_;
   IF (c_default_template%FOUND) THEN
      retval_ := 'TRUE';
   END IF;
   CLOSE c_default_template;
   RETURN retval_;
END Default_Part_Exist;


-- Check_Exist
--   Checks whether a part exists or not.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, part_no_);
END Check_Exist;



