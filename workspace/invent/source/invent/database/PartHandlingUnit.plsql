-----------------------------------------------------------------------------
--
--  Logical unit: PartHandlingUnit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180921  ChFolk   SCUXXW$-5636, Added method Part_Handling_Unit_Type_Exist to be used by Aurena client. 
--  170404  Jhalse   LIM-11076, Added method Check_Operative to check for inherited capacity groups.
--  161209  NaSalk   LIM-9757, Modified error messages in Check_Handling_Unit_Type and Check_Combination to provide more information.
--  160721  Rakalk   LIM-7993, Removed method Get_Capacity
--  160721  Rakalk   LIM-7993, Added method Get_Capacity
--  160226  UdGnlk   LIM-6224, Replaced Packing_Instruction_Node_API.Get_Handling_Unit_Type_Id() with Packing_Instruction_API.Get_Leaf_Nodes().
--  160218  jhalse   LIM-6330, Removed procedure Raise_Handl_Unit_Type_Error___ and created new error msg in Check_Combination.
--  160129  JeLise   LIM-5884, Added new method Copy.
--  130904  JeLise   Added new methods Check_Handling_Unit_Type and Raise_Handl_Unit_Type_Error___.
--  130826  JeLise   Added new method Check_Combination.
--  130716  MaEelk   Added Get_Handl_Unit_Type_Id that would return the first handling unit found for the combination of part no, unit code and packing instruction id.
--  130422  JeLise   Added method Get_Handl_Unit_Type_Id to get all the possible handling unit types.
--  130129  JeLise   Changed sort in view PART_HANDLING_UNIT_OPERATIVE so that 'Part Catalog' will show above 'Capacity Group'.
--  120912  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_handling_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   Capacity_Grp_Handling_Unit_API.Check_Quantity(newrec_.max_quantity_capacity, newrec_.unit_code);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     part_handling_unit_tab%ROWTYPE,
   newrec_ IN OUT part_handling_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_   VARCHAR2(30);
   value_  VARCHAR2(2000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.max_quantity_capacity != oldrec_.max_quantity_capacity) THEN
      Capacity_Grp_Handling_Unit_API.Check_Quantity(newrec_.max_quantity_capacity, newrec_.unit_code);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Max_Quantity_Capacity (
   part_no_               IN VARCHAR2,
   handling_unit_type_id_ IN VARCHAR2,
   unit_code_             IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ PART_HANDLING_UNIT_TAB.max_quantity_capacity%TYPE;
   CURSOR get_attr IS
      SELECT max_quantity_capacity
      FROM PART_HANDLING_UNIT_OPERATIVE
      WHERE part_no               = part_no_
      AND   handling_unit_type_id = handling_unit_type_id_
      AND   unit_code             = unit_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Max_Quantity_Capacity;


@UncheckedAccess
FUNCTION Get_Handling_Unit_Type_Id (
   part_no_   IN VARCHAR2,
   unit_code_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   temp_ PART_HANDLING_UNIT_TAB.handling_unit_type_id%TYPE;
   CURSOR get_attr IS
      SELECT handling_unit_type_id
      FROM PART_HANDLING_UNIT_OPERATIVE
      WHERE part_no   = part_no_
      AND   unit_code = unit_code_
      ORDER BY sort;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Handling_Unit_Type_Id;


-- Get_Handl_Unit_Type_Id
--   This would return the first handling unit found for a given catalog no that satisfies the given values of unit code and packing instruction id
@UncheckedAccess
FUNCTION Get_Handl_Unit_Type_Id (
   part_no_   IN VARCHAR2,
   unit_code_ IN VARCHAR2 ) RETURN Handling_Unit_Type_API.Unit_Type_Tab
IS
   handling_unit_type_tab_ Handling_Unit_Type_API.Unit_Type_Tab;
   CURSOR get_handling_unit_type IS
      SELECT handling_unit_type_id
      FROM PART_HANDLING_UNIT_OPERATIVE
      WHERE part_no   = part_no_
      AND   unit_code = unit_code_
      ORDER BY sort;
BEGIN
   OPEN get_handling_unit_type;
   FETCH get_handling_unit_type BULK COLLECT INTO handling_unit_type_tab_;
   CLOSE get_handling_unit_type;
   RETURN handling_unit_type_tab_;
END Get_Handl_Unit_Type_Id;


-- Get_Handl_Unit_Type_Id
--   This would return the first handling unit found for a given catalog no that satisfies the given values of unit code and packing instruction id
@UncheckedAccess
FUNCTION Get_Handl_Unit_Type_Id (
   part_no_                IN VARCHAR2,
   unit_code_              IN VARCHAR2,
   packing_instruction_id_ IN VARCHAR2 )  RETURN VARCHAR2 
IS
   handling_unit_type_id_         PART_HANDLING_UNIT_TAB.handling_unit_type_id%TYPE;
   part_handling_unit_type_tab_   Handling_Unit_Type_API.Unit_Type_Tab;
   packinstr_handl_unit_type_tab_ Handling_Unit_Type_API.Unit_Type_Tab;
BEGIN
   part_handling_unit_type_tab_ := Get_Handl_Unit_Type_Id(part_no_, 
                                                          unit_code_);
   IF (packing_instruction_id_ IS NULL) THEN 
      IF (part_handling_unit_type_tab_.COUNT > 0) THEN 
         handling_unit_type_id_ := part_handling_unit_type_tab_(1).handling_unit_type_id;
      END IF;
   ELSE
      packinstr_handl_unit_type_tab_ := Packing_Instruction_API.Get_Leaf_Nodes(packing_instruction_id_);
         
      IF (packinstr_handl_unit_type_tab_.COUNT > 0) THEN
         FOR i IN packinstr_handl_unit_type_tab_.FIRST..packinstr_handl_unit_type_tab_.LAST LOOP
            IF (part_handling_unit_type_tab_.COUNT > 0) THEN 
               FOR j IN part_handling_unit_type_tab_.FIRST..part_handling_unit_type_tab_.LAST LOOP
                  IF (packinstr_handl_unit_type_tab_(i).handling_unit_type_id = part_handling_unit_type_tab_(j).handling_unit_type_id) THEN 
                     handling_unit_type_id_ := packinstr_handl_unit_type_tab_(i).handling_unit_type_id;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
            EXIT WHEN handling_unit_type_id_ IS NOT NULL;
         END LOOP;
      END IF;
   END IF;
   
   RETURN handling_unit_type_id_;
END Get_Handl_Unit_Type_Id;


PROCEDURE Check_Combination (
   part_no_                IN VARCHAR2,
   unit_code_              IN VARCHAR2,
   packing_instruction_id_ IN VARCHAR2 )
IS
   handling_unit_type_id_ VARCHAR2(25);
BEGIN
   handling_unit_type_id_ := Get_Handl_Unit_Type_Id(part_no_, 
                                                    unit_code_,
                                                    packing_instruction_id_);
   IF (handling_unit_type_id_ IS NULL) THEN 
      Error_SYS.Record_General(lu_name_, 'NOHUCAPACITYFORPI: No handling unit capacity is defined for the combination of part number :P1, unit of measure :P2 and handling unit type in the selected packing instruction :P3.',
                               part_no_, unit_code_, packing_instruction_id_);
   END IF;
END Check_Combination;


PROCEDURE Check_Handling_Unit_Type (
   part_no_               IN VARCHAR2,
   unit_code_             IN VARCHAR2,
   handling_unit_type_id_ IN VARCHAR2 )
IS
   part_handling_unit_type_tab_ Handling_Unit_Type_API.Unit_Type_Tab;
   handling_unit_type_id_found_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   part_handling_unit_type_tab_ := Get_Handl_Unit_Type_Id(part_no_,
                                                          unit_code_);
   IF (part_handling_unit_type_tab_.COUNT > 0) THEN 
      FOR i IN part_handling_unit_type_tab_.FIRST..part_handling_unit_type_tab_.LAST LOOP
         IF (part_handling_unit_type_tab_(i).handling_unit_type_id = handling_unit_type_id_) THEN 
            handling_unit_type_id_found_ := Fnd_Boolean_API.DB_TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   
   IF (handling_unit_type_id_found_ = Fnd_Boolean_API.DB_FALSE) THEN 
      Error_SYS.Record_General(lu_name_, 'NOHUCAPACITY: No handling unit capacity is defined for the combination of part number :P1, unit of measure :P2 and handling unit type :P3.',
                               part_no_, unit_code_, handling_unit_type_id_);
   END IF;
END Check_Handling_Unit_Type;


PROCEDURE Copy (
   from_part_no_             IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_       PART_HANDLING_UNIT_TAB%ROWTYPE;
   TYPE Capacity_Tab_Type IS TABLE OF PART_HANDLING_UNIT_TAB%ROWTYPE 
      INDEX BY BINARY_INTEGER;
   capacity_tab_ Capacity_Tab_Type;

   CURSOR get_capacity_lines IS
      SELECT *
      FROM PART_HANDLING_UNIT_TAB
      WHERE part_no = from_part_no_;
BEGIN
   OPEN get_capacity_lines;
   FETCH get_capacity_lines BULK COLLECT INTO capacity_tab_;
   CLOSE get_capacity_lines;
   
   IF (capacity_tab_.COUNT > 0) THEN 
      FOR i IN capacity_tab_.FIRST..capacity_tab_.LAST LOOP
         IF (Check_Exist___(to_part_no_, capacity_tab_(i).handling_unit_type_id, capacity_tab_(i).unit_code)) THEN
            IF (error_when_existing_copy_ = 'TRUE') THEN
               Error_SYS.Record_Not_Exist(lu_name_, 'HUCAPEXIST: Handling Unit Capacity exist for part :P1 handling unit type :P2 and unit of measure :P3', 
                                                    to_part_no_, capacity_tab_(i).handling_unit_type_id, capacity_tab_(i).unit_code);
            END IF;
         ELSE
            newrec_         := capacity_tab_(i);
            newrec_.part_no := to_part_no_;

            New___(newrec_);
         END IF;
      END LOOP;
   ELSIF (error_when_no_source_ = 'TRUE') THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'HUCAPNOTEXIST: Handling Unit Capacity does not exist for part :P1', from_part_no_);
   END IF;
END Copy;

@UncheckedAccess
FUNCTION Check_Operative(
   part_no_                IN VARCHAR2,
   handling_unit_type_id_  IN VARCHAR2,
   unit_code_              IN VARCHAR2 ) RETURN BOOLEAN
   IS
      dummy_ NUMBER := 0;
      
      CURSOR get_operative IS
         SELECT 1
           FROM PART_HANDLING_UNIT_OPERATIVE
          WHERE part_no                 = part_no_
            AND handling_unit_type_id   = handling_unit_type_id_
            AND unit_code               = unit_code_;
   BEGIN
      OPEN  get_operative;
      FETCH get_operative INTO dummy_;
      CLOSE get_operative;
      
      RETURN CASE WHEN dummy_ = 1 THEN TRUE ELSE FALSE END;
END Check_Operative;

FUNCTION Part_Handling_Unit_Type_Exist (
   part_no_               IN VARCHAR2,
   unit_code_             IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_handling_unit_type_tab_ Handling_Unit_Type_API.Unit_Type_Tab;
   handling_unit_type_id_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   part_handling_unit_type_tab_ := Get_Handl_Unit_Type_Id(part_no_, unit_code_);
   IF (part_handling_unit_type_tab_.COUNT > 0) THEN 
      handling_unit_type_id_exist_ := Fnd_Boolean_API.DB_TRUE;     
   END IF;
   
   RETURN handling_unit_type_id_exist_;
END Part_Handling_Unit_Type_Exist;


