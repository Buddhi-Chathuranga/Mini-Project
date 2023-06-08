-----------------------------------------------------------------------------
--
--  Logical unit: AssortmentHistory
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210101  SBalLK  Issue SC2020R1-11830, Modified New() method by removing attr_ functionality to optimize the performance.
--  061026  ISWILK   Created.
--  131104  UdGnlk   PBSC-192, Modified message_text column mandatory in the base view
--  131104           comments and code to align with model file errors
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   assortment_id_ IN VARCHAR2,
   message_text_  IN VARCHAR2 )
IS
   CURSOR get_max_history IS
      SELECT MAX(history_no)
      FROM  assortment_history_tab
      WHERE assortment_id = assortment_id_;

    newrec_    assortment_history_tab%ROWTYPE;
    hist_no_   assortment_history_tab.history_no%TYPE;
BEGIN
   OPEN get_max_history;
   FETCH get_max_history INTO hist_no_;
   CLOSE get_max_history;

   hist_no_ := NVL(hist_no_, 0) + 1;
   
   newrec_.assortment_id := assortment_id_;
   newrec_.history_no    := hist_no_;
   newrec_.date_created  := sysdate;
   newrec_.user_id       := Fnd_Session_API.Get_Fnd_User;
   newrec_.message_text  := message_text_;
   New___(newrec_);
END New;



