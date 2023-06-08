-----------------------------------------------------------------------------
--  NOTE! DO NOT EDIT!! THIS FILE BELONGS TO DEVELOPER STUDIO TEAM
--        ANY CHANGE WILL BE OVERWRITTEN IN NEXT BUILD.
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
--
--  Logical unit: OdataProviderMetadata
--  Component:    FNDBAS
--
--  Template:     3.0
--  Built by:     IFS Developer Studio 10.82.0-SNAPSHOT
--
--  NOTE! Do not edit!! This file is completely generated and will be
--        overwritten next time the corresponding JSON schema is saved.
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Main_Rec IS RECORD (
   projection_                   JSON_OBJECT_T
);

TYPE Projection_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   apidoc_                       VARCHAR2(4000),
   metadata_                     JSON_OBJECT_T,
   container_                    JSON_OBJECT_T,
   enumerations_                 JSON_ARRAY_T,
   structures_                   JSON_ARRAY_T,
   entities_                     JSON_ARRAY_T
);

TYPE Metadata_Rec IS RECORD (
   version_                      VARCHAR2(4000),
   description_                  VARCHAR2(4000),
   category_                     JSON_ARRAY_T
);

TYPE Container_Rec IS RECORD (
   entity_sets_                  JSON_ARRAY_T,
   singletons_                   JSON_ARRAY_T,
   actions_                      JSON_ARRAY_T,
   functions_                    JSON_ARRAY_T
);

TYPE Structure_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   p_l_s_q_l_record_name_        VARCHAR2(4000),
   attributes_                   JSON_ARRAY_T,
   apidoc_                       VARCHAR2(4000)
);

TYPE AttributeDec_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   data_type_                    VARCHAR2(4000)
);

TYPE EntitySet_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   entity_type_                  VARCHAR2(4000),
   where_                        VARCHAR2(4000),
   default_where_                VARCHAR2(4000),
   apidoc_                       VARCHAR2(4000)
);

TYPE Singleton_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   entity_type_                  VARCHAR2(4000),
   where_                        VARCHAR2(4000),
   default_where_                VARCHAR2(4000)
);

TYPE Enumeration_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   values_                       JSON_ARRAY_T
);

TYPE Value_Rec IS RECORD (
   identifier_                   VARCHAR2(4000),
   db_value_                     VARCHAR2(4000)
);

TYPE Entity_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   support_warnings_             BOOLEAN,
   key_fetch_on_create_          BOOLEAN,
   execute_                      JSON_OBJECT_T,
   group_by_                     JSON_ARRAY_T,
   keys_                         JSON_ARRAY_T,
   keys_where_                   VARCHAR2(4000),
   connected_entities_           JSON_ARRAY_T,
   attributes_                   JSON_ARRAY_T,
   computed_                     JSON_ARRAY_T,
   annotations_                  JSON_ARRAY_T,
   navigation_                   JSON_ARRAY_T,
   c_r_u_d_                      JSON_ARRAY_T,
   actions_                      JSON_ARRAY_T,
   functions_                    JSON_ARRAY_T,
   transaction_group_            VARCHAR2(4000),
   apidoc_                       VARCHAR2(4000)
);

TYPE EntityExecute_Rec IS RECORD (
   s_q_l_                        JSON_OBJECT_T
);

TYPE EntityExecuteSQL_Rec IS RECORD (
   from_                         VARCHAR2(4000),
   where_                        VARCHAR2(4000)
);

TYPE Navigation_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   collection_                   BOOLEAN,
   target_                       VARCHAR2(4000),
   keys_                         JSON_ARRAY_T,
   parent_attributes_            JSON_ARRAY_T,
   child_attributes_             JSON_ARRAY_T,
   where_                        VARCHAR2(4000),
   apidoc_                       VARCHAR2(4000)
);

TYPE KeyMapping_Rec IS RECORD (
   this_attribute_               VARCHAR2(4000),
   target_attribute_             VARCHAR2(4000)
);

TYPE Attribute_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   implementation_               VARCHAR2(4000),
   bean_                         VARCHAR2(4000),
   data_type_                    VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000),
   collection_                   BOOLEAN,
   size_                         INTEGER,
   true_value_                   VARCHAR2(4000),
   false_value_                  VARCHAR2(4000),
   scale_                        VARCHAR2(4000),
   precision_                    VARCHAR2(4000),
   mime_type_                    VARCHAR2(4000),
   nullable_                     BOOLEAN,
   exclude_from_schema_          BOOLEAN,
   insertable_                   BOOLEAN,
   inlined_                      BOOLEAN,
   updatable_                    BOOLEAN,
   attr_name_                    VARCHAR2(4000),
   keygeneration_                VARCHAR2(4000),
   unbound_                      BOOLEAN,
   file_info_                    JSON_OBJECT_T,
   execute_                      JSON_OBJECT_T,
   apidoc_                       VARCHAR2(4000),
   format_                       VARCHAR2(4000)
);

TYPE FileInfo_Rec IS RECORD (
   file_name_                    VARCHAR2(4000),
   mime_type_                    VARCHAR2(4000),
   attachment_                   BOOLEAN
);

TYPE AttributeExecute_Rec IS RECORD (
   s_q_l_                        JSON_OBJECT_T
);

TYPE AttributeExecuteSQL_Rec IS RECORD (
   select_                       VARCHAR2(4000),
   order_by_                     VARCHAR2(4000),
   implementation_type_          VARCHAR2(4000),
   alias_                        VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000)
);

TYPE AlterAttributeExecute_Rec IS RECORD (
   s_q_l_                        JSON_OBJECT_T
);

TYPE AlterAttributeExecuteSQL_Rec IS RECORD (
   select_                       VARCHAR2(4000)
);

TYPE Action_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   returns_info_                 BOOLEAN,
   implementation_               VARCHAR2(4000),
   bean_                         VARCHAR2(4000),
   data_type_                    VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000),
   true_value_                   VARCHAR2(4000),
   false_value_                  VARCHAR2(4000),
   scale_                        VARCHAR2(4000),
   precision_                    VARCHAR2(4000),
   collection_                   BOOLEAN,
   collection_bound_             BOOLEAN,
   state_transition_             BOOLEAN,
   parameters_                   JSON_ARRAY_T,
   execute_                      JSON_OBJECT_T,
   transaction_group_            VARCHAR2(4000),
   checkpoint_                   VARCHAR2(4000),
   legacy_checkpoints_           JSON_ARRAY_T,
   checkpoints_active_           VARCHAR2(4000),
   apidoc_                       JSON_OBJECT_T
);

TYPE Function_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   data_type_                    VARCHAR2(4000),
   implementation_               VARCHAR2(4000),
   bean_                         VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000),
   true_value_                   VARCHAR2(4000),
   false_value_                  VARCHAR2(4000),
   scale_                        VARCHAR2(4000),
   precision_                    VARCHAR2(4000),
   based_on_entity_set_          VARCHAR2(4000),
   support_file_info_            BOOLEAN,
   collection_                   BOOLEAN,
   crud_operation_               BOOLEAN,
   alter_attributes_             JSON_ARRAY_T,
   parameters_                   JSON_ARRAY_T,
   execute_                      JSON_OBJECT_T,
   apidoc_                       JSON_OBJECT_T
);

TYPE ApiDocObject_Rec IS RECORD (
   description_                  VARCHAR2(4000),
   return_                       VARCHAR2(4000)
);

TYPE BasedOnEntitySet_Rec IS RECORD (
   name_entity_set_              VARCHAR2(4000)
);

TYPE Parameter_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   data_type_                    VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000),
   usage_                        VARCHAR2(4000),
   true_value_                   VARCHAR2(4000),
   false_value_                  VARCHAR2(4000),
   scale_                        VARCHAR2(4000),
   precision_                    VARCHAR2(4000),
   collection_                   BOOLEAN,
   nullable_                     BOOLEAN,
   apidoc_                       VARCHAR2(4000)
);

TYPE Execute_Rec IS RECORD (
   p_l_s_q_l_                    JSON_OBJECT_T,
   s_q_l_                        JSON_OBJECT_T
);

TYPE Executearray_Rec IS TABLE OF Execute_Rec;

TYPE ExecuteSQL_Rec IS RECORD (
   where_                        VARCHAR2(4000),
   from_                         VARCHAR2(4000),
   bind_                         JSON_ARRAY_T,
   start_with_                   VARCHAR2(4000),
   connect_by_                   VARCHAR2(4000)
);

TYPE ExecutePLSQL_Rec IS RECORD (
   method_call_                  VARCHAR2(4000),
   return_type_                  VARCHAR2(4000),
   code_                         JSON_ARRAY_T,
   bind_                         JSON_ARRAY_T
);

TYPE AlterAttribute_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   execute_                      JSON_OBJECT_T
);

TYPE Bind_Rec IS RECORD (
   kind_                         VARCHAR2(4000),
   name_                         VARCHAR2(4000),
   implementation_type_          VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000),
   direction_                    VARCHAR2(4000)
);

------------------------------- MAIN METADATA -------------------------------

FUNCTION Build (
   rec_   IN Main_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Main_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.projection_ IS NULL) THEN
         json_.put('projection', JSON_OBJECT_T());
      ELSE
         json_.put('projection', rec_.projection_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY Main_Rec,
   value_ IN            Projection_Rec )
IS
BEGIN
   rec_.projection_ := Build_Json___(value_);
END Set_Projection;


FUNCTION Build (
   rec_   IN Projection_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Projection_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      json_.put('apidoc', rec_.apidoc_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.metadata_ IS NULL) THEN
         json_.put('Metadata', JSON_OBJECT_T());
      ELSE
         json_.put('Metadata', rec_.metadata_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.container_ IS NULL) THEN
         json_.put('Container', JSON_OBJECT_T());
      ELSE
         json_.put('Container', rec_.container_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.enumerations_ IS NULL) THEN
         json_.put('Enumerations', JSON_ARRAY_T());
      ELSE
         json_.put('Enumerations', rec_.enumerations_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.structures_ IS NULL) THEN
         json_.put('Structures', JSON_ARRAY_T());
      ELSE
         json_.put('Structures', rec_.structures_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.entities_ IS NULL) THEN
         json_.put('Entities', JSON_ARRAY_T());
      ELSE
         json_.put('Entities', rec_.entities_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.apidoc_ := value_;
END Set_Apidoc;
  

PROCEDURE Set_Metadata (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            Metadata_Rec )
IS
BEGIN
   rec_.metadata_ := Build_Json___(value_);
END Set_Metadata;

  

PROCEDURE Set_Container (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            Container_Rec )
IS
BEGIN
   rec_.container_ := Build_Json___(value_);
END Set_Container;

  

PROCEDURE Add_Enumerations (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            Enumeration_Rec )
IS
BEGIN
   IF (rec_.enumerations_ IS NULL) THEN
      rec_.enumerations_ := JSON_ARRAY_T();
   END IF;
   rec_.enumerations_.append(Build_Json___(value_));
END Add_Enumerations;

  

PROCEDURE Add_Structures (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            Structure_Rec )
IS
BEGIN
   IF (rec_.structures_ IS NULL) THEN
      rec_.structures_ := JSON_ARRAY_T();
   END IF;
   rec_.structures_.append(Build_Json___(value_));
END Add_Structures;

  

PROCEDURE Add_Entities (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            Entity_Rec )
IS
BEGIN
   IF (rec_.entities_ IS NULL) THEN
      rec_.entities_ := JSON_ARRAY_T();
   END IF;
   rec_.entities_.append(Build_Json___(value_));
END Add_Entities;


FUNCTION Build (
   rec_   IN Metadata_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Metadata_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Version', rec_.version_);
   END IF;
   IF (rec_.description_ IS NOT NULL) THEN
      json_.put('Description', rec_.description_);
   END IF;
   IF (rec_.category_ IS NOT NULL) THEN
      IF (rec_.category_ IS NULL) THEN
         json_.put('Category', JSON_ARRAY_T());
      ELSE
         json_.put('Category', rec_.category_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Version (
   rec_   IN OUT NOCOPY Metadata_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.version_ := value_;
END Set_Version;
  
PROCEDURE Set_Description (
   rec_   IN OUT NOCOPY Metadata_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.description_ := value_;
END Set_Description;
  
PROCEDURE Add_Category (
   rec_   IN OUT NOCOPY Metadata_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.category_ IS NULL) THEN
      rec_.category_ := JSON_ARRAY_T();
   END IF;
   rec_.category_.append(value_);
END Add_Category;

FUNCTION Build (
   rec_   IN Container_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Container_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.entity_sets_ IS NULL) THEN
         json_.put('EntitySets', JSON_ARRAY_T());
      ELSE
         json_.put('EntitySets', rec_.entity_sets_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.singletons_ IS NULL) THEN
         json_.put('Singletons', JSON_ARRAY_T());
      ELSE
         json_.put('Singletons', rec_.singletons_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.actions_ IS NULL) THEN
         json_.put('Actions', JSON_ARRAY_T());
      ELSE
         json_.put('Actions', rec_.actions_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.functions_ IS NULL) THEN
         json_.put('Functions', JSON_ARRAY_T());
      ELSE
         json_.put('Functions', rec_.functions_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Add_Entity_Sets (
   rec_   IN OUT NOCOPY Container_Rec,
   value_ IN            EntitySet_Rec )
IS
BEGIN
   IF (rec_.entity_sets_ IS NULL) THEN
      rec_.entity_sets_ := JSON_ARRAY_T();
   END IF;
   rec_.entity_sets_.append(Build_Json___(value_));
END Add_Entity_Sets;

  

PROCEDURE Add_Singletons (
   rec_   IN OUT NOCOPY Container_Rec,
   value_ IN            Singleton_Rec )
IS
BEGIN
   IF (rec_.singletons_ IS NULL) THEN
      rec_.singletons_ := JSON_ARRAY_T();
   END IF;
   rec_.singletons_.append(Build_Json___(value_));
END Add_Singletons;

  

PROCEDURE Add_Actions (
   rec_   IN OUT NOCOPY Container_Rec,
   value_ IN            Action_Rec )
IS
BEGIN
   IF (rec_.actions_ IS NULL) THEN
      rec_.actions_ := JSON_ARRAY_T();
   END IF;
   rec_.actions_.append(Build_Json___(value_));
END Add_Actions;

  

PROCEDURE Add_Functions (
   rec_   IN OUT NOCOPY Container_Rec,
   value_ IN            Function_Rec )
IS
BEGIN
   IF (rec_.functions_ IS NULL) THEN
      rec_.functions_ := JSON_ARRAY_T();
   END IF;
   rec_.functions_.append(Build_Json___(value_));
END Add_Functions;

----------------------------- INCLUDED CONTENT ------------------------------

FUNCTION Build (
   rec_   IN Structure_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Structure_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('PLSQLRecordName', rec_.p_l_s_q_l_record_name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.attributes_ IS NULL) THEN
         json_.put('Attributes', JSON_ARRAY_T());
      ELSE
         json_.put('Attributes', rec_.attributes_);
      END IF;
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      json_.put('apidoc', rec_.apidoc_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Structure_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_P_L_S_Q_L_Record_Name (
   rec_   IN OUT NOCOPY Structure_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.p_l_s_q_l_record_name_ := value_;
END Set_P_L_S_Q_L_Record_Name;
  

PROCEDURE Add_Attributes (
   rec_   IN OUT NOCOPY Structure_Rec,
   value_ IN            Attribute_Rec )
IS
BEGIN
   IF (rec_.attributes_ IS NULL) THEN
      rec_.attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.attributes_.append(Build_Json___(value_));
END Add_Attributes;


PROCEDURE Add_Attributes (
   rec_   IN OUT NOCOPY Structure_Rec,
   value_ IN            AttributeDec_Rec )
IS
BEGIN
   IF (rec_.attributes_ IS NULL) THEN
      rec_.attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.attributes_.append(Build_Json___(value_));
END Add_Attributes;

  
PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY Structure_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.apidoc_ := value_;
END Set_Apidoc;

FUNCTION Build (
   rec_   IN AttributeDec_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AttributeDec_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('DataType', rec_.data_type_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY AttributeDec_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Data_Type (
   rec_   IN OUT NOCOPY AttributeDec_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.data_type_ := value_;
END Set_Data_Type;
---------------------------- ENTITY SET CONTENT -----------------------------

FUNCTION Build (
   rec_   IN EntitySet_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN EntitySet_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('EntityType', rec_.entity_type_);
   END IF;
   IF (rec_.where_ IS NOT NULL) THEN
      json_.put('Where', rec_.where_);
   END IF;
   IF (rec_.default_where_ IS NOT NULL) THEN
      json_.put('DefaultWhere', rec_.default_where_);
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      json_.put('apidoc', rec_.apidoc_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Entity_Type (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_type_ := value_;
END Set_Entity_Type;
  
PROCEDURE Set_Where (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.where_ := value_;
END Set_Where;
  
PROCEDURE Set_Default_Where (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.default_where_ := value_;
END Set_Default_Where;
  
PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.apidoc_ := value_;
END Set_Apidoc;

FUNCTION Build (
   rec_   IN Singleton_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Singleton_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('EntityType', rec_.entity_type_);
   END IF;
   IF (rec_.where_ IS NOT NULL) THEN
      json_.put('Where', rec_.where_);
   END IF;
   IF (rec_.default_where_ IS NOT NULL) THEN
      json_.put('DefaultWhere', rec_.default_where_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Singleton_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Entity_Type (
   rec_   IN OUT NOCOPY Singleton_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_type_ := value_;
END Set_Entity_Type;
  
PROCEDURE Set_Where (
   rec_   IN OUT NOCOPY Singleton_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.where_ := value_;
END Set_Where;
  
PROCEDURE Set_Default_Where (
   rec_   IN OUT NOCOPY Singleton_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.default_where_ := value_;
END Set_Default_Where;
---------------------------- ENUMERATION CONTENT ----------------------------

FUNCTION Build (
   rec_   IN Enumeration_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Enumeration_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.values_ IS NULL) THEN
         json_.put('Values', JSON_ARRAY_T());
      ELSE
         json_.put('Values', rec_.values_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Enumeration_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Values (
   rec_   IN OUT NOCOPY Enumeration_Rec,
   value_ IN            Value_Rec )
IS
BEGIN
   IF (rec_.values_ IS NULL) THEN
      rec_.values_ := JSON_ARRAY_T();
   END IF;
   rec_.values_.append(Build_Json___(value_));
END Add_Values;


FUNCTION Build (
   rec_   IN Value_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Value_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Identifier', rec_.identifier_);
   END IF;
   IF (TRUE) THEN
      json_.put('DbValue', rec_.db_value_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Identifier (
   rec_   IN OUT NOCOPY Value_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.identifier_ := value_;
END Set_Identifier;
  
PROCEDURE Set_Db_Value (
   rec_   IN OUT NOCOPY Value_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.db_value_ := value_;
END Set_Db_Value;
------------------------------ ENTITY CONTENT -------------------------------

FUNCTION Build (
   rec_   IN Entity_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Entity_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (rec_.support_warnings_ IS NOT NULL) THEN
      json_.put('SupportWarnings', rec_.support_warnings_);
   END IF;
   IF (rec_.key_fetch_on_create_ IS NOT NULL) THEN
      json_.put('KeyFetchOnCreate', rec_.key_fetch_on_create_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.execute_ IS NULL) THEN
         json_.put('Execute', JSON_OBJECT_T());
      ELSE
         json_.put('Execute', rec_.execute_);
      END IF;
   END IF;
   IF (rec_.group_by_ IS NOT NULL) THEN
      IF (rec_.group_by_ IS NULL) THEN
         json_.put('GroupBy', JSON_ARRAY_T());
      ELSE
         json_.put('GroupBy', rec_.group_by_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.keys_ IS NULL) THEN
         json_.put('Keys', JSON_ARRAY_T());
      ELSE
         json_.put('Keys', rec_.keys_);
      END IF;
   END IF;
   IF (rec_.keys_where_ IS NOT NULL) THEN
      json_.put('KeysWhere', rec_.keys_where_);
   END IF;
   IF (rec_.connected_entities_ IS NOT NULL) THEN
      IF (rec_.connected_entities_ IS NULL) THEN
         json_.put('ConnectedEntities', JSON_ARRAY_T());
      ELSE
         json_.put('ConnectedEntities', rec_.connected_entities_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.attributes_ IS NULL) THEN
         json_.put('Attributes', JSON_ARRAY_T());
      ELSE
         json_.put('Attributes', rec_.attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.computed_ IS NULL) THEN
         json_.put('Computed', JSON_ARRAY_T());
      ELSE
         json_.put('Computed', rec_.computed_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.annotations_ IS NULL) THEN
         json_.put('Annotations', JSON_ARRAY_T());
      ELSE
         json_.put('Annotations', rec_.annotations_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.navigation_ IS NULL) THEN
         json_.put('Navigation', JSON_ARRAY_T());
      ELSE
         json_.put('Navigation', rec_.navigation_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.c_r_u_d_ IS NULL) THEN
         json_.put('CRUD', JSON_ARRAY_T());
      ELSE
         json_.put('CRUD', rec_.c_r_u_d_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.actions_ IS NULL) THEN
         json_.put('Actions', JSON_ARRAY_T());
      ELSE
         json_.put('Actions', rec_.actions_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.functions_ IS NULL) THEN
         json_.put('Functions', JSON_ARRAY_T());
      ELSE
         json_.put('Functions', rec_.functions_);
      END IF;
   END IF;
   IF (rec_.transaction_group_ IS NOT NULL) THEN
      json_.put('TransactionGroup', rec_.transaction_group_);
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      json_.put('apidoc', rec_.apidoc_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Support_Warnings (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.support_warnings_ := value_;
END Set_Support_Warnings;
  
PROCEDURE Set_Key_Fetch_On_Create (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.key_fetch_on_create_ := value_;
END Set_Key_Fetch_On_Create;
  

PROCEDURE Set_Execute (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            EntityExecute_Rec )
IS
BEGIN
   rec_.execute_ := Build_Json___(value_);
END Set_Execute;

  
PROCEDURE Add_Group_By (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.group_by_ IS NULL) THEN
      rec_.group_by_ := JSON_ARRAY_T();
   END IF;
   rec_.group_by_.append(value_);
END Add_Group_By;
  
PROCEDURE Add_Keys (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.keys_ IS NULL) THEN
      rec_.keys_ := JSON_ARRAY_T();
   END IF;
   rec_.keys_.append(value_);
END Add_Keys;
  
PROCEDURE Set_Keys_Where (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.keys_where_ := value_;
END Set_Keys_Where;
  
PROCEDURE Add_Connected_Entities (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.connected_entities_ IS NULL) THEN
      rec_.connected_entities_ := JSON_ARRAY_T();
   END IF;
   rec_.connected_entities_.append(value_);
END Add_Connected_Entities;
  

PROCEDURE Add_Attributes (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            Attribute_Rec )
IS
BEGIN
   IF (rec_.attributes_ IS NULL) THEN
      rec_.attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.attributes_.append(Build_Json___(value_));
END Add_Attributes;

  

PROCEDURE Add_Computed (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            Attribute_Rec )
IS
BEGIN
   IF (rec_.computed_ IS NULL) THEN
      rec_.computed_ := JSON_ARRAY_T();
   END IF;
   rec_.computed_.append(Build_Json___(value_));
END Add_Computed;

  

PROCEDURE Add_Annotations (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            Attribute_Rec )
IS
BEGIN
   IF (rec_.annotations_ IS NULL) THEN
      rec_.annotations_ := JSON_ARRAY_T();
   END IF;
   rec_.annotations_.append(Build_Json___(value_));
END Add_Annotations;

  

PROCEDURE Add_Navigation (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            Navigation_Rec )
IS
BEGIN
   IF (rec_.navigation_ IS NULL) THEN
      rec_.navigation_ := JSON_ARRAY_T();
   END IF;
   rec_.navigation_.append(Build_Json___(value_));
END Add_Navigation;

  

PROCEDURE Add_C_R_U_D (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            Action_Rec )
IS
BEGIN
   IF (rec_.c_r_u_d_ IS NULL) THEN
      rec_.c_r_u_d_ := JSON_ARRAY_T();
   END IF;
   rec_.c_r_u_d_.append(Build_Json___(value_));
END Add_C_R_U_D;

  

PROCEDURE Add_Actions (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            Action_Rec )
IS
BEGIN
   IF (rec_.actions_ IS NULL) THEN
      rec_.actions_ := JSON_ARRAY_T();
   END IF;
   rec_.actions_.append(Build_Json___(value_));
END Add_Actions;

  

PROCEDURE Add_Functions (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            Function_Rec )
IS
BEGIN
   IF (rec_.functions_ IS NULL) THEN
      rec_.functions_ := JSON_ARRAY_T();
   END IF;
   rec_.functions_.append(Build_Json___(value_));
END Add_Functions;

  
PROCEDURE Set_Transaction_Group (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.transaction_group_ := value_;
END Set_Transaction_Group;
  
PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.apidoc_ := value_;
END Set_Apidoc;

FUNCTION Build (
   rec_   IN EntityExecute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN EntityExecute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.s_q_l_ IS NULL) THEN
         json_.put('SQL', JSON_OBJECT_T());
      ELSE
         json_.put('SQL', rec_.s_q_l_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_S_Q_L (
   rec_   IN OUT NOCOPY EntityExecute_Rec,
   value_ IN            EntityExecuteSQL_Rec )
IS
BEGIN
   rec_.s_q_l_ := Build_Json___(value_);
END Set_S_Q_L;


FUNCTION Build (
   rec_   IN EntityExecuteSQL_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN EntityExecuteSQL_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('From', rec_.from_);
   END IF;
   IF (rec_.where_ IS NOT NULL) THEN
      json_.put('Where', rec_.where_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_From (
   rec_   IN OUT NOCOPY EntityExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.from_ := value_;
END Set_From;
  
PROCEDURE Set_Where (
   rec_   IN OUT NOCOPY EntityExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.where_ := value_;
END Set_Where;

FUNCTION Build (
   rec_   IN Navigation_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Navigation_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('Collection', rec_.collection_);
   END IF;
   IF (TRUE) THEN
      json_.put('Target', rec_.target_);
   END IF;
   IF (rec_.keys_ IS NOT NULL) THEN
      IF (rec_.keys_ IS NULL) THEN
         json_.put('Keys', JSON_ARRAY_T());
      ELSE
         json_.put('Keys', rec_.keys_);
      END IF;
   END IF;
   IF (rec_.parent_attributes_ IS NOT NULL) THEN
      IF (rec_.parent_attributes_ IS NULL) THEN
         json_.put('ParentAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('ParentAttributes', rec_.parent_attributes_);
      END IF;
   END IF;
   IF (rec_.child_attributes_ IS NOT NULL) THEN
      IF (rec_.child_attributes_ IS NULL) THEN
         json_.put('ChildAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('ChildAttributes', rec_.child_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('Where', rec_.where_);
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      json_.put('apidoc', rec_.apidoc_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Navigation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY Navigation_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;
  
PROCEDURE Set_Target (
   rec_   IN OUT NOCOPY Navigation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.target_ := value_;
END Set_Target;
  

PROCEDURE Add_Keys (
   rec_   IN OUT NOCOPY Navigation_Rec,
   value_ IN            KeyMapping_Rec )
IS
BEGIN
   IF (rec_.keys_ IS NULL) THEN
      rec_.keys_ := JSON_ARRAY_T();
   END IF;
   rec_.keys_.append(Build_Json___(value_));
END Add_Keys;

  
PROCEDURE Add_Parent_Attributes (
   rec_   IN OUT NOCOPY Navigation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.parent_attributes_ IS NULL) THEN
      rec_.parent_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.parent_attributes_.append(value_);
END Add_Parent_Attributes;
  
PROCEDURE Add_Child_Attributes (
   rec_   IN OUT NOCOPY Navigation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.child_attributes_ IS NULL) THEN
      rec_.child_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.child_attributes_.append(value_);
END Add_Child_Attributes;
  
PROCEDURE Set_Where (
   rec_   IN OUT NOCOPY Navigation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.where_ := value_;
END Set_Where;
  
PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY Navigation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.apidoc_ := value_;
END Set_Apidoc;

FUNCTION Build (
   rec_   IN KeyMapping_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN KeyMapping_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('ThisAttribute', rec_.this_attribute_);
   END IF;
   IF (TRUE) THEN
      json_.put('TargetAttribute', rec_.target_attribute_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_This_Attribute (
   rec_   IN OUT NOCOPY KeyMapping_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.this_attribute_ := value_;
END Set_This_Attribute;
  
PROCEDURE Set_Target_Attribute (
   rec_   IN OUT NOCOPY KeyMapping_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.target_attribute_ := value_;
END Set_Target_Attribute;
----------------------------- ATTRIBUTE CONTENT -----------------------------

FUNCTION Build (
   rec_   IN Attribute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Attribute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (rec_.implementation_ IS NOT NULL) THEN
      json_.put('Implementation', rec_.implementation_);
   END IF;
   IF (rec_.bean_ IS NOT NULL) THEN
      json_.put('Bean', rec_.bean_);
   END IF;
   IF (TRUE) THEN
      json_.put('DataType', rec_.data_type_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('SubType', rec_.sub_type_);
   END IF;
   IF (rec_.collection_ IS NOT NULL) THEN
      json_.put('Collection', rec_.collection_);
   END IF;
   IF (rec_.size_ IS NOT NULL) THEN
      json_.put('Size', rec_.size_);
   END IF;
   IF (rec_.true_value_ IS NOT NULL) THEN
      json_.put('TrueValue', rec_.true_value_);
   END IF;
   IF (rec_.false_value_ IS NOT NULL) THEN
      json_.put('FalseValue', rec_.false_value_);
   END IF;
   IF (rec_.scale_ IS NOT NULL) THEN
      json_.put('Scale', rec_.scale_);
   END IF;
   IF (rec_.precision_ IS NOT NULL) THEN
      json_.put('Precision', rec_.precision_);
   END IF;
   IF (rec_.mime_type_ IS NOT NULL) THEN
      json_.put('MimeType', rec_.mime_type_);
   END IF;
   IF (rec_.nullable_ IS NOT NULL) THEN
      json_.put('Nullable', rec_.nullable_);
   END IF;
   IF (rec_.exclude_from_schema_ IS NOT NULL) THEN
      json_.put('ExcludeFromSchema', rec_.exclude_from_schema_);
   END IF;
   IF (rec_.insertable_ IS NOT NULL) THEN
      json_.put('Insertable', rec_.insertable_);
   END IF;
   IF (rec_.inlined_ IS NOT NULL) THEN
      json_.put('Inlined', rec_.inlined_);
   END IF;
   IF (rec_.updatable_ IS NOT NULL) THEN
      json_.put('Updatable', rec_.updatable_);
   END IF;
   IF (rec_.attr_name_ IS NOT NULL) THEN
      json_.put('AttrName', rec_.attr_name_);
   END IF;
   IF (rec_.keygeneration_ IS NOT NULL) THEN
      json_.put('Keygeneration', rec_.keygeneration_);
   END IF;
   IF (rec_.unbound_ IS NOT NULL) THEN
      json_.put('Unbound', rec_.unbound_);
   END IF;
   IF (rec_.file_info_ IS NOT NULL) THEN
      IF (rec_.file_info_ IS NULL) THEN
         json_.put('FileInfo', JSON_OBJECT_T());
      ELSE
         json_.put('FileInfo', rec_.file_info_);
      END IF;
   END IF;
   IF (rec_.execute_ IS NOT NULL) THEN
      IF (rec_.execute_ IS NULL) THEN
         json_.put('Execute', JSON_OBJECT_T());
      ELSE
         json_.put('Execute', rec_.execute_);
      END IF;
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      json_.put('apidoc', rec_.apidoc_);
   END IF;
   IF (rec_.format_ IS NOT NULL) THEN
      json_.put('format', rec_.format_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Implementation (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.implementation_ := value_;
END Set_Implementation;
  
PROCEDURE Set_Bean (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.bean_ := value_;
END Set_Bean;
  
PROCEDURE Set_Data_Type (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.data_type_ := value_;
END Set_Data_Type;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;
  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;
  

PROCEDURE Set_Size (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.size_ := value_;
END Set_Size;

  
PROCEDURE Set_True_Value (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.true_value_ := value_;
END Set_True_Value;
  
PROCEDURE Set_False_Value (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.false_value_ := value_;
END Set_False_Value;
  
PROCEDURE Set_Scale (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.scale_ := value_;
END Set_Scale;
  
PROCEDURE Set_Precision (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.precision_ := value_;
END Set_Precision;
  
PROCEDURE Set_Mime_Type (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.mime_type_ := value_;
END Set_Mime_Type;
  
PROCEDURE Set_Nullable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.nullable_ := value_;
END Set_Nullable;
  
PROCEDURE Set_Exclude_From_Schema (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.exclude_from_schema_ := value_;
END Set_Exclude_From_Schema;
  
PROCEDURE Set_Insertable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.insertable_ := value_;
END Set_Insertable;
  
PROCEDURE Set_Inlined (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.inlined_ := value_;
END Set_Inlined;
  
PROCEDURE Set_Updatable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.updatable_ := value_;
END Set_Updatable;
  
PROCEDURE Set_Attr_Name (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attr_name_ := value_;
END Set_Attr_Name;
  
PROCEDURE Set_Keygeneration (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.keygeneration_ := value_;
END Set_Keygeneration;
  
PROCEDURE Set_Unbound (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.unbound_ := value_;
END Set_Unbound;
  

PROCEDURE Set_File_Info (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            FileInfo_Rec )
IS
BEGIN
   rec_.file_info_ := Build_Json___(value_);
END Set_File_Info;

  

PROCEDURE Set_Execute (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            AttributeExecute_Rec )
IS
BEGIN
   rec_.execute_ := Build_Json___(value_);
END Set_Execute;

  
PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.apidoc_ := value_;
END Set_Apidoc;
  
PROCEDURE Set_Format (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.format_ := value_;
END Set_Format;

FUNCTION Build (
   rec_   IN FileInfo_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FileInfo_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.file_name_ IS NOT NULL) THEN
      json_.put('FileName', rec_.file_name_);
   END IF;
   IF (rec_.mime_type_ IS NOT NULL) THEN
      json_.put('MimeType', rec_.mime_type_);
   END IF;
   IF (rec_.attachment_ IS NOT NULL) THEN
      json_.put('Attachment', rec_.attachment_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_File_Name (
   rec_   IN OUT NOCOPY FileInfo_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.file_name_ := value_;
END Set_File_Name;
  
PROCEDURE Set_Mime_Type (
   rec_   IN OUT NOCOPY FileInfo_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.mime_type_ := value_;
END Set_Mime_Type;
  
PROCEDURE Set_Attachment (
   rec_   IN OUT NOCOPY FileInfo_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.attachment_ := value_;
END Set_Attachment;

FUNCTION Build (
   rec_   IN AttributeExecute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AttributeExecute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.s_q_l_ IS NULL) THEN
         json_.put('SQL', JSON_OBJECT_T());
      ELSE
         json_.put('SQL', rec_.s_q_l_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_S_Q_L (
   rec_   IN OUT NOCOPY AttributeExecute_Rec,
   value_ IN            AttributeExecuteSQL_Rec )
IS
BEGIN
   rec_.s_q_l_ := Build_Json___(value_);
END Set_S_Q_L;


FUNCTION Build (
   rec_   IN AttributeExecuteSQL_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AttributeExecuteSQL_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.select_ IS NOT NULL) THEN
      json_.put('Select', rec_.select_);
   END IF;
   IF (rec_.order_by_ IS NOT NULL) THEN
      json_.put('OrderBy', rec_.order_by_);
   END IF;
   IF (rec_.implementation_type_ IS NOT NULL) THEN
      json_.put('ImplementationType', rec_.implementation_type_);
   END IF;
   IF (rec_.alias_ IS NOT NULL) THEN
      json_.put('Alias', rec_.alias_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('SubType', rec_.sub_type_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Select (
   rec_   IN OUT NOCOPY AttributeExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.select_ := value_;
END Set_Select;
  
PROCEDURE Set_Order_By (
   rec_   IN OUT NOCOPY AttributeExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.order_by_ := value_;
END Set_Order_By;
  
PROCEDURE Set_Implementation_Type (
   rec_   IN OUT NOCOPY AttributeExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.implementation_type_ := value_;
END Set_Implementation_Type;
  
PROCEDURE Set_Alias (
   rec_   IN OUT NOCOPY AttributeExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.alias_ := value_;
END Set_Alias;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY AttributeExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;

FUNCTION Build (
   rec_   IN AlterAttributeExecute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AlterAttributeExecute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.s_q_l_ IS NULL) THEN
         json_.put('SQL', JSON_OBJECT_T());
      ELSE
         json_.put('SQL', rec_.s_q_l_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_S_Q_L (
   rec_   IN OUT NOCOPY AlterAttributeExecute_Rec,
   value_ IN            AlterAttributeExecuteSQL_Rec )
IS
BEGIN
   rec_.s_q_l_ := Build_Json___(value_);
END Set_S_Q_L;


FUNCTION Build (
   rec_   IN AlterAttributeExecuteSQL_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AlterAttributeExecuteSQL_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.select_ IS NOT NULL) THEN
      json_.put('Select', rec_.select_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Select (
   rec_   IN OUT NOCOPY AlterAttributeExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.select_ := value_;
END Set_Select;
--------------------------- ACTIONS AND FUNCTIONS ---------------------------

FUNCTION Build (
   rec_   IN Action_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Action_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (rec_.returns_info_ IS NOT NULL) THEN
      json_.put('ReturnsInfo', rec_.returns_info_);
   END IF;
   IF (rec_.implementation_ IS NOT NULL) THEN
      json_.put('Implementation', rec_.implementation_);
   END IF;
   IF (rec_.bean_ IS NOT NULL) THEN
      json_.put('Bean', rec_.bean_);
   END IF;
   IF (rec_.data_type_ IS NOT NULL) THEN
      json_.put('DataType', rec_.data_type_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('SubType', rec_.sub_type_);
   END IF;
   IF (rec_.true_value_ IS NOT NULL) THEN
      json_.put('TrueValue', rec_.true_value_);
   END IF;
   IF (rec_.false_value_ IS NOT NULL) THEN
      json_.put('FalseValue', rec_.false_value_);
   END IF;
   IF (rec_.scale_ IS NOT NULL) THEN
      json_.put('Scale', rec_.scale_);
   END IF;
   IF (rec_.precision_ IS NOT NULL) THEN
      json_.put('Precision', rec_.precision_);
   END IF;
   IF (rec_.collection_ IS NOT NULL) THEN
      json_.put('Collection', rec_.collection_);
   END IF;
   IF (rec_.collection_bound_ IS NOT NULL) THEN
      json_.put('CollectionBound', rec_.collection_bound_);
   END IF;
   IF (rec_.state_transition_ IS NOT NULL) THEN
      json_.put('StateTransition', rec_.state_transition_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.parameters_ IS NULL) THEN
         json_.put('Parameters', JSON_ARRAY_T());
      ELSE
         json_.put('Parameters', rec_.parameters_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.execute_ IS NULL) THEN
         json_.put('Execute', JSON_OBJECT_T());
      ELSE
         json_.put('Execute', rec_.execute_);
      END IF;
   END IF;
   IF (rec_.transaction_group_ IS NOT NULL) THEN
      json_.put('TransactionGroup', rec_.transaction_group_);
   END IF;
   IF (rec_.checkpoint_ IS NOT NULL) THEN
      json_.put('Checkpoint', rec_.checkpoint_);
   END IF;
   IF (rec_.legacy_checkpoints_ IS NOT NULL) THEN
      IF (rec_.legacy_checkpoints_ IS NULL) THEN
         json_.put('LegacyCheckpoints', JSON_ARRAY_T());
      ELSE
         json_.put('LegacyCheckpoints', rec_.legacy_checkpoints_);
      END IF;
   END IF;
   IF (rec_.checkpoints_active_ IS NOT NULL) THEN
      IF (rec_.checkpoints_active_ = 'TRUE') THEN
         json_.put('CheckpointsActive', TRUE);
      ELSIF (rec_.checkpoints_active_ = 'FALSE') THEN
         json_.put('CheckpointsActive', FALSE);
      ELSE
         json_.put('CheckpointsActive', rec_.checkpoints_active_);
      END IF;
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      IF (rec_.apidoc_ IS NULL) THEN
         json_.put('apidoc', JSON_OBJECT_T());
      ELSE
         json_.put('apidoc', rec_.apidoc_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Returns_Info (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.returns_info_ := value_;
END Set_Returns_Info;
  
PROCEDURE Set_Implementation (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.implementation_ := value_;
END Set_Implementation;
  
PROCEDURE Set_Bean (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.bean_ := value_;
END Set_Bean;
  
PROCEDURE Set_Data_Type (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.data_type_ := value_;
END Set_Data_Type;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;
  
PROCEDURE Set_True_Value (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.true_value_ := value_;
END Set_True_Value;
  
PROCEDURE Set_False_Value (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.false_value_ := value_;
END Set_False_Value;
  
PROCEDURE Set_Scale (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.scale_ := value_;
END Set_Scale;
  
PROCEDURE Set_Precision (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.precision_ := value_;
END Set_Precision;
  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;
  
PROCEDURE Set_Collection_Bound (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_bound_ := value_;
END Set_Collection_Bound;
  
PROCEDURE Set_State_Transition (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.state_transition_ := value_;
END Set_State_Transition;
  

PROCEDURE Add_Parameters (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            Parameter_Rec )
IS
BEGIN
   IF (rec_.parameters_ IS NULL) THEN
      rec_.parameters_ := JSON_ARRAY_T();
   END IF;
   rec_.parameters_.append(Build_Json___(value_));
END Add_Parameters;

  

PROCEDURE Set_Execute (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            Execute_Rec )
IS
BEGIN
   rec_.execute_ := Build_Json___(value_);
END Set_Execute;

  
PROCEDURE Set_Transaction_Group (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.transaction_group_ := value_;
END Set_Transaction_Group;
  
PROCEDURE Set_Checkpoint (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.checkpoint_ := value_;
END Set_Checkpoint;
  
PROCEDURE Add_Legacy_Checkpoints (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.legacy_checkpoints_ IS NULL) THEN
      rec_.legacy_checkpoints_ := JSON_ARRAY_T();
   END IF;
   rec_.legacy_checkpoints_.append(value_);
END Add_Legacy_Checkpoints;
  
PROCEDURE Set_Checkpoints_Active (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.checkpoints_active_ := value_;
END Set_Checkpoints_Active;


PROCEDURE Set_Checkpoints_Active (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.checkpoints_active_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Checkpoints_Active;
  

PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            ApiDocObject_Rec )
IS
BEGIN
   rec_.apidoc_ := Build_Json___(value_);
END Set_Apidoc;


FUNCTION Build (
   rec_   IN Function_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Function_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('DataType', rec_.data_type_);
   END IF;
   IF (rec_.implementation_ IS NOT NULL) THEN
      json_.put('Implementation', rec_.implementation_);
   END IF;
   IF (rec_.bean_ IS NOT NULL) THEN
      json_.put('Bean', rec_.bean_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('SubType', rec_.sub_type_);
   END IF;
   IF (rec_.true_value_ IS NOT NULL) THEN
      json_.put('TrueValue', rec_.true_value_);
   END IF;
   IF (rec_.false_value_ IS NOT NULL) THEN
      json_.put('FalseValue', rec_.false_value_);
   END IF;
   IF (rec_.scale_ IS NOT NULL) THEN
      json_.put('Scale', rec_.scale_);
   END IF;
   IF (rec_.precision_ IS NOT NULL) THEN
      json_.put('Precision', rec_.precision_);
   END IF;
   IF (rec_.based_on_entity_set_ IS NOT NULL) THEN
      json_.put('BasedOnEntitySet', rec_.based_on_entity_set_);
   END IF;
   IF (rec_.support_file_info_ IS NOT NULL) THEN
      json_.put('SupportFileInfo', rec_.support_file_info_);
   END IF;
   IF (TRUE) THEN
      json_.put('Collection', rec_.collection_);
   END IF;
   IF (rec_.crud_operation_ IS NOT NULL) THEN
      json_.put('CrudOperation', rec_.crud_operation_);
   END IF;
   IF (rec_.alter_attributes_ IS NOT NULL) THEN
      IF (rec_.alter_attributes_ IS NULL) THEN
         json_.put('AlterAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('AlterAttributes', rec_.alter_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.parameters_ IS NULL) THEN
         json_.put('Parameters', JSON_ARRAY_T());
      ELSE
         json_.put('Parameters', rec_.parameters_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.execute_ IS NULL) THEN
         json_.put('Execute', JSON_OBJECT_T());
      ELSE
         json_.put('Execute', rec_.execute_);
      END IF;
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      IF (rec_.apidoc_ IS NULL) THEN
         json_.put('apidoc', JSON_OBJECT_T());
      ELSE
         json_.put('apidoc', rec_.apidoc_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Data_Type (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.data_type_ := value_;
END Set_Data_Type;
  
PROCEDURE Set_Implementation (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.implementation_ := value_;
END Set_Implementation;
  
PROCEDURE Set_Bean (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.bean_ := value_;
END Set_Bean;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;
  
PROCEDURE Set_True_Value (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.true_value_ := value_;
END Set_True_Value;
  
PROCEDURE Set_False_Value (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.false_value_ := value_;
END Set_False_Value;
  
PROCEDURE Set_Scale (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.scale_ := value_;
END Set_Scale;
  
PROCEDURE Set_Precision (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.precision_ := value_;
END Set_Precision;
  
PROCEDURE Set_Based_On_Entity_Set (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.based_on_entity_set_ := value_;
END Set_Based_On_Entity_Set;
  
PROCEDURE Set_Support_File_Info (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.support_file_info_ := value_;
END Set_Support_File_Info;
  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;
  
PROCEDURE Set_Crud_Operation (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.crud_operation_ := value_;
END Set_Crud_Operation;
  

PROCEDURE Add_Alter_Attributes (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            AlterAttribute_Rec )
IS
BEGIN
   IF (rec_.alter_attributes_ IS NULL) THEN
      rec_.alter_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.alter_attributes_.append(Build_Json___(value_));
END Add_Alter_Attributes;

  

PROCEDURE Add_Parameters (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            Parameter_Rec )
IS
BEGIN
   IF (rec_.parameters_ IS NULL) THEN
      rec_.parameters_ := JSON_ARRAY_T();
   END IF;
   rec_.parameters_.append(Build_Json___(value_));
END Add_Parameters;

  

PROCEDURE Set_Execute (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            Execute_Rec )
IS
BEGIN
   rec_.execute_ := Build_Json___(value_);
END Set_Execute;

  

PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            ApiDocObject_Rec )
IS
BEGIN
   rec_.apidoc_ := Build_Json___(value_);
END Set_Apidoc;


FUNCTION Build (
   rec_   IN ApiDocObject_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ApiDocObject_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.description_ IS NOT NULL) THEN
      json_.put('description', rec_.description_);
   END IF;
   IF (rec_.return_ IS NOT NULL) THEN
      json_.put('return', rec_.return_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Description (
   rec_   IN OUT NOCOPY ApiDocObject_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.description_ := value_;
END Set_Description;
  
PROCEDURE Set_Return (
   rec_   IN OUT NOCOPY ApiDocObject_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.return_ := value_;
END Set_Return;

FUNCTION Build (
   rec_   IN BasedOnEntitySet_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BasedOnEntitySet_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('NameEntitySet', rec_.name_entity_set_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name_Entity_Set (
   rec_   IN OUT NOCOPY BasedOnEntitySet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_entity_set_ := value_;
END Set_Name_Entity_Set;

FUNCTION Build (
   rec_   IN Parameter_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Parameter_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('DataType', rec_.data_type_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('SubType', rec_.sub_type_);
   END IF;
   IF (rec_.usage_ IS NOT NULL) THEN
      json_.put('Usage', rec_.usage_);
   END IF;
   IF (rec_.true_value_ IS NOT NULL) THEN
      json_.put('TrueValue', rec_.true_value_);
   END IF;
   IF (rec_.false_value_ IS NOT NULL) THEN
      json_.put('FalseValue', rec_.false_value_);
   END IF;
   IF (rec_.scale_ IS NOT NULL) THEN
      json_.put('Scale', rec_.scale_);
   END IF;
   IF (rec_.precision_ IS NOT NULL) THEN
      json_.put('Precision', rec_.precision_);
   END IF;
   IF (TRUE) THEN
      json_.put('Collection', rec_.collection_);
   END IF;
   IF (TRUE) THEN
      json_.put('Nullable', rec_.nullable_);
   END IF;
   IF (rec_.apidoc_ IS NOT NULL) THEN
      json_.put('apidoc', rec_.apidoc_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Data_Type (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.data_type_ := value_;
END Set_Data_Type;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;
  
PROCEDURE Set_Usage (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.usage_ := value_;
END Set_Usage;
  
PROCEDURE Set_True_Value (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.true_value_ := value_;
END Set_True_Value;
  
PROCEDURE Set_False_Value (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.false_value_ := value_;
END Set_False_Value;
  
PROCEDURE Set_Scale (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.scale_ := value_;
END Set_Scale;
  
PROCEDURE Set_Precision (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.precision_ := value_;
END Set_Precision;
  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;
  
PROCEDURE Set_Nullable (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.nullable_ := value_;
END Set_Nullable;
  
PROCEDURE Set_Apidoc (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.apidoc_ := value_;
END Set_Apidoc;

FUNCTION Build (
   rec_   IN Execute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Executearray_Rec ) RETURN JSON_ARRAY_T
IS
   json_ JSON_ARRAY_T;
BEGIN
   json_ := JSON_ARRAY_T();
   FOR i IN rec_.first .. rec_.last LOOP
      json_.append(Build_Json___(rec_(i)));
   END LOOP;
   RETURN json_;
END Build_Json___;


FUNCTION Build_Json___ (
   rec_   IN Execute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.p_l_s_q_l_ IS NOT NULL) THEN
      IF (rec_.p_l_s_q_l_ IS NULL) THEN
         json_.put('PL-SQL', JSON_OBJECT_T());
      ELSE
         json_.put('PL-SQL', rec_.p_l_s_q_l_);
      END IF;
   END IF;
   IF (rec_.s_q_l_ IS NOT NULL) THEN
      IF (rec_.s_q_l_ IS NULL) THEN
         json_.put('SQL', JSON_OBJECT_T());
      ELSE
         json_.put('SQL', rec_.s_q_l_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_P_L_S_Q_L (
   rec_   IN OUT NOCOPY Execute_Rec,
   value_ IN            ExecutePLSQL_Rec )
IS
BEGIN
   rec_.p_l_s_q_l_ := Build_Json___(value_);
END Set_P_L_S_Q_L;

  

PROCEDURE Set_S_Q_L (
   rec_   IN OUT NOCOPY Execute_Rec,
   value_ IN            ExecuteSQL_Rec )
IS
BEGIN
   rec_.s_q_l_ := Build_Json___(value_);
END Set_S_Q_L;


FUNCTION Build (
   rec_   IN ExecuteSQL_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ExecuteSQL_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.where_ IS NOT NULL) THEN
      json_.put('Where', rec_.where_);
   END IF;
   IF (rec_.from_ IS NOT NULL) THEN
      json_.put('From', rec_.from_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.bind_ IS NULL) THEN
         json_.put('Bind', JSON_ARRAY_T());
      ELSE
         json_.put('Bind', rec_.bind_);
      END IF;
   END IF;
   IF (rec_.start_with_ IS NOT NULL) THEN
      json_.put('StartWith', rec_.start_with_);
   END IF;
   IF (rec_.connect_by_ IS NOT NULL) THEN
      json_.put('ConnectBy', rec_.connect_by_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Where (
   rec_   IN OUT NOCOPY ExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.where_ := value_;
END Set_Where;
  
PROCEDURE Set_From (
   rec_   IN OUT NOCOPY ExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.from_ := value_;
END Set_From;
  

PROCEDURE Add_Bind (
   rec_   IN OUT NOCOPY ExecuteSQL_Rec,
   value_ IN            Bind_Rec )
IS
BEGIN
   IF (rec_.bind_ IS NULL) THEN
      rec_.bind_ := JSON_ARRAY_T();
   END IF;
   rec_.bind_.append(Build_Json___(value_));
END Add_Bind;

  
PROCEDURE Set_Start_With (
   rec_   IN OUT NOCOPY ExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.start_with_ := value_;
END Set_Start_With;
  
PROCEDURE Set_Connect_By (
   rec_   IN OUT NOCOPY ExecuteSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.connect_by_ := value_;
END Set_Connect_By;

FUNCTION Build (
   rec_   IN ExecutePLSQL_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ExecutePLSQL_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.method_call_ IS NOT NULL) THEN
      json_.put('MethodCall', rec_.method_call_);
   END IF;
   IF (rec_.return_type_ IS NOT NULL) THEN
      json_.put('ReturnType', rec_.return_type_);
   END IF;
   IF (rec_.code_ IS NOT NULL) THEN
      IF (rec_.code_ IS NULL) THEN
         json_.put('Code', JSON_ARRAY_T());
      ELSE
         json_.put('Code', rec_.code_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.bind_ IS NULL) THEN
         json_.put('Bind', JSON_ARRAY_T());
      ELSE
         json_.put('Bind', rec_.bind_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Method_Call (
   rec_   IN OUT NOCOPY ExecutePLSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.method_call_ := value_;
END Set_Method_Call;
  
PROCEDURE Set_Return_Type (
   rec_   IN OUT NOCOPY ExecutePLSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.return_type_ := value_;
END Set_Return_Type;
  
PROCEDURE Add_Code (
   rec_   IN OUT NOCOPY ExecutePLSQL_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.code_ IS NULL) THEN
      rec_.code_ := JSON_ARRAY_T();
   END IF;
   rec_.code_.append(value_);
END Add_Code;
  

PROCEDURE Add_Bind (
   rec_   IN OUT NOCOPY ExecutePLSQL_Rec,
   value_ IN            Bind_Rec )
IS
BEGIN
   IF (rec_.bind_ IS NULL) THEN
      rec_.bind_ := JSON_ARRAY_T();
   END IF;
   rec_.bind_.append(Build_Json___(value_));
END Add_Bind;


FUNCTION Build (
   rec_   IN AlterAttribute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AlterAttribute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (rec_.execute_ IS NOT NULL) THEN
      IF (rec_.execute_ IS NULL) THEN
         json_.put('Execute', JSON_OBJECT_T());
      ELSE
         json_.put('Execute', rec_.execute_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY AlterAttribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Execute (
   rec_   IN OUT NOCOPY AlterAttribute_Rec,
   value_ IN            AlterAttributeExecute_Rec )
IS
BEGIN
   rec_.execute_ := Build_Json___(value_);
END Set_Execute;


FUNCTION Build (
   rec_   IN Bind_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Bind_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Kind', rec_.kind_);
   END IF;
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (rec_.implementation_type_ IS NOT NULL) THEN
      json_.put('ImplementationType', rec_.implementation_type_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('SubType', rec_.sub_type_);
   END IF;
   IF (rec_.direction_ IS NOT NULL) THEN
      json_.put('Direction', rec_.direction_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Kind (
   rec_   IN OUT NOCOPY Bind_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.kind_ := value_;
END Set_Kind;
  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Bind_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Implementation_Type (
   rec_   IN OUT NOCOPY Bind_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.implementation_type_ := value_;
END Set_Implementation_Type;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY Bind_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;
  
PROCEDURE Set_Direction (
   rec_   IN OUT NOCOPY Bind_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.direction_ := value_;
END Set_Direction;
