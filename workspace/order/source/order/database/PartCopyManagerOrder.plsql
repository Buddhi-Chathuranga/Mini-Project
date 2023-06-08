-----------------------------------------------------------------------------
--
--  Logical unit: PartCopyManagerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151106  HimRlk  Bug 123910, Modified Copy to handle copying of customer warranty.
--  100518  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  080306  MaMalk  Bug 70852, Modified method copy to handle the copying of sales part language descriptions.
--  050922  NaLrlk  Removed unused variables.
--  050208  KeFelk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   This method is used to copy site dependent information like general,
--   characteristics document texts and connected objects.
PROCEDURE Copy (
   from_contract_ IN VARCHAR2,
   from_part_no_  IN VARCHAR2,
   to_contract_   IN VARCHAR2,
   to_part_no_    IN VARCHAR2,
   to_part_desc_  IN VARCHAR2,
   event_no_      IN NUMBER )
IS
   event_param_rec_ Part_Copy_Event_Parameter_API.Public_Rec;  
BEGIN
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_, 'ORDER', 'GENSP');
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Sales_Part_API.Copy(from_contract_,
                          from_part_no_,
                          to_contract_,
                          to_part_no_,
                          to_part_desc_,
                          event_param_rec_.cancel_when_no_source, 
                          event_param_rec_.cancel_when_existing_copy);
   END IF;
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_, 'ORDER', 'PARTCHAR'); 
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Sales_Part_API.Copy_Characteristics(from_contract_,
                                          from_part_no_,
                                          to_contract_,
                                          to_part_no_,
                                          event_param_rec_.cancel_when_no_source, 
                                          event_param_rec_.cancel_when_existing_copy);
   END IF;

   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_, 'ORDER', 'DOCTSP'); 
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Sales_Part_API.Copy_Note_Texts(from_contract_,
                                     from_part_no_,
                                     to_contract_,
                                     to_part_no_,
                                     event_param_rec_.cancel_when_no_source, 
                                     event_param_rec_.cancel_when_existing_copy);
   END IF;

   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_, 'ORDER', 'CONOSP'); 
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Sales_Part_API.Copy_Connected_Objects(from_contract_,
                                            from_part_no_,
                                            to_contract_,
                                            to_part_no_,
                                            event_param_rec_.cancel_when_no_source, 
                                            event_param_rec_.cancel_when_existing_copy);
   END IF;
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_, 'ORDER', 'LANGSP');
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Sales_Part_API.Copy_Language_Descriptions(from_contract_,
                                                from_part_no_,
                                                to_contract_,
                                                to_part_no_,
                                                event_param_rec_.cancel_when_no_source, 
                                                event_param_rec_.cancel_when_existing_copy);
   END IF;
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_, 'ORDER', 'CWARSP');
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Sales_Part_API.Copy_Customer_Warranty(from_contract_,
                                            from_part_no_,
                                            to_contract_,
                                            to_part_no_,
                                            event_param_rec_.cancel_when_no_source, 
                                            event_param_rec_.cancel_when_existing_copy);
   END IF;
END Copy; 



