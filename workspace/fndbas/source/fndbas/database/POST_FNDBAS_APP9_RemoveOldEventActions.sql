
-----------------------------------------------------------------------------------------
--
--  Module:       FNDBAS
--
--  File:         POST_FNDBAS_APP9_RemoveOldEventActions.sql
--
--  Purpose:      The following Event Action types are obsolete with APP9
--                -SMSMESSAGE
--                -SHELLCOMMAND
--                This will remove obsolete event actions.And the removed actions are logged to a file. 
--
-----------------------------------------------------------------------------------------
--  Date    Sign      History
--  ------  ------    -------------------------------------------------------------------
--  150925  MADDLK    Created.
-----------------------------------------------------------------------------------------

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SET FEEDBACK OFF

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP9_RemoveOldEventActions.sql','Started');
PROMPT POST_FNDBAS_APP9_RemoveOldEventActions.sql
PROMPT Spooling to file removed_obsolete_event_actions.log
PROMPT ----------------------------------------------------

SET TERMOUT OFF

SPOOL removed_obsolete_event_actions.log

DECLARE 
    count_ NUMBER;
    CURSOR get_obsolete_actions IS
       SELECT t.event_lu_name,t.event_id,t.description,t.action_enable,t.fnd_event_action_type,t.action_parameters,t.action_number 
       FROM FND_EVENT_ACTION_TAB t
       WHERE fnd_event_action_type IN ('SMSMESSAGE','SHELLCOMMAND'); 


BEGIN

   Dbms_Output.Put_Line(' --                                                                                    ');
   Dbms_Output.Put_Line(' --                                                                                    ');
   Dbms_Output.Put_Line(' -- The following Event Action types are obsolete with APP9                            ');
   Dbms_Output.Put_Line(' --   SMSMESSAGE                                                                       ');
   Dbms_Output.Put_Line(' --   SHELLCOMMAND                                                                     ');
   Dbms_Output.Put_Line(' --                                                                                    ');
   Dbms_Output.Put_Line(' -- Post Script POST_FNDBAS_APP9_RemoveOldEventActions.sql removed following           ');
   Dbms_Output.Put_Line(' -- obsolete event actions                                                             ');
   Dbms_Output.Put_Line(' --                                                                                    ');
   Dbms_Output.Put_Line(' --------------------------------------------------------------------------------------'); 

   FOR rec_ IN get_obsolete_actions LOOP
            
      Dbms_Output.Put_Line(' -- Event ID             : '|| rec_.event_id ); 
      Dbms_Output.Put_Line(' -- Event Lu Name        : '|| rec_.event_lu_name ); 
      Dbms_Output.Put_Line(' -- Action type          : '|| rec_.fnd_event_action_type ); 
      Dbms_Output.Put_Line(' -- Action Description   : '|| rec_.description ); 
      Dbms_Output.Put_Line(' -- Action Enabled       : '|| rec_.action_enable ); 
      Dbms_Output.Put_Line(' -- Action Parameters    : '|| rec_.action_parameters ); 
      
      Dbms_Output.Put_Line(' -----------------------------------------------------------------------------------'); 
      
   
      DELETE 
      FROM FND_EVENT_ACTION_TAB 
      WHERE event_id = rec_.event_id AND event_lu_name  = rec_.event_lu_name AND action_number=rec_.action_number; 
      
      SELECT count(*) 
      INTO count_ 
      FROM FND_EVENT_ACTION_TAB 
      WHERE event_id = rec_.event_id AND event_lu_name = rec_.event_lu_name AND action_enable='TRUE';
      
      IF (count_ = 0) THEN
        
        UPDATE fnd_event_tab 
        SET event_enable ='FALSE'
        WHERE event_id=rec_.event_id AND event_lu_name=rec_.event_lu_name;
        
      END IF;
      
      COMMIT;                          
   
   END LOOP;
   

END;
/


SET TERMOUT ON
SPOOL OFF
--

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP9_RemoveOldEventActions.sql','Finished');
PROMPT Execution of POST_FNDBAS_APP9_RemoveOldEventActions.sql is Completed.

