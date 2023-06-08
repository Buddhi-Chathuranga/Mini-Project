-----------------------------------------------------------------------------
--
--  Logical unit: UserWarehouseAccess
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210723  WaSalk  SC21R2-2027, Modified error messages in Check_Invent_Trans_Allowed() and Check_Stock_Reserv_Allowed() with correct parameter order.
--  210723          Modified Find_User_Access_Warehouses() error messages in more descriptive way.
--  210514  WaSalk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
db_true_                        CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

db_false_                       CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     user_warehouse_access_tab%ROWTYPE,
   newrec_ IN OUT user_warehouse_access_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.invent_trans_allowed = db_false_ AND newrec_.stock_reserv_allowed = db_false_ THEN
      Error_SYS.Record_General(lu_name_, 'NOACCESSALLOWED: The user should have access to at least one out of stock reservations or performing transactions, to save a record.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract );
   User_Allowed_Site_API.Exist(newrec_.user_id, newrec_.contract );
END Check_Common___;



@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('STOCK_RESERV_ALLOWED_DB', Fnd_Boolean_API.DB_TRUE, attr_);
   Client_SYS.Add_To_Attr('STOCK_TRANS_ALLOWED_DB', Fnd_Boolean_API.DB_TRUE, attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Find_User_Access_Warehouses (
   contract_     IN VARCHAR2,
   action_       IN VARCHAR2)
IS
   warehouse_id_tab_   Inventory_Part_In_Stock_API.Warehouse_Id_Tab; 
   
   CURSOR get_user_access_warehouse IS
      SELECT warehouse_id
      FROM user_warehouse_access_tab
      WHERE user_id = Fnd_session_API.Get_Fnd_User
      AND contract = contract_
      AND ((stock_reserv_allowed = db_true_ AND action_ = Inventory_Part_In_Stock_API.reserve_)
      OR (invent_trans_allowed  = db_true_ AND action_ = Inventory_Part_In_Stock_API.issue_ ));

BEGIN
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'ACCESS_CTRL_FOR_INV_RESERV') = db_true_) THEN
      OPEN  get_user_access_warehouse;
      FETCH get_user_access_warehouse BULK COLLECT INTO warehouse_id_tab_;
      CLOSE get_user_access_warehouse;
      IF warehouse_id_tab_.COUNT > 0 THEN
         Inventory_part_In_Stock_API.Fill_Warehouse_Id_Tmp(warehouse_id_tab_);
      ELSE
         IF (action_ = Inventory_Part_In_Stock_API.reserve_) THEN
            Error_SYS.Record_General(lu_name_, 'NORESERVEACCESS: :P1 does not have access to make stock reservations in the warehouses of Site :P2', Fnd_Session_API.Get_Fnd_User, contract_);
         ELSIF(action_ = Inventory_Part_In_Stock_API.issue_) THEN
            Error_SYS.Record_General(lu_name_, 'NOTRANSACTIONACCESS: :P1 does not have access to perform inventory transactions in the warehouses of Site :P2', Fnd_Session_API.Get_Fnd_User, contract_);
         END IF;
      END IF;
   END IF;
END Find_User_Access_Warehouses; 

PROCEDURE Check_Stock_Reserv_Allowed (
   user_id_      IN VARCHAR2,
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2)
IS
   stock_reserv_allowed_Db_   USER_WAREHOUSE_ACCESS_TAB.stock_reserv_allowed%TYPE;
BEGIN
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'ACCESS_CTRL_FOR_INV_RESERV') = db_true_) THEN
      stock_reserv_allowed_Db_ := Get_Stock_Reserv_Allowed_Db(user_id_, contract_, warehouse_id_ );  
      IF (stock_reserv_allowed_Db_ IS NULL OR stock_reserv_allowed_Db_ = Fnd_Boolean_API.DB_FALSE) THEN
         Error_SYS.Record_General(lu_name_, 
                                  'NORESERVPERM: :P1 does not have access to make stock reservations in Warehouse :P2 of Site :P3',
                                  user_id_, warehouse_id_, contract_);
      END IF;
   END IF;
END Check_Stock_Reserv_Allowed;


PROCEDURE Check_Invent_Trans_Allowed (
   user_id_      IN VARCHAR2,
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2)
IS
   invent_trans_allowed_Db_   USER_WAREHOUSE_ACCESS_TAB.invent_trans_allowed%TYPE;
BEGIN
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'ACCESS_CTRL_FOR_INV_TRANS') = db_true_) THEN
      invent_trans_allowed_Db_ := Get_Invent_Trans_Allowed_Db(user_id_, contract_, warehouse_id_);
      IF (invent_trans_allowed_Db_ IS NULL OR invent_trans_allowed_Db_ = Fnd_Boolean_API.DB_FALSE) THEN
         Error_SYS.Record_General(lu_name_,
                                  'NOTRANSPERM: :P1 does not have access to perform inventory transactions in Warehouse :P2 of Site :P3',
                                  user_id_, warehouse_id_, contract_ );
      END IF;
   END IF;
END Check_Invent_Trans_Allowed;