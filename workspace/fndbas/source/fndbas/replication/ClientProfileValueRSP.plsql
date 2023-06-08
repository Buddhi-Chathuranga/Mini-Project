-----------------------------------------------------------------------------
--
--  Logical unit: ClientProfileValueReplSend
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- REPLICATION SEND IMPLEMENTATION METHODS ---------------------


-------------------- REPLICATION SEND PRIVATE METHODS ----------------------------


-------------------- REPLICATION SEND PROTECTED METHODS --------------------------


-------------------- REPLICATION SEND PUBLIC METHODS -----------------------------
@Override
PROCEDURE Replicate_Lob (
   site_           IN VARCHAR2,
   lob_field_name_ IN VARCHAR2,
   new_attr_       IN VARCHAR2,
   new_clob_       IN CLOB,
   old_clob_       IN CLOB )
IS
BEGIN
   
   IF (Is_Base_Profile___(new_attr_) = 1 ) THEN
      super(site_,lob_field_name_,new_attr_,new_clob_, old_clob_);
   END IF;
END Replicate_Lob;

@Override
PROCEDURE Replicate (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2)
IS
BEGIN
   IF (Is_Base_Profile___(new_attr_) = 1 ) THEN
      super(site_, old_attr_, new_attr_);
   END IF;
END Replicate;



PROCEDURE Replicate_Forced (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2)

IS
      xml_string_          CLOB;
BEGIN
      IF Data_Sync_SYS.Get_Value('INSTALLATION','LOCATION') = 'HUB' THEN
         xml_string_ := Create_Hub_Xml_String___(site_, old_attr_, new_attr_);
      ELSE
         xml_string_ := Create_Sat_Xml_String___(site_, old_attr_, new_attr_);
      END IF;
   
      IF xml_string_ IS NOT NULL THEN
         Data_Sync_SYS.Send_Repl_Data_Clob(
                'ClientProfileValue',
                site_,
                'NewModify',
                xml_string_);
      END IF;
END Replicate_Forced;


@Override
PROCEDURE Replicate_Remove (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2 )
IS
BEGIN
   IF (Is_Base_Profile___(old_attr_) = 1 ) THEN
      super(site_, old_attr_);
   END IF;
END Replicate_Remove;

FUNCTION Is_Base_Profile___ (
   new_attr_ IN VARCHAR2) RETURN NUMBER
IS
   dummy_        NUMBER;
   profile_id_   VARCHAR2(50);
BEGIN
   profile_id_:=client_sys.Get_Item_Value('PROFILE_ID',new_attr_) ;
        SELECT 1 INTO dummy_
        FROM fndrr_client_profile_tab t
        WHERE profile_id = profile_id_
        AND owner IS NULL;
        
        RETURN dummy_;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       RETURN 0;       
END Is_Base_Profile___;