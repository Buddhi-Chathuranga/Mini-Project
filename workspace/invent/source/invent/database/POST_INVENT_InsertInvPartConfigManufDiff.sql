--------------------------------------------------------------------------------------------------------
--
--  File        : POST_INVENT_InsertInvPartConfigManufDiff.sql
--
--  Module      : INVENT 14.1.0 - Update 1
--
--  Purpose     : This script will handle upgrade for inventory parts were inventory value is calculated
--                using Periodic Weighted Average.
--                The script will split any remaining diff from earlier PWA calculation stored in the
--                attribute accumulated_manuf_diff in inventory_part_config_tab stored into cost details
--                stored in the new table part_config_manuf_diff_tab
--
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  150625   JoAnSe  MONO-192, Converted to use dynamic SQL since the accumulated_manuf_diff column
--                   might not exist.
--  150416   JoAnse  MONO-192, Created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_InsertInvPartConfigManufDiff.sql','Timestamp_1');
PROMPT Starting POST_INVENT_InsertInvPartConfigManufDiff

DECLARE
   stmt_           VARCHAR2(4000);
BEGIN
   IF (Database_SYS.Column_Exist('INVENTORY_PART_CONFIG_TAB', 'ACCUMULATED_MANUF_DIFF')) THEN
      stmt_ :=
     'DECLARE
         cost_diff_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
         empty_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
         newrec_                inv_part_config_manuf_diff_tab%ROWTYPE;

         CURSOR get_part_with_diff IS
            SELECT contract, part_no, configuration_id, accumulated_manuf_diff
            FROM   inventory_part_config_tab ipc
            WHERE  accumulated_manuf_diff != 0
            AND    NOT EXISTS (SELECT 1
                               FROM inv_part_config_manuf_diff_tab pcmd
                               WHERE ipc.contract         = pcmd.contract
                               AND   ipc.part_no          = pcmd.part_no
                               AND   ipc.configuration_id = pcmd.configuration_id);
      BEGIN
         FOR next_part_ IN get_part_with_diff LOOP
            cost_diff_detail_tab_ := empty_cost_detail_tab_;
            cost_diff_detail_tab_ := Inventory_Part_Unit_Cost_API.Generate_Cost_Details(cost_detail_tab_       => cost_diff_detail_tab_,
                                                                                        unit_cost_             => next_part_.accumulated_manuf_diff,
                                                                                        unit_cost_is_material_ => FALSE,
                                                                                        company_               => Site_API.Get_Company(next_part_.contract),
                                                                                        contract_              => next_part_.contract,
                                                                                        part_no_               => next_part_.part_no,
                                                                                        configuration_id_      => next_part_.configuration_id,
                                                                                        source_ref1_           => NULL,
                                                                                        source_ref2_           => NULL,
                                                                                        source_ref3_           => NULL,
                                                                                        source_ref4_           => NULL,
                                                                                        source_ref_type_db_    => NULL);

            newrec_.rowversion       := sysdate;
            newrec_.contract         := next_part_.contract;
            newrec_.part_no          := next_part_.part_no;
            newrec_.configuration_id := next_part_.configuration_id;

            -- Store the new diff details
            FOR i_ IN 1..cost_diff_detail_tab_.COUNT LOOP
               IF (cost_diff_detail_tab_(i_).unit_cost != 0) THEN
                  newrec_.accounting_year        := cost_diff_detail_tab_(i_).accounting_year;
                  newrec_.cost_bucket_id         := cost_diff_detail_tab_(i_).cost_bucket_id;
                  newrec_.company                := cost_diff_detail_tab_(i_).company;
                  newrec_.cost_source_id         := cost_diff_detail_tab_(i_).cost_source_id;
                  newrec_.accumulated_manuf_diff := cost_diff_detail_tab_(i_).unit_cost;

                  INSERT
                     INTO inv_part_config_manuf_diff_tab
                     VALUES newrec_;

               END IF;
            END LOOP;
         END LOOP;
         COMMIT;
      END;';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_InsertInvPartConfigManufDiff.sql','Timestamp_2');
PROMPT Finished with POST_INVENT_InsertInvPartConfigManufDiff
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_InsertInvPartConfigManufDiff.sql','Done');



