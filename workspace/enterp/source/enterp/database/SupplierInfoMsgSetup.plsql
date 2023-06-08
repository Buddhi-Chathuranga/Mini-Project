-----------------------------------------------------------------------------
--
--  Logical unit: SupplierInfoMsgSetup
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981123  Camk    Created
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  050504  SaRalk  Added function Msg_Class_Registered. 
--  071109  PrPrlk  Bug 68771 Added new column sequence_no to the view CUSTOMER_INFO_MSG_SETUP
--  071109          and modified the relevant methods to handle INSERT and UPDATE operations. 
--  071109          Two new mthods named Increase_Sequence_No and Get_Sequence_No was emplemented 
--  071109          to handle management of sequence no's when sending invoices.
--  120727  Chhulk  Bug 102287, Modified Increase_Sequence_No()
--  120829  Hecolk  Bug 111219, Corrected Coding mistake in WHERE clause in FUNCTION Get_Sequence_N
--  140407  AjPelk  Bug 114002, Modified method Increase_Sequence_No
--  140418  AjPelk  PBFI-5416, Merged bug 115051.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Default___ (
   newrec_ IN supplier_info_msg_setup_tab%ROWTYPE,
   objid_  IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR meth_def IS
      SELECT 1
      FROM   supplier_info_msg_setup
      WHERE  supplier_id     = newrec_.supplier_id
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
   newrec_     IN OUT supplier_info_msg_setup_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Check_Default___(newrec_, NULL);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     supplier_info_msg_setup_tab%ROWTYPE,
   newrec_     IN OUT supplier_info_msg_setup_tab%ROWTYPE,
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
   supplier_id_   IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   media_code_ supplier_info_msg_setup.media_code%TYPE;
   CURSOR get_media IS
      SELECT media_code
      FROM   supplier_info_msg_setup
      WHERE  supplier_id = supplier_id_
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
   supplier_id_   IN VARCHAR2,
   media_code_    IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_def IS
      SELECT method_default
      FROM   supplier_info_msg_setup
      WHERE  supplier_id = supplier_id_
      AND    message_class = message_class_
      AND    media_code = media_code_;
BEGIN
   FOR m IN get_def LOOP
      RETURN M.method_default;
   END LOOP;
   RETURN 'FALSE';
END Is_Method_Default;


PROCEDURE Copy_Supplier (
   supplier_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2 )
IS   
   newrec_ supplier_info_msg_setup_tab%ROWTYPE;
   oldrec_ supplier_info_msg_setup_tab%ROWTYPE;
   CURSOR get_attr IS
      SELECT *
      FROM   supplier_info_msg_setup_tab
      WHERE  supplier_id = supplier_id_;
BEGIN      
   FOR rec_ IN get_attr LOOP
      oldrec_ := Lock_By_Keys___(supplier_id_, rec_.media_code, rec_.message_class);   
      newrec_ := oldrec_ ;
      newrec_.supplier_id := new_id_;         
      newrec_.sequence_no := NULL;
      New___(newrec_);
   END LOOP; 
END Copy_Supplier;


@UncheckedAccess
FUNCTION Msg_Class_Registered (
   supplier_id_   IN VARCHAR2,
   media_code_    IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN NUMBER
IS
   class_exists_ NUMBER;
   CURSOR msg_class_exists IS
      SELECT 1
      FROM   supplier_info_msg_setup_tab
      WHERE  supplier_id   = supplier_id_
      AND    message_class = message_class_
      AND    media_code    = NVL(media_code_, media_code);
BEGIN
   OPEN msg_class_exists;
   FETCH msg_class_exists INTO class_exists_;
   IF (msg_class_exists%FOUND) THEN
      CLOSE msg_class_exists;
      RETURN 1;
   END IF;
   CLOSE msg_class_exists;
   RETURN 0;
END Msg_Class_Registered;


FUNCTION Increase_Sequence_No (
   supplier_id_         IN  VARCHAR2,
   media_code_          IN  VARCHAR2,
   message_class_       IN  VARCHAR2 ) RETURN NUMBER
IS
   sequence_no_         supplier_info_msg_setup.sequence_no%TYPE;
   CURSOR get_attr IS
      SELECT sequence_no
      FROM   supplier_info_msg_setup_tab
      WHERE  supplier_id = supplier_id_
      AND    media_code = media_code_
      AND    message_class = message_class_
      FOR UPDATE;
      PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO sequence_no_;
   CLOSE get_attr;
   sequence_no_ := NVL(sequence_no_,0)+1;
   UPDATE supplier_info_msg_setup_tab
   SET    sequence_no   = sequence_no_
   WHERE  supplier_id   = supplier_id_
   AND    media_code    = media_code_
   AND    message_class = message_class_;
   @ApproveTransactionStatement(2014-04-18,ajpelk)
   COMMIT;
   RETURN sequence_no_; 
END Increase_Sequence_No;



