-----------------------------------------------------------------------------
--  Module : ENTERP
--
--  File   : Post_Enterp_RemoveCzVatControlStatementData_GET.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  180815   kagalk  gelr: Added to support Global Extension Functionalities.
--  180815           Move Cz Vat Control Statement basic data from taxled to enterp.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------
--
SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveCzVatControlStatementData.sql','Timestamp_1');
PROMPT Post_Enterp_RemoveCzVatControlStatementData_GET.SQL

-- gelr:cz_vat_reporting, begin
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveCzVatControlStatementData.sql','Timestamp_2');
PROMPT Moving data from cz_reg_tax_office_300
DECLARE
   stmt_             VARCHAR2(2000);
   insert_stmt_      VARCHAR2(2000);
   dummy_            NUMBER;
   TYPE RecordType   IS REF CURSOR;
   get_details_      RecordType;
   tax_office_id_    tax_office_info_tab.tax_office_id%TYPE;
   name_             tax_office_info_tab.name%TYPE;
   creation_date_    tax_office_info_tab.creation_date%TYPE;

   CURSOR check_exist IS
      SELECT 1
      FROM tax_office_info_tab
      WHERE tax_office_id = tax_office_id_;
BEGIN
   IF (Database_SYS.Table_Exist('CZ_REG_TAX_OFFICE_300'))THEN
      stmt_ := 'SELECT DISTINCT tax_office_id, tax_office_name, from_date
                     FROM cz_reg_tax_office_300 c
                     WHERE NOT EXISTS(SELECT 1
                                      FROM tax_office_info_tab t
                                      WHERE t.tax_office_id = TO_CHAR(c.tax_office_id))';

      insert_stmt_  :=  'INSERT INTO tax_office_info_tab
                           (tax_office_id, name, creation_date, country, default_language,  rowversion, rowkey)
                           VALUES (:tax_office_id_, :name_, :creation_date_, ''CZ'', ''cs'', sysdate, sys_guid())';

      OPEN  get_details_ FOR stmt_;
      FETCH get_details_ INTO tax_office_id_, name_, creation_date_;
      WHILE get_details_%FOUND LOOP
         OPEN check_exist;
         FETCH check_exist INTO dummy_;
         IF (check_exist%NOTFOUND) THEN
            EXECUTE IMMEDIATE insert_stmt_ USING tax_office_id_, name_, creation_date_;
         END IF;
         CLOSE check_exist;
         FETCH get_details_ INTO tax_office_id_, name_, creation_date_;
      END LOOP;
      CLOSE get_details_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveCzVatControlStatementData.sql','Timestamp_3');
PROMPT Moving data from cz_regional_office_300
DECLARE
   stmt_             VARCHAR2(2000);
   insert_stmt_      VARCHAR2(2000);
   dummy_            NUMBER;
   TYPE RecordType   IS REF CURSOR;
   get_details_      RecordType;
   tax_office_id_    tax_office_info_tab.tax_office_id%TYPE;
   name_             tax_office_info_tab.name%TYPE;
   creation_date_    tax_office_info_tab.creation_date%TYPE;

   CURSOR check_exist IS
      SELECT 1
      FROM tax_office_info_tab
      WHERE tax_office_id = tax_office_id_;
BEGIN
   IF (Database_SYS.Table_Exist('CZ_REGIONAL_OFFICE_300'))THEN
      stmt_ := 'SELECT DISTINCT regional_office_id, regional_office_name, from_date
                     FROM cz_regional_office_300 c
                     WHERE NOT EXISTS(SELECT 1
                                      FROM tax_office_info_tab t
                                      WHERE t.tax_office_id = TO_CHAR(c.regional_office_id))';

      insert_stmt_  :=  'INSERT INTO tax_office_info_tab
                           (tax_office_id, name, creation_date, country, default_language,  rowversion, rowkey)
                           VALUES (:tax_office_id_, :name_, :creation_date_, ''CZ'', ''cs'', sysdate, sys_guid())';

      OPEN  get_details_ FOR stmt_;
      FETCH get_details_ INTO tax_office_id_, name_, creation_date_;
      WHILE get_details_%FOUND LOOP
         OPEN check_exist;
         FETCH check_exist INTO dummy_;
         IF (check_exist%NOTFOUND) THEN
            EXECUTE IMMEDIATE insert_stmt_ USING tax_office_id_, name_, creation_date_;
         END IF;
         CLOSE check_exist;
         FETCH get_details_ INTO tax_office_id_, name_, creation_date_;
      END LOOP;
      CLOSE get_details_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveCzVatControlStatementData.sql','Timestamp_4');
PROMPT Moving data from cz_tax_consultant_code_300
DECLARE
   stmt_             VARCHAR2(2000);
   dummy_            NUMBER;
   TYPE RecordType   IS REF CURSOR;
   get_details_      RecordType;
   consultant_code_  person_info_tab.person_id%TYPE;
   description_      person_info_tab.name%TYPE;

   CURSOR check_exist IS
      SELECT 1
      FROM person_info_tab
      WHERE person_id = consultant_code_;
BEGIN
   IF (Database_SYS.Table_Exist('CZ_TAX_CONSULTANT_CODE_300'))THEN
      stmt_ := 'SELECT DISTINCT UPPER(consultant_code), description
                  FROM cz_tax_consultant_code_300 c
                  WHERE NOT EXISTS(SELECT 1
                                   FROM person_info_tab p
                                   WHERE p.person_id = UPPER(c.consultant_code))';
      OPEN  get_details_ FOR stmt_;
      FETCH get_details_ INTO consultant_code_, description_;
      WHILE get_details_%FOUND LOOP
         OPEN check_exist;
         FETCH check_exist INTO dummy_;
         IF (check_exist%NOTFOUND) THEN
            Person_Info_API.New(consultant_code_, description_);
         END IF;
         CLOSE check_exist;
         FETCH get_details_ INTO consultant_code_, description_;
      END LOOP;
      CLOSE get_details_;
      COMMIT;
   END IF;
END;
/
-- gelr:cz_vat_reporting, end
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveCzVatControlStatementData.sql','Done');
SET SERVEROUTPUT OFF
