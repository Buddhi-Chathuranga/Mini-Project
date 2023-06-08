-----------------------------------------------------------------------------
--
--  Logical unit: OptionValuePriceList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140806  ChFolk  Added new OUT parameter fixed_amt_incl_tax_ into Get_Price_List_Infos which is to be used when price including tax is used.
--  140411  MaIklk  PBSC-8350, Set rowkey = NULL when copy records.
--  140115  AyAmlk  Bug 114687, Modified Copy() to have the correct currency conversion.
--  130708  MaRalk  TIBE-1000, Removed global LU constant inst_BasePartCharacteristic_ and modified Validate_Base_Part_Option___ accordingly.
--  110926  MaRalk  Modified method Is_Valid_Price_List by adding the check Sales_Price_List_API.Is_Valid_Assort.
--  110824  ChJalk  Bug 95597, Modified the method Is_Valid_Price_List to add IN parameter catalog_no_ to the method call Sales_Price_List_API.Is_Valid.
--  101206  ShKolk  Restricted Unauthorized access to sales price list.
--  100520  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090516  MaMalk  Bug 80827, Modified the specification of the Copy method and re-structured the method to copy the option values correctly.
--  060726  ThGulk  Added Objid instead of rowid in Procedure Insert__
--  060125  JaJalk  Added Assert safe annotation.
--  060112  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050920  NaLrlk  Removed unused variables.
--  040224  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------------Edge Package Group 3 Unicode Changes-----------------
--  040128  GeKalk  Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  031031  ErFi    Call 109738, added catalog_no to view OPTION_VALUE_PRICE_LIST_PUB
--  030805  AjShlk  Synchonized with the CAT file - SP4 merge
--  030730  GaJalk  Performed SP4 Merge.
--  030417  MaGu    Bug 33755. Added new key catalog_no. Also added new attribute base_price_site.
--  021212  Asawlk  Merged bug fixes in 2002-3 SP3
--  021111  MaGu    Bug 32538. Added methods Copy_Revision_Price, Check_Remove__ and Do_Remove__.
--  021111          Added CUSTOMLIST delete on attribute option_value_id in view comments on view OPTION_VALUE_PRICE_LIST.
--  020103  JICE    Added public view for Sales Configurator export
--  010720  ViPalk  Bug fix 21370, Divided the fixed_amount by the currency_rate_ before inserting the new record
--                  into table Option_Value_Price_List_Tab in the Copy procedure.
--  010528  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method in procedure Is_Valid_Price_List and removed 'True'
--                  as last parameter in the same statement in procedure Get_Price_List_Infos.
--  010521  SuSalk  Bug Fix 19108,Add new procedure to delete records on 'OPTION_VALUE_PRICE_LIST_TAB' which is relevant to 'price_list_no',
--                  'part_no','spec_revision_no',and'characteristic_id'.
--  010413  JaBa    Bug Fix 20598,Added new global lu constant inst_BasePartCharacteristic_.
--  010104  JakH  Changed table to this Lu for finding correct max date.
--  001207  JoEd  Changed Unpack_Check_Insert___ so that the keys are fetched
--                before they're used in Validate_Base_Part_Option___.
--  0001719 TFU   Merging from Chameleon
--  000706  TFU   Added procedure COPY
--  000628  GBO   Added Validate_Base_Part_Option___, Get_Price_List_Infos
--                and Is_Valid_Price_List
--  000626  GBO   Added default values
--                Removed minus_percentage
--  000621  GBO   Created
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
   Client_SYS.Add_To_Attr('OFFSET_VALUE', '0', attr_ );
   Client_SYS.Add_To_Attr('FIXED_AMOUNT', '0', attr_ );
   Client_SYS.Add_To_Attr('FIXED_AMOUNT_INCL_TAX', '0', attr_ );
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', TRUNC(SYSDATE), attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN OPTION_VALUE_PRICE_LIST_TAB%ROWTYPE )
IS
BEGIN
   Sales_Price_List_API.Check_Editable(remrec_.price_list_no);

   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     option_value_price_list_tab%ROWTYPE,
   newrec_ IN OUT option_value_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.sales_price_type := NVL(newrec_.sales_price_type, 'SALES PRICES');
   super(oldrec_, newrec_, indrec_, attr_);
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Remove__
--   Checks if it is allowed to remove option value price list when removing a
--   part configuration option.
PROCEDURE Check_Remove__ (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2,
   option_value_id_   IN VARCHAR2 )
IS
   CURSOR get_rec_key IS
      SELECT *
      FROM OPTION_VALUE_PRICE_LIST_TAB
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
--   Removes option value price list when removing a part configuration option.
PROCEDURE Do_Remove__ (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2,
   option_value_id_   IN VARCHAR2 )
IS
   remrec_     OPTION_VALUE_PRICE_LIST_TAB%ROWTYPE;
   objid_      OPTION_VALUE_PRICE_LIST.objid%TYPE;
   objversion_ OPTION_VALUE_PRICE_LIST.objversion%TYPE;

   CURSOR get_rec_key IS
      SELECT *
      FROM OPTION_VALUE_PRICE_LIST_TAB
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_
      AND   option_value_id = option_value_id_;
BEGIN

   FOR keyrec_ IN get_rec_key LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, keyrec_.price_list_no, keyrec_.part_no,
                                keyrec_.spec_revision_no, keyrec_.characteristic_id,
                                keyrec_.option_value_id, keyrec_.valid_from_date, keyrec_.catalog_no);
      remrec_ := Lock_By_Keys___(keyrec_.price_list_no, keyrec_.part_no,
                                keyrec_.spec_revision_no, keyrec_.characteristic_id,
                                keyrec_.option_value_id, keyrec_.valid_from_date, keyrec_.catalog_no);
      Delete___(objid_, remrec_);
   END LOOP;
END Do_Remove__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Copy the relevant option values for a given characteristic.
PROCEDURE Copy (
   old_price_list_no_   IN VARCHAR2,
   new_price_list_no_   IN VARCHAR2,
   valid_from_date_     IN DATE,
   to_valid_from_date_  IN DATE,
   part_no_             IN VARCHAR2,
   spec_revision_no_    IN NUMBER,
   characteristic_id_   IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   currency_rate_       IN NUMBER)
IS
   newrec_              OPTION_VALUE_PRICE_LIST_TAB%ROWTYPE;
   objid_               OPTION_VALUE_PRICE_LIST.objid%TYPE;
   objversion_          OPTION_VALUE_PRICE_LIST.objversion%TYPE;
   attr_                VARCHAR2(32000);
   valid_date_          DATE;
   new_valid_from_date_ DATE;

   -- Select all options for a given price_list_no, part_no, catalog_no, characteristic_id and spec_revision_no
   CURSOR get_all_options IS
      SELECT *
      FROM   OPTION_VALUE_PRICE_LIST_TAB
      WHERE  price_list_no = old_price_list_no_
      AND    part_no = part_no_
      AND    catalog_no = catalog_no_
      AND    characteristic_id = characteristic_id_
      AND    spec_revision_no  = spec_revision_no_;

   -- select distinct option_value_ids for a given price_list_no, part_no, catalog_no, characteristic_id and spec_revision_no
   CURSOR get_distinct_options IS
      SELECT DISTINCT option_value_id
      FROM   OPTION_VALUE_PRICE_LIST_TAB
      WHERE  price_list_no = old_price_list_no_
      AND    part_no = part_no_
      AND    catalog_no = catalog_no_
      AND    characteristic_id = characteristic_id_
      AND    spec_revision_no  = spec_revision_no_;

   -- Suppose we have given a valid from date as 15-06-2008 when copying and there are three records with vaid_from_dates
   -- 13-06-2008,14-06-2008 and 16-06-2008, this cursor will select 14-06-2008 as the date that we should consider when copying records
   CURSOR get_rec_with_max_valid_from(option_value_id_ IN VARCHAR2, valid_date_ IN DATE) IS
      SELECT MAX(valid_from_date)
      FROM   OPTION_VALUE_PRICE_LIST_TAB
      WHERE  price_list_no = old_price_list_no_
      AND    part_no = part_no_
      AND    catalog_no = catalog_no_
      AND    spec_revision_no = spec_revision_no_
      AND    characteristic_id = characteristic_id_
      AND    option_value_id = option_value_id_
      AND    valid_from_date <= valid_date_;


   CURSOR get_valid_options(option_value_id_ IN VARCHAR2, valid_date_ IN DATE) IS
      SELECT *
      FROM   OPTION_VALUE_PRICE_LIST_TAB
      WHERE  price_list_no = old_price_list_no_
      AND    part_no = part_no_
      AND    catalog_no = catalog_no_
      AND    spec_revision_no = spec_revision_no_
      AND    characteristic_id = characteristic_id_
      AND    option_value_id = option_value_id_
      AND    valid_from_date >= valid_date_;

BEGIN
   IF (valid_from_date_ IS NULL) THEN
      -- Copy all option values
      FOR next_ IN get_all_options LOOP

         IF NOT Check_Exist___(new_price_list_no_, part_no_, spec_revision_no_, characteristic_id_, next_.option_value_id, next_.valid_from_date, catalog_no_) THEN
            Client_SYS.Clear_Attr(attr_);
            newrec_               := next_;
            newrec_.price_list_no := new_price_list_no_;
            newrec_.fixed_amount  := next_.fixed_amount * NVL(currency_rate_, 1);
            newrec_.rowkey        := NULL;
            Insert___(objid_, objversion_, newrec_, attr_);
         END IF;
      END LOOP;
   ELSE
      -- Copy rows that are valid for the specified valid_from_date_
      FOR distinct_rec_ IN get_distinct_options LOOP
         -- Used get_rec_with_max_valid_from in order to find the maximum valid from date of the records which satisfies the condition <= specified valid_from_date_
         OPEN get_rec_with_max_valid_from(distinct_rec_.option_value_id, valid_from_date_);
         FETCH get_rec_with_max_valid_from INTO valid_date_;
         CLOSE get_rec_with_max_valid_from;

         -- IF no record found to satisfy the condition <= specified valid_from_date_ we take the valid_from_date_
         -- as the date that we should take for the comparison, when copying records
         valid_date_ := NVL(valid_date_, valid_from_date_);

         FOR next_ IN get_valid_options(distinct_rec_.option_value_id, valid_date_) LOOP
            -- IF a to_valid_from_date_ is given we will use that date as the valid_from_date of the new records
            -- IF not, depending on the valid_from_date of the old records and the given valid_from_date when copying, fetch the dates for the new records
            IF (to_valid_from_date_ IS NULL) THEN
               IF (valid_from_date_ > next_.valid_from_date) THEN
                  new_valid_from_date_ := valid_from_date_ ;
               ELSE
                  new_valid_from_date_ := next_.valid_from_date;
               END IF;
            ELSE
               new_valid_from_date_ := to_valid_from_date_;
            END IF;

            IF NOT Check_Exist___(new_price_list_no_, part_no_, spec_revision_no_, characteristic_id_, next_.option_value_id, new_valid_from_date_, catalog_no_) THEN
               Client_SYS.Clear_Attr(attr_);
               newrec_                 := next_;
               newrec_.price_list_no   := new_price_list_no_;
               newrec_.valid_from_date := new_valid_from_date_;
               newrec_.fixed_amount    := next_.fixed_amount * NVL(currency_rate_, 1);
               newrec_.rowkey          := NULL;

               Insert___(objid_, objversion_, newrec_, attr_);

               -- IF we have given a to_valid_from_date_ then we can copy only one record
               IF (to_valid_from_date_ IS NOT NULL) THEN
                  EXIT;
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   END IF;
END Copy;


-- Is_Valid_Price_List
--   Check the Validity of the price list
FUNCTION Is_Valid_Price_List (
   price_list_no_     IN VARCHAR2,
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2,
   option_value_id_   IN VARCHAR2,
   contract_          IN VARCHAR2,
   currency_code_     IN VARCHAR2,
   catalog_no_        IN VARCHAR2,
   validity_date_     IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   found_  VARCHAR2(5) := 'FALSE';
   date_   DATE;

   CURSOR exist_control IS
      SELECT 'TRUE'
      FROM   OPTION_VALUE_PRICE_LIST_TAB
      WHERE option_value_id = option_value_id_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_;
BEGIN
   IF (validity_date_ IS NULL) THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := validity_date_;
   END IF;
   -- Check that price list is valid
   IF (Sales_Price_List_API.Is_Valid( price_list_no_, contract_, catalog_no_, date_ ) OR
       Sales_Price_List_API.Is_Valid_Assort( price_list_no_, contract_, catalog_no_, date_ )) THEN
      OPEN exist_control;
      FETCH exist_control INTO found_;
      IF exist_control%NOTFOUND THEN
         found_ := 'FALSE';
      END IF;
      CLOSE exist_control;
   END IF;
   RETURN found_;
END Is_Valid_Price_List;


-- Get_Price_List_Infos
--   Return information from Price List.
PROCEDURE Get_Price_List_Infos (
   offset_value_       OUT NUMBER,
   fixed_amount_       OUT NUMBER,
   fixed_amt_incl_tax_ OUT NUMBER,
   multiply_by_qty_    OUT VARCHAR2,
   price_list_no_      IN  VARCHAR2,
   part_no_            IN  VARCHAR2,
   spec_revision_no_   IN  NUMBER,
   characteristic_id_  IN  VARCHAR2,
   option_value_id_    IN  VARCHAR2,
   char_value_         IN  NUMBER,
   char_qty_           IN  NUMBER,
   contract_           IN  VARCHAR2,
   catalog_no_         IN  VARCHAR2,
   validity_date_      IN  DATE DEFAULT NULL )
IS
   date_  DATE;

   CURSOR GetInfos IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method
      FROM OPTION_VALUE_PRICE_LIST_TAB
      WHERE valid_from_date IN
         ( SELECT MAX(valid_from_date)
            FROM OPTION_VALUE_PRICE_LIST_TAB
            WHERE  valid_from_date <= date_
               AND option_value_id = option_value_id_
               AND characteristic_id = characteristic_id_
               AND spec_revision_no = spec_revision_no_
               AND part_no = part_no_
               AND price_list_no = price_list_no_
               AND catalog_no = catalog_no_)
      AND option_value_id = option_value_id_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_;
BEGIN

   IF (validity_date_ IS NULL)  THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := validity_date_;
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
END Get_Price_List_Infos;


PROCEDURE Delete_Option_Values (
   price_list_no_     IN VARCHAR2,
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2,
   catalog_no_        IN VARCHAR2 )
IS
      objid_ VARCHAR2(2000);
      objversion_ VARCHAR2(2000);
      info_ VARCHAR2(2000);

      CURSOR get_all_option_ IS
      SELECT option_value_id,valid_from_date
      FROM   OPTION_VALUE_PRICE_LIST_TAB
      WHERE  part_no = part_no_
      AND    spec_revision_no = spec_revision_no_
      AND    characteristic_id = characteristic_id_
      AND    price_list_no = price_list_no_
      AND    catalog_no = catalog_no_;
BEGIN
   FOR all_option IN get_all_option_ LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_,price_list_no_,part_no_,spec_revision_no_,characteristic_id_,all_option.option_value_id,all_option.valid_from_date,catalog_no_);
      Remove__ (info_,objid_,objversion_,'DO');
   END LOOP;
END Delete_Option_Values;


-- Copy_Revision_Price
--   Copies pricing details from one spec revision to another.
PROCEDURE Copy_Revision_Price (
  price_list_no_        IN VARCHAR2,
  part_no_              IN VARCHAR2,
  characteristic_id_    IN VARCHAR2,
  option_value_id_      IN VARCHAR2,
  valid_from_date_      IN DATE,
  old_spec_revision_no_ IN NUMBER,
  new_spec_revision_no_ IN NUMBER,
  catalog_no_           IN VARCHAR2 )
IS
   newrec_       OPTION_VALUE_PRICE_LIST_TAB%ROWTYPE;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(2000);

   CURSOR get_oldrec IS
      SELECT *
      FROM OPTION_VALUE_PRICE_LIST_TAB
      WHERE price_list_no = price_list_no_
      AND   part_no = part_no_
      AND   spec_revision_no = old_spec_revision_no_
      AND   characteristic_id = characteristic_id_
      AND   option_value_id = option_value_id_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no = catalog_no_;
BEGIN

   OPEN get_oldrec;
   FETCH get_oldrec INTO newrec_;
   IF get_oldrec%FOUND THEN
      CLOSE get_oldrec;
      newrec_.spec_revision_no := new_spec_revision_no_;
      newrec_.rowkey := NULL;
      Client_SYS.Clear_Attr(attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      CLOSE get_oldrec;
   END IF;
END Copy_Revision_Price;



