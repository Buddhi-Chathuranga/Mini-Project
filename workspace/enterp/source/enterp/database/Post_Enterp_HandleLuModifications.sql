--------------------------------------------------------------------------
--  File:      Post_Enterp_HandleLuModifications.sql
--
--  Module:    ENTERP
--
--  Purpose:   Hanlde object connections and other Lu modifications after changing keys.
--
--  Date    Sign   History
--  ------  -----  -------------------------------------------------------
--  180223  Bmekse Created
--------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_HandleLuModifications.sql','Timestamp_1');
PROMPT Starting Post_Enterp_HandleLuModifications.sql

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_HandleLuModifications.sql','Timestamp_2');
PROMPT Handle lu modifications for tax_liability_tab
BEGIN
   Database_SYS.Handle_Lu_Modification('ENTERP', 'TaxLiability', key_ref_map_ => 'LIABILITY_TYPE=TAX_LIABILITY');
   COMMIT;
END;
/
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_HandleLuModifications.sql','Done');

PROMPT Finished with Post_Enterp_HandleLuModifications.sql
