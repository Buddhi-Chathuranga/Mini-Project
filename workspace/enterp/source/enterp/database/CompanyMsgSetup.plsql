-----------------------------------------------------------------------------
--
--  Logical unit: CompanyMsgSetup
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981124  Camk    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Default___ (
   newrec_ IN company_msg_setup_tab%ROWTYPE,
   objid_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR meth_def IS
      SELECT 1
      FROM   company_msg_setup
      WHERE  company     = newrec_.company
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
   newrec_     IN OUT company_msg_setup_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Check_Default___(newrec_, NULL);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     company_msg_setup_tab%ROWTYPE,
   newrec_     IN OUT company_msg_setup_tab%ROWTYPE,
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
   company_       IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   media_code_ company_msg_setup.media_code%TYPE;
   CURSOR get_media IS
      SELECT media_code
      FROM   company_msg_setup
      WHERE  company = company_
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
   company_       IN VARCHAR2,
   media_code_    IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_def IS
      SELECT method_default
      FROM   company_msg_setup
      WHERE  company = company_
      AND    message_class = message_class_
      AND    media_code = media_code_;
BEGIN
   FOR m IN get_def LOOP
      RETURN M.method_default;
   END LOOP;
   RETURN 'FALSE';
END Is_Method_Default;