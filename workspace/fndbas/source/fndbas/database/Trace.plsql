-----------------------------------------------------------------------------
--
--  Logical unit: Trace
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950301  MADR    Copied from CMS-Tumba into EVEREST prototyping
--  950418  ERFO    Minor changes to follow minimum of EVEREST-standards
--  950523  ERFO    Renamed to Trace_SYS, removed define symbols
--  950823  ERFO    Removed dependencies to SYSTEM4 System
--  960325  ERFO    Added method to support console logging (Idea #462).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030317  ROOD    Added methods Set_Method_Trace and Put_Line (ToDo#4143).
--  070516  HAAR    Changed method Set_Buffer_Size to handle unlimited lines (Bug#64423)
--  190508  RAKUSE  Added method Attr to be used with attribute strings  (TEUXXCC-2153)
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

global_package_id_  CONSTANT NATURAL := 1;
trigger_package_id_ CONSTANT NATURAL := 2;

-------------------- PRIVATE DECLARATIONS -----------------------------------

type name_table IS table of VARCHAR2(128)  index by NATURAL;
type bool_table IS table of BOOLEAN        index by NATURAL;
type int_table  IS table of binary_integer index by NATURAL;
long_date_format_ CONSTANT VARCHAR2(30) := 'yymmdd hh24:mi:ss';
trace_line_size_  CONSTANT NATURAL := 80;
indent_size_      CONSTANT NATURAL := 3;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Message (
   msg_        VARCHAR2,
   channel_id_ NATURAL DEFAULT 2 )
IS
BEGIN
   put_field( msg_ );
/*
   IF main_switch and current_switch THEN
      IF get_channel_switch(channel_id_) THEN
         put_field( msg_ );
      END IF;
   END IF;
*/
END Message;


@UncheckedAccess
PROCEDURE Label (
   id_         VARCHAR2,
   channel_id_ NATURAL DEFAULT 2 )
IS
BEGIN
   put_field( '<<' || id_ || '>>' );
/*
   label_stack(stack_top) := substr(id,1,128);
   IF main_switch and current_switch THEN
      IF get_channel_switch(channel_id_) THEN
         put_field( '<<' || id_ || '>>' );
      END IF;
   END IF;
*/
END Label;


@UncheckedAccess
PROCEDURE Field (
   name_       VARCHAR2,
   value_      VARCHAR2,
   channel_id_ NATURAL := 3 )
IS
BEGIN
   put_field( name_ || ' = ' || image(value_) );
/*
   IF main_switch and current_switch THEN
      IF get_channel_switch(channel_id_) THEN
         put_field( name_ || ' = ' || image(value_) );
      END IF;
   END IF;
*/
END Field;


@UncheckedAccess
PROCEDURE Field (
   name_       VARCHAR2,
   value_      NUMBER,
   channel_id_ NATURAL := 3 )
IS
BEGIN
   put_field( name_ || ' = ' || image(value_) );
/*
   IF main_switch and current_switch THEN
      IF get_channel_switch(channel_id_) THEN
         put_field( name_ || ' = ' || image(value_) );
      END IF;
   END IF;
*/
END Field;


@UncheckedAccess
PROCEDURE Field (
   name_       VARCHAR2,
   value_      DATE,
   channel_id_ NATURAL := 3 )
IS
BEGIN
   put_field( name_ || ' = ' || image(value_) );
/*
   IF main_switch and current_switch THEN
      IF get_channel_switch(channel_id_) THEN
         put_field( name_ || ' = ' || image(value_) );
     END IF;
   END IF;
*/
END Field;


@UncheckedAccess
PROCEDURE Field (
   name_       VARCHAR2,
   value_      BOOLEAN,
   channel_id_ NATURAL := 3 )
IS
BEGIN
   put_field( name_ || ' = ' || image(value_) );
/*
   IF main_switch and current_switch THEN
      IF get_channel_switch(channel_id_) THEN
         put_field( name_ || ' = ' || image(value_) );
      END IF;
   END IF;
*/
END Field;

@UncheckedAccess
PROCEDURE Attribute_String (
   attr_ IN VARCHAR2,
   attr_name_ IN VARCHAR2 DEFAULT '') 
IS
   len_   VARCHAR2(6) := 'NULL';
   ptr_   NUMBER := NULL;
   count_ NUMBER := 0;
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
   tmp_   VARCHAR2(32);
BEGIN
   IF (attr_ IS NOT NULL) THEN
      len_ := LENGTH(attr_);
   END IF;
   IF (attr_name_ IS NOT NULL) THEN
      tmp_ := '''' || attr_name_ || ''' ';
   END IF;
   Message('--- Attribute String ' || tmp_ || 'Begin --- (Length=' || len_ ||')');
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
   count_ := count_ + 1;
      Field(count_ || '. ' || name_, value_);
   END LOOP;
   Message('--- Attribute String End ---');
END Attribute_String;

-- Put_Line
--   Put a trace output through service DBMS_OUTPUT including
--   timestamp information to be used from the console in IFS/Client.
@UncheckedAccess
PROCEDURE Put_Line (
   text_ IN VARCHAR2,
   p1_ IN VARCHAR2 DEFAULT NULL,
   p2_ IN VARCHAR2 DEFAULT NULL,
   p3_ IN VARCHAR2 DEFAULT NULL )
IS
   temp_ VARCHAR2(2000) := text_;
BEGIN
   temp_ := replace(temp_, ':P1', p1_);
   temp_ := replace(temp_, ':P2', p2_);
   temp_ := replace(temp_, ':P3', p3_);
   Log_SYS.App_Trace(Log_SYS.trace_, substr(temp_, 1, 240)||'('||to_char(dbms_utility.get_time)||')');
END Put_Line;


@UncheckedAccess
PROCEDURE Set_Output (
   main_switch_ BOOLEAN )
IS
BEGIN
   --Trace_SYS.main_switch    := main_switch_;
   --Trace_SYS.current_switch := main_switch_;
   NULL;
END Set_Output;


-- Set_Method_Trace
--   Set the boolean global to set server trace flag on or off.
--   Client value zero means FALSE and client value one means TRUE.
@UncheckedAccess
PROCEDURE Set_Method_Trace (
   trace_value_ IN NUMBER )
IS
BEGIN
   /*
   IF (trace_value_ = 1) THEN
      method_trace_ := TRUE;
   ELSE
      method_trace_ := FALSE;
   END IF;
   */
   NULL;
END Set_Method_Trace;


@UncheckedAccess
FUNCTION Get_Main_Switch RETURN BOOLEAN
IS
BEGIN
   --   RETURN main_switch;
   RETURN(TRUE);
END Get_Main_Switch;


@UncheckedAccess
PROCEDURE Set_Trace_Output (
   trace_flag_ IN NUMBER )
IS
   installation_mode_ BOOLEAN := Installation_SYS.Get_Installation_Mode;
BEGIN
   IF (trace_flag_ = 0) THEN
      Log_SYS.Set_Log_Level_(Log_SYS.error_, installation_mode_);
   ELSE
      Log_SYS.Set_Log_Level_(Log_SYS.debug_, installation_mode_);
   END IF;
/*
   IF (trace_flag_ = 1) THEN
      set_output(TRUE);
   ELSE
      set_output(FALSE);
   END IF;
*/
END Set_Trace_Output;


@UncheckedAccess
PROCEDURE Internal_Error (
   procname_ VARCHAR2 )
IS
BEGIN
   init;
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Trace_SYS' || Log_SYS.Get_Separator || ' Internal error in procedure ' || upper(procname_) );
END Internal_Error;


@UncheckedAccess
FUNCTION Time RETURN VARCHAR2
IS
BEGIN
   RETURN to_char( sysdate, long_date_format_ );
END Time;


@UncheckedAccess
FUNCTION Indent (
   call_level_ NATURAL DEFAULT 0 ) RETURN VARCHAR2
IS
BEGIN
   RETURN rpad('.',indent_size_*call_level_,' ');
END Indent;


@UncheckedAccess
PROCEDURE Put_Action (
   action_  VARCHAR2,
   id_      VARCHAR2,
   level_  NATURAL DEFAULT 0 )
IS
   line_       VARCHAR2(512);
BEGIN
   line_ := indent(level_) || rpad(lower(action_),6) || ' ' || id_;
/*   
   IF curr_time_ <> last_time THEN
      last_time := curr_time_;
      Log_SYS.Fnd_Trace_(Log_SYS.info_, rpad( line_, trace_line_size_-16 ) || last_time );
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, line_ );
   END IF;
*/
   Log_SYS.Fnd_Trace_(Log_SYS.info_, line_ || Time );
END Put_Action;


@UncheckedAccess
PROCEDURE Put_Field (
   field_ VARCHAR2 )
IS
BEGIN
   Log_SYS.App_Trace(Log_SYS.trace_, substr( indent||field_, 1, 255 ));
END Put_Field;


@UncheckedAccess
PROCEDURE Warning (
   msg_ VARCHAR2 )
IS
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.warning_, 'Trace_SYS' || Log_SYS.Get_Separator || ' Warning! ' || msg_ || '.' );
END Warning;


@UncheckedAccess
FUNCTION Get_Channel_Switch (
   channel_id_ NATURAL ) RETURN BOOLEAN
IS
BEGIN
   --   RETURN nvl( channel_switch(channel_id), default_channel_switch );
   RETURN(TRUE);
EXCEPTION
   WHEN no_data_found THEN 
      --RETURN default_channel_switch;
      RETURN(TRUE);
END Get_Channel_Switch;


@UncheckedAccess
FUNCTION Image (
   item_ VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN '''' || item_ || '''';
END Image;


@UncheckedAccess
FUNCTION Image (
   item_ NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN nvl(to_char(item_),'NULL');
END Image;


@UncheckedAccess
FUNCTION Image (
   item_ DATE ) RETURN VARCHAR2
IS
BEGIN
   RETURN nvl(to_char(item_,long_date_format_),'NULL');
END Image;


@UncheckedAccess
FUNCTION Image (
   item_ BOOLEAN ) RETURN VARCHAR2
IS
   bool_ VARCHAR2(10);
BEGIN
   IF item_ THEN
      bool_ := 'TRUE';
   ELSIF NOT item_ THEN
      bool_ := 'FALSE';
   ELSE
      bool_ := 'NULL';
   END IF;
   RETURN bool_;
END Image;


@UncheckedAccess
PROCEDURE Set_Buffer_Size (
   buffer_size_ NATURAL )
IS
BEGIN
   dbms_output.enable( NULL ); -- Null means unlimited size
END Set_Buffer_Size;


@UncheckedAccess
PROCEDURE Set_Channel (
   channel_id_ NATURAL,
   switch_     BOOLEAN )
IS
BEGIN
   --   channel_switch( channel_id ) := switch;
   NULL;
END Set_Channel;


@UncheckedAccess
PROCEDURE Set_Channel (
   default_switch_ BOOLEAN )
IS
BEGIN
   --default_channel_switch := default_switch;
   NULL;
END Set_Channel;



