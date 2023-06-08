-----------------------------------------------------------------------------
--
--  Logical unit: InfoChgRequestLine
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210803  NaLrlk  PR21R2-582, Added Get_Client_Value() to retreive client values for request information.
--  210728  NaLrlk  PR21R2-398, Modified changes for rename the info_chg_request tables.
--  210701  NaLrlk  PR21R2-395, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT info_chg_request_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.line_no IS NULL) THEN
      newrec_.line_no := Get_Next_Line_No___(newrec_.request_id);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


-- Get_Next_Line_No___
--   Returns next line no for a given request_id.
FUNCTION Get_Next_Line_No___ (
   request_id_  IN VARCHAR2 )RETURN NUMBER
IS
   line_no_  info_chg_request_line_tab.line_no%TYPE;
   CURSOR get_line_no IS
      SELECT NVL(MAX(line_no + 1), 1)
      FROM   info_chg_request_line_tab
      WHERE  request_id = request_id_;
BEGIN
   IF (request_id_ IS NOT NULL) THEN
      OPEN get_line_no;
      FETCH get_line_no INTO line_no_;
      CLOSE get_line_no;
   END IF;
   RETURN line_no_;
END Get_Next_Line_No___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public interface to create a record.
@IgnoreUnitTest DMLOperation
PROCEDURE New (
   request_id_          IN NUMBER,
   change_information_  IN VARCHAR2,
   old_value_           IN VARCHAR2,
   new_value_           IN VARCHAR2 )
IS
   newrec_  info_chg_request_line_tab%ROWTYPE;
BEGIN
   newrec_.request_id := request_id_;
   newrec_.change_information := change_information_;
   newrec_.old_value := old_value_;
   newrec_.new_value := new_value_;
   New___(newrec_);
END New;


-- Get_Client_Value
--   Returns client value for specified change information db value.
@UncheckedAccess
FUNCTION Get_Client_Value (
   change_information_  IN VARCHAR2,
   db_value_            IN VARCHAR2 ) RETURN VARCHAR2
IS
   client_value_   VARCHAR2(32000);
BEGIN
   IF (db_value_ IS NOT NULL) THEN
      IF (change_information_ = 'DEFAULT_LANGUAGE') THEN
         client_value_ := Iso_Language_API.Decode(db_value_);
      ELSIF (change_information_ IN ('COUNTRY', 'ADDR_COUNTRY')) THEN
         client_value_ := Iso_Country_API.Decode(db_value_);      
      ELSIF (change_information_ = 'GEOGRAPHY_CODE') THEN
         $IF Component_Srm_SYS.INSTALLED $THEN
            client_value_ := Supp_Geography_Code_API.Decode_List(db_value_);
         $ELSE
            client_value_ := NULL;
         $END      
      ELSIF (change_information_ = 'DEPARTMENT') THEN
         $IF Component_Rmcom_SYS.INSTALLED $THEN
            client_value_ := Supplier_Info_Contact_API.Decode_Department(db_value_);
         $ELSE
            client_value_ := NULL;
         $END
      ELSIF (change_information_ = 'ROLE') THEN
         client_value_ := Contact_Role_API.Decode_List(db_value_);
      ELSIF (change_information_ IN ('DEF_DELIVERY_ADDRESS', 'DEF_INVOICE_ADDRESS', 'DEF_VISIT_ADDRESS', 'DEF_PAY_ADDRESS', 'CONNECT_ALL_SUPP_ADDR', 'SUPPLIER_PRIMARY', 'ADDRESS_PRIMARY')) THEN
         client_value_ := Fnd_Boolean_API.Decode(db_value_);
      ELSE
         client_value_ := db_value_;
      END IF;
   END IF;
   RETURN client_value_;
END Get_Client_Value;
