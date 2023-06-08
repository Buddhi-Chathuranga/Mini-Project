-----------------------------------------------------------------------------
--
--  Logical unit: FndBookmark
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT fnd_bookmark_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   ordinal_ NUMBER;
   profile_id_ VARCHAR2(100) := Fndrr_User_Client_Profile_API.GET_PERSONAL_PROFILE_ID(Fnd_Session_API.Get_Fnd_User);

   CURSOR lock_rows IS
   SELECT *
   FROM FND_BOOKMARK_TAB
   WHERE PROFILE_ID = profile_id_ AND is_pinned = 1
   FOR UPDATE;

   CURSOR get_ordnal IS
   SELECT NVL(MAX(ordinal),0) + 1
   FROM FND_BOOKMARK_TAB
   WHERE PROFILE_ID = profile_id_ AND is_pinned = 1;

BEGIN
   newrec_.id := FND_BOOKMARK_SEQ.NEXTVAL;
   IF newrec_.is_pinned = 1 THEN
      --lock
      OPEN lock_rows;
      --get max ordinal
      OPEN get_ordnal;
      FETCH get_ordnal INTO ordinal_;
      CLOSE get_ordnal;
      --No sequence, since ordinal will modified by move()
      newrec_.ordinal := ordinal_;
      Client_SYS.Add_To_Attr('ORDINAL', newrec_.ordinal , attr_);
      CLOSE lock_rows;

   END IF;

   Client_SYS.Add_To_Attr('ID', newrec_.id, attr_);
   newrec_.profile_id := profile_id_;
   Client_SYS.Add_To_Attr('PROFILE_ID', newrec_.profile_id, attr_);
   newrec_.added := sysdate;
   Client_SYS.Add_To_Attr('ADDED', newrec_.added , attr_);
   Delete_All_Except_Latest___(50, newrec_.context);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN            VARCHAR2,
   oldrec_     IN            fnd_bookmark_tab%ROWTYPE,
   newrec_     IN OUT NOCOPY fnd_bookmark_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   by_keys_    IN            BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.added := sysdate;
   Client_SYS.Add_To_Attr('ADDED', newrec_.added, attr_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

-------------------- PRIVATE DECLARATIONS -----------------------------------
PROCEDURE Delete_All_Except_Latest___ (
   number_to_keep_ IN NUMBER,
   context_ IN VARCHAR2 )
IS
   total_ NUMBER;
   last_ DATE;
   profile_ VARCHAR2(100);
BEGIN
   profile_ := FNDRR_USER_CLIENT_PROFILE_API.GET_PERSONAL_PROFILE_ID(fnd_session_api.Get_Fnd_User);
   SELECT COUNT(*) INTO total_ FROM FND_BOOKMARK_TAB WHERE PROFILE_ID = profile_ AND IS_PINNED = '0' AND CONTEXT = context_;
   IF total_ > number_to_keep_ THEN
         SELECT ADDED INTO last_ FROM (SELECT ROW_NUMBER() OVER (ORDER BY ADDED DESC) AS rownumber, ADDED FROM FND_BOOKMARK_TAB WHERE PROFILE_ID = profile_ AND IS_PINNED = '0' AND CONTEXT = context_) WHERE ROWNUMBER = number_to_keep_;
         DELETE FROM FND_BOOKMARK_TAB WHERE ADDED < last_ AND PROFILE_ID = profile_ AND IS_PINNED = '0' AND CONTEXT = context_;
         @ApproveTransactionStatement()
         COMMIT;
   END IF;
END Delete_All_Except_Latest___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

