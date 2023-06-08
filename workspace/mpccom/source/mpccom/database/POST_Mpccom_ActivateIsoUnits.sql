--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Mpccom_ActivateIsoUnits.sql
--
--  Module      : MPCCOM 14.0.0
--
--  Purpose     : Activating commonly used units to enable 'Used in Application' ISO unit usage-UOM tab and this is only executed
--                in a fresh installation.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  170505   JeeJlk  Bug 135642, Created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_ActivateIsoUnits.sql','Timestamp_1');
PROMPT Starting POST_Mpccom_ActivateIsoUnits
PROMPT Activating commonly used units...
-- The units activated below already exists in the IsoUnit table.
BEGIN
   -- kilo
   Iso_Unit_API.Set_Unit_Type('kg', Iso_Unit_Type_API.Decode('WEIGHT'));
   Iso_Unit_API.Activate_Code('kg');

   -- piece (not ISO)
   Iso_Unit_API.Set_Unit_Type('PCS', Iso_Unit_Type_API.Decode('DISCRETE'));
   Iso_Unit_API.Activate_Code('PCS');

   -- litre
   Iso_Unit_API.Set_Unit_Type('m3', Iso_Unit_Type_API.Decode('VOLUME'));
   Iso_Unit_API.Activate_Code('l');

   -- meter
   Iso_Unit_API.Activate_Code('m');

   -- hour
   Iso_Unit_API.Activate_Code('h');
END;
/

PROMPT Finished with POST_Mpccom_ActivateIsoUnits.sql
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_ActivateIsoUnits.sql','Done');
