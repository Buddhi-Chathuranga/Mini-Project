old 103:    Public_Revoke('&DO_PUBLIC_REVOKE');
new 103:    Public_Revoke('Y');
Privleges are revoked from PUBLIC. Run the marked lines to regrant these        
privleges                                                                       
================================================================================
==                                                                              
SUCCESS: REVOKE ALL ON SYS."UTL_TCP" FROM PUBLIC                                
RUN THIS COMMAND TO REGRANT THE PRIVILEGE: GRANT EXECUTE ON SYS."UTL_TCP" TO    
PUBLIC;                                                                         
SUCCESS: REVOKE ALL ON SYS."UTL_HTTP" FROM PUBLIC                               
RUN THIS COMMAND TO REGRANT THE PRIVILEGE: GRANT EXECUTE ON SYS."UTL_HTTP" TO   
PUBLIC;                                                                         
SUCCESS: REVOKE ALL ON SYS."UTL_FILE" FROM PUBLIC                               
RUN THIS COMMAND TO REGRANT THE PRIVILEGE: GRANT EXECUTE ON SYS."UTL_FILE" TO   
PUBLIC;                                                                         
SUCCESS: REVOKE ALL ON SYS."UTL_SMTP" FROM PUBLIC                               
RUN THIS COMMAND TO REGRANT THE PRIVILEGE: GRANT EXECUTE ON SYS."UTL_SMTP" TO   
PUBLIC;                                                                         

PL/SQL procedure successfully completed.

