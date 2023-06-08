-----------------------------------------------------------------------------
--
--  Logical unit: GenYesNo
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  141122  MeAblk  Added new methods Data_Capt_Item_Value_Exist, Get_Data_Capt_Item_Value_Desc.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- This method is used by DataCaptCreateHndlUnit, DataCaptDeleteHndlUnit, DataCaptModifyHndlUnit, DataCaptureInventUtil,
-- DataCaptReportPickPart, DataCaptRecvDispAdvice, DataCaptRecvHuDispAdv, DataCaptReassHuShip, DataCaptRecSo,
-- DataCaptRecSoHu, DataCaptRepPickPartSo, DataCaptureShopordUtil, DataCaptManIssueWo and DataCaptUnissueWo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   capture_session_id_ IN NUMBER )
IS
   TYPE Client_Value_Tab IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   client_value_tab_   Client_Value_Tab;
   client_value_       VARCHAR2(2000);
   index_              NUMBER := 0;
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_ NUMBER;
   exit_lov_           BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      LOOP
         client_value_ := Get_Client_Value(index_);
         EXIT WHEN client_value_ IS NULL;
         index_ := index_ + 1;
         client_value_tab_(index_) := client_value_;
      END LOOP;
      FOR i IN client_value_tab_.FIRST..client_value_tab_.LAST LOOP
         Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                          capture_session_id_    => capture_session_id_,
                                          lov_item_value_        => client_value_tab_(i),
                                          lov_item_description_  => NULL,
                                          lov_row_limitation_    => lov_row_limitation_,    
                                          session_rec_           => session_rec_);
         EXIT WHEN exit_lov_;
      END LOOP;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


PROCEDURE Data_Capt_Item_Value_Exist (
   data_item_value_  IN VARCHAR2 )
IS
BEGIN
   IF data_item_value_ IN ('Y', 'N') THEN
      NULL;
   ELSE
      Exist_Db(data_item_value_);
   END IF;
END Data_Capt_Item_Value_Exist;


@UncheckedAccess
FUNCTION Get_Data_Capt_Item_Value_Desc (
   data_item_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ VARCHAR2(50);
BEGIN
   IF (data_item_value_ = 'Y') THEN
      description_ :=  SUBSTR(Get_Client_Value(0),1,50);
   ELSIF (data_item_value_ = 'N') THEN
      description_ :=  SUBSTR(Get_Client_Value(1),1,50);
   END IF; 
   RETURN description_;
END Get_Data_Capt_Item_Value_Desc; 
