-----------------------------------------------------------------------------
--
--  Logical unit: CustomerInfoMsgSetup
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981117  Camk    Created
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  071109  PrPrlk  Bug 68771 Added new column sequence_no to the view CUSTOMER_INFO_MSG_SETUP
--  071109          and modified the relevant methods to handle INSERT and UPDATE operations.
--  071109          Two new mthods named Increase_Sequence_No and Get_Sequence_No was emplemented 
--  071109          to handle management of sequence no's when sending invoices.
--  090624  Shhelk  Bug 76768, Added Check_Exist function. 
--  120727  Chhulk  Bug 102287, Modified Increase_Sequence_No()
--  120730  Chwilk  Bug 103895, Added new attribute locale.
--  131021  Isuklk  CAHOOK-2783 Refactoring in CustomerInfoMsgSetup.entity
--  150813  Wahelk  BLU-1192,Modified Copy_Customer method to add new parameter copy_info_
--  210203  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in method Increase_Sequence_No
--  210223  Hecolk  FISPRING20-9277, Reverted the changes done by FISPRING20-8730 in method Increase_Sequence_No
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Default___ (
   newrec_ IN customer_info_msg_setup_tab%ROWTYPE,
   objid_  IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR meth_def IS
      SELECT 1
      FROM   customer_info_msg_setup
      WHERE  customer_id     = newrec_.customer_id
      AND    message_class   = newrec_.message_class
      AND    method_default  = 'TRUE'
      AND    objid||''      <> NVL(objid_,CHR(0));
BEGIN
   IF (newrec_.method_default = 'TRUE') THEN
      OPEN meth_def;
      FETCH meth_def INTO dummy_;
      IF (meth_def%FOUND) THEN
         Error_SYS.Record_General(lu_name_, 'METHDEFEX: Default method for this message class is already registered.');
      END IF;
      CLOSE meth_def;
   ELSIF (newrec_.method_default <> 'FALSE') THEN
      Error_SYS.Item_Format(lu_name_, 'METHOD_DEFAULT', newrec_.method_default);
   END IF;
END Check_Default___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('METHOD_DEFAULT', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_info_msg_setup_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Check_Default___(newrec_, NULL);   
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customer_info_msg_setup_tab%ROWTYPE,
   newrec_     IN OUT customer_info_msg_setup_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Default___(newrec_, objid_);   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Default_Media_Code (
   customer_id_   IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   media_code_ customer_info_msg_setup.media_code%TYPE;
   CURSOR get_media IS
      SELECT media_code
      FROM   customer_info_msg_setup
      WHERE  customer_id = customer_id_
      AND    message_class = message_class_
      AND    method_default = 'TRUE';
BEGIN
   OPEN get_media;
   FETCH get_media INTO media_code_;
   CLOSE get_media;
   RETURN media_code_;
END Get_Default_Media_Code;


@UncheckedAccess
FUNCTION Is_Method_Default (
   customer_id_   IN VARCHAR2,
   media_code_    IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_def IS
      SELECT method_default
      FROM   customer_info_msg_setup
      WHERE  customer_id = customer_id_
      AND    message_class = message_class_
      AND    media_code = media_code_;
BEGIN
   FOR m IN get_def LOOP
      RETURN M.method_default;
   END LOOP;
   RETURN 'FALSE';
END Is_Method_Default;


PROCEDURE Copy_Customer (
   customer_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2,
   copy_info_   IN  Customer_Info_API.Copy_Param_Info)
IS   
   newrec_ customer_info_msg_setup_tab%ROWTYPE;
   oldrec_ customer_info_msg_setup_tab%ROWTYPE;
   CURSOR get_attr IS
      SELECT *
      FROM customer_info_msg_setup_tab
      WHERE customer_id = customer_id_;
BEGIN      
   FOR rec_ IN get_attr LOOP
      oldrec_ := Lock_By_Keys___(customer_id_, rec_.media_code, rec_.message_class);   
      newrec_ := oldrec_ ;
      newrec_.customer_id := new_id_; 
      newrec_.sequence_no := NULL;
      New___(newrec_);
   END LOOP;      
END Copy_Customer;


FUNCTION Increase_Sequence_No (
   customer_id_         IN  VARCHAR2,
   media_code_          IN  VARCHAR2,
   message_class_       IN  VARCHAR2 ) RETURN NUMBER
IS
   sequence_no_         customer_info_msg_setup.sequence_no%TYPE;
   oldrec_              customer_info_msg_setup_tab%ROWTYPE;
   newrec_              customer_info_msg_setup_tab%ROWTYPE;
   attr_                VARCHAR2(32000);
   objid_               ROWID;
   objversion_          customer_info_msg_setup_tab.rowversion%TYPE;  
   indrec_              Indicator_Rec;
   -- select from table as LU is using an older template
   CURSOR get_attr IS
      SELECT ROWID, rowversion   
      FROM   customer_info_msg_setup_tab
      WHERE  customer_id = customer_id_
      AND    media_code = media_code_
      AND    message_class = message_class_
      FOR UPDATE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO objid_, objversion_;
   IF (get_attr%NOTFOUND) THEN
      CLOSE get_attr;
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
   CLOSE get_attr;
   oldrec_ := Get_Object_By_Id___(objid_);   
   newrec_ := oldrec_;
   sequence_no_ := NVL(oldrec_.sequence_no, 0) + 1;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SEQUENCE_NO', sequence_no_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   RETURN sequence_no_;
END Increase_Sequence_No;


@UncheckedAccess
FUNCTION Check_Exist(
   customer_id_   IN VARCHAR2,
   media_code_    IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(customer_id_,media_code_,message_class_)) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Check_Exist;