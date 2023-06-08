-----------------------------------------------------------------------------
--
--  Logical unit: CompanyEmp
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981012  Camk    Created
--  981125  Camk    Keys are changed from Company, Person_Id to
--                  Company, Employee_Id
--  981210  Camk    Get_Max_Employee_Id() added.
--  990127  Camk    Replace() added.
--  990210  Camk    Get_Employee_UsingPerson() added.
--  990415  Maruse  New template
--  990429  Maruse  New template, corrs
--  991012  Camk    New method Add_Emp_To_Project___ added.
--  991019  Camk    New method Remove_Emp_From_Project___ added.
--  000306  Camk    Bug# 14896 Corrected.
--  000313  Camk    Method Create_H_R_Employee added.
--  000330  Camk    Removed Error_SYS.Check_Not_Null in Unpack_Check_Insert___ for person_id.
--                  Added a control in Insert___ instead, to check if person_id is null. This
--                  because it should be possible to fetch an automatic generated person_id
--                  from LU PartyIdentitySeries. Also added the procedure get_identity___.
--  000405  Camk    Call #36840. Warning when multiple employees added.
--  000420  Camk    Bug #15919 Corrected. Expire date added
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  010222  ToOs    Bug # 20177 Added Global Lu constants for check for transaction_sys calls
--  010522  Raablk  Bug # 20748 Added another error message in PROCEDURE Create_H_R_Employee and commented previous one .
--  011015  ovjose  Added PROCEDURE Set_Person_Id (Bug 25369)
--  050919  Hecolk  LCS Merge - Bug 52720, Added FUNCTION Get_Next_Identity and Removed PROCEDURE Get_Identity___ 
--  050922  Hecolk  LCS Merge - Bug 52935, Added PROCEDURE Update_Expire_Date
--  060105  Rufelk  B130412 - Modified the Get_Next_Identity() function so that the next value is always updated.
--                  Also removed all unused variables.
--  060505  Hecolk  Bug 56391, Added PROCEDURE Check_Expire_Date_All__
--  060726  CsAmlk  Persian Calendar Modifications.
--  070301  JAPALK  Bug Id 141340.Modified Exist method.
--  070515  Surmlk  Added ifs_assert_safe comment
--  071214  Jakalk  Bug 70020, Modified column 'name' of view COMPANY_EMP as a LOV column.
--  080114  Shdilk  Bug 66318, Modified Check_Exist___ to check the expire date as well
--  081105  Shdilk  Bug 78220, Modified Get_Max_Employee_Id to consider the expire date
--  090401  Hiralk  Bug 80549, Added PROCEDURE Check_Expire_Date_Time_Rep__() to check the max_creation_date of work order time reporting.
--  100603  Kanslk  Bug 91109, Modified Check_Exist___.
--  100906  JoAnSe  Added Get_Control_Type_Value_Desc
--  110811  Umdolk  Merged Bug 95254, added method Check_Emp_Day_Exists.
--  110831  Chhulk  EASTTWO-9715, Merged Bug 98518
--  120425  Chwilk  EASTRTM-10403, Merged Bug 102199.
--  130118  KrRaLK  Bug 106514, Modified Get_Expire_Date().
--  130614  DipeLK  TIBE-726, Removed global variables which used to check exsistance of PROJ,PCM,PERSON components.
--  140217  MEALLK  PBFI-4704, modifed Insert___.
--  140725  Hecolk  PRFI-41, Moved code that generates Employee Id from Check_Insert___ to Insert___ 
--  160706  SamGLK  STRSA-7401, Added Set_Primary_Schedule().
--  161108  Vwloza  STRPJ-17617, Removed primary_scheduling column and related code.
--  210201  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods New and Update_Expire_Date
-- ----------- Black Pearl----------------------------------------------------
--  130920  MADGLK  Black-742 Replace conditional compilation that refers PCM
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Emp_Rec_ IS RECORD (
   emp_id     company_emp_tab.employee_id%TYPE,
   exp_date   DATE );

TYPE Emp_Info_Table IS TABLE OF Emp_Rec_ INDEX BY BINARY_INTEGER;
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Remove_Emp_From_Project___ (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2 )
IS   
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      -- Add new employee to project access teams where all employees are teams.
      Project_Access_Definition_API.Remove_Access(NULL, NULL, employee_id_, company_, NULL);
   $ELSE
      NULL;
   $END
END Remove_Emp_From_Project___;


PROCEDURE Add_Emp_To_Project___ (
   employee_id_  IN  VARCHAR2 )
IS   
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      -- Add new employee to project access teams where all employees are teams.
      Project_Access_Definition_API.Generate_Access(employee_id_);
   $ELSE
      NULL;
   $END
END Add_Emp_To_Project___;


@Override
FUNCTION Check_Exist___ (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   tmp_ BOOLEAN;
   expire_date_ company_emp_tab.expire_date%TYPE;
BEGIN
   tmp_ := super(company_, employee_id_);
   IF (tmp_) THEN
      expire_date_ := Get_Expire_Date(company_, employee_id_);
      IF (TRUNC(expire_date_) >= TRUNC(SYSDATE) OR expire_date_ IS NULL) THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;   
    ELSE  
        RETURN tmp_;
    END IF;   
END Check_Exist___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT company_emp_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.employee_id IS NULL) THEN
      IF (NOT Party_Identity_Series_API.Exists_Db('EMPLOYEE')) THEN
         Error_SYS.Record_General(lu_name_, 'PERS_ERROR2: Employee ID requires a value.');
      END IF;
      newrec_.employee_id := Get_Next_Identity(newrec_.company);      
   END IF;   
   IF (Company_Emp_API.Get_Expire_Date(newrec_.company, newrec_.employee_id) < SYSDATE) THEN
      Error_SYS.Appl_General(lu_name_, 'EXPEMPEXISTS: An expired employee with this employee ID already exists.');
   END IF;
   --Add new employee to project
   Add_Emp_To_Project___(newrec_.employee_id);
   super(objid_, objversion_, newrec_, attr_);
   Create_H_R_Employee(newrec_);
   Client_SYS.Add_To_Attr('EMPLOYEE_ID', newrec_.employee_id, attr_);
END Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN company_emp_tab%ROWTYPE )
IS   
BEGIN
   Remove_Emp_From_Project___(remrec_.company, remrec_.employee_id);
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_emp_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN   
   super(newrec_, indrec_, attr_);
   --Check if person already registated as an employee
   Check_If_Person_Is_Emp(newrec_.company, newrec_.person_id);
END Check_Insert___;


@Override
PROCEDURE Raise_Record_Not_Exist___ (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'EMPLOYEE: Employee :P1 does not exist', employee_id_);
   super(company_, employee_id_);
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Check_Expire_Date_All__ (
   warn_msg_      OUT VARCHAR2,
   emp_msg_       IN  VARCHAR2,
   company_       IN  VARCHAR2 )
IS
   language_        VARCHAR2(15)  := Language_SYS.Get_Language;
   m_s_names_       Message_SYS.name_table;
   m_s_values_      Message_SYS.line_table;
   emp_rec1_        Emp_Info_Table;
   tmp_emp_id_      company_emp_tab.employee_id%TYPE; 
   count_           NUMBER;
   index_           NUMBER := 0;
   tmp_value_       VARCHAR2(5);
   stmt_            VARCHAR2(4000);
BEGIN
   $IF Component_Wo_SYS.INSTALLED $THEN
      Message_SYS.Get_Attributes(emp_msg_, count_, m_s_names_, m_s_values_);
      FOR dummy_ IN 1..count_ LOOP
         IF (m_s_names_(dummy_) = 'EMP_ID') THEN
            index_ := index_ + 1;
            emp_rec1_(index_).emp_id := m_s_values_(dummy_);
         ELSIF (m_s_names_(dummy_) = 'EXP_DATE') THEN
            emp_rec1_(index_).exp_date := Client_SYS.Attr_Value_To_Date(m_s_values_(dummy_));
         END IF;
      END LOOP;
      count_ := 0;
      stmt_ := Language_SYS.Translate_Constant(lu_name_, 'WARN1: There are planned operation lines on Work Orders for the following Employees.', language_);
      FOR dummy_ IN 1..index_ LOOP
         tmp_value_ := Jt_Execution_Instance_API.Is_Execution_Instance_Exist(company_, emp_rec1_(dummy_).emp_id, emp_rec1_(dummy_).exp_date); 
         IF (tmp_value_ = 'TRUE') THEN
            stmt_ := stmt_ || CHR(13) || emp_rec1_(dummy_).emp_id;
            tmp_emp_id_ := emp_rec1_(dummy_).emp_id;
            count_ := count_ + 1;
         END IF;
      END LOOP;
      IF (count_ = 0) THEN
         stmt_ := NULL;
      ELSE
         IF (count_ = 1) THEN
            stmt_ := Language_SYS.Translate_Constant(lu_name_, 'WARN2: There are planned operation lines on Work Orders for Employee :P1.',language_, tmp_emp_id_);
         END IF;
         stmt_ := stmt_ || CHR(13) || Language_SYS.Translate_Constant(lu_name_,'WARN3: Do you want to continue anyway?',language_);
      END IF;
      warn_msg_ := stmt_; 
   $ELSE
      NULL;
   $END
END Check_Expire_Date_All__;


PROCEDURE Check_Expire_Date_Time_Rep__ (
   warn_msg_      OUT VARCHAR2,
   emp_msg_       IN  VARCHAR2,
   company_       IN  VARCHAR2 )
IS
   language_        VARCHAR2(15)  := Language_SYS.Get_Language;
   m_s_names_       Message_SYS.name_table;
   m_s_values_      Message_SYS.line_table;
   emp_rec1_        Emp_Info_Table;
   tmp_emp_id_      company_emp_tab.employee_id%TYPE;
   count_           NUMBER;
   index_           NUMBER := 0;
   tmp_value_       VARCHAR2(5);
   stmt_            VARCHAR2(4000);
BEGIN
   $IF Component_Wo_SYS.INSTALLED $THEN
      Message_SYS.Get_Attributes(emp_msg_, count_, m_s_names_, m_s_values_);
      FOR dummy_ IN 1..count_ LOOP
         IF (m_s_names_(dummy_) = 'EMP_ID') THEN
            index_ := index_ + 1;
            emp_rec1_(index_).emp_id := m_s_values_(dummy_);
         ELSIF (m_s_names_(dummy_) = 'EXP_DATE') THEN
            emp_rec1_(index_).exp_date := Client_SYS.Attr_Value_To_Date(m_s_values_(dummy_));
         END IF;
      END LOOP;
      count_ := 0;
      stmt_ := Language_SYS.Translate_Constant(lu_name_, 'TIMEREPORTWARN1: The following employees among selection have already reported time for work order operations beyond new expiry date,',language_);
      FOR dummy_ IN 1..index_ LOOP
         tmp_value_ := Jt_Task_Transaction_API.Is_Reporting_Lines_Exist(company_, emp_rec1_(dummy_).emp_id, emp_rec1_(dummy_).exp_date); 
         IF (tmp_value_ = 'TRUE') THEN
            stmt_ := stmt_ || CHR(13) || emp_rec1_(dummy_).emp_id;
            tmp_emp_id_ := emp_rec1_(dummy_).emp_id;
            count_ := count_ + 1;
         END IF;
      END LOOP;
      IF (count_ = 0) THEN
         stmt_ := NULL;
      ELSE
         IF (count_ = 1) THEN
            stmt_ := Language_SYS.Translate_Constant(lu_name_, 'TIMEREPORTWARN2: Employee :P1 have already reported time for work order operations beyond new expiry date,',language_, tmp_emp_id_);
         END IF;
         stmt_ := stmt_ || CHR(13) || Language_SYS.Translate_Constant(lu_name_,'TIMEREPORTWARN3: Do you want to continue ?',language_);
      END IF;
      warn_msg_ := stmt_;
   $ELSE
      NULL;
   $END
END Check_Expire_Date_Time_Rep__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Name (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_     company_emp_tab%ROWTYPE;
   name_    VARCHAR2(100);
BEGIN
   rec_ := Get_Object_By_Keys___(company_, employee_id_);
   name_ := Person_Info_API.Get_Name(rec_.person_id);
   RETURN name_;
END Get_Name;


@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   name_                VARCHAR2(100);
   obj_description_     VARCHAR2(200);
   CURSOR get_obj_description IS
     SELECT company || ': ' || employee_id_ || '-' || name_ description
     FROM   company_emp_tab
     WHERE  company   = company_
     AND    employee_id = employee_id_;
BEGIN
   name_ := Get_Name(company_, employee_id_);
   OPEN get_obj_description;
   FETCH get_obj_description INTO obj_description_;
   IF (get_obj_description%NOTFOUND) THEN
      CLOSE get_obj_description;
      RETURN Language_SYS.Translate_Constant(lu_name_, 'NODOCDESC: No description available');
   END IF;
   CLOSE get_obj_description;
   RETURN obj_description_;
END Get_Doc_Object_Description;


@UncheckedAccess
FUNCTION Get_Max_Employee_Id (
   company_   IN VARCHAR2,
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   max_  VARCHAR2(20);
   CURSOR get_emp IS
      SELECT MAX(employee_id)
      FROM   company_emp_tab
      WHERE  company   = company_
      AND    person_id = person_id_
      AND    (TRUNC(expire_date) >= TRUNC(SYSDATE) OR expire_date IS NULL);
BEGIN
   OPEN get_emp;
   FETCH get_emp INTO max_;
   CLOSE get_emp;
   RETURN max_;
END Get_Max_Employee_Id;


PROCEDURE New (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2 )
IS
   newrec_  company_emp_tab%ROWTYPE;
BEGIN
   newrec_.company      := company_;
   newrec_.person_id    := person_id_;
   newrec_.employee_id  := employee_id_;
   New___(newrec_);
END New;


PROCEDURE Remove (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(100);
   remrec_      company_emp_tab%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(company_, employee_id_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


@UncheckedAccess
FUNCTION Get_Employee_Using_Person (
   company_   IN VARCHAR2,
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   all_emp_ VARCHAR2(2000);
   CURSOR get_emp IS
      SELECT employee_id
      FROM   company_emp
      WHERE  company   = company_
      AND    person_id = person_id_;
BEGIN
   FOR i IN get_emp LOOP
      IF (i.employee_id IS NOT NULL) THEN
         all_emp_ := all_emp_||CHR(13)||i.employee_id;
      END IF;
   END LOOP;
   RETURN all_emp_;
END Get_Employee_Using_Person;


PROCEDURE Create_H_R_Employee (
   newrec_     IN OUT company_emp_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000);
BEGIN
   attr_ := Pack___(newrec_);
   $IF Component_Person_SYS.INSTALLED $THEN
      Company_Person_API.Create_Employee(attr_);
   $ELSE
      NULL;
   $END
END Create_H_R_Employee;


PROCEDURE Check_If_Person_Is_Emp (
   company_   IN VARCHAR2,
   person_id_ IN VARCHAR2 )
IS
   CURSOR get_person IS
      SELECT 1
      FROM   company_emp_tab
      WHERE  company   = company_
      AND    person_id = person_id_;
   temp_  VARCHAR2(5);
BEGIN
   OPEN get_person;
   FETCH get_person INTO temp_;
   IF (get_person%FOUND) THEN
      Client_SYS.Add_Warning(lu_name_, 'PERSISEMP: An employee number already exists for person :P1', person_id_);
   END IF;
   CLOSE get_person;
END Check_If_Person_Is_Emp;


PROCEDURE Set_Person_Id (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2 )
IS
BEGIN
   UPDATE company_emp_tab
      SET person_id  = person_id_,
          rowversion = rowversion + 1
   WHERE company     = company_
   AND   employee_id = employee_id_;
END Set_Person_Id;


PROCEDURE Update_Expire_Date (
   company_       IN VARCHAR2,
   employee_id_   IN VARCHAR2,
   new_date_      IN DATE )
IS
   newrec_       company_emp_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(company_, employee_id_);
   newrec_.expire_date := TRUNC(new_date_);
   Modify___(newrec_);
END Update_Expire_Date;


FUNCTION Get_Next_Identity (
   company_ IN VARCHAR2 ) RETURN NUMBER
IS
   next_id_             NUMBER;
   party_type_db_       VARCHAR2(20) := 'EMPLOYEE';
BEGIN
   next_id_ := Party_Identity_Series_API.Get_Next_Value(Party_Type_API.Decode(party_type_db_));  
   IF (next_id_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'PERS_ERROR: Error while retrieving the next free identity. Check the identity series for employee.');      
   END IF;
   WHILE Check_Exist___(company_, next_id_) OR Company_Emp_API.Get_Expire_Date(company_, next_id_) < SYSDATE LOOP
      next_id_ := next_id_ + 1;
   END LOOP;
   Party_Identity_Series_API.Update_Next_Value(next_id_ + 1, party_type_db_);
   RETURN next_id_; 
END Get_Next_Identity;


-- Get_Control_Type_Value_Desc
--   Used from posting control
PROCEDURE Get_Control_Type_Value_Desc (
   desc_      OUT VARCHAR2,
   company_   IN  VARCHAR2,
   value_     IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Name(company_, value_);
END Get_Control_Type_Value_Desc;


PROCEDURE Check_Emp_Date_Exists (
   company_      IN VARCHAR2,
   employee_id_  IN VARCHAR2,
   account_date_ IN DATE )
IS
   rec_     company_emp_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(company_, employee_id_);
   IF NOT (TRUNC(rec_.expire_date) > TRUNC(account_date_) OR rec_.expire_date IS NULL) THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'EMPLOYEE: Employee :P1 does not exist', employee_id_);
   END IF;   
END Check_Emp_Date_Exists;


@UncheckedAccess
FUNCTION Check_Exist (
   company_     IN VARCHAR2,
   employee_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(company_, employee_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Check_Emp_By_Date (
   company_      IN VARCHAR2,
   employee_id_  IN VARCHAR2,
   account_date_ IN DATE ) RETURN BOOLEAN
IS
   rec_     company_emp_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(company_, employee_id_);
   IF NOT (TRUNC(rec_.expire_date) > TRUNC(account_date_) OR rec_.expire_date IS NULL) THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;    
END Check_Emp_By_Date;


-- This method is to be used by Aurena
FUNCTION Check_If_Employee_Exists (
   company_   IN VARCHAR2,
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_person IS
      SELECT 1
      FROM   company_emp_tab
      WHERE  company   = company_
      AND    person_id = person_id_;
   temp_  VARCHAR2(5);
BEGIN
   OPEN get_person;
   FETCH get_person INTO temp_;
   IF (get_person%FOUND) THEN
      CLOSE get_person;
      RETURN 'TRUE';
   END IF;
   CLOSE get_person;
   RETURN 'FALSE';
END Check_If_Employee_Exists;

