-----------------------------------------------------------------------------
--
--  Logical unit: PartCopyManagerPartca
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170929  AmPalk  STRMF-14410. Merged 137856.
--  170929          DAJOLK  Bug 137856, Modified Copy_Local_Datasets__ by adding conditional check to copy ECOMAN part data.
--  130729  MaIklk  TIBE-1043, Removed inst_UserAllowedSite_ global constant and used conditional compilation instead.
--  100423  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  080314  MaEelk  Bug 70852, Allowed copying of part catalog language descriptions when copying parts.
--  071015  MarSlk  Bug 68047, Added validation in method Copy.
--  060801  NaWilk  Replaced PART_CATALOG_PUB with PART_CATALOG_TAB.
--  060602  MiErlk  Enlarge Description - Changed Variables .
------------------------------------- 13.4.0 --------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  050607  KeFelk  Modifications to Generate_Copy_Event_Parameters in order to deal with previous user settings.
--  050126  Sajjlk  Added back the method Copy_Local_Datasets__.
--  050125  SaJjlk  Removed unused method Copy_Local_Datasets__.
--  050110  KeFelk  Added FROM_SITE_NULL error msg in Copy() method.
--  050105  KeFelk  Removed commented codes and applied Code Review changes.
--  041217  SaRalk  Temporaraly commented some cursors in Copy and Copy_To_Site procedures.
--  041217  SaRalk  Modified procedure Copy_Basic_Dataset and procedure Copy_Local_Datasets__ by replacing the call
--  041217          Part_Copy_Event_Parameter_API.Get_Error_Handling_Flags by Part_Copy_Event_Parameter_API.Get.
--  041213  SaRalk  Changed part_copy_event_parameter_tab to part_copy_event_parameter_pub.
--  041211  JaBalk  Modified Copy_Basic_Dataset method.
--  041129  SaRalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Copy___
--   This method is used to copy site independent data when copying part information.
PROCEDURE Copy___ (
   from_contract_     IN VARCHAR2,
   from_part_no_      IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_part_no_        IN VARCHAR2,
   to_part_desc_      IN VARCHAR2,
   is_background_job_ IN VARCHAR2,
   event_no_          IN NUMBER )
IS
   stmt_   VARCHAR2(2000);

   CURSOR get_module_method IS
      SELECT module, copy_method
        FROM part_copy_module_tab
       ORDER BY execution_order;

BEGIN

   FOR module_method_rec_ IN get_module_method LOOP
      IF (Part_Copy_Event_Parameter_API.Site_Independent_Enabled(event_no_, module_method_rec_.module)) THEN
         stmt_ := 'BEGIN ' ||
                      module_method_rec_.copy_method || '(:from_part_no,
                                                          :to_part_no,
                                                          :to_part_desc,
                                                          :event_no);' ||
                  ' END;';

         @ApproveDynamicStatement(2006-01-23,JaJalk)
         EXECUTE IMMEDIATE stmt_
            USING from_part_no_,
                  to_part_no_,
                  to_part_desc_,
                  event_no_;
      END IF;
   END LOOP;
   
   $IF (Component_Mpccom_SYS.INSTALLED) $THEN
      IF (from_contract_ IS NOT NULL) THEN
         IF (Part_Copy_Event_Parameter_API.Site_Dependent_Enabled(event_no_, NULL)) THEN
            User_Allowed_Site_API.Copy_Part_To_Site (from_contract_,
                                                     from_part_no_,
                                                     to_contract_,
                                                     to_part_no_,
                                                     to_part_desc_,
                                                     is_background_job_,
                                                     event_no_);
                  
         END IF;
      END IF;
   $END
END Copy___;


-- Copy_To_Site___
--   This method is used to copy site dependent data when copying part information.
PROCEDURE Copy_To_Site___ (
   from_contract_ IN VARCHAR2,
   from_part_no_  IN VARCHAR2,
   to_contract_   IN VARCHAR2,
   to_part_no_    IN VARCHAR2,
   to_part_desc_  IN VARCHAR2,
   event_no_      IN NUMBER )
IS
   stmt_   VARCHAR2(2000);

   CURSOR get_module_method IS
      SELECT module, copy_method
        FROM part_copy_module_tab
       ORDER BY execution_order;
BEGIN

   FOR module_method_rec_ IN get_module_method LOOP
      IF (Part_Copy_Event_Parameter_API.Site_Dependent_Enabled(event_no_, module_method_rec_.module)) THEN
         stmt_ := 'BEGIN ' ||
                      module_method_rec_.copy_method || '(:from_contract,
                                                 :from_part_no,
                                                 :to_contract,
                                                 :to_part_no,
                                                 :to_part_desc,
                                                 :event_no);' ||
                  ' END;';
         @ApproveDynamicStatement(2006-01-23,JaJalk)
         EXECUTE IMMEDIATE stmt_
               USING from_contract_,
                     from_part_no_,
                     to_contract_,
                     to_part_no_,
                     to_part_desc_,
                     event_no_;
      END IF;
   END LOOP;
END Copy_To_Site___;


-- Unpack_From_Attr___
--   This method is used to unpack the IN parameter attr_ and assign values to variables.
PROCEDURE Unpack_From_Attr___ (
   from_contract_     OUT VARCHAR2,
   from_part_no_      OUT VARCHAR2,
   to_contract_       OUT VARCHAR2,
   to_part_no_        OUT VARCHAR2,
   to_part_desc_      OUT VARCHAR2,
   is_background_job_ OUT VARCHAR2,
   event_no_          OUT NUMBER,
   attr_              IN  VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
BEGIN

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'FROM_CONTRACT') THEN
         from_contract_ := value_;
      ELSIF (name_ = 'FROM_PART_NO') THEN
         from_part_no_ := value_;
      ELSIF (name_ = 'TO_CONTRACT') THEN
         to_contract_ := value_;
      ELSIF (name_ = 'TO_PART_NO') THEN
         to_part_no_ := value_;
      ELSIF (name_ = 'TO_PART_DESC') THEN
         to_part_desc_ := value_;
      ELSIF (name_ = 'IS_BACKGROUND_JOB') THEN
         is_background_job_ := value_;
      ELSIF (name_ = 'EVENT_NO') THEN
         event_no_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
END Unpack_From_Attr___;


-- Pack_Into_Attr___
--   This method is used to add variable values to IN OUT parameter attr_.
PROCEDURE Pack_Into_Attr___ (
   attr_              OUT VARCHAR2,
   from_contract_     IN  VARCHAR2,
   from_part_no_      IN  VARCHAR2,
   to_contract_       IN  VARCHAR2,
   to_part_no_        IN  VARCHAR2,
   to_part_desc_      IN  VARCHAR2,
   is_background_job_ IN  VARCHAR2,
   event_no_          IN  NUMBER )
IS
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FROM_CONTRACT', from_contract_, attr_);
   Client_SYS.Add_To_Attr('FROM_PART_NO' , from_part_no_ , attr_);
   Client_SYS.Add_To_Attr('TO_CONTRACT'  , to_contract_  , attr_);
   Client_SYS.Add_To_Attr('TO_PART_NO'   , to_part_no_   , attr_);
   Client_SYS.Add_To_Attr('TO_PART_DESC' , to_part_desc_ , attr_);
   Client_SYS.Add_To_Attr('EVENT_NO'     , event_no_     , attr_);
   Client_SYS.Add_To_Attr('IS_BACKGROUND_JOB', is_background_job_, attr_);
END Pack_Into_Attr___;


FUNCTION Get_Next_Event_No___ RETURN NUMBER
IS
   event_no_ NUMBER;
BEGIN
   SELECT part_copy_event_parameter_seq.NEXTVAL INTO event_no_ FROM  dual;
   RETURN event_no_;
END Get_Next_Event_No___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy__
--   This method unpacks the Attr_ and calls the Copy___.
PROCEDURE Copy__ (
   attr_ IN VARCHAR2 )
IS
   from_contract_     VARCHAR2(5);
   from_part_no_      VARCHAR2(25);
   to_contract_       VARCHAR2(5);
   to_part_no_        VARCHAR2(25);
   to_part_desc_      PART_CATALOG_TAB.Description%TYPE;
   is_background_job_ VARCHAR2(5);
   event_no_          NUMBER;
BEGIN

   Unpack_From_Attr___(from_contract_,
                       from_part_no_,
                       to_contract_,
                       to_part_no_,
                       to_part_desc_,
                       is_background_job_,
                       event_no_,
                       attr_);

   Copy___(from_contract_,
           from_part_no_,
           to_contract_,
           to_part_no_,
           to_part_desc_,
           is_background_job_,
           event_no_);
END Copy__;


-- Copy_To_Site__
--   This method unpacks the Attr_ and calls CopyToSite___.
PROCEDURE Copy_To_Site__ (
   attr_ IN VARCHAR2 )
IS
   from_contract_     VARCHAR2(5);
   from_part_no_      VARCHAR2(25);
   to_contract_       VARCHAR2(5);
   to_part_no_        VARCHAR2(25);
   to_part_desc_      PART_CATALOG_TAB.Description%TYPE;
   is_background_job_ VARCHAR2(5);
   event_no_          NUMBER;
BEGIN

   Unpack_From_Attr___(from_contract_,
                       from_part_no_,
                       to_contract_,
                       to_part_no_,
                       to_part_desc_,
                       is_background_job_,
                       event_no_,
                       attr_);

   Copy_To_Site___(from_contract_,
                   from_part_no_,
                   to_contract_,
                   to_part_no_,
                   to_part_desc_,
                   event_no_);
END Copy_To_Site__;


PROCEDURE Copy_Local_Datasets__ (
   from_part_no_  IN VARCHAR2,
   to_part_no_    IN VARCHAR2,
   to_part_desc_  IN VARCHAR2,
   event_no_      IN NUMBER )
IS
   event_param_rec_ Part_Copy_Event_Parameter_API.Public_Rec;
BEGIN

   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'PARTCA',
                                                        'GENERAL');

   IF (event_param_rec_.enabled = 'TRUE') THEN
      Part_Catalog_API.Copy(from_part_no_,
                      to_part_no_,
                      to_part_desc_,
                      event_param_rec_.cancel_when_no_source,
                      event_param_rec_.cancel_when_existing_copy);
                      
      $IF Component_Ecoman_SYS.INSTALLED $THEN
         event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                              'ECOMAN',
                                                              'EMISSIONECO');                     
         IF (event_param_rec_.enabled = 'TRUE') THEN
            Ecoman_Part_Info_API.Copy_Data(from_part_no_, 
                                           to_part_no_,                                           
                                           event_param_rec_.cancel_when_no_source,
                                           event_param_rec_.cancel_when_existing_copy);
         END IF;         
      $END
                      
   END IF;

   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'PARTCA',
                                                        'MANFACT');

   IF (event_param_rec_.enabled = 'TRUE') THEN
      Part_Manufacturer_API.Copy(from_part_no_,
                                 to_part_no_,
                                 event_param_rec_.cancel_when_no_source,
                                 event_param_rec_.cancel_when_existing_copy);
   END IF;

   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'PARTCA',
                                                        'ALTPART');

   IF (event_param_rec_.enabled = 'TRUE') THEN
      Part_Catalog_Alternative_API.Copy(from_part_no_,
                                        to_part_no_,
                                        event_param_rec_.cancel_when_no_source,
                                        event_param_rec_.cancel_when_existing_copy);
   END IF;

   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'PARTCA',
                                                        'CONOBJ');

   IF (event_param_rec_.enabled = 'TRUE') THEN
      Part_Catalog_API.Copy_Connected_Objects(from_part_no_,
                                              to_part_no_,
                                              event_param_rec_.cancel_when_no_source,
                                              event_param_rec_.cancel_when_existing_copy);
   END IF;

   event_param_rec_ := Part_Copy_Event_Parameter_API.Get(event_no_,
                                                        'PARTCA',
                                                        'LANGPARTCA');

   IF (event_param_rec_.enabled = 'TRUE') THEN
      Part_Catalog_Language_API.Copy(from_part_no_,
                                     to_part_no_,
                                     event_param_rec_.cancel_when_no_source,
                                     event_param_rec_.cancel_when_existing_copy);
   END IF;
END Copy_Local_Datasets__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   This method calls the relevant Copy method depending on the value
--   of is_background_job_.
PROCEDURE Copy (
   from_contract_     IN VARCHAR2,
   from_part_no_      IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_part_no_        IN VARCHAR2,
   to_part_desc_      IN VARCHAR2,
   is_background_job_ IN VARCHAR2,
   event_no_          IN NUMBER )
IS  
   attr_         VARCHAR2(2000);
   description_  VARCHAR2(2000);
BEGIN

   Part_Copy_Event_Parameter_API.Cleanup_Part_Parameters(event_no_);

   IF ((to_part_no_  = from_part_no_) AND (to_contract_ = from_contract_)) THEN
      Error_SYS.Record_General(lu_name_, 'SAME_PART_SITE: Site and Part No cannot be the same for Destination and Source');
   END IF;

   $IF (Component_Mpccom_SYS.INSTALLED) $THEN    

      IF (from_contract_ IS NOT NULL) THEN
         Site_API.Exist(from_contract_);
         User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, from_contract_);        
      ELSIF (Part_Copy_Event_Parameter_API.Site_Dependent_Enabled(event_no_, NULL)) THEN
         Error_SYS.Record_General(lu_name_,
            'FROM_SITE_NULL: Site dependent objects cannot be copied unless a value is given for From Site');
      END IF;

      IF ((to_contract_ IS NOT NULL) AND (INSTR(to_contract_, '%') = 0)) THEN
         Site_API.Exist(to_contract_);
         User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, to_contract_);        
      END IF;
   $ELSE
      IF ((from_contract_ IS NOT NULL) OR (to_contract_ IS NOT NULL)) THEN
         Error_SYS.Record_General(lu_name_,
            'NOT_ALLOWED_SITE: Site information can not be processed since object Site is not installed.');
      END IF;
   $END

   IF (is_background_job_ = 'TRUE') THEN
      Pack_Into_Attr___(attr_,
                        from_contract_,
                        from_part_no_,
                        to_contract_,
                        to_part_no_,
                        to_part_desc_,
                        is_background_job_,
                        event_no_);

      description_ := Language_SYS.Translate_Constant(
                         lu_name_,
                         'COPY_FROM_PART: Copy from part number :P1 to part number :P2',
                         NULL,
                         from_part_no_,
                         to_part_no_);
      Transaction_SYS.Deferred_Call('Part_Copy_Manager_Partca_API.Copy__', attr_, description_);

   ELSE
      Copy___(from_contract_,
              from_part_no_,
              to_contract_,
              to_part_no_,
              to_part_desc_,
              is_background_job_,
              event_no_);
   END IF;
END Copy;


-- Copy_To_Site
--   This method calls the relevant Copy_To_Site methods depending
--   on the value of is_background_job_.
PROCEDURE Copy_To_Site (
   from_contract_     IN VARCHAR2,
   from_part_no_      IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_part_no_        IN VARCHAR2,
   to_part_desc_      IN VARCHAR2,
   is_background_job_ IN VARCHAR2,
   event_no_          IN NUMBER )
IS
   description_       VARCHAR2(2000);
   to_description_    VARCHAR2(2000);
   attr_              VARCHAR2(2000);
BEGIN

   IF (is_background_job_ = 'TRUE') THEN
      Pack_Into_Attr___(attr_,
                        from_contract_,
                        from_part_no_,
                        to_contract_,
                        to_part_no_,
                        to_part_desc_,
                        is_background_job_,
                        event_no_);

      description_    := Language_SYS.Translate_Constant(
                            lu_name_,
                            'COPY_DATA_FROM_PART: Copy data from part number :P1 on site :P2',
                            NULL,
                            from_part_no_,
                            from_contract_);

      to_description_ := Language_SYS.Translate_Constant(
                            lu_name_,
                            'COPY_DATA_TO_PART:  to part number :P1 on site :P2',
                            NULL,
                            to_part_no_,
                            to_contract_);

      description_ := description_ || to_description_;

      Transaction_SYS.Deferred_Call('Part_Copy_Manager_Partca_API.Copy_To_Site__', attr_, description_);

   ELSE
      Copy_To_Site___(from_contract_,
                      from_part_no_,
                      to_contract_,
                      to_part_no_,
                      to_part_desc_,
                      event_no_);
   END IF;
END Copy_To_Site;


-- Generate_Copy_Event_Parameters
--   This method is used to copy data from part_copy_module_dataset_tab to this LU.
PROCEDURE Generate_Copy_Event_Parameters (
   event_no_ OUT NUMBER,
   default_  IN VARCHAR2 )
IS
   user_id_                   VARCHAR2(30);
   latest_event_no_           NUMBER;
   parameter_rec_             Part_Copy_Event_Parameter_API.Public_Rec;
   enabled_                   VARCHAR2(5);
   cancel_when_no_source_     VARCHAR2(5);
   cancel_when_existing_copy_ VARCHAR2(5);

   CURSOR get_module_dataset IS
      SELECT module,
             dataset_id,
             enabled,
             cancel_when_no_source,
             cancel_when_existing_copy
        FROM part_copy_module_dataset_tab;
BEGIN
   
   event_no_        := Get_Next_Event_No___();
   user_id_         := Fnd_Session_Api.Get_Fnd_User;
   latest_event_no_ := Part_Copy_Event_Parameter_API.Get_Latest_Event_No(user_id_);
   
   FOR dataset_rec_ IN get_module_dataset LOOP
      IF (default_ = 'FALSE' AND latest_event_no_ IS NOT NULL) THEN
         parameter_rec_ := Part_Copy_Event_Parameter_API.Get(latest_event_no_,
                                                             dataset_rec_.module,
                                                             dataset_rec_.dataset_id);
         enabled_                   := NVL(parameter_rec_.enabled, 'FALSE');
         cancel_when_no_source_     := NVL(parameter_rec_.cancel_when_no_source, dataset_rec_.enabled);
         cancel_when_existing_copy_ := NVL(parameter_rec_.cancel_when_existing_copy, dataset_rec_.cancel_when_existing_copy);
      ELSE
         enabled_                   := dataset_rec_.enabled;
         cancel_when_no_source_     := dataset_rec_.cancel_when_no_source;
         cancel_when_existing_copy_ := dataset_rec_.cancel_when_existing_copy;
      END IF;      

      Part_Copy_Event_Parameter_API.New(event_no_,
                                        dataset_rec_.module,
                                        dataset_rec_.dataset_id,
                                        enabled_,
                                        cancel_when_no_source_,
                                        cancel_when_existing_copy_);      
   END LOOP;
END Generate_Copy_Event_Parameters;



