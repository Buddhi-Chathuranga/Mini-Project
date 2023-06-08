-----------------------------------------------------------------------------
--
--  Logical unit: InventTransInterconnect
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200324  BudKlk  Bug 152368(SCZ-8891), Created a new method Get_All_Connected_Trans_id_Tab() to retrive the transactions connected to a specific transaction, where the connection works both ways
--  200324          and introducted a new collection All_Connected_Transaction_Id_Tab.
--  051221  DAYJLK  Added function Get_All_Connected_Transactions.
--  051111  JoAnSe  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Connected_Transaction_Id_Tab IS TABLE OF INVENT_TRANS_INTERCONNECT_TAB.connected_transaction_id%TYPE INDEX BY BINARY_INTEGER;

TYPE Transaction_Id_Rec IS RECORD (
   connected_transaction_id  INVENT_TRANS_INTERCONNECT_TAB.connected_transaction_id%TYPE,
   transaction_id            INVENT_TRANS_INTERCONNECT_TAB.transaction_id%TYPE);
   
TYPE All_Connected_Transaction_Id_Tab IS TABLE OF Transaction_Id_Rec INDEX BY PLS_INTEGER;
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT invent_trans_interconnect_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   -- Make sure that the connection has not already been defined in the other direction
   IF (Check_Exist___(newrec_.connected_transaction_id, newrec_.transaction_id)) THEN
      Error_SYS.Record_General(lu_name_, 'CONN_EXISTS: The connection between transactions :P1 and :P2 already exist',
                               newrec_.transaction_id, newrec_.connected_transaction_id);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Connect_Transactions
--   Create a new record to connect the two specified transactions with the
--   specified connect reason.
PROCEDURE Connect_Transactions (
   transaction_id_           IN NUMBER,
   connected_transaction_id_ IN NUMBER,
   connect_reason_db_        IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   newrec_     INVENT_TRANS_INTERCONNECT_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('TRANSACTION_ID', transaction_id_, attr_);
   Client_SYS.Add_To_Attr('CONNECTED_TRANSACTION_ID', connected_transaction_id_, attr_);
   Client_SYS.Add_To_Attr('CONNECT_REASON_DB', connect_reason_db_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

END Connect_Transactions;


-- Get_Connected_Transaction_Id
--   Retrive the id of the transaction connected to the specified transaction_id
--   with the specified connect_reason. The connection works both ways.
@UncheckedAccess
FUNCTION Get_Connected_Transaction_Id (
   transaction_id_    IN NUMBER,
   connect_reason_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   connected_transaction_id_ NUMBER;

   CURSOR get_connection IS
      SELECT connected_transaction_id
      FROM INVENT_TRANS_INTERCONNECT_TAB
      WHERE transaction_id = transaction_id_
      AND   connect_reason = connect_reason_db_;

   CURSOR get_inverted_connection IS
      SELECT transaction_id
      FROM INVENT_TRANS_INTERCONNECT_TAB
      WHERE connected_transaction_id = transaction_id_
      AND   connect_reason = connect_reason_db_;
BEGIN
   OPEN get_connection;
   FETCH get_connection INTO connected_transaction_id_;
   CLOSE get_connection;

   IF connected_transaction_id_ IS NULL THEN
      OPEN get_inverted_connection;
      FETCH get_inverted_connection INTO connected_transaction_id_;
      CLOSE get_inverted_connection;
   END IF;

   RETURN connected_transaction_id_;

END Get_Connected_Transaction_Id;


-- Get_Connected_Transactions_Tab
--   Retrive the ids of the transactions connected to the specified transaction_id
--   with the specified connect_reason. The connection works both ways.
@UncheckedAccess
FUNCTION Get_All_Connected_Trans_id_Tab (
   transaction_id_    IN NUMBER,
   connect_reason_db_ IN VARCHAR2 ) RETURN Connected_Transaction_Id_Tab
IS
   connected_transaction_id_tab_  Connected_Transaction_Id_Tab;
   all_transaction_id_tab_        All_Connected_Transaction_Id_Tab;
   count_                         NUMBER := 1;

   CURSOR get_connected_transactions IS
      SELECT connected_transaction_id, transaction_id
      FROM INVENT_TRANS_INTERCONNECT_TAB
      WHERE (transaction_id = transaction_id_ OR connected_transaction_id = transaction_id_)
      AND   connect_reason = connect_reason_db_;

   BEGIN
   OPEN get_connected_transactions;
   FETCH get_connected_transactions BULK COLLECT INTO all_transaction_id_tab_;
   CLOSE get_connected_transactions;

   IF (all_transaction_id_tab_.COUNT > 0) THEN 
      FOR i IN all_transaction_id_tab_.FIRST..all_transaction_id_tab_.LAST LOOP
         connected_transaction_id_tab_(count_)   := all_transaction_id_tab_(i).connected_transaction_id;
         connected_transaction_id_tab_(count_+1) := all_transaction_id_tab_(i).transaction_id;
         count_                                  := connected_transaction_id_tab_.LAST + 1;
      END LOOP;
   END IF;

   RETURN(connected_transaction_id_tab_);
END Get_All_Connected_Trans_id_Tab;


-- Get_All_Connected_Transactions
--   Retreive all the connected transaction id(s) connected to a particular
--   transaction with the specified connect reason or without a connect reason if not specified.
--   Only connected transaction ids linked to a transaction id can be fetched, not vice versa.
@UncheckedAccess
FUNCTION Get_All_Connected_Transactions (
   transaction_id_    IN NUMBER,
   connect_reason_db_ IN VARCHAR2 ) RETURN Connected_Transaction_Id_Tab
IS
   connected_transaction_id_tab_  Connected_Transaction_Id_Tab;

   CURSOR get_connected_transactions IS
      SELECT connected_transaction_id
      FROM   INVENT_TRANS_INTERCONNECT_TAB
      WHERE transaction_id = transaction_id_
      AND   (connect_reason = connect_reason_db_ OR connect_reason_db_ IS NULL);
BEGIN
   OPEN get_connected_transactions;
   FETCH get_connected_transactions BULK COLLECT INTO connected_transaction_id_tab_;
   CLOSE get_connected_transactions;

   RETURN(connected_transaction_id_tab_);
END Get_All_Connected_Transactions;



