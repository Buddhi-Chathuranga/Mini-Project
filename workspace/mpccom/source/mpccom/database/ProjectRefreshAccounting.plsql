-----------------------------------------------------------------------------
--
--  Logical unit: ProjectRefreshAccounting
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120807  Darklk   Bug 104487, Modified Remove_Using_Temporary_Table() by adding an anonymous block to trap the application error message -20115
--  120807           since we can be sure the data which had in the table PROJECT_REFRESH_ACCOUNTING_TAB is properly removed by another process.
--  110418  PraWlk   Bug 93686, Modified method Fill_Temporary_Table() by adding new parameter accounting_id_.  
--  100430  Ajpelk   Merge rose method documentation
------------------------------Eagle------------------------------------------
--  080408  NiBalk   Bug 70198, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   accounting_id_    IN  NUMBER,
   contract_         IN  VARCHAR2,
   booking_source_   IN  VARCHAR2 )
IS
   acc_rec_      PROJECT_REFRESH_ACCOUNTING_TAB%ROWTYPE; 
   newrec_       PROJECT_REFRESH_ACCOUNTING_TAB%ROWTYPE;
   objid_        PROJECT_REFRESH_ACCOUNTING.objid%TYPE;
   objversion_   PROJECT_REFRESH_ACCOUNTING.objversion%TYPE;
   attr_         VARCHAR2(2000);
   indrec_       Indicator_Rec;

BEGIN
   IF (Check_Exist___(accounting_id_))  THEN
      acc_rec_ := Get_Object_By_Keys___(accounting_id_);
      IF (acc_rec_.contract != contract_) OR (acc_rec_.booking_source != booking_source_) THEN
         Error_Sys.Record_General(lu_name_,'NOTMATCHING: A record exists with Accountin ID :P1 , Contract :P2 and Booking Source :P3.', accounting_id_, acc_rec_.contract, acc_rec_.booking_source);
      END IF;
   ELSE
      Client_SYS.Add_To_Attr('ACCOUNTING_ID',  accounting_id_,  attr_);
      Client_SYS.Add_To_Attr('CONTRACT',       contract_,       attr_);
      Client_SYS.Add_To_Attr('BOOKING_SOURCE', booking_source_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);  
   END IF;
END New;


PROCEDURE Fill_Temporary_Table (
   contract_         IN VARCHAR2,
   booking_source_   IN VARCHAR2,
   accounting_id_    IN NUMBER DEFAULT NULL )
IS
   CURSOR get_acc_ids IS
      SELECT accounting_id
        FROM PROJECT_REFRESH_ACCOUNTING_TAB
       WHERE contract       = contract_ 
         AND booking_source = booking_source_
         AND (accounting_id = accounting_id_ OR accounting_id_ IS NULL);
               
   accounting_id_tab_            Mpccom_Accounting_API.Accounting_Id_Tab;
BEGIN
   OPEN get_acc_ids;
   FETCH get_acc_ids BULK COLLECT into accounting_id_tab_;
   CLOSE get_acc_ids;

   IF (accounting_id_tab_.COUNT > 0) THEN
      Mpccom_Accounting_API.Fill_Temporary_Table(accounting_id_tab_);
   END IF;   
END Fill_Temporary_Table;


PROCEDURE Remove_Using_Temporary_Table
IS
   accounting_id_tab_            Mpccom_Accounting_API.Accounting_Id_Tab;
   remrec_     PROJECT_REFRESH_ACCOUNTING_TAB%ROWTYPE;
   objid_      PROJECT_REFRESH_ACCOUNTING.objid%TYPE;
   objversion_ PROJECT_REFRESH_ACCOUNTING.objversion%TYPE;
BEGIN

   accounting_id_tab_ := Mpccom_Accounting_API.Get_From_Temporary_Table;

   IF (accounting_id_tab_.COUNT > 0) THEN
      FOR i IN accounting_id_tab_.FIRST..accounting_id_tab_.LAST LOOP
         Get_Id_Version_By_Keys___(objid_, objversion_, accounting_id_tab_(i));
         DECLARE
            row_deleted EXCEPTION;
            PRAGMA      EXCEPTION_INIT(row_deleted, -20115);
         BEGIN
            remrec_ := Lock_By_Keys___(accounting_id_tab_(i));
            Check_Delete___(remrec_);
            Delete___(objid_, remrec_);
            EXCEPTION
               WHEN row_deleted THEN
                  NULL;
               WHEN OTHERS THEN
                  RAISE;
         END;
      END LOOP;
   END IF;

   Mpccom_Accounting_API.Clear_Temporary_Table;
END Remove_Using_Temporary_Table;



