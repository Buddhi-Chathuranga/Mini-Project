-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectMapUtil
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180801  LoPrlk  Bug: 143211, Added new overload to sub method Append_Clob___ into Get_Map_Metadata and called appropriately.
--  180221  MDAHSE  Moved code from EquipmentObject.plsql to here.
--  200915  CLEKLK  AM2020R1-5967,, Modified Get_Map_Object_Info
--  201209  ILSOLK  Merged SM2020R1-5353,SMZCUST-885,156902, Changed Get_Map_Object_Info(Replace " with /" characters).
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Map_Object_Info (
   cust_type_   IN VARCHAR2 DEFAULT NULL )RETURN CLOB
IS
   --location_id_  equipment_object_tab.location_id%TYPE;
   longitude_        NUMBER;
   latitude_         NUMBER;
   json_             CLOB;
   obj_desc_         equipment_object_tab.mch_name%TYPE;
   user_cust_        equipment_object_party_tab.identity%TYPE;
   obj_state_client_ MAINTENANCE_OBJECT.operational_status%TYPE;
   coordinates_found_ BOOLEAN := FALSE;
   obj_coordinates_   VARCHAR2(100);
   belongs_object_    VARCHAR2(400);
   loc_prim_add_id_   NUMBER;
   loc_address1_      VARCHAR2(100);
   loc_zip_code_      VARCHAR2(100);
   loc_city_          VARCHAR2(100);
   loc_contact_       VARCHAR2(100);
   loc_cont_phone_    VARCHAR2(200);
   loc_cont_email_    VARCHAR2(100);
   party_type_        equipment_object_party_tab.party_type%TYPE:='CUSTOMER';
   has_cust_contr_    VARCHAR2(5);
   window_title_      VARCHAR2(50);
   loc_party_add_rec_ Location_Party_Address_API.Public_Rec;
   
   CURSOR get_objects IS
      SELECT *
      FROM EQUIPMENT_OBJECT t
      WHERE Equipment_Object_Party_API.Has_User_Customer(contract, mch_code) = 'TRUE'
      ORDER BY mch_code;

      CURSOR get_location_map_positions(location_id_ IN VARCHAR2) IS
         SELECT t.longitude, t.latitude
         FROM map_position t
         WHERE lu_name = 'Location'
         AND key_ref = 'LOCATION_ID=' || location_id_ || '^'
         AND default_position = 1;

      CURSOR get_obj_map_positions(equipment_object_seq_ IN NUMBER) IS
         SELECT t.longitude, t.latitude
         FROM map_position t
         WHERE lu_name = 'EquipmentObject'
         AND key_ref = 'EQUIPMENT_OBJECT_SEQ=' || equipment_object_seq_ || '^'
        AND default_position = 1;

      FUNCTION Attribute___ (name_      IN VARCHAR2,
                             value_     IN VARCHAR2,
                             add_comma_ IN BOOLEAN DEFAULT TRUE) RETURN VARCHAR2 IS
         attr_ VARCHAR2 (4000);
      BEGIN
         attr_ := '"' || name_ || '": "' || REPLACE (value_, '"', '\"') || '"';
         IF add_comma_ THEN
            attr_ := attr_ || ',';
         END IF;
         RETURN attr_;
      END Attribute___;

BEGIN
   user_cust_ := B2b_User_Util_API.Get_User_Default_Customer;
   FOR objects IN get_objects LOOP
      coordinates_found_ := FALSE;
      loc_address1_     :='';
      loc_zip_code_     :='';
      loc_city_         :='';
      loc_contact_      :='';
      loc_cont_phone_   :='';
      loc_cont_email_   :='';
      IF (cust_type_ = 'ENDCUST') THEN
         $IF Component_Pcmsci_SYS.INSTALLED $THEN
            has_cust_contr_ := Psc_Contr_Product_API.Has_Cust_Conract_For_Object(objects.mch_code, objects.contract, user_cust_);
         $ELSE
            has_cust_contr_ := 'FALSE';
         $END
         IF (has_cust_contr_ = 'TRUE') THEN
            obj_desc_ := objects.mch_name;
            window_title_ := objects.mch_code;
            IF (LENGTH(objects.mch_code) > 40) THEN
               window_title_ := SUBSTR(window_title_, 0, 37) || '...';
            END IF;

            OPEN get_location_map_positions(objects.location_id);
            FETCH get_location_map_positions INTO longitude_,latitude_;
            IF get_location_map_positions%FOUND THEN
               CLOSE get_location_map_positions;
               coordinates_found_ := TRUE;
               obj_coordinates_ := longitude_||chr(30)||latitude_;
            ELSE
               CLOSE get_location_map_positions;

               OPEN get_obj_map_positions(objects.equipment_object_seq);
               FETCH get_obj_map_positions INTO longitude_,latitude_;
               IF get_obj_map_positions%FOUND THEN
                  coordinates_found_ := TRUE;
                  obj_coordinates_ := longitude_||chr(30)||latitude_;
               END IF;
               CLOSE get_obj_map_positions;
            END IF;
            IF (coordinates_found_) THEN
               obj_state_client_ := Equipment_Object_API.Get_Operational_Status(objects.contract,objects.mch_code);
               IF (objects.sup_mch_code IS NOT NULL ) THEN
                  belongs_object_ := objects.sup_mch_code||' - ' ||Equipment_Object_API.Get_Sup_Mch_Name(objects.contract,objects.mch_code);
               ELSE
                  belongs_object_ := objects.sup_mch_code;
               END IF;
               IF (objects.location_id IS NOT NULL ) THEN
                  loc_prim_add_id_   := Location_Party_Address_API.Has_Primary_Visit_Address(objects.location_id, party_type_,user_cust_);
                  loc_address1_      := Location_Party_Address_API.Get_Primary_Cust_Address1(objects.location_id,loc_prim_add_id_);
                  loc_zip_code_      := Location_Party_Address_API.Get_Primary_Cust_Zip_Code(objects.location_id,loc_prim_add_id_);
                  loc_city_          := Location_Party_Address_API.Get_Primary_Cust_City(objects.location_id,loc_prim_add_id_);
                  loc_party_add_rec_ := Location_Party_Address_API.Get(objects.location_id,loc_prim_add_id_);
                  loc_contact_       := loc_party_add_rec_.contact;
                  loc_cont_phone_    := loc_party_add_rec_.phone_no;
                  loc_cont_email_    := loc_party_add_rec_.e_mail;
               END IF;

               -- loc_add_info_    := loc_address1_||chr(30)||loc_zip_code_||chr(30)||loc_city_||chr(30)||loc_contact_||chr(30)||loc_cont_phone_||chr(30)||loc_cont_email_;

               -- objects_info_ := objects_info_ ||
               --   obj_coordinates_                                                                  || chr(30) ||
               --   Equipment_Object_API.Get_Operational_Status_Db(objects.contract,objects.mch_code) || chr(30) ||
               --   objects.contract                                                                  || chr(30) ||
               --   objects.mch_code                                                                  || chr(30) ||
               --   obj_desc_                                                                         || chr(30) ||
               --   Equipment_Obj_Type_API.Get_Description(objects.mch_type)                          || chr(30) ||
               --   belongs_object_                                                                   || chr(30) ||
               --   Location_API.Get_Name(objects.location_id)                                        || chr(30) ||
               --   obj_state_client_                                                                 || chr(30) ||
               --   objects.serial_no                                                                 || chr(30) ||
               --   loc_add_info_                                                                     || chr(30) ||
               --   window_title_                                                                     || chr(30) ||
               --   objects.location_id                                                               ||';';

               json_ := json_ ||
                 '{' ||
                 Attribute___ ('Longitude'       , longitude_)                                                                        ||
                 Attribute___ ('Latitude'        , latitude_)                                                                         ||
                 Attribute___ ('Symbol'          , 'blue')                                                                            ||
                 Attribute___ ('PopupTitle'      , objects.mch_code)                                                                  ||
                 Attribute___ ('Label'           , objects.mch_code)                                                                  ||
                 Attribute___ ('Status'          , Equipment_Object_API.Get_Operational_Status_Db(objects.contract,objects.mch_code)) ||
                 Attribute___ ('Site'            , objects.contract)                                                                  ||
                 Attribute___ ('MchCode'         , objects.mch_code)                                                                  ||
                 Attribute___ ('ObjectDesc'      , obj_desc_)                                                                         ||
                 Attribute___ ('ObjectType'      , Equipment_Obj_Type_API.Get_Description(objects.mch_type))                          ||
                 Attribute___ ('BelongsToObject' , belongs_object_)                                                                   ||
                 Attribute___ ('LocationName'    , Location_API.Get_Name(objects.location_id))                                        ||
                 Attribute___ ('ClientStatus'    , obj_state_client_)                                                                 ||
                 Attribute___ ('SerialNo'        , objects.serial_no)                                                                 ||
                 Attribute___ ('Address1'        , loc_address1_)                                                                     ||
                 Attribute___ ('ZipCode'         , loc_zip_code_)                                                                     ||
                 Attribute___ ('City'            , loc_city_)                                                                         ||
                 Attribute___ ('Contact'         , loc_contact_)                                                                      ||
                 Attribute___ ('ContactPhone'    , loc_cont_phone_)                                                                   ||
                 Attribute___ ('ContactEmail'    , loc_cont_email_)                                                                   ||
                 Attribute___ ('LocationId'      , objects.location_id, FALSE)                                                        ||
                 '},'; -- This comma must be removed on the last record

            END IF;
         END IF;
      ELSIF (cust_type_ = 'MAINCUST') THEN
         obj_desc_ := objects.mch_name;
         window_title_ := objects.mch_code;
         IF (LENGTH(objects.mch_code) > 40) THEN
            window_title_ := SUBSTR(window_title_, 0, 37) || '...';
         END IF;

         OPEN get_location_map_positions(objects.location_id);
         FETCH get_location_map_positions INTO longitude_,latitude_;
         IF get_location_map_positions%FOUND THEN
            CLOSE get_location_map_positions;
            coordinates_found_ := TRUE;
            obj_coordinates_ := longitude_||chr(30)||latitude_;
         ELSE
            CLOSE get_location_map_positions;

            OPEN get_obj_map_positions(objects.equipment_object_seq);
            FETCH get_obj_map_positions INTO longitude_,latitude_;
            IF get_obj_map_positions%FOUND THEN
               coordinates_found_ := TRUE;
               obj_coordinates_ := longitude_||chr(30)||latitude_;
            END IF;
            CLOSE get_obj_map_positions;
         END IF;
         IF (coordinates_found_) THEN
            obj_state_client_ := Equipment_Object_API.Get_Operational_Status(objects.contract,objects.mch_code);
            IF (objects.sup_mch_code IS NOT NULL ) THEN
               belongs_object_ := objects.sup_mch_code||' - ' ||Equipment_Object_API.Get_Sup_Mch_Name(objects.contract,objects.mch_code);
            ELSE
               belongs_object_ := objects.sup_mch_code;
            END IF;
            IF (objects.location_id IS NOT NULL ) THEN
               loc_prim_add_id_ := Location_Party_Address_API.Has_Primary_Visit_Address(objects.location_id, party_type_,user_cust_);
               loc_address1_    := Location_Party_Address_API.Get_Primary_Cust_Address1(objects.location_id,loc_prim_add_id_);
               loc_zip_code_    := Location_Party_Address_API.Get_Primary_Cust_Zip_Code(objects.location_id,loc_prim_add_id_);
               loc_city_        := Location_Party_Address_API.Get_Primary_Cust_City(objects.location_id,loc_prim_add_id_);
               loc_contact_     := Location_Party_Address_API.Get_Contact(objects.location_id,loc_prim_add_id_);
               loc_cont_phone_  := Location_Party_Address_API.Get_Phone_No(objects.location_id,loc_prim_add_id_);
               loc_cont_email_  := Location_Party_Address_API.Get_E_Mail(objects.location_id,loc_prim_add_id_);
            END IF;

            -- loc_add_info_    := loc_address1_||chr(30)||loc_zip_code_||chr(30)||loc_city_||chr(30)||loc_contact_||chr(30)||loc_cont_phone_||chr(30)||loc_cont_email_;

            -- objects_info_ := objects_info_ ||
            --   obj_coordinates_                                                                  || chr(30) ||
            --   Equipment_Object_API.Get_Operational_Status_Db(objects.contract,objects.mch_code) || chr(30) ||
            --   objects.contract                                                                  || chr(30) ||
            --   objects.mch_code                                                                  || chr(30) ||
            --   obj_desc_                                                                         || chr(30) ||
            --   Equipment_Obj_Type_API.Get_Description(objects.mch_type)                          || chr(30) ||
            --   belongs_object_                                                                   || chr(30) ||
            --   Location_API.Get_Name(objects.location_id)                                        || chr(30) ||
            --   obj_state_client_                                                                 || chr(30) ||
            --   objects.serial_no                                                                 || chr(30) ||
            --   loc_add_info_                                                                     || chr(30) ||
            --   window_title_                                                                     || chr(30) ||
            --   objects.location_id                                                               ||';';

               json_ := json_ ||
                 '{' ||
                 Attribute___ ('Longitude'       , longitude_)                                                                        ||
                 Attribute___ ('Latitude'        , latitude_)                                                                         ||
                 Attribute___ ('Symbol'          , 'blue')                                                                            ||
                 Attribute___ ('PopupTitle'      , objects.mch_code)                                                                  ||
                 Attribute___ ('Label'           , objects.mch_code)                                                                  ||
                 Attribute___ ('Status'          , Equipment_Object_API.Get_Operational_Status_Db(objects.contract,objects.mch_code)) ||
                 Attribute___ ('Site'            , objects.contract)                                                                  ||
                 Attribute___ ('MchCode'         , objects.mch_code)                                                                  ||
                 Attribute___ ('ObjectDesc'      , obj_desc_)                                                                         ||
                 Attribute___ ('ObjectType'      , Equipment_Obj_Type_API.Get_Description(objects.mch_type))                          ||
                 Attribute___ ('BelongsToObject' , belongs_object_)                                                                   ||
                 Attribute___ ('LocationName'    , Location_API.Get_Name(objects.location_id))                                        ||
                 Attribute___ ('ClientStatus'    , obj_state_client_)                                                                 ||
                 Attribute___ ('SerialNo'        , objects.serial_no)                                                                 ||
                 Attribute___ ('Address1'        , loc_address1_)                                                                     ||
                 Attribute___ ('ZipCode'         , loc_zip_code_)                                                                     ||
                 Attribute___ ('City'            , loc_city_)                                                                         ||
                 Attribute___ ('Contact'         , loc_contact_)                                                                      ||
                 Attribute___ ('ContactPhone'    , loc_cont_phone_)                                                                   ||
                 Attribute___ ('ContactEmail'    , loc_cont_email_)                                                                   ||
                 Attribute___ ('LocationId'      , objects.location_id, FALSE)                                                        ||
                 '},'; -- This comma must be removed on the last record

         END IF;
      END IF;
   END LOOP;

   IF json_ IS NULL THEN
      RETURN '[]';
   ELSE
      RETURN '[' || SUBSTR(json_, 0, LENGTH (json_) - 1) || ']'; -- Strip last comma
   END IF;

END Get_Map_Object_Info;

FUNCTION Get_Map_Metadata (
   scenario_ IN VARCHAR2) RETURN CLOB
IS
   metadata_   CLOB;
   cust_type_  VARCHAR2 (10);

   PROCEDURE Append_Clob___ (text_ IN VARCHAR2 )
   IS
   BEGIN
      IF (metadata_ IS NULL AND text_ IS NOT NULL) THEN
         metadata_ := to_clob(text_);
      ELSIF (text_ IS NOT NULL AND LENGTH (text_) > 0) THEN
         DBMS_LOB.Writeappend(metadata_, LENGTH (text_), text_);
      END IF;
   END Append_Clob___;
   
   PROCEDURE Append_Clob___(src_ IN CLOB)
   IS
   BEGIN
      IF (metadata_ IS NULL AND src_ IS NOT NULL) THEN
         metadata_ := src_;
      ELSIF (src_ IS NOT NULL) THEN
         DBMS_LOB.Append(metadata_, src_);
      END IF;
   END Append_Clob___;

   PROCEDURE Add_Row___ (label_ IN VARCHAR2,
                         value_ IN VARCHAR2) IS
   BEGIN
      Append_Clob___ ('<tr><td><strong>' || label_ || '</strong></td><td>' || value_ || '</td></tr>');
   END Add_Row___;

BEGIN
   IF NOT (scenario_ = 'EquipmentObjectEndCustomer' OR scenario_ = 'EquipmentObjectMainCustomer' OR scenario_ = 'ObjectDetailsForRecord') THEN
      Error_SYS.Appl_General('EquipmentObjects', 'UNSUPPSCENARIO: Unsupported scenario :P1', scenario_);
   END IF;

   -- We will now build some JSON so that the map knows what information it
   -- should display, from where to get the data, etc.

   -- Beginning of JSON

   Append_Clob___ ('{');

   -- First add translations for all static texts we use in the map. In
   -- most cases, the standard texts defined in APPSRV should suffice.

   Append_Clob___ (Map_Position_Util_API.Get_Map_Metadata_Std_Texts ());
   Append_Clob___ (',');

   -- Next, pick which basemap to use. By default, "streets" is used in the
   -- map, so let's override that:

   Append_Clob___ ('"basemap": "osm",');

   -- Optionally we can add special symbols we might want to have. The map
   -- contains some basic symbols that you don't need to define here. In
   -- the object data, the attribute Symbol will be used to refer to the
   -- name of the symbol below ("cyan"). It's easy to control the color and
   -- size of the circle that makes up the symbol.

   Append_Clob___ ('"symbols": [{"name": "cyan", "symbol": {"color": [0, 150, 150], "outline": {"color": [255, 255, 255], "width": 2}}}],');

   IF (scenario_ = 'EquipmentObjectEndCustomer' OR scenario_ = 'EquipmentObjectMainCustomer') THEN

      -- Next we will build the template used for the popup dialog used when
      -- clicking on objects in the map. It can be as simple as a fixed
      -- string, but probably we want some table or similar, with object
      -- values in it. In this example we will build up a small paragraph with
      -- links and then a table to show object attributes.

      -- First add a paragraph and some links. This is all optional. The popup
      -- content can be as simple as a static texts, if needed. The example
      -- below is quite complex, with links for navigation to other Aurena
      -- pages as well as a table displayin data about the object on the map.

      Append_Clob___ ('"popupTemplate": "<p>');
      
      IF (scenario_ = 'EquipmentObjectEndCustomer') THEN
         Append_Clob___ ('<a href=\"#\" onclick=\"navigate(''EquipmentObjects'', ''EquipmentObjectEndConsumer'', ''Contract eq \\''{Site}\\'' and MchCode eq \\''{MchCode}\\'''');\">' ||
                      Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTOBDET: Objects Details') || '</a>');
      ELSE
         Append_Clob___ ('<a href=\"#\" onclick=\"navigate(''EquipmentObjects'', ''FunctionalObject'', ''Contract eq \\''{Site}\\'' and MchCode eq \\''{MchCode}\\'''');\">' ||
                      Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTOBDET: Objects Details') || '</a>');
      END IF;
         
      -- Below, the code between "[#LocationId:" and "#]" will only be part of
      -- the actual popup template used for an object if LocationId has a
      -- value. The JavaScript code will process the template and look for
      -- these expressions before the template is set on the object.

      -- The syntax is "[#ATTRIBUTENAME:OPTIONAL CODE GOES
      -- HERE#]". ATTRIBUTENAME must be the name of an attribute added to the
      -- JSON data for the object and used in the map.

      -- Navigation is done by using the "navigate" function in the map. The
      -- input is the name of the projection and page as well as the filter
      -- use on that page. Beware that quoting string values is importand, and
      -- tricky to get right.
    
      IF (scenario_ = 'EquipmentObjectEndCustomer') THEN
         Append_Clob___ ('[#LocationId: | <a href=\"#\" onclick=\"navigate(''EquipmentObjects'', ''EquipmentObjectsEndConsumer'', ''LocationId eq \\''{LocationId}\\'''');\">' ||
                         Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTOBJATLOC: Objects at Location') || '</a>#]</p>');
      ELSE
         Append_Clob___ ('[#LocationId: | <a href=\"#\" onclick=\"navigate(''EquipmentObjects'', ''MainCustEquipmentObjects'', ''LocationId eq \\''{LocationId}\\'''');\">' ||
                         Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTOBJATLOC: Objects at Location') || '</a>#]</p>');
      END IF;

      Append_Clob___ ('<table>');

      -- Below, the syntax "{ATTRIBUTENAME}" is used to inject actual object
      -- attribute data into the template. In order for that to work, the
      -- object must have an attribute with that name as part of the JSON data
      -- used by the map. Esri's API will do the replacement for us.

      Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTOBJDESC: Object Description'), '{ObjectDesc}');
      Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTOBJTYP: Object Type'),         '{ObjectType}');
      Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTBELONGS: Belongs to Object'),  '{BelongsToObject}');
      Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTSERNO: Serial Number'),        '{SerialNo}');
      Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTLOCNAME: Location Name'),      '{LocationName}');
      Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTADDRESS: Address'),            '{Address1}');
      Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTCITY: City'),                  '{City}');

      Append_Clob___ ('</table>",');

   ELSIF scenario_ = 'ObjectDetailsForRecord' THEN

      -- For scenarios where the map is bound to a record on the page, we
      -- want things to be a little bit different.

      Append_Clob___ ('"popupTemplate": "",');
      Append_Clob___ ('"zoomLevel": 4,');
      Append_Clob___ ('"pluginHeight": 400,');
      Append_Clob___ ('"defaultSymbol": "picture_pin1_blue",');
   END IF;

   IF scenario_ = 'EquipmentObjectMainCustomer' THEN
      cust_type_ := 'MAINCUST';
   ELSIF scenario_ = 'EquipmentObjectEndCustomer' THEN
      cust_type_ := 'ENDCUST';
   END IF;

   -- Add all objects

   IF (scenario_ = 'EquipmentObjectEndCustomer' OR scenario_ = 'EquipmentObjectMainCustomer') THEN
      Append_Clob___('"objects":');
      Append_Clob___(Get_Map_Object_Info (cust_type_));
   ELSIF scenario_ = 'ObjectDetailsForRecord' THEN
      -- The object / position is fetched from the record in the page instead.
      Append_Clob___ ('"objects": []');
   END IF;

   -- End JSON

   Append_Clob___ ('}');

   RETURN metadata_;

END Get_Map_Metadata;

-------------------- LU  NEW METHODS -------------------------------------
