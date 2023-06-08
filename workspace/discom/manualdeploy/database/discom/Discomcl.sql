-----------------------------------------------------------------------------
--
--  File:      Discomcl.sql
--
--  Function:  Removes backup tables created in the upgrade process.
--
--  Date    By      Notes
--  ------  ------  ---------------------------------------------------------
--  210603  WaSalk  SC21R2-1367, Merge DiscomCL_GET.SQL scripts of GET to 21R2.
-----------------------------------------------------------------------------

PROMPT NOTE! This script drops tables and columns no longer used in core
PROMPT and must be edited before usage.                                         
ACCEPT Press_any_key                                                            
EXIT; -- Remove me before usage                                                 

SET SERVEROUTPUT ON

PROMPT -------------------------------------------------------------
PROMPT Removal of obsolete tables/columns in DISCOM used in GET 
PROMPT -------------------------------------------------------------

PROMPT Removing obsolete tables from GET release ...

PROMPT Removing obsolete columns from GET release ...
DECLARE           
   column_  Database_SYS.ColRec;
BEGIN 
   --Note: Obsolete columns from SITE_DISCOM_INFO_TAB
   column_ := Database_SYS.Set_Column_Values ('CREATE_IVC_WITHIN_COMP_210');
   Database_SYS.Alter_Table_Column('SITE_DISCOM_INFO_TAB', 'D', column_, TRUE);   
END;
/

PROMPT -------------------------------------------------------------
PROMPT Drop of obsolete table in DISCOM done!
PROMPT -------------------------------------------------------------

