-----------------------------------------------------------------------------
--
--  Logical unit: CommissionRange
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110514  MaMalk  Corrected the text given in messages in Check_Range_Validity___.
--  100512  Ajpelk  Merge rose method documentation
--  060112  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  010528  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in procedure New and removed
--                  'TRUE' as last parameter in the General_SYS.Init_Method call in procedure Change_Allowed.
--  000711  JakH    Merged from Chameleon
--  000517  DEHA    Added public new method.
--  000510  BRO     Added validity check on commission range type
--  000509  BRO     Added validity check on perc. and amount
--  000420  BRO     Added validity check on min_value
--  000411  DEHA    Changed field name agreement_version to revision_no.
--  000407  DEHA    Recreated.
--  000406  BRO     Created
--  000406  DEHA    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Range_Validity___
--   Private method for checking, if commission range is valid.
PROCEDURE Check_Range_Validity___ (
   rec_                    IN COMMISSION_RANGE_TAB%ROWTYPE,
   commission_range_type_  IN VARCHAR2 DEFAULT NULL)
IS
   com_range_type_         COMMISSION_AGREE_LINE_TAB.commission_range_type%TYPE;
BEGIN
   IF (commission_range_type_ IS NULL) THEN
      com_range_type_ := Commission_Range_Type_API.Encode(Commission_Agree_Line_API.Get_Commission_Range_Type(
      rec_.agreement_id, rec_.revision_no, rec_.line_no));
   ELSE
      com_range_type_ := commission_range_type_;
   END IF;

   IF (com_range_type_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NO_RANGE_TYPE: There is no range type defined for the Commission Agreement Line.');
   END IF;
   IF (rec_.min_value < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEG_MIN_VALUE: The minimum value should be positive');
   END IF;
   IF (rec_.percentage < 0) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_NEGATIVE: Percentage cannot be negative');
   END IF;
   IF (rec_.percentage > 100) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_TOOBIG: Percentage cannot be greater than 100');
   END IF;

   IF (rec_.amount < 0) THEN
       Error_SYS.Record_General(lu_name_, 'AMOUNT_NEGATIVE: Amount cannot be negative');
   END IF;

   IF (com_range_type_ = 'AMOUNT' AND rec_.percentage IS NOT NULL AND rec_.amount IS NOT NULL) THEN
      IF (commission_range_type_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'TOO_MANY_COM_INFO2: Only one value between percentage and amount may be filled at the same time (you should first change back the commission range type).');
      END IF;
      Error_SYS.Record_General(lu_name_, 'TOO_MANY_COM_INFO: Only one value between percentage and amount may be filled at the same time.');
   END IF;

   IF (com_range_type_ <> 'AMOUNT' AND rec_.percentage IS NULL AND rec_.amount IS NOT NULL) THEN
      IF (commission_range_type_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'WRONG_COM_INFO2: The percentage should have a value (you should first change back the commission range type).');
      END IF;
      Error_SYS.Record_General(lu_name_, 'WRONG_COM_INFO: The percentage should have a value.');
   END IF;

   IF ((com_range_type_ = 'AMOUNT' AND rec_.percentage IS NULL AND rec_.amount IS NULL)
      OR (com_range_type_ <> 'AMOUNT' AND rec_.percentage IS NULL))
   THEN
      IF (commission_range_type_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_COM_INFO2: There are no data for the commission calculation (you should first change back the commission range type).');
      END IF;
      Error_SYS.Record_General(lu_name_, 'NO_COM_INFO: There are no data for the commission calculation.');
   END IF;

END Check_Range_Validity___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     commission_range_tab%ROWTYPE,
   newrec_ IN OUT commission_range_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   Check_Range_Validity___(newrec_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Change_Allowed
--   Public methoc for checking if changes in the commission
--   range are valid and therefore allowed.
PROCEDURE Change_Allowed (
   agreement_id_ IN VARCHAR2,
   revision_no_ IN NUMBER,
   line_no_ IN NUMBER,
   commission_range_type_ IN VARCHAR2 )
IS
   CURSOR loop_com_range IS
      SELECT cr.*
      FROM COMMISSION_RANGE_TAB cr
      WHERE cr.agreement_id = agreement_id_
      AND   cr.revision_no = revision_no_
      AND   cr.line_no = line_no_;
BEGIN

   FOR cr_rec_ IN loop_com_range LOOP
      IF (commission_range_type_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'RANGE_EXISTS: You should first delete the range lines.');
      END IF;
      Check_Range_Validity___(cr_rec_, commission_range_type_);
   END LOOP;

END Change_Allowed;


-- New
--   Public new method, to insert a record by key.
PROCEDURE New (
   newrec_ IN OUT COMMISSION_RANGE_TAB%ROWTYPE )
IS
   attr_                   VARCHAR2(2000);
   objid_                  VARCHAR2(200);
   objversion_             VARCHAR2(200);
BEGIN
   Insert___(objid_, objversion_, newrec_, attr_);
END New;



