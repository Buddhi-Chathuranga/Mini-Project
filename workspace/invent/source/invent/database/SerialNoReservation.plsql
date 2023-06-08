-----------------------------------------------------------------------------
--
--  Logical unit: SerialNoReservation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210423  Disklk  PJ21R2-448, Removed pdmpro references.
--  170809  DAYJLK  STRSC-10729, Modified Check_Insert___ to ensure that only the permitted characters are used in the serial numbers that are reserved.
--  170704  BudKlk  Bug 136234, Modified method Check_Insert___() to make sure that the orginal value will be save when the serial rule is automatic.
--  170505  ShPrlk  Bug 135138, Modified Check_Insert___ to stop the conversion of serial_no to number, when the serial number already exists.
--  170307  SWiclk  Bug 134659, Modified Get_Reserved_Serial_Tab() in order to sort the serials.
--  160706  ChFolk  STRSC-2730, Removed Public_Rec and Reserved_Serial_Table Types and replaced the usages from Part_Serial_Catalog_API.Serial_No_Tab.
--  160531  PrYaLK  Bug 127654, Added new functions Get_All_Serials_With_State() and New_Clob().
--  151214  NaSalk  LIM-5153, Added Get_Reserved_Serial_List.
--  140918  BudKlk  Bug 118711, Created a new function Has_Alphanumeric_Serial().
--  130903  SBalLK  Bug 111695, Modified Unpack_Check_Insert___() method by converting serial number to a number
--  130903          value when the serial rule is automatic.
--  130805  MaRalk  TIBE-903, Removed global LU constant inst_ShopOrd_ and modified methodS Unpack_Check_Insert___,  
--  130805          Check_Delete___ using conditional compilation instead.
--  121121  RiLase  Added method Serial_Is_Reserved_For_Source.
--  101015  GayDLK  Bug 93374, Changed the place where the comments were added from the previous correction of the same bug.
--  101005  GayDLK  Bug 93374, Added a '-' as the Update Flag for ORDER_REF1,ORDER_REF2 and ORDER_REF3 columns in 
--  101005          SO_SERIAL_RESERVE_LOV view.
--  100505  KRPELK  Merge Rose Method Documentation.
--  090930  ChFolk  Removed unused variables in the package.
--  --------------------------------- 14.0.0 --------------------------------
--  081023  UTSWLK  Bug 77113, Added new functions Get_Min_Serial and Get_Max_Serial.
--  080808  Prawlk  Bug 75586, Deleted call for General_SYS.Init_Method in PROCEDURE Get_Min_Max_Serials.
--  080528  HoInlk  Bug 73830, Removed conditions for checking not null values in Modify.
--  080425  MaEelk  Bug 73302, Removed the correction 72452 and re-structured the code in Unpack_Check_Insert___
--  080402  UTSWLK  Bug 72452, Modified Unpack_Check_Insert___ to assign string_null_ if order_code_ is null.
--  070425  Haunlk   Checked and added assert_safe comments where necessary.
--  060817  KaDilk  Reverse the public cursor removal changes done.
--  060721  KaDilk  Added Function Get_Part_Serial_No That return plsql table Part_Serial_No_Tab.
--  060721           Removed public cursor get_part_serial_no_cur.
--  060515  Asawlk  Bug 56705, Modified Check_Delete___ in order to handle Shop Order connected warnings.
--  060124  NiDalk  Added Assert safe annotation.
--  060119  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___
--  060119          and added UNDEFINE according to the new template.
--  050412  SeJalk  Bug 50050, Added function Get_Reserved_Serial_Tab() to return table of serial no records.
--  040826  LeSvse  Bug 27735, modified method Unpack_Check_Insert___ to handle Repair shoporder. Added global constant.
--  040812  NuFilk  Modified procedure Check_Update_Serial_Tracking changed the error message.
--  040714  ChFolk  Bug 45838, modified procedure Check_Update_Serial_Tracking to check serial reservations in Purchase Orders.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  --------------------------------- 13.3.0 --------------------------------
--  040114  ErSolk  Bug 39502, Added procedure Check_Update_Serial_Tracking.
--  020718  BEHAUS  Merged Lot Batch Mod.Added SO_SERIAL_RESERVATION LOV view.
--  020523  NASALK  Extended length of Serial no from VARCHAR2(15) to VARCHAR2(50) in view comments
--                  and in Get_Min_Max_Serials, Get_Max_Serial_No functions
--  020205  JABALK  Bug Fix 26409,Modified the cursor to convert the serial no into number in the Func:Get_Max_Serial_No.
--  010110  PERK    Changed cursor get_serial_no in Delete_Reserved
--  000925  JOHESE  Added undefines.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  990617  SHVE    Corrected error message RESERVEXIST.
--  990503  SHVE    Replaced serial_reservation_source with serial_reservation_source_db
--                  in all public methods and the public cursor.
--  990430  SHVE    General performance improvements.
--  990409  SHVE    Updraded to Perfomance optimized template.
--  990401  SHVE    Changed the error message for existing reservations.
--  990319  SHVE    Added column serial_reservation_used and
--                  Modify_Serial_Reservation_Used.
--  990317  SHVE    Added validations for alphanumeric serials. Added method
--                  Added method Check_Part_Serial_Exist.
--  990222  SHVE    Added method Get_Count_Reservation.
--  990209  SHVE    Added methods Modify, Get_Min_Max_Serials.
--  990208  SHVE    Fixed Delete_Reserved to handle null values in order_ref4.
--  990203  ROOD    Removed the use of Gen_Def_Key_Value with hardcoded '*' in Unpack_Check_...
--  990202  SHVE    Added methods Check_Reservation_Exist and Get_Max_Serial_No.
--  990126  SHVE    Added method Check_Exist.
--  990120  LEPE    Added public cursor get_part_serial_no_cur.
--  981228  JOKE    Added validation that you don't use a asterisk as a serial_no.
--  981201  SHVE    Added methods Get_Reservation_Info and Delete_Reserved.
--  981112  SHVE    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE part_serial_no_record
 IS RECORD (part_no   VARCHAR2(25),
            serial_no VARCHAR2(50));  

CURSOR Get_Part_Serial_No_Cur (order_ref1_ IN VARCHAR2,
                               order_ref2_ IN VARCHAR2,
                               order_ref3_ IN VARCHAR2,
                               order_ref4_ IN NUMBER,
                               serial_reservation_source_db_ IN VARCHAR2)
                               RETURN part_serial_no_record IS
   SELECT part_no, serial_no
   FROM   SERIAL_NO_RESERVATION_TAB
   WHERE  order_ref1                = order_ref1_
   AND    NVL(order_ref2,'DUMMY')   = NVL(order_ref2_,NVL(order_ref2,'DUMMY'))
   AND    NVL(order_ref3,'DUMMY')   = NVL(order_ref3_,NVL(order_ref3,'DUMMY'))
   AND    NVL(order_ref4,0)         = NVL(order_ref4_,NVL(order_ref4,0))
   AND    serial_reservation_source = serial_reservation_source_db_;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT serial_no_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_          VARCHAR2(30);
   value_         VARCHAR2(4000);
   allow_reserve_existing_serial_ VARCHAR2(5) := 'FALSE';   
   partca_rec_    Part_Catalog_API.Public_Rec;
   dummy_         NUMBER;
BEGIN
   IF (newrec_.serial_reservation_used IS NULL) THEN
      newrec_.serial_reservation_used := 'NOT USED';
   END IF;
   super(newrec_, indrec_, attr_);

   IF (newrec_.serial_no = '*') THEN
      Error_SYS.Record_General(lu_name_, 'NOASTERISK: Asterisk not allowed as a serial number.');
   END IF;
   
   -- Ensure that only the permitted characters are used in the serial numbers that are reserved
   Error_SYS.Check_Valid_Key_String('SERIAL_NO', newrec_.serial_no);
   
   -- check if serial no exists in PartSerialCatalog
   IF (Part_Serial_Catalog_API.Check_Exist(newrec_.part_no, newrec_.serial_no) = 'TRUE') THEN
      $IF Component_Shpord_SYS.INSTALLED $THEN
         IF (newrec_.serial_reservation_source = 'SHOP ORDER') THEN
            IF (Shop_Ord_API.Allow_Reserve_Existing_Serial(newrec_.order_ref1, 
                                                           newrec_.order_ref2, 
                                                           newrec_.order_ref3)) THEN
               allow_reserve_existing_serial_ := 'TRUE';
            END IF;   
         END IF;            
      $END  
      IF (allow_reserve_existing_serial_ = 'FALSE') THEN
         Error_Sys.Record_General(lu_name_, 'SERIALEXIST: Serial number(:P1) is already used by this part.',newrec_.serial_no);
      END IF;
   ELSE
      partca_rec_ := Part_Catalog_API.Get(newrec_.part_no);
   
      -- check if valid number for serial rule automatic
      BEGIN
         IF ( partca_rec_.serial_rule = 'AUTOMATIC') THEN
            -- Assigned the number value to the dummy_ variable.
            dummy_ := TO_NUMBER(newrec_.serial_no);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            Error_SYS.Record_General(lu_name_, 'VALIDNUMBER: Alphanumeric serials(:P1) are not allowed when serial rule is :P2',newrec_.serial_no,Part_Serial_Rule_API.Decode( partca_rec_.serial_rule ));
      END;

   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     serial_no_reservation_tab%ROWTYPE,
   newrec_ IN OUT serial_no_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.serial_no = '*') THEN
      Error_SYS.Record_General(lu_name_, 'NOASTERISK: Asterisk not allowed as a serial number.');
   END IF;

   IF (newrec_.serial_reservation_used IS NULL) THEN
      newrec_.serial_reservation_used := 'NOT USED';
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ serial_no_reservation_tab%ROWTYPE )
IS
  concat_  VARCHAR2(200);
  oldrec_  SERIAL_NO_RESERVATION_TAB%ROWTYPE;
BEGIN
   oldrec_ := Get_Object_By_Keys___(rec_.part_no, rec_.serial_no);
   concat_ := Serial_Reservation_Source_API.Decode(oldrec_.serial_reservation_source)||'-'||oldrec_.order_ref1||'  '||oldrec_.order_ref2||'  '||oldrec_.order_ref3||'  '||oldrec_.order_ref4;
   Error_Sys.Record_Exist(lu_name_, 'RESERVEXIST: Serial no(:P1) is reserved by :P2 ',rec_.serial_no,concat_);
   
   super(rec_);
END Raise_Record_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   remrec_     SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   objid_      SERIAL_NO_RESERVATION.objid%TYPE;
   objversion_ SERIAL_NO_RESERVATION.objversion%TYPE;
BEGIN
   remrec_ := Get_Object_By_Keys___(part_no_, serial_no_);
   IF (remrec_.part_no is NOT NULL) THEN
      Get_Id_Version_By_Keys___(objid_,objversion_,part_no_,serial_no_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
END Remove;


PROCEDURE New (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2 )
IS
   newrec_      SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
   attr_        VARCHAR2 (32000);
   objid_       SERIAL_NO_RESERVATION.objid%TYPE;
   objversion_  SERIAL_NO_RESERVATION.objversion%TYPE;
BEGIN
   IF (serial_no_ = '*') THEN
      RETURN;
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
   IF (order_ref1_ IS NOT NULL) THEN
     Client_SYS.Add_To_Attr('ORDER_REF1', order_ref1_, attr_);
   END IF;
   IF (order_ref2_ IS NOT NULL) THEN
     Client_SYS.Add_To_Attr('ORDER_REF2', order_ref2_, attr_);
   END IF;
   IF (order_ref3_ IS NOT NULL) THEN
     Client_SYS.Add_To_Attr('ORDER_REF3', order_ref3_, attr_);
   END IF;
   IF (order_ref4_ IS NOT NULL) THEN
     Client_SYS.Add_To_Attr('ORDER_REF4', order_ref4_, attr_);
   END IF;
   IF (serial_reservation_source_db_ IS NOT NULL) THEN
     Client_SYS.Add_To_Attr('SERIAL_RESERVATION_SOURCE_DB', serial_reservation_source_db_, attr_);
   END IF;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


PROCEDURE Get_Reservation_Info (
   order_ref1_ OUT VARCHAR2,
   order_ref2_ OUT VARCHAR2,
   order_ref3_ OUT VARCHAR2,
   order_ref4_ OUT NUMBER,
   serial_reservation_source_db_ OUT VARCHAR2,
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   currec_  SERIAL_NO_RESERVATION_TAB%ROWTYPE;
BEGIN
   currec_ := Get_Object_By_Keys___(part_no_, serial_no_);
   order_ref1_ := currec_.order_ref1;
   order_ref2_ := currec_.order_ref2;
   order_ref3_ := currec_.order_ref3;
   order_ref4_ := currec_.order_ref4;
   serial_reservation_source_db_ := currec_.serial_reservation_source;
END Get_Reservation_Info;


PROCEDURE Delete_Reserved (
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2 DEFAULT NULL )
IS
   remrec_                            SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   objid_                             SERIAL_NO_RESERVATION.objid%TYPE;
   objversion_                        SERIAL_NO_RESERVATION.objversion%TYPE;

   CURSOR get_serial_no IS
      SELECT *
      FROM SERIAL_NO_RESERVATION_TAB
      WHERE serial_reservation_source = Nvl(serial_reservation_source_db_,'SHOP ORDER')
        AND NVL(order_ref4, 0) = NVL(order_ref4_, 0)
        AND NVL(order_ref3,'DUMMY') = NVL(order_ref3_,'DUMMY')
        AND NVL(order_ref2,'DUMMY') = NVL(order_ref2_,'DUMMY')
        AND NVL(order_ref1,'DUMMY') = NVL(order_ref1_,'DUMMY');

BEGIN

   OPEN get_serial_no;
   LOOP
       FETCH get_serial_no INTO remrec_;
       EXIT WHEN get_serial_no%NOTFOUND;
       Get_Id_Version_By_Keys___(objid_,objversion_,remrec_.part_no,remrec_.serial_no);
       Check_Delete___(remrec_);
       Delete___(objid_, remrec_);
   END LOOP;
   CLOSE get_serial_no;
END Delete_Reserved;


-- Check_Exist
--   Checks the existance of an instance and returns the string 'TRUE' or 'FALSE'
@UncheckedAccess
FUNCTION Check_Exist (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(part_no_, serial_no_ )) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


-- Get_Max_Serial_No
--   Checks the last serial no created in PartSerialCatalog and also the
--   last serial no reserved for a part and determines the max serial no used.
@UncheckedAccess
FUNCTION Get_Max_Serial_No (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   max_part_serial_no_ SERIAL_NO_RESERVATION_TAB.serial_no%TYPE;
   max_reserved_serial_no_ SERIAL_NO_RESERVATION_TAB.serial_no%TYPE;
   max_serial_no_ SERIAL_NO_RESERVATION_TAB.serial_no%TYPE;

   n_max_part_serial_no_       NUMBER;
   n_max_reserved_serial_no_ NUMBER;

   CURSOR Get_Max_Reserved_Serial_No IS
      SELECT serial_no
      FROM SERIAL_NO_RESERVATION_TAB
      WHERE part_no   = part_no_
      AND   TO_NUMBER(LPAD(serial_no,50)) = (SELECT MAX(TO_NUMBER(LPAD(serial_no,50))) 
                         FROM SERIAL_NO_RESERVATION_TAB
                         WHERE part_no = part_no_);
BEGIN
  BEGIN
   OPEN Get_Max_Reserved_Serial_No;
   FETCH Get_Max_Reserved_Serial_No INTO max_reserved_serial_no_;
   CLOSE Get_Max_Reserved_Serial_No;
   n_max_reserved_serial_no_:= To_Number(max_reserved_serial_no_);
  EXCEPTION
   WHEN others THEN
    RETURN max_reserved_serial_no_;
  END;

  BEGIN
    max_part_serial_no_ := Part_Serial_Catalog_API.Get_Max_Part_Serial_No(part_no_);
    n_max_part_serial_no_ := To_Number(max_part_serial_no_);
  EXCEPTION
    WHEN others THEN
     RETURN max_part_serial_no_;
  END;

  IF (Nvl(n_max_reserved_serial_no_,0) >= Nvl(n_max_part_serial_no_,0)) THEN
      max_serial_no_ := max_reserved_serial_no_;
  ELSE
      max_serial_no_ := max_part_serial_no_;
  END IF;
  RETURN Nvl(max_serial_no_,0);
EXCEPTION
 WHEN others THEN
  RETURN  0;
END Get_Max_Serial_No;


-- Check_Reservation_Exist
--   Checks if a serial no is reserved for an order and returns the
--   string 'TRUE' or 'FALSE'
@UncheckedAccess
FUNCTION Check_Reservation_Exist (
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   check_                             VARCHAR2(5);

   CURSOR check_reservation IS
      SELECT 1
      FROM SERIAL_NO_RESERVATION_TAB
      WHERE  NVL(serial_reservation_source,'DUMMY') =
              NVL(serial_reservation_source_db_,NVL(serial_reservation_source,'DUMMY'))
        AND NVL(order_ref4,0)         = NVL(order_ref4_,NVL(order_ref4,0))
        AND NVL(order_ref3,'DUMMY')   = NVL(order_ref3_,NVL(order_ref3,'DUMMY'))
        AND NVL(order_ref2,'DUMMY')   = NVL(order_ref2_,NVL(order_ref2,'DUMMY'))
        AND NVL(order_ref1,'DUMMY')   = NVL(order_ref1_,NVL(order_ref1,'DUMMY'))
        AND part_no = part_no_;
BEGIN

   OPEN check_reservation;
   FETCH check_reservation INTO check_;
   IF (check_reservation%FOUND) THEN
      CLOSE check_reservation;
      RETURN('TRUE');
   END IF;
   CLOSE check_reservation;
   RETURN ('FALSE');
END Check_Reservation_Exist;


-- Serial_Is_Reserved_For_Source
--   Checks if a specific serial no is reserved for an order.
@UncheckedAccess
FUNCTION Serial_Is_Reserved_For_Source (
   part_no_                      IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   order_ref1_                   IN VARCHAR2,
   order_ref2_                   IN VARCHAR2,
   order_ref3_                   IN VARCHAR2,
   order_ref4_                   IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_                           SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   serial_is_reserved_for_source_ BOOLEAN               := FALSE;
   string_null_                   CONSTANT VARCHAR2(15) := Database_SYS.string_null_;
   number_null_                   CONSTANT NUMBER       := -99999999;
BEGIN
   rec_ := Get_Object_By_Keys___(part_no_, serial_no_);

   IF (rec_.part_no IS NOT NULL) THEN
      IF ((rec_.order_ref1                    = order_ref1_) AND
          (NVL(rec_.order_ref2, string_null_) = NVL(order_ref2_, string_null_)) AND
          (NVL(rec_.order_ref3, string_null_) = NVL(order_ref3_, string_null_)) AND
          (NVL(rec_.order_ref4, number_null_) = NVL(order_ref4_, number_null_)) AND
          (rec_.serial_reservation_source     = serial_reservation_source_db_)) THEN
         serial_is_reserved_for_source_ := TRUE;
      END IF;
   END IF;

   RETURN(serial_is_reserved_for_source_);
END Serial_Is_Reserved_For_Source;


-- Get_Min_Max_Serials
--   Fetches the minimum and maximum serial no generated for a order.
@UncheckedAccess
PROCEDURE Get_Min_Max_Serials (
   min_serial_no_ OUT VARCHAR2,
   max_serial_no_ OUT VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
   --

   CURSOR Get_Serial_Range IS
      SELECT MIN(LPAD(serial_no,50)), MAX(LPAD(serial_no,50)) 
      FROM SERIAL_NO_RESERVATION_TAB
      WHERE NVL(serial_reservation_source,'DUMMY') =
             NVL(serial_reservation_source_db_,'DUMMY')
         AND NVL(order_ref4,0)         = NVL(order_ref4_,NVL(order_ref4,0))
         AND NVL(order_ref3,'DUMMY') = NVL(order_ref3_,NVL(order_ref3,'DUMMY'))
         AND NVL(order_ref2,'DUMMY') = NVL(order_ref2_,NVL(order_ref2,'DUMMY'))
         AND NVL(order_ref1,'DUMMY')= NVL(order_ref1_,NVL(order_ref1,'DUMMY'))
         AND part_no = part_no_;
   --
BEGIN
   OPEN Get_Serial_Range;
   FETCH Get_Serial_Range INTO min_serial_no_, max_serial_no_;
   CLOSE Get_Serial_Range;
   min_serial_no_ := LTRIM(min_serial_no_);
   max_serial_no_ := LTRIM(max_serial_no_);
END Get_Min_Max_Serials;


-- Get_Min_Serial
--   Note: Return the minimun serial number reserved by the serial_reservation_source
--   for a given order reference.
@UncheckedAccess
FUNCTION Get_Min_Serial (
   order_ref1_                   IN VARCHAR2,
   order_ref2_                   IN VARCHAR2,
   order_ref3_                   IN VARCHAR2,
   order_ref4_                   IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2,
   part_no_                      IN VARCHAR2 ) RETURN VARCHAR2
IS 
   min_serial_no_      SERIAL_NO_RESERVATION_TAB.serial_no%TYPE;
   max_serial_no_      SERIAL_NO_RESERVATION_TAB.serial_no%TYPE;
BEGIN
   Get_Min_Max_Serials (min_serial_no_,
                        max_serial_no_,
                        order_ref1_,
                        order_ref2_,
                        order_ref3_,
                        order_ref4_,
                        serial_reservation_source_db_,
                        part_no_);
   RETURN min_serial_no_;
END Get_Min_Serial;


-- Get_Max_Serial
--   Note: Return the maximun serial number reserved by the serial_reservation_source
--   for a given order reference.
@UncheckedAccess
FUNCTION Get_Max_Serial (
   order_ref1_                   IN VARCHAR2,
   order_ref2_                   IN VARCHAR2,
   order_ref3_                   IN VARCHAR2,
   order_ref4_                   IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2,
   part_no_                      IN VARCHAR2 ) RETURN VARCHAR2
IS 
   min_serial_no_      SERIAL_NO_RESERVATION_TAB.serial_no%TYPE;
   max_serial_no_      SERIAL_NO_RESERVATION_TAB.serial_no%TYPE;
BEGIN
   Get_Min_Max_Serials (min_serial_no_,
                        max_serial_no_,
                        order_ref1_,
                        order_ref2_,
                        order_ref3_,
                        order_ref4_,
                        serial_reservation_source_db_,
                        part_no_);
   RETURN max_serial_no_;
END Get_Max_Serial;


-- Modify
--   Modifies an instance of serial number reservation.
PROCEDURE Modify (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2 )
IS
   oldrec_     SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   newrec_     SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   attr_       VARCHAR2 (32000);
   objid_      SERIAL_NO_RESERVATION.objid%TYPE;
   objversion_ SERIAL_NO_RESERVATION.objversion%TYPE;

BEGIN

   oldrec_ := Lock_By_Keys___(part_no_,serial_no_);
   newrec_ := oldrec_;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ORDER_REF1', order_ref1_, attr_);
   Client_SYS.Add_To_Attr('ORDER_REF2', order_ref2_, attr_);
   Client_SYS.Add_To_Attr('ORDER_REF3', order_ref3_, attr_);
   Client_SYS.Add_To_Attr('ORDER_REF4', order_ref4_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_RESERVATION_SOURCE_DB', serial_reservation_source_db_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_,oldrec_, newrec_, attr_,objversion_,TRUE);

END Modify;


@UncheckedAccess
FUNCTION Get_Count_Reservation (
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   serial_reservation_source_db_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   count_  NUMBER;
   CURSOR count_reservation IS
      SELECT count(*)
      FROM SERIAL_NO_RESERVATION_TAB
      WHERE NVL(order_ref1,'DUMMY')   = NVL(order_ref1_,NVL(order_ref1,'DUMMY'))
        AND NVL(order_ref2,'DUMMY')   = NVL(order_ref2_,NVL(order_ref2,'DUMMY'))
        AND NVL(order_ref3,'DUMMY')   = NVL(order_ref3_,NVL(order_ref3,'DUMMY'))
        AND NVL(order_ref4,0)         = NVL(order_ref4_,NVL(order_ref4,0))
        AND NVL(serial_reservation_source,'DUMMY') =
              NVL(serial_reservation_source_db_,NVL(serial_reservation_source,'DUMMY'))
        AND part_no = part_no_;
BEGIN
   OPEN count_reservation;
   FETCH count_reservation INTO count_;
   IF (count_reservation%FOUND) THEN
      CLOSE count_reservation;
      RETURN(count_);
   END IF;
   CLOSE count_reservation;
   RETURN (0);
END Get_Count_Reservation;


PROCEDURE Check_Part_Serial_Exist (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   rec_        SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   concat_     VARCHAR2(200);

   CURSOR get_rec IS
      SELECT *
      FROM SERIAL_NO_RESERVATION_TAB
      WHERE part_no = part_no_
      AND   serial_no = serial_no_
      AND   serial_reservation_used LIKE 'NOT USED';

BEGIN

   OPEN get_rec;
   FETCH get_rec INTO rec_;
   IF (get_rec%FOUND) THEN
      CLOSE get_rec;
      concat_ := Serial_Reservation_Source_API.Decode(rec_.serial_reservation_source)||'-'||rec_.order_ref1||'  '||rec_.order_ref2||'  '||rec_.order_ref3||'  '||rec_.order_ref4;
      Error_Sys.Record_General(lu_name_, 'RESERVEXIST: Serial no(:P1) is reserved by :P2 ',serial_no_,concat_);
   END IF;
   CLOSE get_rec;
END Check_Part_Serial_Exist;


PROCEDURE Modify_Serial_Reservation_Used (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   serial_reservation_used_ IN VARCHAR2 )
IS
   oldrec_     SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   newrec_     SERIAL_NO_RESERVATION_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   attr_       VARCHAR2 (32000);
   objid_      SERIAL_NO_RESERVATION.objid%TYPE;
   objversion_ SERIAL_NO_RESERVATION.objversion%TYPE;

BEGIN

   oldrec_ := Lock_By_Keys___(part_no_,serial_no_);
   newrec_ := oldrec_;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SERIAL_RESERVATION_USED', serial_reservation_used_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_,oldrec_, newrec_, attr_,objversion_,TRUE);

END Modify_Serial_Reservation_Used;


-- Check_Update_Serial_Tracking
--   Note: Checks if serial no reservations exist when changing serial track code.
PROCEDURE Check_Update_Serial_Tracking (
   part_no_ IN VARCHAR2 )
IS
   order_no_              VARCHAR2(12);
   serial_reserv_source_  VARCHAR2(35);

   CURSOR check_serial_no_reservation IS
      SELECT order_ref1, serial_reservation_source
      FROM   SERIAL_NO_RESERVATION_TAB
      WHERE  part_no = part_no_;
BEGIN
   OPEN check_serial_no_reservation;
   FETCH check_serial_no_reservation INTO order_no_, serial_reserv_source_;
   CLOSE check_serial_no_reservation;
   IF (order_no_ IS NOT NULL) THEN
      IF (serial_reserv_source_ = 'SHOP ORDER') THEN
         Error_SYS.Record_General(lu_name_, 'SERIAL_NO_RESERVE_SO: Serial No is reserved for this parent part in Shop Order :P1. Remove Serial No Reservation before changing serial tracking.', order_no_);
      ELSIF (serial_reserv_source_ = 'PURCHASE ORDER') THEN
         Error_SYS.Record_General(lu_name_, 'SERIAL_NO_RESERVE_PO: Serial Number Reservation has been made for this part on Purchase Order :P1. Remove Serial Reservation before changing serial tracking.', order_no_);
      END IF;
   END IF;

END Check_Update_Serial_Tracking;


@UncheckedAccess
FUNCTION Get_Reserved_Serial_Tab (
   part_no_              IN VARCHAR2,
   order_ref1_           IN VARCHAR2,
   order_ref2_           IN VARCHAR2,
   order_ref3_           IN VARCHAR2,
   serial_res_source_db_ IN VARCHAR2 ) RETURN Part_Serial_Catalog_API.Serial_No_Tab
IS
   CURSOR get_serial_nos IS
      SELECT serial_no
      FROM   SERIAL_NO_RESERVATION_TAB
      WHERE  part_no                   = part_no_
      AND    order_ref1                = order_ref1_
      AND    (order_ref2               = order_ref2_ OR  order_ref2_ IS NULL)
      AND    (order_ref3               = order_ref3_ OR  order_ref3_ IS NULL)
      AND    serial_reservation_source = serial_res_source_db_
      ORDER BY Utility_SYS.String_To_Number(serial_no) ASC, serial_no ASC;
   serial_tab_  Part_Serial_Catalog_API.Serial_No_Tab;
   rows_        NUMBER := 0;
BEGIN
   FOR serial_rec_ IN get_serial_nos LOOP
      serial_tab_(rows_).serial_no := serial_rec_.serial_no;
      rows_ := rows_ + 1;
   END LOOP;
   RETURN serial_tab_;
END Get_Reserved_Serial_Tab;

   
FUNCTION Has_Alphanumeric_Serial (
   part_no_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR get_serials IS
      SELECT serial_no
      FROM   SERIAL_NO_RESERVATION_TAB
      WHERE  part_no = part_no_;
   n_serial_   NUMBER;
BEGIN
   FOR serial_rec_ IN get_serials LOOP
      n_serial_ := TO_NUMBER(serial_rec_.serial_no);
   END LOOP;
   RETURN FALSE;  
EXCEPTION
   WHEN OTHERS THEN
      RETURN TRUE;  
END Has_Alphanumeric_Serial;
   
@UncheckedAccess
FUNCTION Get_Reserved_Serial_List (
   part_no_              IN VARCHAR2,
   order_ref1_           IN VARCHAR2,
   order_ref2_           IN VARCHAR2,
   order_ref3_           IN VARCHAR2,
   serial_res_source_db_ IN VARCHAR2 ) RETURN CLOB
IS
   serial_tab_   Part_Serial_Catalog_API.Serial_No_Tab;
   serial_list_  CLOB;
BEGIN
   serial_tab_ := Get_Reserved_Serial_Tab(part_no_, order_ref1_, order_ref2_, order_ref3_, serial_res_source_db_); 
   IF (serial_tab_.COUNT > 0) THEN
      FOR i IN serial_tab_.FIRST..serial_tab_.LAST LOOP
         IF (serial_list_ IS NULL) THEN 
            serial_list_ := serial_tab_(i).serial_no;
         ELSE
            serial_list_ := serial_list_ || Client_SYS.text_separator_ || serial_tab_(i).serial_no;  
         END IF;   
      END LOOP;
   END IF; 
   RETURN serial_list_;
END Get_Reserved_Serial_List; 


FUNCTION Get_All_Serials_With_State (
   serial_no_attr_        IN    CLOB,
   part_no_               IN    VARCHAR2 ) RETURN CLOB
IS
   local_serial_list_   CLOB;
   dummy_number_        NUMBER;
   serial_no_tab_       utility_sys.STRING_TABLE;

BEGIN
   Utility_SYS.Tokenize(serial_no_attr_, Client_Sys.record_separator_, serial_no_tab_, dummy_number_);
   
   IF (serial_no_tab_.COUNT > 0) THEN
      FOR i_ IN serial_no_tab_.FIRST..serial_no_tab_.LAST LOOP
         Serial_No_Reservation_API.Check_Part_Serial_Exist(part_no_, serial_no_tab_(i_));
         local_serial_list_ := local_serial_list_ || serial_no_tab_(i_) || Client_SYS.field_separator_ || Part_Serial_Catalog_API.Get_Objstate(part_no_, serial_no_tab_(i_)) || Client_SYS.record_separator_;
      END LOOP;
   END IF;
   RETURN local_serial_list_;

END Get_All_Serials_With_State;


FUNCTION New_Clob (
   serial_no_attr_                  IN    CLOB,
   part_no_                         IN    VARCHAR2,
   order_ref1_                      IN    VARCHAR2,
   order_ref2_                      IN    VARCHAR2,
   order_ref3_                      IN    VARCHAR2,
   order_ref4_                      IN    NUMBER,
   serial_reservation_source_db_    IN    VARCHAR2 )  RETURN CLOB
IS
   dummy_number_        NUMBER;
   serial_no_tab_       Utility_SYS.STRING_TABLE;
   newrec_              serial_no_reservation_tab%ROWTYPE;
   
BEGIN
   Utility_SYS.Tokenize(serial_no_attr_, Client_SYS.record_separator_, serial_no_tab_, dummy_number_);

   IF (serial_no_tab_.COUNT > 0) THEN
      FOR i_ IN serial_no_tab_.FIRST..serial_no_tab_.LAST LOOP
         newrec_.part_no := part_no_;
         newrec_.serial_no := serial_no_tab_(i_);
         newrec_.order_ref1 := order_ref1_;
         newrec_.order_ref2 := order_ref2_;
         newrec_.order_ref3 := order_ref3_;
         newrec_.order_ref4 := order_ref4_;
         newrec_.serial_reservation_source := serial_reservation_source_db_;
         New___(newrec_);
      END LOOP;
   END IF;
   RETURN Client_SYS.Get_All_Info;

END New_Clob;
