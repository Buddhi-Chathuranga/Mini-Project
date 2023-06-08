-----------------------------------------------------------------------------
--
--  Logical unit: InventPostingCtrl
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  001205  ovjose   Created.
--  001218  LiSv     For new Create Company concept dded procedures Make_Company, 
--                   Copy___, Import___ and Export___.
--  010816  ovjose   Added Create Company translation method Create_Company_Translations___
--  020102  THSRLK   IID 20001 Enhancement of Update Company. Changes inside make_company method
--                   Changed Import___, Export___ and Copy___ methods to use records
--  040623  anpelk   FIPR338A2: Unicode Changes.
--  050524  ovjose   New generic concept.All code placed in PostingCtrlCrecomp.Also removed ETC and PCT-vie
--  160725  Hecolk   FINLIFE-118,  Added methods Control_Type_Value_Exist and Get_Control_Type_Value_Desc 
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
   Posting_Ctrl_Crecomp_API.Make_Company_Gen( 'INVENT', lu_name_, 'INVENT_POSTING_CTRL_API', attr_ );
END Make_Company;


PROCEDURE Get_Control_Type_Value_Desc (
   description_    OUT VARCHAR2,
   company_        IN VARCHAR2,  
   connectivity_   IN  VARCHAR2 )
IS
BEGIN
   IF(connectivity_ = 'CONNECTED') THEN
      description_ := Language_SYS.Translate_Constant(lu_name_, 'PROJINVENT: Project Inventory');
   ELSIF(connectivity_ = 'NOTCONNECTED' ) THEN
      description_ := Language_SYS.Translate_Constant(lu_name_, 'GENINVENT: General Inventory');
   END IF;
END Get_Control_Type_Value_Desc;

PROCEDURE Control_Type_Value_Exist (
   connectivity_ IN VARCHAR2 )
IS
BEGIN     
   IF NOT(connectivity_ IN ('CONNECTED', 'NOTCONNECTED')) THEN
      Error_SYS.Record_General(lu_name_, 'NOCNTRLTYPEVAL: The Control Type Value object does not exist.');
   END IF;
END Control_Type_Value_Exist;