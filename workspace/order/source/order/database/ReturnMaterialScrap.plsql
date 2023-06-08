-----------------------------------------------------------------------------
--
--  Logical unit: ReturnMaterialScrap
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130808  NiDalk Bug 111734, Added function Get_Sum_Qty_Scrapped.
--  130611  Vwloza Added public New method.
--  111101  NISMLK SMA-289, Increased eng_chg_level length to STRING(6) in column comments.
--  110126  ShVese Replaced fetching of Part_Catalog serial tracking_code and lot tracking code with the Get method and
--                 used the receipt_issue_serial_track flag instead of serial tracking code.
--  060119  SaJjlk Added returning clause to method Insert___.
--  --------------------------------13.3.0---------------------------------------
--  020919  MaEelk Removed unused variables from the code
--  021018  JoAnSe Removed condition_code.
--  020722  NabeUs Changed Unpack_Check_Insert___ to validate condition_code.
--  020628  MaEelk Changed comments on CONDITION_CODE in RETURN_MATERIAL_SCRAP.
--  020621  MaEelk Added CONDITION_CODE to the LU.
--  020522  SuAmlk Changed VIEW COMMENTS in the view RETURN_MATERIAL_SCRAP.
--  ******************************** AD 2002-3 Baseline ************************************

--  991110  JoEd  Changed fetch of eng_chg_level in Prepare_Insert___.
--  991109  JakH  CID 27530 Errors for specifying ser no / lot batch without handling.
--  991104  JakH  Added check when inserting for EC tracking. Removed checks in update.
--  991104  JakH  Added eng_chg_level and waiv_dev_rej_no. Removed unused public functions.
--                Set the key attribute on the four inventory part attributes
--  991028  PaLj  Corrected Unpack_Check_Insert and Unpack_Check_Update serial no handling
--  990811  JakH  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_                        CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_ VARCHAR2(5);
   part_no_  VARCHAR2(25);
   site_date_  DATE;
BEGIN
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   part_no_ := Client_SYS.Get_Item_Value('PART_NO', attr_);
   site_date_ := Site_API.Get_Site_Date(contract_);
   super(attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', '*', attr_);
   Client_SYS.Add_To_Attr('LOT_BATCH_NO', '*', attr_);
   Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', '*', attr_);
   Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', Inventory_Part_Revision_API.Get_Eng_Chg_Level(contract_, part_no_, site_date_), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     RETURN_MATERIAL_SCRAP_TAB%ROWTYPE,
   newrec_     IN OUT RETURN_MATERIAL_SCRAP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.qty_scrapped < oldrec_.qty_scrapped) THEN
      Error_SYS.Record_General(lu_name_, 'QTY_DECREASE: The qty scrapped may not be decreased!');
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT return_material_scrap_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   rmalinerec_          Return_Material_Line_API.Public_Rec;
   part_no_             VARCHAR2(25);
   part_catalog_rec_    Part_Catalog_API.Public_Rec;

BEGIN
   Trace_SYS.Field('attr_= ',attr_);
   super(newrec_, indrec_, attr_);

   rmalinerec_ := return_material_line_api.get(newrec_.rma_no,
                                               newrec_.rma_line_no);

   part_no_ := sales_part_api.get_part_no(rmalinerec_.contract,
                                          rmalinerec_.catalog_no);
   IF part_no_ IS NULL THEN
      error_sys.record_general(lu_name_, 'NOPARTNO: This type of part can not be scrapped.');
   ELSE
      part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
      IF (part_catalog_rec_.receipt_issue_serial_track = db_true_) THEN
         IF (newrec_.serial_no = '*') THEN
            error_sys.record_general(lu_name_, 'NOSERNO: Serial Number has to be specified.');
         END IF;
         IF newrec_.qty_scrapped != 1 THEN
            error_sys.record_general(lu_name_, 'MULTISER: Only one item can be scrapped on each Serial Number.');
         END IF;
      ELSE
         IF (newrec_.serial_no != '*') THEN
            error_sys.record_general(lu_name_, 'NOSERSTAR: Serial Number can not be specified.');
         END IF;
      END IF;
                        
      IF (part_catalog_rec_.lot_tracking_code IN ('LOT TRACKING', 'ORDER BASED')) THEN
         IF (newrec_.lot_batch_no = '*') THEN
            error_sys.record_general(lu_name_, 'NOBATNO: Lot/Batch Number has to be specified.');
         END IF;
      ELSE
         IF (newrec_.lot_batch_no != '*') THEN
            error_sys.record_general(lu_name_, 'NOLOTSTAR: Lot Batch Number can not be specified.');
         END IF;
      END IF;

      Inventory_Part_Revision_API.Exist(rmalinerec_.contract, part_no_, newrec_.eng_chg_level);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     return_material_scrap_tab%ROWTYPE,
   newrec_ IN OUT return_material_scrap_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- Make sure qty scrapped is not < 0
   IF (newrec_.qty_scrapped < 0) THEN
      Error_SYS.Record_General(lu_name_, 'QTY_SCR_LESS_THAN_ZERO: The qty scrapped may not be less than zero!');
   END IF;


EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   rma_no_          IN  NUMBER,
   rma_line_no_     IN  NUMBER,
   receipt_no_      IN  NUMBER,
   reject_reason_   IN  VARCHAR2,
   serial_no_       IN  VARCHAR2,
   lot_batch_no_    IN  VARCHAR2,
   eng_chg_level_   IN  VARCHAR2,
   waiv_dev_rej_no_ IN  VARCHAR2,
   qty_scrapped_    IN  NUMBER )
IS
   attr_       VARCHAR2(4000);
   newrec_     RETURN_MATERIAL_SCRAP_TAB%ROWTYPE;
   objid_      RETURN_MATERIAL_SCRAP.objid%TYPE;
   objversion_ RETURN_MATERIAL_SCRAP.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RMA_NO', rma_no_, attr_);
   Client_SYS.Add_To_Attr('RMA_LINE_NO', rma_line_no_, attr_);
   Client_SYS.Add_To_Attr('RECEIPT_NO', receipt_no_, attr_);
   Client_SYS.Add_To_Attr('REJECT_REASON', reject_reason_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
   Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, attr_);
   Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', eng_chg_level_, attr_);
   Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', waiv_dev_rej_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_SCRAPPED', qty_scrapped_, attr_);
   Unpack___(newrec_, indrec_, attr_); 
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


@UncheckedAccess
FUNCTION Check_Exist (
   rma_no_          IN NUMBER,
   rma_line_no_     IN NUMBER,
   receipt_no_      IN NUMBER,
   reject_reason_   IN VARCHAR2,
   serial_no_       IN VARCHAR2,
   lot_batch_no_    IN VARCHAR2,
   eng_chg_level_   IN VARCHAR2,
   waiv_dev_rej_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(rma_no_, 
                         rma_line_no_, 
                         receipt_no_, 
                         reject_reason_, 
                         serial_no_, 
                         lot_batch_no_, 
                         eng_chg_level_, 
                         waiv_dev_rej_no_);
END Check_Exist;


-- Get_Sum_Qty_Scrapped
--   Returns summed scrapped quantity for a part in rma line per serial_no_,
--   lot_batch_no_and eng_chg_level_.
@UncheckedAccess
FUNCTION Get_Sum_Qty_Scrapped (
   rma_no_          IN NUMBER,
   rma_line_no_     IN NUMBER,
   serial_no_       IN VARCHAR2,
   lot_batch_no_    IN VARCHAR2,
   eng_chg_level_   IN VARCHAR2 ) RETURN NUMBER
IS
   scrapped_qty_     NUMBER := 0;

   CURSOR get_qty IS
      SELECT SUM(qty_scrapped)
      FROM RETURN_MATERIAL_SCRAP_TAB
      WHERE rma_no = rma_no_
      AND   rma_line_no = rma_line_no_
      AND   serial_no = serial_no_
      AND   lot_batch_no = lot_batch_no_
      AND   eng_chg_level = eng_chg_level_;
BEGIN
   OPEN get_qty;
   FETCH get_qty INTO scrapped_qty_;
   CLOSE get_qty;

   RETURN  NVL(scrapped_qty_, 0);
END Get_Sum_Qty_Scrapped;



