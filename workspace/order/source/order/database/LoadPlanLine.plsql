-----------------------------------------------------------------------------
--
--  Logical unit: LoadPlanLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130704  MAHPLK  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT load_plan_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (Cust_Ord_Customer_Address_API.Is_Ship_Location(newrec_.customer_no, newrec_.addr_no) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'LOADSEQSPEC: Load Sequence number may only be specified for a delivery address.');
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Load_Seq_No (
   route_id_      IN VARCHAR2,
   ship_via_code_ IN VARCHAR2,
   contract_      IN VARCHAR2,
   customer_no_   IN VARCHAR2,
   addr_no_       IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ LOAD_PLAN_LINE_TAB.load_sequence_no%TYPE;
   CURSOR get_seq_no_site IS
      SELECT load_sequence_no
      FROM   LOAD_PLAN_LINE_TAB
      WHERE  route_id = route_id_
       AND   ship_via_code = ship_via_code_
       AND   contract = contract_
       AND   customer_no = customer_no_
       AND   addr_no = addr_no_;
   
   CURSOR get_seq_no_all_site IS
      SELECT load_sequence_no
      FROM   LOAD_PLAN_LINE_TAB
      WHERE  route_id = route_id_
       AND   ship_via_code = ship_via_code_
       AND   contract = '*'
       AND   customer_no = customer_no_
       AND   addr_no = addr_no_;
BEGIN
   OPEN get_seq_no_site;
   FETCH get_seq_no_site INTO temp_;
   CLOSE get_seq_no_site;
   -- Find load sequnce number for any site, if not defined for given site.
   IF temp_ IS NULL THEN
      OPEN get_seq_no_all_site;
      FETCH get_seq_no_all_site INTO temp_;
      CLOSE get_seq_no_all_site;
   END IF;
   RETURN temp_;
END Get_Load_Seq_No;



