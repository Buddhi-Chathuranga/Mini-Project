-----------------------------------------------------------------------------
--
--  Logical unit: TransRevalEvent
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150825  AyAmlk  Bug 114937, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT NOCOPY trans_reval_event_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   SELECT trans_reval_event_id_seq.nextval INTO newrec_.event_id FROM DUAL;
   newrec_.user_id                    := Fnd_Session_API.Get_Fnd_User;
   newrec_.date_time_started          := Site_API.Get_Site_Date(newrec_.contract);
   newrec_.transaction_update_counter := 0;
   
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     trans_reval_event_tab%ROWTYPE,
   newrec_     IN OUT NOCOPY trans_reval_event_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   site_date_  DATE;
BEGIN
   site_date_ := Site_API.Get_Site_Date(newrec_.contract);   
   newrec_.date_time_finished := site_date_;   
   IF (Transaction_SYS.Is_Session_Deferred() = FALSE) THEN
      newrec_.date_time_online_finished := site_date_;
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);  
END Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   event_id_                      OUT NUMBER,
   part_no_                       IN  VARCHAR2,
   contract_                      IN  VARCHAR2,
   shpord_order_no_               IN  VARCHAR2  DEFAULT NULL,
   shpord_release_no_             IN  VARCHAR2  DEFAULT NULL,
   shpord_sequence_no_            IN  VARCHAR2  DEFAULT NULL,
   shpord_line_item_no_           IN  NUMBER    DEFAULT NULL,
   purch_order_no_                IN  VARCHAR2  DEFAULT NULL,
   purch_line_no_                 IN  VARCHAR2  DEFAULT NULL,
   purch_release_no_              IN  VARCHAR2  DEFAULT NULL,
   purch_receipt_no_              IN  NUMBER    DEFAULT NULL,
   purch_charge_sequence_no_      IN  NUMBER    DEFAULT NULL,   
   invoice_id_                    IN  NUMBER    DEFAULT NULL,
   invoice_company_               IN  VARCHAR2  DEFAULT NULL,   
   purch_receipt_cost_            IN  NUMBER    DEFAULT NULL,
   average_invoice_price_         IN  NUMBER    DEFAULT NULL,
   invoice_qty_                   IN  NUMBER    DEFAULT NULL,
   purch_price_diff_per_unit_     IN  NUMBER    DEFAULT NULL,
   supplier_invoice_cancelled_    IN  BOOLEAN   DEFAULT NULL,
   external_direct_delivery_      IN  BOOLEAN   DEFAULT NULL )
IS
   newrec_       trans_reval_event_tab%ROWTYPE;
BEGIN
   newrec_.part_no  := part_no_;
   newrec_.contract := contract_;
   IF (shpord_order_no_ IS NOT NULL) THEN
      newrec_.shpord_order_no := shpord_order_no_;
   END IF;
   IF (shpord_release_no_ IS NOT NULL) THEN
      newrec_.shpord_release_no := shpord_release_no_;
   END IF;
   IF (shpord_sequence_no_ IS NOT NULL) THEN
      newrec_.shpord_release_no := shpord_sequence_no_;
   END IF;
   IF (shpord_line_item_no_ IS NOT NULL) THEN
      newrec_.shpord_line_item_no := shpord_line_item_no_;
   END IF;
   IF (purch_order_no_ IS NOT NULL) THEN
      newrec_.purch_order_no := purch_order_no_;
   END IF;
   IF (purch_line_no_ IS NOT NULL) THEN
      newrec_.purch_line_no := purch_line_no_;
   END IF;
   IF (purch_release_no_ IS NOT NULL) THEN
      newrec_.purch_release_no := purch_release_no_;
   END IF;
   IF (purch_receipt_no_ IS NOT NULL) THEN
      newrec_.purch_receipt_no := purch_receipt_no_;
   END IF;
   IF (purch_charge_sequence_no_ IS NOT NULL) THEN
      newrec_.purch_charge_sequence_no := purch_charge_sequence_no_;
   END IF;
   IF (invoice_id_ IS NOT NULL) THEN
      newrec_.invoice_id := invoice_id_;
   END IF;
   IF (invoice_company_ IS NOT NULL) THEN
      newrec_.invoice_company := invoice_company_;
   END IF;
   IF (purch_receipt_cost_ IS NOT NULL) THEN
      newrec_.purch_receipt_cost := purch_receipt_cost_;
   END IF;
   IF (average_invoice_price_ IS NOT NULL) THEN
      newrec_.average_invoice_price := average_invoice_price_;
   END IF;
   IF (invoice_qty_ IS NOT NULL) THEN
      newrec_.invoice_qty := invoice_qty_;
   END IF;
   IF (purch_price_diff_per_unit_ IS NOT NULL) THEN
      newrec_.purch_price_diff_per_unit := purch_price_diff_per_unit_;
   END IF;
   IF (supplier_invoice_cancelled_ IS NOT NULL) THEN
      IF (supplier_invoice_cancelled_) THEN
         newrec_.supplier_invoice_cancelled := Fnd_Boolean_API.db_true;
      ELSE
         newrec_.supplier_invoice_cancelled := Fnd_Boolean_API.db_false;
      END IF;
   END IF;
   IF (external_direct_delivery_ IS NOT NULL) THEN
      IF (external_direct_delivery_) THEN
         newrec_.external_direct_delivery := Fnd_Boolean_API.db_true;
      ELSE
         newrec_.external_direct_delivery := Fnd_Boolean_API.db_false;
      END IF;
   END IF;

   New___(newrec_);
   event_id_ := newrec_.event_id;
   
END New;

PROCEDURE Finish (
   event_id_                   IN NUMBER,
   revaluation_is_impossible_  IN BOOLEAN,
   transaction_update_counter_ IN NUMBER)
IS
   newrec_     trans_reval_event_tab%ROWTYPE;
BEGIN
   
   newrec_ := Lock_By_Keys___(event_id_);
   newrec_.transaction_update_counter := newrec_.transaction_update_counter + transaction_update_counter_;
   IF (revaluation_is_impossible_) THEN
      newrec_.revaluation_impossible := Fnd_Boolean_API.db_true;
   ELSE
      newrec_.revaluation_impossible := Fnd_Boolean_API.db_false;
   END IF;

   Modify___(newrec_);

END Finish;