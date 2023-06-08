-----------------------------------------------------------------------------
--
--  Logical unit: FndConditionalFormat
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
 format_url_    VARCHAR2(500);
 user_id_       VARCHAR2(10);
 format_key_    VARCHAR2(500);
 priority_      NUMBER;
   
BEGIN
   format_url_   := Client_SYS.Get_Item_Value( 'FORMAT_URL', attr_ );
   user_id_      := Client_SYS.Get_Item_Value( 'USER_ID', attr_ );
   format_key_   := format_url_ || '/' || user_id_ || '/' || sys_guid();
   priority_     := Get_Next_Sequence_Number(format_url_, user_id_);
   super(attr_);
   Client_SYS.Add_To_Attr('FORMAT_KEY', format_key_, attr_);
   Client_SYS.Add_To_Attr('PRIORITY', priority_, attr_);
END Prepare_Insert___;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_Next_Sequence_Number(
   format_url_ IN fnd_conditional_format_tab.format_url%TYPE,
   user_id_ IN fnd_conditional_format_tab.user_id%TYPE) RETURN NUMBER
IS
   current_sequence_ NUMBER;

   CURSOR get_next_priority IS
   SELECT MAX(fnd_conditional_format_tab.priority)
   FROM   fnd_conditional_format_tab
   WHERE  format_url    = format_url_
   AND    user_id     = user_id_;
BEGIN
   OPEN  get_next_priority;
   FETCH get_next_priority INTO current_sequence_;
   CLOSE get_next_priority;

   IF current_sequence_ IS NULL THEN
      RETURN 1;
   ELSE 
      RETURN current_sequence_ + 1;
   END IF;
END Get_Next_Sequence_Number;
