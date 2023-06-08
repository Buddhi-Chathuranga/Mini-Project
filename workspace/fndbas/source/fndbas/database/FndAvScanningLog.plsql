-----------------------------------------------------------------------------
--
--  Logical unit: FndAvScanningLog
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
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_av_scanning_log_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY fnd_av_scanning_log_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF (newrec_.identity IS NOT NULL)
       AND (indrec_.identity)
       AND (Validate_SYS.Is_Changed(oldrec_.identity, newrec_.identity))
       AND (newrec_.identity != 'FSS') THEN
      Fnd_User_API.Exist(newrec_.identity);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Log_Scanner_Event(
   table_name_    VARCHAR2,
   ref_rowkey_    VARCHAR2,
   event_         VARCHAR2,
   agent_         VARCHAR2,
   info_          VARCHAR2 DEFAULT '',
   identity_      VARCHAR2 DEFAULT '' )
IS
   newrec_     fnd_av_scanning_log_tab%ROWTYPE;
BEGIN
   newrec_.timestamp    := SYSTIMESTAMP;
   newrec_.table_name   := table_name_;
   newrec_.ref_rowkey   := ref_rowkey_;
   newrec_.event        := event_;
   newrec_.agent        := agent_;
   newrec_.info         := info_;
   
   IF identity_ IS NULL THEN
      newrec_.identity  := Fnd_Session_API.Get_Fnd_User;
   ELSE
      newrec_.identity := identity_;
   END IF;
   
   New___(newrec_);
   
END Log_Scanner_Event;


FUNCTION Get_Latest_Threat_Skipped_Info (
   table_name_    VARCHAR2,
   ref_rowkey_    VARCHAR2) RETURN VARCHAR2
IS
   threat_info_   VARCHAR2(1000);
   timestamp_     fnd_av_scanning_log_tab.timestamp%TYPE;
BEGIN
   SELECT MAX(timestamp) 
      INTO timestamp_
      FROM fnd_av_scanning_log_tab
      WHERE ref_rowkey = ref_rowkey_
      AND table_name = table_name_
      AND event = 'SetThreatSkipped';
   threat_info_ := Get_Info(timestamp_, table_name_,ref_rowkey_);
   RETURN threat_info_;
END Get_Latest_Threat_Skipped_Info;
