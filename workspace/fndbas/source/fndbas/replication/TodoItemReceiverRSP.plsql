-----------------------------------------------------------------------------
--
--  Logical unit: TodoItemReceiverReplSend
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
PROCEDURE Get_Item_Info(attr_    IN  VARCHAR2,
                        lu_      OUT VARCHAR2,
                        url_     OUT VARCHAR2) IS
   item_id_    VARCHAR2(200);
   CURSOR Get_Todo_Item(item_id_ TODO_ITEM_TAB.item_id%TYPE) IS
      SELECT url, business_object
      FROM  todo_item_tab
      WHERE item_id = item_id_;                    
BEGIN
   -- Get item_id from the new_attr_
   item_id_     := Client_SYS.Get_Item_Value('ITEM_ID', attr_);
   OPEN  Get_Todo_Item(item_id_);
   FETCH Get_Todo_Item INTO url_, lu_;
   CLOSE Get_Todo_Item;
END Get_Item_Info;

PROCEDURE Get_Info(     attr_           IN  VARCHAR2,
                        lu_             IN  VARCHAR2,
                        site_field_     OUT VARCHAR2,
                        key_fields_     OUT VARCHAR2) IS   
   package_name_  VARCHAR2(100);
   stmt_          VARCHAR2(3000);  
BEGIN
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
         --@ApproveDynamicStatement(2016-08-04,nadelk)
         EXECUTE IMMEDIATE stmt_ USING OUT key_fields_,OUT site_field_;
      END IF;           
   END IF;
END Get_Info; 

FUNCTION Get_Statement(attr_ IN  VARCHAR2,
                       lu_         IN VARCHAR2,
                       url_        IN VARCHAR2,
                       site_field_ IN VARCHAR2,
                       key_fields_ IN VARCHAR2) RETURN VARCHAR2
IS 
   temp_url_   VARCHAR2(4000);
   stmt_       VARCHAR2(32000);
   rowid_stmt_ VARCHAR2(2000);
   rowid_      VARCHAR2(200);
   view_name_  VARCHAR2(200);
   temp_       VARCHAR2(2000);
   poss0_      NUMBER := 1;
   poss1_      NUMBER := 1;
   poss2_      NUMBER := 1;
   key1_       VARCHAR2(4000);
   key2_       VARCHAR2(4000);
   key_ref_    VARCHAR2(4000);
   split_      NUMBER := 1;
   split1_     NUMBER := 1;
   init1_      NUMBER := 1;
   init_       NUMBER := 1;
BEGIN
   -- Get base view
   view_name_   := Dictionary_SYS.Get_Base_View(lu_); 
   
   stmt_    := 'SELECT DISTINCT '|| site_field_ || ' FROM '||view_name_||' WHERE rowid IN (';
   -- if action=get todo item is syncronized and if it is a draft do not synchronize
   IF(instr(url_,'&'||'action=get')>0) THEN
      -- get the keys from url and key value separator %5E is replaced from ^
      temp_url_ := substr(url_,instr(url_,'&'||'key1='));
      temp_url_ := replace(temp_url_,'%5E','^');
      -- Loops until there is key
      WHILE(poss0_>0) LOOP
         poss1_ := instr(temp_url_,'&'||'key',poss0_);
         poss2_ := instr(temp_url_,'&'||'key',poss1_+5);
         IF(poss2_>0)THEN
           key1_  := substr(temp_url_,poss1_,poss2_-poss1_);
           key2_  := substr(key1_,instr(key1_,'=')+1);
         ELSE
           key1_  := substr(temp_url_,poss1_);
           key2_  := substr(key1_,instr(key1_,'=')+1);
         END IF;
         key_ref_ := key_fields_;
         poss0_ :=  poss2_-1;
         split_ := 1;
         init1_ := 1;
         init_ := 1;
         --Loops until there is ^ in key fields and value fields
         WHILE(split_>0) LOOP
            split_ := instr(key2_,'^',init_);
            split1_:= instr(key_fields_,'^',init1_);
            IF(split_ > 0 AND split1_ > 0)THEN
               key_ref_ := replace(key_ref_,substr(key_fields_,init1_,split1_-init1_),substr(key_fields_,init1_,split1_-init1_)||'='||substr(key2_,init_,split_-init_));
            ELSE
               temp_ := substr(key2_,init_);
               IF instr(temp_,'#')>0 THEN 
                  temp_ := substr(temp_,1,instr(temp_,'#')-1);
               END IF;
               IF instr(temp_,'&')>0 THEN
                 temp_ := substr(temp_,1,instr(temp_,'&')-1);
               END IF;
               key_ref_ := replace(key_ref_,substr(key_fields_,init1_),substr(key_fields_,init1_)||'='||temp_);
            END IF;
            init_  := split_+1;   
            init1_ := split1_+1;
         END LOOP;
         rowid_ := Object_Connection_Sys.Get_Rowid_From_Keyref (lu_ ,key_ref_);
         rowid_stmt_  := rowid_stmt_||''''||rowid_||''',';
      END LOOP;
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
   lu_         VARCHAR2(200);
   url_        VARCHAR2(4000);
   key_fields_ VARCHAR2(4000);
   stmt_       VARCHAR2(32000);
   site_stmt_  VARCHAR2(32000);
   TYPE cursor_type IS REF CURSOR;
   cursor_ cursor_type;
   sync_sites_ VARCHAR2(2000);
BEGIN
   Get_Item_Info(new_attr_,lu_,url_);
   Get_Info(new_attr_,lu_,site_field_,key_fields_);
   IF(site_field_ = '*') THEN 
      site_new_ := site_field_;
      super(site_new_, old_attr_, new_attr_);
   ELSIF(instr(site_field_,'.')>0) THEN
      site_stmt_ := 'BEGIN 
                      :sitenew:='||site_field_||'; 
                   END;';
      --@ApproveDynamicStatement(2016-08-04,nadelk)
      EXECUTE IMMEDIATE site_stmt_ USING OUT site_new_;
      super(site_new_, old_attr_, new_attr_);
   ELSIF (site_field_ IS NULL) THEN
      RETURN; 
   ELSE
      stmt_ := Get_Statement(new_attr_,lu_,url_,site_field_,key_fields_);
      IF(stmt_ IS NOT NULL) THEN
         --@ApproveDynamicStatement(2016-08-04,nadelk)
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
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2 )
IS
   site_new_   VARCHAR2(100);
   site_field_ VARCHAR2(100);
   lu_         VARCHAR2(200);
   url_        VARCHAR2(4000);
   key_fields_ VARCHAR2(4000);
   stmt_       VARCHAR2(32000);
   site_stmt_  VARCHAR2(32000);
   TYPE cursor_type IS REF CURSOR;
   cursor_ cursor_type;
   sync_sites_ VARCHAR2(2000);
BEGIN
   Get_Item_Info(old_attr_,lu_,url_);
   Get_Info(old_attr_,lu_,site_field_,key_fields_);
   IF(site_field_ = '*') THEN 
      site_new_ := site_field_;
      super(site_new_, old_attr_);
   ELSIF(instr(site_field_,'.')>0) THEN
      site_stmt_ := 'BEGIN 
                      :sitenew:='||site_field_||'; 
                   END;';
      --@ApproveDynamicStatement(2016-08-04,nadelk)
      EXECUTE IMMEDIATE site_stmt_ USING OUT site_new_;
      super(site_new_, old_attr_);
   ELSIF (site_field_ IS NULL) THEN
      RETURN; 
   ELSE
      stmt_ := Get_Statement(old_attr_,lu_,url_,site_field_,key_fields_);
      IF(stmt_ IS NOT NULL) THEN
         --@ApproveDynamicStatement(2016-08-04,nadelk)
         OPEN cursor_ FOR stmt_;
         FETCH cursor_ INTO site_new_;
         IF cursor_%NOTFOUND THEN
            -- No values for Site found (Site is NULL)
            site_new_ := '*';
            super(site_new_, old_attr_);
         END IF;
         sync_sites_  := '^'||Data_Sync_SYS.Get_Distinct_Site_List('^') || Data_Sync_SYS.Get_Hq_Site_List('^');
         WHILE cursor_%FOUND LOOP
            IF instr( sync_sites_, '^'||site_new_||'^') > 0 THEN
               super(site_new_, old_attr_);
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

