-----------------------------------------------------------------------------
--
--  Logical unit: PartServiceUtil
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  ---------------------------------------------------------
--  2021-07-27  ChBnlk  SC21R2-1737, Modified Get_Part_Catalog to handle errors properly. 
--  2021-07-08  DhAplk  SC21R2-1781, Modified Get_Part_Catalog by adding null check for collections.
--  2021-06-28  ChBnlk  SC21R2-1418, Modified Get_Part_Catalog() to handle error messages.
--  2021-01-25  DhAplk  SC2020R1-12242, Added is_json_ to Post_Outbound_Message() method call in Send_Part_Catalog.
--  2020-09-29  ChBnlk  SC2020R1-55, Removed the manually added methods to add attributes to the structure
--  2020-09-29          PriceCatalog and modified Send_Part_Catalog only to send the json clob.
--  2020-09-22  NiDalk  SC2020R1-9657,  Added ORDSRV installed check.
--  2020-04-23  Erlise  SC2020R1-55, Utility package created to support integration projection PartCatalogService.
---------------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


------------------------------------------------------------------------
-- Send_Part_Catalog
--    Fetch a list of parts to be exported.
--    Default output format is Json, if the parameter json_response_ is set to false,
--    two different xml formats can be returned by using the parameter ifs_xml_format_.
--    If this parameter is set to 'TRUE' the xml returned is uppercase with underscores.
------------------------------------------------------------------------
PROCEDURE Send_Part_Catalog (
   receiver_routing_parameter_ IN VARCHAR2,
   assortment_id_              IN VARCHAR2,
   part_main_group_            IN VARCHAR2,
   part_main_grp_in_cond_      IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   changed_since_no_of_days_   IN NUMBER,
   include_extra_attributes_   IN VARCHAR2 DEFAULT 'FALSE')
IS
   request_          Part_Catalog_Params_Structure_Rec;
   return_part_arr_  Part_Catalog_Structure_Arr := Part_Catalog_Structure_Arr();
   
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
      IF (part_main_group_ IS NOT NULL) THEN 
         request_.part_main_group := part_main_group_;
      END IF;
      IF (part_main_grp_in_cond_ IS NOT NULL) THEN
         request_.part_main_grp_in_cond := part_main_grp_in_cond_;
      END IF;
      IF (part_no_ IS NOT NULL) THEN
         request_.part_no := part_no_;
      END IF;
      IF (changed_since_no_of_days_ IS NOT NULL) THEN
         request_.changed_since_number_of_days := changed_since_no_of_days_;
      END IF;
      IF (include_extra_attributes_ IS NOT NULL) THEN
         IF (UPPER(include_extra_attributes_) = 'TRUE') THEN
            request_.include_attributes := true;
         ELSIF (UPPER(include_extra_attributes_) = 'FALSE') THEN
            request_.include_attributes := false;
         END IF;
      END IF;

      -- Get the response array of part records
      return_part_arr_ := Get_Part_Catalog(request_);
      json_obj_ := Part_Catalog_Structure_Arr_To_Json___(return_part_arr_);
      json_clob_ := json_obj_.to_clob;              
      Plsqlap_Server_API.Post_Outbound_Message(json_clob_,
                                                   message_id_, 
                                                   sender_,
                                                   receiver_routing_parameter_, 
                                                   message_type_ => 'APPLICATION_MESSAGE',
                                                   message_function_ => 'SEND_PART_CATALOG',
                                                   is_json_ => true);
      
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;
END Send_Part_Catalog;


FUNCTION Get_Part_Catalog (
   request_ IN Part_Catalog_Params_Structure_Rec ) RETURN Part_Catalog_Structure_Arr
IS
   return_arr_                Part_Catalog_Structure_Arr := Part_Catalog_Structure_Arr();
   TYPE Get_Part_List         IS REF CURSOR;
   get_part_list_             Get_Part_List;
   TYPE Part_List_Tab         IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   part_list_tab_             Part_List_Tab;
   stmt_                      VARCHAR2(32000);
   error_message_             VARCHAR2(20000);
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      BEGIN
         stmt_ := 'SELECT part_no FROM part_catalog ';

         IF (request_.part_no IS NOT NULL) THEN
            stmt_ := stmt_ || ' WHERE part_no LIKE UPPER(:part_no_) ';
         ELSE
            stmt_ := stmt_ || ' WHERE :part_no_ IS NULL ';
         END IF;

         IF (request_.part_main_group IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND part_main_group LIKE UPPER(:part_main_group_) ';
         ELSE
            stmt_ := stmt_ || ' AND :part_main_group_ IS NULL ';
         END IF;


         IF (request_.part_main_grp_in_cond IS NOT NULL) THEN
            -- The request parameter is split on comma as the separator, spaces are interpreted as part of the value.
            stmt_ := stmt_ || ' AND part_main_group IN (select regexp_substr(:part_main_grp_in_cond_,''[^,]+'', 1, level) from dual 
                                connect by regexp_substr(:part_main_grp_in_cond_, ''[^,]+'', 1, level) is not null) ';
         ELSE
            stmt_ := stmt_ || ' AND :part_main_grp_in_cond_ IS NULL AND :part_main_grp_in_cond_ IS NULL ';
         END IF;

         IF (request_.changed_since_number_of_days IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND objversion > to_char(sysdate - :changed_since_number_of_days_, ''YYYYMMDDHH24MISS'' )';
         ELSE
            stmt_ := stmt_ || ' AND :changed_since_number_of_days_ IS NULL ';
         END IF;

         $IF Component_Invent_SYS.INSTALLED $THEN
         -- Select parts connected to a specified assortment.
         IF (request_.assortment_id IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND part_no IN (SELECT part_no FROM assortment_node_part_cat WHERE assortment_id = :assortment_id_)';
         ELSE
            stmt_ := stmt_ || ' AND :assortment_id_ IS NULL ';
         END IF;
         $END

         @ApproveDynamicStatement(2020-05-18,ERLISE)
         OPEN  get_part_list_ FOR stmt_ USING request_.part_no,
                                              request_.part_main_group,
                                              request_.part_main_grp_in_cond,
                                              request_.part_main_grp_in_cond,
                                              request_.changed_since_number_of_days,
                                              request_.assortment_id;
         FETCH get_part_list_ BULK COLLECT INTO part_list_tab_;
         CLOSE get_part_list_;

         IF (part_list_tab_ IS NOT NULL) THEN
            IF part_list_tab_.COUNT > 0 THEN
               FOR i IN part_list_tab_.FIRST..part_list_tab_.LAST LOOP
                  return_arr_.EXTEND;
                  return_arr_(return_arr_.LAST) := Get_Part_Catalog_Structure_Rec___(part_list_tab_(i));
                  IF (request_.include_attributes = FALSE) THEN
                     return_arr_(return_arr_.LAST).attributes := Part_Catalog_Structure_Attribute_Structure_Arr();                          
                  END IF;
               END LOOP;
            END IF;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
             IF return_arr_.COUNT = 0 THEN
                  return_arr_.EXTEND;
               END IF;
            error_message_ := sqlerrm;
            return_arr_(return_arr_.LAST).error_message := error_message_;
      END;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;

   RETURN return_arr_;
END Get_Part_Catalog;

-----------------------------------------------------------------------------
-- Get_Part_Status
--   Use this method to add a true/false parameter based on business logic within IFS.
--   Default implementation will always result in the value "TRUE" in the corresponding message attribute.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Part_Status (
   part_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   part_status_ VARCHAR2(5) := 'TRUE';
BEGIN
   return part_status_;
END Get_Part_Status;
-------------------- LU  NEW METHODS -------------------------------------
