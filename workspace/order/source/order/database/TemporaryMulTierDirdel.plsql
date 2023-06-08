-----------------------------------------------------------------------------
--
--  Logical unit: TemporaryMulTierDirdel
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   --------------------------------------------------------
--  210127  MaEelk   SC2020R1-12354, Modified New and replaced the calls to Unpack___, Check_Insert___ and Insert___ with New___.
--  170911  TiRalk   STRSC-11807, When supporting undo delivery for direct delivery deliv_no became unique for serials parts and needed new key.
--  170911           Hence made the attributes configuration_id_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, handling_unit_id to key
--  170831           and made necessary changes to the method Remove_Session___. 
--  150417  JeLise   LIM-163, Added handling_unit_id_ to method New.
--  140728  RoJalk   Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Remove_Old_Sessions___
IS
   CURSOR get_old_records IS
      SELECT DISTINCT session_id
        FROM TEMPORARY_MUL_TIER_DIRDEL_TAB
       WHERE TRUNC(rowversion) < TRUNC(SYSDATE) - 7;
BEGIN
   FOR rec_ IN get_old_records LOOP     
      Remove_Session___(rec_.session_id);  
   END LOOP;
END Remove_Old_Sessions___;

PROCEDURE Remove_Session___ (
   session_id_ IN NUMBER)
IS
   objid_      TEMPORARY_MUL_TIER_DIRDEL.objid%TYPE;
   objversion_ TEMPORARY_MUL_TIER_DIRDEL.objversion%TYPE;
   remrec_     TEMPORARY_MUL_TIER_DIRDEL_TAB%ROWTYPE;
      
   CURSOR get_rec(session_id_ NUMBER) IS
      SELECT order_no, line_no, rel_no, line_item_no, deliv_no, configuration_id, lot_batch_no, 
             serial_no, waiv_dev_rej_no, eng_chg_level, handling_unit_id
        FROM TEMPORARY_MUL_TIER_DIRDEL_TAB
       WHERE session_id = session_id_
         FOR UPDATE;
BEGIN
   FOR rec_ IN get_rec(session_id_) LOOP
      remrec_ := Lock_By_Keys___(session_id_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.deliv_no, rec_.configuration_id,
                                 rec_.lot_batch_no, rec_.serial_no, rec_.waiv_dev_rej_no, rec_.eng_chg_level, rec_.handling_unit_id);
      Check_Delete___(remrec_);
      Get_Id_Version_By_Keys___(objid_,
                                objversion_,
                                session_id_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.deliv_no, rec_.configuration_id,
                                rec_.lot_batch_no, rec_.serial_no, rec_.waiv_dev_rej_no, rec_.eng_chg_level, rec_.handling_unit_id);
      Delete___(objid_, remrec_);   
   END LOOP;
END Remove_Session___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Session (
   session_id_ IN NUMBER)
IS
BEGIN
   Remove_Session___(session_id_);
   Remove_Old_Sessions___;
END Remove_Session;   

   
PROCEDURE Check_Create_Session (
   mul_tier_dirdel_allowed_ OUT    VARCHAR2,
   session_id_              IN OUT NUMBER,  
   order_no_                IN     VARCHAR2 )
IS
   media_code_            VARCHAR2(30) := NULL;
   order_rec_             Customer_Order_API.Public_Rec;
   cust_ord_customer_rec_ Cust_Ord_Customer_API.Public_Rec; 
BEGIN
   order_rec_             := Customer_Order_API.Get(order_no_);
   cust_ord_customer_rec_ := Cust_Ord_Customer_API.Get(order_rec_.customer_no);
   media_code_            := Cust_Ord_Customer_API.Get_Default_Media_Code(order_rec_.customer_no, 'DIRDEL');
   
   IF (media_code_ IS NOT NULL) AND (Cust_Ord_Customer_API.Get_Mul_Tier_Del_Notificat_Db(order_rec_.customer_no)= 'TRUE') THEN
      mul_tier_dirdel_allowed_ := 'TRUE';
      IF (session_id_ IS NULL) THEN
         session_id_ := Get_Next_Session_Id();
      END IF;   
   ELSE
      mul_tier_dirdel_allowed_ := 'FALSE';
   END IF;  
END Check_Create_Session;   

   
FUNCTION Get_Next_Session_Id RETURN NUMBER
IS
   session_id_ NUMBER;
   CURSOR get_id IS
      SELECT temporary_mul_tier_dirdel_seq.nextval
      FROM dual;
BEGIN
   OPEN  get_id;
   FETCH get_id INTO session_id_;
   CLOSE get_id;
   RETURN session_id_;
END Get_Next_Session_Id;

   
FUNCTION Check_Session_Exist (
   session_id_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_         NUMBER;
   session_found_ VARCHAR2(5):='FALSE';
   
   CURSOR session_exist IS
      SELECT 1
        FROM TEMPORARY_MUL_TIER_DIRDEL_TAB
       WHERE session_id = session_id_;
BEGIN
   OPEN  session_exist;
   FETCH session_exist INTO dummy_;
   IF (session_exist%FOUND) THEN
      session_found_ := 'TRUE';
   END IF;
   CLOSE session_exist;
   RETURN session_found_;
END Check_Session_Exist;

   
PROCEDURE New (
   session_id_          IN NUMBER,
   order_no_            IN VARCHAR2, 
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,              
   line_item_no_        IN NUMBER,
   deliv_no_            IN NUMBER,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   handling_unit_id_    IN NUMBER,
   quantity_delivered_  IN NUMBER,
   catch_qty_delivered_ IN NUMBER,
   expiration_date_     IN DATE)
IS
   newrec_     TEMPORARY_MUL_TIER_DIRDEL_TAB%ROWTYPE;
BEGIN
   newrec_.session_id := session_id_;
   newrec_.order_no := order_no_;
   newrec_.line_no := line_no_;
   newrec_.rel_no := rel_no_;
   newrec_.line_item_no := line_item_no_;
   newrec_.deliv_no := deliv_no_;
   newrec_.configuration_id := configuration_id_;
   newrec_.lot_batch_no := lot_batch_no_;
   newrec_.serial_no := serial_no_;
   newrec_.eng_chg_level := eng_chg_level_;
   newrec_.waiv_dev_rej_no := waiv_dev_rej_no_;
   newrec_.handling_unit_id := handling_unit_id_;
   newrec_.expiration_date := expiration_date_;
   newrec_.quantity_delivered := quantity_delivered_;
   newrec_.catch_qty_delivered := catch_qty_delivered_;
   
   New___(newrec_); 
   
END New;

