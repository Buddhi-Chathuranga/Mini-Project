-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptureCommonUtil
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210731  DiJwlk  SC21R2-1611, Modified Install_Process_And_All_Config(), removed unused parameters.
--  210731          config_data_item_col_width_, config_desc_label_font_size_, config_input_field_font_size_, config_list_font_size_
--  210201  DaZase  SC2020R1-10508, Removed Get_Scandit_App_Key() since its now obsolete.
--  200305  DaZase  SCXTEND-3803, Added lov_search_string_match, lov_search_target, lov_search_case_sensitive to Session_Rec.
--  191210  SWiclk  Bug 151218(SCZ-7901), Added function Get_Lov_Search_Where_Clause() in orde to handle LoV search settings for Where clause.
--  180116  DaZase  STRSC-8677, Changes to support rename/uninstall of data/feedback items as control items and data in subsequent tables. Install_Config_Ctrl_Item changed default values.
--  180116          Changed Rename_Data_Item_All_Config/Rename_Feedbac_Item_All_Config to also do renames in subsequent table and on control item. Similar changes
--  180116          in Uninstall_Data_Item_All_Config/Uninstall_Feedback_All_Config.
--  171212  SWiclk  STRSC-15143, Modified Install_Data_Item_All_Configs() by adding parameter onscreen_keyboard_enabled_db_. 
--  171207  SWiclk  STRSC-14791, Added Get_Scandit_App_Key().
--  171030  SWiclk  STRSC-13218, Modified Install_Process_And_All_Config() by adding sort_list_descending_db_ as a parameter.
--  170912  DaZase  STRSC-8582, Changed Install_Data_Item_All_Configs so it now also support data type GS1.
--  170906  DaZase  STRSC-11610, Changed size of data_item_value, data_item_default, fixed_item_value in Session_Line_Rec and data_item_value in Data_Item_Rec to 4000.
--  161207  DaZase  LIM-9572, Added method Install_Default_Subseq_Config to able to set default subsequent process/configuration for the template configuration for a process.
--  161123  SWiclk  LIM-9836, Added methods Disconn_Detail_Data_All_Config() and Disconn_Detail_From_Data_Item() in order to disconnect feedback items from data items.
--  151027  Erlise  LIM-4348, Modified method Rename_Data_Item_All_Config(). Added parameter default_flag_ in the call to Data_Capt_Conf_Data_Item_API.New_Or_Modify.
--  150826  RuLiLk  Bug 124207, Added new method Get_Leading_Zero_For_Decimals() to add leading 0 for decimal values between 0 and 1 to display in messages.
--  150724  RuLiLk  Bug 121975, Modified method Install_Process_Feedback_Item(), added data_type_ as parameter. Depricated the old method Install_Process_Feedback_Item() with 6 parameters.
--  150724          Modified method Rename_Feedbac_Item_All_Config to set the data_type.
--  150527  DaZase  COB-439, Added lov_search_statement to Session_Rec.
--  150417  BudKlk  Bug 121706, Added a new method Uninstall_Feedback_All_Config() to remove a feedback item defined in the process and all the configurations.   
--  150504  DaZase  Added new parameter config_data_item_order_ on Install_Data_Item_All_Configs. Removed obsolete methods Install_Process_And_Config, 
--  150504          Install_Proc_Config_Data_Item and Install_Process_Config_Detail since they was replaced earlier.
--  150114  DaZase  PRSC-5056, Removed calls in methods Install_Data_Item_All_Configs, Install_Detail_All_Configs, Rename_Data_Item_All_Config, Rename_Detail_Item_All_Config,
--  150114          Rename_Feedbac_Item_All_Config and Uninstall_Data_Item_All_Config that will set the state back to the original state for each configuration.
--  150114          Added Install_Process_And_All_Config(). Changed Install_Data_Item_All_Configs/Install_Detail_All_Configs so they install config 1 if no configs exists.
--  141205  DaZase  PRSC-4409, Added methods Install_Subseq_Config/Install_Subseq_Conf_Data_Item/Install_Config_Ctrl_Item.
--  141009  RiLase  PRSC-1633, Added methods Connect_Feedback_To_Data_Item() and Conn_Detail_Data_Item_All_Conf().
--  140915  RiLase  PRSC-2975, Added handling of default fixed value.
--  140909  DaZase  PRSC-2781, Added parameters enumeration_package_, data_item_value_view_ and data_item_value_pkg_ to Install_Proc_Config_Data_Item/Install_Data_Item_All_Configs 
--  140909          and enumeration_package_ to Install_Process_Feedback_Item.
--  140908  RiLase  PRSC-2497, Updating default values for hide line and use fixed value.
--  140829  SudJlk   Bug 118229, Added new method Uninstall_Data_Item_All_Config to remove data items and their feedback items.
--  140818  DaZase  PRSC-1634, Added loop_end_db_ to Install_Proc_Config_Data_Item/Install_Data_Item_All_Configs AND Rename_Data_Item_All_Config.
--  140815  Erlise  PRSC-1643, Changed a parameter name in Install_Process_And_Config.
--  140812  DaZase  PRSC-1611, Changed so all db parameters in Install_Process_And_Config have _db_ in their name.
--  140805  DaZase  PRSC-1431, Added string_length_ parameter and renamed data_type_ to data_type_db_ in methods Install_Proc_Config_Data_Item and Install_Data_Item_All_Configs. 
--  140805          Also added string_length_ to New_Or_Modify call in Rename_Data_Item_All_Config. 
--  140526  DaZase  PBSC-9885, Bug 115922, Added parameter process_camera_enabled_db_ to Install_Process_And_Config. Added Blob_Ref_Rec/Blob_Ref_Tab.
--  140303  DaZase  Removed config_visible_db_ from Install_Proc_Config_Data_Item and Install_Data_Item_All_Configs since its now obsolete.
--  140219  DaZase  Changed default value of config_use_automatic_value_db_ on Install_Proc_Config_Data_Item/Install_Data_Item_All_Configs from Fnd_Boolean_API.db_true to 'FIXED'.
--  140210  RuLiLk  Bug 115289, Added new methods Rename_Data_Item_In_All_Configs(), Rename_Detail_Item_In_All_Configs()
--  140210          and Rename_Feedback_Item_In_All_Configs(). Added new record type Config_Item_Rec
--  131114  DaZase  Bug 113685, Added config_reset_session_ as a default parameter to Install_Process_And_Config and in the call to Data_Capture_Config_API.New_Or_Modify.
--  131107  RuLilk  Bug 113595, Added Install_Data_Item_All_Configs() and Install_Detail_All_Configs() .
--  120913  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Session_Rec IS RECORD
   (capture_process_id VARCHAR2(50),
    capture_config_id NUMBER,
    session_user_id VARCHAR2(30),
    session_contract VARCHAR2(5),
    previous_capture_session_id NUMBER,
    lov_search_statement VARCHAR2(200),
    lov_search_string_match VARCHAR2(20),
    lov_search_target VARCHAR2(20), 
    lov_search_case_sensitive VARCHAR2(20));

TYPE Session_Line_Rec IS RECORD
   (data_item_id VARCHAR2(50),
    data_item_value VARCHAR2(4000),
    data_item_default VARCHAR2(4000),
    fixed_item_value VARCHAR2(4000),
    use_fixed_value VARCHAR2(20));

TYPE Config_Item_Detail_Rec IS RECORD
   (data_item_detail_id VARCHAR2(50),
    item_type VARCHAR2(20),
    config_item_detail_order NUMBER);

TYPE Config_Item_Detail_Tab IS TABLE OF Config_Item_Detail_Rec
INDEX BY PLS_INTEGER;

TYPE Data_Item_Rec IS RECORD
   (data_item_id VARCHAR2(50),
    data_item_value VARCHAR2(4000));

TYPE Data_Item_Tab IS TABLE OF Data_Item_Rec
INDEX BY PLS_INTEGER;

TYPE Config_Item_Rec IS RECORD 
   (data_item_id             VARCHAR2(50), 
    data_item_detail_id      VARCHAR2(50),
    item_type                VARCHAR2(20),
    config_item_detail_order NUMBER);

TYPE Config_Item_Tab IS TABLE OF Config_Item_Rec
INDEX BY PLS_INTEGER;

TYPE Blob_Ref_Rec IS RECORD
   (session_line_no NUMBER,
    blob_id         NUMBER);

TYPE Blob_Ref_Tab IS TABLE OF Blob_Ref_Rec
INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Install_Config_Ctrl_Item (
   capture_process_id_            IN VARCHAR2,
   config_ctrl_data_item_id_      IN VARCHAR2 DEFAULT 'NOT_CHANGED',
   config_ctrl_feedback_item_id_  IN VARCHAR2 DEFAULT 'NOT_CHANGED' )
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Config_API.Modify_Subseq_Ctrl_Item(capture_process_id_           => capture_process_id_, 
                                                      capture_config_id_            => 1, 
                                                      subseq_ctrl_data_item_id_     => config_ctrl_data_item_id_,
                                                      subseq_ctrl_feedback_item_id_ => config_ctrl_feedback_item_id_);
   $ELSE
      NULL;
   $END

END Install_Config_Ctrl_Item;


PROCEDURE Install_Proc_Config_Data_Item (
   capture_process_id_            IN VARCHAR2,
   data_item_id_                  IN VARCHAR2,
   description_                   IN VARCHAR2,
   data_type_db_                  IN VARCHAR2,
   process_key_db_                IN VARCHAR2,
   uppercase_db_                  IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_true,
   string_length_                 IN NUMBER   DEFAULT 200,
   enumeration_package_           IN VARCHAR2 DEFAULT NULL,
   data_item_value_view_          IN VARCHAR2 DEFAULT NULL,
   data_item_value_pkg_           IN VARCHAR2 DEFAULT NULL,
   config_default_value_          IN VARCHAR2 DEFAULT NULL,   -- if item is an enumeration send database value and not client value here
   config_fixed_value_            IN VARCHAR2 DEFAULT NULL,   -- if item is an enumeration send database value and not client value here
   config_hide_line_db_           IN VARCHAR2 DEFAULT 'NEVER',
   config_loop_start_db_          IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   config_loop_end_db_            IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   config_use_fixed_value_db_     IN VARCHAR2 DEFAULT 'NEVER',
   config_use_automatic_value_db_ IN VARCHAR2 DEFAULT 'FIXED',
   config_list_of_values_db_      IN VARCHAR2 DEFAULT 'OFF',
   config_subseq_data_item_id_    IN VARCHAR2 DEFAULT NULL,
   config_use_subseq_value_db_    IN VARCHAR2 DEFAULT 'OFF',
   process_default_fixed_value_   IN VARCHAR2 DEFAULT NULL,
   process_list_of_val_supported_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   process_fix_val_applic_supp_   IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false )
IS
   tmp_uppercase_db_    VARCHAR2(20);
   tmp_string_length_   NUMBER;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_type_db_ != Data_Capture_Data_Type_API.DB_STRING) THEN
         tmp_uppercase_db_ := Fnd_Boolean_API.db_false;
         tmp_string_length_ := NULL;
      ELSE
         tmp_uppercase_db_ := uppercase_db_;
         tmp_string_length_ := string_length_;
      END IF;
      Data_Capt_Proc_Data_Item_API.New_Or_Modify(capture_process_id_            => capture_process_id_, 
                                                 data_item_id_                  => data_item_id_, 
                                                 description_                   => description_, 
                                                 data_type_db_                  => data_type_db_, 
                                                 process_key_db_                => process_key_db_, 
                                                 uppercase_db_                  => tmp_uppercase_db_,
                                                 string_length_                 => tmp_string_length_,
                                                 enumeration_package_           => enumeration_package_,
                                                 data_item_value_view_          => data_item_value_view_,
                                                 data_item_value_pkg_           => data_item_value_pkg_,
                                                 default_fixed_value_           => process_default_fixed_value_,
                                                 list_of_val_supported_         => process_list_of_val_supported_,
                                                 fix_val_applic_supprtd_        => process_fix_val_applic_supp_);   
      
      Data_Capt_Conf_Data_Item_API.New_Or_Modify(capture_process_id_      => capture_process_id_, 
                                                 capture_config_id_       => 1,
                                                 data_item_id_            => data_item_id_,
                                                 default_value_           => config_default_value_, 
                                                 fixed_value_             => config_fixed_value_, 
                                                 hide_line_db_            => config_hide_line_db_, 
                                                 loop_start_db_           => config_loop_start_db_,
                                                 loop_end_db_             => config_loop_end_db_,
                                                 use_fixed_value_db_      => config_use_fixed_value_db_, 
                                                 use_automatic_value_db_  => config_use_automatic_value_db_,
                                                 list_of_values_db_       => config_list_of_values_db_,
                                                 subsequent_data_item_id_ => config_subseq_data_item_id_,
                                                 use_subsequent_value_db_ => config_use_subseq_value_db_);
   $ELSE
      NULL;  
   $END
END Install_Proc_Config_Data_Item;

-- This method is deprecated.
-- STRING is sent as default data type to avoid deployement errors.
-- Sending STRING data type for numeric/ date fields will recreate the issue reported in bug 121975.
-- Use Install_Process_Feedback_Item method with 7 parameters (which includes data_type_).
@Deprecated
PROCEDURE Install_Process_Feedback_Item (
   capture_process_id_             IN VARCHAR2,
   feedback_item_id_               IN VARCHAR2,
   description_                    IN VARCHAR2,
   enumeration_package_            IN VARCHAR2 DEFAULT NULL,
   feedback_item_value_view_       IN VARCHAR2 DEFAULT NULL,
   feedback_item_value_pkg_        IN VARCHAR2 DEFAULT NULL )
IS
   data_type_   VARCHAR2(20) := 'STRING';
BEGIN
   Install_Process_Feedback_Item(capture_process_id_, 
                                 feedback_item_id_, 
                                 description_,
                                 data_type_,
                                 enumeration_package_,
                                 feedback_item_value_view_,
                                 feedback_item_value_pkg_);
   
END Install_Process_Feedback_Item;

PROCEDURE Install_Process_Feedback_Item (
   capture_process_id_             IN VARCHAR2,
   feedback_item_id_               IN VARCHAR2,
   description_                    IN VARCHAR2,
   data_type_                      IN VARCHAR2,
   enumeration_package_            IN VARCHAR2 DEFAULT NULL,
   feedback_item_value_view_       IN VARCHAR2 DEFAULT NULL,
   feedback_item_value_pkg_        IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capt_Proc_Feedba_Item_API.New_Or_Modify(capture_process_id_, 
                                                   feedback_item_id_, 
                                                   description_,
                                                   data_type_,
                                                   enumeration_package_,
                                                   feedback_item_value_view_,
                                                   feedback_item_value_pkg_);
   $ELSE
      NULL;                                                 
   $END
END Install_Process_Feedback_Item;


PROCEDURE Install_Subseq_Config (
   capture_process_id_            IN VARCHAR2,
   control_item_value_            IN VARCHAR2,    -- Database values only
   subsequent_capture_process_id_ IN VARCHAR2 )                                 
IS
BEGIN
   -- If this method in the future will allow new/updates on configurations that are not configuration 1 
   -- then this method needs to be changed so it does the Set_State/Remove_Uncompleted_Sessions calls 
   -- like in the Install_xxxxx_All_Config methods. 
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      Subseq_Data_Capture_Config_API.New_Or_Modify(capture_process_id_            => capture_process_id_,
                                                   capture_config_id_             => 1,
                                                   control_item_value_            => control_item_value_,
                                                   subsequent_capture_process_id_ => subsequent_capture_process_id_,
                                                   subsequent_capture_config_id_  => 1);

   $ELSE
      NULL;   
   $END
END Install_Subseq_Config;


PROCEDURE Install_Default_Subseq_Process (
   capture_process_id_            IN VARCHAR2,
   subsequent_capture_process_id_ IN VARCHAR2 )                                 
IS
   -- This method is an update/set method, if you need to insert these values (if the subsequent process is installed before this one), they should be 
   -- included as default NULL parameters on Install_Process_And_All_Config instead and added to Data_Capture_Config_API.New_Or_Modify, where they 
   -- should only be set if they are not NULL since if they are NULL the old functionality will set each process/config to its own subsequent process/config. 
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      
      Data_Capture_Config_API.Set_State(capture_process_id_, 1, 'Locked'); 
      Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, 1);
      Data_Capture_Config_API.Modify_Subseq_Process(capture_process_id_            => capture_process_id_, 
                                                    capture_config_id_             => 1, 
                                                    subsequent_capture_process_id_ => subsequent_capture_process_id_,
                                                    subsequent_capture_config_id_  => 1);
   $ELSE
      NULL;   
   $END
END Install_Default_Subseq_Process;


PROCEDURE Install_Subseq_Conf_Data_Item (
   capture_process_id_      IN VARCHAR2,
   control_item_value_      IN VARCHAR2,    -- Database values only
   data_item_id_            IN VARCHAR2,
   subsequent_data_item_id_ IN VARCHAR2,
   use_subsequent_value_db_ IN VARCHAR2 )
IS
BEGIN
   -- If this method in the future will allow new/updates on configurations that are not configuration 1 
   -- then this method needs to be changed so it does the Set_State/Remove_Uncompleted_Sessions calls 
   -- like in the Install_xxxxx_All_Config methods.
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      Subseq_Config_Data_Item_API.New_Or_Modify(capture_process_id_      => capture_process_id_,
                                                capture_config_id_       => 1,
                                                control_item_value_      => control_item_value_,
                                                data_item_id_            => data_item_id_,
                                                subsequent_data_item_id_ => subsequent_data_item_id_,
                                                use_subsequent_value_db_ => use_subsequent_value_db_);

   $ELSE
      NULL;   
   $END
END Install_Subseq_Conf_Data_Item;


PROCEDURE Install_Process_And_All_Config (
   capture_process_id_            IN VARCHAR2,
   description_                   IN VARCHAR2,
   process_package_               IN VARCHAR2,
   process_component_             IN VARCHAR2,
   config_menu_label_             IN VARCHAR2,
   config_proc_compl_action_db_   IN VARCHAR2 DEFAULT 'CREATE_NEW_SESSION',
   config_confirm_execution_db_   IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE,
   config_enable_media_db_        IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   config_valid_for_all_users_db_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE,
   config_reset_session_db_       IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   process_camera_enabled_db_     IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   sort_list_descending_db_       IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   config_tab_          Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Process_API.New_Or_Modify(capture_process_id_, 
                                             description_, 
                                             process_package_,
                                             process_component_,
                                             process_camera_enabled_db_,
                                             sort_list_descending_db_ );

      config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
      IF (config_tab_.COUNT > 0) THEN
         FOR i IN config_tab_.FIRST..config_tab_.LAST  LOOP
            Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
            Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);
            Data_Capture_Config_API.New_Or_Modify(capture_process_id_           => capture_process_id_, 
                                                  capture_config_id_            => config_tab_(i).capture_config_id, 
                                                  menu_label_                   => config_menu_label_, 
                                                  process_completion_action_db_ => config_proc_compl_action_db_, 
                                                  confirm_execution_db_         => config_confirm_execution_db_, 
                                                  enable_media_db_              => config_enable_media_db_, 
                                                  valid_for_all_users_db_       => config_valid_for_all_users_db_,
                                                  reset_session_on_proc_err_db_ => config_reset_session_db_);
         END LOOP;
      ELSE
         Data_Capture_Config_API.New_Or_Modify(capture_process_id_           => capture_process_id_, 
                                               capture_config_id_            => 1, 
                                               menu_label_                   => config_menu_label_, 
                                               process_completion_action_db_ => config_proc_compl_action_db_, 
                                               confirm_execution_db_         => config_confirm_execution_db_, 
                                               enable_media_db_              => config_enable_media_db_, 
                                               valid_for_all_users_db_       => config_valid_for_all_users_db_,
                                               reset_session_on_proc_err_db_ => config_reset_session_db_);
      END IF;

   $ELSE
      NULL;
   $END
END Install_Process_And_All_Config;


--------------------------------------------------------------------
-- Install_Data_Item_All_Configs
--   This will add or modify particular data item into all configurations
--   including configuration 1.   
------------------------------------------------------------------
PROCEDURE Install_Data_Item_All_Configs (
   capture_process_id_            IN VARCHAR2,
   data_item_id_                  IN VARCHAR2,
   description_                   IN VARCHAR2,
   data_type_db_                  IN VARCHAR2,
   process_key_db_                IN VARCHAR2,
   uppercase_db_                  IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_true,
   string_length_                 IN NUMBER   DEFAULT 200,
   enumeration_package_           IN VARCHAR2 DEFAULT NULL,
   data_item_value_view_          IN VARCHAR2 DEFAULT NULL,
   data_item_value_pkg_           IN VARCHAR2 DEFAULT NULL,
   config_default_value_          IN VARCHAR2 DEFAULT NULL,    -- if item is an enumeration send database value and not client value here
   config_fixed_value_            IN VARCHAR2 DEFAULT NULL,    -- if item is an enumeration send database value and not client value here
   config_hide_line_db_           IN VARCHAR2 DEFAULT 'NEVER',
   config_loop_start_db_          IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   config_loop_end_db_            IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   config_use_fixed_value_db_     IN VARCHAR2 DEFAULT 'NEVER',
   config_use_automatic_value_db_ IN VARCHAR2 DEFAULT 'FIXED',
   config_list_of_values_db_      IN VARCHAR2 DEFAULT 'OFF',
   config_subseq_data_item_id_    IN VARCHAR2 DEFAULT NULL,
   config_use_subseq_value_db_    IN VARCHAR2 DEFAULT 'OFF',
   process_default_fixed_value_   IN VARCHAR2 DEFAULT NULL,
   process_list_of_val_supported_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   process_fix_val_applic_supp_   IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   onscreen_keyboard_enabled_db_  IN VARCHAR2 DEFAULT 'OFF',
   config_data_item_order_        IN OUT NUMBER )

IS
   tmp_uppercase_db_    VARCHAR2(20);
   tmp_string_length_   NUMBER;
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   config_tab_          Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      
      IF (config_data_item_order_ IS NULL OR config_data_item_order_ = 0) THEN
         config_data_item_order_ := 1;
      END IF;
      IF (data_type_db_ NOT IN (Data_Capture_Data_Type_API.DB_STRING, Data_Capture_Data_Type_API.DB_GS1)) THEN
         tmp_uppercase_db_ := Fnd_Boolean_API.db_false;
         tmp_string_length_ := NULL;
      ELSE
         tmp_uppercase_db_ := uppercase_db_;
         tmp_string_length_ := string_length_;
      END IF;
      
      Data_Capt_Proc_Data_Item_API.New_Or_Modify(capture_process_id_            => capture_process_id_, 
                                                 data_item_id_                  => data_item_id_, 
                                                 description_                   => description_, 
                                                 data_type_db_                  => data_type_db_, 
                                                 process_key_db_                => process_key_db_, 
                                                 uppercase_db_                  => tmp_uppercase_db_,
                                                 string_length_                 => tmp_string_length_,
                                                 enumeration_package_           => enumeration_package_,
                                                 data_item_value_view_          => data_item_value_view_,
                                                 data_item_value_pkg_           => data_item_value_pkg_,
                                                 default_fixed_value_           => process_default_fixed_value_,
                                                 list_of_val_supported_         => process_list_of_val_supported_,
                                                 fix_val_applic_supprtd_        => process_fix_val_applic_supp_);

      config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
      IF (config_tab_.COUNT > 0) THEN
         FOR i IN config_tab_.FIRST..config_tab_.LAST  LOOP
            Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
            Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);

      
            Data_Capt_Conf_Data_Item_API.New_Or_Modify(capture_process_id_      => capture_process_id_, 
                                                       capture_config_id_       => config_tab_(i).capture_config_id,
                                                       data_item_id_            => data_item_id_,
                                                       default_value_           => config_default_value_, 
                                                       fixed_value_             => config_fixed_value_, 
                                                       hide_line_db_            => config_hide_line_db_, 
                                                       loop_start_db_           => config_loop_start_db_, 
                                                       loop_end_db_             => config_loop_end_db_,
                                                       use_fixed_value_db_      => config_use_fixed_value_db_, 
                                                       use_automatic_value_db_  => config_use_automatic_value_db_,
                                                       list_of_values_db_       => config_list_of_values_db_,
                                                       subsequent_data_item_id_ => config_subseq_data_item_id_,
                                                       use_subsequent_value_db_ => config_use_subseq_value_db_,
                                                       data_item_order_         => config_data_item_order_,
                                                       onscreen_keyboard_enabled_db_ => onscreen_keyboard_enabled_db_);
         END LOOP;
      ELSE
         Data_Capt_Conf_Data_Item_API.New_Or_Modify(capture_process_id_      => capture_process_id_, 
                                                    capture_config_id_       => 1,
                                                    data_item_id_            => data_item_id_,
                                                    default_value_           => config_default_value_, 
                                                    fixed_value_             => config_fixed_value_, 
                                                    hide_line_db_            => config_hide_line_db_, 
                                                    loop_start_db_           => config_loop_start_db_,
                                                    loop_end_db_             => config_loop_end_db_,
                                                    use_fixed_value_db_      => config_use_fixed_value_db_, 
                                                    use_automatic_value_db_  => config_use_automatic_value_db_,
                                                    list_of_values_db_       => config_list_of_values_db_,
                                                    subsequent_data_item_id_ => config_subseq_data_item_id_,
                                                    use_subsequent_value_db_ => config_use_subseq_value_db_,
                                                    data_item_order_         => config_data_item_order_,
                                                    onscreen_keyboard_enabled_db_ => onscreen_keyboard_enabled_db_);
      END IF;
      config_data_item_order_ := config_data_item_order_ + 1;
   $ELSE
      NULL;
   $END
END Install_Data_Item_All_Configs;

--------------------------------------------------------------------
-- Install_Detail_All_Configs
--   This will add or modify particular detail into all configurations
--   including configuration 1.   
------------------------------------------------------------------
PROCEDURE Install_Detail_All_Configs (
   capture_process_id_        IN VARCHAR2,
   capture_process_detail_id_ IN VARCHAR2,
   description_               IN VARCHAR2,
   enabled_db_                IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false )

IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   config_tab_          Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Proces_Detail_API.New_Or_Modify(capture_process_id_, 
                                                   capture_process_detail_id_, 
                                                   description_);
      
      config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
      IF (config_tab_.COUNT > 0) THEN
         FOR i IN config_tab_.FIRST..config_tab_.LAST  LOOP
            Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
            Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);

      
            Data_Capture_Config_Detail_API.New_Or_Modify(capture_process_id_ => capture_process_id_, 
                                                         capture_config_id_  => config_tab_(i).capture_config_id, 
                                                         process_detail_id_  => capture_process_detail_id_, 
                                                         enabled_db_         => enabled_db_);
         END LOOP;
      ELSE
         Data_Capture_Config_Detail_API.New_Or_Modify(capture_process_id_ => capture_process_id_, 
                                                      capture_config_id_  => 1, 
                                                      process_detail_id_  => capture_process_detail_id_, 
                                                      enabled_db_         => enabled_db_);
      END IF;
   $ELSE
      NULL;  
   $END
END Install_Detail_All_Configs;


--------------------------------------------------------------------
-- Rename_Data_Item_All_Config
--   This will Rename a data item defined in the process and 
--   all the configurations.   
-- NOTE: if the old data item have feedback or data item connected as 
--       details on it you must first, disconnect them in the post script
--       with Disconn_Detail_Data_All_Config before you can call this method.
--       Due to config 1 issue that stop us from removing the detail for config 1.
--------------------------------------------------------------------
PROCEDURE Rename_Data_Item_All_Config (
   capture_process_id_   IN VARCHAR2,
   old_data_item_id_     IN VARCHAR2,
   new_data_item_id_     IN VARCHAR2,
   new_data_item_desc_   IN VARCHAR2 DEFAULT NULL)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   proc_rec_          Data_Capt_Proc_Data_Item_API.Public_Rec;
   config_tab_        Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   conf_rec_          Data_Capt_Conf_Data_Item_API.Public_Rec;
   conf_detail_tab_   Data_Capture_Common_Util_API.Config_Item_Tab;
   sdcc_config_tab_   Subseq_Data_Capture_Config_API.Subseq_Conf_Tab;
   scdi_config_tab_   Subseq_Config_Data_Item_API.Subseq_Conf_Data_Item_Tab;
   scdi_conf_rec_tab_ Subseq_Config_Data_Item_API.Subseq_Conf_Data_Item_Tab;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF Data_Capt_Proc_Data_Item_API.Check_Exist(capture_process_id_, old_data_item_id_) = TRUE THEN
      
         proc_rec_ := Data_Capt_Proc_Data_Item_API.Get(capture_process_id_, old_data_item_id_);
      
         Data_Capt_Proc_Data_Item_API.New_Or_Modify(capture_process_id_     => capture_process_id_, 
                                                    data_item_id_           => new_data_item_id_, 
                                                    description_            => NVL(new_data_item_desc_, proc_rec_.description), 
                                                    data_type_db_           => proc_rec_.data_type,
                                                    process_key_db_         => proc_rec_.process_key, 
                                                    uppercase_db_           => proc_rec_.uppercase,
                                                    string_length_          => proc_rec_.string_length,
                                                    enumeration_package_    => proc_rec_.enumeration_package,
                                                    data_item_value_view_   => proc_rec_.data_item_value_view,
                                                    data_item_value_pkg_    => proc_rec_.data_item_value_pkg,
                                                    default_fixed_value_    => proc_rec_.default_fixed_value,
                                                    list_of_val_supported_  => proc_rec_.list_of_val_supported,
                                                    fix_val_applic_supprtd_ => proc_rec_.fix_val_applic_supprtd);
         
         -- Changing any SUBSEQUENT_DATA_ITEM_ID in SUBSEQ_CONFIG_DATA_ITEM_TAB if this process and data item are used as subsequent
         sdcc_config_tab_ := Subseq_Data_Capture_Config_API.Get_All_Subseq_Configurations(subsequent_capture_process_id_ => capture_process_id_);
         -- Getting all records that have this process as a subseq process in Subseq_Data_Capture_Config 
         IF (sdcc_config_tab_.COUNT > 0) THEN
            FOR i IN sdcc_config_tab_.FIRST..sdcc_config_tab_.LAST  LOOP
               -- Getting all records that have above subsequent process and the old data item as a subsequent data item
               scdi_config_tab_ := Subseq_Config_Data_Item_API.Get_All_Subseq_Configurations(capture_process_id_      => sdcc_config_tab_(i).capture_process_id,
                                                                                             capture_config_id_       => sdcc_config_tab_(i).capture_config_id,
                                                                                             control_item_value_      => sdcc_config_tab_(i).control_item_value,
                                                                                             subsequent_data_item_id_ => old_data_item_id_);
               IF (scdi_config_tab_.COUNT > 0) THEN
                  FOR j IN scdi_config_tab_.FIRST..scdi_config_tab_.LAST  LOOP
                     Data_Capture_Config_API.Set_State(scdi_config_tab_(j).capture_process_id, scdi_config_tab_(j).capture_config_id, 'Locked'); 
                     Data_Capture_Session_API.Remove_Uncompleted_Sessions(scdi_config_tab_(j).capture_process_id, scdi_config_tab_(j).capture_config_id);
                     -- Renaming this subsequent data item to the new name/id
                     Subseq_Config_Data_Item_API.New_Or_Modify(capture_process_id_      => scdi_config_tab_(j).capture_process_id,
                                                               capture_config_id_       => scdi_config_tab_(j).capture_config_id,
                                                               control_item_value_      => scdi_config_tab_(j).control_item_value,
                                                               data_item_id_            => scdi_config_tab_(j).data_item_id,
                                                               subsequent_data_item_id_ => new_data_item_id_,
                                                               use_subsequent_value_db_ => scdi_config_tab_(j).use_subsequent_value,
                                                               change_all_configs_      => Fnd_Boolean_API.db_true); -- changing in all configs not just config 1

                  END LOOP;
               END IF;
            END LOOP;
         END IF;

         -- Changes in data capture config data item 
         config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
         IF (config_tab_.COUNT > 0) THEN
            FOR i IN config_tab_.FIRST..config_tab_.LAST  LOOP
               IF (Data_Capt_Conf_Data_Item_API.Check_Exist(capture_process_id_, config_tab_(i).capture_config_id, old_data_item_id_)) THEN
                  Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
                  Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);

                  conf_rec_ := Data_Capt_Conf_Data_Item_API.Get(capture_process_id_, config_tab_(i).capture_config_id, old_data_item_id_);
                  Data_Capt_Conf_Data_Item_API.New_Or_Modify(capture_process_id_      => capture_process_id_, 
                                                             capture_config_id_       => config_tab_(i).capture_config_id,
                                                             data_item_id_            => new_data_item_id_,
                                                             default_value_           => conf_rec_.default_value, 
                                                             fixed_value_             => conf_rec_.fixed_value, 
                                                             hide_line_db_            => conf_rec_.hide_line, 
                                                             loop_start_db_           => conf_rec_.loop_start,
                                                             loop_end_db_             => conf_rec_.loop_end,
                                                             use_fixed_value_db_      => conf_rec_.use_fixed_value, 
                                                             use_automatic_value_db_  => conf_rec_.use_automatic_value,
                                                             list_of_values_db_       => conf_rec_.list_of_values,
                                                             subsequent_data_item_id_ => conf_rec_.subsequent_data_item_id,
                                                             use_subsequent_value_db_ => conf_rec_.use_subsequent_value,
                                                             data_item_order_         => conf_rec_.data_item_order,
                                                             update_flag_             => TRUE);

                  IF (Data_Capture_Config_API.Get_Subseq_Ctrl_Data_Item_Id(capture_process_id_, config_tab_(i).capture_config_id) = old_data_item_id_) THEN
                     -- Renaming the data item if its a subsequent control data item on the Config general tab
                     Data_Capture_Config_API.Modify_Subseq_Ctrl_Item(capture_process_id_           => capture_process_id_, 
                                                                     capture_config_id_            => config_tab_(i).capture_config_id, 
                                                                     subseq_ctrl_data_item_id_     => new_data_item_id_);
                  END IF;

                                                             
                  -- Get all the item details connected to the old data item.
                  conf_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_All_Collection(capture_process_id_, config_tab_(i).capture_config_id, old_data_item_id_, NULL);
                  IF (conf_detail_tab_.COUNT > 0) THEN

                     FOR j IN conf_detail_tab_.FIRST..conf_detail_tab_.LAST  LOOP

                        Data_Capt_Conf_Item_Detail_API.New(capture_process_id_       => capture_process_id_,
                                                           capture_config_id_        => config_tab_(i).capture_config_id,
                                                           data_item_id_             => new_data_item_id_,
                                                           data_item_detail_id_      => conf_detail_tab_(j).data_item_detail_id,
                                                           item_type_db_             => conf_detail_tab_(j).item_type,
                                                           config_item_detail_order_ => conf_detail_tab_(j).config_item_detail_order);
                        
                     END LOOP;
                  END IF;
                  -- Get all the data items that has the renaming old data item as a item detail.
                  conf_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_All_Collection(capture_process_id_, config_tab_(i).capture_config_id, NULL, old_data_item_id_);
                  IF (conf_detail_tab_.COUNT > 0) THEN

                     FOR j IN conf_detail_tab_.FIRST..conf_detail_tab_.LAST  LOOP

                        Data_Capt_Conf_Item_Detail_API.New(capture_process_id_       => capture_process_id_,
                                                           capture_config_id_        => config_tab_(i).capture_config_id,
                                                           data_item_id_             => conf_detail_tab_(j).data_item_id,
                                                           data_item_detail_id_      => new_data_item_id_,
                                                           item_type_db_             => conf_detail_tab_(j).item_type,
                                                           config_item_detail_order_ => conf_detail_tab_(j).config_item_detail_order);

                        Data_Capt_Conf_Item_Detail_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, conf_detail_tab_(j).data_item_id, old_data_item_id_);
                     
                     END LOOP;

                  END IF;

                  -- Replacing records in SUBSEQ_CONFIG_DATA_ITEM adding the new data item and removing the old data item
                  scdi_conf_rec_tab_ := Subseq_Config_Data_Item_API.Get_All_Config_Records(capture_process_id_ => capture_process_id_,
                                                                                           capture_config_id_  => config_tab_(i).capture_config_id,
                                                                                           data_item_id_       => old_data_item_id_);
                  IF (scdi_conf_rec_tab_.COUNT > 0) THEN
                     FOR j IN scdi_conf_rec_tab_.FIRST..scdi_conf_rec_tab_.LAST  LOOP
                        IF (Subseq_Config_Data_Item_API.Check_Exist(capture_process_id_ => capture_process_id_,
                                                                    capture_config_id_  => config_tab_(i).capture_config_id,
                                                                    control_item_value_ => scdi_conf_rec_tab_(j).control_item_value,
                                                                    data_item_id_       => new_data_item_id_) = FALSE) THEN
                           Subseq_Config_Data_Item_API.New(capture_process_id_      => capture_process_id_,
                                                           capture_config_id_       => config_tab_(i).capture_config_id,
                                                           control_item_value_      => scdi_conf_rec_tab_(j).control_item_value,
                                                           data_item_id_            => new_data_item_id_,
                                                           subsequent_data_item_id_ => scdi_conf_rec_tab_(j).subsequent_data_item_id,
                                                           use_subsequent_value_db_ => scdi_conf_rec_tab_(j).use_subsequent_value);

                        END IF;
                        Subseq_Config_Data_Item_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, scdi_conf_rec_tab_(j).control_item_value, old_data_item_id_);
                     END LOOP;

                  END IF;

                  Data_Capt_Conf_Data_Item_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, old_data_item_id_);

               END IF;
            END LOOP;
         END IF;

         Data_Capt_Proc_Data_Item_API.Remove(capture_process_id_, old_data_item_id_);
      END IF;
   $ELSE
      NULL;
   $END
END Rename_Data_Item_All_Config;

--------------------------------------------------------------------
-- Rename_Detail_Item_All_Config
--   This will Rename a detail item defined in the process and 
--   all the configurations.   
--------------------------------------------------------------------
PROCEDURE Rename_Detail_Item_All_Config (
   capture_process_id_   IN VARCHAR2,
   old_detail_item_id_   IN VARCHAR2,
   new_detail_item_id_   IN VARCHAR2,
   new_data_item_desc_   IN VARCHAR2 DEFAULT NULL)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   config_tab_    Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   description_   DATA_CAPTURE_PROCES_DETAIL_TAB.description%TYPE;
   enabled_db_    VARCHAR2(20);
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (Data_Capture_Proces_Detail_API.Check_Exist(capture_process_id_, old_detail_item_id_) = TRUE )THEN
         IF new_data_item_desc_ IS NULL THEN
            description_ := Data_Capture_Proces_Detail_API.Get_Description(capture_process_id_, old_detail_item_id_); 
         ELSE
            description_ := new_data_item_desc_;
         END IF;
         
         Data_Capture_Proces_Detail_API.New_Or_Modify(capture_process_id_        => capture_process_id_, 
                                                      capture_process_detail_id_ => new_detail_item_id_, 
                                                      description_               => description_);

         Data_Capture_Proces_Detail_API.Remove(capture_process_id_, old_detail_item_id_);
         config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
   
         IF (config_tab_.COUNT > 0) THEN
            FOR i IN config_tab_.FIRST..config_tab_.LAST LOOP
               IF Data_Capture_Config_Detail_API.Check_Exist(capture_process_id_, config_tab_(i).capture_config_id, old_detail_item_id_) THEN
            
                  Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
                  Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);

                  enabled_db_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_, config_tab_(i).capture_config_id, old_detail_item_id_);
                  Data_Capture_Config_Detail_API.New_Or_Modify(capture_process_id_     => capture_process_id_, 
                                                               capture_config_id_      => config_tab_(i).capture_config_id,
                                                               process_detail_id_      => new_detail_item_id_,
                                                               enabled_db_             => enabled_db_);
                  Data_Capture_Config_Detail_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, old_detail_item_id_);
               END IF;
            END LOOP;
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Rename_Detail_Item_All_Config;

--------------------------------------------------------------------
-- Rename_Feedbac_Item_All_Config
--   This will Rename a feedback items defined in the process and 
--   all the configurations.   
--------------------------------------------------------------------
PROCEDURE Rename_Feedbac_Item_All_Config (
   capture_process_id_     IN VARCHAR2,
   old_feedback_item_id_   IN VARCHAR2,
   new_feedback_item_id_   IN VARCHAR2,
   new_data_item_desc_     IN VARCHAR2 DEFAULT NULL)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   description_       VARCHAR2(200);
   config_tab_        Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   conf_detail_tab_   Data_Capture_Common_Util_API.Config_Item_Tab;
   proc_rec_          Data_Capt_Proc_Feedba_Item_API.Public_Rec;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   IF (Data_Capt_Proc_Feedba_Item_API.Check_Exist(capture_process_id_, old_feedback_item_id_) = TRUE) THEN
      proc_rec_ := Data_Capt_Proc_Feedba_Item_API.Get(capture_process_id_, old_feedback_item_id_); 

      IF new_data_item_desc_ IS NULL THEN
         description_ := proc_rec_.description;
      ELSE
         description_ := new_data_item_desc_;
      END IF;
      
      Data_Capt_Proc_Feedba_Item_API.New_Or_Modify(capture_process_id_       => capture_process_id_, 
                                                   feedback_item_id_         => new_feedback_item_id_, 
                                                   description_              => description_,
                                                   data_type_                => proc_rec_.data_type,
                                                   enumeration_package_      => Data_Capt_Proc_Feedba_Item_API.Get_Enumeration_Package(capture_process_id_, old_feedback_item_id_),
                                                   feedback_item_value_view_ => Data_Capt_Proc_Feedba_Item_API.Get_Feedback_Item_Value_View(capture_process_id_, old_feedback_item_id_),
                                                   feedback_item_value_pkg_  => Data_Capt_Proc_Feedba_Item_API.Get_Feedback_Item_Value_Pkg(capture_process_id_, old_feedback_item_id_));


      config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
      IF (config_tab_.COUNT > 0) THEN
         FOR i IN config_tab_.FIRST..config_tab_.LAST  LOOP


            IF (Data_Capture_Config_API.Get_Subseq_Ctrl_Feedba_Item_Id(capture_process_id_, config_tab_(i).capture_config_id) = old_feedback_item_id_) THEN
               -- Renaming the feedback item if its a subsequent control feedback item on the Config general tab
               Data_Capture_Config_API.Modify_Subseq_Ctrl_Item(capture_process_id_           => capture_process_id_, 
                                                               capture_config_id_            => config_tab_(i).capture_config_id, 
                                                               subseq_ctrl_feedback_item_id_ => new_feedback_item_id_);
            END IF;

            -- Get all the data items that has the renaming feedback item.
            conf_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_ALL_Collection(capture_process_id_, config_tab_(i).capture_config_id, NULL, old_feedback_item_id_);
            IF (conf_detail_tab_.COUNT > 0) THEN
               FOR j IN conf_detail_tab_.FIRST..conf_detail_tab_.LAST  LOOP
            
                  Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
                  Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);
                  Data_Capt_Conf_Item_Detail_API.New(capture_process_id_       => capture_process_id_,
                                                     capture_config_id_        => config_tab_(i).capture_config_id,
                                                     data_item_id_             => conf_detail_tab_(j).data_item_id,
                                                     data_item_detail_id_      => new_feedback_item_id_,
                                                     item_type_db_             => conf_detail_tab_(j).item_type,
                                                     config_item_detail_order_ => conf_detail_tab_(j).config_item_detail_order);
                  Data_Capt_Conf_Item_Detail_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, conf_detail_tab_(j).data_item_id, old_feedback_item_id_);
            
               END LOOP;
             END IF;
         END LOOP;
      END IF;
      
      Data_Capt_Proc_Feedba_Item_API.Remove(capture_process_id_, old_feedback_item_id_);
   END IF;
   $ELSE
   NULL;
   $END
END Rename_Feedbac_Item_All_Config;

-- Connect a data item detail to a specific configuration
PROCEDURE Connect_Detail_To_Data_Item (
   capture_process_id_            IN VARCHAR2,
   capture_config_id_             IN NUMBER,
   data_item_id_                  IN VARCHAR2,
   data_item_detail_id_           IN VARCHAR2,
   item_type_db_                  IN VARCHAR2)
IS
   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capt_Conf_Item_Detail_API.New_Or_Modify(capture_process_id_, capture_config_id_, data_item_id_, data_item_detail_id_, item_type_db_);
   $ELSE
      NULL;
   $END
END Connect_Detail_To_Data_Item;

-- Used to connect data item details to the base configuration 1
PROCEDURE Connect_Detail_To_Data_Item (
   capture_process_id_            IN VARCHAR2,
   data_item_id_                  IN VARCHAR2,
   data_item_detail_id_           IN VARCHAR2,
   item_type_db_                  IN VARCHAR2)
IS
   
BEGIN
   Connect_Detail_To_Data_Item(capture_process_id_, 1, data_item_id_, data_item_detail_id_, item_type_db_);
END Connect_Detail_To_Data_Item;

-- Used to connect a data item detail (feedback/data) to all configurations of a specific process.
PROCEDURE Conn_Detail_Data_Item_All_Conf (
   capture_process_id_            IN VARCHAR2,
   data_item_id_                  IN VARCHAR2,
   data_item_detail_id_           IN VARCHAR2,
   item_type_db_                  IN VARCHAR2)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      config_tab_        Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
      IF (config_tab_.COUNT > 0) THEN
         FOR i IN config_tab_.FIRST..config_tab_.LAST LOOP
            Connect_Detail_To_Data_Item(capture_process_id_   => capture_process_id_,
                                        capture_config_id_    => config_tab_(i).capture_config_id,
                                        data_item_id_         => data_item_id_,
                                        data_item_detail_id_  => data_item_detail_id_,
                                        item_type_db_         => item_type_db_);
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Conn_Detail_Data_Item_All_Conf;

-- Disconnect a data item detail (feedback/data) from data item in a specific configuration
PROCEDURE Disconn_Detail_From_Data_Item (
   capture_process_id_            IN VARCHAR2,
   capture_config_id_             IN NUMBER,
   data_item_id_                  IN VARCHAR2,
   data_item_detail_id_           IN VARCHAR2)
IS
   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capt_Conf_Item_Detail_API.Remove(capture_process_id_, capture_config_id_, data_item_id_, data_item_detail_id_);
   $ELSE
      NULL;
   $END
END Disconn_Detail_From_Data_Item;

-- Used to disconnect a data item detail (feedback/data) from the connected data item in all configurations of a specific process.
PROCEDURE Disconn_Detail_Data_All_Config (
   capture_process_id_            IN VARCHAR2,
   data_item_id_                  IN VARCHAR2,
   data_item_detail_id_           IN VARCHAR2)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      config_tab_        Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
      IF (config_tab_.COUNT > 0) THEN
         FOR i IN config_tab_.FIRST..config_tab_.LAST LOOP
            Disconn_Detail_From_Data_Item(capture_process_id_   => capture_process_id_,
                                          capture_config_id_    => config_tab_(i).capture_config_id,
                                          data_item_id_         => data_item_id_,
                                          data_item_detail_id_  => data_item_detail_id_);
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Disconn_Detail_Data_All_Config;

------------------------------------------------------------------------------------
-- Uninstall_Data_Item_All_Config
--   This will remove a data item defined in the process and all the configurations.    
------------------------------------------------------------------------------------
PROCEDURE Uninstall_Data_Item_All_Config(
   capture_process_id_  IN VARCHAR2,
   data_item_id_        IN VARCHAR2)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   config_tab_        Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   conf_detail_tab_   Data_Capture_Common_Util_API.Config_Item_Tab;
   sdcc_config_tab_   Subseq_Data_Capture_Config_API.Subseq_Conf_Tab;
   scdi_config_tab_   Subseq_Config_Data_Item_API.Subseq_Conf_Data_Item_Tab;
   scdi_conf_rec_tab_ Subseq_Config_Data_Item_API.Subseq_Conf_Data_Item_Tab;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Check if the data item exists for the process.
      IF (Data_Capt_Proc_Data_Item_API.Check_Exist(capture_process_id_, data_item_id_)) THEN

         -- Removing any SUBSEQUENT_DATA_ITEM_ID in SUBSEQ_CONFIG_DATA_ITEM_TAB if this process and data item are used as subsequent
         sdcc_config_tab_ := Subseq_Data_Capture_Config_API.Get_All_Subseq_Configurations(subsequent_capture_process_id_ => capture_process_id_);
         -- Getting all records that have this process as a subseq process in Subseq_Data_Capture_Config 
         IF (sdcc_config_tab_.COUNT > 0) THEN
            FOR i IN sdcc_config_tab_.FIRST..sdcc_config_tab_.LAST  LOOP
               -- Getting all records that have above subsequent process and the data item as a subsequent data item
               scdi_config_tab_ := Subseq_Config_Data_Item_API.Get_All_Subseq_Configurations(capture_process_id_      => sdcc_config_tab_(i).capture_process_id,
                                                                                             capture_config_id_       => sdcc_config_tab_(i).capture_config_id,
                                                                                             control_item_value_      => sdcc_config_tab_(i).control_item_value,
                                                                                             subsequent_data_item_id_ => data_item_id_);
               IF (scdi_config_tab_.COUNT > 0) THEN
                  FOR j IN scdi_config_tab_.FIRST..scdi_config_tab_.LAST  LOOP
                     Data_Capture_Config_API.Set_State(scdi_config_tab_(j).capture_process_id, scdi_config_tab_(j).capture_config_id, 'Locked'); 
                     Data_Capture_Session_API.Remove_Uncompleted_Sessions(scdi_config_tab_(j).capture_process_id, scdi_config_tab_(j).capture_config_id);
                     -- Removing this subsequent data item
                     Subseq_Config_Data_Item_API.Remove(capture_process_id_ => scdi_config_tab_(j).capture_process_id,
                                                        capture_config_id_  => scdi_config_tab_(j).capture_config_id,
                                                        control_item_value_ => scdi_config_tab_(j).control_item_value,
                                                        data_item_id_       => scdi_config_tab_(j).data_item_id);

                  END LOOP;
               END IF;
            END LOOP;
         END IF;

         -- Removing data item from all configurations
         config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
         IF (config_tab_.COUNT > 0) THEN
            
            FOR i IN config_tab_.FIRST..config_tab_.LAST  LOOP
               
               IF (Data_Capt_Conf_Data_Item_API.Check_Exist(capture_process_id_, config_tab_(i).capture_config_id, data_item_id_)) THEN
                  Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
                  Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);
                  -- Fetch all the item details connected to the data item.
                  conf_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_All_Collection(capture_process_id_, config_tab_(i).capture_config_id, data_item_id_, NULL);
                  
                  IF (conf_detail_tab_.COUNT > 0) THEN
                     FOR j IN conf_detail_tab_.FIRST..conf_detail_tab_.LAST  LOOP
                        -- Remove all the item details connected to the data item
                        Data_Capt_Conf_Item_Detail_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, conf_detail_tab_(j).data_item_id, conf_detail_tab_(j).data_item_detail_id);
                     END LOOP;
                  END IF;
   
                  -- Fetch all the data items that has the data item being removed as a item detail.
                  conf_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_All_Collection(capture_process_id_, config_tab_(i).capture_config_id, NULL, data_item_id_);
                  IF (conf_detail_tab_.COUNT > 0) THEN
                     FOR j IN conf_detail_tab_.FIRST..conf_detail_tab_.LAST  LOOP
                        Data_Capt_Conf_Item_Detail_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, conf_detail_tab_(j).data_item_id, data_item_id_);                    
                     END LOOP;
                  END IF;

                  IF (Data_Capture_Config_API.Get_Subseq_Ctrl_Data_Item_Id(capture_process_id_, config_tab_(i).capture_config_id) = data_item_id_) THEN
                     -- Setting subsequent control data item to NULL if it this data item 
                     Data_Capture_Config_API.Modify_Subseq_Ctrl_Item(capture_process_id_           => capture_process_id_, 
                                                                     capture_config_id_            => config_tab_(i).capture_config_id, 
                                                                     subseq_ctrl_data_item_id_     => NULL);
                     -- We are not removing data from the 2 subsequent tables here. Maybe we should? but that data is more connected to subsequent control item and its value and not directly connected to the data item 
                  END IF;

                  -- Removing records in SUBSEQ_CONFIG_DATA_ITEM for this data item (this time when its a data item, the earlier remove was when its was subsequent data item).
                  scdi_conf_rec_tab_ := Subseq_Config_Data_Item_API.Get_All_Config_Records(capture_process_id_ => capture_process_id_,
                                                                                           capture_config_id_  => config_tab_(i).capture_config_id,
                                                                                           data_item_id_       => data_item_id_);
                  IF (scdi_conf_rec_tab_.COUNT > 0) THEN
                     FOR j IN scdi_conf_rec_tab_.FIRST..scdi_conf_rec_tab_.LAST  LOOP
                        Subseq_Config_Data_Item_API.Remove(capture_process_id_ => capture_process_id_, 
                                                           capture_config_id_  => config_tab_(i).capture_config_id, 
                                                           control_item_value_ => scdi_conf_rec_tab_(j).control_item_value, 
                                                           data_item_id_       => data_item_id_);
                     END LOOP;

                  END IF;

                  Data_Capt_Conf_Data_Item_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, data_item_id_);
               END IF;
   
            END LOOP;
         END IF;

         -- Removing the Process data item
         Data_Capt_Proc_Data_Item_API.Remove(capture_process_id_, data_item_id_);
      END IF;
   $ELSE
      NULL;
   $END
END Uninstall_Data_Item_All_Config;


--------------------------------------------------------------------
-- Uninstall_Feedback_All_Config
--   This will Remove a feedback item defined in the process and 
--   all the configurations.   
--------------------------------------------------------------------
PROCEDURE Uninstall_Feedback_All_Config(
   capture_process_id_   IN VARCHAR2,
   feedback_item_id_     IN VARCHAR2)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   config_tab_        Data_Capture_Config_API.Data_Capt_Key_State_Tab;
   conf_detail_tab_   Data_Capture_Common_Util_API.Config_Item_Tab;
   $END
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   IF (Data_Capt_Proc_Feedba_Item_API.Check_Exist(capture_process_id_, feedback_item_id_) = TRUE) THEN

      config_tab_ := Data_Capture_Config_API.Get_All_Configurations(capture_process_id_);
      IF (config_tab_.COUNT > 0) THEN
         FOR i IN config_tab_.FIRST..config_tab_.LAST  LOOP

            -- Get all the data items that has the removing feedback item.
            conf_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_ALL_Collection(capture_process_id_, config_tab_(i).capture_config_id, NULL, feedback_item_id_);
            IF (conf_detail_tab_.COUNT > 0) THEN
               FOR j IN conf_detail_tab_.FIRST..conf_detail_tab_.LAST  LOOP

                  Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
                  Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);

                  Data_Capt_Conf_Item_Detail_API.Remove(capture_process_id_, config_tab_(i).capture_config_id, conf_detail_tab_(j).data_item_id, feedback_item_id_);

               END LOOP;

               Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, config_tab_(i).rowstate);
            END IF;

            IF (Data_Capture_Config_API.Get_Subseq_Ctrl_Feedba_Item_Id(capture_process_id_, config_tab_(i).capture_config_id) = feedback_item_id_) THEN

               Data_Capture_Config_API.Set_State(capture_process_id_, config_tab_(i).capture_config_id, 'Locked'); 
               Data_Capture_Session_API.Remove_Uncompleted_Sessions(capture_process_id_, config_tab_(i).capture_config_id);
               -- Setting subsequent control feedback item to NULL if it this feedback item
               Data_Capture_Config_API.Modify_Subseq_Ctrl_Item(capture_process_id_           => capture_process_id_, 
                                                               capture_config_id_            => config_tab_(i).capture_config_id, 
                                                               subseq_ctrl_feedback_item_id_ => NULL);
               -- We are not removing data from the 2 subsequent tables here. Maybe we should? but that data is more connected to subsequent control item and its value and not directly connected to the feedback item 
            END IF;
         END LOOP;

         -- Remove feedback item from process
         Data_Capt_Proc_Feedba_Item_API.Remove(capture_process_id_, feedback_item_id_);
      END IF;
   END IF;
   $ELSE
      NULL;
   $END
END Uninstall_Feedback_All_Config;

--------------------------------------------------------------------
-- Get_Leading_Zero_For_Decimals
--   Standard oracle decimal values between 0 and 1, does not have a leading zero (Ex: '.1').
--   When these numbers are displayed in error message, user get mislead.
--   This function will append 0 to decimal value between 0 and 1.
--------------------------------------------------------------------
FUNCTION Get_Leading_Zero_For_Decimals(decimal_number_ NUMBER) RETURN VARCHAR2
IS
   str_value_ VARCHAR2(2000);
BEGIN
   str_value_ := TO_CHAR(decimal_number_);
   IF(decimal_number_ < 1) AND (decimal_number_ > 0) THEN
      str_value_ := '0' || TRIM(str_value_);
   END IF;
   RETURN str_value_;
END Get_Leading_Zero_For_Decimals;


FUNCTION Get_Lov_Search_Where_Clause(
   column_name_               IN VARCHAR2,
   lov_search_statement_      IN VARCHAR2,
   lov_search_string_match_   IN VARCHAR2,
   lov_search_target_         IN VARCHAR2,
   lov_search_case_sensitive_ IN VARCHAR2) RETURN VARCHAR2
IS
   local_lov_search_statement_ VARCHAR2(1000);
   lov_search_stmt_            VARCHAR2(1000);   
   BEGIN
      $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF ((lov_search_statement_ IS NOT NULL) AND (lov_search_target_ = Lov_Search_Target_API.DB_ID)) THEN         
         IF (lov_search_string_match_ = Lov_Search_String_Match_API.DB_BEGINS_WITH) THEN
            local_lov_search_statement_ := lov_search_statement_ ||'%';
         ELSIF (lov_search_string_match_ = Lov_Search_String_Match_API.DB_CONTAINS) THEN
            local_lov_search_statement_ := '%' || lov_search_statement_ ||'%';
         ELSIF (lov_search_string_match_ = Lov_Search_String_Match_API.DB_ENDS_WITH) THEN
            local_lov_search_statement_ := '%' || lov_search_statement_;
         ELSE
            -- DB_EQUALS
            local_lov_search_statement_ := lov_search_statement_;   
         END IF;
         
         IF (lov_search_case_sensitive_ = Fnd_Boolean_API.DB_TRUE) THEN
            lov_search_stmt_ := column_name_ || ' LIKE ''' || local_lov_search_statement_ || '''';
         ELSE
            local_lov_search_statement_ := UPPER(local_lov_search_statement_);
            lov_search_stmt_ := 'UPPER(' || column_name_ || ') LIKE ''' || local_lov_search_statement_||'''';          
         END IF;                 
      END IF;      
      $END
      RETURN lov_search_stmt_;
   END Get_Lov_Search_Where_Clause;
