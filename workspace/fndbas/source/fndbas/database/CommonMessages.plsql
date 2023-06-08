-----------------------------------------------------------------------------
--
--  Logical unit: CommonMessages
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


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Dates___(
   effective_from_ IN DATE,
   expires_on_     IN DATE)
IS
BEGIN   
   IF (effective_from_ > expires_on_) THEN
       Error_SYS.Appl_General(lu_name_,'INVALID_DATES: Expire date must be greater then Effective From date.');
   END IF;
END Check_Dates___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   temp_field_ NUMBER;
   CURSOR get_sequence_ IS
      SELECT common_messages_id_sequence.NEXTVAL
      FROM dual;
BEGIN
   OPEN get_sequence_;
   FETCH get_sequence_ INTO temp_field_;
   CLOSE get_sequence_;
   super(attr_);
   Client_SYS.Add_To_Attr('MESSAGE_ID', temp_field_, attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     common_messages_tab%ROWTYPE,
   newrec_ IN OUT common_messages_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.effective_from IS NULL) THEN
      newrec_.effective_from := SYSDATE;
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   Check_Dates___(newrec_.effective_from, newrec_.expires_on);
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Is_Message_Active (
   message_id_ IN NUMBER) RETURN VARCHAR2
IS
   count_ NUMBER;
   CURSOR get_count_ IS
      SELECT count(*) 
      FROM common_messages
      WHERE message_id = message_id_
      AND effective_from <= sysdate
      AND expires_on > sysdate;
BEGIN
   OPEN get_count_;
   FETCH get_count_ INTO count_;
   CLOSE get_count_;

   IF (count_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Message_Active;


@UncheckedAccess
FUNCTION Is_Message_Expired (
   message_id_ IN NUMBER) RETURN VARCHAR2
IS
   count_ NUMBER;
   CURSOR get_count_ IS
      SELECT count(*) 
      FROM common_messages
      WHERE message_id = message_id_
      AND expires_on < sysdate;
BEGIN
   OPEN get_count_;
   FETCH get_count_ INTO count_;
   CLOSE get_count_;

   IF (count_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Message_Expired;


