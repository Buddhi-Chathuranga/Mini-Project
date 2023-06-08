-----------------------------------------------------------------------------
--
--  Logical unit: HistoryLogUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990702  RaKu    Created.
--  990720  RaKu    Changed translation logic in Cleanup_Message__.
--                  Removed exception handling in Cleanup__.
--  020626  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__
IS
   message_     VARCHAR2(2000);

   CURSOR table_to_clear IS
      SELECT table_name, days_to_keep
      FROM   HISTORY_SETTING_TAB
      WHERE  activate_cleanup = 'TRUE';
BEGIN
   FOR next_ IN table_to_clear LOOP
      message_ := Message_SYS.Construct('CLEANUP_HISTORY_LOG');
      Message_SYS.Add_Attribute(message_, 'TABLE_NAME', next_.table_name);
      Message_SYS.Add_Attribute(message_, 'DAYS_TO_KEEP', next_.days_to_keep);
      History_Log_API.Remove_Older_Than__(message_);
      @ApproveTransactionStatement(2013-10-30,haarse)
      COMMIT;
   END LOOP;
END Cleanup__;


PROCEDURE Cleanup_Message__ (
   message_ IN VARCHAR2 )
IS
   description_ VARCHAR2(200);
   value_       VARCHAR2(200);
   null_        VARCHAR2(200) := NULL;
BEGIN
   value_ := Message_SYS.Find_Attribute(message_, 'MODULE', null_);
   IF (value_ IS NOT NULL) THEN
      description_ := Language_SYS.Translate_Constant(lu_name_, 'CLEAN_HIST_LOG_MOD: Cleanup history log for module :P1', NULL, value_);
   ELSE
      value_ := Message_SYS.Find_Attribute(message_, 'LU_NAME', null_);
      IF (value_ IS NOT NULL) THEN
         description_ := Language_SYS.Translate_Constant(lu_name_, 'CLEAN_HIST_LOG_LU: Cleanup history log for logical unit :P1', NULL, value_);
      ELSE
         value_ := Message_SYS.Find_Attribute(message_, 'TABLE_NAME', null_);
         IF (value_ IS NULL) THEN
            Error_SYS.Appl_General(lu_name_, 'REQUIRED_PARAMS: Missing required parameters for message');
         END IF;
         description_ := Language_SYS.Translate_Constant(lu_name_, 'CLEAN_HIST_LOG_TAB: Cleanup history log for table :P1', NULL, value_);
      END IF;
   END IF;

   Transaction_SYS.Deferred_Call('History_Log_API.Remove_Older_Than__', message_, description_);
END Cleanup_Message__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Key_Ref_From_Objkey (
   lu_name_ IN VARCHAR2,
   objkey_  IN VARCHAR2) RETURN VARCHAR2
IS
   key_val_ VARCHAR2(32000);
BEGIN
   key_val_ := Client_SYS.Get_Key_Reference_From_Objkey(lu_name_, objkey_);
   RETURN key_val_;
END Get_Key_Ref_From_Objkey;

-- Note: 
-- Method Get_Key_Ref_From_Objkey_AT should be only used
-- to avoid mutating error in a DELETE operation
--
@UncheckedAccess
FUNCTION Get_Key_Ref_From_Objkey_AT (
   lu_name_ IN VARCHAR2,
   objkey_  IN VARCHAR2) RETURN VARCHAR2
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   RETURN Get_Key_Ref_From_Objkey(lu_name_, objkey_);
END Get_Key_Ref_From_Objkey_AT;

PROCEDURE Handle_Lu_Modification (
   old_lu_name_           IN VARCHAR2,
   new_lu_name_           IN VARCHAR2,
   old_table_name_        IN VARCHAR2,
   new_table_name_        IN VARCHAR2,   
   module_name_           IN VARCHAR2,
   in_regenerate_key_ref_ IN BOOLEAN  DEFAULT TRUE,
   key_ref_map_           IN VARCHAR2 DEFAULT NULL
)
IS
   to_lu_name_              VARCHAR2(100);
   from_lu_name_            VARCHAR2(100);
   cf_old_tbl_name_         VARCHAR2(100);
   cf_new_tbl_name_         VARCHAR2(100);
   to_table_name_           VARCHAR2(100);
   upd_type_                VARCHAR2(100);
   current_key_ref_list_    Utility_SYS.STRING_TABLE;
   key_rename_count_        NUMBER;
   regenerate_key_ref_      BOOLEAN;
   key_ref_new_             VARCHAR2(32000);
   key_val_new_             VARCHAR2(32000); 
   key_ref_old_             VARCHAR2(32000);
   key_ref_old_modified_    VARCHAR2(32000);
   key_change_list_tab_     Utility_SYS.STRING_TABLE;
   key_change_tab_          Utility_SYS.STRING_TABLE;
   key_count_               NUMBER;
   debug_                   CONSTANT BOOLEAN := FALSE;
   cft_available_           BOOLEAN := FALSE;
   
   TYPE Map_Entry IS RECORD (OLD VARCHAR2(128), NEW VARCHAR2(128));
   TYPE Map_Entry_Tab IS TABLE OF Map_Entry INDEX BY PLS_INTEGER;
   key_rename_map_entries_ Map_Entry_Tab;
   
   CURSOR get_entries IS
      SELECT DISTINCT keys
      FROM   history_log_tab
      WHERE  lu_name = old_lu_name_;

   PROCEDURE Trace___ (
      text_ IN VARCHAR2)
   IS
   BEGIN
      IF debug_ THEN
         Log_SYS.App_Trace(Log_SYS.debug_, text_);
      END IF;
   END;
   
   FUNCTION Is_Table_Available___ (
      table_ IN VARCHAR2)  RETURN BOOLEAN
   IS
   BEGIN
      RETURN Database_SYS.Table_Exist(table_);
   END;
   
   PROCEDURE Remove_Old_HistoryLogTrgs___ (
      old_table_name_ IN VARCHAR2)
   IS
      tab_short_name_          VARCHAR2(50);
   BEGIN
      tab_short_name_ := Get_Tab_Short_Name(old_table_name_);
      Database_SYS.Remove_Trigger(tab_short_name_ ||'_I');
      Database_SYS.Remove_Trigger(tab_short_name_ ||'_U');
      Database_SYS.Remove_Trigger(tab_short_name_ ||'1_U');
      Database_SYS.Remove_Trigger(tab_short_name_ ||'2_U');
      Database_SYS.Remove_Trigger(tab_short_name_ ||'3_U');
      Database_SYS.Remove_Trigger(tab_short_name_ ||'4_U');
      Database_SYS.Remove_Trigger(tab_short_name_ ||'_D');
   END;
BEGIN
   to_lu_name_         := NVL(new_lu_name_, old_lu_name_);
   from_lu_name_       := old_lu_name_;
   regenerate_key_ref_ := in_regenerate_key_ref_;
   to_table_name_      := NVL(new_table_name_, old_table_name_);
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      cf_old_tbl_name_ := Custom_Fields_API.Generate_Table_Name__(old_lu_name_);
      cf_new_tbl_name_ := Custom_Fields_API.Generate_Table_Name__(new_lu_name_);
      --Expecting custom fields related things already transformed.
      cft_available_ := Is_Table_Available___(cf_new_tbl_name_);
   $END
    
   Utility_SYS.Tokenize (key_ref_map_, '^', key_change_list_tab_, key_rename_count_); 
   FOR counter_ IN 1..key_rename_count_ LOOP
      Utility_SYS.Tokenize (key_change_list_tab_ (counter_), '=', key_change_tab_, key_count_);
      IF (key_change_tab_(1) <> key_change_tab_(2)) THEN
         key_rename_map_entries_(NVL(key_rename_map_entries_.LAST,0)+1).OLD := key_change_tab_ (1);
         key_rename_map_entries_(key_rename_map_entries_.LAST).NEW := key_change_tab_ (2);
         
         regenerate_key_ref_ := TRUE;
      END IF;
   END LOOP;
   key_rename_count_ := NVL(key_rename_map_entries_.LAST, 0);
   
   IF old_lu_name_ <> new_lu_name_ AND regenerate_key_ref_ THEN
      upd_type_ := 'LU_AND_KEY_REF';
   ELSIF old_lu_name_ <> new_lu_name_ THEN
      upd_type_ := 'LU_ONLY';
   ELSIF regenerate_key_ref_ THEN
      upd_type_ := 'KEY_REF_ONLY';
   ELSE
      Error_SYS.Appl_General(History_Log_Util_API.lu_name_, 'ILLEGAL_HANDL_LU_MOD: Incorrect usage of method.');     
   END IF;
  
   BEGIN 
      Trace___('Starting History log config migration for from '||from_lu_name_|| ' to ' || to_lu_name_);
      -- Incase Lu_name is changed; But, KEY_REF is identical
      IF upd_type_ = 'LU_ONLY' THEN
               
         UPDATE HISTORY_LOG_TAB
         SET lu_name = to_lu_name_,
             table_name = (CASE
                              WHEN table_name = cf_old_tbl_name_ THEN cf_new_tbl_name_
                              ELSE to_table_name_
                           END)
         WHERE lu_name = old_lu_name_;
         @ApproveTransactionStatement(2017-12-06,maddlk)
         COMMIT;
         Trace___('**LU_ONLY** Meta data updated');

      ELSE
         -- Get history record to be modified
         OPEN get_entries;
         LOOP
            FETCH get_entries BULK COLLECT INTO current_key_ref_list_ LIMIT 10000;
            EXIT WHEN current_key_ref_list_.COUNT = 0;

            FOR i_ IN 1..current_key_ref_list_.COUNT LOOP
               key_ref_new_ := '';
               key_val_new_ := ''; 
               key_ref_old_ := current_key_ref_list_(i_);
               key_ref_old_modified_ := key_ref_old_;
               -- Adjust KEY_REF incase existing Primary keys are RENAMED based on the parameter key_ref_map_
               FOR counter_ IN 1..key_rename_count_ LOOP
                  key_ref_old_modified_ := REPLACE(key_ref_old_modified_, UPPER(key_rename_map_entries_(counter_).OLD), UPPER(key_rename_map_entries_(counter_).NEW));
               END LOOP;

               -- Get new Key_Ref of the target object
               IF regenerate_key_ref_ THEN
                  key_ref_new_ := Client_SYS.Get_New_Key_Reference (to_lu_name_, key_ref_old_modified_,FALSE,TRUE);
               ELSE
                  key_ref_new_ := key_ref_old_modified_;
               END IF;
               
               IF key_ref_new_ IS NOT NULL THEN  -- new keyref generated
                  -- Update new Key_Ref and Key_Value; But, Lu_name is unchanged (Option 1)
                  IF upd_type_ = 'KEY_REF_ONLY' THEN
                     IF (key_ref_old_ <> key_ref_new_) THEN
                        UPDATE history_log_tab
                        SET    keys = key_ref_new_
                        WHERE  lu_name = from_lu_name_
                        AND    keys = key_ref_old_;

                        Trace___('** KEY_REF_ONLY **  Updated -: key_ref_old_: ' || key_ref_old_ || ' key_ref_new_: ' || key_ref_new_);                    
                     END IF;
                  -- Both Lu_name and KEY_REF is changed (Option 3)
                  ELSIF upd_type_ = 'LU_AND_KEY_REF' THEN
                     UPDATE history_log_tab
                     SET    keys = key_ref_new_,
                            lu_name = to_lu_name_,
                            table_name = (CASE
                                             WHEN table_name = cf_old_tbl_name_ THEN cf_new_tbl_name_
                                             ELSE to_table_name_
                                          END)
                     WHERE  lu_name = from_lu_name_
                     AND    keys = key_ref_old_;

                     Trace___('** LU_AND_KEY_REF ** Updated -: key_ref_old_: ' || key_ref_old_ || ' key_ref_new_: ' || key_ref_new_);
                  END IF;
               ELSE
                  Log_SYS.App_Trace(Log_SYS.error_, 'Unable look up record. Lu : ' || to_lu_name_ || ' keyref: '||key_ref_old_modified_);
               END IF; -- target record found by (rowid)
            END LOOP;
            @ApproveTransactionStatement(2017-12-06,maddlk)
            COMMIT;
         END LOOP; 
         CLOSE get_entries;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN     
         Log_SYS.App_Trace(Log_SYS.error_, '  Error           : ' || dbms_utility.format_error_stack);
   END;
   
   UPDATE HISTORY_SETTING_TAB
   SET table_name = (CASE
                        WHEN table_name = cf_old_tbl_name_ THEN cf_new_tbl_name_
                        ELSE to_table_name_
                     END)
   WHERE table_name IN (old_table_name_,cf_old_tbl_name_);
                      
   UPDATE HISTORY_SETTING_ATTRIBUTE_TAB
   SET table_name = (CASE
                        WHEN table_name = cf_old_tbl_name_ THEN cf_new_tbl_name_
                        ELSE to_table_name_
                     END)
   WHERE table_name IN (old_table_name_,cf_old_tbl_name_);
   
   @ApproveTransactionStatement(2018-11-12,ahorse)
   COMMIT;

   BEGIN
      --Refreshing Historylog entries and settings
      Remove_Old_HistoryLogTrgs___(old_table_name_);
      History_Setting_Util_API.Refresh_Settings(module_name_,to_lu_name_,to_table_name_);
      --Refreshing Historylog entries and settings for custom fileds
      IF cft_available_ THEN
         Remove_Old_HistoryLogTrgs___(cf_old_tbl_name_);
         History_Setting_Util_API.Refresh_Settings(module_name_,to_lu_name_,cf_new_tbl_name_);
      END IF;
      Trace___('** Refreshed history log settings for ** : ' || to_lu_name_ );            
   EXCEPTION
      WHEN OTHERS THEN
         Log_SYS.App_Trace(Log_SYS.error_, 'Error: Refreshing history log settings for ' ||to_lu_name_ || '. Error was: ' ||SQLERRM);
   END;
   Trace___('**Finished:  Migration of HistoryLog configuration from: ' ||old_lu_name_ || ' to '||to_lu_name_);
END Handle_Lu_Modification;


@UncheckedAccess
FUNCTION Get_Tab_Short_Name (
   table_name_ IN VARCHAR2
   ) RETURN VARCHAR2
IS
   trigger_hash_val_    NUMBER;
   tab_short_name_      VARCHAR2(50);
BEGIN
   
   IF table_name_ LIKE '%/_CFT' ESCAPE '/' OR table_name_ LIKE '%/_CLT' ESCAPE '/' THEN
      IF length(table_name_) > 24 THEN
         SELECT ora_hash(table_name_, 4294967295) INTO trigger_hash_val_ FROM dual;
         tab_short_name_ := substr(table_name_,1,14)||trigger_hash_val_;
      ELSE
         tab_short_name_ := table_name_; -- include CFT part
      END IF;
   ELSE      
      tab_short_name_ := SUBSTR(REPLACE(table_name_, '_TAB', ''),1,27);
   END IF;
   RETURN tab_short_name_;
END Get_Tab_Short_Name;