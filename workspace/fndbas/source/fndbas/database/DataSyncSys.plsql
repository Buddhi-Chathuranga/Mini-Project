-----------------------------------------------------------------------------
--
--  Logical unit: DataSyncSys
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE ReplLobBufRec IS RECORD (
     lob_buffer_id   VARCHAR2(50),
     lu_name         VARCHAR2(30),
     lob_field       VARCHAR2(30),
     rowkey_field    VARCHAR2(50),
     site            VARCHAR2(30),
     state           VARCHAR2(30),
     lob_type        VARCHAR2(5)
     );
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Send_Repl_Data_Clob(
   lu_name_             IN VARCHAR2,
   site_                IN VARCHAR2,
   method_type_         IN VARCHAR2,
   xml_data_            IN CLOB)
IS 
BEGIN
$IF Component_Fndrpl_SYS.INSTALLED $THEN
   Repl_Connect_Util_API.Send_Repl_Data_Clob(lu_name_, site_, method_type_, xml_data_);
$ELSE
   NULL;
$END
END Send_Repl_Data_Clob;


FUNCTION Encode_Characters(
   attr_      IN VARCHAR2)RETURN VARCHAR2
IS 
BEGIN
$IF Component_Fndrpl_SYS.INSTALLED $THEN
   RETURN Repl_Connect_Util_API.Encode_Characters(attr_);
$ELSE
   RETURN NULL;
$END

END Encode_Characters; 

PROCEDURE Insert_Or_Update_Rec(
    newrec_ IN Data_Sync_SYS.ReplLobBufRec)
IS 
BEGIN
$IF Component_Fndrpl_SYS.INSTALLED $THEN
    Repl_Lob_Buffer_API.Insert_Or_Update_Rec(newrec_);
$ELSE
   NULL;
$END
END Insert_Or_Update_Rec;

PROCEDURE Init_All_Processes__ 
IS
BEGIN
   $IF Component_Fndrpl_SYS.INSTALLED $THEN
      Repl_Config_Util_API.Init_All_Processes__(0);
   $ELSE
      NULL;
   $END
END Init_All_Processes__;

FUNCTION get_property_value(
    property_name_ IN VARCHAR2,
    property_type_ IN VARCHAR2) RETURN VARCHAR2
IS 
BEGIN
$IF Component_Fndrpl_SYS.INSTALLED $THEN
    RETURN repl_property_api.get_property_value(property_type_,property_name_);
$ELSE
   RETURN NULL;
$END
END get_property_value;

FUNCTION Get_Value (
   property_type_    IN VARCHAR2,
   property_name_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndrpl_SYS.INSTALLED $THEN
      RETURN Repl_Property_API.Get_Value(property_type_, property_name_);
   $ELSE
      RETURN NULL;
   $END
END Get_Value;

FUNCTION Get_Distinct_Site_List (
   separator_      IN VARCHAR2 DEFAULT ',') RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndrpl_SYS.INSTALLED $THEN
      RETURN Repl_Satellite_Site_API.Get_Distinct_Site_List(separator_);
   $ELSE
      RETURN NULL;
   $END
END Get_Distinct_Site_List;   

FUNCTION Get_Satellite_List (
   separator_      IN VARCHAR2 DEFAULT ',') RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndrpl_SYS.INSTALLED $THEN
      RETURN Repl_Satellite_API.Get_Satellite_List(separator_);
   $ELSE
      RETURN NULL;
   $END
END Get_Satellite_List;   

FUNCTION Get_Hq_Site_List (
   separator_      IN VARCHAR2 DEFAULT ',') RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndrpl_SYS.INSTALLED $THEN
      RETURN Repl_Hq_Site_API.Get_Hq_Site_List(separator_);
   $ELSE
      RETURN NULL;
   $END
END Get_Hq_Site_List;  

PROCEDURE Skip_Processing_Message(
   error_msg_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   $IF Component_Fndrpl_SYS.INSTALLED $THEN
      Repl_Connect_Util_API.Skip_Processing_Message(error_msg_);
   $ELSE
      NULL;
   $END
END Skip_Processing_Message;
