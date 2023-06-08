-----------------------------------------------------------------------------
--
--  Logical unit: PackingInstruction
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200703  SBalLK  Bug 154469(SCZ-10454), Modified Create_Handling_Unit_Structure() method to generate SSCC codes for the handling units where Generate SSCC enabled.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  170904  JeLise  STRSC-11879, Added Create_Data_Capture_Lov.
--  161129  NaSalk  LIM-9757, Added order by clause to get_node_id cursor in Get_Leaf_Nodes method.
--  160226  UdGnlk  LIM-6224, Added new method Get_Leaf_Nodes().   
--  150610  Chfose  LIM-3073, Added parent_handling_unit_id_ as a default NULL parameter to Create_Handling_Unit_Structure instead of having it as a hardcoded NULL value.
--  140225  HimRlk  Modified Create_Handling_Unit_Structure by adding default null parameter shipment_id.
--  130430  MeAblk  Removed attribute unattached_ship_lines_allowed.
--  130308  MeAblk  Removed method Add_Empty_Handl_Unit_Structure.
--  130222  MeAblk  Implemented new methods Add_Empty_Handl_Unit_Structure, Create_Handling_Unit_Structure to create empty handling unit structure from packing instructions.
--  130117  MeAblk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN PACKING_INSTRUCTION_TAB%ROWTYPE )
IS
BEGIN
   Packing_Instruction_Node_API.Remove_Complete_Structure(remrec_.packing_instruction_id); 
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT packing_instruction_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   Error_SYS.Check_Valid_Key_String('PACKING_INSTRUCTION_ID', newrec_.packing_instruction_id);
   
   IF (upper(newrec_.packing_instruction_id) != newrec_.packing_instruction_id) THEN
      Error_SYS.Record_General(lu_name_,'UPPERCASE: The Packing Instruction ID must be entered in uppercase.');
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Handling_Unit_Structure (
   handling_unit_id_        OUT NUMBER,
   packing_instruction_id_  IN  VARCHAR2,
   shipment_id_             IN  NUMBER DEFAULT NULL,
   parent_handling_unit_id_ IN  NUMBER DEFAULT NULL )
IS
   root_node_id_ NUMBER;
   handling_unit_rec_ Handling_Unit_API.Public_Rec;
   handling_unit_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN   
   Exist(packing_instruction_id_);
   root_node_id_ := Packing_Instruction_Node_API.Get_Root_Node_Id(packing_instruction_id_);
   
   IF (root_node_id_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ROOTNODENOTEXIST: Packing Instruction :P1 does not contain any Handling Unit Types.', packing_instruction_id_); 
   END IF;   
   Packing_Instruction_Node_API.Add_Handling_Unit_Struct_Node(handling_unit_id_,
                                                              packing_instruction_id_,
                                                              root_node_id_,
                                                              parent_handling_unit_id_ => parent_handling_unit_id_,
                                                              shipment_id_ => shipment_id_);
   IF (packing_instruction_id_ IS NOT NULL ) THEN
      handling_unit_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_);
      FOR i IN handling_unit_tab_.first..handling_unit_tab_.last LOOP
         handling_unit_rec_ := Handling_Unit_API.Get(handling_unit_tab_(i).handling_unit_id);
         IF ( handling_unit_rec_.contract IS NOT NULL AND handling_unit_rec_.generate_sscc_no = Fnd_Boolean_API.DB_TRUE AND handling_unit_rec_.sscc IS NULL) THEN
            Handling_Unit_API.Create_Sscc(handling_unit_tab_(i).handling_unit_id);
         END IF;
      END LOOP;
   END IF;
END Create_Handling_Unit_Structure;


@UncheckedAccess
FUNCTION Get_Description (
    packing_instruction_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ PACKING_INSTRUCTION_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM   PACKING_INSTRUCTION_TAB
      WHERE  packing_instruction_id = packing_instruction_id_;
BEGIN
   temp_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_,
                                                                         lu_name_,
                                                                         packing_instruction_id_), 1, 200);
   IF (temp_ IS NULL) THEN                                                                              
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Description;


@UncheckedAccess
FUNCTION Get_Leaf_Nodes (
   packing_instruction_id_ IN VARCHAR2 ) RETURN Handling_Unit_Type_API.Unit_Type_Tab
IS
   handling_unit_type_tab_ Handling_Unit_Type_API.Unit_Type_Tab;
   rows_                   PLS_INTEGER := 1;
   CURSOR get_node_id IS
      SELECT node_id
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      ORDER BY node_id;
BEGIN
   FOR rec_ IN get_node_id LOOP
      IF (Packing_Instruction_Node_API.Child_Node_Exist__(packing_instruction_id_, rec_.node_id) = 0) THEN 
         handling_unit_type_tab_(rows_).handling_unit_type_id := Packing_Instruction_Node_API.Get_Handling_Unit_Type_Id(packing_instruction_id_,
                                                                                                                        rec_.node_id);
         rows_ := rows_ + 1;
      END IF;
   END LOOP;
   
   RETURN handling_unit_type_tab_;   
END Get_Leaf_Nodes;


-- This method is used by DataCaptRegstrArrivals
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   part_no_            IN VARCHAR2,
   unit_code_          IN VARCHAR2,
   capture_session_id_ IN NUMBER )
IS
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_ NUMBER;
   exit_lov_           BOOLEAN := FALSE;
   
   CURSOR get_list_of_values IS
      SELECT packing_instruction_id, packing_instruction_desc
      FROM packing_instruction_with_root pin
      WHERE packing_instruction_id IN (SELECT pin1.packing_instruction_id
                                       FROM packing_instruction_node pin1
                                       WHERE pin1.packing_instruction_id = pin.packing_instruction_id
                                       AND   pin1.handling_unit_type_id  IN (SELECT handling_unit_type_id 
                                                                             FROM part_handling_unit_operative phuo 
                                                                             WHERE (phuo.part_no   = part_no_ OR part_no_ IS NULL)
                                                                             AND   (phuo.unit_code = unit_code_ OR unit_code_ IS NULL))
                                       AND   NOT EXISTS (SELECT 1
                                                         FROM packing_instruction_node pin2
                                                         WHERE pin2.packing_instruction_id = pin1.packing_instruction_id
                                                         AND   pin2.parent_node_id         = pin1.node_id));     
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      FOR lov_rec_ IN get_list_of_values LOOP
         Data_Capture_Session_Lov_API.New(exit_lov_             => exit_lov_,
                                          capture_session_id_   => capture_session_id_,
                                          lov_item_value_       => lov_rec_.packing_instruction_id,
                                          lov_item_description_ => lov_rec_.packing_instruction_desc,
                                          lov_row_limitation_   => lov_row_limitation_,    
                                          session_rec_          => session_rec_);
         EXIT WHEN exit_lov_;
      END LOOP;
   $ELSE
      NULL; 
   $END
END Create_Data_Capture_Lov;

