-----------------------------------------------------------------------------
--
--  Logical unit: ObjectConnectionsMetadata
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200316  RAKUSE  Created.
--  200616  RAKUSE  Added B2B handling in metadata creation. (TEAURENAFW-2709)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

CATEGORY_USERS             CONSTANT VARCHAR2(10) := 'Users';
CLIENT_SUFFIX_USERS        CONSTANT VARCHAR2(10) := 'Attachment';

CATEGORY_EXTERNAL_B2B      CONSTANT VARCHAR2(20) := 'ExternalB2B';
CLIENT_SUFFIX_EXTERNAL_B2B CONSTANT VARCHAR2(20) := 'B2bAttachment';


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Append_Clob___ (
   clob_ IN OUT NOCOPY CLOB,
   text_ IN            VARCHAR2 )
IS
BEGIN
   IF (clob_ IS NULL AND text_ IS NOT NULL) THEN
      clob_ := to_clob(text_);
   ELSIF (text_ IS NOT NULL AND length(text_) > 0) THEN
      Dbms_Lob.WriteAppend(clob_, length(text_), text_);
   END IF;
END Append_Clob___;


-- OBSOLETE!!! To be removed!!!
FUNCTION Get_Json_Entities___ (
   used_entities_  IN VARCHAR2) RETURN CLOB
IS
   output_           CLOB;
   obj_con_entities_ Utility_SYS.String_Table;
   obj_con_services_ Utility_SYS.String_Table;
BEGIN
   -- services
   Append_Clob___(output_, '{ "services": {');
   Enum_Active_Services___(obj_con_entities_, obj_con_services_, used_entities_);
   IF (obj_con_entities_.COUNT > 0) THEN
      FOR object IN 1 .. obj_con_entities_.COUNT LOOP
         IF (object > 1) THEN
            Append_Clob___(output_, ', ');
         END IF;
         Append_Clob___(output_, '"' || obj_con_entities_(object) || '": "' || obj_con_services_(object) || '"');
      END LOOP;
   END IF;

   Append_Clob___(output_, '}, "metadata": [] }');            

   RETURN output_;
END Get_Json_Entities___;

FUNCTION Enum_Entity_Services___ (
   used_entities_  IN VARCHAR2) RETURN CLOB
IS
   output_           CLOB;
   obj_con_entities_ Utility_SYS.String_Table;
   obj_con_services_ Utility_SYS.String_Table;
BEGIN
   Enum_Active_Services___(obj_con_entities_, obj_con_services_, used_entities_);
   IF (obj_con_entities_.COUNT > 0) THEN
      FOR object IN 1 .. obj_con_entities_.COUNT LOOP
         IF (object > 1) THEN
            Append_Clob___(output_, ', ');
         END IF;
         Append_Clob___(output_, '"' || obj_con_entities_(object) || '": "' || obj_con_services_(object) || '"');
      END LOOP;
   END IF;
   
   RETURN output_;
END Enum_Entity_Services___;


FUNCTION Expand_Entities_Based_On___ (
   used_entities_ IN VARCHAR2) RETURN VARCHAR2
IS
   entities_            Utility_SYS.String_Table;
   entities_based_on_   Utility_SYS.String_Table;
   entities_str_        VARCHAR2(4000);
   dummy_               NUMBER;
BEGIN
   IF (used_entities_ IS NULL) THEN
      RETURN used_entities_;
   END IF;
   
   Utility_SYS.Tokenize(used_entities_, ',', entities_, dummy_); 
   IF (dummy_ = 0) THEN
      RETURN used_entities_;
   END IF;
    
   entities_str_ := used_entities_;
   FOR i IN 1 .. entities_.COUNT LOOP
      entities_based_on_ := Object_Connection_SYS.Enumerate_Entities_Based_On_(entities_(i));
      IF (entities_based_on_.COUNT > 0) THEN
         FOR j IN 1 .. entities_based_on_.COUNT LOOP
            entities_str_ := Utility_SYS.Add_To_String_List(entities_str_, ',' || entities_based_on_(j), ',');         
         END LOOP;
      END IF;
   END LOOP;
   
   RETURN entities_str_;
END Expand_Entities_Based_On___;


PROCEDURE Enum_Active_Services___ (
   obj_con_entities_ OUT Utility_SYS.String_Table,
   obj_con_services_ OUT Utility_SYS.String_Table,
   used_entities_    IN  VARCHAR2)
IS   
   entities_      Utility_SYS.String_Table;
   services_      Utility_SYS.String_Table;
   dummy_         NUMBER;
   lu_services_   VARCHAR2(32000);
   count_         NUMBER := 0;
BEGIN
   IF (used_entities_ IS NULL) THEN
      RETURN;
   END IF;
      
   Utility_SYS.Tokenize(Expand_Entities_Based_On___(used_entities_), ',', entities_, dummy_); 
   IF (dummy_ = 0) THEN
      RETURN;
   END IF;
      
   FOR i IN 1 .. entities_.COUNT LOOP
      lu_services_ := NULL;
      services_ := Object_Connection_SYS.Enumerate_Lu_Services(entities_(i));            
      IF (services_.COUNT > 0) THEN
         FOR s IN 1 .. services_.COUNT LOOP                                          
            IF (lu_services_ IS NOT NULL) THEN
               lu_services_ := lu_services_ || ',';
            END IF;
            lu_services_ := lu_services_ || services_(s);
         END LOOP;

         IF (lu_services_ IS NOT NULL) THEN
            count_ := count_ + 1;
            obj_con_entities_(count_) := entities_(i);
            obj_con_services_(count_) := lu_services_;
         END IF;
      END IF;
   END LOOP;
      
END Enum_Active_Services___;

FUNCTION Find_Model_For_Category___ ( 
   service_name_ IN VARCHAR2,
   category_     IN VARCHAR2) RETURN VARCHAR2
IS
   projection_id_ VARCHAR2(200);
   model_id_      VARCHAR2(200);
   client_name_   VARCHAR2(200);
   
   CURSOR check_exist IS
      SELECT reference
      FROM fnd_model_design_tab
      WHERE model_id = model_id_;
BEGIN
   IF (category_ = CATEGORY_EXTERNAL_B2B) THEN
      client_name_ := service_name_ || CLIENT_SUFFIX_EXTERNAL_B2B;    
   ELSE
      -- The rest assumes using the 'Users' category.
      client_name_ := service_name_ || CLIENT_SUFFIX_USERS;    
   END IF;
   model_id_ := Model_Design_SYS.CLIENT_METADATA || '.client:' || client_name_;
   
   OPEN check_exist;
   FETCH check_exist INTO projection_id_;
   CLOSE check_exist;

   IF (projection_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   
   -- TODO: Enforce security here, before sending metadata back o client? /Rakuse
   RETURN client_name_;
END Find_Model_For_Category___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Route_Callback_Content_ (
   method_ IN VARCHAR2,
   param_  IN VARCHAR2,
   clob_   OUT NOCOPY CLOB) RETURN BOOLEAN
IS
BEGIN
   CASE method_
      WHEN 'GET_JSON_ENTITIES_' THEN
         clob_ := Get_Json_Entities___(param_);
      WHEN 'ENUM_ENTITY_SERVICES_' THEN
         clob_ := Enum_Entity_Services___(param_);
      ELSE
         clob_ := '';         
         RETURN FALSE;
   END CASE;
   
   RETURN TRUE;
END Route_Callback_Content_;
   
@UncheckedAccess
FUNCTION Enumerate_Services_ (
   services_     OUT Utility_SYS.STRING_TABLE,
   models_       OUT Utility_SYS.STRING_TABLE,
   descriptions_ OUT Utility_SYS.STRING_TABLE,
   category_     IN VARCHAR2) RETURN NUMBER
IS
   all_services_ Utility_SYS.STRING_TABLE;
   model_name_   VARCHAR2(128);
   
   count_       NUMBER := 0;
   service_arr_ Utility_SYS.STRING_TABLE;
   model_arr_   Utility_SYS.STRING_TABLE;
   desc_arr_    Utility_SYS.STRING_TABLE;
BEGIN   
   IF (category_ != CATEGORY_USERS) AND 
      (category_ != CATEGORY_EXTERNAL_B2B) THEN
         Error_SYS.Appl_General(lu_name_, 'UNSUPPORTED_CATEGORY: Supported categories for Object Connection Services are "' || CATEGORY_USERS || '" and "' || CATEGORY_EXTERNAL_B2B || '"');     
   END IF;
   
   all_services_ := Object_Connection_SYS.Enumerate_Services();
   IF (all_services_.COUNT > 0) THEN
      FOR i IN 1 .. all_services_.COUNT LOOP
         model_name_  := Find_Model_For_Category___(all_services_(i), category_);
         IF (model_name_ IS NOT NULL) THEN
            -- Add the service to the list but only if it have a supporting client model for the specific category.
            count_ := count_ + 1;
            service_arr_(count_) := all_services_(i);
            model_arr_(count_)   := model_name_;
            desc_arr_(count_)    := Object_Connection_SYS.Get_Logical_Unit_Description(all_services_(i));            
         END IF;                 
      END LOOP;
   END IF;
   
   -- Debug
--   IF (count_ = 0) THEN
--      dbms_output.put_line('No Services for Category "' || category_ || '"');
--   ELSE
--      dbms_output.put_line('Services for Category "' || category_ || '":');
--      FOR i IN 1 .. count_ LOOP
--         dbms_output.put_line(' ' || i || ': ' || service_arr_(i) || ' (' || desc_arr_(i) || ') -> ' || model_arr_(i));
--      END LOOP;
--   END IF;
   
   services_     := service_arr_;
   models_       := model_arr_;
   descriptions_ := desc_arr_;
   
   RETURN count_;
END Enumerate_Services_;

@UncheckedAccess
FUNCTION Is_Model_Service_ (
   model_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   name_ VARCHAR2(200);
BEGIN
   IF (model_name_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   
   name_ := REPLACE(model_name_, CLIENT_SUFFIX_USERS);
   IF (name_ || CLIENT_SUFFIX_USERS = model_name_) THEN
      RETURN Object_Connection_SYS.Is_Service(name_);
   END IF;

   name_ := REPLACE(model_name_, CLIENT_SUFFIX_EXTERNAL_B2B);
   IF (name_ || CLIENT_SUFFIX_EXTERNAL_B2B = model_name_) THEN
      RETURN Object_Connection_SYS.Is_Service(name_);
   END IF;      
               
   RETURN FALSE;
END Is_Model_Service_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
