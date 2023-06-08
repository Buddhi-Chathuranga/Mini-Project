-----------------------------------------------------------------------------
--
--  Logical unit: PartGtinUnitMeas
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201222  SBalLK  Issue SC2020R1-11830, Modified Remove_All_Gtin14() method by calling framework Remove___().
--  190802  ErRalk  Bug 149226(SCZ-6170), Modified error message GTIN14EXISTS and moved it into the Check_Common___.
--  170720  SWiclk  STRSC-9621, Added Get_Gtin_No().
--  120314  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method at Set_Default_Gtin__.
--  120112  NaLrlk  SCE23 - Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_             CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

db_false_            CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Package_Indicator_Exist___
--   Checks if the given package indicator is used in GTIN 14
--   packages for specified part and gtin.
FUNCTION Package_Indicator_Exist___ (
   part_no_           IN VARCHAR2,
   gtin_no_           IN VARCHAR2,
   package_indicator_ IN NUMBER ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR pkg_indicator_exist IS
      SELECT 1
      FROM   part_gtin_unit_meas_tab
      WHERE  part_no = part_no_
      AND    gtin_no = gtin_no_
      AND    substr(gtin14, 1, 1) = package_indicator_;
BEGIN
   OPEN pkg_indicator_exist;
   FETCH pkg_indicator_exist INTO found_;
   IF (pkg_indicator_exist%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE pkg_indicator_exist;
   RETURN (found_ = 1);
END Package_Indicator_Exist___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('USED_FOR_IDENTIFICATION_DB', db_true_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_gtin_unit_meas_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   package_indicator_     NUMBER;
   identified_gtin_part_  part_gtin_unit_meas_tab.part_no%TYPE;
BEGIN
   IF (newrec_.gtin14 IS NULL) THEN
      package_indicator_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PACKAGE_INDICATOR', attr_));
      newrec_.gtin14 := Gtin_Factory_Util_API.Get_Auto_Created_Gtin14(package_indicator_, 
                                                                      newrec_.gtin_no);
      identified_gtin_part_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(newrec_.gtin14);
      IF (newrec_.used_for_identification = db_true_  AND identified_gtin_part_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'GTIN14EXISTS: This GTIN 14 is used for identifying part catalog entry :P1. You cannot use the same GTIN 14 for identification of this part.', identified_gtin_part_);   
      END IF;
   END IF;

   Client_SYS.Add_To_Attr('GTIN14', newrec_.gtin14, attr_);
   Client_SYS.Add_To_Attr('USED_FOR_IDENTIFICATION_DB', newrec_.used_for_identification, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_gtin_unit_meas_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(4000);
   package_indicator_     NUMBER;
   part_gtin_rec_         Part_Gtin_API.Public_Rec;
BEGIN
   IF NOT indrec_.used_for_identification THEN 
      newrec_.used_for_identification := db_true_;
   END IF;
   super(newrec_, indrec_, attr_);
   
   package_indicator_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PACKAGE_INDICATOR', attr_));
  
   IF ((package_indicator_ NOT BETWEEN 0 AND 9) OR (package_indicator_ != ROUND(package_indicator_))) THEN
      Error_SYS.Record_General(lu_name_, 'PKGINDCTPOSDIGIT: The package indicator should be a positive single digit integer.');
   END IF;
   IF (Package_Indicator_Exist___(newrec_.part_no, newrec_.gtin_no, package_indicator_)) THEN
      Error_SYS.Record_General(lu_name_, 'PKGINDCTEXIST: The package indicator :P1 already exists in part :P2.', package_indicator_, newrec_.part_no);
   END IF;
   part_gtin_rec_ := Part_Gtin_API.Get(newrec_.part_no, newrec_.gtin_no);

   Input_Unit_Meas_API.Exist(Part_Catalog_API.Get_Input_Unit_Meas_Group_Id(newrec_.part_no), newrec_.unit_code);

   IF (part_gtin_rec_.gtin_series IN ('GTIN_14', 'FREE_FORMAT')) OR (part_gtin_rec_.used_for_identification = db_false_) THEN
      Error_SYS.Record_General(lu_name_, 'NOTCREATGTIN14: To create GTIN 14 packages for the part, the GTIN must be used for identification and the GTIN series must be either GTIN 8, 12 or 13.');
   END IF;
   IF (newrec_.gtin14 IS NOT NULL) THEN
      IF (SUBSTR(newrec_.gtin14, 1, 1) != package_indicator_) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGGTIN14: The first digit of the GTIN 14 should be :P1.', package_indicator_);
      END IF;
      Gtin_Factory_Util_API.Validate_Gtin_Digits(newrec_.gtin14, 'GTIN_14');   
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     part_gtin_unit_meas_tab%ROWTYPE,
   newrec_ IN OUT part_gtin_unit_meas_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   identified_gtin_part_  part_gtin_unit_meas_tab.part_no%TYPE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   
   IF (Validate_SYS.Is_Changed(oldrec_.used_for_identification, newrec_.used_for_identification) AND newrec_.used_for_identification = db_true_) THEN   
      identified_gtin_part_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(newrec_.gtin14);
      IF (identified_gtin_part_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'GTIN14EXISTS: This GTIN 14 is used for identifying part catalog entry :P1. You cannot use the same GTIN 14 for identification of this part.', identified_gtin_part_);   
      END IF;
   END IF;
END Check_Common___;
   





-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Part_Via_Identified_Gtin
--   Returns used for identified part no for the specified gtin14 number.
--   Otherwise returns NULL.
@UncheckedAccess
FUNCTION Get_Part_Via_Identified_Gtin (
   gtin14_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_part_no IS
      SELECT part_no
      FROM   part_gtin_unit_meas_tab
      WHERE  gtin14 = gtin14_
      AND    used_for_identification = db_true_;
   part_no_ part_gtin_unit_meas_tab.part_no%TYPE;
BEGIN
   OPEN get_part_no;
   FETCH get_part_no INTO part_no_;
   CLOSE get_part_no;
   RETURN part_no_;
END Get_Part_Via_Identified_Gtin;


-- Remove_All_Gtin14
--   Remove all Gtin 14 for the specified part number.
PROCEDURE Remove_All_Gtin14 (
   part_no_ IN VARCHAR2 )
IS
   CURSOR get_rec IS
      SELECT *
      FROM part_gtin_unit_meas_tab
      WHERE part_no = part_no_
      FOR UPDATE;
BEGIN
   FOR rec_ IN get_rec LOOP
      Remove___(rec_);
   END LOOP;
END Remove_All_Gtin14;


-- Check_Exist_Any_Unit
--   Checks whether any unit codes exist for given part.
@UncheckedAccess
FUNCTION Check_Exist_Any_Unit (
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR exist_records IS
      SELECT 1
      FROM part_gtin_unit_meas_tab
      WHERE part_no = part_no_;
BEGIN
   OPEN exist_records;
   FETCH exist_records INTO found_;
   IF (exist_records%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_records;
   RETURN (found_ = 1);
END Check_Exist_Any_Unit;


-- Check_Exist_Unit_Code
--   Checks whether the records exist for specified part and unit code.
@UncheckedAccess
FUNCTION Check_Exist_Unit_Code (
   part_no_   IN VARCHAR2,
   unit_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR exist_records IS
      SELECT 1
      FROM   part_gtin_unit_meas_tab
      WHERE part_no = part_no_
      AND   unit_code = unit_code_;
BEGIN
   OPEN exist_records;
   FETCH exist_records INTO found_;
   IF (exist_records%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_records;
   RETURN (found_ = 1);
END Check_Exist_Unit_Code;


-- Get_Unit_Code_For_Gtin14
--   Returns unit code for the specified GTIN 14 number
--   if it is used for identification. Otherwise return NULL.
@UncheckedAccess
FUNCTION Get_Unit_Code_For_Gtin14 (
   gtin14_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   unit_code_ part_gtin_unit_meas_tab.unit_code%TYPE;
   CURSOR get_unit_code IS
      SELECT unit_code
      FROM   part_gtin_unit_meas_tab
      WHERE  gtin14 = gtin14_
      AND    used_for_identification = db_true_;
BEGIN
   OPEN get_unit_code;
   FETCH get_unit_code INTO unit_code_;
   CLOSE get_unit_code;
   RETURN unit_code_;
END Get_Unit_Code_For_Gtin14;


-- Get_Identified_Gtin14
--   Returns identified gtin14.
--   Otherwise return NULL.
@UncheckedAccess
FUNCTION Get_Identified_Gtin14 (
   part_no_   IN VARCHAR2,
   gtin_no_   IN VARCHAR2,
   unit_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   gtin14_ part_gtin_unit_meas_tab.gtin14%TYPE;
   CURSOR get_attr IS
      SELECT gtin14
      FROM   part_gtin_unit_meas_tab
      WHERE  part_no = part_no_
      AND    gtin_no = gtin_no_
      AND    unit_code = unit_code_
      AND    used_for_identification = db_true_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO gtin14_;
   CLOSE get_attr;
   RETURN gtin14_;
END Get_Identified_Gtin14;

@UncheckedAccess
FUNCTION Get_Gtin_No (
   contract_   IN VARCHAR2,
   part_no_    IN VARCHAR2,
   unit_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   gtin_no_                   VARCHAR2(14) := NULL;
   gtin14_                    VARCHAR2(14) := NULL;
   inv_input_uom_group_id_    VARCHAR2(30);
   partca_rec_                Part_Catalog_API.Public_Rec;
BEGIN
   partca_rec_ := Part_Catalog_API.Get(part_no_);
   gtin_no_    := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
   IF (unit_code_ IS NOT NULL AND partca_rec_.input_unit_meas_group_id IS NOT NULL) THEN
      $IF Component_Invent_SYS.INSTALLED $THEN
         inv_input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
      $END
      IF ((inv_input_uom_group_id_ IS NOT NULL) AND inv_input_uom_group_id_ = partca_rec_.input_unit_meas_group_id ) THEN
         gtin14_ := Part_Gtin_Unit_Meas_API.Get_Identified_Gtin14(part_no_, gtin_no_, unit_code_);
      END IF;
   END IF;
   RETURN NVL(gtin14_, gtin_no_);
END Get_Gtin_No;



