-----------------------------------------------------------------------------
--
--  Logical unit: AssortmentSalesDef
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160405  MeAblk   Bug 128430, Added method Check_Tax_Class_Id_Ref___() to have a custom exist validation for Tax Class Id.
--  130902  MaEelk   Removed package_type, pallet_type, proposed_parcel_qty and proposed_pallet_qty attributes from the LU and the call to Sales_Part_API.Create_Sales_Part.
--  130719  MeAblk   Changed the references of Pallet_Type_API, Package_Type_API into Handling_Unit_Type_API.
--  120305  MaMalk   Bug 99430, Added attribute inverted conversion factor to define the inventory conversion factor in an inverted way
--  120305           so the long decimal values caused by division can be avoided.
--  100713  ChFolk   Removed columns bonus_basis_flag, bonus_basis_flag_db, bonus_value_flag and bonus_value_flag_db as bonus functionality is obsoleted.
--  100512  Ajpelk   Merge rose method documentation
--  090930  DaZase   Added length on view comment for sales_part_rebate_group.
--  081005  AmPalk   Removed weight net and volume, since now at sales part creation freight information does not get automatically calculated.
--  080526  KiSalk   Removed ean_no.
--  080513  AmPalk   Added sales_part_rebate_group to the LU and Sales_Part_API.Create_Sales_Part method calls.
--  070214  NiDalk   Removed method Chk_Site_Cluster_Conn___.
--  070214  MiErlk   Removed weight_gross.
--  070214  MiErlk   Modified Create_Parts_Per_Site to consider defaults endered for Site cluster node to which the site belongs.
--  070205  MiErlk   Added method Remove().
--  070122  NiDalk   Added out parameter create_status_ to procedure Create_Parts_Per_Site. Also added Notes field
--  070116  KeFelk   Changed the logic of Chk_Site_Cluster_Conn___ and CURSOR get_parents.
--  070110  NiDalk   Modified Create_Parts_Per_Site to pass correct decode values.
--  061227  KeFelk   Modified Unpack_Check_Insert___ for site_cluster_id and site_cluster_node_id.
--  061218  KeFelk   Minor Modifications.
--  061215  IsWilk   Modified the PROCEDURE Create_Parts_Per_Site.
--  061214  IsWilk   Modified the Create_Parts_Per_Site.
--  061123  NiDalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Assign_Defaults___
--   Assign default valus for the new record if no vlue is set.
PROCEDURE Assign_Defaults___ (
   newrec_      IN OUT ASSORTMENT_SALES_DEF_TAB%ROWTYPE,
   default_rec_ IN     ASSORTMENT_SALES_DEF_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.conv_factor IS NULL) THEN
      newrec_.conv_factor := default_rec_.conv_factor;
   END IF;
   IF (newrec_.inverted_conv_factor IS NULL) THEN
      newrec_.inverted_conv_factor := default_rec_.inverted_conv_factor;
   END IF;
   IF (newrec_.price_conv_factor IS NULL) THEN
      newrec_.price_conv_factor := default_rec_.price_conv_factor;
   END IF;
   IF (newrec_.list_price IS NULL) THEN
      newrec_.list_price := default_rec_.list_price;
   END IF;
   IF (newrec_.expected_average_price IS NULL) THEN
      newrec_.expected_average_price := default_rec_.expected_average_price;
   END IF;
   IF (newrec_.minimum_qty IS NULL) THEN
      newrec_.minimum_qty := default_rec_.minimum_qty;
   END IF;
   IF (newrec_.close_tolerance IS NULL) THEN
      newrec_.close_tolerance := default_rec_.close_tolerance;
   END IF;
   IF (newrec_.date_of_replacement IS NULL) THEN
      newrec_.date_of_replacement := default_rec_.date_of_replacement;
   END IF;
   IF (newrec_.sourcing_option IS NULL) THEN
      newrec_.sourcing_option := default_rec_.sourcing_option;
   END IF;
   IF (newrec_.activeind IS NULL) THEN
      newrec_.activeind := default_rec_.activeind;
   END IF;
   IF (newrec_.taxable IS NULL) THEN
      newrec_.taxable := default_rec_.taxable;
   END IF;
   IF (newrec_.export_to_external_app IS NULL) THEN
      newrec_.export_to_external_app := default_rec_.export_to_external_app;
   END IF;
   IF (newrec_.create_sm_object_option IS NULL) THEN
      newrec_.create_sm_object_option := default_rec_.create_sm_object_option;
   END IF;
   IF (newrec_.rule_id IS NULL) THEN
      newrec_.rule_id := default_rec_.rule_id;
   END IF;
   IF (newrec_.sales_unit_meas IS NULL) THEN
      newrec_.sales_unit_meas := default_rec_.sales_unit_meas;
   END IF;
   IF (newrec_.price_unit_meas IS NULL) THEN
      newrec_.price_unit_meas := default_rec_.price_unit_meas;
   END IF;
   IF (newrec_.sales_price_group_id IS NULL) THEN
      newrec_.sales_price_group_id := default_rec_.sales_price_group_id;
   END IF;
   IF (newrec_.catalog_group IS NULL) THEN
      newrec_.catalog_group := default_rec_.catalog_group;
   END IF;
   IF (newrec_.discount_group IS NULL) THEN
      newrec_.discount_group := default_rec_.discount_group;
   END IF;
   IF (newrec_.fee_code IS NULL) THEN
      newrec_.fee_code := default_rec_.fee_code;
   END IF;
   IF (newrec_.replacement_part_no IS NULL) THEN
      newrec_.replacement_part_no := default_rec_.replacement_part_no;
   END IF;
   IF (newrec_.delivery_type IS NULL) THEN
      newrec_.delivery_type := default_rec_.delivery_type;
   END IF;
   IF (newrec_.sales_part_rebate_group IS NULL) THEN
      newrec_.sales_part_rebate_group := default_rec_.sales_part_rebate_group;
   END IF;
   IF (newrec_.tax_class_id IS NULL) THEN
      newrec_.tax_class_id := default_rec_.tax_class_id;
   END IF;
END Assign_Defaults___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('COMPANY'              ,'*', attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_ID'      ,'*', attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_NODE_ID' ,'*', attr_);
   Client_SYS.Add_To_Attr('CONTRACT'             ,'*', attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE'         ,'*', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     assortment_sales_def_tab%ROWTYPE,
   newrec_ IN OUT assortment_sales_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   
   IF indrec_.site_cluster_id = TRUE THEN
      IF (newrec_.site_cluster_id IS NOT NULL AND newrec_.site_cluster_id != '*' AND indrec_.site_cluster_id)
      AND (Validate_SYS.Is_Changed(oldrec_.site_cluster_id, newrec_.site_cluster_id, indrec_.site_cluster_id)) THEN
         Site_Cluster_API.Exist(newrec_.site_cluster_id);
      END IF;      
   END IF;
   
   IF indrec_.site_cluster_node_id = TRUE THEN
      IF NOT (newrec_.site_cluster_id = '*' AND newrec_.site_cluster_node_id = '*') THEN
         IF (newrec_.site_cluster_id = '*' OR newrec_.site_cluster_node_id = '*') THEN
            Error_SYS.Record_General(lu_name_,'CLUSTERNODEMISMATCH: IF you specify one of the fields Site Cluster ID or Site Cluster Node ID, you must specify the other.');         
         END IF;
      END IF;
      
      IF (newrec_.site_cluster_id IS NOT NULL AND newrec_.site_cluster_id != '*' AND newrec_.site_cluster_node_id IS NOT NULL  
         AND newrec_.site_cluster_node_id != '*' AND indrec_.site_cluster_node_id)
         AND (Validate_SYS.Is_Changed(oldrec_.site_cluster_id, newrec_.site_cluster_id, indrec_.site_cluster_id)
           OR Validate_SYS.Is_Changed(oldrec_.site_cluster_node_id, newrec_.site_cluster_node_id, indrec_.site_cluster_node_id)) THEN
         Site_Cluster_Node_API.Exist(newrec_.site_cluster_id, newrec_.site_cluster_node_id);
      END IF;      
   END IF;
   
   IF indrec_.contract = TRUE THEN
      IF (newrec_.contract IS NOT NULL AND newrec_.contract != '*' AND indrec_.contract)
      AND (Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract, indrec_.contract)) THEN
         Site_API.Exist(newrec_.contract);
      END IF;
      IF (newrec_.contract != '*') THEN
         IF (newrec_.site_cluster_node_id != '*') OR (newrec_.country_code != '*') OR (newrec_.company != '*') THEN
            Error_SYS.Record_General(lu_name_,'PURCHDEFERR: Company, Country, and Site Cluster Node must be * when you specify a value for Site.');
         END IF;
      END IF;      
   END IF;
                                                                   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.conv_factor IS NULL AND newrec_.inverted_conv_factor IS NOT NULL) THEN
     newrec_.conv_factor := 1;
   END IF;

   IF (newrec_.conv_factor IS NOT NULL AND newrec_.inverted_conv_factor IS NULL) THEN
     newrec_.inverted_conv_factor := 1;
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT assortment_sales_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
      
   newrec_.priority := Create_Parts_Per_Site_Util_API.Get_Priority(newrec_.site_cluster_node_id,
                                                                   newrec_.contract,
                                                                   newrec_.country_code,
                                                                   newrec_.company,
                                                                   NULL);
                                                                   
   super(newrec_, indrec_, attr_);
   -- Both the conversion factor and the inverted conversion factor cannot have a value which is not equal to one at the same time.
   IF (newrec_.conv_factor != 1 AND newrec_.inverted_conv_factor != 1) THEN
     newrec_.inverted_conv_factor := 1;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     assortment_sales_def_tab%ROWTYPE,
   newrec_ IN OUT assortment_sales_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Both the conversion factor and the inverted conversion factor cannot have a value which is not equal to one at the same time.
   IF (newrec_.conv_factor != 1 AND newrec_.inverted_conv_factor != 1) THEN
     IF (oldrec_.conv_factor != newrec_.conv_factor) THEN
        newrec_.inverted_conv_factor := 1;
     ELSIF (oldrec_.inverted_conv_factor != newrec_.inverted_conv_factor) THEN
        newrec_.conv_factor := 1;
     END IF;
   END IF; 
END Check_Update___;


PROCEDURE Check_Tax_Class_Id_Ref___ (
   newrec_ IN OUT NOCOPY assortment_sales_def_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.company != '*') THEN
      Tax_Class_API.Exist(newrec_.company, newrec_.tax_class_id);
   ELSIF(newrec_.contract != '*') THEN   
      Tax_Class_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.tax_class_id);
   END IF;   
END  Check_Tax_Class_Id_Ref___;
   

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Parts_Per_Site
--   Creates sales part according to the defaults enterd. Defaults are assigned
--   considering following criteria.
--   1. Priority
--   2. Assortment node level. (close Parents have high priority)
--   3. Site Cluster Node defaults for which the site belongs
PROCEDURE Create_Parts_Per_Site (
   create_status_      OUT VARCHAR2,
   assortment_id_      IN  VARCHAR2,
   assortment_node_id_ IN  VARCHAR2,
   contract_           IN  VARCHAR2,
   company_            IN  VARCHAR2,
   country_code_       IN  VARCHAR2,
   part_no_            IN  VARCHAR2 )
IS
   defaults_rec_           ASSORTMENT_SALES_DEF_TAB%ROWTYPE;
   newrec_                 ASSORTMENT_SALES_DEF_TAB%ROWTYPE;
   site_belong_to_node_    VARCHAR2(10);
   parent_node_            ASSORTMENT_NODE_TAB.parent_node%TYPE;

   CURSOR get_sales_assortment_defaults(selected_node_id_ IN VARCHAR2) IS
   SELECT *
   FROM   ASSORTMENT_SALES_DEF_TAB
   WHERE  assortment_id = assortment_id_
   AND    assortment_node_id = selected_node_id_
   AND    contract IN (contract_,'*')
   AND    country_code IN (country_code_,'*')
   AND    company IN (company_,'*')
   ORDER BY priority ASC, (Site_Cluster_Node_API.Get_Level_No(site_cluster_id, site_cluster_node_id)) DESC;
BEGIN

   create_status_ := 'FALSE';

   IF (Sales_Part_API.Check_Exist(contract_, part_no_) = 0) THEN
      parent_node_ := assortment_node_id_;

      -- To get the defaults from the parents.
       WHILE parent_node_ IS NOT NULL LOOP
         OPEN get_sales_assortment_defaults(parent_node_);
         FETCH get_sales_assortment_defaults INTO defaults_rec_;
         WHILE get_sales_assortment_defaults%FOUND LOOP
            site_belong_to_node_ := Site_Cluster_Node_API.Is_Site_Belongs_To_Node(defaults_rec_.site_cluster_id, defaults_rec_.site_cluster_node_id, contract_);
            IF (defaults_rec_.site_cluster_node_id = '*' OR
                 (defaults_rec_.site_cluster_node_id !='*' AND site_belong_to_node_ = 'TRUE')) THEN
               Assign_Defaults___(newrec_, defaults_rec_);
            END IF;
            FETCH  get_sales_assortment_defaults INTO defaults_rec_;
         END LOOP;
         CLOSE get_sales_assortment_defaults;
         parent_node_ := Assortment_Node_API.Get_Parent_Node(assortment_id_, parent_node_);
      END LOOP;

      Sales_Part_API.Create_Sales_Part(contract_,
                                       part_no_,
                                       newrec_.conv_factor,
                                       newrec_.inverted_conv_factor,
                                       newrec_.price_conv_factor,
                                       newrec_.list_price,
                                       newrec_.expected_average_price,
                                       newrec_.minimum_qty,
                                       newrec_.close_tolerance,
                                       newrec_.date_of_replacement,
                                       Sourcing_Option_API.Decode(newrec_.sourcing_option),
                                       Active_Sales_Part_API.Decode(newrec_.activeind),
                                       Fnd_Boolean_API.Decode(newrec_.taxable),
                                       Fnd_Boolean_API.Decode(newrec_.export_to_external_app),
                                       Create_Sm_Object_Option_API.Decode(newrec_.create_sm_object_option),
                                       newrec_.rule_id,
                                       newrec_.sales_unit_meas,
                                       newrec_.price_unit_meas,
                                       newrec_.sales_price_group_id,
                                       newrec_.catalog_group,
                                       newrec_.discount_group,
                                       newrec_.fee_code,
                                       newrec_.replacement_part_no,
                                       newrec_.delivery_type,
                                       newrec_.sales_part_rebate_group,
                                       newrec_.tax_class_id);
      create_status_ := 'TRUE';
   END IF;
END Create_Parts_Per_Site;


-- Remove
--   Used to remove the Defaults when  Assortment nodes is deleted.
PROCEDURE Remove (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS
   remrec_      ASSORTMENT_SALES_DEF_TAB%ROWTYPE;
   objid_       ASSORTMENT_SALES_DEF.objid%TYPE;
   objversion_  ASSORTMENT_SALES_DEF.objversion%TYPE;

   CURSOR get_data IS
      SELECT company,country_code, site_cluster_id, site_cluster_node_id, contract
      FROM   ASSORTMENT_SALES_DEF_TAB
      WHERE  assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_;

BEGIN

   FOR rec_ IN  get_data LOOP
    remrec_ := Get_Object_By_Keys___(assortment_id_,
                                     assortment_node_id_,
                                     rec_.company,
                                     rec_.country_code,
                                     rec_.site_cluster_id,
                                     rec_.site_cluster_node_id,
                                     rec_.contract);

    Get_Id_Version_By_Keys___(objid_,
                              objversion_,
                              assortment_id_,
                              assortment_node_id_,
                              rec_.company,
                              rec_.country_code,
                              rec_.site_cluster_id,
                              rec_.site_cluster_node_id,
                              rec_.contract);
    Check_Delete___(remrec_);
    Delete___(objid_, remrec_);
   END LOOP;
END Remove;



