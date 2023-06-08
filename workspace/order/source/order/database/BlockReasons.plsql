-----------------------------------------------------------------------------
--
--  Logical unit: BlockReasons
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171102  RaVdlk  STRSC-14009, Modified message constant of Check_Update___ from ILLSOURCETYPE to UPDATENOTALLOWED and of Check_Delete___ from ILLSOURCETYPE
--                  to DELETENOTALLOWED to avoid overriding of language translations.
--  160713  TiRalk  STRSC-2713, Modified Insert_Block_Reasons by adding new attribute exclude_mtrl_planning_.
--  160705  IzShlk  STRSC-1190, Overriden  Prepare_Insert___, Check_Insert___, Check_Delete___ methods.
--  160704  IzShlk  STRSC-1190, Created Insert_Block_Reasons method to insert data through INS script.
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
   Client_SYS.Add_To_Attr('BLOCK_TYPE', 'Manual', attr_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED_DB', 'FALSE' , attr_);
   Client_SYS.Add_To_Attr('EXCLUDE_MTRL_PLANNING_DB', 'FALSE' , attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT block_reasons_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.system_defined IS NULL) THEN
      newrec_.system_defined := 'FALSE';
   END IF;
   super(newrec_, indrec_, attr_);
   
END Check_Insert___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN block_reasons_tab%ROWTYPE )
IS
BEGIN
   IF (remrec_.system_defined = 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'DELETENOTALLOWED: You are not allowed to delete a system defined block reason.');
   END IF;
   super(remrec_);
  
END Check_Delete___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     block_reasons_tab%ROWTYPE,
   newrec_ IN OUT block_reasons_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF ( oldrec_.system_defined= 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'UPDATENOTALLOWED: You are not allowed to update a system defined block reason.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Insert_Block_Reasons (
   block_reason_              IN VARCHAR2,
   block_reason_description_  IN VARCHAR2,
   block_type_                IN VARCHAR2,
   system_defined_            IN VARCHAR2,
   exclude_mtrl_planning_     IN VARCHAR2,
   rowstate_                  IN VARCHAR2)
IS
   dummy_      NUMBER;
   
   CURSOR check_rec IS
         SELECT 1
         FROM   BLOCK_REASONS_TAB
         WHERE  block_reason = block_reason_;
   
BEGIN
   OPEN check_rec;
      FETCH check_rec INTO dummy_;
      IF (check_rec%NOTFOUND) THEN
         CLOSE check_rec;
         INSERT INTO BLOCK_REASONS_TAB ( BLOCK_REASON, BLOCK_REASON_DESCRIPTION, BLOCK_TYPE, SYSTEM_DEFINED, EXCLUDE_MTRL_PLANNING, ROWSTATE, ROWVERSION, ROWKEY  )
            VALUES ( block_reason_, block_reason_description_, block_type_, system_defined_, exclude_mtrl_planning_, rowstate_, SYSDATE, sys_guid() );
      ELSE
         CLOSE  check_rec;
         UPDATE BLOCK_REASONS_TAB
            SET block_reason              = block_reason_,
                block_reason_description  = block_reason_description_,
                block_type                = block_type_,
                exclude_mtrl_planning     = exclude_mtrl_planning_,
                rowstate                  = rowstate_
            WHERE block_reason = block_reason_;
      END IF;
      
      -- Insert Data into Basic Data Translations tab
      Basic_Data_Translation_API.Insert_Prog_Translation('ORDER',
                                                         'BlockReasons',
                                                          block_reason_,
                                                          block_reason_description_);

END Insert_Block_Reasons;

-------------------- LU  NEW METHODS -------------------------------------
