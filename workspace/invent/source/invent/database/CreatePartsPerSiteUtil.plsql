-----------------------------------------------------------------------------
--
--  Logical unit: CreatePartsPerSiteUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140313  AyAmlk   Bug 115778, Modified Create_Parts_Per_Site__ () by fetching the Site country instead of Delivery Address Country.
--  130731  UdGnlk   TIBE-835, Removed the dynamic code and modify to conditional compilation.
--  100511  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  070316  AmPalk   Added a COMMIT just befor the part creation loop ends in Create_Parts_Per_Site__.
--  070308  AmPalk   Modified cursor get_child_nodes in Create_Parts_Per_Site__.
--  070130  NiDalk   Modified Create_Parts_Per_Site__ to get correct no of created suppliers and modified Get_Priority method to include supplier. 
--  070123  NiDalk   Added FUNCTION Get_Priority.
--  070123  MiErlk   Modified Create_Parts_Per_Site__ to check create_supp_part.
--  070122  NiDalk   Modified Create_Parts_Per_Site__ to add part create status information messages.
--  070117  NiDalk   Modified where clause of CURSOR get_child_nodes in Create_Parts_Per_Site__.
--  070111  NiDalk   Corrected a small spelling error.
--  070110  KeFelk   Changes to get_child_nodes cursor.
--  061227  KeFelk   Removed all Save Points and Commits.
--  061219  MiErlk   Modified the PROCEDURE Create_Parts_Per_Site__ .
--  061214  IsWilk   Modified the PROCEDURE Create_Parts_Per_Site__ .
--  061213  IsWilk   Modified the PROCEDURE Create_Parts_Per_Site__ .
--  061208  IsWilk   Modified the PROCEDURE Create_Parts_Per_Site__ .
--  061205  IsWilk   Modified the PROCEDURE Create_Parts_Per_Sites__ by changing the description_.
--  061127  IsWilk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Attr_To_Part_Cre_Hist_Rec___
--   Returns the part_create_hist_rec extracting values from the input attr.
FUNCTION Attr_To_Part_Cre_Hist_Rec___ (
   attr_ IN VARCHAR2 ) RETURN Create_Parts_Per_Site_Hist_API.Part_Creation_Hist_Rec
IS
   part_creation_hist_rec_ Create_Parts_Per_Site_Hist_API.Part_Creation_Hist_Rec;
BEGIN

   part_creation_hist_rec_.history_no         := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('HISTORY_NO', attr_));
   part_creation_hist_rec_.assortment_id      := Client_SYS.Get_Item_Value('ASSORTMENT_ID', attr_);
   part_creation_hist_rec_.assortment_node_id := Client_SYS.Get_Item_Value('ASSORTMENT_NODE_ID', attr_);
   part_creation_hist_rec_.contract           := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   part_creation_hist_rec_.create_sales_part  := Client_SYS.Get_Item_Value('CREATE_SALES_PART', attr_);
   part_creation_hist_rec_.create_supp_part   := Client_SYS.Get_Item_Value('CREATE_SUPP_PART', attr_);

   RETURN (part_creation_hist_rec_);
END Attr_To_Part_Cre_Hist_Rec___;


-- Part_Cre_Hist_Rec_To_Attr___
--   Converts input part_creation_hist_rec to an attribute string.
FUNCTION Part_Cre_Hist_Rec_To_Attr___ (
   part_creation_hist_rec_ IN Create_Parts_Per_Site_Hist_API.Part_Creation_Hist_Rec) RETURN VARCHAR2
IS
   attr_    VARCHAR2(2000);
BEGIN

   Client_SYS.Add_To_Attr('HISTORY_NO'         , part_creation_hist_rec_.history_no         , attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID'      , part_creation_hist_rec_.assortment_id      , attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_NODE_ID' , part_creation_hist_rec_.assortment_node_id , attr_);
   Client_SYS.Add_To_Attr('CONTRACT'           , part_creation_hist_rec_.contract           , attr_);
   Client_SYS.Add_To_Attr('CREATE_SALES_PART'  , part_creation_hist_rec_.create_sales_part  , attr_);
   Client_SYS.Add_To_Attr('CREATE_SUPP_PART'   , part_creation_hist_rec_.create_supp_part   , attr_);
   RETURN (attr_);
END Part_Cre_Hist_Rec_To_Attr___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Parts_Per_Sites__
--   Creates parts for all the site, assortment node combinations to be
--   executed for this run_id_.
PROCEDURE Create_Parts_Per_Sites__ (
   run_id_ IN NUMBER )
IS
   create_parts_per_site_hist_   Create_Parts_Per_Site_Hist_API.Part_Creation_Hist_Tab;
   description_                  VARCHAR2(2000);
   attr_                         VARCHAR2(2000);
BEGIN
   -- Retrieve the table with all the site, assortment node combinations to be executed for this run_id_
   create_parts_per_site_hist_ := Create_Parts_Per_Site_Hist_API.Get_Records_To_Execute__(run_id_);

   IF (create_parts_per_site_hist_.COUNT > 0) THEN
      FOR i IN create_parts_per_site_hist_.FIRST..create_parts_per_site_hist_.LAST LOOP
         attr_ := Part_Cre_Hist_Rec_To_Attr___(create_parts_per_site_hist_(i));

         description_ := Language_SYS.Translate_Constant(lu_name_, 'PARTCREATION: Create Parts for the Assortment Node: '':P1'', and Site: '':P2'' combination',
                                                         p1_ => create_parts_per_site_hist_(i).assortment_node_id,
                                                         p2_ => create_parts_per_site_hist_(i).contract);

         Transaction_SYS.Deferred_Call('CREATE_PARTS_PER_SITE_UTIL_API.Create_Parts_Per_Site__', attr_, description_);
      END LOOP;
   END IF;
END Create_Parts_Per_Sites__;


-- Create_Parts_Per_Site__
--   Creates parts for a site.
PROCEDURE Create_Parts_Per_Site__ (
   attr_ IN VARCHAR2 )
IS
   part_creation_rec_    Create_Parts_Per_Site_Hist_API.Part_Creation_Hist_Rec;
   company_              VARCHAR2(20);
   country_code_         VARCHAR2(3);
   error_message_        VARCHAR2(2000);
   part_no_              VARCHAR2(50);
   part_cre_text_        VARCHAR2(100);   
   invent_create_status_ VARCHAR2(5) := 'FALSE';
   purch_create_status_  VARCHAR2(5) := 'FALSE';
   sales_create_status_  VARCHAR2(5) := 'FALSE';
   part_sup_count_       NUMBER := 0;
   invent_part_no_       NUMBER := 0;
   purch_part_no_        NUMBER := 0;
   sales_part_no_        NUMBER := 0;
   part_supp_no_         NUMBER := 0;

   CURSOR get_child_nodes IS
      SELECT assortment_node_id, part_no
      FROM   assortment_node_tab
      WHERE  part_no IS NOT NULL
      AND    assortment_id = part_creation_rec_.assortment_id
      START WITH assortment_node_id = part_creation_rec_.assortment_node_id
             AND assortment_id = part_creation_rec_.assortment_id
      CONNECT BY PRIOR  assortment_node_id = parent_node
      AND PRIOR assortment_id = assortment_id;
BEGIN

   part_creation_rec_ := Attr_To_Part_Cre_Hist_Rec___(attr_);
   company_           := Site_API.Get_Company(part_creation_rec_.contract);
   country_code_      := Company_Site_API.Get_Country_Db(part_creation_rec_.contract);

   FOR child_nodes_ IN get_child_nodes LOOP
      part_no_ := child_nodes_.part_no;

      -- Creating Inventory Part
      part_cre_text_ := Language_SYS.Translate_Constant(lu_name_, 'CREINVENTPART: Creating Inventory Part');
      Assortment_Invent_Def_API.Create_Parts_Per_Site(invent_create_status_,
                                                      part_creation_rec_.assortment_id,
                                                      child_nodes_.assortment_node_id,
                                                      part_creation_rec_.contract,
                                                      company_,
                                                      country_code_,
                                                      part_no_);
      IF (invent_create_status_ = 'TRUE') THEN
         invent_part_no_ := invent_part_no_ + 1;
      END IF;

      --Creating Inventory Part Characteristics Defaults
      part_cre_text_ := Language_SYS.Translate_Constant(lu_name_, 'CREINVENTCHARPART: Creating Inventory Part Characteristics for the part');
      Assortment_Inv_Char_Def_API.Create_Inv_Par_Char_Per_Site(part_creation_rec_.assortment_id,
                                                               child_nodes_.assortment_node_id,
                                                               part_creation_rec_.contract,
                                                               company_,
                                                               country_code_,
                                                               part_no_);
      IF (Inventory_Part_API.Get_Type_Code_Db(part_creation_rec_.contract, part_no_) IN ('3', '4', '6')) THEN
         -- Creating Purchase Part         
         $IF (Component_Purch_SYS.INSTALLED) $THEN   
            part_cre_text_ := Language_SYS.Translate_Constant(lu_name_, 'CREPURCHPART: Creating Purchase Part');
            Assortment_Purch_Def_API.Create_Parts_Per_Site(purch_create_status_,
                                                           part_creation_rec_.assortment_id,
                                                           child_nodes_.assortment_node_id,
                                                           part_creation_rec_.contract,
                                                           company_,
                                                           country_code_,
                                                           part_no_);
            IF (purch_create_status_ = 'TRUE') THEN
               purch_part_no_ := purch_part_no_ + 1;
            END IF;
         $END

         -- Creating Supplier for Purchase Part
         IF (part_creation_rec_.create_supp_part = 'TRUE') THEN
            part_sup_count_ := 0;            
            $IF (Component_Purch_SYS.INSTALLED) $THEN
               part_cre_text_ := Language_SYS.Translate_Constant(lu_name_, 'CREPURCHSUPPPART: Creating Supplier For Purchase Part');
               Assortment_Part_Supp_Def_API.Create_Parts_Per_Site(part_sup_count_,
                                                                  part_creation_rec_.assortment_id,
                                                                  child_nodes_.assortment_node_id,
                                                                  part_creation_rec_.contract,
                                                                  company_,
                                                                  country_code_,
                                                                  part_no_);            
               part_supp_no_ := part_supp_no_ + part_sup_count_;
            $END
         END IF;
      END IF;

      -- Creating Sales Part
      IF (part_creation_rec_.create_sales_part = 'TRUE') THEN         
         $IF (Component_Order_SYS.INSTALLED) $THEN
            part_cre_text_ := Language_SYS.Translate_Constant(lu_name_, 'CRESALESPART: Creating Sales Part');
            Assortment_Sales_Def_API.Create_Parts_Per_Site(sales_create_status_,
                                                           part_creation_rec_.assortment_id,
                                                           child_nodes_.assortment_node_id,
                                                           part_creation_rec_.contract,
                                                           company_,
                                                           country_code_,
                                                           part_no_ );       
            IF (sales_create_status_ = 'TRUE') THEN
               sales_part_no_ := sales_part_no_ + 1;
            END IF;
         $ELSE
            NULL;
         $END
      END IF;
    @ApproveTransactionStatement(2012-01-25,GanNLK)
    COMMIT;
   END LOOP;

   IF (part_no_ IS NULL) THEN
      Transaction_SYS.Set_Status_Info(Language_SYS.Translate_Constant(lu_name_,'ERRPURCHPART: No Part Nodes found for the selected node or child nodes. '));
   ELSE
      Transaction_SYS.Set_Status_Info(Language_SYS.Translate_Constant(lu_name_, 'INVPARTINFO: :P1 inventory parts were created at the site :P2. ',
                                                                                p1_ => invent_part_no_,
                                                                                p2_ => part_creation_rec_.contract ),
                                                                                'INFO');

      $IF (Component_Purch_SYS.INSTALLED) $THEN
         Transaction_SYS.Set_Status_Info(Language_SYS.Translate_Constant(lu_name_, 'PURCHPARTINFO: :P1 purchase parts were created at the site :P2. ',
                                                                                   p1_ => purch_part_no_,
                                                                                   p2_ => part_creation_rec_.contract ),
                                                                                   'INFO');
     
         IF (part_creation_rec_.create_supp_part = 'TRUE') THEN
            Transaction_SYS.Set_Status_Info(Language_SYS.Translate_Constant(lu_name_, 'PARTSUPPINFO: :P1 suppliers for purchase parts were created at the site :P2. ',
                                                                                      p1_ => part_supp_no_,
                                                                                      p2_ => part_creation_rec_.contract ),
                                                                                      'INFO');
         END IF;
      $END   

      IF (part_creation_rec_.create_sales_part = 'TRUE') AND (Component_Order_SYS.INSTALLED) THEN
         Transaction_SYS.Set_Status_Info(Language_SYS.Translate_Constant(lu_name_, 'SALESPARTINFO: :P1 sales parts were created at the site :P2. ',
                                                                                   p1_ => sales_part_no_,
                                                                                   p2_ => part_creation_rec_.contract ),
                                                                                   'INFO');
      END IF;
   END IF;

   Create_Parts_Per_Site_Hist_API.Set_Executed(part_creation_rec_.history_no);
EXCEPTION
   WHEN OTHERS THEN
      error_message_ := Language_SYS.Translate_Constant(lu_name_, 'PARTCREERR: Error when :P1 ::P2 for the site ::P3 ',
                                                                                p1_ => part_cre_text_,
                                                                                p2_ => part_no_,
                                                                                p3_ => part_creation_rec_.contract );
      error_message_ := error_message_ || SQLERRM ;
      @ApproveTransactionStatement(2012-01-25,GanNLK)
      ROLLBACK;
      Create_Parts_Per_Site_Hist_API.Set_Error(part_creation_rec_.history_no,
                                               error_message_);

      Transaction_SYS.Set_Status_Info(error_message_);
END Create_Parts_Per_Site__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Priority
--   Returns the priority value for the node depending on the input parameters.
--   Priority ranges 1 - 9 for ASSORTMENT_INVENT_DEF_TAB, ASSORTMENT_SALES_DEF_TAB,
--   ASSORTMENT_PURCH_DEF_TAB and ASSORTMENT_INV_CHAR_DEF_TAB.
--   Prority order is
@UncheckedAccess
FUNCTION Get_Priority (
   site_cluster_node_id_ IN VARCHAR2,
   contract_             IN VARCHAR2,
   country_code_         IN VARCHAR2,
   company_              IN VARCHAR2,
   vendor_no_            IN VARCHAR2 ) RETURN NUMBER
IS
   priority_            NUMBER;
BEGIN
   -- To assign priorty for other tabs other than ASSORTMENT_PART_SUPP_DEF_TAB.
   IF vendor_no_ IS NULL THEN
      IF (contract_ != '*') THEN
         priority_ := 1;
      ELSE
         IF (site_cluster_node_id_ != '*') THEN
            IF (company_ != '*') THEN
               IF (country_code_ != '*') THEN
                  priority_ := 2;
               ELSE
                  priority_ := 3;
               END IF;
            ELSE
               IF (country_code_ != '*') THEN
                  priority_ := 4;
               ELSE
                  priority_ := 5;
               END IF;
            END IF;
         ELSE
            IF (company_ != '*') THEN
               IF (country_code_ != '*') THEN
                  priority_ := 6;
               ELSE
                  priority_ := 7;
               END IF;
            ELSE
               IF (country_code_ != '*') THEN
                  priority_ := 8;
               ELSE
                  priority_ := 9;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      -- To assign priority for ASSORTMENT_PART_SUPP_DEF_TAB.
      IF vendor_no_ != '*' THEN
         IF (contract_ != '*') THEN
            priority_ := 1;
         ELSE
            IF (site_cluster_node_id_ != '*') THEN
               IF (company_ != '*') THEN
                  IF (country_code_ != '*') THEN
                     priority_ := 2;
                  ELSE
                     priority_ := 3;
                  END IF;
               ELSE
                  IF (country_code_ != '*') THEN
                     priority_ := 4;
                  ELSE
                     priority_ := 5;
                  END IF;
               END IF;
            ELSE
               IF (company_ != '*') THEN
                  IF (country_code_ != '*') THEN
                     priority_ := 6;
                  ELSE
                     priority_ := 7;
                  END IF;
               ELSE
                  IF (country_code_ != '*') THEN
                     priority_ := 8;
                  ELSE
                     priority_ := 9;
                  END IF;
               END IF;
            END IF;
         END IF;
      ELSE
         IF (contract_ != '*') THEN
            priority_ := 10;
         ELSE
            IF (site_cluster_node_id_ != '*') THEN
               IF (company_ != '*') THEN
                  IF (country_code_ != '*') THEN
                     priority_ := 11;
                  ELSE
                     priority_ := 12;
                  END IF;
               ELSE
                  IF (country_code_ != '*') THEN
                     priority_ := 13;
                  ELSE
                     priority_ := 14;
                  END IF;
               END IF;
            ELSE
               IF (company_ != '*') THEN
                  IF (country_code_ != '*') THEN
                     priority_ := 15;
                  ELSE
                     priority_ := 16;
                  END IF;
               ELSE
                  IF (country_code_ != '*') THEN
                     priority_ := 17;
                  ELSE
                     priority_ := 18;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;

   RETURN priority_;
END Get_Priority;




