-----------------------------------------------------------------------------
--
--  File:      Shpmntcl.sql
--
--  Function:  Removes backup tables created in the upgrade process.
--
--  Date    By      Notes
--  ------  ------  ---------------------------------------------------------
--  210604  WaSalk  SC21R2-1367, Merge ShpmntCL_GET.SQL scripts of GET to 21R2.
--  190708  SBalLK  SCUXXW4-22988, Added 'WHIGHT' column in SHPMNT_CONSOLID_PICK_LIST_RPT to the cleanup script.
--  161122  MaIklk  LIM-9178, Moved SHIPMENT_RESERV_HANDL_UNIT_TAB content from order to shpmnt.
--  160704  MaRalk  LIM-7671, Removed obsolete columns ADDR_2, ADDR_3, ADDR_4, ADDR_5, ADDR_6 
--  160704          from DELIVERY_NOTE_TAB.
--  160526  MaIklk  LIM-7440, Moved removing of obsoleted Delivery note columns from ORDER to SHPMNT.
--  160509  MaRalk  LIM-6531, Removed obsolete columns FIX_DELIV_FREIGHT, APPLY_FIX_DELIV_FREIGHT,  
--  160509          CURRENCY_CODE, FREIGHT_MAP_ID, ZONE_ID, PRICE_LIST_NO, FREIGHT_CHG_INVOICED, 
--  160412          SUPPLY_COUNTRY and USE_PRICE_INCL_TAX from SHIPMENT_TAB.
--  160308  MaRalk  LIM-5871, Removed obsolete column LINE_ITEM_NO from SHIPMENT_LINE_TAB.  
--  160225  RoJalk  Created.
-----------------------------------------------------------------------------

PROMPT NOTE! This script drops tables and columns no longer used in core
PROMPT and must be edited before usage.                                         
ACCEPT Press_any_key                                                            
EXIT; -- Remove me before usage                                                 

SET SERVEROUTPUT ON

PROMPT Removing obsolete columns from tables...
DECLARE           
   column_  Database_SYS.ColRec; 
BEGIN 
   --Note: Obsolete columns from SHIPMENT_LINE_HANDL_UNIT_TAB
   column_ := Database_SYS.Set_Column_Values ('ORDER_NO');
   Database_SYS.Alter_Table_Column('SHIPMENT_LINE_HANDL_UNIT_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Database_SYS.Set_Column_Values ('LINE_NO');
   Database_SYS.Alter_Table_Column('SHIPMENT_LINE_HANDL_UNIT_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Database_SYS.Set_Column_Values ('REL_NO');
   Database_SYS.Alter_Table_Column('SHIPMENT_LINE_HANDL_UNIT_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Database_SYS.Set_Column_Values ('LINE_ITEM_NO');
   Database_SYS.Alter_Table_Column('SHIPMENT_LINE_HANDL_UNIT_TAB', 'DROP COLUMN', column_, TRUE);
   
   --Note: Obsolete columns from SHIPMENT_LINE_TAB
   column_ := Database_SYS.Set_Column_Values ('LINE_ITEM_NO');
   Database_SYS.Alter_Table_Column('SHIPMENT_LINE_TAB', 'DROP COLUMN', column_, TRUE);  

   --Note: Obsolete columns from SHIPMENT_TAB
   column_ := Database_SYS.Set_Column_Values ('FIX_DELIV_FREIGHT');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('APPLY_FIX_DELIV_FREIGHT');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('CURRENCY_CODE');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('FREIGHT_MAP_ID');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('ZONE_ID');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('PRICE_LIST_NO');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('FREIGHT_CHG_INVOICED');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('SUPPLY_COUNTRY');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('USE_PRICE_INCL_TAX');
   Database_SYS.Alter_Table_Column('SHIPMENT_TAB', 'DROP COLUMN', column_, TRUE);


   -- Note: Obsolete columns from DELIVERY_NOTE_TAB
   column_ := Database_SYS.Set_Column_Values ('DELIVERY_TERMS_DESC');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_);
   column_ := Database_SYS.Set_Column_Values ('SHIP_VIA_DESC');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_);
   column_ := Database_SYS.Set_Column_Values ('DELIVERY_NOTE_SENT');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_);   
   column_ := Database_SYS.Set_Column_Values ('ADDR_2');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_, TRUE);   
   column_ := Database_SYS.Set_Column_Values ('ADDR_3');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_, TRUE); 
   column_ := Database_SYS.Set_Column_Values ('ADDR_4');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_, TRUE); 
   column_ := Database_SYS.Set_Column_Values ('ADDR_5');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_, TRUE); 
   column_ := Database_SYS.Set_Column_Values ('ADDR_6');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_, TRUE); 

   -- Note: Obsolete column from SHIPMENT_RESERV_HANDL_UNIT_TAB
   column_ := Database_SYS.Set_Column_Values ('PALLET_ID');
   Database_SYS.Alter_Table_Column('SHIPMENT_RESERV_HANDL_UNIT_TAB', 'DROP COLUMN', column_);
   column_ := Database_SYS.Set_Column_Values ('LINE_ITEM_NO');
   Database_SYS.Alter_Table_Column('SHIPMENT_RESERV_HANDL_UNIT_TAB', 'DROP COLUMN', column_, TRUE); 
   
   -- Note: Obsolete column from SHIPMENT_TYPE_TAB
   column_ := Database_SYS.Set_Column_Values ('PICK_INVENTORY_TYPE');
   Database_SYS.Alter_Table_Column('SHIPMENT_TYPE_TAB', 'DROP COLUMN', column_, TRUE);
   
   -- Note: Obsolete column for SHPMNT_CONSOLID_PICK_LIST_RPT
   column_ := Database_SYS.Set_Column_Values('WHIGHT');
   Database_SYS.Alter_Table_Column('SHPMNT_CONSOLID_PICK_LIST_RPT', 'DROP COLUMN', column_, TRUE);
END;
/

PROMPT -------------------------------------------------------------
PROMPT Removal of obsolete tables/columns in SHPMNT used in GET 
PROMPT -------------------------------------------------------------

PROMPT Removing obsolete tables from GET release ...


PROMPT Removing obsolete columns from GET release ...

-- PRE component is order so order version is indicated here
PROMPT Removing obsolete columns from 14.1.0-GET release ...
DECLARE           
   column_  Database_SYS.ColRec; 
BEGIN 
   -- Note: Obsolete column from DELIVERY_NOTE_TAB
   column_ := Database_SYS.Set_Column_Values ('EXC_SVC_DELNOTE_1410');
   Database_SYS.Alter_Table_Column('DELIVERY_NOTE_TAB', 'DROP COLUMN', column_,TRUE);
END;
/

PROMPT -------------------------------------------------------------
PROMPT RDrop of obsolete table in SHPMNT done!
PROMPT -------------------------------------------------------------

 
