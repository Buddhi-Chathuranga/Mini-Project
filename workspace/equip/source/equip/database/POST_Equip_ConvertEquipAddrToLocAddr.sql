--------------------------------------------------------------------------
--  File:     POST_Equip_ConvertEquipAddrToLocAddr.sql
--
--  Module:   EQUIP
--
--  Purpose:  It is possible to register/create Addresses for a Location,
--            after introducing the Location ID field (Functional Object/s) in Equipment Object entity.
--            In Equipment Object, address is handle using the addresses registered/created under connected Location.               
--              
--            The purpose of this post script is to create Location based Addresses based on the existing Equipment Object Addresses.
--            After the upgrade, new Location would be created to the Object ID.
--            Then addresses in the Equipment Object Addresses would be connected as Location Addresses to the newly created Locations. 

--
--  Date    Sign     History
--  ------  -----    --------------------------------------------------------------------------------------------
--  160105  KrRaLK   STRSA-1856, Created.
--  170510  KrRaLK   STRSA-24664, Added validation for state.
--  171101  HASTSE   STRSA-31677, Fixes
--  200226  KrRaLK   Bug 152788,  Added EQUIPMENT_OBJECT_ADDRESS_800_IXT to improve performance.
--  200423  Tajalk   Bug 153627,  Fixing some coding issues
--  200706  LoPrlk   AMZEAX-111, Altered the filtering logic of Check_Single_Location_Address___.
--  210710  lasslk   AMZEAX-620, Modified the script to improve performance.
--  211115  DEEKLK   AMZEAX-805, Modified the script to improve performance.
--  -------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_ConvertEquipAddrToLocAddr.sql','Timestamp_1');
PROMPT Starting POST_Equip_ConvertEquipAddrToLocAddr.sql


DECLARE
   stmt_ VARCHAR2(32000);
BEGIN
   IF (Database_SYS.Table_Exist('EQUIPMENT_OBJECT_ADDRESS_800')) THEN
      stmt_ := '
   DECLARE
      
   location_id_      location_tab.location_id%TYPE;
   child_obj_loc_id_ location_tab.location_id%TYPE;
   address_info_id_  location_party_address_tab.address_info_id%TYPE := NULL;
   columns_          Database_SYS.ColumnTabType;
      
    TYPE loc_address IS RECORD
   (contract    equipment_object_address_800.contract%TYPE, 
    mch_code    equipment_object_address_800.mch_code%TYPE,
    location_id equipment_object_address_800.location_id%TYPE,
    address_id  equipment_object_address_800.address_id%TYPE,
    address1    equipment_object_address_800.address1%TYPE,
    address2    equipment_object_address_800.address2%TYPE,
    address3    equipment_object_address_800.address3%TYPE,
    address4    equipment_object_address_800.address4%TYPE,
    address5    equipment_object_address_800.address5%TYPE,
    address6    equipment_object_address_800.address6%TYPE,
    address7    equipment_object_address_800.address7%TYPE,
    contact     equipment_object_address_800.contact%TYPE,
    phone_no    equipment_object_address_800.phone_no%TYPE,
    e_mail      equipment_object_address_800.e_mail%TYPE);
      
   TYPE loc_address_l IS TABLE OF loc_address;   
   loc_add_collection_  loc_address_l;
      
   -- All object default addresses that not is inherited
   CURSOR get_parent_objects IS
      SELECT contract,
             mch_code,
             location_id,
             address_id,
             address1,
             address2,
             address3,
             address4,
             address5,
             address6,
             address7,
             contact,
             phone_no,
             e_mail          
                 FROM EQUIPMENT_OBJECT_ADDRESS_800
                WHERE addr_ref_contract         IS NULL
                  AND object_structure_addr_ref IS NULL
                  AND addr_ref_id               IS NULL
                  AND def_address               = ''2'';  -- Is def address
      
   -- All object addresses that not is default and not inherited
            CURSOR get_additional_address(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT address_id,
             def_address,
             address1,
             address2,
             address3,
             address4,
             address5,
             address6,
             address7,
             location_id,
             contact,
             phone_no,
             e_mail  
                 FROM EQUIPMENT_OBJECT_ADDRESS_800
                WHERE contract = contract_
                  AND mch_code = mch_code_
                  AND object_structure_addr_ref IS NULL
                  AND (def_address IS NULL OR def_address = ''1'');
      
            FUNCTION Generate_Sequence RETURN VARCHAR2
            IS
      temp_ NUMBER := 0;
      CURSOR get_next_seq IS
                  SELECT LOCATION_SEQ.NEXTVAL
                  FROM DUAL;
   BEGIN
      OPEN get_next_seq;
               FETCH get_next_seq INTO temp_;
      CLOSE get_next_seq;
      RETURN TO_CHAR(temp_);
            END Generate_Sequence;      
      
            PROCEDURE Create_Address(
                           location_id_  IN VARCHAR2,
                            address1_     IN VARCHAR2,
                            address2_     IN VARCHAR2,
                            zip_code_     IN VARCHAR2,
                            city_         IN VARCHAR2,
                            state_        IN VARCHAR2,
                            county_       IN VARCHAR2,
                            country_code_ IN VARCHAR2,
                            contact_      IN VARCHAR2,
                            e_mail_       IN VARCHAR2,
                            phone_no_     IN VARCHAR2,
                            primary_addr_ IN VARCHAR2,
                            address3_     IN VARCHAR2 DEFAULT NULL,
                            address4_     IN VARCHAR2 DEFAULT NULL,
                            address5_     IN VARCHAR2 DEFAULT NULL,
                            address6_     IN VARCHAR2 DEFAULT NULL) IS
               party_type_db_         location_party_address_tab.party_type%TYPE;
               address_info_id_       location_party_address_tab.address_info_id%TYPE;
               state_code_            VARCHAR2(35);
               validate_state_code_   VARCHAR2(5);
               state__                VARCHAR2(35);
               state_code_exists_     BOOLEAN;
   BEGIN
      party_type_db_ := ''COMPANY'';
               state__ := state_;
      IF (country_code_ IS NOT NULL AND state_ IS NOT NULL) THEN
         validate_state_code_ := Enterp_Address_Country_API.Get_Validate_State_Code(country_code_);
                  state_code_exists_   := State_Codes_API.Exists(country_code_, State_Codes_API.Get_State_Code(country_code_, State_));
         IF (validate_state_code_ = ''TRUE'' AND NOT state_code_exists_) THEN
            state__ := NULL;
         ELSIF (validate_state_code_ = ''TRUE'' AND state_code_exists_) THEN
                     state__ := State_Codes_API.Get_State_Code(country_code_, State_);
         END IF;
      END IF;
         
      -- Create visit address for company party idenity
               Location_Party_Address_API.New_Address(
                                           address_info_id_           => address_info_id_,
                                           location_id_               => location_id_,
                                           party_type_db_             => party_type_db_,
                                           identity_                  => NULL,
                                           address_id_                => NULL,
                                           visit_address_             => ''TRUE'',
                                           delivery_address_          => ''FALSE'',
                                           location_specific_address_ => ''TRUE'',
                                           primary_address_           => primary_addr_,
                                           address1_                  => address1_,
                                           address2_                  => address2_,
                                           address3_                  => address3_,
                                           address4_                  => address4_,
                                           address5_                  => address5_,
                                           address6_                  => address6_,
                                           zip_code_                  => zip_code_,
                                           city_                      => city_,
                                           state_                     => state__,
                                           country_code_              => country_code_,
                                           county_                    => county_,
                                           contact_                   => contact_,
                                           phone_no_                  => phone_no_,
                                           e_mail_                    => e_mail_);
            END Create_Address;
      
            FUNCTION Create_Location(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2)
               RETURN VARCHAR2 IS
      attr_        VARCHAR2(32000);
      location_id_ location_tab.location_id%TYPE;
   BEGIN
               location_id_ := Generate_Sequence();
      IF (NOT Location_API.Exists(location_id_)) THEN
         Client_SYS.Clear_Attr(attr_);
                  CLient_SYS.Add_To_Attr(''LOCATION_ID'', location_id_,   attr_);
                  CLient_SYS.Add_To_Attr(''NAME'',        SUBSTR(''Location'' || ''-'' || mch_code_, 1, 64), attr_);
         Location_API.New(attr_);
      END IF;
      RETURN location_id_;
            END Create_Location;
         
            PROCEDURE Inherit_Map_Position(location_id_ IN VARCHAR2,
                                  contract_    IN VARCHAR2,
                                  mch_code_    IN VARCHAR2) IS
      keyref_eo_  VARCHAR2(512);
      keyref_loc_ VARCHAR2(512);
         
      luname_loc_   map_position.lu_name%TYPE := ''Location'';
      loc_position_ map_position%ROWTYPE;
               CURSOR getPositionFromKeyRef(keyref_ IN VARCHAR2) IS
         SELECT *
                    FROM Map_Position_TAB
                   WHERE Lu_name = ''EquipmentObject''
                     AND key_ref = keyref_;
         
   BEGIN
      IF (mch_code_ IS NOT NULL AND contract_ IS NOT NULL) THEN
         Client_SYS.Clear_Attr(keyref_eo_);
                  Client_SYS.Add_To_Key_Reference(keyref_eo_,  ''CONTRACT'', contract_);
                  Client_SYS.Add_To_Key_Reference(keyref_eo_,  ''MCH_CODE'', mch_code_);
         Client_SYS.Clear_Attr(keyref_loc_);
         Client_SYS.Add_To_Key_Reference(keyref_loc_, ''LOCATION_ID'', location_id_);
         
         -- Look for PositionFrom EO
                  FOR rec_ IN getPositionFromKeyRef(keyref_eo_) LOOP
                     Map_Position_API.Create_New_Map_Position(luname_loc_, 
                                                              keyref_loc_,
                                                              rec_.longitude,
                                                              rec_.latitude);
         END LOOP;
         
      END IF;
            END Inherit_Map_Position;
         
   -- Checks if location just is used on this specific object address
            FUNCTION Check_Single_Location_Address___(location_id_ IN VARCHAR2,
                                             mch_code_    IN VARCHAR2,
                                             contract_    IN VARCHAR2,
                                                      address_id_  IN VARCHAR2 DEFAULT NULL) RETURN BOOLEAN
            IS
      temp_ NUMBER := 0;
      CURSOR check_addr IS
         SELECT 1
                    FROM EQUIPMENT_OBJECT_ADDRESS_800
                   WHERE location_id  =  location_id_
                     AND (contract    != contract_ OR
                          mch_code    != mch_code_ OR
                          address_id  != address_id_);
   BEGIN
      OPEN check_addr;
               FETCH check_addr INTO temp_;
      IF (check_addr%FOUND) THEN
         CLOSE check_addr;
         RETURN FALSE;
      END IF;
         
      CLOSE check_addr;
      RETURN TRUE;
            END Check_Single_Location_Address___;
         
            FUNCTION Create_Location_With_Id(location_id_ IN VARCHAR2, mch_code_ IN VARCHAR2)
               RETURN VARCHAR2 IS
               attr_        VARCHAR2(32000);
   BEGIN
      IF (NOT Location_API.Exists(location_id_)) THEN
         Client_SYS.Clear_Attr(attr_);
                  CLient_SYS.Add_To_Attr(''LOCATION_ID'', location_id_,   attr_);
                  CLient_SYS.Add_To_Attr(''NAME'',        SUBSTR(''Location'' || ''-'' || NVL(mch_code_, location_id_), 1, 64), attr_);
         Location_API.New(attr_);
      END IF;
      RETURN location_id_;
            END Create_Location_With_Id;        

BEGIN
   Database_SYS.Reset_Column_Table(columns_);
   Database_SYS.Set_Table_Column(columns_,''MCH_CODE'');
   Database_SYS.Set_Table_Column(columns_,''CONTRACT'');
   Database_SYS.Create_Index(''EQUIPMENT_OBJECT_ADDRESS_800'', ''EQUIPMENT_OBJECT_ADDRESS_800_IXT'', columns_, ''N'', ''&IFSAPP_INDEX'', NULL, TRUE);
   
   Database_SYS.Reset_Column_Table(columns_);
   Database_SYS.Set_Table_Column(columns_,''ADDR_REF_CONTRACT'');
   Database_SYS.Set_Table_Column(columns_,''OBJECT_STRUCTURE_ADDR_REF'');
   Database_SYS.Create_Index(''EQUIPMENT_OBJECT_ADDRESS_800'', ''EQUIPMENT_OBJECT_ADDRESS_800_IX2'', columns_, ''N'', ''&IFSAPP_INDEX'', NULL, TRUE);
   COMMIT;
   
   OPEN get_parent_objects;
   FETCH get_parent_objects BULK COLLECT INTO loc_add_collection_;
   CLOSE get_parent_objects;
   
   FOR rec_ IN 1 .. loc_add_collection_.COUNT LOOP
      IF (loc_add_collection_(rec_).location_id IS NOT NULL AND Location_API.Exists(loc_add_collection_(rec_).location_id) AND check_single_location_address___(loc_add_collection_(rec_).location_id, loc_add_collection_(rec_).mch_code, loc_add_collection_(rec_).contract, loc_add_collection_(rec_).address_id)) THEN
         location_id_ := loc_add_collection_(rec_).location_id;
      ELSIF (loc_add_collection_(rec_).location_id IS NOT NULL AND Location_API.Exists(loc_add_collection_(rec_).location_id) = FALSE AND check_single_location_address___(loc_add_collection_(rec_).location_id, loc_add_collection_(rec_).mch_code, loc_add_collection_(rec_).contract, loc_add_collection_(rec_).address_id) )THEN
         location_id_ := create_location_with_id(loc_add_collection_(rec_).location_id, loc_add_collection_(rec_).mch_code);
      ELSE
         location_id_ := create_location(loc_add_collection_(rec_).contract, loc_add_collection_(rec_).mch_code);
         inherit_map_position(location_id_, loc_add_collection_(rec_).contract, loc_add_collection_(rec_).mch_code);
      END IF;
   
      inherit_map_position(location_id_, loc_add_collection_(rec_).contract, loc_add_collection_(rec_).mch_code);
      create_address(location_id_, loc_add_collection_(rec_).address1, loc_add_collection_(rec_).address2, loc_add_collection_(rec_).address3, loc_add_collection_(rec_).address4, loc_add_collection_(rec_).address5, loc_add_collection_(rec_).address6, loc_add_collection_(rec_).address7, loc_add_collection_(rec_).contact, loc_add_collection_(rec_).e_mail, loc_add_collection_(rec_).phone_no, ''TRUE'');
      
      FOR child_add_rec_ IN get_additional_address(loc_add_collection_(rec_).contract, loc_add_collection_(rec_).mch_code) LOOP
         create_address(location_id_, child_add_rec_.address1, child_add_rec_.address2, child_add_rec_.address3, child_add_rec_.address4, child_add_rec_.address5, child_add_rec_.address6, child_add_rec_.address7, child_add_rec_.contact, child_add_rec_.e_mail, child_add_rec_.phone_no, ''FALSE'');
      END LOOP;
         
      UPDATE equipment_object_tab equip_tab 
      SET    equip_tab.location_id = location_id_ 
      WHERE  equip_tab.contract = loc_add_collection_(rec_).contract 
      AND    equip_tab.mch_code = loc_add_collection_(rec_).mch_code; 
         
      UPDATE equipment_object_tab equip_tab
      SET equip_tab.location_id = location_id_
      WHERE (equip_tab.contract, equip_tab.mch_code) IN ( SELECT e.contract, e.mch_code 
                                                          FROM EQUIPMENT_OBJECT_ADDRESS_800 e 
                                                          WHERE e.addr_ref_contract = loc_add_collection_(rec_).contract 
                                                          AND e.object_structure_addr_ref = loc_add_collection_(rec_).mch_code 
                                                          AND e.def_address = ''2'' ); 
   END LOOP;
                                                            
   Database_SYS.Remove_Indexes(''EQUIPMENT_OBJECT_ADDRESS_800'', ''EQUIPMENT_OBJECT_ADDRESS_800_IXT'',TRUE);
   Database_SYS.Remove_Indexes(''EQUIPMENT_OBJECT_ADDRESS_800'', ''EQUIPMENT_OBJECT_ADDRESS_800_IX2'',TRUE);
   COMMIT;
END;
                    ';   
   END IF;
   IF stmt_ IS NOT NULL THEN
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;        
/

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_ConvertEquipAddrToLocAddr.sql','Done');
PROMPT Finished with POST_Equip_ConvertEquipAddrToLocAddr.sql
