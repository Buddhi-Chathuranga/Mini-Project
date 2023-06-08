-----------------------------------------------------------------------------
--
--  Logical unit: ExtFileServerUtil
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021031  PPerse   Created
--  040928  ovjose   Added support for writing files with Utl_File with different character set
--  060120  shsalk   Corrected translation problem.
--  060524  Jeguse  Bug 58274, Corrected
--  061016  Kagalk  LCS Merge 57354, Increased length of file_line_ and max_linesize for Utl_File.Fopen
--  061016          Added Check for file line length
--  060726  AmNilk  Merged the LCS Bug 58891, Added code to remove the original file when file read is done.    
--  061208  Kagalk  LCS Merge 60487
--  070711  Hawalk  Merged Bug 66081, Added OUT parameter backup_file_path_ to Copy_Server_File_().
--  090116  Jeguse  Bug 79498, Increased length of file_name
--  100920  AjPelk  Bug 91106  Replaced '\' with a server_path_separator_
--  131114  Charlk  PBFI-2045,Change method In_Ext_File_Template_Dir_API.Get_Character_Set to  Get_Character_Set_D
--  190515  Nudilk  Bug 148286, Added Remove_Invalid_Char_Server_File___.
--  210713  Nudilk  FI21R2-1900, Added Load_External_File, Modified logic in Load_Server_File and Remove unused methods.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Remove_Invalid_Char_Server_File___(
   file_line_  IN VARCHAR2) RETURN VARCHAR2
IS
   ret_file_line_ VARCHAR2(32000);
BEGIN
   ret_file_line_ := file_line_;
   -- Remove BOM charactor all occurences.
   ret_file_line_ := REPLACE(ret_file_line_, CHR(15711167));
   -- Remove last CHR(13) charactor.
   IF (SUBSTR(ret_file_line_,-1) = CHR(13)) THEN
      ret_file_line_ := SUBSTR(ret_file_line_, 0, LENGTH(ret_file_line_) - 1);
   END IF;
   RETURN ret_file_line_;
END Remove_Invalid_Char_Server_File___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@IgnoreUnitTest DMLOperation
PROCEDURE Load_Server_File (
   load_file_id_     IN OUT NUMBER,
   file_template_id_ IN     VARCHAR2,
   file_type_        IN     VARCHAR2,
   file_name_        IN     VARCHAR2,
   company_          IN     VARCHAR2 )
IS
   file_namex_              VARCHAR2(2000);
   in_file_character_set_   VARCHAR2(64) := In_Ext_File_Template_Dir_API.Get_Character_Set_Db(file_template_id_,'1');
   row_no_                  NUMBER:=0;
   import_message_id_       NUMBER;
   file_data_clob_          CLOB;
   file_line_               ext_file_trans_tab.file_line%TYPE;
   file_lines_array_        External_File_Utility_API.LineTabType;
   
   CURSOR get_file_data_clob IS
      SELECT file_data
        FROM external_batch_load_file_tab
       WHERE load_file_id      = load_file_id_
         AND file_name         = file_name_
         AND state             = Ext_Batch_File_Load_State_API.DB_TRANSFERRED
         AND import_message_id = import_message_id_;
   
BEGIN
   External_Batch_Load_File_API.Validate_External_File_Load(import_message_id_, load_file_id_, file_name_);
   
   IF (import_message_id_ != 0) THEN

      OPEN get_file_data_clob;
      FETCH get_file_data_clob INTO file_data_clob_;
      CLOSE get_file_data_clob;
      
      IF file_data_clob_ IS NOT NULL THEN
         
         -- Set character set to convert from
         IF in_file_character_set_ IS NOT NULL THEN
            Database_SYS.Set_File_Encoding(in_file_character_set_);
         END IF;
         
         -- Get file content to file_lines_array_.
         file_lines_array_ := External_File_Utility_API.Split_Clob_To_File_Lines(file_data_clob_);
      
         -- Loop through file_lines.
         FOR i_ IN 1..file_lines_array_.COUNT() LOOP
            file_line_ := file_lines_array_(i_);
            file_line_ := Database_SYS.File_To_Db_Encoding(file_line_);
            file_line_ := Remove_Invalid_Char_Server_File___(file_line_);
            IF length(file_line_) > 4000 THEN
               Error_SYS.Appl_General(lu_name_, 'FILELINELONG: Maximum length allowed for a File Line is 4000 characters.');
            END IF;
            IF (NVL(load_file_id_,0) = 0) THEN
               load_file_id_ := External_File_Utility_API.Get_Next_Seq;
            END IF;
            row_no_ := Ext_File_Trans_API.Get_Max_Row_No ( load_file_id_ );

            IF (NOT Ext_File_Load_API.Check_Exist_File_Load ( load_file_id_ ) ) THEN
               Ext_File_Load_API.Insert_File_Load ( load_file_id_,
                                                    file_template_id_,
                                                    '1',
                                                    file_type_,
                                                    company_,
                                                    file_namex_ );
            END IF;
            Ext_File_Trans_API.Insert_File_Trans ( load_file_id_,
                                                   row_no_,
                                                   file_line_ );
            row_no_ := row_no_ + 1;
         END LOOP;
         Ext_File_Load_API.Update_State (load_file_id_, '2');
         
         -- Set the file encoding back to default
         Database_SYS.Set_Default_File_Encoding;
      END IF;
   END IF;
END Load_Server_File;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Note: This method will be called from Routing rules when new external file loaded from an appliation message.
@IgnoreUnitTest DMLOperation
FUNCTION Load_External_File(
   message_ IN CLOB) RETURN CLOB
IS
   message_out_   CLOB;
   app_msg_id_    NUMBER;
   rec_           external_batch_load_file_tab%ROWTYPE;
   created_from_  VARCHAR2(2000);
   file_name_     VARCHAR2(100);
   
   CURSOR get_created_from IS
      SELECT created_from 
      FROM Application_Message
      WHERE application_message_id = app_msg_id_;
   
   CURSOR get_file_name IS
      SELECT NAME
      FROM fndcn_message_body_tab 
      WHERE application_message_id = app_msg_id_
      AND NAME IS NOT NULL
      ORDER by seq_no;
   
BEGIN
   app_msg_id_ := App_Context_SYS.Find_Number_Value('APPLICATION_MESSAGE_ID', 0);
   IF app_msg_id_ != 0 THEN
      
      OPEN get_created_from;
      FETCH get_created_from INTO created_from_;
      CLOSE get_created_from;
      
      OPEN get_file_name;
      FETCH get_file_name INTO file_name_;
      CLOSE get_file_name;
      IF file_name_ IS NULL AND created_from_ IS NOT NULL THEN
         file_name_ := SUBSTR(created_from_, INSTR(created_from_,',',-1)+1, length(created_from_));
      END IF;
      
      rec_.import_message_id := app_msg_id_;
      rec_.state             := Ext_Batch_File_Load_State_API.DB_LOADED;
      rec_.file_data         := message_;
      rec_.created_from      := created_from_;
      rec_.file_name         := file_name_;
      rec_.creation_date     := SYSDATE;
      
      External_Batch_Load_File_API.Insert_Record(rec_);
   END IF;
   RETURN message_out_;
END Load_External_File;