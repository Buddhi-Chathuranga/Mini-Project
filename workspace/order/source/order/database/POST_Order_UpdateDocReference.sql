-----------------------------------------------------------------------------------------------------------------------------
-- Module :  ORDER
--
-- File   :  POST_Order_UpdateDocReference.sql
--
-- Purpose:  This script Updats the object descriptions in doc_reference_object_tab with the corresponding discriptions in sales_part_tab and part_catalog_tab           
--           Sales_price_list_part has been added with a new key min_duration. So, when upgraded to App9, to retain the connected objects 
--           of the "Part Based" tab of Sales Price List window, this script updates the three most common objects. 
--           i.e. Characteristics (technical_object_reference_tab), Approval process (approval_routing_tab) and Documents ( doc_reference_object_tab).
--
-- Date      Sign     History
-----------------------------------------------------------------------------------------------------------------------------
-- 201009    HaPulk   SC2020R1-10456, No need to check Table_Exist since all components are installed.
-- 170731    KiSalk   Bug 137114, Handled exception on adding new key min_duration, to update connected object tables properly,
-- 170731             if the missing connected objects have been re-entered after the upgrade.
-- 170614    KiSalk   Bug 136350, Updated technical_object_reference_tab, approval_routing_tab and doc_reference_object_tab with new key min_duration for SalesPriceListPart.
-- 160330    KiSalk   Bug 135092, Rewritten to enhance performance eliminating function call in the where clauses 
-- 110222    Darklk   Bug 95798, Updates the object descriptions in doc_reference_object_tab with the corresponding descriptions
-- 110222             in sales_part_tab and part_catalog_tab.
-----------------------------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateDocReference.sql','Timestamp_1');
PROMPT Starting POST_Order_UpdateDocReference.sql

DECLARE
       stmt_    VARCHAR2(32000);

BEGIN
     --IF Database_SYS.Table_Exist('doc_reference_object_tab') THEN
         stmt_ := 'DECLARE 
                   CURSOR get_parts IS
                      SELECT PA.description, Client_SYS.Get_Key_Reference(''SalesPart'', ''CATALOG_NO'', SP.catalog_no, ''CONTRACT'', SP.contract) key_ref
                        FROM sales_part_tab SP, part_catalog_tab  PA,  site_discom_info_tab     SI
                       WHERE SP.catalog_no = PA.part_no
                         AND SP.contract = SI.contract  
                         AND SI.use_partca_desc_order = ''TRUE''
                         AND PA.description != SP.catalog_desc;
                   BEGIN
                      FOR rec_ IN get_parts LOOP
                         UPDATE doc_reference_object_tab DOC SET DOC.doc_object_desc = rec_.description
                          WHERE DOC.lu_name = ''SalesPart''
                            AND DOC.key_ref = rec_.key_ref  
                            AND rec_.description != nvl(DOC.doc_object_desc, '' '');
                      END LOOP;    
                   END;';
                         
         EXECUTE IMMEDIATE stmt_; 
        
         stmt_ := 'DECLARE 
                   CURSOR get_sales_parts IS
                      SELECT SP.catalog_desc, Client_SYS.Get_Key_Reference(''SalesPart'', ''CATALOG_NO'', SP.catalog_no, ''CONTRACT'', SP.contract) key_ref
                        FROM sales_part_tab SP, site_discom_info_tab SI
                       WHERE SP.contract = SI.contract  
                         AND SI.use_partca_desc_order = ''FALSE'';

                   BEGIN
                     FOR rec_ IN get_sales_parts LOOP
                        UPDATE doc_reference_object_tab DOC SET DOC.doc_object_desc = rec_.catalog_desc
                         WHERE DOC.lu_name = ''SalesPart''
                           AND DOC.key_ref = rec_.key_ref  
                           AND rec_.catalog_desc != nvl(DOC.doc_object_desc, '' '');
                     END LOOP;                                                      
                   END;';
                         
         EXECUTE IMMEDIATE stmt_; 

         stmt_ := 'DECLARE
                      key_ref_           VARCHAR2(600);
                      key_value_         VARCHAR2(500);
                      lu_name_           VARCHAR2(30) := ''SalesPriceListPart'';
                      catalog_no_        VARCHAR2(25);
                      catalog_no_ref_    VARCHAR2(40);
                      min_duration_ref_  VARCHAR2(20);
                      seperator_         VARCHAR2(1)  := Client_SYS.text_separator_;
                   CURSOR get_doc_reference IS
                      SELECT key_ref, key_value
                      FROM   doc_reference_object_tab 
                      WHERE  lu_name = lu_name_
                      AND    NOT key_ref LIKE ''%MIN_DURATION%'' 
                      FOR UPDATE OF key_ref, key_value;
                   BEGIN
                      FOR rec_ IN get_doc_reference LOOP
                         catalog_no_ref_ := NULL;
                         min_duration_ref_ := NULL;
                         catalog_no_ := Client_SYS.Get_Key_Reference_Value(rec_.key_ref, ''CATALOG_NO'');
                         Client_SYS.Add_To_Key_Reference(catalog_no_ref_, ''CATALOG_NO'', catalog_no_);
                         Client_SYS.Add_To_Key_Reference(min_duration_ref_, ''MIN_DURATION'', -1);

                         key_ref_   := REPLACE(rec_.key_ref, catalog_no_ref_,  catalog_no_ref_||min_duration_ref_);
                         key_value_ := rec_.key_value||''-1''||seperator_;

                         BEGIN
                            UPDATE doc_reference_object_tab 
                               SET key_ref   = key_ref_,
                                   key_value = key_value_
                             WHERE CURRENT OF get_doc_reference;                
                         EXCEPTION
                            WHEN dup_val_on_index THEN NULL;
                         END;

                      END LOOP;
                   END;';
                         
         EXECUTE IMMEDIATE stmt_;

     --END IF;

     --IF Database_SYS.Table_Exist('technical_object_reference_tab') THEN

        stmt_ := 'DECLARE
                     key_ref_           VARCHAR2(600);
                     key_value_         VARCHAR2(500);
                     lu_name_           VARCHAR2(30) := ''SalesPriceListPart'';
                     catalog_no_        VARCHAR2(25);
                     catalog_no_ref_    VARCHAR2(40);
                     min_duration_ref_  VARCHAR2(20);
                     seperator_         VARCHAR2(1)  := Client_SYS.text_separator_;
        
                  CURSOR get_tech_object IS
                     SELECT key_ref, key_value
                     FROM   technical_object_reference_tab 
                     WHERE  lu_name = lu_name_
                     AND    NOT key_ref LIKE ''%MIN_DURATION%'' 
                     FOR UPDATE OF key_ref, key_value;
                   BEGIN
                      FOR rec_ IN get_tech_object LOOP
                         catalog_no_ref_ := NULL;
                         min_duration_ref_ := NULL;
                         catalog_no_ := Client_SYS.Get_Key_Reference_Value(rec_.key_ref, ''CATALOG_NO'');
                         Client_SYS.Add_To_Key_Reference(catalog_no_ref_, ''CATALOG_NO'', catalog_no_);
                         Client_SYS.Add_To_Key_Reference(min_duration_ref_, ''MIN_DURATION'', -1);
            
                         key_ref_   := REPLACE(rec_.key_ref, catalog_no_ref_,  catalog_no_ref_||min_duration_ref_);
                         key_value_ := rec_.key_value||''-1''||seperator_;

                         BEGIN
                            UPDATE technical_object_reference_tab 
                               SET key_ref   = key_ref_,
                                   key_value = key_value_
                             WHERE CURRENT OF get_tech_object;                 
                         EXCEPTION
                            WHEN dup_val_on_index THEN NULL;
                         END;
            
                      END LOOP;
                   END;';
                         
         EXECUTE IMMEDIATE stmt_;

     --END IF;


     --IF Database_SYS.Table_Exist('approval_routing_tab') THEN

        stmt_ := 'DECLARE
                     key_ref_           VARCHAR2(600);
                     key_value_         VARCHAR2(500);
                     lu_name_           VARCHAR2(30) := ''SalesPriceListPart'';
                     catalog_no_        VARCHAR2(25);
                     catalog_no_ref_    VARCHAR2(40);
                     min_duration_ref_  VARCHAR2(20);
                     seperator_         VARCHAR2(1)  := Client_SYS.text_separator_;
        
                     CURSOR get_approval_routing IS
                        SELECT key_ref
                        FROM   approval_routing_tab 
                        WHERE  lu_name = lu_name_
                        AND    NOT key_ref LIKE ''%MIN_DURATION%'' 
                        FOR UPDATE OF key_ref;
                   BEGIN
                     FOR rec_ IN get_approval_routing LOOP
                        catalog_no_ref_ := NULL;
                        min_duration_ref_ := NULL;
                        catalog_no_ := Client_SYS.Get_Key_Reference_Value(rec_.key_ref, ''CATALOG_NO'');
                        Client_SYS.Add_To_Key_Reference(catalog_no_ref_, ''CATALOG_NO'', catalog_no_);
                        Client_SYS.Add_To_Key_Reference(min_duration_ref_, ''MIN_DURATION'', -1);
               
                        key_ref_   := REPLACE(rec_.key_ref, catalog_no_ref_,  catalog_no_ref_||min_duration_ref_);

                        BEGIN
                           UPDATE approval_routing_tab 
                              SET key_ref   = key_ref_
                            WHERE CURRENT OF get_approval_routing;                
                         EXCEPTION
                            WHEN dup_val_on_index THEN NULL;
                         END;
               
                     END LOOP;
                   END;';
                         
         EXECUTE IMMEDIATE stmt_;

     --END IF;

END;
/
COMMIT;

PROMPT Finished POST_Order_UpdateDocReference.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateDocReference.sql','Done');
