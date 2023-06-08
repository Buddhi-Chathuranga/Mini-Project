-----------------------------------------------------------------------------
--
--  Logical unit: RemotePrintingNode
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  041209  DOZE    Created
--  051109  DOZE    Changed Is_Late to use table and rowversion to get rid of
--                  date format exception (#51419)
--  060327  MAOL    Fixed Is_Late to return true if no data is found. (Edge
--  140129  AsiWLK   Merged LCS-111925
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Node (
   name_ IN VARCHAR2,
   poll_time_ IN NUMBER )
IS
BEGIN
   IF Check_Exist___(name_) THEN
      UPDATE REMOTE_PRINTING_NODE_TAB
      SET POLL_TIME = poll_time_,
          ROWVERSION = sysdate
      WHERE NAME = name_;
   ELSE
      INSERT INTO REMOTE_PRINTING_NODE_TAB(name,poll_time,rowversion) VALUES(name_, poll_time_, sysdate);
   END IF;
   DBMS_Alert.Signal('PRINT_AGENT_ALERT','RENEW');
END Create_Node;


PROCEDURE Touch (
   name_ IN VARCHAR2 )
IS
BEGIN
   UPDATE REMOTE_PRINTING_NODE_TAB
   SET rowversion = systimestamp WHERE NAME = name_;
END Touch;


FUNCTION Is_Late (
   name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   touch_ DATE;
   poll_time_ NUMBER;
BEGIN
   SELECT rowversion, poll_time
   INTO touch_, poll_time_
   FROM REMOTE_PRINTING_NODE_TAB
   WHERE NAME = name_;
   RETURN (sysdate > (touch_ + 3 * (poll_time_ /(24*60*60))));
EXCEPTION
   WHEN no_data_found THEN
      RETURN TRUE;
END Is_Late;

FUNCTION Get_Rowversion (
   name_ IN VARCHAR2 ) RETURN DATE
IS
   touch_ DATE
   ;
BEGIN
   SELECT rowversion
   INTO touch_
   FROM REMOTE_PRINTING_NODE_TAB
   WHERE NAME = name_;
   RETURN touch_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN sysdate;
END Get_Rowversion;



