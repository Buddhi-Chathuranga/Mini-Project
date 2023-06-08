-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartSalesman
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160627  SudJlk STRSC-1964, Removed Blocked_For_Use with the introduction of data validity.
--  100514  KRPELK Merge Rose Method Documentation.
--  100108  Umdolk Refactoring in Communication Methods in Enterprise.
--  091001  MaMalk Removed unused code in Exist. 
--  ------------------------- 14.0.0 -----------------------------------------
--  090606  PraWlk  Bug 83548, Modified Unpack_Check_Insert___ by assigning FALSE for blocked_for_use
--  090606          attibute when it is NULL.
--  090319  SudJlk Bug 77435, Introduced "Blocked for Use" to set person related basic data as outdated.
--  060118  JaJalk Added the returning clause in Insert___ according to the new F1 template.
--  040225  IsWilk Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  010419  JSAnse  Bug fix 21249, modified COMMENT ON COLUMN &VIEW_LOV..name, removed "/UPPERCASE".
--  000419  PaLj  Corrected Init_Method Errors
--  -------------------- 12.0 ----------------------------------------------
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990602  JakH  Updated Replace_Person_Id function
--  990505  JakH  Added Replace_Person_Id function
--  990127  TOBE  Added /NOCHECK on ref to PersonInfo in VIEW_LOV.
--  990108  ToBe  Added public function Get_Phone.
--  990108  ToBe  SalesPartSalesman now connected to PersonInfo only salesman_code and
--                rowversion left as attributes, public functions preserved.
--  971125  RaKu  Changed to FND200 Templates.
--  970509  JoAn  Added method Get_Control_Type_Value_Desc
--  970312  RaKu  Changed table name.
--  970218  JOED  Changed objversion.
--  960208  JOED  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Purpose: Retreive the control type description used in accounting
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Name(value_);
END Get_Control_Type_Value_Desc;


-- Get_Name
--   Purpose: Returns the name of the salesman.
@UncheckedAccess
FUNCTION Get_Name (
   salesman_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Person_Info_API.Get_Name(salesman_code_);
END Get_Name;


-- Get_Phone
--   Purpose: Returns the default phone number of the salesman.
@UncheckedAccess
FUNCTION Get_Phone (
   salesman_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Comm_Method_API.Get_Default_Value('PERSON', salesman_code_, 'PHONE');
END Get_Phone;


-- Replace_Person_Id
--   The procedure does not really replace any person data, instead it works
--   like this:  if the new_person_id exists, nothing is done, otherwhise if
--   the old_person_id exists the new_person_id gets created with data from
--   the old. (since there are no attributes associated the id simply gets
--   added to the table)
FUNCTION Replace_Person_Id (
   new_person_id_ IN VARCHAR2,
   old_person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_        VARCHAR2(500);
   newrec_      SALES_PART_SALESMAN_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   IF new_person_id_ = old_person_id_ THEN
      -- no need to change, either neither exists or both
      RETURN 'TRUE';
   END IF;

   IF check_exist___(new_person_id_) THEN
      -- ok he's already here don't do anything
      RETURN 'FALSE';
   ELSIF (NOT check_exist___(old_person_id_))THEN
      --  the old guy is nonexisting so the new guy is not really a salesman
      RETURN 'TRUE';
   ELSE
      -- add new_person_id
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SALESMAN_CODE', new_person_id_ , attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      RETURN 'TRUE';
   END IF;
END Replace_Person_Id;



