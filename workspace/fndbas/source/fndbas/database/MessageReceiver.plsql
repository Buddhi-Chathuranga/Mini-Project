-----------------------------------------------------------------------------
--
--  Logical unit: MessageReceiver
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971117  jhma  Created
--  000808  ROOD  Upgraded to Yoshimura template (Bug#15811).
--  020128  ROOD  Modified view and business logic to handle 
--                attribute translations (ToDo#4070).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  051222  IsAn  Made description as a lov member in view MESSAGE_RECEIVER.
--  091126  DUWI  Added the method Check_Exist (Bug#87226)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   receiver_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(Message_Receiver_API.lu_name_, p1_ => receiver_);
   super(receiver_);
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist_String (
   receiver_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ VARCHAR2(5);
BEGIN
   IF Check_Exist___(receiver_)  THEN
      temp_ := 'TRUE'; 
      RETURN temp_;
   END IF;
   temp_ := 'FALSE';
   RETURN temp_;
END Check_Exist_String;

PROCEDURE Create_Receiver (
   newrec_ IN OUT NOCOPY message_receiver_tab%ROWTYPE )
IS       
   rec_ Public_Rec;
BEGIN   
   rec_ := Get(newrec_.receiver);
   IF (rec_.receiver = newrec_.receiver) THEN
      newrec_.rowkey := rec_.rowkey;
      Modify___(newrec_);
   ELSE
      New___(newrec_); 
   END IF;
END Create_Receiver;

PROCEDURE Remove_Receiver (
   remrec_ IN OUT NOCOPY message_receiver_tab%ROWTYPE)
IS        
BEGIN      
   Remove___(remrec_);   
END Remove_Receiver;