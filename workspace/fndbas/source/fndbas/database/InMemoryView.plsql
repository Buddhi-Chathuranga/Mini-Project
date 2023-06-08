-----------------------------------------------------------------------------
--
--  Logical unit: InMemoryView
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION InMemory_Parameter_Transleter_ (parameter_value_ VARCHAR2) 
   RETURN VARCHAR2 
IS
   lu_name_ VARCHAR2(32) := 'InMemoryView';
BEGIN
   CASE parameter_value_
   WHEN 'Specifies whether in-memory queries are allowed' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS: Enabled');
   WHEN 'maximum inmemory populate servers' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS2: Populate Servers (max)');
   WHEN 'optimizer in-memory columnar awareness' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS3: Optimizer Awareness');
   WHEN 'ENABLE' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS4: Yes');
   WHEN 'TRUE' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS4: Yes');
   WHEN 'Target size of SGA' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS5: SGA Target');
   WHEN 'Enabled' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS: Enabled');
   WHEN 'Disabled' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS6: Disabled');
   WHEN 'size in bytes of in-memory area' THEN RETURN Language_SYS.Translate_Constant(lu_name_, 'IM_PARAMS7: Allocated Memory');
   ELSE RETURN parameter_value_;  
   END CASE;
   
END InMemory_Parameter_Transleter_;


@UncheckedAccess
FUNCTION In_Memory_Status_
   RETURN NUMBER
IS
   -------------------------------------------
   -- return value description for traficlight
   -------------------------------------------
   -- 00 -  10 : RED
   -- 10 -  20 : YELLOW
   -- 20 -  30 : GREEN
   -- 30 - 100 : NO COLOR 
   --
   RED      CONSTANT NUMBER := 5;
   YELLOW   CONSTANT NUMBER := 15;
   GREEN    CONSTANT NUMBER := 25;
   NO_COLOR CONSTANT NUMBER := 100;
   
   CURSOR still_loading_imap_count_ IS
      SELECT count(*)
      FROM  in_memory_package
      WHERE enabled = 1
      AND   load_completion != 100;
   
   CURSOR enabled_imap_count_ IS
      SELECT count(*)
      FROM   in_memory_package_tab
      WHERE enabled = 1;
      
   loading_count_ NUMBER;
   enabled_count_ NUMBER;
   inmemory_size_ NUMBER;
   im_aware_ VARCHAR2(100);
   im_query_enabled_ VARCHAR2(100);
   
BEGIN
   -- When In-Memory unavailable in System show nothing.
   -- If In-Memory is disabled or non of the packages are enabled then red.
   -- When Im-Memory population is in progress it's yello.
   -- When All packges are 100% loaded, it means green.
   
   IF Dictionary_SYS.Is_Db_Inmemory_Supported THEN
      OPEN enabled_imap_count_;
      FETCH enabled_imap_count_ INTO enabled_count_;
      CLOSE enabled_imap_count_;

      SELECT value INTO inmemory_size_ FROM v$parameter WHERE name = 'inmemory_size' ;
      SELECT value INTO im_query_enabled_ FROM v$parameter WHERE name = 'inmemory_query' ;
      SELECT value INTO im_aware_ FROM v$parameter WHERE name = 'optimizer_inmemory_aware' ;

      IF inmemory_size_ <= 0 OR im_query_enabled_ != 'ENABLE'  OR im_aware_ != 'TRUE' OR enabled_count_ = 0 THEN 
         RETURN RED;
      END IF;

      OPEN still_loading_imap_count_;
      FETCH still_loading_imap_count_ INTO loading_count_;
      CLOSE still_loading_imap_count_;
      IF loading_count_ > 0 THEN
         RETURN YELLOW;
      END IF;

      RETURN GREEN;
   ELSE
      RETURN NO_COLOR;
   END IF;
END In_Memory_Status_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

