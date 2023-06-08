-----------------------------------------------------------------------------
--
--  Logical unit: CharacteristicPrintout
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190703  SBalLK   Bug 149033 (SCZ-5531), Modified Print_Characteristic___() method to print characteristic with negetive prices.
--  160923  RuLiLk   Bug 126029, Modified method Print_Characteristic___() to not print characteristic lines with negative or 0 prices
--  160923           when print configuration code is PRINTWITHPRICECONTRIBCHAR. 
--  160729  NiLalk   STRSC-2137, Added missed rpt_table_name parameter in Print_Characteristic___ method call within Print_Characteristic method.
--  160322  MaIklk   LIM-6596, Moved this utility package form ORDER to SHPMNT.
--  141125  Chfose   PRSC-3846, Extracted checks from call in Print_Characteristic___. 
--  140521  RoJalk   Modified Print_Characteristic___and used the tag DynamicComponentDependency since all the logic within method depend on CFGCHR. 
--  130704  MaRalk   TIBE-950, Removed global LU constant inst_ConfigSpecValue_ and moved dynamic sql block to new Print_Characteristic___ method.
--  120710  Chahlk   MOSXP-921, Modified the Display Text for Included Package Characteristics to diplay Characteristic/Option Description.
--  120626  Chahlk   MOSXP-732, Renamed Package_Content to Config Value Type..
--  120622  Chahlk   MOSXP-732, Added Package_Content Column.
--  100512  Ajpelk   Merge rose method documentation
--  100223  PaWelk   Bug 88699, Added new xml element PRINT_FIRST_RECORD to trace the first characteristic node which needs be printed as an attachment.
--  091209  PaWelk   Bug 87358, Merged Mosaic code to support track. 
--  060626  JaJalk   Bug 57455, Added the asset safe condition to the concatenated schemas in the dynamic call of the method Print_Characteristic.
--  050920  SaMelk   Removed the unused variables ptr_, name_, value_, configuration_last_, language_code_ and order_no_ from the method 'Print_Characteristic'.
--  050330  ToBeSe   Bug 49409, Modified Print_Characteristic to use the public cursor
--                   Config_Manager_API.Get_Config_Char_Value and completely re-designed the print code logic.
--  050516  Castse   Bug 50143, Modified connection between reportname and config_display_type in Print_Characteristic.
--  040826  SaNalk   Modified the positions of the IN parameters in the method Print_Characteristic.
--  040227  SaRalk   Bug 38375, Modified method Print_Characteristic by adding char_rec_.c_characteristic_block, 
--  040227           char_rec_.c_characteristic_sub_block, characteristic_block_ and characteristic_sub_block_ to the insert statement.
--  040203  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  031208  DaZa  Added xml_ as an in/out parameter and xml_element_, do_xml_/do_rs_ as 
--                in parameters in method Print_Characteristic. Added xml adaptations for Report Designer.
--  010419  CaRa  Bug Fix 20215, Added order by to cursor get_config_char_value.
--  010413  JaBa  Bug Fix 20598,Added new global lu constant inst_ConfigSpecValue_ and used it in Print_Characteristic.
--  001206  DaZa  Added dont_print := 0 in the beginning of the loop.
--  001018  JakH  Cleaned the dynamic code.
--  001018  JakH  Remove call to Config_Spec_Usage_API, fetch the configuration id from record.
--  000913  FBen  Added UNDEFINE.
--  000815  DaZa  Removed global variables and attribute strings and instead used a
--                public record for these. Also removed method Init_Print_Characteristic.
--  000711  TFU   merging from Chameleon
--  000629  ReSt  Created.
--  ------------------------------ 13.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Public_Rec IS RECORD
   (reportname                VARCHAR2(30),
    doc_code                  VARCHAR2(3),
    order_no                  VARCHAR2(12),
    quote_no                  VARCHAR2(12),
    c_characteristic_id       VARCHAR2(3),
    c_characteristic_value    VARCHAR2(3),
    c_characteristic_uom      VARCHAR2(3),
    c_characteristic_qty      VARCHAR2(3),
    c_characteristic_first    VARCHAR2(3),
    c_characteristic_last     VARCHAR2(3),
    c_characteristic_act      VARCHAR2(3),
    c_characteristic_price    VARCHAR2(3),
    c_characteristic_pflag    VARCHAR2(3),
    c_characteristic_block    VARCHAR2(3),
    c_characteristic_sub_block  VARCHAR2(3),
    language_code             VARCHAR2(2),
    print_char_code           VARCHAR2(3),
    print_control_code        VARCHAR2(10),
    line_no                   VARCHAR2(4),
    rel_no                    VARCHAR2(4),
    line_item_no              NUMBER,
    sales_part_no             VARCHAR2(25),
    manual_flag               VARCHAR2(15),
    result_key                NUMBER,
    parent_row_no             NUMBER,
    configuration_id          VARCHAR2(50),
    configured_line_price_id  NUMBER,
    characteristic_block      NUMBER,
    characteristic_sub_block  NUMBER,
    source_ref_type_db        VARCHAR2(20));

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@DynamicComponentDependency CFGCHR 
PROCEDURE Print_Characteristic___ (
      row_no_                 IN OUT NUMBER, 
      xml_                    IN OUT CLOB,   
      xml_element_            IN     VARCHAR2,
      do_xml_flag_            IN     NUMBER,
      do_rs_flag_             IN     NUMBER,
      char_rec_               IN     Public_Rec,
      rpt_table_name_         IN     VARCHAR2,
      config_display_type_db_ IN     VARCHAR2,
      print_config_code_      IN     VARCHAR2,
      print_media_items_      IN     VARCHAR2 DEFAULT NULL,
      report_id_              IN     VARCHAR2 DEFAULT NULL,
      media_print_option_     IN     VARCHAR2 DEFAULT NULL)   
   IS
      characteristic_first_          NUMBER := 1;
      characteristic_last_           NUMBER := 0;
      characteristic_pflag_          NUMBER := 0;
      dont_print_                    NUMBER := 0;    /* 1 = dont print characteristic line  0 = print line */
      characteristic_price_          NUMBER;
      unit_code_                     VARCHAR2(30);
      language_code_                 VARCHAR2(2) := char_rec_.language_code;
      characteristic_block_          NUMBER := char_rec_.characteristic_block;  
      characteristic_sub_block_      NUMBER := char_rec_.characteristic_sub_block;        
      library_id_                    VARCHAR2(200) := NULL;
      option_library_id_             VARCHAR2(200) := NULL;
      option_text_lib_id_            VARCHAR2(200) := NULL;
      option_image_lib_id_           VARCHAR2(200) := NULL;
      char_library_id_               VARCHAR2(200) := NULL;
      char_text_lib_id_              VARCHAR2(200) := NULL;
      char_image_lib_id_             VARCHAR2(200) := NULL;
      char_id_media_obj_exist_       NUMBER;
      char_val_media_obj_exist_      NUMBER;
      char_id_media_text_exist_      NUMBER;
      char_val_media_text_exist_     NUMBER;
      option_lib_item_source_        VARCHAR2(2000);
      option_lib_text_source_        VARCHAR2(2000);
      option_lib_image_source_       VARCHAR2(2000);
      char_lib_item_source_          VARCHAR2(2000);
      char_lib_text_source_          VARCHAR2(2000);
      char_lib_image_source_         VARCHAR2(2000);
      base_val_media_obj_exist_      NUMBER;
      base_id_media_obj_exist_       NUMBER;
      base_val_media_text_exist_     NUMBER;
      base_id_media_text_exist_      NUMBER;
      media_text_                    CLOB;
      media_text_var_                VARCHAR2(32000);
      print_text_                    VARCHAR2(5);
      print_image_                   VARCHAR2(5);
      lang_code_                     VARCHAR2(2);
      count_                         NUMBER;
      round_                         NUMBER;
      print_option_                  VARCHAR2(5);
      print_char_                    VARCHAR2(5);
      print_first_record_            VARCHAR2(15) := 'NOT PRINTED';
      comp_characteristics_used_     VARCHAR2(32000);
      attr_                          VARCHAR2(32000); 
      ptr_                           NUMBER;
      name_                          VARCHAR2(30);
      value_                         VARCHAR2(2000);
      content_char_id_                 VARCHAR2(2000); 
      content_opt_value_id_          VARCHAR2(2000);  
      stmt_                          VARCHAR2(4000);

      CURSOR get_media_text(library_id_ VARCHAR2) IS
         SELECT j.library_item_id, j.item_id, k.media_text, k.name
         FROM media_item_join j, media_item k
         WHERE j.library_id = library_id_
         AND j.media_item_type_db = 'TEXT'
         AND k.item_id = j.item_id
         AND (j.obsolete = 'FALSE' OR j.obsolete IS NULL);

      CURSOR get_media_object(library_id_ VARCHAR2) IS
         SELECT library_item_id, item_id, name
         FROM media_item_join
         WHERE library_id = library_id_
         AND media_item_type_db = 'IMAGE'
         AND (obsolete = 'FALSE' OR obsolete IS NULL);
   BEGIN
      FOR confman_rec in Config_Manager_API.Get_Config_Char_Value(char_rec_.sales_part_no, char_rec_.configuration_id, config_display_type_db_, language_code_) LOOP
         char_id_media_obj_exist_   := 0;  
         char_val_media_obj_exist_  := 0;
         char_id_media_text_exist_  := 0;  
         char_val_media_text_exist_ := 0;
         base_val_media_obj_exist_  := 0;
         base_id_media_obj_exist_   := 0;
         base_val_media_text_exist_ := 0;
         base_id_media_text_exist_  := 0;
         count_ := 0;

         dont_print_ := 0;
         
         unit_code_ := Config_Characteristic_API.Get_Unit_Code(confman_rec.characteristic_id);
         

         IF print_config_code_ IN ('PRINTWITHPRICEALLCHAR', 'PRINTWITHPRICECONTRIBCHAR') THEN
            characteristic_pflag_ := 1;
         ELSE
            characteristic_pflag_ := 0;
         END IF;

         IF characteristic_pflag_ = 1 THEN                    /*  get the characteristic price      */
            characteristic_price_ := Shipment_Source_Utility_API.Get_Characteristic_Price(char_rec_.configured_line_price_id, 
                                                                                          char_rec_.sales_part_no, 
                                                                                          char_rec_.configuration_id,
                                                                                          confman_rec.spec_revision_no, 
                                                                                          confman_rec.characteristic_id,
                                                                                          confman_rec.config_spec_value_id,
                                                                                          char_rec_.source_ref_type_db);           
            IF ((characteristic_price_ IS NULL OR characteristic_price_ = 0) AND print_config_code_ = 'PRINTWITHPRICECONTRIBCHAR') THEN
                  dont_print_ := 1;      /* No price found*/
            END IF;
            characteristic_price_ := NVL(characteristic_price_, 0);
         END IF; 
         IF (print_media_items_ = 'TRUE') THEN
            option_library_id_ := Media_Library_Item_API.Media_Library_Item_Exist('BasePartOptionValue', char_rec_.sales_part_no, confman_rec.spec_revision_no, confman_rec.characteristic_id, confman_rec.characteristic_value );
            option_lib_item_source_ := 'BasePartOptionValue';
            option_text_lib_id_ := option_library_id_;
            option_lib_text_source_ := 'BasePartOptionValue';
            option_image_lib_id_ := option_library_id_;
            option_lib_image_source_ := 'BasePartOptionValue';
            IF (option_library_id_ IS NULL) THEN
               option_library_id_ := Media_Library_Item_API.Media_Library_Item_Exist('ConfigOptionValue', confman_rec.characteristic_id, confman_rec.characteristic_value);
               option_lib_item_source_ := 'ConfigOptionValue';
               option_text_lib_id_ := option_library_id_;
               option_lib_text_source_ := 'ConfigOptionValue';
               option_image_lib_id_ := option_library_id_;
               option_lib_image_source_ := 'ConfigOptionValue';
            ELSE
               IF (Media_Library_Item_API.Media_Lib_Items_Obsolete(option_library_id_, 'IMAGE') = 'TRUE') THEN
                  option_image_lib_id_ := Media_Library_Item_API.Media_Library_Item_Exist('ConfigOptionValue', confman_rec.characteristic_id, confman_rec.characteristic_value);
                  option_lib_image_source_ := 'ConfigOptionValue';
               END IF;
               IF (Media_Library_Item_API.Media_Lib_Items_Obsolete(option_library_id_, 'TEXT') = 'TRUE') THEN
                  option_text_lib_id_ := Media_Library_Item_API.Media_Library_Item_Exist('ConfigOptionValue', confman_rec.characteristic_id, confman_rec.characteristic_value);
                  option_lib_text_source_ := 'ConfigOptionValue';
               END IF;
            END IF;

            char_library_id_ := Media_Library_Item_API.Media_Library_Item_Exist('BasePartCharacteristic', char_rec_.sales_part_no, confman_rec.spec_revision_no, confman_rec.characteristic_id );
            char_lib_item_source_ := 'BasePartCharacteristic';
            char_text_lib_id_ := char_library_id_;
            char_lib_text_source_ := 'BasePartCharacteristic';
            char_image_lib_id_ := char_library_id_;
            char_lib_image_source_ := 'BasePartCharacteristic';
            IF (char_library_id_ IS NULL) THEN
               char_library_id_ := Media_Library_Item_API.Media_Library_Item_Exist('ConfigCharacteristic', confman_rec.characteristic_id);
               char_lib_item_source_ := 'ConfigCharacteristic';
               char_text_lib_id_ := char_library_id_;
               char_lib_text_source_ := 'ConfigCharacteristic';
               char_image_lib_id_ := char_library_id_;
               char_lib_image_source_ := 'ConfigCharacteristic';
            ELSE
               IF (Media_Library_Item_API.Media_Lib_Items_Obsolete(char_library_id_, 'IMAGE') = 'TRUE') THEN
                  char_image_lib_id_ := Media_Library_Item_API.Media_Library_Item_Exist('ConfigCharacteristic', confman_rec.characteristic_id);
                  char_lib_image_source_ := 'ConfigCharacteristic';
               END IF;
               IF (Media_Library_Item_API.Media_Lib_Items_Obsolete(char_library_id_, 'TEXT') = 'TRUE') THEN
                  char_text_lib_id_ := Media_Library_Item_API.Media_Library_Item_Exist('ConfigCharacteristic', confman_rec.characteristic_id);
                  char_lib_text_source_ := 'ConfigCharacteristic';
               END IF;
            END IF;

            IF (option_library_id_ IS NOT NULL) THEN
               IF (option_lib_image_source_ = 'BasePartOptionValue') THEN
                  base_val_media_obj_exist_ := 1;
               END IF;
               IF (option_lib_text_source_ = 'BasePartOptionValue') THEN
                  base_val_media_text_exist_ := 1;
               END IF;
               IF (option_lib_image_source_ = 'ConfigOptionValue') THEN
                  char_val_media_obj_exist_ := 1;
               END IF;
               IF (option_lib_text_source_ = 'ConfigOptionValue') THEN
                  char_val_media_text_exist_ := 1;
               END IF;
               count_ := 1;
            END IF;

            IF (char_library_id_ IS NOT NULL) THEN
               IF (char_lib_image_source_ = 'BasePartCharacteristic') THEN
                  base_id_media_obj_exist_ := 1;
               END IF;
               IF (char_lib_text_source_ = 'BasePartCharacteristic') THEN
                  base_id_media_text_exist_ := 1;
               END IF;
               IF (char_lib_image_source_ = 'ConfigCharacteristic') THEN
                  char_id_media_obj_exist_ := 1;
               END IF;
               IF (char_lib_text_source_ = 'ConfigCharacteristic') THEN
                  char_id_media_text_exist_ := 1;
               END IF;
               count_ := 1;
            END IF;

            IF (option_library_id_ IS NOT NULL AND char_library_id_ IS NOT NULL) THEN
               count_ := 2;
            END IF;
         END IF;
        

         IF dont_print_ = 0 THEN                             
            IF (do_xml_flag_ = 1) THEN                       
               Xml_Record_Writer_SYS.Start_Element(xml_, xml_element_);
               Xml_Record_Writer_SYS.Add_Element(xml_,'CHARACTERISTIC_PRICE', characteristic_price_);
               Xml_Record_Writer_SYS.Add_Element(xml_,'CHARACTERISTIC_PFLAG', characteristic_pflag_);
               Xml_Record_Writer_SYS.Add_Element(xml_,'CHARACTERISTIC_ID', confman_rec.char_description);
               Xml_Record_Writer_SYS.Add_Element(xml_,'CHARACTERISTIC_VALUE', confman_rec.value_description);
               Xml_Record_Writer_SYS.Add_Element(xml_,'CONFIG_VALUE_TYPE', confman_rec.config_value_type_db);
               IF confman_rec.config_value_type_db = 'PACKAGE' THEN
                  ptr_ := NULL;
                  comp_characteristics_used_   := NULL;
                  attr_:= Config_Package_Contents_API.Get_Package_Contents(CONFIG_PART_CATALOG_API.Get_Config_Family_Id(char_rec_.sales_part_no),confman_rec.characteristic_id,confman_rec.characteristic_value);              
                  WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
                     IF (name_ = 'CONTENT_CHAR_ID') THEN
                        content_char_id_ := value_;
                     ELSIF (name_ = 'CONTENT_OPT_VALUE_ID') THEN
                        content_opt_value_id_ := value_;
                        IF comp_characteristics_used_ IS NOT NULL THEN
                           comp_characteristics_used_ := comp_characteristics_used_ ||', '|| CONFIG_CHAR_LANG_DESC_API.Get_Default_Description(content_char_id_)||':'||NVL(Config_Option_Value_API.Get_Description_For_Language(content_char_id_,content_opt_value_id_),content_opt_value_id_);
                        ELSE
                           comp_characteristics_used_ := CONFIG_CHAR_LANG_DESC_API.Get_Default_Description(content_char_id_)||':'||NVL(Config_Option_Value_API.Get_Description_For_Language(content_char_id_ ,content_opt_value_id_),content_opt_value_id_);
                        END IF;
                     END IF;
                  END LOOP;
               END IF;   
               Xml_Record_Writer_SYS.Add_Element(xml_,'COMP_CHARACTERISTICS_USED', comp_characteristics_used_);

               IF (print_media_items_ = 'TRUE') THEN
                  Xml_Record_Writer_SYS.Start_Element(xml_, 'MEDIA_OBJECTS');
                  round_ := count_;
                  WHILE (round_ > 0) LOOP
                     print_option_ := 'FALSE';
                     print_char_ := 'FALSE';
                     IF (count_ = 1 AND option_library_id_ IS NOT NULL) OR (count_ = 2 AND round_ = 2) THEN
                        library_id_ := option_image_lib_id_;
                        print_option_ := 'TRUE';
                     ELSIF (count_ = 1 AND char_library_id_ IS NOT NULL) OR (count_ = 2 AND round_ = 1) THEN
                        library_id_ := char_image_lib_id_;
                        print_char_ := 'TRUE';
                     END IF;
                     FOR media_object_rec_ IN get_media_object(library_id_) LOOP
                        IF (Media_Library_Item_API.Print_Media_Item(library_id_, media_object_rec_.library_item_id, report_id_, media_print_option_) = 'TRUE') THEN
                           print_image_ := 'FALSE';
                           lang_code_ := NULL;
                           IF (Media_Item_Language_API.Media_Item_Exist(media_object_rec_.item_id, language_code_) = 'FALSE') THEN
                              lang_code_ := '99';
                              print_image_ := 'TRUE';
                           ELSE
                              IF (Media_Item_Language_API.Media_Object_Empty(media_object_rec_.item_id, language_code_) = 'FALSE') THEN
                                 lang_code_ := language_code_;
                                 print_image_ := 'TRUE';
                              END IF;
                           END IF;

                           IF (print_image_ = 'TRUE') THEN
                              Xml_Record_Writer_SYS.Start_Element(xml_, 'MEDIA_OBJECT');
                              Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_LANG_CODE', lang_code_);
                              IF (print_option_ = 'TRUE') THEN
                                 IF (base_val_media_obj_exist_ = 1) THEN
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'BASE_VAL_MEDIA_ID', media_object_rec_.item_id);
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'BASE_VAL_MEDIA_NAME', media_object_rec_.name);
                                 END IF;
                                 IF (char_val_media_obj_exist_ = 1) THEN
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_VAL_MEDIA_ID', media_object_rec_.item_id);
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_VAL_MEDIA_NAME', media_object_rec_.name);
                                 END IF;
                              END IF;
                              IF (print_char_ = 'TRUE') THEN
                                 IF (char_id_media_obj_exist_ = 1) THEN
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_MEDIA_ID', media_object_rec_.item_id);
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_MEDIA_NAME', media_object_rec_.name);
                                 END IF;
                                 IF (base_id_media_obj_exist_ = 1) THEN
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'BASE_MEDIA_ID', media_object_rec_.item_id);
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'BASE_MEDIA_NAME', media_object_rec_.name);
                                 END IF;
                              END IF;
                              IF (base_val_media_obj_exist_ = 1 OR char_val_media_obj_exist_ = 1) THEN
                                 Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_VAL_MEDIA_EXISTS', 'TRUE');
                                 IF (print_first_record_ = 'NOT PRINTED') THEN
                                    print_first_record_ := 'PRINTING';
                                 END IF;
                              ELSIF (base_id_media_obj_exist_ = 1 OR char_id_media_obj_exist_ = 1) THEN
                                 Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_ID_MEDIA_EXISTS', 'TRUE');
                                 IF (print_first_record_ = 'NOT PRINTED') THEN
                                    print_first_record_ := 'PRINTING';
                                 END IF;   
                              END IF;
                              Xml_Record_Writer_SYS.End_Element(xml_, 'MEDIA_OBJECT');
                              END IF;
                           END IF;
                        END LOOP;
                        round_ := round_ - 1;
                     END LOOP;
                     Xml_Record_Writer_SYS.End_Element(xml_, 'MEDIA_OBJECTS');
                     
                     Xml_Record_Writer_SYS.Start_Element(xml_, 'MEDIA_TEXTS');
                     round_ := count_;
                     WHILE (round_ > 0) LOOP
                        print_option_ := 'FALSE';
                        print_char_ := 'FALSE';
                        IF (count_ = 1 AND option_library_id_ IS NOT NULL) OR (count_ = 2 AND round_ = 2) THEN
                           library_id_ := option_text_lib_id_;
                           print_option_ := 'TRUE';
                        ELSIF (count_ = 1 AND char_library_id_ IS NOT NULL) OR (count_ = 2 AND round_ = 1) THEN
                           library_id_ := char_text_lib_id_;
                           print_char_ := 'TRUE';
                        END IF;
                        FOR media_text_rec_ IN get_media_text(library_id_) LOOP
                           IF (Media_Library_Item_API.Print_Media_Item(library_id_, media_text_rec_.library_item_id, report_id_, media_print_option_) = 'TRUE') THEN
                              print_text_ := 'FALSE';
                              IF (Media_Item_Language_API.Media_Item_Exist(media_text_rec_.item_id, language_code_) = 'FALSE') THEN
                                 media_text_var_ := dbms_lob.substr(media_text_rec_.media_text, 32000, 1);
                                 print_text_ := 'TRUE';
                              ELSE
                                 IF (Media_Item_Language_API.Media_Text_Empty(media_text_rec_.item_id, language_code_) = 'FALSE') THEN
                                    media_text_ := Media_Item_Language_API.Get_Media_Text(media_text_rec_.item_id, language_code_);
                                    media_text_var_ := dbms_lob.substr(media_text_, 32000, 1);
                                    print_text_ := 'TRUE';
                                 END IF;
                              END IF;                  
                              IF (print_text_ = 'TRUE') THEN
                                 Xml_Record_Writer_SYS.Start_Element(xml_, 'MEDIA_TEXT');
                                 IF (print_option_ = 'TRUE') THEN
                                    IF (base_val_media_text_exist_ = 1) THEN
                                       Xml_Record_Writer_SYS.Add_Element(xml_, 'BASE_VAL_MEDIA_TEXT', media_text_var_);
                                       Xml_Record_Writer_SYS.Add_Element(xml_, 'BASE_VAL_MEDIA_TEXT_NAME', media_text_rec_.name);
                                    END IF;
                                    IF (char_val_media_text_exist_ = 1) THEN
                                       Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_VAL_MEDIA_TEXT', media_text_var_);
                                       Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_VAL_MEDIA_TEXT_NAME', media_text_rec_.name);
                                    END IF;
                                 END IF;
                                 IF (print_char_ = 'TRUE')  THEN
                                    IF (char_id_media_text_exist_ = 1) THEN
                                       Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_MEDIA_TEXT', media_text_var_);
                                       Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_MEDIA_TEXT_NAME', media_text_rec_.name);
                                    END IF;
                                    IF (base_id_media_text_exist_ = 1) THEN
                                       Xml_Record_Writer_SYS.Add_Element(xml_, 'BASE_MEDIA_TEXT', media_text_var_);
                                       Xml_Record_Writer_SYS.Add_Element(xml_, 'BASE_MEDIA_TEXT_NAME', media_text_rec_.name);
                                    END IF;
                                 END IF;
                                 IF (base_val_media_obj_exist_ = 1 OR char_val_media_obj_exist_ = 1) THEN
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_VAL_MEDIA_TEXT_EXISTS', 'TRUE');
                                    IF (print_first_record_ = 'NOT PRINTED') THEN
                                       print_first_record_ := 'PRINTING';
                                    END IF;
                                 ELSIF (base_id_media_obj_exist_ = 1 OR char_id_media_obj_exist_ = 1) THEN
                                    Xml_Record_Writer_SYS.Add_Element(xml_, 'CHAR_ID_MEDIA_TEXT_EXISTS', 'TRUE');
                                    IF (print_first_record_ = 'NOT PRINTED') THEN
                                       print_first_record_ := 'PRINTING';
                                    END IF;
                                 END IF;
                                 Xml_Record_Writer_SYS.End_Element(xml_, 'MEDIA_TEXT');
                              END IF;
                           END IF;
                        END LOOP;
                        round_ := round_ - 1;
                     END LOOP;
                     Xml_Record_Writer_SYS.End_Element(xml_, 'MEDIA_TEXTS');   
                  END IF;
                  Xml_Record_Writer_SYS.Add_Element(xml_,'PRINT_FIRST_RECORD', print_first_record_);
                  IF (print_first_record_ = 'PRINTING') THEN
                     print_first_record_ := 'ALREADY PRINTED';
                  END IF;
                  Xml_Record_Writer_SYS.Add_Element(xml_,'CHARACTERISTIC_UOM', unit_code_);
                  Xml_Record_Writer_SYS.Add_Element(xml_,'CHARACTERISTIC_QTY', confman_rec.qty_characteristic);
                  Xml_Record_Writer_SYS.End_Element(xml_, xml_element_);
               END IF;   
               IF(do_rs_flag_ = 1) THEN
                  stmt_ := 'BEGIN ' ||
                           '        INSERT INTO ' || rpt_table_name_ || ' (                       ' ||
                           '            result_key, row_no, parent_row_no,      ' ||
                                  char_rec_.c_characteristic_id    || ' , ' ||
                                  char_rec_.c_characteristic_value || ' , ' ||
                                  char_rec_.c_characteristic_uom   || ' , ' ||
                                  char_rec_.c_characteristic_qty   || ' , ' ||
                                  char_rec_.c_characteristic_first || ' , ' ||
                                  char_rec_.c_characteristic_last  || ' , ' ||
                                  char_rec_.c_characteristic_act   || ' , ' ||
                                  char_rec_.c_characteristic_price || ' , ' ||
                                  char_rec_.c_characteristic_pflag || ' , ' ||
                                  char_rec_.c_characteristic_block || ' , ' ||
                                  char_rec_.c_characteristic_sub_block || ' ) ' ||                            
                  '           VALUES (:result_key, :row_no, :parent_row_no_bind,
                                  :confman_rec_char_desc,  :confman_rec_value_desc, :unit_code,
                                  :confman_rec_qty_characteristic,
                                  :characteristic_first, 0,
                                  :characteristic_last + 1,
                                  :characteristic_price, :characteristic_pflag,
                                  :characteristic_block,
                                  :characteristic_sub_block);
                              :row_no := :row_no + 1;
                              :characteristic_first := 0;
                              :characteristic_last := :characteristic_last + 1;
                           END ; ';
               @ApproveDynamicStatement(2013-07-04,MaRalk)
               EXECUTE IMMEDIATE stmt_
                     USING 
                       IN     char_rec_.result_key,
                       IN OUT row_no_,
                       IN     char_rec_.parent_row_no,
                       IN     confman_rec.char_description,    
                       IN     confman_rec.value_description,
                       IN     unit_code_,
                       IN     confman_rec.qty_characteristic, 
                       IN OUT characteristic_first_,
                       IN OUT characteristic_last_,
                       IN     characteristic_price_,
                       IN     characteristic_pflag_ ,
                       IN     characteristic_block_,
                       IN     characteristic_sub_block_; 
               END IF;
            END IF;
         END LOOP;
         
      IF(characteristic_last_ > 0) THEN
         stmt_ := 'BEGIN ' ||
                 '   UPDATE  ' || rpt_table_name_ || '                                                         ' ||
                  '   SET ' || char_rec_.c_characteristic_last || ' = 1                       ' ||
                 '   WHERE result_key = :result_key                                         ' ||
                  '   AND parent_row_no = :parent_row_no_bind                                ' ||
                  '   AND ' || char_rec_.c_characteristic_act || ' = :characteristic_last ;   ' ||
                  'END ; ';
      
         @ApproveDynamicStatement(2013-07-04,MaRalk)
         EXECUTE IMMEDIATE stmt_
               USING
                 IN     characteristic_last_,              
                 IN     char_rec_.result_key,              
                 IN     char_rec_.parent_row_no; 
      END IF;           
END Print_Characteristic___;  

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Print_Characteristic
--   This method controls the printout of characteristics and
--   prices for all order reports
PROCEDURE Print_Characteristic (
   row_no_             IN OUT    NUMBER,
   xml_                IN OUT    CLOB,
   xml_element_        IN        VARCHAR2,
   do_xml_             IN        BOOLEAN,
   do_rs_              IN        BOOLEAN,
   char_rec_           IN        Public_Rec,
   rpt_table_name_     IN        VARCHAR2,
   print_media_items_  IN        VARCHAR2 DEFAULT NULL,
   report_id_          IN        VARCHAR2 DEFAULT NULL,
   media_print_option_ IN        VARCHAR2 DEFAULT NULL )
IS
   print_config_code_         VARCHAR2(30);
   config_display_type_db_    VARCHAR2(20);
   do_xml_flag_               NUMBER;
   do_rs_flag_                NUMBER;

BEGIN

   -- transforming boolean to number values, since dynamic pl cant handle boolean
   IF (do_xml_) THEN
      do_xml_flag_ := 1;
   ELSE
      do_xml_flag_ := 0;  
   END IF;
   IF (do_rs_) THEN
      do_rs_flag_ := 1;
   ELSE
      do_rs_flag_ := 0;
   END IF;

   -- check for configured parts if characteristics and prices for characteristics
   -- should be displayed or not
   -- Retrieve the IID value for printing configuration
   -- values: PRINTWITHOUTPRICE PRINTWITHPRICEALLCHAR PRINTWITHPRICECONTRIBCHAR DONOTPRINT
   print_config_code_ := Shipment_Source_Utility_API.Get_Print_Config_Code
                           (char_rec_.print_control_code, char_rec_.print_char_code, char_rec_.doc_code, char_rec_.source_ref_type_db);

   -- handle configuration
   $IF Component_Cfgchr_SYS.INSTALLED $THEN 
      IF (print_config_code_ != 'DONOTPRINT') THEN
            IF char_rec_.configuration_id IS NOT NULL THEN
               IF char_rec_.reportname = 'Report_Order_Quotation' THEN
                  config_display_type_db_ := 'SALESQUOTATION';
               ELSIF char_rec_.reportname IN ('Report_Proforma_Invoice', 'Report_Collective_Invoice', 'Report_Invoice') THEN
                  config_display_type_db_ := 'CUSTOMERINVOICE';
               ELSE
                  config_display_type_db_ := 'CUSTOMERORDER';
               END IF;

               --  Replaced local cursor with Config_Manager_API.Get_Config_Char_Value. 
               --  Complete re-design of print control logic.

               ---------------------------------------------------------------------------
               -- print_config_code    display_characteristic  result 1    result 2
               --                                              print char  print price
               ---------------------------------------------------------------------------
               -- DONOTPRINT                    (*)              no          no
               ---------------------------------------------------------------------------
               -- PRINTWITHOUTPRICE            'YES'             yes         no
               --                              'NO'              no          no
               ----------------------------------------------------------------------------
               -- PRINTWITHPRICEALLCHAR        'YES'             yes         yes
               --                              'NO'              no          no
               ----------------------------------------------------------------------------
               -- PRINTWITHPRICECONTRIBCHAR    'YES'           (if price not null)
               --                              'NO'              no          no
               ----------------------------------------------------------------------------
               --  (*) is irrelevant

               IF (char_rec_.c_characteristic_id IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_id);
               END IF;
               
               IF (char_rec_.c_characteristic_value IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_value);
               END IF;

               IF (char_rec_.c_characteristic_uom IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_uom);
               END IF;

               IF (char_rec_.c_characteristic_qty IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_qty);
               END IF;

               IF (char_rec_.c_characteristic_first IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_first);
               END IF;

               IF (char_rec_.c_characteristic_last IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_last);
               END IF;

               IF (char_rec_.c_characteristic_act IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_act);
               END IF;

               IF (char_rec_.c_characteristic_price IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_price);
               END IF;

               IF (char_rec_.c_characteristic_pflag IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_pflag);
               END IF;

               IF (char_rec_.c_characteristic_block IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_block);
               END IF;
               
               IF (char_rec_.c_characteristic_sub_block IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Table_Column(rpt_table_name_,char_rec_.c_characteristic_sub_block);
               END IF;      
               Print_Characteristic___ (row_no_, xml_, xml_element_, do_xml_flag_, do_rs_flag_, 
                                        char_rec_, rpt_table_name_, config_display_type_db_, print_config_code_, 
                                        print_media_items_, report_id_, media_print_option_); 
            END IF;
      END IF;      
   $END
END Print_Characteristic;



