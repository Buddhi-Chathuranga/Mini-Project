-----------------------------------------------------------------------------
--
--  Logical unit: EnterpInstallation
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200429  Skanlk  Bug 153723, Modified the view SUPPLIER_PURCH_SRM_INFO by changing the column comments of Purchase_Code.
--  180906  NaLrlk  SCUXXW4-3116, Modified columns geography_code,segment_code,rating and previous_rating to Lookup type in SUPPLIER_PURCH_SRM_INFO.
--  180607  SucPlk  SCUXXW4-12235, Modified column comments on geography_code_db and segment_code_db by replacing the reference view. 
--  180517  SucPlk  SCUXXW4-12044, Added columns ord_conf_reminder_db and delivery_reminder_db to Supplier_Purch_Srm_Info view. 
--  180514  SucPlk  SCUXXW4-12044, Added rating_db and previous_rating_db to SUPPLIER_PURCH_SRM_INFO.
--  180228  DilMlk  Bug 140374, Modified view SUPPLIER_INFO_RFQ_LOV and added a WHERE clause to prevent displaying expired suppliers and prospects.
--  160707  IsSalk  FINHR-2499, Removed columns pay_tax and pay_tax_db and added column tax_liability to the SUPPLIER_PURCH_SRM_INFO view. 
--  160624  DilMlk  STRSC-1199, Modified Replace_Supp_Purch_Srm_Info___ and removed column edi_auto_order_approval column. Added columns
--  160624          dir_del_approval, order_conf_approval and order_conf_diff_approval.
--  160505  RasDlk  Bug 128485, Modified Replace_Supp_Purch_Srm_Info___ method by removing purchase_group_db and adding a get method to retrieve purchase_group information
--  160505          in the SUPPLIER_PURCH_SRM_INFO view.
--  151209  Hairlk  ORA-1543, added NOCHECK for main_representative_db and revenue_currency column comments
--  151110  Hairlk  ORA-1490, get language_code and creation_date directly from supplier_info_tab
--  151102  Hairlk  ORA-1404, Renamed view Supplier_Info_Rfq_Lov to Supplier_Purch_Srm_Info and procedure Replace_Rfq_Supplier_Lov___
--                  to Replace_Supp_Purch_Srm_Info___
--  151028  Hairlk  ORA-1294, Added association_no column to SUPPLIER_INFO_RFQ_LOV view
--  151026  Hairlk  ORA-1379, Added additional columns and corresponding column comments to SUPPLIER_INFO_RFQ_LOV view
--  150821  Hairlk  Moved the code related to SUPPLIER_INFO_RFQ_LOV to an implementation method
--  150805  Hairlk  ORA-1040,Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Replace_Supp_Purch_Srm_Info___
IS
   stmt_ CLOB;
   eol_  VARCHAR2(2) := CHR(13)||CHR(10);
BEGIN
   stmt_ := 'CREATE OR REPLACE VIEW SUPPLIER_PURCH_SRM_INFO AS'||eol_;
      stmt_ := stmt_ || 'SELECT'||eol_;
      stmt_ := stmt_ || '       sit.supplier_id                                                             supplier_id,'||eol_;
      stmt_ := stmt_ || '       sit.name                                                                    name,'||eol_;
      stmt_ := stmt_ || '       Iso_Country_API.Decode(sit.country)                                         country,'||eol_;
      stmt_ := stmt_ || '       Supplier_Info_Category_API.Decode(sit.supplier_category)                    supplier_category,'||eol_;      
      stmt_ := stmt_ || '       sit.supplier_category                                                       supplier_category_db,'||eol_;
      stmt_ := stmt_ || '       sit.association_no                                                          association_no,'||eol_;
      stmt_ := stmt_ || '       sit.default_language                                                        language_code,'||eol_;
      stmt_ := stmt_ || '       sit.creation_date                                                           creation_date,'||eol_;
   IF (Dictionary_SYS.Component_Is_Active('PURCH')) THEN
      stmt_ := stmt_ || '       spip.supp_grp_db                                                            supp_grp_db,'||eol_;
      stmt_ := stmt_ || '       spip.supp_grp                                                               supp_grp,'||eol_;
      stmt_ := stmt_ || '       spip.buyer_code                                                             buyer_code,'||eol_;
      stmt_ := stmt_ || '       spip.buyer_name                                                             buyer_name,'||eol_;
      stmt_ := stmt_ || '       spip.currency_code                                                          currency_code,'||eol_;
      stmt_ := stmt_ || '       spip.purchase_code_db                                                       purchase_code_db,'||eol_;
      stmt_ := stmt_ || '       spip.purchase_code                                                          purchase_code,'||eol_;
      stmt_ := stmt_ || '       Purchase_Group_Supplier_API.Get_Supplier_Purchase_Groups(sit.supplier_id)   purchase_group,'||eol_;
      stmt_ := stmt_ || '       spip.our_customer_no                                                        our_customer_no,'||eol_;
      stmt_ := stmt_ || '       spip.additional_cost_amount                                                 additional_cost_amount,'||eol_;
      stmt_ := stmt_ || '       spip.discount                                                               discount,'||eol_;
      stmt_ := stmt_ || '       spip.qc_approval                                                            qc_approval,'||eol_;
      stmt_ := stmt_ || '       spip.environmental_approval                                                 environmental_approval,'||eol_;
      stmt_ := stmt_ || '       spip.environmental_approval_db                                              environmental_approval_db,'||eol_;
      stmt_ := stmt_ || '       spip.environment_date                                                       environment_date,'||eol_;
      stmt_ := stmt_ || '       spip.environment_type                                                       environment_type,'||eol_;
      stmt_ := stmt_ || '       spip.environment_audit                                                      environment_audit,'||eol_;
      stmt_ := stmt_ || '       spip.environment_note_text                                                  environment_note_text,'||eol_;
      stmt_ := stmt_ || '       spip.coc_approval                                                           coc_approval,'||eol_;
      stmt_ := stmt_ || '       spip.coc_approval_db                                                        coc_approval_db,'||eol_;
      stmt_ := stmt_ || '       spip.coc_date                                                               coc_date,'||eol_;
      stmt_ := stmt_ || '       spip.coc_type                                                               coc_type,'||eol_;
      stmt_ := stmt_ || '       spip.coc_audit                                                              coc_audit,'||eol_;
      stmt_ := stmt_ || '       spip.coc_note_text                                                          coc_note_text,'||eol_;
      stmt_ := stmt_ || '       spip.cr_check                                                               cr_check,'||eol_;
      stmt_ := stmt_ || '       spip.cr_check_db                                                            cr_check_db,'||eol_;
      stmt_ := stmt_ || '       spip.cr_date                                                                cr_date,'||eol_;
      stmt_ := stmt_ || '       spip.cr_note_text                                                           cr_note_text,'||eol_;
      stmt_ := stmt_ || '       spip.qc_approval_db                                                         qc_approval_db,'||eol_;
      stmt_ := stmt_ || '       spip.qc_date                                                                qc_date,'||eol_;
      stmt_ := stmt_ || '       spip.qc_type                                                                qc_type,'||eol_;
      stmt_ := stmt_ || '       spip.qc_audit                                                               qc_audit,'||eol_;
      stmt_ := stmt_ || '       spip.qc_note_text                                                           qc_note_text,'||eol_;
      stmt_ := stmt_ || '       Ord_Conf_Reminder_API.Decode(spip.ord_conf_reminder_db)                     ord_conf_reminder,'||eol_;
      stmt_ := stmt_ || '       spip.ord_conf_reminder_db                                                   ord_conf_reminder_db,'||eol_;
      stmt_ := stmt_ || '       spip.ord_conf_rem_interval                                                  ord_conf_rem_interval,'||eol_;
      stmt_ := stmt_ || '       spip.days_before_delivery                                                   days_before_delivery,'||eol_;
      stmt_ := stmt_ || '       Delivery_Reminder_API.Decode(spip.delivery_reminder_db)                     delivery_reminder,'||eol_;
      stmt_ := stmt_ || '       spip.delivery_reminder_db                                                   delivery_reminder_db,'||eol_;
      stmt_ := stmt_ || '       spip.delivery_rem_interval                                                  delivery_rem_interval,'||eol_;
      stmt_ := stmt_ || '       spip.days_before_arrival                                                    days_before_arrival,'||eol_;
      stmt_ := stmt_ || '       spip.category_db                                                            category_db,'||eol_;
      stmt_ := stmt_ || '       Supplier_Category_API.Decode(spip.category_db)                              category,'||eol_;
      stmt_ := stmt_ || '       spip.acquisition_site                                                       acquisition_site,'||eol_;
      stmt_ := stmt_ || '       spip.date_del                                                               date_del,'||eol_;
      stmt_ := stmt_ || '       spip.purch_order_flag_db                                                    purch_order_flag_db,'||eol_;
      stmt_ := stmt_ || '       Print_Purchase_Order_API.Decode(spip.purch_order_flag_db)                   purch_order_flag,'||eol_;
      stmt_ := stmt_ || '       spip.note_text                                                              note_text,'||eol_;
      stmt_ := stmt_ || '       DECODE(User_Default_API.Get_Contract, NULL, User_Profile_SYS.Get_Default(''COMPANY'',Fnd_Session_API.Get_Fnd_User), Site_API.Get_Company(User_Default_API.Get_Contract)) company,'||eol_;
      stmt_ := stmt_ || '       spip.pay_term_id                                                            pay_term_id,'||eol_;
      stmt_ := stmt_ || '       spip.edi_auto_approval_user                                                 edi_auto_approval_user,'||eol_;
      stmt_ := stmt_ || '       spip.template_supplier_db                                                   template_supplier_db,'||eol_;
      stmt_ := stmt_ || '       Template_Supplier_API.Decode(spip.template_supplier_db)                     template_supplier,'||eol_;
      stmt_ := stmt_ || '       spip.supplier_template_desc                                                 supplier_template_desc,'||eol_;
      stmt_ := stmt_ || '       spip.quick_registered_supplier_db                                           quick_registered_supplier_db,'||eol_;
      stmt_ := stmt_ || '       Quick_Registered_Supplier_API.Decode(spip.quick_registered_supplier_db)     quick_registered_supplier,'||eol_;
      stmt_ := stmt_ || '       spip.express_order_allowed_db                                               express_order_allowed_db,'||eol_;
      stmt_ := stmt_ || '       Purchase_Express_Order_API.Decode(spip.express_order_allowed_db)            express_order_allowed,'||eol_;
      stmt_ := stmt_ || '       spip.receipt_ref_reminder_db                                                receipt_ref_reminder_db,'||eol_;
      stmt_ := stmt_ || '       Receipt_Reference_Reminder_API.Decode(spip.receipt_ref_reminder_db)         receipt_ref_reminder,'||eol_;
      stmt_ := stmt_ || '       spip.note_id                                                                note_id,'||eol_;
      stmt_ := stmt_ || '       Document_Text_API.Note_Id_Exist(spip.note_id)                               note_id_exist,'||eol_;
      stmt_ := stmt_ || '       spip.dir_del_approval_db                                                    dir_del_approval_db,'||eol_;
      stmt_ := stmt_ || '       Approval_Option_API.Decode(spip.dir_del_approval_db)                        dir_del_approval,'||eol_;
      stmt_ := stmt_ || '       spip.order_conf_approval_db                                                 order_conf_approval_db,'||eol_;
      stmt_ := stmt_ || '       Approval_Option_API.Decode(spip.order_conf_approval_db)                     order_conf_approval,'||eol_;
      stmt_ := stmt_ || '       spip.order_conf_diff_approval_db                                            order_conf_diff_approval_db,'||eol_;
      stmt_ := stmt_ || '       Approval_Option_API.Decode(spip.order_conf_diff_approval_db)                order_conf_diff_approval,'||eol_;
      stmt_ := stmt_ || '       spip.tax_liability                                                          tax_liability,'||eol_;
   END IF;
   IF (Dictionary_SYS.Component_Is_Active('SRM')) THEN
      stmt_ := stmt_ || '       ssip.turnover                                                               annual_revenue,'||eol_;
      stmt_ := stmt_ || '       ssip.currency_code                                                          revenue_currency,'||eol_;
      stmt_ := stmt_ || '       ssip.main_representative_db                                                 main_representative_db,'||eol_;
      stmt_ := stmt_ || '       ssip.main_representative                                                    main_representative,'||eol_;
      stmt_ := stmt_ || '       ssip.latest_review_date                                                     latest_review_date,'||eol_;
      stmt_ := stmt_ || '       ssip.next_review_date                                                       next_review_date,'||eol_;
      stmt_ := stmt_ || '       ssip.geography_code_db                                                      geography_code_db,'||eol_;
      stmt_ := stmt_ || '       ssip.geography_code                                                         geography_code,'||eol_;
      stmt_ := stmt_ || '       ssip.segment_code_db                                                        segment_code_db,'||eol_;
      stmt_ := stmt_ || '       ssip.segment_code                                                           segment_code,'||eol_;
      stmt_ := stmt_ || '       ssip.rating_db                                                              rating_db,'||eol_;
      stmt_ := stmt_ || '       ssip.rating                                                                 rating,'||eol_;
      stmt_ := stmt_ || '       ssip.previous_rating_db                                                     previous_rating_db,'||eol_;
      stmt_ := stmt_ || '       ssip.previous_rating                                                        previous_rating,'||eol_;
   END IF;
      stmt_ := stmt_ || '       sit.rowkey                                                                  objkey,'||eol_;
      stmt_ := stmt_ || '       sit.rowtype                                                                 objtype,'||eol_;
      stmt_ := stmt_ || '       TO_CHAR(sit.rowversion)                                                     objversion,'||eol_;
      stmt_ := stmt_ || '       sit.ROWID                                                                   objid'||eol_;
      stmt_ := stmt_ || 'FROM   supplier_info_tab sit'||eol_;
   IF (Dictionary_SYS.Component_Is_Active('PURCH')) THEN
      stmt_ := stmt_ || 'LEFT JOIN Supplier_Purch_Info_Pub spip '||eol_;
      stmt_ := stmt_ || 'ON sit.supplier_id=spip.vendor_no'||eol_;
   END IF;
   IF (Dictionary_SYS.Component_Is_Active('SRM')) THEN
      stmt_ := stmt_ || 'LEFT JOIN Srm_Supp_Info_Pub ssip'||eol_;
      stmt_ := stmt_ || 'ON sit.supplier_id=ssip.supplier_id'||eol_;
   END IF;
   IF (Dictionary_SYS.Component_Is_Active('PURCH')) THEN
      stmt_ := stmt_ || 'WHERE spip.date_del IS NULL'||eol_;
      stmt_ := stmt_ || 'OR spip.date_del > SYSDATE'||eol_;
   END IF;
      stmt_ := stmt_ || 'WITH READ ONLY';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE stmt_;
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON TABLE SUPPLIER_PURCH_SRM_INFO
         IS ''LU=SupplierInfoGeneral^PROMPT=Supplier Info Rfq Lov^MODULE=ENTERP^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.supplier_id
         IS ''FLAGS=KMI-L^DATATYPE=STRING(20)/UPPERCASE^PROMPT=Supplier Id^REF=SupplierInfoGeneral/NOCHECK^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.name
         IS ''FLAGS=A---L^DATATYPE=STRING(100)^PROMPT=Name^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.country
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^PROMPT=Country^REF=IsoCountry/NOCHECK^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.supplier_category
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^ENUMERATION=SupplierInfoCategory^PROMPT=Supplier Category^''';
      @ApproveDynamicStatement(2018-05-14,sucplk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.supplier_category_db
         IS ''FLAGS=A----^DATATYPE=STRING(200)^PROMPT=Supplier Category Db^''';
      @ApproveDynamicStatement(2015-10-28,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.association_no
         IS ''FLAGS=A----^DATATYPE=STRING(50)^PROMPT=Association No^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.language_code
         IS ''FLAGS=A----^DATATYPE=STRING(2)^PROMPT=Language Code^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.creation_date
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Creation Date^''';
   IF (Dictionary_SYS.Component_Is_Active('PURCH')) THEN
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.supp_grp_db
         IS ''FLAGS=A----^DATATYPE=STRING(10)/UPPERCASE^REF=SupplierGroup/NOCHECK^PROMPT=Supp Grp Db^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.supp_grp
         IS ''FLAGS=A---L^PROMPT=Supp Stat Grp^DATATYPE=STRING^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.buyer_code
         IS ''FLAGS=A---L^DATATYPE=STRING(20)/UPPERCASE^REF=PurchaseBuyer/NOCHECK^PROMPT=Buyer Code^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.buyer_name
         IS ''FLAGS=A---L^PROMPT=Buyer^DATATYPE=STRING^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.currency_code
         IS ''FLAGS=A---L^DATATYPE=STRING(3)/UPPERCASE^REF=IsoCurrency/NOCHECK^PROMPT=Currency^''';
      @ApproveDynamicStatement(2015-08-20,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.purchase_code_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)/UPPERCASE^PROMPT=Purchase Code Db^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.purchase_code
         IS ''FLAGS=A---L^DATATYPE=STRING(20)^REF=PurchaseCode/NOCHECK^PROMPT=Purchase Code^''';      
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.purchase_group
         IS ''FLAGS=A---L^PROMPT=Purchase Group^DATATYPE=STRING^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.our_customer_no
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Our Customer No^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.additional_cost_amount
         IS ''FLAGS=A----^DATATYPE=NUMBER^PROMPT=Additional Cost Amount^''';  
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.discount
         IS ''FLAGS=A----^DATATYPE=NUMBER/PERCENTAGE^PROMPT=Discount^'''; 
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.qc_approval
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^ENUMERATION=SupplierQualityApproved^PROMPT=Quality Approved^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.qc_approval_db
         IS ''FLAGS=A----^DATATYPE=STRING(1)^PROMPT=Qc Approval Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.qc_date
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Qc Date^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.qc_type
         IS ''FLAGS=A----^DATATYPE=STRING(25)^PROMPT=Qc Type^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.qc_audit
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Qc Audit^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.qc_note_text
         IS ''FLAGS=A----^DATATYPE=STRING(2000)^PROMPT=Qc Note Text^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.environmental_approval
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^ENUMERATION=SupplierEnvironApproval^PROMPT=Environment Approved^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.environmental_approval_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Environmental Approval Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.environment_date
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Environment Date^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.environment_type
         IS ''FLAGS=A----^DATATYPE=STRING(25)^PROMPT=Environment Type^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.environment_audit
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Environment Audit^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.environment_note_text
         IS ''FLAGS=A----^DATATYPE=STRING(2000)^PROMPT=Environment Note Text^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.coc_approval
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^ENUMERATION=SupplierCocApproval^PROMPT=Code of Conduct Approved^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.coc_approval_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Coc Approval Db^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.coc_date
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Coc Date^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.coc_type
         IS ''FLAGS=A----^DATATYPE=STRING(25)^PROMPT=Coc Type^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.coc_audit
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Coc Audit^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.coc_note_text
         IS ''FLAGS=A----^DATATYPE=STRING(2000)^PROMPT=Coc Note Text^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.cr_check
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^ENUMERATION=SupplierCredit^PROMPT=Credit Approved^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.cr_check_db
         IS ''FLAGS=A----^DATATYPE=STRING(1)^PROMPT=Cr Check Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.cr_date
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Cr Date^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.cr_note_text
         IS ''FLAGS=A----^DATATYPE=STRING(2000)^PROMPT=Cr Note Text^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.ord_conf_reminder
         IS ''FLAGS=A----^DATATYPE=STRING(20)^ENUMERATION=OrdConfReminder^PROMPT=Ord Conf Reminder Db^''';
      @ApproveDynamicStatement(2018-05-17,sucplk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.ord_conf_reminder_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Ord Conf Reminder Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.ord_conf_rem_interval
         IS ''FLAGS=A----^DATATYPE=NUMBER^PROMPT=Ord Conf Rem Interval^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.days_before_delivery
         IS ''FLAGS=A----^DATATYPE=NUMBER^PROMPT=Days Before Delivery^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.delivery_reminder
         IS ''FLAGS=A----^DATATYPE=STRING(20)^ENUMERATION=DeliveryReminder^PROMPT=Delivery Reminder^''';
      @ApproveDynamicStatement(2018-05-17,sucplk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.delivery_reminder_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Delivery Reminder Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.delivery_rem_interval
         IS ''FLAGS=A----^DATATYPE=NUMBER^PROMPT=Delivery Rem Interval^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.days_before_arrival
         IS ''FLAGS=A----^DATATYPE=NUMBER^PROMPT=Days Before Arrival^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.category_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Category Db^''';
       @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.category
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=SupplierCategory^PROMPT=Category^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.acquisition_site
         IS ''FLAGS=A----^DATATYPE=STRING(5)/UPPERCASE^REF=Site/NOCHECK^PROMPT=Acquisition Site^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.date_del
         IS ''FLAGS=A----^DATATYPE=DATE/DATE^PROMPT=Date Del^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.purch_order_flag_db
         IS ''FLAGS=A----^DATATYPE=STRING(1)^PROMPT=Purch Order Flag Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.purch_order_flag
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=PrintPurchaseOrder^PROMPT=Purch Order Flag^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.note_text
         IS ''FLAGS=A----^DATATYPE=STRING(2000)^PROMPT=Note Text^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.company
         IS ''FLAGS=A----^DATATYPE=STRING(20)^COLUMN=Site_API.Get_Company(User_Default_API.Get_Contract)^PROMPT=Company^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.pay_term_id
         IS ''FLAGS=A----^DATATYPE=STRING(20)/UPPERCASE^REF=PaymentTerm(company)/NOCHECK^PROMPT=Pay Term Id^''';     
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.edi_auto_approval_user
         IS ''FLAGS=A----^DATATYPE=STRING(30)/UPPERCASE^REF=UserDefault/NOCHECK^PROMPT=Edi Auto Approval User^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.template_supplier_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Template Supplier Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.template_supplier
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=TemplateSupplier^PROMPT=Template Supplier^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.supplier_template_desc
         IS ''FLAGS=A----^DATATYPE=STRING(100)^PROMPT=Supplier Template Desc^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.quick_registered_supplier_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Quick Registered Supplier Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.quick_registered_supplier
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=QuickRegisteredSupplier^PROMPT=Quick Registered Supplier^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.express_order_allowed_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Express Order Allowed Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.express_order_allowed
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=PurchaseExpressOrder^PROMPT=Express Order Allowed^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.receipt_ref_reminder_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Receipt Ref Reminder Db^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.receipt_ref_reminder
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=ReceiptReferenceReminder^PROMPT=Receipt Ref Reminder^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.note_id
         IS ''FLAGS=A----^DATATYPE=NUMBER^PROMPT=Note Id^''';
      @ApproveDynamicStatement(2015-10-26,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.note_id_exist
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Note Id Exist^''';
      @ApproveDynamicStatement(2016-06-23,dilmlk)   
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.dir_del_approval_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Direct Delivery Approval Db^''';
      @ApproveDynamicStatement(2016-06-23,dilmlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.dir_del_approval
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=ApprovalOption^PROMPT=Direct Delivery Approval^''';
      @ApproveDynamicStatement(2016-06-23,dilmlk)   
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.order_conf_approval_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Order Confirmation Approval Db^''';
      @ApproveDynamicStatement(2016-06-23,dilmlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.order_conf_approval
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=ApprovalOption^PROMPT=Order Confirmation Approval^''';
      @ApproveDynamicStatement(2016-06-23,dilmlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.order_conf_diff_approval_db
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Order Confirmation With Differences Approval Db^''';        
      @ApproveDynamicStatement(2016-06-23,dilmlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.order_conf_diff_approval
         IS ''FLAGS=A----^DATATYPE=STRING(200)^ENUMERATION=ApprovalOption^PROMPT=Order Confirmation With Differences Approval^''';       
      @ApproveDynamicStatement(2016-07-06,IsSalk) 
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.tax_liability
         IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Tax Liability^''';
   END IF;
   IF (Dictionary_SYS.Component_Is_Active('SRM')) THEN
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.annual_revenue
         IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Annual Revenue^''';
      @ApproveDynamicStatement(2015-12-09,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.revenue_currency
         IS ''FLAGS=A---L^DATATYPE=STRING(3)/UPPERCASE^PROMPT=Revenue Currency^REF=IsoCurrency/NOCHECK^''';
      @ApproveDynamicStatement(2015-12-09,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.main_representative_db
         IS ''FLAGS=A---L^DATATYPE=STRING(20)/UPPERCASE^PROMPT=Main Representative ID^REF=BusinessRepresentative/NOCHECK^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.main_representative
         IS ''FLAGS=A---L^DATATYPE=STRING^PROMPT=Main Representative^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.latest_review_date
         IS ''FLAGS=A---L^PROMPT=Latest Review Date^DATATYPE=DATE/DATE^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.next_review_date
         IS ''FLAGS=A---L^PROMPT=Next Review Date^DATATYPE=DATE/DATE^''';
      @ApproveDynamicStatement(2015-08-20,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.geography_code_db
         IS ''FLAGS=A----^DATATYPE=STRING(4000)/LIST^PROMPT=Geography Code Db^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.geography_code
         IS ''FLAGS=A---L^DATATYPE=STRING(200)/LIST^LOOKUP=SuppGeographyCode^PROMPT=Geography Code^''';
      @ApproveDynamicStatement(2015-08-20,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.segment_code_db
         IS ''FLAGS=A----^DATATYPE=STRING(10)^PROMPT=Segment Code Db^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.segment_code
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^LOOKUP=SupplierSegment^PROMPT=Segment Code^''';
      @ApproveDynamicStatement(2018-05-14,sucplk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.rating_db
         IS ''FLAGS=A----^DATATYPE=STRING(10)^PROMPT=Rating Db^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.rating
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^LOOKUP=SupplierRating^PROMPT=Rating^''';
      @ApproveDynamicStatement(2018-05-14,sucplk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.previous_rating_db
         IS ''FLAGS=A----^DATATYPE=STRING(10)^PROMPT=Previous Rating Db^''';
      @ApproveDynamicStatement(2015-08-05,hairlk)
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN SUPPLIER_PURCH_SRM_INFO.previous_rating
         IS ''FLAGS=A---L^DATATYPE=STRING(200)^LOOKUP=SupplierRating^PROMPT=Previous Rating^''';
   END IF;
END Replace_Supp_Purch_Srm_Info___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Post_Installation_Object
IS
BEGIN
   --This procedure replaces the view SUPPLIER_PURCH_SRM_INFO which created in SupplierInfoGeneral lu. For more info on this refer the attached mail thread in ORA-1040 
   Replace_Supp_Purch_Srm_Info___();  
END Post_Installation_Object;
