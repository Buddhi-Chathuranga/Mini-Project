-----------------------------------------------------------------------------
--
--  Logical unit: FndcgProjectionSvcTypes
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Entity_Dec IS RECORD (
   etag                           VARCHAR2(100),
   info                           VARCHAR2(4000),
   attr                           VARCHAR2(32000));

TYPE Entity_Small_Dec IS RECORD (
   etag                           VARCHAR2(100),
   info                           VARCHAR2(4000),
   attr                           VARCHAR2(4000));

TYPE Entity_Small_Drr      IS TABLE OF Entity_Small_Dec;
TYPE Entity_Drr      IS TABLE OF Entity_Dec;
TYPE Objid_Arr       IS TABLE OF VARCHAR2(100);
TYPE Objid_Art       IS TABLE OF VARCHAR2(100);
TYPE Empty_Art       IS TABLE OF VARCHAR2(1);

TYPE Alpha_Arr       IS TABLE OF DATE;
TYPE Alpha_Art       IS TABLE OF DATE;
TYPE Binary_Arr      IS TABLE OF BLOB;
TYPE Binary_Art      IS TABLE OF BLOB;
TYPE Boolean_Arr     IS TABLE OF BOOLEAN;
TYPE Boolean_Art     IS TABLE OF VARCHAR2(5);
TYPE Date_Arr        IS TABLE OF DATE;
TYPE Date_Art        IS TABLE OF DATE;
TYPE Entity_Arr      IS TABLE OF VARCHAR2(100); --List of objid's
TYPE Entity_Art      IS TABLE OF VARCHAR2(100); --List of objid's
TYPE Enumeration_Arr IS TABLE OF VARCHAR2(100);
TYPE Enumeration_Art IS TABLE OF VARCHAR2(100);
TYPE GUID_Arr        IS TABLE OF VARCHAR2(100);
TYPE GUID_Art        IS TABLE OF VARCHAR2(100);
TYPE Identity_Arr    IS TABLE OF NUMBER;
TYPE Identity_Art    IS TABLE OF NUMBER;
TYPE Integer_Arr     IS TABLE OF INTEGER;
TYPE Integer_Art     IS TABLE OF INTEGER;
TYPE Long_Text_Arr   IS TABLE OF CLOB;
TYPE Long_Text_Art   IS TABLE OF CLOB;
TYPE Lookup_Arr      IS TABLE OF VARCHAR2(100);
TYPE Lookup_Art      IS TABLE OF VARCHAR2(100);
TYPE Number_Arr      IS TABLE OF NUMBER;
TYPE Number_Art      IS TABLE OF NUMBER;
TYPE Text_Arr        IS TABLE OF VARCHAR2(4000);
TYPE Text_Art        IS TABLE OF VARCHAR2(4000);
TYPE Time_Arr        IS TABLE OF DATE;
TYPE Time_Art        IS TABLE OF DATE;
TYPE Timestamp_Arr   IS TABLE OF DATE;
TYPE Timestamp_Art   IS TABLE OF DATE;
TYPE Stream_Arr      IS TABLE OF BLOB;
TYPE Stream_Art      IS TABLE OF BLOB;

TYPE Stream_Data_Ret IS RECORD (
   file_name                           VARCHAR2(100),
   mime_type                           VARCHAR2(100),
   stream_data                         BLOB);

TYPE Stream_Data_Art IS TABLE OF Stream_Data_Ret;

TYPE Stream_Data_Rec IS RECORD (
   file_name                           VARCHAR2(100),
   mime_type                           VARCHAR2(100),
   stream_data                         BLOB);

TYPE Stream_Data_Arr IS TABLE OF Stream_Data_Rec;

TYPE Stream_Info_Rec IS RECORD (
   file_name                           VARCHAR2(100),
   mime_type                           VARCHAR2(100));

TYPE Stream_Text_Data_Rec IS RECORD (
   file_name                           VARCHAR2(100),
   mime_type                           VARCHAR2(100),
   stream_data                         CLOB);

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
