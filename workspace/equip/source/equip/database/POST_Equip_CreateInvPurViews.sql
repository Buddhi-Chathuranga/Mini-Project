-----------------------------------------------------------------------------------
--
--  File: POST_Equip_CreateInvPurViews.sql
--
--  Date: 2009-04-28
--
--  Purpose:    
--
--  Date    Sign     History
--  ------  ----     -----------------------------------------------------------------
--  200813  LASSLK   AMZDOC-540, Renamed part no,contract as spare id ,spare contract respectively.
--  150811  VISHLK   ANPJ-1594, Excluded the external resource type purchase parts from the view.
--  140812  chanlk   Mergerd Bug 118223, Modified view EQUIP_INV_PUR_PART
--  110829  PRIKLK   SADEAGLE-1739, Added user_allowed_site filter to view EQUIP_INV_PUR_PART. Used public views instead of private base views of other modules.
--  090627  HARPLK   Bug 97780, Method calls set for dim_quality,type_designation for get correct values.
--  110422  NUKULK   Bug EASTONE-16039, Added nochecks.
--  090428  NUKULK   Bug 82400, Created.
-----------------------------------------------------------------------------------

DEFINE MODULE        = EQUIP
DEFINE LU            = EquipmentSpareStructure
DEFINE VIEW          = EQUIP_INV_PUR_PART

DEFINE OBJID         = rowid
DEFINE OBJVERSION    = ltrim(lpad(to_char(rowversion),2000))
DEFINE SYSDATEVERSION    = "ltrim(lpad(to_char(sysdate,''YYYYMMDDHH24MISS''),2000))"


-------------------------------------------------------------------
             
SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_CreateInvPurViews.sql','Timestamp_1');
PROMPT Creating VIEW &VIEW.

DECLARE
   cid_          INTEGER;
   result_       INTEGER;
   dummy_        NUMBER;
BEGIN
 IF (Transaction_SYS.Package_Is_Installed('Purchase_Part_API') AND Transaction_SYS.Package_Is_Installed('Inventory_Part_API')) THEN
    cid_ := dbms_sql.open_cursor;
    dbms_sql.parse(cid_,
       'CREATE OR REPLACE VIEW &VIEW AS
            SELECT p.contract                       spare_contract,
                   p.part_no                        spare_id,
                   Purchase_Part_API.Get_Description(p.contract, p.part_no)  description,
                   substr(inventory_flag,1,200)   inventory_flag,
                   Inventory_Part_API.Get_Dim_Quality(p.contract, p.part_no)        dim_quality,
                   Inventory_Part_API.Get_Type_Designation(p.contract, p.part_no)   type_designation,
                   p.contract || ''^'' || p.part_no   objid,
                   &SYSDATEVERSION                objversion
            FROM   PURCHASE_PART_PUB p
            WHERE  EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = p.contract)
            AND    external_resource_db = ''FALSE''
            UNION ALL 
            SELECT t.contract                     spare_contract,
                   t.part_no                      spare_id,
                   Inventory_Part_API.Get_Description(t.contract, t.part_no)  description,
                   substr(Inventory_Flag_API.Decode(''Y''),1,200)      inventory_flag,
                   t.dim_quality                                         dim_quality,
                   t.type_designation                                    type_designation,
                   t.contract || ''^'' || t.part_no               objid,
                   &SYSDATEVERSION                objversion
            FROM   INVENTORY_PART_PUB t
            WHERE t.type_code_db = ''1''
            AND    EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = t.contract)
            AND    NOT EXISTS (  SELECT 1 
                                 FROM PURCHASE_PART_PUB t2 
                                 WHERE t2.part_no = t.part_no
                                 AND t2.contract = t.contract
                                 AND EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = t2.contract))            
            WITH   read only', dbms_sql.native);
    dummy_ := dbms_sql.execute(cid_);
    dbms_sql.close_cursor(cid_);
      
    cid_ := dbms_sql.open_cursor;
    dbms_sql.parse(cid_,'COMMENT ON TABLE &VIEW
                              IS ''LU=&LU^PROMPT=Equipment spare structure^MODULE=&MODULE^''',dbms_sql.native);
    dummy_ := dbms_sql.execute(cid_);
    dbms_sql.close_cursor(cid_);

    cid_ := dbms_sql.open_cursor;
    dbms_sql.parse(cid_,'COMMENT ON COLUMN &VIEW..spare_contract
                           IS ''FLAGS=PMI--^DATATYPE=STRING(5)/UPPERCASE^PROMPT=Site^REF=Site/NOCHECK^''',dbms_sql.native);
    dummy_ := dbms_sql.execute(cid_);
    dbms_sql.close_cursor(cid_);

    cid_ := dbms_sql.open_cursor;
    dbms_sql.parse(cid_,'COMMENT ON COLUMN &VIEW..spare_id
                           IS ''FLAGS=PMI-L^DATATYPE=STRING(25)/UPPERCASE^PROMPT=Part No^REF=PartCatalog/NOCHECK^''',dbms_sql.native);
    dummy_ := dbms_sql.execute(cid_);
    dbms_sql.close_cursor(cid_);

    cid_ := dbms_sql.open_cursor;
    dbms_sql.parse(cid_,'COMMENT ON COLUMN &VIEW..description
                              IS ''FLAGS=AMIUL^DATATYPE=STRING(35)^PROMPT=Description^''',dbms_sql.native);
    dummy_ := dbms_sql.execute(cid_);
    dbms_sql.close_cursor(cid_);

    cid_ := dbms_sql.open_cursor;
    dbms_sql.parse(cid_,'COMMENT ON COLUMN &VIEW..inventory_flag
                              IS ''FLAGS=AM-UL^DATATYPE=STRING(200)^PROMPT=Inventory Flag^REF=InventoryFlag^''',dbms_sql.native);
    dummy_ := dbms_sql.execute(cid_);
    dbms_sql.close_cursor(cid_);

    cid_ := dbms_sql.open_cursor;
    dbms_sql.parse(cid_,'COMMENT ON COLUMN &VIEW..dim_quality
                              IS ''FLAGS=A-IUL^DATATYPE=STRING(25)^PROMPT=Dim Quality^''',dbms_sql.native);
    dummy_ := dbms_sql.execute(cid_);
    dbms_sql.close_cursor(cid_);
    
    
    cid_ := dbms_sql.open_cursor;
    dbms_sql.parse(cid_,'COMMENT ON COLUMN &VIEW..type_designation
                              IS ''FLAGS=A-IUL^DATATYPE=STRING(25)^PROMPT=Type Designation^''',dbms_sql.native);
    dummy_ := dbms_sql.execute(cid_);
    dbms_sql.close_cursor(cid_);
  
 END IF;
EXCEPTION 
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      RAISE;  
END;
/

UNDEFINE MODULE
UNDEFINE LU
UNDEFINE VIEW

UNDEFINE OBJID
UNDEFINE OBJVERSION
UNDEFINE SYSDATEVERSION

COMMIT;
/
EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_CreateInvPurViews.sql','Done');
