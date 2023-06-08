-----------------------------------------------------------------------------
--
--  Logical unit: UserClientProfileReplSend
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

-------------------- REPLICATION SEND PRIVATE METHODS ----------------------------


-------------------- REPLICATION SEND PROTECTED METHODS --------------------------


-------------------- REPLICATION SEND PUBLIC METHODS -----------------------------
@Override
PROCEDURE Replicate (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2)
IS
BEGIN
   IF (Is_Base_Profile___(new_attr_) = 1 ) THEN
      super(site_, old_attr_, new_attr_);
   ELSE
      RETURN;
   END IF;
END Replicate;

@Override
PROCEDURE Replicate_Remove (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2 )
IS
BEGIN
   IF (Is_Base_Profile___(old_attr_) = 1 ) THEN
      super(site_, old_attr_);
   ELSE
      RETURN;
   END IF;
END Replicate_Remove;




