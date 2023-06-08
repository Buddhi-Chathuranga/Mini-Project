-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationStatistics
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000621  ROOD    Set business_object uppercase in view.
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Statistics (
   business_object_   IN VARCHAR2,
   lu_name_           IN VARCHAR2,
   replication_date_  IN DATE DEFAULT sysdate,
   rows_sent_         IN NUMBER DEFAULT 0,
   rows_received_     IN NUMBER DEFAULT 0,
   errors_on_send_    IN NUMBER DEFAULT 0,
   errors_on_receive_ IN NUMBER DEFAULT 0 )
IS
   objid_         VARCHAR2(200);
   objversion_    VARCHAR2(200);
   oldrec_        replication_statistics_tab%ROWTYPE;
   newrec_        replication_statistics_tab%ROWTYPE;
   attr_          VARCHAR2(200);
   key_format_    VARCHAR2(20) := NVL(Fnd_Setting_API.Get_Value('REPL_STAT_KEY_FORMAT'),'YYYY-MM-DD');
   CURSOR c1_statistics (object_  replication_statistics_tab.business_object%TYPE,
                         lu_      replication_statistics_tab.lu_name%TYPE,
                         date_    replication_statistics_tab.replication_date%TYPE) IS
      SELECT *
      FROM   replication_statistics_tab
      WHERE  business_object  = object_
      AND    lu_name          = lu_
      AND    replication_date = date_;
BEGIN
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_STATISTICS'),'OFF') = 'ON' ) THEN 
      OPEN c1_statistics (business_object_, lu_name_, TO_CHAR(replication_date_, key_format_));
      FETCH c1_statistics INTO oldrec_;
      IF ( c1_statistics%FOUND ) THEN
         CLOSE c1_statistics;
         newrec_                   := oldrec_;
         newrec_.rows_sent         := NVL(newrec_.rows_sent, 0)         + rows_sent_;
         newrec_.rows_received     := NVL(newrec_.rows_received, 0)     + rows_received_;
         newrec_.errors_on_send    := NVL(newrec_.errors_on_send, 0)    + errors_on_send_;
         newrec_.errors_on_receive := NVL(newrec_.errors_on_receive, 0) + errors_on_receive_;
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      ELSE
         CLOSE c1_statistics;
         newrec_.business_object   := business_object_;
         newrec_.lu_name           := lu_name_;
         newrec_.replication_date  := TO_CHAR(replication_date_, key_format_);
         newrec_.rows_sent         := rows_sent_;
         newrec_.rows_received     := rows_received_;
         newrec_.errors_on_send    := errors_on_send_;
         newrec_.errors_on_receive := errors_on_receive_;
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END IF;
EXCEPTION
   WHEN others THEN
      NULL;
END Create_Statistics;



