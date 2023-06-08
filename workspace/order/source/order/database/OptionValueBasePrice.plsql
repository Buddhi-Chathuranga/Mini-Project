-----------------------------------------------------------------------------
--
--  Logical unit: OptionValueBasePrice
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140730  ChFolk  Modified Get_Price_Infos to add new OUT parameter fixed_amt_incl_tax_ which return including tax value of fixed amount.
--  140508  JICE    Clears rowkey in Copy_Revision_Price.
--  130708  MaRalk TIBE-999, Removed global LU constant inst_BasePartChar_ and modified Validate_Base_Part_Option___ accordingly.
--  110713  ChJalk Added user_allowed-site filter to the view OPTION_VALUE_BASE_PRICE.
--  100519  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060125  JaJalk Added Assert safe annotation.
--  060112  NaWalk Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050920  NaLrlk Removed unused variables.
--  040220  IsWilk Removed the SUBSTRB from view for Unicode Changes.
--  -------------  Edge Package Group 3 Unicode Changes-----------------------  
--  040127  GeKalk Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  021212  Asawlk Merged bug fixes in 2002-3 SP3
--  021111  MaGu   Bug 32538. Added methods Copy_Revision_Price, Check_Remove__ and Do_Remove__. 
--  021111         Added CUSTOMLIST delete on attribute option_value_id in view comments on view OPTION_VALUE_BASE_PRICE.
--  020103  JICE   Added public view for Sales Configurator interface.
--  020718  RaSilk  Bug 29966, Added public procedure Remove();
--  010413  JaBa   Bug Fix 20598,Added new global lu constant inst_BasePartChar_.
--  001115  JoEd   Changed Unpack_Check_Insert___ for the Exist checks to work
--                 correctly.
--  000719  TFU    Merging from Chameleon
--  000703  TFU    added function Get_Prise_Infos
--  000629  GBO    Added Validate_Base_Part_Option___
--  000628  TFU    Added char_qty_price_method
--  000621  TFU    Creatio
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', SYSDATE, attr_ );
   Client_SYS.Add_To_Attr('OFFSET_VALUE', '0', attr_ );
   Client_SYS.Add_To_Attr('FIXED_AMOUNT', '0', attr_ );
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Remove__
--   Checks if it is allowed to remove option value base price when removing a
--   part configuration option.
PROCEDURE Check_Remove__ (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2,
   option_value_id_    IN VARCHAR2 )
IS
   CURSOR get_rec_key IS
      SELECT *
      FROM OPTION_VALUE_BASE_PRICE_TAB
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_
      AND   option_value_id = option_value_id_;
BEGIN

   FOR keyrec_ IN get_rec_key LOOP
       Check_Delete___(keyrec_);
   END LOOP;
END Check_Remove__;


-- Do_Remove__
--   Removes option value base price when removing a part configuration option.
PROCEDURE Do_Remove__ (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2,
   option_value_id_   IN VARCHAR2 )
IS
   remrec_     OPTION_VALUE_BASE_PRICE_TAB%ROWTYPE;
   objid_      OPTION_VALUE_BASE_PRICE.objid%TYPE;
   objversion_ OPTION_VALUE_BASE_PRICE.objversion%TYPE;

   CURSOR get_rec_key IS
      SELECT *
      FROM OPTION_VALUE_BASE_PRICE_TAB
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_
      AND   option_value_id = option_value_id_;
BEGIN
   
   FOR keyrec_ IN get_rec_key LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, keyrec_.contract, keyrec_.catalog_no,
                                keyrec_.part_no, keyrec_.spec_revision_no, keyrec_.characteristic_id,
                                keyrec_.option_value_id, keyrec_.valid_from_date);  
      remrec_ := Lock_By_Keys___(keyrec_.contract, keyrec_.catalog_no,
                                keyrec_.part_no, keyrec_.spec_revision_no, keyrec_.characteristic_id,
                                keyrec_.option_value_id, keyrec_.valid_from_date);
      Delete___(objid_, remrec_);
   END LOOP;
END Do_Remove__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Price_Infos
--   return  offset_value, fixed_amount and multiply_by_qty
PROCEDURE Get_Price_Infos (
   offset_value_        OUT  NUMBER,
   fixed_amount_        OUT  NUMBER,
   fixed_amt_incl_tax_  OUT  NUMBER,
   multiply_by_qty_     OUT  VARCHAR2,
   contract_            IN   VARCHAR2,
   catalog_no_          IN   VARCHAR2,
   part_no_             IN   VARCHAR2,
   spec_revision_no_    IN   NUMBER,
   characteristic_id_   IN   VARCHAR2,
   option_value_id_     IN   VARCHAR2,
   valid_from_date_     IN   DATE DEFAULT NULL )
IS
   date_             DATE;
   CURSOR GetInfos IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method
      FROM OPTION_VALUE_BASE_PRICE_TAB
      WHERE valid_from_date IN
            ( SELECT MAX(valid_from_date)
         FROM option_value_base_price_tab
         WHERE valid_from_date <= date_
         AND catalog_no = catalog_no_
         AND contract = contract_
         AND option_value_id = option_value_id_
         AND characteristic_id = characteristic_id_
         AND spec_revision_no = spec_revision_no_
         AND part_no = part_no_
            )
      AND catalog_no = catalog_no_
      AND contract = contract_
      AND option_value_id = option_value_id_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_;
BEGIN

   IF (valid_from_date_ IS NULL) THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := valid_from_date_;
   END IF;
   OPEN GetInfos;
   FETCH GetInfos INTO offset_value_, fixed_amount_, fixed_amt_incl_tax_, multiply_by_qty_;
   IF GetInfos%NOTFOUND THEN
      offset_value_ := NULL;
      fixed_amount_ := NULL;
      fixed_amt_incl_tax_ := NULL;
      multiply_by_qty_ := NULL;
   END IF;
   CLOSE GetInfos;
END Get_Price_Infos;


-- Remove
--   Public remove method.
PROCEDURE Remove (
   contract_ IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   spec_revision_no_ IN NUMBER,
   characteristic_id_ IN VARCHAR2,
   valid_from_date_ IN DATE DEFAULT NULL,
   option_value_id_ IN VARCHAR2 DEFAULT NULL)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(2000);
   CURSOR get_row IS
      SELECT *
      FROM OPTION_VALUE_BASE_PRICE_TAB
      WHERE  contract = contract_
      AND catalog_no = catalog_no_
      AND part_no = part_no_
      AND spec_revision_no = spec_revision_no_
      AND characteristic_id = characteristic_id_
      AND valid_from_date LIKE nvl(to_char(valid_from_date_), '%')
      AND option_value_id LIKE nvl(option_value_id_, '%');
BEGIN
   FOR remrec_ IN get_row LOOP
      Get_Id_Version_By_Keys___( objid_, objversion_,
                                 remrec_.contract,
                                 remrec_.catalog_no,
                                 remrec_.part_no,
                                 remrec_.spec_revision_no,
                                 remrec_.characteristic_id,
                                 remrec_.option_value_id,
                                 remrec_.valid_from_date);
      Remove__ (info_, objid_, objversion_, 'DO');     
   END LOOP;
END Remove;


-- Copy_Revision_Price
--   Copies pricing details from one spec revision to another.
PROCEDURE Copy_Revision_Price (
   contract_             IN VARCHAR2,
   catalog_no_           IN VARCHAR2,
   part_no_              IN VARCHAR2,
   characteristic_id_    IN VARCHAR2,
   option_value_id_      IN VARCHAR2,
   valid_from_date_      IN DATE,
   old_spec_revision_no_ IN NUMBER,
   new_spec_revision_no_ IN NUMBER )
IS
   newrec_       OPTION_VALUE_BASE_PRICE_TAB%ROWTYPE;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(2000);

   CURSOR get_oldrec IS
      SELECT * 
      FROM OPTION_VALUE_BASE_PRICE_TAB
      WHERE catalog_no = catalog_no_
      AND   part_no = part_no_
      AND   contract = contract_
      AND   spec_revision_no = old_spec_revision_no_
      AND   characteristic_id = characteristic_id_
      AND   option_value_id = option_value_id_
      AND   valid_from_date = valid_from_date_;
BEGIN

   OPEN get_oldrec;
   FETCH get_oldrec INTO newrec_;
   IF get_oldrec%FOUND THEN
      CLOSE get_oldrec;
      newrec_.rowkey := NULL;
      newrec_.spec_revision_no := new_spec_revision_no_;
      Client_SYS.Clear_Attr(attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      CLOSE get_oldrec;
   END IF;
END Copy_Revision_Price;



