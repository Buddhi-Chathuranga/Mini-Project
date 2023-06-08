-----------------------------------------------------------------------------
--
--  Logical unit: AssortmentInvCharDef
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131104  UdGnlk   PBSC-193, Modified Unpack_Check_Update___() to align with model file errors.
--  090714  SuThlk   Bug 83313, Did modification in Unpack_Check_Insert___ and Unpack_Check_Update___ to store the values 
--  090714           in between -1 and 1 in 0.xx format.
--  081216  NWeelk   Bug 78364, Changed char_type_ to newrec_.char_type in Unpack_Check_Insert___ and in Unpack_Check_Update___. 
--  070215  NiDalk   Removed method Chk_Site_Cluster_Conn___.
--  070213  MiErlk   Modified Create_Parts_Per_Site to consider defaults endered for Site cluster node to which the site belongs.
--  070122  NiDalk   Added Notes field.
--  070116  KeFelk   Changed the logic of Chk_Site_Cluster_Conn___ and CURSOR get_parents.
--  061228  MiErlk   Modified Create_Inv_Par_Char_Per_Site.
--  061227  KeFelk   Modified Unpack_Check_Insert___ and Unpack_Check_Update___ for site_cluster_id and site_cluster_node_id.
--  061205  MiErlk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Assign_Defaults___ (
   newrec_      IN OUT ASSORTMENT_INV_CHAR_DEF_TAB%ROWTYPE,
   default_rec_ IN     ASSORTMENT_INV_CHAR_DEF_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.characteristic_code IS NULL) THEN
      newrec_.characteristic_code := default_rec_.characteristic_code;
   END IF;
   IF (newrec_.eng_attribute IS NULL) THEN
      newrec_.eng_attribute:= default_rec_.eng_attribute;
   END IF;
   IF (newrec_.attr_value IS NULL) THEN
      newrec_.attr_value:= default_rec_.attr_value;
   END IF;
END Assign_Defaults___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('COMPANY',              '*', attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_ID',      '*', attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_NODE_ID', '*', attr_);
   Client_SYS.Add_To_Attr('CONTRACT',             '*', attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE',         '*', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT assortment_inv_char_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_      VARCHAR2(30);
   value_     VARCHAR2(4000);
   ndummy_    NUMBER;
   
BEGIN
   IF (newrec_.characteristic_code IS NOT NULL) THEN
      Characteristic_Templ_Char_Api.Exist(newrec_.eng_attribute, newrec_.characteristic_code);
   END IF;

   IF NOT (newrec_.site_cluster_id = '*' AND newrec_.site_cluster_node_id = '*') THEN
      IF (newrec_.site_cluster_id = '*' OR newrec_.site_cluster_node_id = '*') THEN
         Error_SYS.Record_General(lu_name_,'CLUSTERNODEMISMATCH: IF you specify one of the fields Site Cluster ID or Site Cluster Node ID, you must specify the other.');
      ELSE
         Site_Cluster_Node_API.Exist(newrec_.site_cluster_id, newrec_.site_cluster_node_id);
      END IF;
   END IF;

   IF (newrec_.contract != '*') THEN
      IF (newrec_.site_cluster_node_id != '*' OR newrec_.site_cluster_node_id != '*' OR newrec_.country_code != '*' OR newrec_.company != '*') THEN
         Error_SYS.Record_General(lu_name_, 'INVCHARDEFERR: Company, Country, and Site Cluster Node must be * when you specify a value for Site.');
      END IF;
   END IF;

   newrec_.priority := Create_Parts_Per_Site_Util_API.Get_Priority(newrec_.site_cluster_node_id,
                                                                   newrec_.contract,
                                                                   newrec_.country_code,
                                                                   newrec_.company,
                                                                   NULL);

   IF (newrec_.char_type IS NULL) THEN
      newrec_.char_type := Characteristic_API.Get_Row_Type(newrec_.characteristic_code);
   END IF;            
   
   IF(newrec_.char_type = 'DiscreteCharacteristic') THEN
      IF (newrec_.attr_value IS NOT NULL) THEN
         Discrete_Charac_Value_API.Exist(newrec_.characteristic_code, newrec_.attr_value);
      END IF;
   ELSIF (newrec_.char_type = 'IndiscreteCharacteristic') THEN
      /* To generate EXCEPTION FOR invalid numbers */
      IF Characteristic_API.Get_Search_Type(newrec_.characteristic_code) = Alpha_Numeric_API.Decode('N') THEN
         value_  := newrec_.attr_value;
         -- Assignment will raise an exception for invalid attr_value.
         ndummy_ := newrec_.attr_value;
         newrec_.attr_value := Characteristic_API.Get_Formatted_Char_Value(newrec_.characteristic_code,newrec_.attr_value);
      END IF;
   END IF;   
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     assortment_inv_char_def_tab%ROWTYPE,
   newrec_ IN OUT assortment_inv_char_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_        VARCHAR2(30);
   value_       VARCHAR2(4000);
   ndummy_      NUMBER;
   
BEGIN
   newrec_.char_type := Characteristic_API.Get_Row_Type(newrec_.characteristic_code);
   IF (newrec_.characteristic_code IS NOT NULL) THEN
      Characteristic_Templ_Char_Api.Exist(newrec_.eng_attribute, newrec_.characteristic_code);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
  /* IF (newrec_.char_type IS NULL) THEN
      newrec_.char_type := Characteristic_API.Get_Row_Type(newrec_.characteristic_code);
   END IF; */
   
   IF(newrec_.char_type = 'IndiscreteCharacteristic') THEN
      /* To generate EXCEPTION FOR invalid numbers */
      IF Characteristic_API.Get_Search_Type(newrec_.characteristic_code) = Alpha_Numeric_API.Decode('N') THEN
         name_   := 'ATTR_VALUE';
         value_  := newrec_.attr_value;
         -- Assignment will raise an exception for invalid attr_value.
         ndummy_ := newrec_.attr_value;
         newrec_.attr_value := Characteristic_API.Get_Formatted_Char_Value(newrec_.characteristic_code,newrec_.attr_value);
      END IF;
   ELSIF(newrec_.char_type = 'DiscreteCharacteristic' ) THEN
      IF (newrec_.attr_value IS NOT NULL) THEN
         Discrete_Charac_Value_API.Exist(newrec_.characteristic_code, newrec_.attr_value);
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Check_Defaults_Exist__ (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   eng_attribute_      IN VARCHAR2 ) RETURN NUMBER
IS
   sum_   NUMBER;
   CURSOR get_child_node IS
      SELECT  assortment_id, assortment_node_id
      FROM    ASSORTMENT_NODE_TAB
      WHERE   assortment_id = assortment_id_
      AND     charac_tmp_defined_node =  assortment_node_id_ ;
   CURSOR find_defaults(c_assortment_id_ IN VARCHAR2 , c_assortment_node_id_ IN VARCHAR2) IS
      SELECT count(*)
      FROM   assortment_inv_char_def_tab t
      WHERE  assortment_id      = c_assortment_id_
      AND    assortment_node_id = c_assortment_node_id_
      AND    eng_attribute      = eng_attribute_ ;
BEGIN
   FOR child_node_rec_ IN get_child_node LOOP
      OPEN  find_defaults(child_node_rec_.assortment_id , child_node_rec_.assortment_node_id);
      FETCH find_defaults INTO sum_;
      CLOSE find_defaults;
      IF (sum_ > 0 ) THEN
         RETURN 1;
      END IF;
   END LOOP;
   RETURN 0;
END Check_Defaults_Exist__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Inv_Par_Char_Per_Site (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   contract_           IN VARCHAR2,
   company_            IN VARCHAR2,
   country_code_       IN VARCHAR2,
   part_no_            IN VARCHAR2 )
IS
   defaults_rec_        ASSORTMENT_INV_CHAR_DEF_TAB%ROWTYPE;
   newrec_              ASSORTMENT_INV_CHAR_DEF_TAB%ROWTYPE;
   char_type_           ASSORTMENT_INV_CHAR_DEF_TAB.char_type%TYPE;
   attr_value_          ASSORTMENT_INV_CHAR_DEF_TAB.attr_value%TYPE;
   dummy_               NUMBER;
   site_belong_to_node_ VARCHAR2(10);
   parent_node_            ASSORTMENT_NODE_TAB.parent_node%TYPE;

   CURSOR get_inv_part_char_defaults(selected_node_id_ IN VARCHAR2) IS
      SELECT *
      FROM   ASSORTMENT_INV_CHAR_DEF_TAB
      WHERE  assortment_id      = assortment_id_
      AND    assortment_node_id = selected_node_id_
      AND    contract IN (contract_, '*')
      AND    country_code IN (country_code_, '*')
      AND    company IN (company_, '*')
      ORDER BY priority ASC, (Site_Cluster_Node_API.Get_Level_No(site_cluster_id, site_cluster_node_id)) DESC;

   CURSOR check_existance(characteristic_code_ IN VARCHAR2) IS
     SELECT 1
     FROM  inventory_part_char_tab
     WHERE part_no  = part_no_
     AND   contract = contract_
     AND   characteristic_code = characteristic_code_;

BEGIN

   parent_node_ := assortment_node_id_;
   -- we need to get the parents from the
   WHILE parent_node_ IS NOT NULL LOOP
        OPEN get_inv_part_char_defaults(parent_node_);
        FETCH get_inv_part_char_defaults INTO defaults_rec_;
        WHILE get_inv_part_char_defaults%FOUND LOOP
           OPEN check_existance(defaults_rec_.characteristic_code);
           FETCH check_existance INTO dummy_;
           IF (check_existance%NOTFOUND) THEN
              newrec_ := NULL;
              site_belong_to_node_ := Site_Cluster_Node_API.Is_Site_Belongs_To_Node(defaults_rec_.site_cluster_id, defaults_rec_.site_cluster_node_id, contract_);
              IF (defaults_rec_.site_cluster_node_id = '*' OR
                 (defaults_rec_.site_cluster_node_id !='*' AND site_belong_to_node_ = 'TRUE')) THEN
                 Assign_Defaults___(newrec_, defaults_rec_);
              END IF;

              char_type_  := Characteristic_API.Get_Row_Type(newrec_.characteristic_code );
              attr_value_ := newrec_.attr_value ;
              IF( char_type_ = 'IndiscreteCharacteristic') THEN
                 Inv_Part_Indiscrete_Char_API.Create_Part_Type_Char(contract_
                                                                    , part_no_
                                                                    , newrec_.characteristic_code
                                                                    , Characteristic_Templ_Char_API.Get_Unit_Meas(
                                                                                             newrec_.eng_attribute,
                                                                                             newrec_.characteristic_code)
                                                                    , attr_value_ );
              ELSIF (char_type_ = 'DiscreteCharacteristic') THEN
                 Inv_Part_Discrete_Char_API.Create_Part_Type_Char(contract_
                                                                  , part_no_
                                                                  , newrec_.characteristic_code
                                                                  , Characteristic_Templ_Char_API.Get_Unit_Meas(
                                                                                             newrec_.eng_attribute,
                                                                                             newrec_.characteristic_code)
                                                                  , attr_value_);
              END IF;
           END IF;
           CLOSE check_existance;
           FETCH  get_inv_part_char_defaults INTO defaults_rec_;
        END LOOP;
        CLOSE get_inv_part_char_defaults;
        parent_node_ := Assortment_Node_API.Get_Parent_Node(assortment_id_, parent_node_);
     END LOOP;
END Create_Inv_Par_Char_Per_Site;


PROCEDURE Remove (
   assortment_id_       IN VARCHAR2,
   assortment_node_id_  IN VARCHAR2 )
IS
   remrec_      ASSORTMENT_INV_CHAR_DEF_TAB%ROWTYPE;
   objid_       ASSORTMENT_INV_CHAR_DEF.objid%TYPE;
   objversion_  ASSORTMENT_INV_CHAR_DEF.objversion%TYPE;

   CURSOR get_data IS
      SELECT contract, site_cluster_id, site_cluster_node_id, company, country_code, characteristic_code
      FROM   ASSORTMENT_INV_CHAR_DEF_TAB
      WHERE assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_;
BEGIN

   FOR rec_ IN  get_data LOOP
      remrec_ := Get_Object_By_Keys___(assortment_id_,
                                       assortment_node_id_,
                                       rec_.contract,
                                       rec_.site_cluster_id,
                                       rec_.site_cluster_node_id,
                                       rec_.company,
                                       rec_.country_code,
                                       rec_.characteristic_code);

      Get_Id_Version_By_Keys___(objid_,
                                objversion_,
                                assortment_id_,
                                assortment_node_id_,
                                rec_.contract,
                                rec_.site_cluster_id,
                                rec_.site_cluster_node_id,
                                rec_.company,
                                rec_.country_code,
                                rec_.characteristic_code);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Remove;



