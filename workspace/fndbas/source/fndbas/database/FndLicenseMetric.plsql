-----------------------------------------------------------------------------
--
--  Logical unit: FndLicenseMetric
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
FUNCTION Get_ObjKey_Of_License_Metric___(
      metric_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      rowkey_ fnd_license_metric_tab.rowkey%TYPE;
   BEGIN
      IF (metric_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT rowkey
         INTO  rowkey_
         FROM  fnd_license_metric_tab
         WHERE metric = metric_;
      RETURN rowkey_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(metric_, 'Get_ObjKey_Of_License_Metric___');
   END Get_ObjKey_Of_License_Metric___ ;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Register(
   metric_      IN VARCHAR2,
   method_      IN VARCHAR2,
   component_   IN VARCHAR2,
   description_ IN VARCHAR2,
   type_        IN VARCHAR2)
IS
   rec_ fnd_license_metric_tab%ROWTYPE;
BEGIN
   IF NOT REGEXP_LIKE(method_, '^[[:alpha:]_]+\.[[:alpha:]_]+$') THEN
      Error_SYS.Appl_General(lu_name_, 'METRIC_FORMAT_VIOLATION: The metric [:P1] can not be executed because it contains illegal characters.', metric_);
   END IF;
   
   rec_.metric := metric_;
   rec_.method := method_;
   rec_.component := UPPER(component_);
   rec_.description := description_;
   rec_.type := type_;
   
   IF Check_Exist___(metric_) THEN 
      rec_.rowkey := Get_ObjKey_Of_License_Metric___(metric_);
      Modify___(rec_);
   ELSE 
      New___(rec_);
   END IF;
END Register;

PROCEDURE Unregister(metric_ IN VARCHAR2)
IS
   remrec_ fnd_license_metric_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(metric_) THEN
      remrec_ := Get_Object_By_Keys___(metric_);
      Remove___(remrec_);
   END IF;
END Unregister;

FUNCTION Calculate_Metric(
   metric_ IN VARCHAR2) RETURN VARCHAR2
IS 
   rec_ fnd_license_metric_tab%ROWTYPE;
   result_ VARCHAR2 (4000);
BEGIN
   rec_ := Get_Object_By_Keys___(metric_);
   
   IF NOT REGEXP_LIKE(rec_.method, '^[[:alpha:]_]+\.[[:alpha:]_]+$') THEN
      Error_SYS.Appl_General(lu_name_, 'METRIC_FORMAT_VIOLATION: The metric [:P1] can not be executed because it contains illegal characters.', metric_);
   END IF;
   
   @ApproveDynamicStatement(2020-08-31,bjokse)
   EXECUTE IMMEDIATE 'BEGIN :result := ' || rec_.method || '(); END;' USING OUT result_;
   RETURN result_;
END Calculate_Metric;

FUNCTION Get_Description_By_Id(metric_ VARCHAR2) RETURN VARCHAR2
IS
   rec_  Fnd_License_Metric_tab%ROWTYPE;
   --description_ VARCHAR2(1000);
BEGIN
   rec_ := Get_Object_By_Keys___(metric_);
   RETURN rec_.description;
END Get_Description_By_Id;

