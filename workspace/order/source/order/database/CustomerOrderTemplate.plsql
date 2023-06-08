-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderTemplate
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110201  NeKolk EANE-3744  added where clause to the View CUSTOMER_ORDER_TEMPLATE .
--  060110  CsAmlk Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
-- --------------------------------------13.3.0----------------------
--  990409  JakH  New template.
--  981127  JoEd  Call id 5307: Changed key data type from number to string(12).
--  980915  JoEd  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_TEMPLATE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.template_id IS NULL) THEN
      SELECT to_char(template_id_seq.nextval)
         INTO newrec_.template_id
         FROM dual;
      Client_SYS.Add_To_Attr('TEMPLATE_ID', newrec_.template_id, attr_);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


