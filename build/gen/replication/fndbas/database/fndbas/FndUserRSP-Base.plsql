-----------------------------------------------------------------------------
--
--  Logical unit: FndUser Repl
--  Component:    FNDBAS
--
--  Template:     3.0
--  Built by:     IFS Developer Studio (unit-test)
--
--  NOTE! Do not edit!! This file is completely generated and will be
--        overwritten next time the corresponding model is saved.
-----------------------------------------------------------------------------

layer Base;


FUNCTION Create_Hub_Xml_String___ (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2) RETURN CLOB
IS
   xml_string_          CLOB;
BEGIN
   xml_string_ :=
      '<REPLICATION>
         <LU_NAME>FndUser</LU_NAME>
         <PACKAGE_NAME>Fnd_User_RRP</PACKAGE_NAME>
         <METHOD_TYPE>NewModify</METHOD_TYPE>
         <SITE>' || site_ || '</SITE>
         <USER_ID>' || Fnd_Session_API.Get_Fnd_User || '</USER_ID>
         <SENDER_MESSAGE_ID></SENDER_MESSAGE_ID>
         <ATTRIBUTES>
            <NEW_RECORD>'|| Data_Sync_SYS.Encode_Characters(new_attr_)|| '</NEW_RECORD>
            <OLD_RECORD>'|| Data_Sync_SYS.Encode_Characters(old_attr_)|| '</OLD_RECORD>
         </ATTRIBUTES>
      </REPLICATION>';

   RETURN xml_string_;
END Create_Hub_Xml_String___;


FUNCTION Create_Sat_Xml_String___ (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2) RETURN CLOB
IS
   xml_string_          CLOB;
   external_message_id_ NUMBER;
   sender_message_id_   NUMBER;
BEGIN
   xml_string_ :=
      '<REPLICATION>
         <LU_NAME>FndUser</LU_NAME>
         <PACKAGE_NAME>Fnd_User_RRP</PACKAGE_NAME>
         <METHOD_TYPE>NewModify</METHOD_TYPE>
         <SITE>' || site_ || '</SITE>
         <USER_ID>' || Fnd_Session_API.Get_Fnd_User || '</USER_ID>
         <SENDER_MESSAGE_ID>' || sender_message_id_ || '</SENDER_MESSAGE_ID>
         <ATTRIBUTES>
            <NEW_RECORD>'|| Data_Sync_SYS.Encode_Characters(new_attr_)|| '</NEW_RECORD>
            <OLD_RECORD>'|| Data_Sync_SYS.Encode_Characters(old_attr_)|| '</OLD_RECORD>
         </ATTRIBUTES>
      </REPLICATION>';

   RETURN xml_string_;
END Create_Sat_Xml_String___;



FUNCTION Create_Remove_Hub_Xml_Str___ (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2 ) RETURN CLOB
IS
   xml_string_          CLOB;
BEGIN
   xml_string_ :=
      '<REPLICATION>
         <LU_NAME>FndUser</LU_NAME>
         <PACKAGE_NAME>Fnd_User_RRP</PACKAGE_NAME>
         <METHOD_TYPE>Remove</METHOD_TYPE>
         <SITE>' || site_ || '</SITE>
         <USER_ID>' || Fnd_Session_API.Get_Fnd_User || '</USER_ID>
         <SENDER_MESSAGE_ID></SENDER_MESSAGE_ID>
         <ATTRIBUTES>
            <NEW_RECORD>'|| Data_Sync_SYS.Encode_Characters(old_attr_)|| '</NEW_RECORD>
            <OLD_RECORD>'|| Data_Sync_SYS.Encode_Characters(old_attr_)|| '</OLD_RECORD>
         </ATTRIBUTES>
      </REPLICATION>';

   RETURN xml_string_;
END Create_Remove_Hub_Xml_Str___;


FUNCTION Create_Remove_Sat_Xml_Str___ (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2 ) RETURN CLOB
IS
   xml_string_          CLOB;
BEGIN
   xml_string_ :=
      '<REPLICATION>
         <LU_NAME>FndUser</LU_NAME>
         <PACKAGE_NAME>Fnd_User_RRP</PACKAGE_NAME>
         <METHOD_TYPE>Remove</METHOD_TYPE>
         <SITE>' || site_ || '</SITE>
         <USER_ID>' || Fnd_Session_API.Get_Fnd_User || '</USER_ID>
         <SENDER_MESSAGE_ID></SENDER_MESSAGE_ID>
         <ATTRIBUTES>
            <NEW_RECORD>'|| Data_Sync_SYS.Encode_Characters(old_attr_)|| '</NEW_RECORD>
            <OLD_RECORD>'|| Data_Sync_SYS.Encode_Characters(old_attr_)|| '</OLD_RECORD>
         </ATTRIBUTES>
      </REPLICATION>';

   RETURN xml_string_;
END Create_Remove_Sat_Xml_Str___;


-------- SENDING --------

PROCEDURE Replicate (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2)
IS
   xml_string_          CLOB;
   external_message_id_ NUMBER;
   sender_message_id_   NUMBER;
BEGIN
   IF Data_Sync_SYS.Get_Value('INSTALLATION','LOCATION') = 'HUB' THEN
      xml_string_ := Create_Hub_Xml_String___(site_, old_attr_, new_attr_);
   ELSE
      RETURN;
   END IF;

   IF xml_string_ IS NOT NULL THEN
      Data_Sync_SYS.Send_Repl_Data_Clob(
             'FndUser',
             site_,
             'NewModify',
             xml_string_);
   END IF;
END Replicate;

PROCEDURE Replicate_Remove (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2 )
IS
   xml_string_          CLOB;
   sender_message_id_   NUMBER;
   external_message_id_ NUMBER;
BEGIN
   IF Data_Sync_SYS.Get_Value('INSTALLATION','LOCATION') = 'HUB' THEN
      xml_string_ := Create_Remove_Hub_Xml_Str___(site_, old_attr_);
   ELSE
      RETURN;
   END IF;

   IF xml_string_ IS NOT NULL THEN
      Data_Sync_SYS.Send_Repl_Data_Clob(
                 'FndUser',
                 site_,
                 'Remove',
                 xml_string_);
   END IF;
END Replicate_Remove;


PROCEDURE Replicate_Remove (
   site_ IN VARCHAR2,
   key_attr_ IN VARCHAR2,
   non_key_attr_ IN VARCHAR2)
IS
BEGIN
   Replicate_Remove(site_,key_attr_);
END Replicate_Remove;


PROCEDURE Replicate_Lob (
   site_           IN VARCHAR2,
   lob_field_name_ IN VARCHAR2,
   new_attr_       IN VARCHAR2,
   new_clob_       IN CLOB,
   old_clob_       IN CLOB )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(4000);
   newrec_     Data_Sync_SYS.ReplLobBufRec;
   lob_compare_ NUMBER;

BEGIN
   IF new_clob_ IS NOT NULL OR old_clob_ IS NOT NULL THEN
      lob_compare_ := DBMS_LOB.Compare(new_clob_, old_clob_);
      IF lob_compare_ IS NULL OR lob_compare_ != 0 THEN
         newrec_.rowkey_field    := Client_SYS.Get_Item_Value('ROWKEY',new_attr_);
         newrec_.lu_name         := 'FndUser';
         newrec_.lob_field       := lob_field_name_;
         newrec_.site            := site_;
         newrec_.state           := 'Released';
         newrec_.lob_type        := 'CLOB';

         Data_Sync_SYS.Insert_Or_Update_Rec(newrec_);
      END IF;
   ELSE
      RETURN;
   END IF;
END Replicate_Lob;


PROCEDURE Replicate_Lob (
   site_           IN VARCHAR2,
   lob_field_name_ IN VARCHAR2,
   new_attr_       IN VARCHAR2,
   new_blob_       IN BLOB,
   old_blob_       IN BLOB )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(4000);
   newrec_     Data_Sync_SYS.ReplLobBufRec;
   lob_compare_ NUMBER;

BEGIN
   IF new_blob_ IS NOT NULL OR old_blob_ IS NOT NULL THEN
      lob_compare_ := DBMS_LOB.Compare(new_blob_, old_blob_);
      IF lob_compare_ IS NULL OR lob_compare_ != 0 THEN
         newrec_.rowkey_field    := Client_SYS.Get_Item_Value('ROWKEY',new_attr_);
         newrec_.lu_name         := 'FndUser';
         newrec_.lob_field       := lob_field_name_;
         newrec_.site            := site_;
         newrec_.state           := 'Released';
         newrec_.lob_type        := 'BLOB';

         Data_Sync_SYS.Insert_Or_Update_Rec(newrec_);
      END IF;
   ELSE
      RETURN;
   END IF;
END Replicate_Lob;

----- Methods for UPD 4
FUNCTION Get_Key_Fields (
    view_column_names_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN VARCHAR2
IS
BEGIN
    IF(view_column_names_ = 'TRUE') THEN
        return 'IDENTITY';
    ELSE
        return 'IDENTITY';
    END IF;
END Get_Key_Fields;


FUNCTION Get_Site_Field (
    view_column_name_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN VARCHAR2
IS
BEGIN
    IF(view_column_name_ = 'TRUE') THEN
       return '*';
    ELSE
       return '*';
    END IF;
END Get_Site_Field;


