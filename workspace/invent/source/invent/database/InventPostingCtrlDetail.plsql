-----------------------------------------------------------------------------
--
--  Logical unit: InventPostingCtrlDetail
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  001205  ovjose   Created
--  001218  LiSv     For new Create Company concept added procedures Make_Company, 
--                   Copy___, Import___ and Export___.
--  010816  ovjose   Added Create Company translation method Create_Company_Translations___
--  020102  THSRLK   IID 20001 Enhancement of Update Company. Changes inside make_company method
--                   Changed Import___, Export___ and Copy___ methods to use records
--  040623  anpelk   FIPR338A2: Unicode Changes.
--  050524  ovjose   New generic concept.All code placed in PostingCtrlCrecomp.Also removed ETC and PCT-vie
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Make_Company (
   attr_       IN VARCHAR2 )
IS 
BEGIN
   Posting_Ctrl_Crecomp_API.Make_Company_Detail_Gen( 'INVENT', lu_name_, 'INVENT_POSTING_CTRL_DETAIL_API', attr_ );
END Make_Company;   



