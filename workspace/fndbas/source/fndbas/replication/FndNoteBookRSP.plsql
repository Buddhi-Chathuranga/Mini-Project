-----------------------------------------------------------------------------
--
--  Logical unit: FndNoteBookReplSend
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;
-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE Get_Info(     attr_           IN  VARCHAR2,
                        site_field_ OUT VARCHAR2,
                        key_fields_ OUT VARCHAR2) IS   
   lu_       VARCHAR2(200);
   package_name_  VARCHAR2(100);
   stmt_          VARCHAR2(3000);  
BEGIN
   lu_ := Client_SYS.Get_Item_Value('LU_NAME', attr_);
   IF (lu_ IS NULL) THEN
      site_field_ := '*';
      key_fields_ := NULL;
   ELSE
      package_name_ := Dictionary_SYS.Get_Base_Package(lu_);
      IF(instr(package_name_,'_API')>0) THEN
         package_name_ := replace(package_name_,'_API','_RSP');
      ELSIF (instr(package_name_,'_SYS')>0) THEN
         package_name_ := replace(package_name_,'_API','_RSP');
      END IF;
      IF (Installation_SYS.Package_Exist(package_name_)) THEN
         stmt_ := 'BEGIN 
                      :keyfields:='||package_name_||'.Get_Key_Fields(''TRUE''); 
                      :sitefield:='||package_name_||'.Get_Site_Field(''TRUE''); 
                   END;';
         @ApproveDynamicStatement(2020-03-10,rusnlk)
         EXECUTE IMMEDIATE stmt_ USING OUT key_fields_,OUT site_field_;
      END IF;           
   END IF;
END Get_Info; 

FUNCTION Get_Statement(attr_         IN VARCHAR2,
                       site_field_ IN VARCHAR2,
                       key_fields_ IN VARCHAR2) RETURN VARCHAR2
IS
   stmt_       VARCHAR2(32000);
   rowid_stmt_ VARCHAR2(2000);
   rowid_      VARCHAR2(200);
   view_name_  VARCHAR2(200);
   lu_         VARCHAR2(200);
   poss_      NUMBER;
   key_ref_    VARCHAR2(4000);
BEGIN
   
   -- Get key_ref and lu from the new_attr_
   key_ref_   := Client_SYS.Get_Item_Value('KEY_REF', attr_);
   lu_ := Client_SYS.Get_Item_Value('LU_NAME', attr_);
   -- Get base view
   view_name_ := Dictionary_SYS.Get_Base_View(lu_);
   
   stmt_ := 'SELECT DISTINCT ' || site_field_ || ' FROM ' || view_name_ ||
           ' WHERE rowid IN (';
   IF key_ref_ IS NOT NULL THEN
      poss_    := instr(key_ref_, '^') - 1;
      key_ref_ := substr(key_ref_, 1, poss_);
      
      rowid_ := Object_Connection_SYS.Get_Rowid_From_Keyref (lu_ ,key_ref_);
      rowid_stmt_  := rowid_stmt_||''''||rowid_||''',';
      
      stmt_ := stmt_ || rowid_stmt_;
      stmt_ := trim(TRAILING ',' FROM stmt_) || ')'; 
      RETURN stmt_;   
   ELSE
      stmt_ := NULL;
      RETURN stmt_;
   END IF;  
END Get_Statement;

@Override
PROCEDURE Replicate (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2)
IS
   site_new_   VARCHAR2(100);
   site_field_ VARCHAR2(100);
   key_fields_ VARCHAR2(4000);
   stmt_       VARCHAR2(32000);
   site_stmt_  VARCHAR2(32000);
   TYPE cursor_type IS REF CURSOR;
   cursor_ cursor_type;
   sync_sites_ VARCHAR2(2000);
BEGIN
   Get_Info(new_attr_,site_field_,key_fields_);
   IF(site_field_ = '*') THEN  
      site_new_ := site_field_;
      super(site_new_, old_attr_, new_attr_);
   ELSIF(instr(site_field_,'.')>0) THEN
      site_stmt_ := 'BEGIN 
                      :sitenew:='||site_field_||'; 
                   END;';
      @ApproveDynamicStatement(2020-03-10,rusnlk)
      EXECUTE IMMEDIATE site_stmt_ USING OUT site_new_;
      super(site_new_, old_attr_, new_attr_);
   ELSIF (site_field_ IS NULL) THEN
      RETURN;
   ELSE
      stmt_ := Get_Statement(new_attr_,site_field_,key_fields_);
      IF(stmt_ IS NOT NULL) THEN
         @ApproveDynamicStatement(2020-03-10,rusnlk)
         OPEN cursor_ FOR stmt_;
         FETCH cursor_ INTO site_new_;
         IF cursor_%NOTFOUND THEN
            -- No values for Site found (Site is NULL)
            site_new_ := '*';
            super(site_new_, old_attr_, new_attr_);
         END IF;         
         sync_sites_  := '^'||Data_Sync_SYS.Get_Distinct_Site_List('^') || Data_Sync_SYS.Get_Hq_Site_List('^');
         WHILE cursor_%FOUND LOOP
            IF instr( sync_sites_, '^'||site_new_||'^') > 0 THEN
               super(site_new_, old_attr_, new_attr_);
            END IF;
            FETCH cursor_ INTO site_new_;
         END LOOP;
         CLOSE cursor_;
      ELSE
         RETURN;
      END IF;
   END IF;  
END Replicate;

@Override
PROCEDURE Replicate_Remove (
   site_         IN VARCHAR2,
   key_attr_     IN VARCHAR2,
   non_key_attr_ IN VARCHAR2)
IS
   site_new_   VARCHAR2(100);
   site_field_ VARCHAR2(100);
   key_fields_ VARCHAR2(4000);
   stmt_       VARCHAR2(32000);
   site_stmt_  VARCHAR2(32000);
   TYPE cursor_type IS REF CURSOR;
   cursor_ cursor_type;
   sync_sites_ VARCHAR2(2000);
BEGIN
   Get_Info(key_attr_,site_field_,key_fields_);
   stmt_ := Get_Statement(non_key_attr_,site_field_,key_fields_);
   IF(site_field_ = '*') THEN 
      site_new_ := site_field_;
      super(site_new_, key_attr_, non_key_attr_);
   ELSIF(instr(site_field_,'.')>0) THEN
      site_stmt_ := 'BEGIN 
                      :sitenew:='||site_field_||'; 
                   END;';
      @ApproveDynamicStatement(2020-03-10,rusnlk)
      EXECUTE IMMEDIATE site_stmt_ USING OUT site_new_;
      super(site_new_, key_attr_, non_key_attr_);
   ELSIF (site_field_ IS NULL) THEN
      RETURN; 
   ELSE
      IF(stmt_ IS NOT NULL) THEN
         @ApproveDynamicStatement(2020-03-10,rusnlk)
         OPEN cursor_ FOR stmt_;
         FETCH cursor_ INTO site_new_;
         IF cursor_%NOTFOUND THEN
            -- No values for Site found (Site is NULL)
            site_new_ := '*';
            super(site_new_, key_attr_, non_key_attr_);
         END IF;
         sync_sites_  := '^'||Data_Sync_SYS.Get_Distinct_Site_List('^') || Data_Sync_SYS.Get_Hq_Site_List('^');
         WHILE cursor_%FOUND LOOP
            IF instr( sync_sites_, '^'||site_new_||'^') > 0 THEN
               super(site_new_, key_attr_, non_key_attr_);
            END IF;
            FETCH cursor_ INTO site_new_;
         END LOOP;
         CLOSE cursor_;
      ELSE
         RETURN;
      END IF;
   END IF;
END Replicate_Remove;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- REPLICATION SEND IMPLEMENTATION METHODS ---------------------


-------------------- REPLICATION SEND PRIVATE METHODS ----------------------------


-------------------- REPLICATION SEND PROTECTED METHODS --------------------------


-------------------- REPLICATION SEND PUBLIC METHODS -----------------------------

