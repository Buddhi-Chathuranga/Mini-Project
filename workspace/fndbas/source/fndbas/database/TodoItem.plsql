-----------------------------------------------------------------------------
--
--  Logical unit: TodoItem
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
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT todo_item_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.created_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := sysdate;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Complete_Task(
   item_id_    IN VARCHAR2,
   response_   IN VARCHAR2 DEFAULT NULL)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
BEGIN
   Client_Sys.Add_To_Attr('COMPLETED',1,attr_);
   IF response_ IS NOT NULL THEN
       Client_Sys.Add_To_Attr('COMPLETE_RESPONSE',response_,attr_);
   END IF;
   Client_Sys.Add_To_Attr('COMPLETED_DATE',trunc(SYSDATE),attr_);
   Client_Sys.Add_To_Attr('COMPLETED_BY',Fnd_Session_Api.Get_Fnd_User,attr_);
   Get_Id_Version_By_Keys___(objid_,objversion_,item_id_);
   Modify__(info_,objid_,objversion_,attr_,'DO');
END Complete_Task; 


@UncheckedAccess
PROCEDURE Change_Priority(
   item_id_    IN VARCHAR2,
   priority_   IN VARCHAR2)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
BEGIN
   Client_Sys.Add_To_Attr('PRIORITY',priority_,attr_);   
 
   Get_Id_Version_By_Keys___(objid_,objversion_,item_id_);
   Modify__(info_,objid_,objversion_,attr_,'DO');
END Change_Priority;


FUNCTION Insert_Basic_Task__ (
   title_           IN VARCHAR2,
   message_         IN VARCHAR2,
   business_object_ IN VARCHAR2,
   url_             IN VARCHAR2,
   personid_        IN VARCHAR2) RETURN VARCHAR2
IS
   newrec_     todo_item_tab%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   item_id_       VARCHAR2 (100);
   item_shared_ NUMBER;
   session_person_ VARCHAR2 (100);
BEGIN
   $IF Component_Enterp_SYS.INSTALLED $THEN
      session_person_ := Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User()); 
   $END    
   IF(personid_ = session_person_) THEN
      item_shared_ := 0;
   ELSE
      item_shared_ := 1;
   END IF;

   item_id_ := sys_guid();
   newrec_.item_id           := item_id_;
   newrec_.title             := title_;
   newrec_.item_message      := message_;
   newrec_.business_object   := business_object_;
   newrec_.completed         := 0;
   newrec_.created_by        := session_person_;
   newrec_.created_date      := SYSDATE;
   newrec_.priority          := Todo_Priority_API.DB_NORMAL;
   newrec_.shared            := item_shared_;
   newrec_.url               := url_;   
   Insert___(objid_, objversion_, newrec_, attr_);  
   RETURN item_id_;
END Insert_Basic_Task__;





