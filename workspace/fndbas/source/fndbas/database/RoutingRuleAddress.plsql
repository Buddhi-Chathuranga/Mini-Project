-----------------------------------------------------------------------------
--
--  Logical unit: RoutingRuleAddress
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


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Connector__(address_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR   get_connector
IS
   SELECT transport_connector 
   from routing_address_tab
   WHERE address_name = address_name_;
   temp_ VARCHAR2(200);
BEGIN 
   OPEN get_connector;
   FETCH get_connector INTO temp_;
   CLOSE get_connector;
   RETURN temp_;
END Get_Connector__; 


FUNCTION Get_Address__(address_name_ IN VARCHAR2) RETURN VARCHAR2
IS 
   connector_ VARCHAR2(50) := Get_Connector__(address_name_);
   CURSOR   get_address_for_file_connector
IS
   SELECT output_file 
   from routing_address_tab
   WHERE address_name = address_name_;
   CURSOR get_address_for_http_connectors
IS
   SELECT url 
   from routing_address_tab
   WHERE address_name = address_name_;
   CURSOR get_address_for_rest_connectors
IS
   SELECT rest_root_end_point  
   from routing_address_tab
   WHERE address_name = address_name_; 
   CURSOR get_address_for_mail_connectors
IS
   SELECT send_to 
   from routing_address_tab
   WHERE address_name = address_name_; 
   CURSOR get_address_for_plsql_connectors
IS
   SELECT plsql_method 
   from routing_address_tab
   WHERE address_name = address_name_; 
   CURSOR get_address_for_projection_connectors
IS
   SELECT projection_resource 
   from routing_address_tab
   WHERE address_name = address_name_; 
   CURSOR get_address_for_jms_connectors
IS
   SELECT destination 
   from routing_address_tab
   WHERE address_name = address_name_; 
   CURSOR get_address_for_ftp_or_sftp_connectors
IS
   SELECT directory 
   from routing_address_tab
   WHERE address_name = address_name_; 
   temp_ VARCHAR2(200);   
BEGIN   
   CASE connector_
      WHEN 'File' THEN
         OPEN get_address_for_file_connector;
         FETCH get_address_for_file_connector INTO temp_;
         CLOSE get_address_for_file_connector;
         RETURN temp_;
      WHEN 'Http'  THEN
         OPEN get_address_for_http_connectors;
         FETCH get_address_for_http_connectors INTO temp_;
         CLOSE get_address_for_http_connectors;
         RETURN temp_;
      WHEN 'REST' THEN
         OPEN  get_address_for_rest_connectors;
         FETCH get_address_for_rest_connectors INTO temp_;
         CLOSE get_address_for_rest_connectors;
         RETURN temp_;
      WHEN 'Mail' THEN
         OPEN get_address_for_mail_connectors;
         FETCH get_address_for_mail_connectors INTO temp_;
         CLOSE get_address_for_mail_connectors; 
         RETURN temp_;
      WHEN 'PL/SQL' THEN
         OPEN get_address_for_plsql_connectors;
         FETCH get_address_for_plsql_connectors INTO temp_;
         CLOSE get_address_for_plsql_connectors; 
         RETURN temp_;
      WHEN 'PROJECTION' THEN
         OPEN get_address_for_projection_connectors;
         FETCH get_address_for_projection_connectors INTO temp_;
         CLOSE get_address_for_projection_connectors; 
         RETURN temp_;
      WHEN 'JMS' THEN
         OPEN get_address_for_jms_connectors;
         FETCH get_address_for_jms_connectors INTO temp_;
         CLOSE get_address_for_jms_connectors; 
         RETURN temp_;
      WHEN 'Sftp' THEN 
         OPEN get_address_for_ftp_or_sftp_connectors;
         FETCH get_address_for_ftp_or_sftp_connectors INTO temp_;
         CLOSE get_address_for_ftp_or_sftp_connectors; 
         RETURN temp_;
      WHEN 'Ftp' THEN 
         OPEN get_address_for_ftp_or_sftp_connectors;
         FETCH get_address_for_ftp_or_sftp_connectors INTO temp_;
         CLOSE get_address_for_ftp_or_sftp_connectors; 
         RETURN temp_;
      ELSE
         RETURN '';
   END CASE;   
   RETURN '';
END Get_Address__; 

FUNCTION Rule_Exist__ (rule_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   temp_ VARCHAR2(100);
   CURSOR check_for_rule 
IS
   SELECT rule_name
   FROM routing_rule_address
   WHERE rule_name = rule_name_;
BEGIN
   OPEN check_for_rule;
   FETCH check_for_rule INTO temp_;
   CLOSE check_for_rule;  
   IF temp_ IS NOT NULL THEN
      RETURN TRUE;     
   END IF;
   RETURN FALSE;
END Rule_Exist__;
