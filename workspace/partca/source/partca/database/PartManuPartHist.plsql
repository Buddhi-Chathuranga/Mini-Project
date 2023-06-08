-----------------------------------------------------------------------------
--
--  Logical unit: PartManuPartHist
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201218  SBalLK  Issue SC2020R1-11830, Modified Generate_History() method by removing attr_ functionality to optimize the performance.
--  130729  MaIklk  TIBE-1044, Removed inst_NatoStckPartCat_ global constant and used conditional compilation instead.
--  100120  HimRlk   Moved method calls to Transaction_SYS.Logical_Unit_Is_Installed to Global constants.
--  071129  HoInlk  Bug 66539, Increased length of column NATO_STOCK_NUMBER of view
--  071129          PART_MANU_PART_HIST upto 16.
--  060802  NaWilk  Used Part_Catalog_API.Get_Description insted of public rec.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060601  MiErlk  Enlarge Identity - Changed view comments Description.
--  ------------------------- 12.4.0 ---------------------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050916  NaLrlk  Removed unused variables.
--  050620  RoJalk  Bug 51743, Changed the length of preferred_manufacturer to STRING(20) in 
--  050620          PART_MANU_PART_HIST view. Included validations for preferred_manufacturer in
--  050620          Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040224  LoPrlk  Removed substrb from code. &VIEW was altered.
--  -----------------------------12.3.0-------------------------
--  030225  AnLaSe  Used Design to update file after changing rowversion to use type date.
--  030221  Shvese  Changed rowversion from number to date.
--  *****************TSO Merge***********************************************
--  021008  chbalk  Added new attribute to the PartManuPartHist table and
--                  change the parameters in Generate_History method.
--  020620  jagrno  Minor corrections.
--  020605  ToFj    Updated in accordance with spec
--  020515  pask    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Generate_Seq_No___
--   - Generate a unique sequence number used as primary key
FUNCTION Generate_Seq_No___ RETURN NUMBER
IS
   CURSOR c_part_catalog_seq IS
      SELECT part_manu_part_hist_seq.nextval
      FROM dual;
   seq_ part_manu_part_hist_tab.seq_no%TYPE;
BEGIN
   OPEN c_part_catalog_seq;
   FETCH c_part_catalog_seq INTO seq_;
   CLOSE c_part_catalog_seq;
   RETURN (seq_);
END Generate_Seq_No___;


-- Get_Additional_Info___
--   - Gets additional info, such as part descriptions, before new entry is stored.
PROCEDURE Get_Additional_Info___ (
   newrec_ IN OUT part_manu_part_hist_tab%ROWTYPE,
   attr_   IN OUT VARCHAR2 )
IS   
   part_rec_         Part_Catalog_API.Public_Rec;
   manufacturer_rec_ Manufacturer_Info_API.Public_Rec;
BEGIN
   -- get additional values for part
   part_rec_ := Part_Catalog_API.Get(newrec_.part_no);
   newrec_.part_description := Part_Catalog_API.Get_Description(newrec_.part_no);
   Client_SYS.Add_To_Attr('PART_DESCRIPTION', newrec_.part_description, attr_);
   newrec_.part_std_name := Standard_Names_API.Get_Std_Name(part_rec_.std_name_id);
   Client_SYS.Add_To_Attr('PART_STD_NAME', newrec_.part_std_name, attr_);
   -- get additional values for manufacturer from ENTERP
   manufacturer_rec_ := Manufacturer_Info_API.Get(newrec_.manufacturer_no);
   newrec_.manufacturer_name := manufacturer_rec_.name;
   Client_SYS.Add_To_Attr('MANUFACTURER_NAME', newrec_.manufacturer_name, attr_);
   -- get additional values for NATO stock number from NATSTD (dynamic)
   $IF (Component_Natstd_SYS.INSTALLED) $THEN
      -- get the NATO stock number of the part
      newrec_.nato_stock_number := Nato_Stock_Part_Catalog_API.Get_Stock_Number( newrec_.part_no); 
      -- if stock number found, get additional stock number info
      IF (newrec_.nato_stock_number IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('NATO_STOCK_NUMBER', newrec_.nato_stock_number, attr_);
         --
         newrec_.stock_number_id := Nato_Stock_Number_API.Get_Stock_Number_Id(newrec_.nato_stock_number); 
         Client_SYS.Add_To_Attr('STOCK_NUMBER_ID', newrec_.stock_number_id, attr_);
         --
         newrec_.nato_stock_description := Nato_Stock_Number_API.Get_Description(newrec_.stock_number_id);
         Client_SYS.Add_To_Attr('NATO_STOCK_DESCRIPTION', newrec_.nato_stock_description, attr_);
      END IF;
   $END
END Get_Additional_Info___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_manu_part_hist_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- server defaults
   newrec_.seq_no := Generate_Seq_No___;
   Client_SYS.Add_To_Attr('SEQ_NO', newrec_.seq_no, attr_);
   newrec_.date_created := sysdate;
   Client_SYS.Add_To_Attr('DATE_CREATED', newrec_.date_created, attr_);
   newrec_.user_created := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('USER_CREATED', newrec_.user_created, attr_);
   Get_Additional_Info___(newrec_, attr_);
   --
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Generate_History
--   - Method that generates history when the attributes ManuPartNo or NatoNo are
--   changed and when a record is deleted from PartCatalogManufacturer.
PROCEDURE Generate_History (
   part_no_                IN VARCHAR2,
   manufacturer_no_        IN VARCHAR2,
   manu_part_no_           IN VARCHAR2,
   preferred_manu_part_    IN VARCHAR2,
   approved_               IN VARCHAR2,
   approved_date_          IN DATE,
   approved_user_          IN VARCHAR2,
   approved_note_          IN VARCHAR2,
   history_purpose_        IN VARCHAR2,
   preferred_manufacturer_ IN VARCHAR2 )
IS
   newrec_      part_manu_part_hist_tab%ROWTYPE;
   attr_        VARCHAR2(32000);
   indrec_      Indicator_Rec;
BEGIN
   --
   Prepare_Insert___(attr_);
   Unpack___(newrec_, indrec_, attr_);
   
   newrec_.part_no                := part_no_;
   newrec_.manufacturer_no        := manufacturer_no_;
   newrec_.manu_part_no           := manu_part_no_;
   newrec_.preferred_manu_part    := preferred_manu_part_;
   newrec_.approved               := approved_;
   newrec_.approved_user          := approved_user_;
   newrec_.approved_note          := approved_note_;
   newrec_.approved_date          := approved_date_;
   newrec_.history_purpose        := history_purpose_;
   newrec_.preferred_manufacturer := preferred_manufacturer_;
   New___(newrec_);
END Generate_History;



