-----------------------------------------------------------------------------
--
--  Logical unit: ClientProfileReplSend
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
PROCEDURE Replicate (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2)
IS
   prof_id_ VARCHAR2(50);
   newrec_     Data_Sync_SYS.ReplLobBufRec;
   new_child_attr_                  VARCHAR2(32000);
      CURSOR child_rec_to_replicate (profile_id_ IN VARCHAR2) IS
      SELECT PROFILE_ID,PROFILE_SECTION,PROFILE_ENTRY,PROFILE_VALUE,CATEGORY,OVERRIDE_ALLOWED,MODIFIED_DATE,BINARY_VALUE_TYPE,NVL2(PROFILE_BINARY_VALUE,'TRUE','FALSE' ) CLOB_NOTNULL,ROWKEY
      FROM   FNDRR_CLIENT_PROFILE_VALUE_TAB
      WHERE  PROFILE_ID = profile_id_;
BEGIN
   IF (client_sys.Get_Item_Value('OWNER',new_attr_) IS NULL) THEN
   
      super(site_, old_attr_, new_attr_);
      prof_id_ := client_sys.Get_Item_Value('PROFILE_ID',new_attr_);
      IF (client_sys.Get_Item_Value('PROFILE_ID',old_attr_) IS NULL) THEN
      --replicating child records
      
         FOR rec_ IN child_rec_to_replicate(prof_id_) LOOP
            Client_SYS.Clear_Attr(new_child_attr_);
            newrec_ := NULL;
            Client_SYS.Add_To_Attr('PROFILE_ID', prof_id_, new_child_attr_);
            Client_SYS.Add_To_Attr('PROFILE_SECTION', rec_.PROFILE_SECTION, new_child_attr_);
            Client_SYS.Add_To_Attr('PROFILE_ENTRY', rec_.PROFILE_ENTRY, new_child_attr_);
            Client_SYS.Add_To_Attr('PROFILE_VALUE', rec_.PROFILE_VALUE, new_child_attr_);
            Client_SYS.Add_To_Attr('CATEGORY', rec_.CATEGORY, new_child_attr_);
            Client_SYS.Add_To_Attr('OVERRIDE_ALLOWED', rec_.OVERRIDE_ALLOWED, new_child_attr_);
            Client_SYS.Add_To_Attr('MODIFIED_DATE', rec_.MODIFIED_DATE, new_child_attr_);
            Client_SYS.Add_To_Attr('BINARY_VALUE_TYPE_DB', rec_.BINARY_VALUE_TYPE, new_child_attr_);
            Client_Profile_Value_RSP.Replicate_Forced(site_, NULL, new_child_attr_);
         
            IF (rec_.clob_notnull ='TRUE') THEN
               newrec_.rowkey_field    := rec_.rowkey;
               newrec_.lu_name         := 'ClientProfileValue';
               newrec_.lob_field       := 'PROFILE_BINARY_VALUE';
               newrec_.site            := site_;
               newrec_.state           := 'Released';
               newrec_.lob_type        := 'CLOB';
            
               Data_Sync_SYS.Insert_Or_Update_Rec(newrec_);
            END IF;
         
         END LOOP; 
      END IF;

   END IF;
   
END;

@Override
PROCEDURE Replicate_Remove (
   site_         IN VARCHAR2,
   key_attr_     IN VARCHAR2,
   non_key_attr_ IN VARCHAR2)
IS
BEGIN
   IF (client_sys.Get_Item_Value('OWNER',non_key_attr_) IS NULL) THEN
      super(site_, key_attr_, non_key_attr_);
   END IF;
END Replicate_Remove;




