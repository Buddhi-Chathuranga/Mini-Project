-----------------------------------------------------------------------------
--
--  Logical unit: ComponentFileType
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020617  NIPA   Created
--  021001  ROOD   Merged in Project Whiskas.
--  030130  NIPAFI Changed REF for attribute module in VIEW from LanguageModule
--                 to Module.
--  030212  ROOD   Changed module to FNDBAS (ToDo#4149).
--  070316  STDAFI Added logic for suppressing error if old lng file was loaded
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('RUNTIME', 'FALSE', attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Clear_All__ (
   module_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
   CURSOR get_all IS
      SELECT objid, objversion
      FROM COMPONENT_FILE_TYPE
      WHERE module = module_;
BEGIN
  FOR rec_ IN get_all LOOP
     Remove__(info_,rec_.objid,rec_.objversion,'DO');
  END LOOP;
END Clear_All__;


PROCEDURE Update_All__ (
   module_       IN VARCHAR2,
   file_types_   IN OUT VARCHAR2,
   set_obsolete_ IN VARCHAR2,
   separator_    IN VARCHAR2 )
IS
   attr_         VARCHAR2(200);
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   file_type_db_ VARCHAR2(20);
   runtime_      VARCHAR2(6);
   pos_          NUMBER;

BEGIN

   Log_SYS.Fnd_Trace_(Log_SYS.trace_, set_obsolete_);

  IF (set_obsolete_ = 'TRUE') THEN

     Log_SYS.Fnd_Trace_(Log_SYS.trace_, 'Clear file types for module '||module_);
     Clear_All__(module_);

     WHILE (instr(file_types_,separator_,1) <> 0) LOOP

        pos_          := instr(file_types_,separator_,1);
        file_type_db_ := substr(file_types_, 1 ,pos_ - 1);
        file_types_   := substr(file_types_,pos_ +1,length(file_types_));

        pos_          := instr(file_types_,separator_,1);
        runtime_      := substr(file_types_, 1 ,pos_ - 1);
        file_types_   := substr(file_types_,pos_ +1,length(file_types_));

        Client_SYS.Clear_Attr(attr_);
        Client_SYS.Add_To_Attr('MODULE', module_, attr_);
        Client_SYS.Add_To_Attr('FILE_TYPE_DB', file_type_db_, attr_);
        Client_SYS.Add_To_Attr('RUNTIME', runtime_, attr_);
	     
        -- Compability to old lng files.
        IF (File_Type_API.Decode(file_type_db_) IS NOT NULL) THEN
         New__(info_,objid_,objversion_,attr_,'DO');
        END IF;

     END LOOP;

  ELSE

     WHILE (instr(file_types_,separator_,1) <> 0) LOOP

        pos_          := instr(file_types_,separator_,1);
        file_type_db_ := substr(file_types_, 1 ,pos_ - 1);
        file_types_   := substr(file_types_,pos_ +1,length(file_types_));

        pos_          := instr(file_types_,separator_,1);
        runtime_      := substr(file_types_, 1 ,pos_ - 1);
        file_types_   := substr(file_types_,pos_ +1,length(file_types_));

        IF NOT (Check_Exist___(module_,file_type_db_)) THEN
           Client_SYS.Clear_Attr(attr_);
           Client_SYS.Add_To_Attr('MODULE', module_, attr_);
           Client_SYS.Add_To_Attr('FILE_TYPE_DB', file_type_db_, attr_);
           Client_SYS.Add_To_Attr('RUNTIME', runtime_, attr_);
           
           -- Compability to old lng files.
           IF (File_Type_API.Decode(file_type_db_) IS NOT NULL) THEN
            New__(info_,objid_,objversion_,attr_,'DO');
           END IF;
        END IF;

     END LOOP;

  END IF;
END Update_All__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


