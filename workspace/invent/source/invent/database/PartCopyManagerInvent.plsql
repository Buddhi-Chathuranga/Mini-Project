-----------------------------------------------------------------------------
--
--  Logical unit: PartCopyManagerInvent
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160129  JeLise   LIM-5884, Added call to Part_Handling_Unit_API.Copy for data set HUCAPACITY.
--  151120  MaEelk   LIM-4472, Removed the call to the obsolete package Invent_Part_Pallet_Refill.API when the data set id is PARTPALL.
--  110314  DaZase   Changed call to Inventory_Part_Pallet_API.Copy so it calls Invent_Part_Pallet_Refill_API.Copy instead (Inventory_Part_Pallet_API is obsolete).
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  050301  KeFelk   small changes to previous change.
--  050224  KeFelk   Added logic to Copy() in order to avoid creating the PP when IP craeting.
--  050207  KeFelk   Removed obsolete two local variables in Copy. 
--  050201  KeFelk   Modified Copy method by replacing Inv_Part_Discrete_Char_API.Copy_Discrete_Char and 
--  050201           Inv_Part_Indiscrete_Char_API.Copy_In_Discrete_Char with Inventory_Part_API.Copy_Characteristics.
--  050127  KanGlk   Modified Copy method by replacing Inventory_Part_Char_API.Copy 
--  050112           with Inv_Part_Discrete_Char_API.Copy_Discrete_Char and Inv_Part_Indiscrete_Char_API.Copy_In_Discrete_Char
--  041216  SaRalk   Modified Copy methods by replacing Part_Copy_Event_Parameter_API.Get_Error_Handling_Flags
--  041216           with Part_Copy_Event_Parameter_API.Get.
--  041214  SaRalk   Removed the cursors with part_copy_event_parameter_pub and added calls
--  041214           to Part_Copy_Event_Parameter_API.Get_Error_Handling_Flags.
--  041213  SaRalk   Changed part_copy_event_parameter_tab to part_copy_event_parameter_pub. 
--  041211  JaBalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   This method is used to copy site independent information like transport data.
PROCEDURE Copy (
   from_part_no_ IN VARCHAR2,
   to_part_no_   IN VARCHAR2,
   to_part_desc_ IN VARCHAR2,
   event_no_     IN NUMBER )
IS
   event_param_rec_ Part_Copy_Event_Parameter_API.Public_Rec;
BEGIN
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'INVENT',
                                                        'TRANSPORT');
   
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Part_Catalog_Invent_Attrib_API.Copy(from_part_no_,
                                          to_part_no_,
                                          event_param_rec_.cancel_when_no_source, 
                                          event_param_rec_.cancel_when_existing_copy);                      
   END IF;
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'INVENT',
                                                        'HUCAPACITY');
   
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Part_Handling_Unit_API.Copy(from_part_no_,
                                  to_part_no_,
                                  event_param_rec_.cancel_when_no_source, 
                                  event_param_rec_.cancel_when_existing_copy);
   END IF;
END Copy;


-- Copy
--   This method is used to copy site dependent information like general,
--   acquisition, cost, miscellaneous, planning data, alternate parts,
--   default locations, characteristics and document text.
PROCEDURE Copy (
   from_contract_ IN VARCHAR2,
   from_part_no_  IN VARCHAR2,
   to_contract_   IN VARCHAR2,
   to_part_no_    IN VARCHAR2,
   to_part_desc_  IN VARCHAR2,
   event_no_      IN NUMBER )
IS    
   attr_            VARCHAR2(2000);
   event_param_rec_ Part_Copy_Event_Parameter_API.Public_Rec;        
BEGIN
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'INVENT',
                                                        'GENERAL');

   IF (event_param_rec_.enabled = 'TRUE') THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', to_part_desc_, attr_); 
      Inventory_Part_API.Copy(to_contract_,
                              to_part_no_,
                              from_contract_,
                              from_part_no_,
                              attr_,  
                              event_param_rec_.cancel_when_no_source, 
                              event_param_rec_.cancel_when_existing_copy,
                              'FALSE');                              
   END IF;
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                         'INVENT',
                                                         'DEFLOC'); 

   IF (event_param_rec_.enabled = 'TRUE') THEN
      Inventory_Part_Def_Loc_API.Copy(from_contract_,
                                      from_part_no_,
                                      to_contract_,
                                      to_part_no_,
                                      event_param_rec_.cancel_when_no_source, 
                                      event_param_rec_.cancel_when_existing_copy);                                                                     
   END IF;
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'INVENT',
                                                        'PARTCHAR');

   IF (event_param_rec_.enabled = 'TRUE') THEN
      Inventory_Part_API.Copy_Characteristics(from_contract_,
                                              from_part_no_,
                                              to_contract_,
                                              to_part_no_,
                                              event_param_rec_.cancel_when_no_source, 
                                              event_param_rec_.cancel_when_existing_copy);
   END IF;
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'INVENT',
                                                        'DOCTXT');     
                                                      
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Inventory_Part_API.Copy_Note_Texts(from_contract_,
                                         from_part_no_,
                                         to_contract_,
                                         to_part_no_,
                                         event_param_rec_.cancel_when_no_source, 
                                         event_param_rec_.cancel_when_existing_copy);                                                                                                                                                  
   END IF;
   
   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'INVENT',
                                                        'CONOBJ');     
                                                                                                              
   IF (event_param_rec_.enabled = 'TRUE') THEN
      Inventory_Part_API.Copy_Connected_Objects(from_contract_,
                                                from_part_no_,
                                                to_contract_,
                                                to_part_no_,
                                                event_param_rec_.cancel_when_no_source, 
                                                event_param_rec_.cancel_when_existing_copy);                                                                                                                                                                                                                                                    
   END IF;         
END Copy;

