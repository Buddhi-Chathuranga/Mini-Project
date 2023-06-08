-------------------------------------------------------------------------------
--
--  Filename      : Post_Accrul_Remove_Defaults_G2C.sql
--
--  Module        : ACCRUL
--
--  Purpose       : Remove Oracle Default values from columns added by Global Extension to core tables
--                  This need to be done in a post data file to ensure error free deployment of core upgrade scripts
--
--  Date    Sign    History
--  ------  ------  -------------------------------------------------------------
--  200928  PraWlk  Created.
--  221101  Jadulk  FIZ-20788, Added nullable property.
---------------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_Remove_Defaults_G2C.sql','Timestamp_1');
PROMPT Post_Accrul_Remove_Defaults_G2C.sql Start

-----------------------------------------------------------------------------------------
-- Removing Oracle Defaults from table columns
-----------------------------------------------------------------------------------------

-- ***** statutory_fee_tab Begin *****
exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_Remove_Defaults_G2C.sql','Timestamp_2');
PROMPT Removing Oracle default values from columns in statutory_fee_tab
DECLARE
   column_             Database_SYS.ColRec;
   table_              VARCHAR2(30) := 'STATUTORY_FEE_TAB';
BEGIN
   column_ := Database_SYS.Set_Column_Values('EXCLUDE_FROM_SII_REPORTING', nullable_ =>'N', default_value_=>'$DEFAULT_NULL$');
   Database_SYS.Alter_Table_Column (table_, 'M', column_, TRUE);

   column_ := Database_SYS.Set_Column_Values('STAMP_DUTY', nullable_ =>'N', default_value_=>'$DEFAULT_NULL$');
   Database_SYS.Alter_Table_Column (table_, 'M', column_, TRUE);

   column_ := Database_SYS.Set_Column_Values('ROUND_ZERO_DECIMAL', nullable_ =>'N', default_value_=>'$DEFAULT_NULL$');
   Database_SYS.Alter_Table_Column (table_, 'M', column_, TRUE);
END;
/
-- ***** statutory_fee_tab End *****

-- ***** tax_code_texts_tab Begin *****
exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_Remove_Defaults_G2C.sql','Timestamp_3');
PROMPT Removing Oracle default values from columns in tax_code_texts_tab
DECLARE
   column_             Database_SYS.ColRec;
   table_              VARCHAR2(30) := 'TAX_CODE_TEXTS_TAB';
BEGIN
   column_ := Database_SYS.Set_Column_Values('EXC_FROM_SPESOMETRO_DEC', nullable_ =>'N', default_value_=>'$DEFAULT_NULL$');
   Database_SYS.Alter_Table_Column (table_, 'M', column_, TRUE);
END;
/
-- ***** tax_code_texts_tab End *****

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_Remove_Defaults_G2C.sql','Done');
PROMPT Post_Accrul_Remove_Defaults_G2C.sql End


