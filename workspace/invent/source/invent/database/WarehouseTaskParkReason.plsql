-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseTaskParkReason
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   --------------------------------------------------------
--  200311  DaZase   SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  150729  BudKlk   Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729           method call in ORDER BY clause to sort string and number values seperately.
--  150527  DaZase   COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  141014  JeLise   Added Create_Data_Capture_Lov.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- This method is used by DataCaptParkWhseTask
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   capture_session_id_ IN NUMBER )
IS
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;

   CURSOR get_park_reason IS
     SELECT park_reason_id, description
     FROM warehouse_task_park_reason_tab
     ORDER BY Utility_SYS.String_To_Number(park_reason_id) ASC, park_reason_id ASC;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      FOR rec_ IN get_park_reason LOOP
         Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                          capture_session_id_    => capture_session_id_,
                                          lov_item_value_        => rec_.park_reason_id,
                                          lov_item_description_  => rec_.description,
                                          lov_row_limitation_    => lov_row_limitation_,    
                                          session_rec_           => session_rec_);
         EXIT WHEN exit_lov_;
      END LOOP;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


