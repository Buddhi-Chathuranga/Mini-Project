-----------------------------------------------------------------------------
--  Module : ENTERP
--
--  File   : Post_Enterp_RemoveLocalizationParameters.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  170817   dipelk  GEM-512,Created
--  170926   prKalk  GEM-582,Created.
--  171009   prKalk  GEM-210,Clean up.
--  171009   prKalk  GEM-580,Remove APP9 GET CodeExclude Services in Delivery Note Printout.
--  171218   Kagalk  GEM-1446, Remove Extended Handling of Branches.
--  180122   cecobr  GEM-2921, Remove current Brazilian zip code functionalitty from application
--  180220   togrpl  GEM-3417, Removed EXCEPTION handlig, because it only hides the problems.
--  181224   misibr  Bug 146317, removed obsolete ELECTRONIC_FISCAL_NOTE parameter.
--  190506   chgulk  gelr:in_hsn_sac_codes, Bug 146645, removed obsolete TAX_TYPE_CATEGORY parameter.
--  200406   kabelk  Introduced file to Core.
--  200406   kabelk  Remove TAX_EXEMPTION_CERTIFY parameter.
--  200825   MalLlk  GESPRING20-5452, Removed localization parameter FREE_OF_CHARGE, since functinality moved to core.
--  210528   NWeelk  FI21R2-1514, Removed localization parameter PREPAYMENT_TYPE, since functionality moved to core.
--  210622   LEPESE  SC21R2-794, Removed localization parameter HU_APPLIED_DATE_PO_MATCHING, since functionality moved to core.
--  210630   MaEelk  SC21R2-1459, Removed localization parameter DELIVERY_TYPES_IN_PBI, since functionality was moved to core.
--  210727   LEPESE  MF21R2-2533, Removed localization parameter FOLLOW_UP_MAT_PROD_COST, since functionality moved to core.
--  211104   Hiralk  FI21R2-4241, Removed obsolete parameter COEFFICIENT_FOR_TAX.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------


SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveLocalizationParameters.sql','Timestamp_1');
PROMPT Post_Enterp_RemoveLocalizationParameters_GET.sql

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveLocalizationParameters.sql','Timestamp_2');
PROMPT Remove localization parameters and their basic data which moved to core
BEGIN
   -- Localization parameters - Moved to Core
   Localization_Parameter_API.Remove_Loc_Parameter('CUST_DECL_DATE');               -- 1
   Localization_Parameter_API.Remove_Loc_Parameter('INV_DEL_DATE');                 -- 8
   Localization_Parameter_API.Remove_Loc_Parameter('TAX_REPORTING_PER_BRANCH');     -- 9
   Localization_Parameter_API.Remove_Loc_Parameter('PRINT_TAX_BASE_AMOUNTS');       -- 10
   Localization_Parameter_API.Remove_Loc_Parameter('CUST_DECL_NO');                 -- 12
   Localization_Parameter_API.Remove_Loc_Parameter('DEF_CURR_RATE_SUPP_INV');       -- 19
   Localization_Parameter_API.Remove_Loc_Parameter('FREE_OF_CHARGE');               -- 30
   Localization_Parameter_API.Remove_Loc_Parameter('EXC_SVC_DELNOTE_PRINT');        -- 34
   Localization_Parameter_API.Remove_Loc_Parameter('EXTENDED_DEL_NOTE_ANALYSIS');   -- 37
   Localization_Parameter_API.Remove_Loc_Parameter('TAX_CODE_STRUCTURE');           -- 47
   Localization_Parameter_API.Remove_Loc_Parameter('ADDRESS_VIA_ZIP_CODE');         -- 49
   Localization_Parameter_API.Remove_Loc_Parameter('INDO_COMMERCIAL_INVOICE');      -- 66
   Localization_Parameter_API.Remove_Loc_Parameter('PREPAYMENT_TYPE');              -- 91
   Localization_Parameter_API.Remove_Loc_Parameter('CREDIT_INSTANT_INVOICE');       -- 97
   -- Localization parameters - Removed
   Localization_Parameter_API.Remove_Loc_Parameter('FORM_340');                     -- 18
   Localization_Parameter_API.Remove_Loc_Parameter('FOLLOW_UP_MAT_PROD_COST');      -- 23
   Localization_Parameter_API.Remove_Loc_Parameter('ANNUAL_LIST');                  -- 39
   Localization_Parameter_API.Remove_Loc_Parameter('ELECTRONIC_FISCAL_NOTE');       -- 78
   Localization_Parameter_API.Remove_Loc_Parameter('TAX_REP_ER1');                  -- 89
   Localization_Parameter_API.Remove_Loc_Parameter('TAX_TYPE_CATEGORY');            -- 48
   Localization_Parameter_API.Remove_Loc_Parameter('TAX_EXEMPTION_CERTIFY');        -- 62
   Localization_Parameter_API.Remove_Loc_Parameter('COEFFICIENT_FOR_TAX');          -- 103
   Localization_Parameter_API.Remove_Loc_Parameter('HU_APPLIED_DATE_PO_MATCHING');  -- 122
   Localization_Parameter_API.Remove_Loc_Parameter('DELIVERY_TYPES_IN_PBI');        -- 166
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveLocalizationParameters.sql','Done');
SET SERVEROUTPUT OFF

