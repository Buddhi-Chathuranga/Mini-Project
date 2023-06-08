-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatFileUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210809  ErFelk  Bug 159926(SCZ-15791), Modified New_File() in order to use the parameter file_path_ for country Finland.
--  210304  ApWilk  Bug 156696(SCZ-13937), Modified Create_New_File() and New_File() in order to use the newly added parameter pre_intrastat_id_ for Polish transactions.
--  200928  HaPulk  SC2020R1-10102, Replaced Package_Is_Installed with Package_Is_Active since condition is to 
--  200928          check component ACTIVE/INACTIVE instead of installability.
--  200213  ApWilk  Bug 145769, Modified New_File() to remove the attribute report_type_ when calling Create_Output() for hungary.
--  190522  ErFelk  Bug 143445, Modified Create_New_File() and New_File() by adding a new parameter file_path_. 
--  170519  TiRalk  STRSC-8487, Modified Create_New_File add the values properly to the clob.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130325  TiRalk  Bug 108629, Increased length of VARCHAR2_32000_VECTOR to avoid oracle error when transferring the intrastat file.
--  ------------------------------- 14.0.0 ----------------------------------
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  070227  KaDilk  Merged Patch 46111, Modified method New_File in order to handle Slovakia.
--  060911  ChBalk  Merged call 53157, Added methods Set_Progress_Nos and Get_Progress_Nos.
--  051205  HaPulk  Added Assert safe annotation.
--  050425  SeJalk  Bug 49978, Applied validity check for package name in procedure New_File().
--  041102  CaRase  Bug 46113. Parameter Report Type are added to procedure New_File for Hungary
--  040202  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  -------------------------- 13.3.0 ------------------------------------------
--  010226  ErFi    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Create_New_File(
   country_          IN  VARCHAR2,
   intrastat_id_     IN  VARCHAR2,
   intrastat_export_ IN  VARCHAR2,
   intrastat_import_ IN  VARCHAR2,
   report_type_      IN  VARCHAR2,
   pre_intrastat_id_ IN  VARCHAR2,
   file_path_        IN  VARCHAR2)RETURN CLOB
IS 
   output_clob_         CLOB;
   clob_out_data_       CLOB;
   info_                VARCHAR2(32000);
   import_progress_no_  NUMBER;
   export_progress_no_  NUMBER;
   intrastat_id_num_    NUMBER;
   pre_intrastat_id_num_ NUMBER;
   report_type_num_      NUMBER;
BEGIN 
   -- Converting the string values to number
   intrastat_id_num_  := Client_SYS.Attr_Value_To_Number(intrastat_id_);
   report_type_num_   := Client_SYS.Attr_Value_To_Number(report_type_);
   pre_intrastat_id_num_ := Client_SYS.Attr_Value_To_Number(pre_intrastat_id_);
   
   New_File(output_clob_,
            info_,
            import_progress_no_,
            export_progress_no_,
            country_,
            intrastat_id_num_,
            intrastat_export_,
            intrastat_import_,
            pre_intrastat_id_num_,
            report_type_num_,
            file_path_);
   clob_out_data_ := Message_SYS.Construct('OUTPUT_DATA');
   Message_SYS.Add_Clob_Attribute(clob_out_data_, 'FILE_CONTENT' , output_clob_); 
   Message_SYS.Add_Clob_Attribute(clob_out_data_, 'INFO' , info_);      
   Message_SYS.Add_Clob_Attribute(clob_out_data_, 'IMPORT_PROGRESS_NO' , TO_CHAR(NVL(import_progress_no_, 0))); 
   Message_SYS.Add_Clob_Attribute(clob_out_data_, 'EXPORT_PROGRESS_NO' , TO_CHAR(NVL(export_progress_no_, 0))); 
   RETURN clob_out_data_;
END Create_New_File;


-- New_File
--   Calls the correct localized package to create the country specific
--   Intrastat file. Handles both export and import files.
PROCEDURE New_File (
   output_clob_         OUT CLOB,
   info_                OUT VARCHAR2,
   import_progress_no_  OUT NUMBER,
   export_progress_no_  OUT NUMBER,
   country_             IN  VARCHAR2,
   intrastat_id_        IN  NUMBER,
   intrastat_export_    IN  VARCHAR2,
   intrastat_import_    IN  VARCHAR2,
   report_type_         IN  NUMBER,
   pre_intrastat_id_    IN  NUMBER,
   file_path_           IN  VARCHAR2)
IS
   stmt_          VARCHAR2(2000);
   package_name_  VARCHAR2(100);
BEGIN

   -- Check for installed country specific package
   package_name_ := 'Intrastat_'||country_||'_File_API';
   Trace_SYS.Message('Checking if country specific package '||UPPER(package_name_)
                     || ' is installed.');

   IF NOT Transaction_SYS.Package_Is_Active(package_name_) THEN
      -- The specifc localized package was not installed.
      -- This should never happen if the installation was correct.
      -- If this error is encountered, someone has tried to generate an
      -- Intrastat file for a country whoose localized package has not
      -- been intstalled.
      Error_SYS.Record_General(lu_name_, 'NOPACKAGEFOUND: Could not find package for country :P1. Contact your system administrator.', country_);
   END IF;
   Trace_SYS.Message('The package was installed. Continuing execution.');

   -- Since this procedure will not be called very often,
   -- the method name is built dynamically which should not impact on performance.
   -- This means that no changes are needed here when new country specific
   -- packages are added to the database.
   IF country_ = 'HU' THEN
      Assert_Sys.Assert_Is_In_Whitelist(package_name_, 'Intrastat_HU_File_API');
      stmt_ := 'BEGIN
                   '||package_name_||'.Create_Output(:output_clob_, :info, :import_progress_no_, :export_progress_no_,
                                                     :intrastat_id, :intrastat_export, :intrastat_import);
                END;';
      @ApproveDynamicStatement(2005-12-05,hapulk)
      EXECUTE IMMEDIATE stmt_
         USING OUT output_clob_,
               OUT info_,
               OUT import_progress_no_,
               OUT export_progress_no_,
               IN  intrastat_id_,
               IN  intrastat_export_,
               IN  intrastat_import_;

   ELSIF country_ = 'SK' THEN
      Assert_SYS.Assert_Is_In_Whitelist(package_name_, 'Intrastat_SK_File_API');
      stmt_ := 'BEGIN
                   '||package_name_||'.Create_Output(:output_clob_, :info, :import_progress_no_, :export_progress_no_,
                                                     :intrastat_id, :intrastat_export, :intrastat_import, :report_type  );
                END;';

      @ApproveDynamicStatement(2007-01-29,MalLlk)
      EXECUTE IMMEDIATE stmt_
         USING OUT output_clob_,
               OUT info_,
               OUT import_progress_no_,
               OUT export_progress_no_, 
               IN  intrastat_id_,
               IN  intrastat_export_,
               IN  intrastat_import_,
               IN  report_type_;
               
   ELSIF country_ = 'PL' THEN
      Assert_SYS.Assert_Is_In_Whitelist(package_name_, 'Intrastat_PL_File_API');
      stmt_ := 'BEGIN
                   '||package_name_||'.Create_Output(:output_clob_, :info, :import_progress_no_, :export_progress_no_,
                                                     :intrastat_id, :intrastat_export, :intrastat_import, :pre_intrastat_id  );
                END;';

      @ApproveDynamicStatement(2018-08-06,ApWilk)
      EXECUTE IMMEDIATE stmt_
         USING OUT output_clob_,
               OUT info_,
               OUT import_progress_no_,
               OUT export_progress_no_, 
               IN  intrastat_id_,
               IN  intrastat_export_,
               IN  intrastat_import_,
               IN  pre_intrastat_id_;               
               
   ELSIF country_ = 'DE' THEN
      Assert_SYS.Assert_Is_In_Whitelist(package_name_, 'Intrastat_DE_File_API');
      stmt_ := 'BEGIN
                   '||package_name_||'.Create_Output(:output_clob_, :info, :import_progress_no_, :export_progress_no_, 
                                                     :intrastat_id, :intrastat_export, :intrastat_import, :file_extension);
                END;';
      @ApproveDynamicStatement(2019-05-22,ErFelk)
      EXECUTE IMMEDIATE stmt_
      USING    OUT output_clob_,
               OUT info_,
               OUT import_progress_no_,
               OUT export_progress_no_, 
               IN  intrastat_id_,
               IN  intrastat_export_,
               IN  intrastat_import_,
               IN  SUBSTR(file_path_, -3, 3);
   ELSIF country_ = 'FI' THEN
      Assert_SYS.Assert_Is_In_Whitelist(package_name_, 'Intrastat_FI_File_API');
      stmt_ := 'BEGIN
                   '||package_name_||'.Create_Output(:output_clob_, :info, :import_progress_no_, :export_progress_no_, 
                                                     :intrastat_id, :intrastat_export, :intrastat_import, :file_extension);
                END;';
      @ApproveDynamicStatement(2021-07-07,ErFelk)
      EXECUTE IMMEDIATE stmt_
      USING    OUT output_clob_,
               OUT info_,
               OUT import_progress_no_,
               OUT export_progress_no_, 
               IN  intrastat_id_,
               IN  intrastat_export_,
               IN  intrastat_import_,
               IN  SUBSTR(file_path_, -3, 3);            
   ELSE
      Assert_Sys.Assert_Is_Package(package_name_);
      stmt_ := 'BEGIN
                   '||package_name_||'.Create_Output(:output_clob_, :info, :import_progress_no_, :export_progress_no_, 
                                                     :intrastat_id, :intrastat_export, :intrastat_import);
                END;';
      @ApproveDynamicStatement(2005-12-05,hapulk)
      EXECUTE IMMEDIATE stmt_
      USING    OUT output_clob_,
               OUT info_,
               OUT import_progress_no_,
               OUT export_progress_no_, 
               IN  intrastat_id_,
               IN  intrastat_export_,
               IN  intrastat_import_;
   END IF;
END New_File;


PROCEDURE Get_Progress_Nos(
   import_progress_no_ IN OUT NUMBER,
   export_progress_no_ IN OUT NUMBER,
   intrastat_id_       IN  NUMBER )
IS
   old_import_progress_no_ NUMBER;
   old_export_progress_no_ NUMBER;
   
   CURSOR get_progress_nos IS
      SELECT import_progress_no, export_progress_no
      FROM intrastat_tab
      WHERE intrastat_id = intrastat_id_;
BEGIN
   
   OPEN get_progress_nos;
   FETCH get_progress_nos INTO old_import_progress_no_, old_export_progress_no_;
   CLOSE get_progress_nos;
   
   import_progress_no_ := NVL(import_progress_no_, old_import_progress_no_);
   export_progress_no_ := NVL(export_progress_no_, old_export_progress_no_);  
END Get_Progress_Nos;



