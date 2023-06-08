-----------------------------------------------------------------------------
--
--  Logical unit: OutMessageUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980127  ERFO    Rearrangements for release 2.1.0.
--  980324  JHMA    Check if transfer process is running in Process_Outbox__
--  980324  JHMA    Extended exception handling in Transfer_Data__
--  990303  ERFO    Correction in method Cleanup for states (Bug #3149).
--  990705  ERFO    Enable resend-option for non-transferred jobs (Bug #3459).
--  990705  ERFO    Corrected state for background job (Bug #3460).
--  991020  ERFO    Solved problem in date format in method Cleanup (Bug #3620).
--  991026  ERFO    Method Process_Outbox__ may sometimes produce unnecessary
--                  background jobs in Transaction_SYS (Bug #3669).
--  000816  ROOD    Removed obsolete code concerning mainly message_format (ToDo#3927).
--  000818  ROOD    Removed methods Create_File___, Create_Head___ and Create_Line___ (ToDo#3927).
--  010524  ROOD    Added condition on what message classes that should be
--                  processed in method Transfer_Data__ (Bug#22120).
--  020508  ROOD    Increased length of variable database_link_ (Bug#26297).
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040113  NIPE    Performance improvement in Transfer_Data__ (Bug#38136).
--  050404  JORA    Added assertion for dynamic SQL.  (F1PR481)
--  050420  JORA    Moved the assertion within Transfer_Data__. 
--  051108  ASWILK  Improved performance in Cleanup using BULK COLLECT, FORALL (Bug#48401).
--  060105  UTGULK  Annotated Sql injection.
--  061027  NiWiLK  Modified method Cleanup(Bug#61210).
--  100526  JHMA    No description of background job (Bug #90933
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

data_head_prefix_   CONSTANT VARCHAR2(1) := '!';
data_cont_prefix_   CONSTANT VARCHAR2(1) := '-';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Spool_Head___ (
   out_message_ IN out_message%ROWTYPE )
IS
BEGIN
   dbms_output.put_line(data_head_prefix_ || 'HEAD' || Client_SYS.field_separator_ || TO_CHAR(out_message_.message_id) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || out_message_.receiver || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || out_message_.sender || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || out_message_.class_id || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || out_message_.application_message_id || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || out_message_.application_receiver_id || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || out_message_.version || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_.exec_time, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || out_message_.connectivity_version || Client_SYS.field_separator_);
END Spool_Head___;


PROCEDURE Spool_Line___ (
   out_message_line_ IN out_message_line%ROWTYPE )
IS
BEGIN
   dbms_output.put_line(data_head_prefix_ || 'LINE' || Client_SYS.field_separator_ || TO_CHAR(out_message_line_.message_id) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.message_line) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || out_message_line_.name || Client_SYS.field_separator_);
--
--    Columns C00 - C99 is of type VARCHAR2(2000). Values are truncated to 253 characters due to the
--    dbms_output.put_line limit of 255 characters.
--
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c00,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c01,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c02,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c03,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c04,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c05,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c06,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c07,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c08,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c09,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c10,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c11,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c12,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c13,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c14,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c15,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c16,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c17,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c18,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c19,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c20,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c21,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c22,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c23,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c24,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c25,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c26,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c27,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c28,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c29,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c30,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c31,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c32,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c33,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c34,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c35,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c36,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c37,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c38,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c39,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c40,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c41,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c42,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c43,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c44,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c45,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c46,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c47,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c48,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c49,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c50,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c51,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c52,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c53,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c54,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c55,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c56,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c57,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c58,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c59,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c60,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c61,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c62,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c63,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c64,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c65,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c66,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c67,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c68,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c69,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c70,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c71,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c72,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c73,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c74,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c75,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c76,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c77,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c78,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c79,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c80,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c81,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c82,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c83,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c84,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c85,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c86,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c87,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c88,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c89,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c90,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c91,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c92,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c93,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c94,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c95,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c96,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c97,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c98,1,253) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || SUBSTR(out_message_line_.c99,1,253) || Client_SYS.field_separator_);

   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n00) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n01) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n02) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n03) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n04) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n05) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n06) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n07) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n08) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n09) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n10) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n11) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n12) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n13) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n14) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n15) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n16) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n17) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n18) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n19) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n20) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n21) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n22) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n23) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n24) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n25) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n26) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n27) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n28) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n29) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n30) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n31) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n32) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n33) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n34) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n35) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n36) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n37) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n38) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n39) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n40) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n41) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n42) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n43) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n44) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n45) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n46) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n47) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n48) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n49) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n50) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n51) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n52) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n53) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n54) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n55) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n56) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n57) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n58) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n59) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n60) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n61) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n62) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n63) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n64) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n65) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n66) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n67) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n68) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n69) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n70) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n71) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n72) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n73) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n74) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n75) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n76) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n77) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n78) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n79) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n80) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n81) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n82) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n83) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n84) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n85) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n86) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n87) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n88) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n89) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n90) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n91) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n92) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n93) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n94) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n95) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n96) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n97) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n98) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.n99) || Client_SYS.field_separator_);

   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d00, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d01, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d02, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d03, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d04, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d05, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d06, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d07, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d08, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d09, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d10, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d11, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d12, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d13, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d14, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d15, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d16, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d17, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d18, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d19, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d20, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d21, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d22, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d23, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d24, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d25, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d26, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d27, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d28, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d29, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d30, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d31, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d32, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d33, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d34, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d35, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d36, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d37, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d38, Client_SYS.date_format_) || Client_SYS.field_separator_);
   dbms_output.put_line(data_cont_prefix_ || TO_CHAR(out_message_line_.d39, Client_SYS.date_format_) || Client_SYS.field_separator_);

   dbms_output.put_line(data_cont_prefix_ || out_message_line_.objversion || Client_SYS.field_separator_);
END Spool_Line___;


PROCEDURE Spool_Text___ (
   text_ IN VARCHAR2 )
IS
   out_buffer_      VARCHAR2(255);
   start_position_  NUMBER := 1;
   text_length_     NUMBER := LENGTH(text_);
BEGIN
   WHILE (text_length_ >= start_position_) LOOP
      out_buffer_ := SUBSTR(text_, start_position_, LEAST(250,text_length_ - start_position_ + 1));
      dbms_output.put_line(data_cont_prefix_ || out_buffer_);
      start_position_ := start_position_ + 250;
   END LOOP;
END Spool_Text___;


PROCEDURE Spool_Data___ (
   receiver_ IN  VARCHAR2,
   class_id_ IN  VARCHAR2 )
IS
   dummy_                 NUMBER;
   error_message_         VARCHAR2(255);
   message_id_            out_message.message_id%TYPE;

   CURSOR outbox_messages IS
      SELECT *
      FROM   out_message
      WHERE  receiver = receiver_
      AND    class_id LIKE NVL(class_id_,'%')
      AND    objstate = 'Released'
      ORDER BY message_id;
   CURSOR c_out_message_line IS
      SELECT *
      FROM   out_message_line
      WHERE  message_id = message_id_
      ORDER BY message_line;
BEGIN
   FOR out_message_rec_ IN outbox_messages LOOP
      --
      -- Lock explicit entry in Outbox
      --
      BEGIN
         SELECT 1
            INTO dummy_
            FROM   out_message_tab
            WHERE  rowstate = 'Released'
            AND    message_id = out_message_rec_.message_id
            FOR UPDATE NOWAIT;
      EXCEPTION
         WHEN OTHERS THEN
            GOTO end_loop;                   -- Skip job if already removed or locked...
      END;
      --
      -- Update status for specific message
      --
      UPDATE out_message_tab
         SET   rowstate = 'Processing'
         WHERE message_id = out_message_rec_.message_id;
      --
      -- Commit to publish new status
      --
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      BEGIN
         Spool_Head___(out_message_rec_);
         message_id_ := out_message_rec_.message_id;
         FOR out_message_line_rec_ IN c_out_message_line LOOP
            Spool_Line___(out_message_line_rec_);
         END LOOP;
         --
         -- Update status for transferred messages
         --
         UPDATE out_message_tab
            SET   rowstate = 'Transferred'
            WHERE message_id = out_message_rec_.message_id;
         --
         -- Commit each message separately
         --
         @ApproveTransactionStatement(2013-11-19,haarse)
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            error_message_ := sqlerrm;
            @ApproveTransactionStatement(2013-11-19,haarse)
            ROLLBACK;
            --
            -- Update status for failed messages
            --
            UPDATE out_message_tab
               SET   rowstate = 'Incomplete',
                     error_message = error_message_
               WHERE message_id = out_message_rec_.message_id;
            --
            -- Commit each message separately
            --
            @ApproveTransactionStatement(2013-11-19,haarse)
            COMMIT;
      END;
      <<end_loop>>
      NULL;
   END LOOP;
END Spool_Data___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Spool_Data__ (
   receiver_ IN VARCHAR2,
   class_id_ IN VARCHAR2 )
IS
BEGIN
   Spool_Data___(receiver_, class_id_ );
END Spool_Data__;


PROCEDURE Process_Outbox__
IS
   message_found_    NUMBER;
   receiver_         VARCHAR2(30);
   full_method_name_ VARCHAR2(2000) := 'Out_Message_Util_API.Transfer_Data__';
   posted_jobs_      BOOLEAN;

   CURSOR sqlnet_receivers IS
      SELECT receiver
      FROM   message_receiver
      WHERE  site_id IS NOT NULL;
   CURSOR outbox_messages IS
      SELECT 1
      FROM   out_message
      WHERE  receiver = receiver_
      AND    objstate = 'Released';
   CURSOR posted_jobs IS
      SELECT arguments
      FROM   transaction_sys_local_tab
      WHERE  state = 'Posted'
      AND    procedure_name = full_method_name_;
BEGIN
   FOR rec_ IN sqlnet_receivers LOOP
      receiver_ := rec_.receiver;
      message_found_ := 0;
      OPEN outbox_messages;
      FETCH outbox_messages INTO message_found_;
      CLOSE outbox_messages;
      IF (message_found_ = 1) THEN
         posted_jobs_ := FALSE;
         FOR jobs_ IN posted_jobs LOOP
            IF ( jobs_.arguments = receiver_) THEN
               posted_jobs_ := TRUE;
               EXIT;
            END IF;
         END LOOP;
         IF (posted_jobs_ = FALSE) THEN
            Transaction_SYS.Deferred_Call(full_method_name_, rec_.receiver, 'Connectivity: Out message transfer');
         END IF;
      END IF;
   END LOOP;
END Process_Outbox__;


PROCEDURE Transfer_Data__ (
   receiver_ IN VARCHAR2,
   class_id_ IN VARCHAR2 DEFAULT '%' )
IS
   in_message_id_               NUMBER;
   in_message_rowstate_         VARCHAR2(30):= 'Posted';
   in_message_line_rowstate_    VARCHAR2(30):= 'Posted';
   database_link_               VARCHAR2(128);
   in_head_                     VARCHAR2(32000);
   in_line_                     VARCHAR2(32000);
   in_seq_                      VARCHAR2(255);
   error_message_               VARCHAR2(255);
   in_seq_cursor_               INTEGER;
   in_message_cursor_           INTEGER;
   in_message_line_cursor_      INTEGER;
   execute_                     INTEGER;
   dummy_                       NUMBER;
   site_id_                     VARCHAR2(30);
      
   CURSOR outbox_messages IS 
      SELECT * 
      FROM out_message 
      WHERE EXISTS ( 
      SELECT 1 
      FROM message_class m 
      WHERE m.class_id = out_message.class_id 
      AND m.send_db = 'TRUE' ) 
      AND receiver = receiver_ 
      AND class_id LIKE NVL(class_id_,'%') 
      AND objstate = 'Released' 
      ORDER BY message_id;

   CURSOR installation_sites(site_ IN VARCHAR2) IS
      SELECT database_link
      FROM   installation_site
      WHERE  site_id = site_;
BEGIN
   --
   -- If Receiver found in installation_sites use SQL to transfer data.
   -- If field database_link is empty inbox is in the same instance as outbox.
   --
   site_id_ := Message_Receiver_API.Get_Site_Id(receiver_);
   OPEN installation_sites(site_id_);
   FETCH installation_sites INTO database_link_;
   IF (installation_sites%NOTFOUND) then
      CLOSE installation_sites;
      RETURN;
   END IF;
   CLOSE installation_sites;
   IF (database_link_ IS NOT NULL) THEN
      IF (SUBSTR(database_link_,1,1) != '@') THEN
         Assert_SYS.Assert_Is_DB_Link(database_link_);
         database_link_ := '@' || database_link_;
      ELSE
         Assert_SYS.Assert_Is_DB_Link(SUBSTR(database_link_,1));
      END IF;
   END IF;
   in_seq_ := 'SELECT in_message_id_seq.nextval' || database_link_ || ' FROM DUAL';
   in_seq_cursor_ := DBMS_SQL.OPEN_CURSOR;
   @ApproveDynamicStatement(2006-01-05,utgulk)
   DBMS_SQL.PARSE(in_seq_cursor_, in_seq_, DBMS_SQL.V7);
   --
   in_head_ := 'INSERT INTO in_message_tab' || database_link_ || ' (';
   in_head_ := in_head_ || 'message_id, class_id, receiver, sender, sender_message_id, ';
   in_head_ := in_head_ || 'version, received_time, transferred_time, ';
   in_head_ := in_head_ || 'rowversion, rowstate, connectivity_version, sender_id ';
   in_head_ := in_head_ || ') VALUES (';
   in_head_ := in_head_ || ':in_message_id, :class_id, :receiver, :sender, ';
   in_head_ := in_head_ || ':application_message_id, :version, sysdate, sysdate, ';
   in_head_ := in_head_ || 'sysdate, :rowstate, :connectivity_version, :message_id';
   in_head_ := in_head_ || ')';
   in_message_cursor_ := DBMS_SQL.OPEN_CURSOR;
   @ApproveDynamicStatement(2006-02-15,pemase)
   DBMS_SQL.PARSE(in_message_cursor_, in_head_, DBMS_SQL.V7);
   --
   in_line_ := 'INSERT INTO in_message_line_tab' || database_link_ || ' (';
   in_line_ := in_line_ || 'message_id, message_line, name, rowversion, rowstate, ';
   in_line_ := in_line_ || 'c00, c01, c02, c03, c04, c05, c06, c07, c08, c09, ';
   in_line_ := in_line_ || 'c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, ';
   in_line_ := in_line_ || 'c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, ';
   in_line_ := in_line_ || 'c30, c31, c32, c33, c34, c35, c36, c37, c38, c39, ';
   in_line_ := in_line_ || 'c40, c41, c42, c43, c44, c45, c46, c47, c48, c49, ';
   in_line_ := in_line_ || 'c50, c51, c52, c53, c54, c55, c56, c57, c58, c59, ';
   in_line_ := in_line_ || 'c60, c61, c62, c63, c64, c65, c66, c67, c68, c69, ';
   in_line_ := in_line_ || 'c70, c71, c72, c73, c74, c75, c76, c77, c78, c79, ';
   in_line_ := in_line_ || 'c80, c81, c82, c83, c84, c85, c86, c87, c88, c89, ';
   in_line_ := in_line_ || 'c90, c91, c92, c93, c94, c95, c96, c97, c98, c99, ';
   in_line_ := in_line_ || 'n00, n01, n02, n03, n04, n05, n06, n07, n08, n09, ';
   in_line_ := in_line_ || 'n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, ';
   in_line_ := in_line_ || 'n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, ';
   in_line_ := in_line_ || 'n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, ';
   in_line_ := in_line_ || 'n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, ';
   in_line_ := in_line_ || 'n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, ';
   in_line_ := in_line_ || 'n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, ';
   in_line_ := in_line_ || 'n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, ';
   in_line_ := in_line_ || 'n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, ';
   in_line_ := in_line_ || 'n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, ';
   in_line_ := in_line_ || 'd00, d01, d02, d03, d04, d05, d06, d07, d08, d09, ';
   in_line_ := in_line_ || 'd10, d11, d12, d13, d14, d15, d16, d17, d18, d19, ';
   in_line_ := in_line_ || 'd20, d21, d22, d23, d24, d25, d26, d27, d28, d29, ';
   in_line_ := in_line_ || 'd30, d31, d32, d33, d34, d35, d36, d37, d38, d39 ';
   in_line_ := in_line_ || ') SELECT ';
   in_line_ := in_line_ || ':in_message_id, message_line, name, sysdate, :rowstate, ';
   in_line_ := in_line_ || 'c00, c01, c02, c03, c04, c05, c06, c07, c08, c09, ';
   in_line_ := in_line_ || 'c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, ';
   in_line_ := in_line_ || 'c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, ';
   in_line_ := in_line_ || 'c30, c31, c32, c33, c34, c35, c36, c37, c38, c39, ';
   in_line_ := in_line_ || 'c40, c41, c42, c43, c44, c45, c46, c47, c48, c49, ';
   in_line_ := in_line_ || 'c50, c51, c52, c53, c54, c55, c56, c57, c58, c59, ';
   in_line_ := in_line_ || 'c60, c61, c62, c63, c64, c65, c66, c67, c68, c69, ';
   in_line_ := in_line_ || 'c70, c71, c72, c73, c74, c75, c76, c77, c78, c79, ';
   in_line_ := in_line_ || 'c80, c81, c82, c83, c84, c85, c86, c87, c88, c89, ';
   in_line_ := in_line_ || 'c90, c91, c92, c93, c94, c95, c96, c97, c98, c99, ';
   in_line_ := in_line_ || 'n00, n01, n02, n03, n04, n05, n06, n07, n08, n09, ';
   in_line_ := in_line_ || 'n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, ';
   in_line_ := in_line_ || 'n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, ';
   in_line_ := in_line_ || 'n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, ';
   in_line_ := in_line_ || 'n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, ';
   in_line_ := in_line_ || 'n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, ';
   in_line_ := in_line_ || 'n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, ';
   in_line_ := in_line_ || 'n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, ';
   in_line_ := in_line_ || 'n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, ';
   in_line_ := in_line_ || 'n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, ';
   in_line_ := in_line_ || 'd00, d01, d02, d03, d04, d05, d06, d07, d08, d09, ';
   in_line_ := in_line_ || 'd10, d11, d12, d13, d14, d15, d16, d17, d18, d19, ';
   in_line_ := in_line_ || 'd20, d21, d22, d23, d24, d25, d26, d27, d28, d29, ';
   in_line_ := in_line_ || 'd30, d31, d32, d33, d34, d35, d36, d37, d38, d39 ';
   in_line_ := in_line_ || 'FROM out_message_line WHERE message_id = :out_message_id';
   in_message_line_cursor_ := DBMS_SQL.OPEN_CURSOR;
   @ApproveDynamicStatement(2006-02-15,pemase)
   DBMS_SQL.PARSE(in_message_line_cursor_, in_line_, DBMS_SQL.V7);
   --
   FOR msg IN outbox_messages LOOP
      --
      -- Lock explicit entry in Outbox
      --
      BEGIN
         SELECT 1
            INTO dummy_
            FROM   out_message_tab
            WHERE  rowstate = 'Released'
            AND    message_id = msg.message_id
            FOR UPDATE NOWAIT;
      EXCEPTION
         WHEN OTHERS THEN
            GOTO end_loop;                   -- Skip job if already removed or locked...
      END;
      --
      -- Fetch sequence number for inbox.
      --
      DBMS_SQL.DEFINE_COLUMN(in_seq_cursor_, 1, in_message_id_);
      execute_ := DBMS_SQL.EXECUTE(in_seq_cursor_);
      execute_ := DBMS_SQL.FETCH_ROWS(in_seq_cursor_);
      DBMS_SQL.COLUMN_VALUE(in_seq_cursor_, 1, in_message_id_);
      --
      -- Update status for specific message
      --
      UPDATE out_message_tab
         SET   rowstate = 'Processing'
         WHERE message_id = msg.message_id;
      --
      -- Commit to publish new status
      --
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      BEGIN
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':in_message_id', in_message_id_);
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':class_id', msg.class_id);
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':receiver', msg.receiver);
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':sender', msg.sender);
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':application_message_id', msg.application_message_id);
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':version', msg.version);
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':rowstate', in_message_rowstate_);
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':connectivity_version', msg.connectivity_version);
         DBMS_SQL.BIND_VARIABLE(in_message_cursor_, ':message_id', msg.message_id);
         execute_ := DBMS_SQL.EXECUTE(in_message_cursor_);
         --
         DBMS_SQL.BIND_VARIABLE(in_message_line_cursor_, ':in_message_id', in_message_id_);
         DBMS_SQL.BIND_VARIABLE(in_message_line_cursor_, ':out_message_id', msg.message_id);
         DBMS_SQL.BIND_VARIABLE(in_message_line_cursor_, ':rowstate', in_message_line_rowstate_);
         execute_ := DBMS_SQL.EXECUTE(in_message_line_cursor_);
         --
         -- Update status for transferred messages
         --
         UPDATE out_message_tab
            SET   rowstate = 'Accepted',
                  error_message = NULL
            WHERE message_id = msg.message_id;
         --
         -- Commit each message separately
         --
         @ApproveTransactionStatement(2013-11-19,haarse)
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            error_message_ := sqlerrm;
            @ApproveTransactionStatement(2013-11-19,haarse)
            ROLLBACK;
            --
            -- Update status for failed messages
            --
            UPDATE out_message_tab
               SET   rowstate = 'Incomplete',
                     error_message = error_message_
               WHERE message_id = msg.message_id;
            --
            -- Commit each message separately
            --
            @ApproveTransactionStatement(2013-11-19,haarse)
            COMMIT;
      END;
      <<end_loop>>
      NULL;
   END LOOP;
   IF (DBMS_SQL.IS_OPEN(in_seq_cursor_)) THEN
      DBMS_SQL.CLOSE_CURSOR(in_seq_cursor_);
   END IF;
   IF (DBMS_SQL.IS_OPEN(in_message_cursor_)) THEN
      DBMS_SQL.CLOSE_CURSOR(in_message_cursor_);
   END IF;
   IF (DBMS_SQL.IS_OPEN(in_message_line_cursor_)) THEN
      DBMS_SQL.CLOSE_CURSOR(in_message_line_cursor_);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      @ApproveTransactionStatement(2013-11-19,haarse)
      ROLLBACK;
      BEGIN
         IF (DBMS_SQL.IS_OPEN(in_seq_cursor_)) THEN
            DBMS_SQL.CLOSE_CURSOR(in_seq_cursor_);
         END IF;
         IF (DBMS_SQL.IS_OPEN(in_message_cursor_)) THEN
            DBMS_SQL.CLOSE_CURSOR(in_message_cursor_);
         END IF;
         IF (DBMS_SQL.IS_OPEN(in_message_line_cursor_)) THEN
            DBMS_SQL.CLOSE_CURSOR(in_message_line_cursor_);
         END IF;
         RAISE;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE; -- Severe problems
      END;
END Transfer_Data__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Cleanup
IS
   cleanup_days_   NUMBER;
   cleanup_states_  VARCHAR2(100);
   sysdate_        DATE := SYSDATE;
   TYPE msg_id_type IS TABLE OF out_message_tab.message_id%TYPE;
   msg_id_          msg_id_type;

   CURSOR get_recs(cleanup_days_  NUMBER,
                   cleanup_states_  VARCHAR2) IS
      SELECT message_id
      FROM   out_message_tab
      WHERE  rowstate IN (select regexp_substr(cleanup_states_,'[^,]+', 1, level) from dual
                      connect by regexp_substr(cleanup_states_, '[^,]+', 1, level) is not null)
      AND    class_id   NOT IN ('IFS_REPLICATION', 'IFS_REPLICATION_CONFIGURATION')
      AND    rowversion < (sysdate_ - cleanup_days_);

BEGIN
   BEGIN
      cleanup_days_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('CON_KEEP_OUTBOX'));
      cleanup_states_ := Fnd_Setting_API.Get_Value('CON_CLEANUP_STATES');
   EXCEPTION
      WHEN OTHERS THEN
         cleanup_days_ := NULL;
   END;
   IF (cleanup_days_ IS NOT NULL) THEN
      OPEN get_recs(cleanup_days_, cleanup_states_);
      LOOP
         FETCH get_recs BULK COLLECT INTO msg_id_ LIMIT 1000; 
         FORALL i_ IN 1..msg_id_.count
            DELETE
               FROM out_message_tab
               WHERE message_id = msg_id_(i_);

         FORALL i_ IN 1..msg_id_.count
            DELETE 
               FROM out_message_line_tab 
               WHERE message_id = msg_id_(i_);
         -- Commit to avoid snapshot too old error
         @ApproveTransactionStatement(2013-11-19,haarse)
         COMMIT;
         EXIT WHEN get_recs%NOTFOUND;
      END LOOP;
      CLOSE get_recs;
   END IF;
END Cleanup;



