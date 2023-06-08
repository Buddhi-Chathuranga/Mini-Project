-----------------------------------------------------------------------------
--
--  Logical unit: MpccomSystemParameter
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210224  BudKlk  Bug 157684(SCZ-13464), Added GS1_BARCODE_VALIDATION to support validation for the values in the GS1 barcode in WADACO.
--  210128  DaZase  SC2020R1-10508, Removed checks for SCANDIT_APP_KEY in Check_Update___() and Check_Common___() since its now obsolote
--  210128          and now the scandit app key is handled by Native FW instead.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  200203  SBalLK  Bug 152206(SCZ-8596), Modified Check_Common___() method to restrict enter negative value for the 'CAPABLE_BINS_FOR_LARGE_ZONES' parameter.
--  171207  SWiclk  STRSC-14791, Modified Check_Update___() and added Check_Common___() to replace value of SCANDIT_APP_KEY to
--  171207          Database_SYS.STRING_NULL_ if null and to make other parameter_value1s UPPERCASE except for SCANDIT_APP_KEY..
--  170802  SURBLK  Added FNC1_ASCII_VALUE to support for the GS1-128 barcode functionality.
--  151029  JeLise  LIM-4351, Removed all code regarding PALLET_HANDLING.
--  141006  NaLrlk  Modified Check_Insert___ and Check_Update___ to handle rental synchronization parameter values.
--  140730  MaEelk  Modified Check_Update___ and Check_Insert___ to remove unncessary codes and replace the usage of value_ woth newrec_.parameter_value1.
--  140625  KoDelk  Bug 117389, Added validations for the LEADTIME_FACTOR1 and LEADTIME_FACTOR1 so that they will have correct number formating.
--  130812  MaIklk  TIBE-933, Removed inst_InventoryPartLocPallet_ global variable and used conditional compilation instead.
--  120525  JeLise  Made description private.
--  120511  JeLise  Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511          in New___, Modify__, Insert_Or_Update__, Get_Description and in the views. 
--  111019  MaEelk  Modified Unpack_Check_Update___ to execute the method call Inventory_Part_Loc_Pallet_API.Exist_Any_Instance only 
--  111019          when the parameter_value1 is changed from the previous value.
--  100429  Ajpelk  Merge rose method documentation
-- ----------------------------Eagle------------------------------------------
--  061114  NaLrlk  Removed procedure Get_Default_Flags and its usage.
--  060215  JOHESE  Added parameter TRANSACTIONS_PROJECT_TRANSFERS
--  060123  JaJalk  Added Assert safe annotation.
--  051102  GeKalk  Removed onhand_analysis_flag from the code.
--  050919  NaLrlk  Removed unused variables.
--  050126  SaMelk  Removed the dynamic calls to Cust_Ord_Print_Control_API.
--  041221  DhWilk  Bug 120811 - Assigned the DB value for newrec_.parameter_value1 in UnpackCheckUpdate___ & UnpackCheckInsert___
--          DhWilk  And removed unnecessary codes in those methods.
--  041026  HaPulk  Moved methods Insert_Lu_Translation from Insert___ to New__ and
--  041026          Modify_Translation from Update___ to Modify__.
--  041013  HaPulk  Added PARAMETER_VALUE1_DB to methods Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040929  HaPulk  Renamed Insert_Lu_Data_Rec__ as Insert_Or_Update__ and changed the logic.
--  040225  SaNalk  Removed SUBSTRB.
--  ----------------------------- 13.3.0 --------------------------------------
--  040202  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  030930  ThGulk  Changed substr to substrb, instr to instrb, length to lengthb.
--  020118  DaMase  IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  001030  PERK   Changed substr to substrb in MPCCOM_SYSTEM_PARAMETER_GYN and MPCCOM_SYSTEM_PARAMETER_GYNA
--  001026  JOHESE Removed system parameter HSE_INTEGRATION
--  001019  JOHESE Added system parameter HSE_INTEGRATION
--  000925  JOHESE Added undefines.
--  000417  SHVE   Changed the comments for the method Get_Parameter_Value1.
--  000330  ANLASE Removed code regarding parameter_code 'PICKING LEADTIME',
--                 this is now an attribute in site_tab.
--  000117  SHVE   Removed code to support 'PURCHASE_VALUE_METHOD' in Get_Parameter_Value1.
--  990601  ANHO   Removed comma from errormessages.
--  990423  DAZA   General performance improvements.
--  990413  JOHW   Upgraded to performance optimized template.
--  990210  JOHW   Removed code regarding 'ONE_COST_SET' AND 'SUM_STR_CODE'.
--  990205  FRDI   Removed the view MPCCOM_SYSTEM_PARAMETER_IVM
--  990129  FRDI   Removed code regarding 'ALLOW_NEGATIV_ONHAND','PURCHASE_VALUE_METHOD'
--                 which are moved to Site_api. Made workaround for Maintenance 5.3, or earlier,
--                 in Get_Parameter_Value1('PURCHASE_VALUE_METHOD') which is obsolete.
--  980318  JoAn   Support Id 1368 Added checks for integer values > 0 for
--                 PICKING_LEADTIME, DEFAULT_PLAN_DATA_PERIODS and
--                 LEADTIME_RECEIPTS in Unpack_Check_Insert___ and
--                 Unpack_Check_Update___
--  971121  TOOS   Upgrade to F1 2.0
--  970918  GOPE   Made the Get_Parameter_Value1 method not case sensetive
--  970708  NAVE   Added SHORTAGE_HANDLING system parameter.
--  970611  PEKR   Adjusted system parameter 'SO_CREATE_STATUS'.
--  970610  PEKR   Added system parameter 'SO_CREATE_STATUS'.
--  970521  FRMA   Corrected Unpack_Check_Update___ (newrec_ now contains client value).
--                 Replaced cursor Get_Value with function Get_Parameter_Value1 in
--                 procedure Unpack_Check_Update___.
--  970505  PEKR   Added system parameter AUTO_AVAILABILITY_CHECK'
--  970501  JOKE   Added view2 and view3 to be able to show client values in
--                 frmSystemParameter plus altered update procedure.
--  970424  FRMA   Added restriction for ALLOW_NEGATIVE_ONHAND when using FIFO/LIFO.
--  970416  FRMA   Corrected restriction for changing value method.
--  970410  FRMA   Adedd restriction for changing value method to and from FIFO/LIFO.
--  970325  CHAN   Added control when changing system parameter pallet handling
--                 to N.
--  970313  MAGN   Changed tablename from mpc_sysparam to mpccom_system_parameter_tab.
--  970226  MAGN   Uses column rowversion as objversion(timestamp).
--  961214  JOKE   Modified with new workbench default templates.
--  961119  JOBE   Modified for compatibility with workbench.
--  960812  SHVE   Replaced call to Cust_Ord_Print_Control_api with dynamic call.
--  960625  JOKE   Added validation between 'ALLOW_NEGATIV_ONHAND' &
--                 'PURCHASE_VALUE_METHOD' in Unpack_Check_Update.
--  960618  JOKE   Added validation on Parameter_Value1 in Unpack_check_update.
--  960529  JOED   Added function Get_Value and changed Get_Default_Flags to
--                 call this function instead of own cursors.
--  960523  RaKu   Modifyed procedure Get_Default_Flags
--  960523  RaKu   Added procedure Get_Default_Flags
--  960523  JOHNI  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT mpccom_system_parameter_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy_ NUMBER;
BEGIN   
   IF indrec_.parameter_value1 THEN
      IF (newrec_.parameter_code = 'SO_CREATE_STATUS'                OR
          newrec_.parameter_code = 'TRANSACTIONS_PROJECT_TRANSFERS'  OR
          newrec_.parameter_code = 'SHORTAGE_HANDLING'               OR
          newrec_.parameter_code = 'GS1_BARCODE_VALIDATION') THEN
         newrec_.parameter_value1 := Gen_Yes_No_API.Encode(newrec_.parameter_value1);
         Gen_Yes_No_API.Exist(newrec_.parameter_value1);
      ELSIF (newrec_.parameter_code = 'AUTO_AVAILABILITY_CHECK') THEN
         newrec_.parameter_value1 := Gen_Yes_No_Allowed_API.Encode(newrec_.parameter_value1);
         Gen_Yes_No_Allowed_API.Exist(newrec_.parameter_value1);
      ELSIF (newrec_.parameter_code = 'LEADTIME_FACTOR1' OR
             newrec_.parameter_code = 'LEADTIME_FACTOR2' ) THEN
         dummy_                   := TO_NUMBER(newrec_.parameter_value1);
      END IF;
      IF (newrec_.parameter_code = 'PRINT_CONTROL_CODE') THEN
         Cust_Ord_Print_Control_API.Exist(newrec_.parameter_value1);
      ELSIF (newrec_.parameter_code = 'DEFAULT_PLAN_DATA_PERIODS') THEN
         IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
            (newrec_.parameter_value1 < 0)) THEN
            Error_Sys.Record_General(lu_name_,'PLANDATAINTEGER: No of Periods must be an Integer. Negative values not allowed');
         END IF;
      ELSIF (newrec_.parameter_code = 'LEADTIME_RECEIPTS') THEN
         IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
            (newrec_.parameter_value1 < 0)) THEN
            Error_Sys.Record_General(lu_name_,'RECEIPTSINTEGER: Interval number of arrivals must be an Integer. Negative values not allowed');
         END IF;
      ELSIF (newrec_.parameter_code = 'RENTAL_EVENT_SYNCHRO_SITE') THEN
         $IF (Component_Rental_SYS.INSTALLED) $THEN
            newrec_.parameter_value1 := Rental_Event_Synchro_Site_API.Encode(newrec_.parameter_value1);
            Rental_Event_Synchro_Site_API.Exist(newrec_.parameter_value1);
         $ELSE
            NULL;
         $END
      ELSIF (newrec_.parameter_code = 'RENTAL_EVENT_SYNCHRO_COMPANY') THEN
         $IF (Component_Rental_SYS.INSTALLED) $THEN
            newrec_.parameter_value1 := Rental_Event_Synchro_Comp_API.Encode(newrec_.parameter_value1);
            Rental_Event_Synchro_Comp_API.Exist(newrec_.parameter_value1);
         $ELSE
            NULL;
         $END
      ELSIF (newrec_.parameter_code = 'FNC1_ASCII_VALUE') THEN
         $IF (Component_Wadaco_SYS.INSTALLED) $THEN
            IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
               (newrec_.parameter_value1 < 0)) THEN
               Error_Sys.Record_General(lu_name_,'FNC1ASCII: FNC1 ASCCI value must be an Integer. Negative values not allowed');
            END IF;
         $ELSE
            NULL;
         $END
      END IF;
   END IF;
   IF Client_Sys.Item_Exist('PARAMETER_VALUE1_DB', attr_) THEN      
      newrec_.parameter_value1 := Client_Sys.Get_Item_Value('PARAMETER_VALUE1_DB', attr_);
      IF (newrec_.parameter_value1 IS NOT NULL) THEN    
         IF (newrec_.parameter_code = 'PRINT_CONTROL_CODE') THEN
            Cust_Ord_Print_Control_API.Exist(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'AUTO_AVAILABILITY_CHECK') THEN
            Gen_Yes_No_Allowed_API.Exist_Db(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'SO_CREATE_STATUS') THEN
            Gen_Yes_No_API.Exist_Db(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'SHORTAGE_HANDLING') THEN
            Gen_Yes_No_API.Exist_Db(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'TRANSACTIONS_PROJECT_TRANSFERS') THEN
            Gen_Yes_No_API.Exist_Db(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'DEFAULT_PLAN_DATA_PERIODS') THEN
            IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
               (newrec_.parameter_value1 < 0)) THEN
               Error_Sys.Record_General(lu_name_,'PLANDATAINTEGER: No of Periods must be an Integer. Negative values not allowed');
            END IF;
         ELSIF (newrec_.parameter_code = 'LEADTIME_RECEIPTS') THEN
            IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
               (newrec_.parameter_value1 < 0)) THEN
               Error_Sys.Record_General(lu_name_,'RECEIPTSINTEGER: Interval number of arrivals must be an Integer. Negative values not allowed');
            END IF;
         ELSIF (newrec_.parameter_code = 'LEADTIME_FACTOR1' OR
                newrec_.parameter_code = 'LEADTIME_FACTOR2' ) THEN
            dummy_ := TO_NUMBER(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'RENTAL_EVENT_SYNCHRO_SITE') THEN
            $IF (Component_Rental_SYS.INSTALLED) $THEN               
               Rental_Event_Synchro_Site_API.Exist_Db(newrec_.parameter_value1);
            $ELSE
               NULL;
            $END
         ELSIF (newrec_.parameter_code = 'RENTAL_EVENT_SYNCHRO_COMPANY') THEN
            $IF (Component_Rental_SYS.INSTALLED) $THEN               
               Rental_Event_Synchro_Comp_API.Exist_Db(newrec_.parameter_value1);
            $ELSE
               NULL;
            $END
         ELSIF (newrec_.parameter_code = 'FNC1_ASCII_VALUE') THEN
            $IF (Component_Wadaco_SYS.INSTALLED) $THEN
               IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
                  (newrec_.parameter_value1 < 0)) THEN
                  Error_Sys.Record_General(lu_name_,'FNC1ASCII: FNC1 ASCCI value must be an Integer. Negative values not allowed');
               END IF;
            $ELSE
               NULL;
            $END
         ELSIF (newrec_.parameter_code = 'GS1_BARCODE_VALIDATION') THEN
            Gen_Yes_No_API.Exist_Db(newrec_.parameter_value1);
         END IF;
      END IF;
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     mpccom_system_parameter_tab%ROWTYPE,
   newrec_ IN OUT mpccom_system_parameter_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS    
   dummy_ NUMBER;
BEGIN
   -- check the value of indrec_.parameter_value1 here
   IF indrec_.parameter_value1 THEN
      IF (newrec_.parameter_code = 'SO_CREATE_STATUS'                OR
          newrec_.parameter_code = 'TRANSACTIONS_PROJECT_TRANSFERS'  OR
          newrec_.parameter_code = 'SHORTAGE_HANDLING'               OR 
          newrec_.parameter_code = 'GS1_BARCODE_VALIDATION') THEN
         Gen_Yes_No_API.Exist(newrec_.parameter_value1);
         newrec_.parameter_value1 := Gen_Yes_No_API.Encode(newrec_.parameter_value1);  
      ELSIF (newrec_.parameter_code = 'AUTO_AVAILABILITY_CHECK') THEN
            Gen_Yes_No_Allowed_API.Exist(newrec_.parameter_value1);
            newrec_.parameter_value1 := Gen_Yes_No_Allowed_API.Encode(newrec_.parameter_value1);         
      ELSIF (newrec_.parameter_code = 'LEADTIME_FACTOR1' OR
             newrec_.parameter_code = 'LEADTIME_FACTOR2' ) THEN
         dummy_                   := TO_NUMBER(newrec_.parameter_value1);
      ELSIF (newrec_.parameter_code = 'PRINT_CONTROL_CODE') THEN
         Cust_Ord_Print_Control_API.Exist(newrec_.parameter_value1);
      ELSIF (newrec_.parameter_code = 'DEFAULT_PLAN_DATA_PERIODS') THEN
         IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
            (newrec_.parameter_value1 < 0)) THEN
            Error_Sys.Record_General(lu_name_,'PLANDATAINTEGER: No of Periods must be an Integer. Negative values not allowed');
         END IF;
      ELSIF (newrec_.parameter_code = 'LEADTIME_RECEIPTS') THEN
         IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
            (newrec_.parameter_value1 < 0)) THEN
            Error_Sys.Record_General(lu_name_,'RECEIPTSINTEGER: Interval number of arrivals must be an Integer. Negative values not allowed');
         END IF;
      ELSIF (newrec_.parameter_code = 'RENTAL_EVENT_SYNCHRO_SITE') THEN
         $IF (Component_Rental_SYS.INSTALLED) $THEN
            Rental_Event_Synchro_Site_API.Exist(newrec_.parameter_value1);
            newrec_.parameter_value1 := Rental_Event_Synchro_Site_API.Encode(newrec_.parameter_value1);
         $ELSE
            NULL;
         $END
      ELSIF (newrec_.parameter_code = 'RENTAL_EVENT_SYNCHRO_COMPANY') THEN
         $IF (Component_Rental_SYS.INSTALLED) $THEN
            Rental_Event_Synchro_Comp_API.Exist(newrec_.parameter_value1);
            newrec_.parameter_value1 := Rental_Event_Synchro_Comp_API.Encode(newrec_.parameter_value1);
         $ELSE
            NULL;
         $END           
      END IF;
   END IF;
   IF Client_Sys.Item_Exist('PARAMETER_VALUE1_DB', attr_) THEN
      newrec_.parameter_value1 := Client_Sys.Get_Item_Value('PARAMETER_VALUE1_DB', attr_);
      IF (newrec_.parameter_value1 IS NOT NULL) THEN    
         IF (newrec_.parameter_code = 'PRINT_CONTROL_CODE') THEN
            Cust_Ord_Print_Control_API.Exist(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'AUTO_AVAILABILITY_CHECK') THEN
            Gen_Yes_No_Allowed_API.Exist_Db(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'SO_CREATE_STATUS') THEN
            Gen_Yes_No_API.Exist_Db(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'SHORTAGE_HANDLING') THEN
            Gen_Yes_No_API.Exist_Db(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'TRANSACTIONS_PROJECT_TRANSFERS') THEN
            Gen_Yes_No_API.Exist_Db(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'DEFAULT_PLAN_DATA_PERIODS') THEN
            IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
               (newrec_.parameter_value1 < 0)) THEN
               Error_Sys.Record_General(lu_name_,'PLANDATAINTEGER: No of Periods must be an Integer. Negative values not allowed');
            END IF;
         ELSIF (newrec_.parameter_code = 'LEADTIME_RECEIPTS') THEN
            IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
               (newrec_.parameter_value1 < 0)) THEN
               Error_Sys.Record_General(lu_name_,'RECEIPTSINTEGER: Interval number of arrivals must be an Integer. Negative values not allowed');
            END IF;
         ELSIF (newrec_.parameter_code = 'LEADTIME_FACTOR1' OR
                newrec_.parameter_code = 'LEADTIME_FACTOR2' ) THEN
            dummy_ := TO_NUMBER(newrec_.parameter_value1);
         ELSIF (newrec_.parameter_code = 'RENTAL_EVENT_SYNCHRO_SITE') THEN
            $IF (Component_Rental_SYS.INSTALLED) $THEN               
               Rental_Event_Synchro_Site_API.Exist_Db(newrec_.parameter_value1);
            $ELSE
               NULL;
            $END
         ELSIF (newrec_.parameter_code = 'RENTAL_EVENT_SYNCHRO_COMPANY') THEN
            $IF (Component_Rental_SYS.INSTALLED) $THEN               
               Rental_Event_Synchro_Comp_API.Exist_Db(newrec_.parameter_value1);
            $ELSE
               NULL;
            $END
         ELSIF (newrec_.parameter_code = 'GS1_BARCODE_VALIDATION') THEN
            Gen_Yes_No_API.Exist_Db(newrec_.parameter_value1);
         END IF;
      END IF;
   END IF;
   
   IF newrec_.parameter_code = 'TRANSACTIONS_PROJECT_TRANSFERS' 
       AND newrec_.parameter_value1 = 'N' AND oldrec_.parameter_value1 = 'Y' THEN
      Error_Sys.Record_General(lu_name_, 'PROJECT_TRANSFERS: Transactions for project transfers cannot be turned off.');
   ELSIF (newrec_.parameter_code = 'FNC1_ASCII_VALUE') THEN
      $IF (Component_Wadaco_SYS.INSTALLED) $THEN
         IF (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR
            (newrec_.parameter_value1 < 0)) THEN
            Error_Sys.Record_General(lu_name_,'FNC1ASCII: FNC1 ASCCI value must be an Integer. Negative values not allowed');
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     Mpccom_System_Parameter_Tab%ROWTYPE,
   newrec_ IN OUT Mpccom_System_Parameter_Tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF ((newrec_.parameter_code = 'CAPABLE_BINS_FOR_LARGE_ZONES') AND 
       (((TO_NUMBER(newrec_.parameter_value1) - TRUNC(TO_NUMBER(newrec_.parameter_value1))) <> 0) OR (newrec_.parameter_value1 < 0))) THEN
      Error_Sys.Record_General(lu_name_, 'WH_INDEX_INTEGER: Warehouse index must be an integer. Negative values not allowed.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Or_Update__
--   Insert or Update LU rec.
PROCEDURE Insert_Or_Update__ (
   rec_ IN MPCCOM_SYSTEM_PARAMETER_TAB%ROWTYPE )
IS
   dummy_        VARCHAR2(1);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   indrec_       Indicator_Rec;   
   newrec_       MPCCOM_SYSTEM_PARAMETER_TAB%ROWTYPE;
   oldrec_       MPCCOM_SYSTEM_PARAMETER_TAB%ROWTYPE;
   CURSOR Exist IS
      SELECT 'X'
      FROM MPCCOM_SYSTEM_PARAMETER_TAB
      WHERE parameter_code = rec_.parameter_code;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);

   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      Client_SYS.Add_To_Attr('PARAMETER_CODE', rec_.parameter_code, attr_);
      Client_SYS.Add_To_Attr('PARAMETER_VALUE1_DB', rec_.parameter_value1, attr_);     
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      
      IF rec_.parameter_value_blob IS NOT NULL THEN
         Write_Parameter_Value_Blob__(objversion_, objid_, rec_.parameter_value_blob);
      END IF;
   ELSE
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.parameter_code);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
      
      IF rec_.parameter_value_blob IS NOT NULL THEN
         Write_Parameter_Value_Blob__(objversion_, objid_, rec_.parameter_value_blob);
      END IF;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('MPCCOM',
                                                      'MpccomSystemParameter',
                                                      rec_.parameter_code,
                                                      rec_.description);
END Insert_Or_Update__;


PROCEDURE Write_Default_Folder_Image__ (
   objversion_ IN OUT NOCOPY VARCHAR2,
   rowid_      IN     ROWID,
   lob_loc_    IN     BLOB )
IS
BEGIN
      UPDATE mpccom_system_parameter_tab
      SET parameter_value_blob = lob_loc_,
          rowversion       = sysdate
      WHERE parameter_code = 'WADACO_FOLDER_IMAGE';
END Write_Default_Folder_Image__;


PROCEDURE Write_Default_Process_Image__ (
   objversion_ IN OUT NOCOPY VARCHAR2,
   rowid_      IN     ROWID,
   lob_loc_    IN     BLOB )
IS
BEGIN
     UPDATE mpccom_system_parameter_tab
      SET parameter_value_blob = lob_loc_,
          rowversion       = sysdate
      WHERE parameter_code = 'WADACO_PROCESS_IMAGE';
END Write_Default_Process_Image__;







-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


