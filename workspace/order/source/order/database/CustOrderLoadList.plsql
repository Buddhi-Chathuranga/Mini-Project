-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderLoadList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190930  DaZase  SCSPRING20-139, Added Raise_Addr_Format_Error___ to solve MessageDefinitionValidation issue.
--  181103  UdGnlk  Bug 144100, Check_Update___() to add new validation to display the message when modifying.
--  160518  Chgulk  STRLOC-80, Added new address fields.
--  160506  Chgulk  STRLOC-369, used the correct package.
--  160307  DipeLK  STRLOC-247,Change Validate_Address() method call to Address_validation_API.Validate_Address
--  120125 ChJalk Modified the view comments of addr_1, addr_2, addr_3, addr_4 and addr_5.
--  110818 AmPalk Bug 93557, In Unpack_Check_Update___ and Unpack_Check_Insert___ validated country, state, county and city.
--  100531 MaMalk Replaced ApplicationCountry with IsoCountry to correctly represent the relationships in overviews.
--  100531        Removed the column Country.
--  100519 KRPELK Merge Rose Method Documentation.
--  ------------------------------- 14.0.0 ----------------------------------
--  100305 HimRlk Added view comments to column country.
--  071210 MaRalk Bug 66201, Modified functions Sum_Total_Weight_Gross, Sum_Total_Weight_Net 
--  071210        and Sum_Total_Volume in order to return NULL as well.      
--  060726 ThGulk Added Objid instead of rowid in Procedure Insert__
--  060209 IsAnlk  Added info_ parameter to Connect_To_Shipment_List.
--  060131 PrPrlk Bug 55418, Added new public procedure New.
--  060112 NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  040220 IsWilk Removed the SUBSTRB from the view and modified SUBSTRB to SUBSTR for Unicode Changes.
--  ------------- Edge Package Group 3 Unicode Changes---------------------
--  020618 AjShlk Bug 29312, Added attribute county to Update_Ord_Address_Util_API.Get_Order_Address_Line.
--  020320 JOHESE Added column country
--  020313 SaKaLk Call 77116(Foreign Call 28170).Added new column county.
--  001004  MaGu  Added null check on new address before address convertion in
--                Unpack_Check_Insert___ and Unpack_Check_Insert___.
--  001003  MaGu  Added control value ORDER_ADDRESS_UPDATE to Unpack_Check_Update___ to
--                prevent old address fields from being overwritten when running the order
--                address update application.
--  000921  MaGu  Added convertion to old address format in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  000912  MaGu  Added attributes address1, address2, zip_code, city and state.
--  000829  MaGu  Added attribute country_code.
--  ---------------- 12.10 --------------------------------------------------
--  990503  RaKu  Even more Yoshimura fixes.
--  990420  JoAn  More Yoshimura fixes.
--  990407  JakH  New template.
--  980305  DaZa  Removed column number_of_parcels.
--  980201  KaAs  remove  pallet_reg_no ,ship_via_code, forward_agent
--  971125  RaKu  Changed to FND200 Templates.
--  971020  RaKu  Performance improved function Get_Load_Id.
--  970606  RaKu  Added functions Count_Deliverable_Lines__, Count_Not_Deliverable_Lines__.
--  970530  RaKu  Added outparameters in procedure Connect_To_Shipment_List.
--  970522  JOED  Rebuild Get_Load_List_State method.
--                Added .._db column in the view for the IID column.
--  970521  RaKu  Modifyed code to match Design.
--  970515  RaKu  Move functions Has_... to DeliverCustomerOrder.
--  970428  RaKu  Added functions Has_Inventory_Lines__, Has_Non_Inventory_Lines__.
--  970407  RaKu  Added procedure Set_Load_List_Delivered.
--  970228  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Addr_Format_Error___ (
   name_  IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'ADDRFORMA2: You may not save the address in the format :P1.', name_);
END Raise_Addr_Format_Error___;   
   

-- Modify_Attribute___
--   Modifyes a row with all attributes stored in the attribute-string.
PROCEDURE Modify_Attribute___ (
   load_id_ IN NUMBER,
   attr_    IN VARCHAR2 )
IS
   newrec_      CUST_ORDER_LOAD_LIST_TAB%ROWTYPE;
   oldrec_      CUST_ORDER_LOAD_LIST_TAB%ROWTYPE;
   temp_attr_   VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(load_id_);
   newrec_ := oldrec_;
   temp_attr_ := attr_;
   Unpack___(newrec_, indrec_, temp_attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, temp_attr_);
   Update___(objid_, oldrec_, newrec_, temp_attr_, objversion_, TRUE);
END Modify_Attribute___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('LOAD_LIST_STATE_DB', 'NOTDEL', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORDER_LOAD_LIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Get a new sequence-number for the load_id.
   SELECT load_id.nextval INTO newrec_.load_id FROM dual;
   Client_SYS.Add_To_Attr('LOAD_ID', newrec_.load_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_order_load_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_      VARCHAR2(30);
   value_     VARCHAR2(4000);
   addr_line_ VARCHAR2(100);
BEGIN
   IF (indrec_.addr_1 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_1';
      Raise_Addr_Format_Error___(name_);
   END IF;
   IF (indrec_.addr_2 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_2';
      Raise_Addr_Format_Error___(name_);
   END IF;
   IF (indrec_.addr_3 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_3';
      Raise_Addr_Format_Error___(name_);
   END IF;
   IF (indrec_.addr_4 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_4';
      Raise_Addr_Format_Error___(name_);
   END IF;
   IF (indrec_.addr_5 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_5';
      Raise_Addr_Format_Error___(name_);
   END IF;
   
   super(newrec_, indrec_, attr_);

   Address_Setup_API.Validate_Address(newrec_.country_code, newrec_.state, newrec_.county, newrec_.city);
   
   IF ((newrec_.address1 IS NOT NULL) OR (newrec_.address2 IS NOT NULL) OR 
       (newrec_.address3 IS NOT NULL) OR (newrec_.address4 IS NOT NULL) OR
       (newrec_.address5 IS NOT NULL) OR (newrec_.address6 IS NOT NULL) OR
       (newrec_.zip_code IS NOT NULL) OR (newrec_.city IS NOT NULL) OR
       (newrec_.state IS NOT NULL)) THEN

       --Convert the new address to the old format and save as addr_2 to addr_6.
       FOR i in 1..5 LOOP
         addr_line_ := Update_Ord_Address_Util_API.Get_Order_Address_Line(newrec_.address1, newrec_.address2,newrec_.address3,
                                                                          newrec_.address4,newrec_.address5,newrec_.address6,newrec_.zip_code,
                                                                          newrec_.city, newrec_.state, newrec_.county, newrec_.country_code, i);
         IF (i = 1) THEN
            newrec_.addr_1 := SUBSTR(addr_line_, 1, 35);
         ELSIF (i = 2) THEN
            newrec_.addr_2 := SUBSTR(addr_line_, 1, 35);
         ELSIF (i = 3) THEN
            newrec_.addr_3 := SUBSTR(addr_line_, 1, 35);
         ELSIF (i = 4) THEN
            newrec_.addr_4 := SUBSTR(addr_line_, 1, 35);
         ELSIF (i = 5) THEN
            newrec_.addr_5 := SUBSTR(addr_line_, 1, 35);
         END IF;
       END LOOP;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_order_load_list_tab%ROWTYPE,
   newrec_ IN OUT cust_order_load_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                 VARCHAR2(30);
   value_                VARCHAR2(4000);
   addr_line_            VARCHAR2(100);
   order_address_update_ BOOLEAN := FALSE;
BEGIN
   IF (Client_Sys.Item_Exist('ORDER_ADDRESS_UPDATE', attr_)) THEN
      order_address_update_ := TRUE;
   END IF;
   
   IF (indrec_.addr_1 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_1';
      Raise_Addr_Format_Error___(name_);
   END IF;
   IF (indrec_.addr_2 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_2';
      Raise_Addr_Format_Error___(name_);
   END IF;
   IF (indrec_.addr_3 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_3';
      Raise_Addr_Format_Error___(name_);
   END IF;
   IF (indrec_.addr_4 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_4';
      Raise_Addr_Format_Error___(name_);
   END IF;
   IF (indrec_.addr_5 = TRUE) THEN
      -- Should not be possible to send old address format.
      name_ := 'ADDR_5';
      Raise_Addr_Format_Error___(name_);
   END IF;
   
   IF ((indrec_.note_text = TRUE OR indrec_.address1 = TRUE OR indrec_.address2 = TRUE OR indrec_.zip_code = TRUE OR indrec_.city = TRUE OR indrec_.state = TRUE OR indrec_.county = TRUE OR indrec_.name = TRUE OR indrec_.country_code = TRUE) 
      AND newrec_.load_list_state = 'DEL' ) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOTUPDATELOADLISTDELIVERED: Load list :P1 has been delivered. No changes may be made', newrec_.load_id );
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);

   Address_Setup_API.Validate_Address(newrec_.country_code, newrec_.state, newrec_.county, newrec_.city);
   
   IF ((newrec_.address1 IS NOT NULL) OR (newrec_.address2 IS NOT NULL) OR
       (newrec_.address3 IS NOT NULL) OR (newrec_.address4 IS NOT NULL) OR
       (newrec_.address5 IS NOT NULL) OR (newrec_.address6 IS NOT NULL) OR
       (newrec_.zip_code IS NOT NULL) OR (newrec_.city IS NOT NULL) OR
       (newrec_.state IS NOT NULL)) THEN

       IF (NOT order_address_update_) THEN
         --Convert the new address to the old format and save as addr_2 to addr_6.
         FOR i in 1..5 LOOP
           addr_line_ := Update_Ord_Address_Util_API.Get_Order_Address_Line(newrec_.address1, newrec_.address2,newrec_.address3,
                                                                            newrec_.address4,newrec_.address5,newrec_.address6,newrec_.zip_code,
                                                                            newrec_.city, newrec_.state, newrec_.county, newrec_.country_code, i);
           IF (i = 1) THEN
              newrec_.addr_1 := SUBSTR(addr_line_, 1, 35);
           ELSIF (i = 2) THEN
              newrec_.addr_2 := SUBSTR(addr_line_, 1, 35);
           ELSIF (i = 3) THEN
              newrec_.addr_3 := SUBSTR(addr_line_, 1, 35);
           ELSIF (i = 4) THEN
              newrec_.addr_4 := SUBSTR(addr_line_, 1, 35);
           ELSIF (i = 5) THEN
              newrec_.addr_5 := SUBSTR(addr_line_, 1, 35);
           END IF;
         END LOOP;
       END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Count_Deliverable_Lines__
--   Returns the amount of lines connected to an load list that are
--   deliverable on the specified load list.
@UncheckedAccess
FUNCTION Count_Deliverable_Lines__ (
   load_id_ IN NUMBER ) RETURN NUMBER
IS
   lines_to_deliver_ NUMBER := 0;

   CURSOR find_lines IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM   CUST_ORDER_LOAD_LIST_LINE_TAB
      WHERE  load_id = load_id_;
BEGIN
   FOR next_line_ IN find_lines LOOP
      IF (Customer_Order_Line_API.Calculate_Qty_To_Load(next_line_.order_no,
                                                        next_line_.line_no,
                                                        next_line_.rel_no,
                                                        next_line_.line_item_no) > 0) THEN
         lines_to_deliver_ := lines_to_deliver_ + 1;
      END IF;
   END LOOP;
   RETURN lines_to_deliver_;
END Count_Deliverable_Lines__;


-- Count_Not_Deliverable_Lines__
--   Returns the amount of lines connected to an load list that are not
--   deliverable on the specified load list.
@UncheckedAccess
FUNCTION Count_Not_Deliverable_Lines__ (
   load_id_ IN NUMBER ) RETURN NUMBER
IS
   lines_not_to_deliver_ NUMBER := 0;

   CURSOR find_lines IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM   CUST_ORDER_LOAD_LIST_LINE_TAB
      WHERE  load_id = load_id_;

BEGIN
   FOR next_line_ IN find_lines LOOP
      IF (Customer_Order_Line_API.Calculate_Qty_To_Load(next_line_.order_no,
                                                        next_line_.line_no,
                                                        next_line_.rel_no,
                                                        next_line_.line_item_no) = 0) THEN
         lines_not_to_deliver_ := lines_not_to_deliver_ + 1;
      END IF;
   END LOOP;
   RETURN lines_not_to_deliver_;
END Count_Not_Deliverable_Lines__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Connect_To_Shipment_List
--   Connects selected order_lines to the shipment list.
PROCEDURE Connect_To_Shipment_List (
   info_               OUT VARCHAR2,
   total_weight_gross_ OUT NUMBER,
   total_weight_net_   OUT NUMBER,
   total_volume_       OUT NUMBER,
   load_id_            IN NUMBER,
   attr_               IN VARCHAR2 )
IS
   ptr_          NUMBER;
   name_         VARCHAR2(30);
   value_        VARCHAR2(2000);
   order_no_     VARCHAR2(12);
   line_no_      VARCHAR2(4);
   rel_no_       VARCHAR2(4);
   line_item_no_ NUMBER;

BEGIN
   Trace_SYS.Field('Add rows to load_id', load_id_);

   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ORDER_NO') THEN
         order_no_ := value_;
      ELSIF (name_ = 'LINE_NO') THEN
         line_no_ := value_;
      ELSIF (name_ = 'REL_NO') THEN
         rel_no_ := value_;
      ELSIF (name_ = 'LINE_ITEM_NO') THEN
         line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
         Trace_SYS.Field('Order No', order_no_);
         Trace_SYS.Field('Line No', line_no_);
         Trace_SYS.Field('Rel No', rel_no_);
         Trace_SYS.Field('Line Item No', line_item_no_);
         Cust_Order_Load_List_Line_API.Connect_To_Shipment_List(load_id_,order_no_,line_no_,
                                                                rel_no_,line_item_no_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   info_ := Client_SYS.Get_All_Info;
   total_weight_gross_ := Sum_Total_Weight_Gross(load_id_);
   total_weight_net_ := Sum_Total_Weight_Net(load_id_);
   total_volume_ := Sum_Total_Volume(load_id_);
END Connect_To_Shipment_List;


@UncheckedAccess
FUNCTION Get_Load_Id (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   load_id_         CUST_ORDER_LOAD_LIST_TAB.load_id%TYPE;
   CURSOR find_load_id IS
      SELECT ll.load_id
      FROM   CUST_ORDER_LOAD_LIST_TAB ll, CUST_ORDER_LOAD_LIST_LINE_TAB lll
      WHERE  lll.order_no = order_no_
      AND    lll.line_no = line_no_
      AND    lll.rel_no = rel_no_
      AND    lll.line_item_no = line_item_no_
      AND    ll.load_id = lll.load_id
      AND    ll.load_list_state = 'NOTDEL';
BEGIN
   OPEN  find_load_id;
   FETCH find_load_id INTO load_id_;
   IF (find_load_id%NOTFOUND) THEN
      CLOSE find_load_id;
      RETURN (NULL);
   END IF;
   CLOSE find_load_id;
   RETURN load_id_;
END Get_Load_Id;


PROCEDURE Set_Load_List_Delivered (
   load_id_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('LOAD_LIST_STATE_DB', 'DEL', attr_);
   Modify_Attribute___(load_id_, attr_);
END Set_Load_List_Delivered;


-- Sum_Total_Weight_Gross
--   Calculates the Total_Weight_Gross for all lines
@UncheckedAccess
FUNCTION Sum_Total_Weight_Gross (
   load_id_ IN NUMBER ) RETURN NUMBER
IS
   sum_weight_gross_ NUMBER;
   CURSOR sum_weight_gross IS
      SELECT SUM(weight_gross)
      FROM   CUST_ORDER_LOAD_LIST_LINE_TAB
      WHERE  load_id = load_id_;
BEGIN
   OPEN   sum_weight_gross;
   FETCH  sum_weight_gross INTO sum_weight_gross_;
   CLOSE  sum_weight_gross;
   RETURN sum_weight_gross_;
END Sum_Total_Weight_Gross;


-- Sum_Total_Weight_Net
--   Calculates the Total_Weight_Net for all lines
@UncheckedAccess
FUNCTION Sum_Total_Weight_Net (
   load_id_ IN NUMBER ) RETURN NUMBER
IS
   sum_weight_net_ NUMBER;
   CURSOR sum_weight_net IS
      SELECT SUM(weight_net)
      FROM   CUST_ORDER_LOAD_LIST_LINE_TAB
      WHERE  load_id = load_id_;
BEGIN
   OPEN   sum_weight_net;
   FETCH  sum_weight_net INTO sum_weight_net_;
   CLOSE  sum_weight_net;
   RETURN sum_weight_net_;
END Sum_Total_Weight_Net;


-- Sum_Total_Volume
--   Calculates the Total_Volume for all lines
@UncheckedAccess
FUNCTION Sum_Total_Volume (
   load_id_ IN NUMBER ) RETURN NUMBER
IS
   sum_volume_ NUMBER;
   CURSOR sum_volume IS
      SELECT SUM(volume)
      FROM   CUST_ORDER_LOAD_LIST_LINE_TAB
      WHERE  load_id = load_id_;
BEGIN
   OPEN   sum_volume;
   FETCH  sum_volume INTO sum_volume_;
   CLOSE  sum_volume;
   RETURN sum_volume_;
END Sum_Total_Volume;


PROCEDURE New (
   load_id_ IN OUT NUMBER )
IS
   attr_        VARCHAR2(2000);
   info_        VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
BEGIN
  
   Prepare_Insert___ (attr_ );
   New__ (info_, objid_, objversion_, attr_, 'DO');
   load_id_ :=  Client_SYS.Attr_Value_To_Number( Client_SYS.Get_Item_Value('LOAD_ID',attr_));
END New;



