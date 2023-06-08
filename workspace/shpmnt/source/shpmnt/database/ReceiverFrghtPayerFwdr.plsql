-----------------------------------------------------------------------------
--
--  Logical unit: ReceiverFrghtPayerFwdr
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211102  ErRalk  SC21R2-3011, Modified Check_Delete___, Validate_Receiver_Id__ and 
--  211102          Validate_Receiver_Address__ to support supplier receiver type.
--  171004  MaRalk  STRSC-11324, Override Check_Delete___ in order to restrict the delete
--  171004          when the record is referred in shipments. 
--  171003  MaRalk  STRSC-12004, Added methods Validate_Receiver_Id__, Validate_Receiver_Address__  
--  171003          and removed method Receiver_Address_Exist. Modified Check_Insert___ accordingly.
--  170817  MaRalk  STRSC-10692, Override Prepare_Insert___ to set 'Customer' as receiver type.
--  170810  MaRalk  STRSC-10762, Override Get_Freight_Payer_Id in order to handle '*' as the address id.
--  170725  MaRalk  STRSC-10683, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT receiver_frght_payer_fwdr_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN  
   super(newrec_, indrec_, attr_);   
   -- Handling reference check manually for Receiver Id and Address Id since no references added in the model.
   Validate_Receiver_Id__(newrec_.receiver_id, newrec_.receiver_type);
   Validate_Receiver_Address__(newrec_.receiver_id, newrec_.address_id, newrec_.receiver_type);   
END Check_Insert___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN   
   super(attr_); 
   Client_SYS.Add_To_Attr('RECEIVER_TYPE_DB', Sender_Receiver_Type_API.DB_CUSTOMER, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_TYPE', Sender_Receiver_Type_API.Decode(Sender_Receiver_Type_API.DB_CUSTOMER), attr_);
END Prepare_Insert___;
  
@Override
PROCEDURE Check_Delete___ (
   remrec_ IN receiver_frght_payer_fwdr_tab%ROWTYPE )
IS 
BEGIN
   super(remrec_);
   -- Check Shipment exist for the given record
   Shipment_API.Check_Exist_By_Freight_Payer(remrec_.receiver_type, 
                                             remrec_.receiver_id, 
                                             remrec_.address_id,
                                             remrec_.forwarder_id,
                                             Shipment_Payer_API.DB_RECEIVER,
                                             remrec_.freight_payer_id);      
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Validate_Receiver_Id
-- This procedue will validate the receiver id corresponding to a specifc receiver type.
PROCEDURE Validate_Receiver_Id__(
   receiver_id_   IN VARCHAR2,
   receiver_type_ IN VARCHAR2 )   
IS    
BEGIN            
   IF (receiver_type_ = Sender_Receiver_Type_API.DB_CUSTOMER AND (NOT Customer_Info_API.Exists(receiver_id_))) OR 
      (receiver_type_ = Sender_Receiver_Type_API.DB_SUPPLIER AND (NOT Supplier_Info_API.Exists(receiver_id_))) THEN         
         Error_SYS.Record_General(lu_name_, 'RECEIVERNOTEXIST: Receiver ID :P1 with :P2 receiver type does not exist', receiver_id_, Sender_Receiver_Type_API.Decode(receiver_type_));        
   END IF;     
END Validate_Receiver_Id__;


-- Validate_Receiver_Address
-- This method validates receiver address for any receiver type.  
-- It is allowed to save astric('*') as the address id which implies certain ReceiverFrghtPayerFwdr 
-- record can be considered for specific receiver id and forwarder combination irrespective 
-- of a specifically defined address id. 
PROCEDURE Validate_Receiver_Address__(
   receiver_id_      IN VARCHAR2,
   address_id_       IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2)
IS 
BEGIN 
   IF (receiver_type_db_ IN (Sender_Receiver_Type_API.DB_CUSTOMER,Sender_Receiver_Type_API.DB_SUPPLIER)) THEN      
      IF(Customer_Info_Address_API.Exists(receiver_id_, address_id_)) THEN
         IF (Customer_Info_Address_Type_API.Check_Exist(receiver_id_, address_id_, Address_Type_Code_API.Decode( 'DELIVERY' )) != 'TRUE') THEN   
            Error_SYS.Record_General(lu_name_, 'MUSTBEDELIVERYADDRESS: Receiver address must be a delivery address.');
         ELSIF (Customer_Info_Address_API.Is_Valid(receiver_id_, address_id_) != 'TRUE')THEN
            Error_SYS.Record_General(lu_name_, 'MUSTBEVALIDADDRESS: Receiver address must be a valid address.');
         END IF; 
      ELSIF(Supplier_Info_Address_API.Exists(receiver_id_, address_id_)) THEN
         IF (Supplier_Info_Address_Type_API.Check_Exist(receiver_id_, address_id_, Address_Type_Code_API.Decode( 'DELIVERY' )) != 'TRUE') THEN  
            Error_SYS.Record_General(lu_name_, 'MUSTBEDELIVERYADDRESS: Receiver address must be a delivery address.');
         ELSIF (Supplier_Info_Address_API.Is_Valid(receiver_id_, address_id_) != 'TRUE') THEN 
            Error_SYS.Record_General(lu_name_, 'MUSTBEVALIDADDRESS: Receiver address must be a valid address.');
         END IF;
      ELSIF (address_id_ != '*') THEN
         Error_SYS.Record_General(lu_name_, 'CUSTOMERADDRNOTEXIST: Receiver address ID :P1 does not exist', address_id_);
      END IF;
   END IF;  
END Validate_Receiver_Address__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@Override
FUNCTION Get_Freight_Payer_Id (
   forwarder_id_ IN VARCHAR2,
   receiver_type_ IN VARCHAR2,
   receiver_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   temp_ receiver_frght_payer_fwdr_tab.freight_payer_id%TYPE;
BEGIN
   temp_ := super(forwarder_id_, receiver_type_, receiver_id_, address_id_); 
   IF (temp_ IS NULL) THEN
      temp_ := super(forwarder_id_, receiver_type_, receiver_id_, '*');
   END IF;
   RETURN temp_;   
END Get_Freight_Payer_Id;

