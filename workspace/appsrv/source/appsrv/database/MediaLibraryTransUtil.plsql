-----------------------------------------------------------------------------
--
--  Logical unit: MediaLibraryTransUtil
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210731  DEEKLK  AM21R2-1725, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Transfer_Parameter_Rec IS RECORD
(
   from_repo         media_item_tab.repository%TYPE,
   to_repo           media_item_tab.repository%TYPE,
   lu_names          VARCHAR2(4000),
   media_item_types  VARCHAR2(20)
);


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Ensure_No_Text_Media___ (
   transfer_params_ IN Transfer_Parameter_Rec)
IS
   
BEGIN
   IF INSTR(transfer_params_.media_item_types, 'TEXT') <> 0 THEN
      Error_SYS.Appl_General(lu_name_, 'NOTSUPTTEXTRANSF: Transfer of Media Items of Type Text are not supported.');
   END IF;
END Ensure_No_Text_Media___;


PROCEDURE Ensure_Not_Same_Repo___ (
   transfer_params_ IN Transfer_Parameter_Rec)
IS
   
BEGIN
   IF (transfer_params_.from_repo = transfer_params_.to_repo) THEN
      Error_SYS.Appl_General(lu_name_, 'NOTSUPTRANSF: Invalid Repository transfer :P1 to :P2.', transfer_params_.from_repo, transfer_params_.to_repo);
   END IF;
END Ensure_Not_Same_Repo___;


PROCEDURE Unpack_Attrs___ (
   transfer_params_ OUT Transfer_Parameter_Rec,
   attr_            IN  VARCHAR2 )
IS
BEGIN
   transfer_params_.from_repo        := Client_SYS.Get_Item_Value('FROM_REPO',        attr_);
   transfer_params_.to_repo          := Client_SYS.Get_Item_Value('TO_REPO',          attr_);
   transfer_params_.lu_names         := Client_SYS.Get_Item_Value('LU_NAMES',         attr_);
   transfer_params_.media_item_types := Client_SYS.Get_Item_Value('MEDIA_ITEM_TYPES', attr_);   
END Unpack_Attrs___;


PROCEDURE Move_From_Db_To_Fss___ (
   item_id_     IN NUMBER,
   file_name_   IN VARCHAR2,
   file_length_ IN NUMBER)
IS
   msg_id_      NUMBER;
   json_obj_    JSON_OBJECT_T := JSON_OBJECT_T();
   json_        CLOB;
BEGIN
   Set_Main_Parameters___ (json_obj_, item_id_);
   
   Set_Other_Parameters___(json_obj_, 'FileName'    , NULL,         file_name_);
   Set_Other_Parameters___(json_obj_, 'DbFileLength', file_length_,       NULL);
   
   Finalize_Json___(json_, json_obj_);
   
   Plsqlap_Server_API.Post_Outbound_Message(json_             => json_,
                                            message_id_       => msg_id_,
                                            message_type_     => 'APPLICATION_MESSAGE',
                                            message_function_ => 'MEDIA_LIBRARY_DB_TO_FS',
                                            is_json_          => TRUE);
END Move_From_Db_To_Fss___;


PROCEDURE Move_From_Fss_To_Db___ (
   item_id_ IN NUMBER)
IS
   msg_id_      NUMBER;
   json_obj_    JSON_OBJECT_T := JSON_OBJECT_T();
   json_        CLOB;
BEGIN
   Set_Main_Parameters___ (json_obj_, item_id_);
   
   Finalize_Json___(json_, json_obj_);
   
   Plsqlap_Server_API.Post_Outbound_Message(json_             => json_,
                                            message_id_       => msg_id_,
                                            message_type_     => 'APPLICATION_MESSAGE',
                                            message_function_ => 'MEDIA_LIBRARY_FS_TO_DB',
                                            is_json_          => TRUE);
END Move_From_Fss_To_Db___;


PROCEDURE Set_Main_Parameters___ (
   json_    IN OUT JSON_OBJECT_T,
   item_id_ IN     NUMBER)
IS
BEGIN
   json_.put('ItemId', item_id_);
END Set_Main_Parameters___;


PROCEDURE Set_Other_Parameters___ (
   json_                IN OUT JSON_OBJECT_T,
   attrib_name_         IN     VARCHAR2,
   attrib_number_value_ IN     NUMBER,
   attrib_text_value_   IN     VARCHAR2)
IS
BEGIN
   IF attrib_number_value_ IS NOT NULL THEN 
      json_.put(attrib_name_ , attrib_number_value_);
   ELSE 
      json_.put(attrib_name_ , attrib_text_value_);
   END IF;
END Set_Other_Parameters___;


PROCEDURE Finalize_Json___ (json_ OUT VARCHAR2,
                            json_obj_ IN  JSON_OBJECT_T)
IS
BEGIN
   json_ := '{"MediaItemParameters":' || json_obj_.to_string || '}';
END Finalize_Json___;


PROCEDURE Get_File_Info___ (
   file_length_ IN OUT NUMBER,
   item_name_   IN OUT media_item_tab.name%TYPE,
   file_name_   IN OUT media_item_tab.media_file%TYPE,
   item_id_     IN     media_item_tab.item_id%TYPE)
IS
   CURSOR get_file_info(item_id_ NUMBER) IS
      SELECT dbms_lob.getlength(mi.media_object), mi.name, mi.media_file
      FROM media_item_tab mi
      WHERE mi.item_id = item_id_;
BEGIN
   OPEN get_file_info(item_id_);
   FETCH get_file_info INTO file_length_, item_name_, file_name_;
   CLOSE get_file_info;
END Get_File_Info___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Batch_Transfer_Media (
   attr_ IN VARCHAR2)
IS
   transfer_params_  Transfer_Parameter_Rec;
   
   lu_name_array_    Utility_SYS.STRING_TABLE;
   lu_name_count_    NUMBER;
   
   item_type_aray_   Utility_SYS.STRING_TABLE;
   item_type_count_  NUMBER;
   
   file_length_      NUMBER;
   file_name_        media_item_tab.media_file%TYPE;
   item_name_        media_item_tab.name%TYPE;
   
   file_count_       NUMBER := 0;
   
   CURSOR get_items(media_item_type_ VARCHAR2, from_repo_ VARCHAR2) IS
      SELECT mi.item_id
      FROM media_item_tab mi
      WHERE mi.media_item_type = media_item_type_
      AND mi.archived = 'FALSE'
      AND mi.repository = from_repo_;   
   
   CURSOR get_items_for_lu(lu_name_ VARCHAR2, media_item_type_ VARCHAR2, from_repo_ VARCHAR2) IS
      SELECT DISTINCT mli.item_id
      FROM media_library_item_tab mli 
      INNER JOIN media_item_tab mi ON mli.item_id = mi.item_id
      INNER JOIN media_library_tab ml ON mli.library_id = ml.library_id
      WHERE mi.media_item_type = media_item_type_
      AND ml.lu_name = lu_name_
      AND mi.archived = 'FALSE'
      AND mi.repository = from_repo_;
BEGIN
   Unpack_Attrs___(transfer_params_, attr_);
   
   Ensure_Not_Same_Repo___(transfer_params_);
   
   Ensure_No_Text_Media___(transfer_params_);
   
   IF transfer_params_.lu_names IS NOT NULL THEN 
      
      Utility_SYS.Tokenize(transfer_params_.lu_names, ';', lu_name_array_, lu_name_count_);
      FOR i IN 1..lu_name_count_ LOOP
         
         Utility_SYS.Tokenize(transfer_params_.media_item_types, ';', item_type_aray_, item_type_count_);
         FOR j IN 1..item_type_count_ LOOP
            
            FOR item_ IN get_items_for_lu(lu_name_array_(i), item_type_aray_(j), transfer_params_.from_repo) LOOP
               
               IF transfer_params_.to_repo = 'FILE_STORAGE' THEN
                  Get_File_Info___(file_length_, item_name_, file_name_, item_.item_id);
                  
                  Move_From_Db_To_Fss___(item_.item_id, nvl(file_name_, item_name_), nvl(file_length_,0));                     
               ELSE
                  Move_From_Fss_To_Db___(item_.item_id);
               END IF;
               
               file_count_ := file_count_ + 1;
            END LOOP;
         END LOOP;
      END LOOP;
   ELSE 
      Utility_SYS.Tokenize(transfer_params_.media_item_types, ';', item_type_aray_, item_type_count_);
      FOR j IN 1..item_type_count_ LOOP
         
         FOR item_ IN get_items(item_type_aray_(j), transfer_params_.from_repo) LOOP
            
            IF transfer_params_.to_repo = 'FILE_STORAGE' THEN
               Get_File_Info___(file_length_, item_name_, file_name_, item_.item_id);
               
               Move_From_Db_To_Fss___(item_.item_id, nvl(file_name_, item_name_), nvl(file_length_,0));
            ELSE 
               Move_From_Fss_To_Db___(item_.item_id);
            END IF;
            
            file_count_ := file_count_ + 1;            
         END LOOP;
      END LOOP;
   END IF;
   
   Transaction_SYS.Log_Status_Info(file_count_ || ' Media Items are succesfully posted for transferring.', 'INFO');
END Batch_Transfer_Media;



-------------------- LU  NEW METHODS -------------------------------------
