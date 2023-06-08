-----------------------------------------------------------------------------
--
--  Logical unit: AssortmentServiceUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  ---------------------------------------------------------
--  2021-06-28  ChBnlk  SC21R2-1417, Modified Get_Assortment() to handle errors.
--  2021-01-25  DhAplk  SC2020R1-12242, Added is_json_ to Post_Outbound_Message() method call in Send_Assortment.
--  2020-09-29  ChBnlk  SC2020R1-204, Removed the manually added methods to add attributes to the structure
--  2020-09-29          Assortment and modified Send_Assortment only to send the json clob.
--  2020-09-22  NiDalk  SC2020R1-9657,  Added ORDSRV installed check.
--  2020-07-01  Erlise  SC2020R1-204, Created to support the integration projection AssortmentService. 
---------------------------------------------------------------------------------

layer Core;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Override the default method to be able to control if a sub section of the structure should be included in the response.
@Override
FUNCTION Get_Assortment_Structure_Node_Language_Description_Arr___ (
   assortment_id_ IN VARCHAR2,
   node_id_ IN VARCHAR2) RETURN Assortment_Structure_Node_Language_Description_Arr
IS
   include_lang_ BOOLEAN DEFAULT TRUE;
   return_arr_ Assortment_Structure_Node_Language_Description_Arr := Assortment_Structure_Node_Language_Description_Arr();
BEGIN
   include_lang_ := App_Context_SYS.Find_Boolean_Value('INCLUDE_ASSORT_NODE_LANG', TRUE);

   IF (include_lang_ = FALSE) THEN
      RETURN return_arr_;
   ELSE
      RETURN Super(assortment_id_, node_id_);
   END IF;
   
END Get_Assortment_Structure_Node_Language_Description_Arr___;


-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE Send_Assortment (
   receiver_routing_parameter_ IN VARCHAR2,
   assortment_id_              IN VARCHAR2,
   include_language_desc_      IN VARCHAR2 DEFAULT 'FALSE',
   include_extra_attributes_   IN VARCHAR2 DEFAULT 'FALSE' )
IS
   request_          Assortment_Params_Structure_Rec;
   return_arr_       Assortment_Structure_Arr := Assortment_Structure_Arr();
   message_id_       NUMBER;
   sender_           VARCHAR2(20);
   json_obj_         JSON_OBJECT_T;
   json_clob_        CLOB;

BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      -- Create the query record
      IF (assortment_id_ IS NOT NULL) THEN
         request_.assortment_id := assortment_id_;
      END IF;
      IF (include_language_desc_ IS NOT NULL) THEN
         IF (UPPER(include_language_desc_) = 'TRUE') THEN
            request_.include_language_desc := true;
         ELSIF (UPPER(include_language_desc_) = 'FALSE') THEN
            request_.include_language_desc := false;
         END IF;
      END IF;
      IF (include_extra_attributes_ IS NOT NULL) THEN
         IF (UPPER(include_extra_attributes_) = 'TRUE') THEN
            request_.include_attributes := true;
         ELSIF (UPPER(include_extra_attributes_) = 'FALSE') THEN
            request_.include_attributes := false;
         END IF;
      END IF;

      -- Get the response array
      return_arr_ := Get_Assortment(request_);  
      json_obj_ := Assortment_Structure_Arr_To_Json___(return_arr_);
      json_clob_ := json_obj_.to_clob;              
      Plsqlap_Server_API.Post_Outbound_Message(json_clob_,
                                                message_id_, 
                                                sender_,
                                                receiver_routing_parameter_, 
                                                message_type_ => 'APPLICATION_MESSAGE',
                                                message_function_ => 'SEND_ASSORTMENT',
                                                is_json_ => true);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;
END Send_Assortment;


FUNCTION Get_Assortment (
   request_ IN Assortment_Params_Structure_Rec ) RETURN Assortment_Structure_Arr
IS
   return_arr_    Assortment_Structure_Arr := Assortment_Structure_Arr();
   
   CURSOR Get_Assortment IS
   SELECT assortment_id, assortment_node_id
   FROM   assortment_node
   WHERE  assortment_id = request_.assortment_id;
   
   error_message_       VARCHAR2(20000);
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      BEGIN
         -- Set a global context value that can be used in the override method Get_Assortment_Structure_Node_Language_Description_Arr___.
         -- There is a significant drop in performance if this sub section is added and to avoid the sub select from being executed, this context variable is used.
         App_Context_SYS.Set_Value('INCLUDE_ASSORT_NODE_LANG', request_.include_language_desc);
         FOR rec_ IN get_assortment LOOP
            return_arr_.EXTEND;
            return_arr_(return_arr_.LAST) := Get_Assortment_Structure_Rec___(request_.assortment_id, rec_.assortment_node_id);
            IF (request_.include_attributes = FALSE) THEN
              return_arr_(return_arr_.LAST).attributes := Assortment_Structure_Attributes_Arr();           
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS THEN 
            IF return_arr_.COUNT = 0 THEN
               return_arr_.EXTEND;
            END IF;
            error_message_ :=  sqlerrm;
            return_arr_(return_arr_.LAST).error_message := error_message_;
         END;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;
   RETURN return_arr_;
END Get_Assortment;
