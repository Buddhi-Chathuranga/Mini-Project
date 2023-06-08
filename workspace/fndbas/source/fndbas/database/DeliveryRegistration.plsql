-----------------------------------------------------------------------------
--
--  Logical unit: DeliveryRegistration
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200827  CHAHLK  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- New
--   Public New.
PROCEDURE New (
   delivery_id_            IN VARCHAR2,
   product_version_        IN VARCHAR2,
   baseline_delivery_id_   IN VARCHAR2,
   created_date_           IN DATE,
   delivery_package_name_  IN VARCHAR2 DEFAULT NULL)
IS
   newrec_       DELIVERY_REGISTRATION_TAB%ROWTYPE;
BEGIN
   newrec_.id := delivery_registration_seq.nextval;
   newrec_.delivery_id := delivery_id_;
   newrec_.product_version := product_version_;
   newrec_.baseline_delivery_id := baseline_delivery_id_;
   IF created_date_ IS NULL THEN
      newrec_.created_time := sysdate;
   ELSE
      newrec_.created_time := created_date_;
   END IF;
   newrec_.delivery_package_name := delivery_package_name_;
   New___(newrec_);  
END New;

