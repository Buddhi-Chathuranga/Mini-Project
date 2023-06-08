-----------------------------------------------------------------------------
--
--  Logical unit: CreateCompanyTem
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  010419  ovjose   Created.
--  010528  LaLi     Added log handling
--  010619  Gawilk   Fixed bug # 15677. Checked General_SYS.Init_Method.
--  010706  LiSv     Added creation_date and last_modification_date.
--  010816  LiSv     Added procedure Set_Last_Modification_Date.
--  020124  THSRLK   IID 20004 - Add PROCEDURE Get_Default_Template__ & Set_Default_Template__
--  020207  THSRLK   IID 20004 - Changes in Copy_Template__  & unpack methords
--  020208  ovjose   Changed calls from create_company_reg_api to crecomp_component_api
--  020606  ovjose   Bug #29566 corrected. Added Function Exist_Iso_Curr_In_Template__
--  030902  lalise   Modified for template diff handling
--  040324  mgutse   Merge of 2004-1 SP1.
--  040617  sachlk   FIPR338A2: Unicode Changes.
--  041214  KaGalk   LCS Merge 29607.
--  050801  ovjose   New authority concept for templates. Obsolete Method_type and Template_Type.
--  060810  lokrlk   FIPR704: Persian Calendar changes
--  061013  ChBalk   Added C41..C50 to EXPORT_COMPANY_TEMPLATE and Copy_Template__.
--  100226  ovjose   Added method Remove_Company_Templ_Comp__.
--  111201  Swralk   SFI-907, Removed General_SYS.Init method from FUNCTION Change_Template_Allowed.
--  120824  Kagalk   Bug 104803, Added Move_User_Def_Co_Templ_Comp__
--  121015  Kagalk   Bug 105774, Modified to register translatable attributes as system defined attributes
--  121023  Chwilk   Bug 106070, Added Transaction Statement Approved Annotation.
--  121115  Kagalk   Bug 106775, Modified correction for bug 105774.
--  130417  JuKoDE   EDEL-2130, Added C51..C70 to VIEW_ECT and Copy_Template__
--  130821  Chgulk   Bug 111221, Modified in Check_Template_Version___().
--  130821           Restructure the method to fix the identified problem after being executed the QA script
--  131015  Isuklk   CAHOOK-2732 Refactoring in CreateCompanyTem.entity
-----------------------------------------------------------------------------
                           
layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Public_Rec_Templ IS RECORD (
   template_id      VARCHAR2(30),
   description      VARCHAR2(100),
   template_type    VARCHAR2(20),
   method_type      VARCHAR2(20),
   valid            VARCHAR2(5),
   component        VARCHAR2(30),
   version          VARCHAR2(30),
   lu               VARCHAR2(30),
   item_id          NUMBER,
   created_by_user  VARCHAR2(30),
   c1               VARCHAR2(2000),
   c2               VARCHAR2(200),
   c3               VARCHAR2(200),
   c4               VARCHAR2(200),
   c5               VARCHAR2(2000),
   c6               VARCHAR2(200),
   c7               VARCHAR2(200),
   c8               VARCHAR2(200),
   c9               VARCHAR2(200),
   c10              VARCHAR2(200),
   c11              VARCHAR2(200),
   c12              VARCHAR2(200),
   c13              VARCHAR2(200),
   c14              VARCHAR2(200),
   c15              VARCHAR2(200),
   c16              VARCHAR2(200),
   c17              VARCHAR2(200),
   c18              VARCHAR2(200),
   c19              VARCHAR2(200),
   c20              VARCHAR2(200),
   c21              VARCHAR2(200),
   c22              VARCHAR2(200),
   c23              VARCHAR2(200),
   c24              VARCHAR2(200),
   c25              VARCHAR2(200),
   c26              VARCHAR2(200),
   c27              VARCHAR2(200),
   c28              VARCHAR2(200),
   c29              VARCHAR2(200),
   c30              VARCHAR2(200),
   c31              VARCHAR2(200),
   c32              VARCHAR2(200),
   c33              VARCHAR2(200),
   c34              VARCHAR2(200),
   c35              VARCHAR2(200),
   c36              VARCHAR2(200),
   c37              VARCHAR2(200),
   c38              VARCHAR2(200),
   c39              VARCHAR2(200),
   c40              VARCHAR2(200),
   c41              VARCHAR2(200),
   c42              VARCHAR2(200),
   c43              VARCHAR2(200),
   c44              VARCHAR2(200),
   c45              VARCHAR2(200),
   c46              VARCHAR2(200),
   c47              VARCHAR2(200),
   c48              VARCHAR2(200),
   c49              VARCHAR2(200),
   c50              VARCHAR2(200),
   c51              VARCHAR2(200),
   c52              VARCHAR2(200),
   c53              VARCHAR2(200),
   c54              VARCHAR2(200),
   c55              VARCHAR2(200),
   c56              VARCHAR2(200),
   c57              VARCHAR2(200),
   c58              VARCHAR2(200),
   c59              VARCHAR2(200),
   c60              VARCHAR2(200),
   c61              VARCHAR2(200),
   c62              VARCHAR2(200),
   c63              VARCHAR2(200),
   c64              VARCHAR2(200),
   c65              VARCHAR2(200),
   c66              VARCHAR2(200),
   c67              VARCHAR2(200),
   c68              VARCHAR2(200),
   c69              VARCHAR2(200),
   c70              VARCHAR2(200),
   ext_c1           VARCHAR2(200),
   ext_c2           VARCHAR2(200),
   ext_c3           VARCHAR2(200),
   ext_c4           VARCHAR2(200),
   ext_c5           VARCHAR2(200),
   ext_c6           VARCHAR2(200),
   ext_c7           VARCHAR2(200),
   ext_c8           VARCHAR2(200),
   ext_c9           VARCHAR2(200),
   ext_c10          VARCHAR2(200),
   ext_c11          VARCHAR2(200),
   ext_c12          VARCHAR2(200),
   ext_c13          VARCHAR2(200),
   ext_c14          VARCHAR2(200),
   ext_c15          VARCHAR2(200),
   ext_c16          VARCHAR2(200),
   ext_c17          VARCHAR2(200),
   ext_c18          VARCHAR2(200),
   ext_c19          VARCHAR2(200),
   ext_c20          VARCHAR2(200),
   ext_c21          VARCHAR2(200),
   ext_c22          VARCHAR2(200),
   ext_c23          VARCHAR2(200),
   ext_c24          VARCHAR2(200),
   ext_c25          VARCHAR2(200),
   ext_c26          VARCHAR2(200),
   ext_c27          VARCHAR2(200),
   ext_c28          VARCHAR2(200),
   ext_c29          VARCHAR2(200),
   ext_c30          VARCHAR2(200),   
   n1               NUMBER,
   n2               NUMBER,
   n3               NUMBER,
   n4               NUMBER,
   n5               NUMBER,
   n6               NUMBER,
   n7               NUMBER,
   n8               NUMBER,
   n9               NUMBER,
   n10              NUMBER,
   n11              NUMBER,
   n12              NUMBER,
   n13              NUMBER,
   n14              NUMBER,
   n15              NUMBER,
   n16              NUMBER,
   n17              NUMBER,
   n18              NUMBER,
   n19              NUMBER,
   n20              NUMBER,
   ext_n1           NUMBER,
   ext_n2           NUMBER,
   ext_n3           NUMBER,
   ext_n4           NUMBER,
   ext_n5           NUMBER,
   ext_n6           NUMBER,
   ext_n7           NUMBER,
   ext_n8           NUMBER,
   ext_n9           NUMBER,
   ext_n10          NUMBER,
   ext_n11          NUMBER,
   ext_n12          NUMBER,
   ext_n13          NUMBER,
   ext_n14          NUMBER,
   ext_n15          NUMBER,
   ext_n16          NUMBER,
   ext_n17          NUMBER,
   ext_n18          NUMBER,
   ext_n19          NUMBER,
   ext_n20          NUMBER,   
   d1               DATE,
   d2               DATE,
   d3               DATE,
   d4               DATE,
   d5               DATE,
   ext_d1           DATE,
   ext_d2           DATE,
   ext_d3           DATE,
   ext_d4           DATE,
   ext_d5           DATE,   
   rowversion       DATE,
   objkey           VARCHAR2(50) );
                     
-------------------- PRIVATE DECLARATIONS -----------------------------------
                     
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Template_Version___ (
   in_version_       IN VARCHAR2,
   existing_version_ IN VARCHAR2) RETURN BOOLEAN
IS
   TYPE TEMPL_VERSION IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;   
   ptr_              NUMBER;
   value_            VARCHAR2(2000);
   i_                NUMBER := 1;
   in_ver_           TEMPL_VERSION;
   ex_ver_           TEMPL_VERSION;
   result_           BOOLEAN := FALSE;
BEGIN
   IF (existing_version_ IS NULL) THEN
      RETURN TRUE;
   END IF;
   WHILE Get_Next_From_Attr___(in_version_, ptr_, value_, '.') LOOP
      in_ver_(i_) := TO_NUMBER(value_);
      i_ := i_ + 1;
   END LOOP;
   ptr_ := NULL;
   i_ := 1;
   WHILE Get_Next_From_Attr___(existing_version_, ptr_, value_, '.') LOOP
      ex_ver_(i_) := TO_NUMBER(value_);
      i_ := i_ + 1;
   END LOOP;
   i_ := 1;
   WHILE TRUE LOOP
      IF (ex_ver_.EXISTS(i_) AND in_ver_.EXISTS(i_) ) THEN
         IF (in_ver_(i_) > ex_ver_(i_)) THEN
            result_ := TRUE;
            EXIT;
         ELSIF (in_ver_(i_) < ex_ver_(i_)) THEN
            result_ := FALSE;
            EXIT;
         END IF;
      ELSIF (ex_ver_.EXISTS(i_) AND NOT in_ver_.EXISTS(i_)) THEN
         result_ := FALSE;
         EXIT;
      ELSE
         result_ := TRUE;
         EXIT;
      END IF;
      i_ := i_ + 1;
   END LOOP;
   RETURN result_;
END Check_Template_Version___;


FUNCTION Get_Next_From_Attr___ (
   attr_             IN     VARCHAR2,
   ptr_              IN OUT NUMBER,
   value_            IN OUT VARCHAR2,
   record_separator_ IN     VARCHAR2 ) RETURN BOOLEAN
IS
   from_  NUMBER;
   to_    NUMBER;
   index_ NUMBER;
BEGIN
   from_ := NVL(ptr_, 1);
   to_   := INSTR(attr_, record_separator_, from_);
   IF (to_ > 0) THEN
      index_ := INSTR(attr_, record_separator_, from_);
      value_ := SUBSTR(attr_, from_, index_-from_);
      ptr_   := to_+1;
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Next_From_Attr___;


PROCEDURE Delete_Child_Lu_Data___ (
   template_id_      IN VARCHAR2,
   component_        IN VARCHAR2)
IS
BEGIN
   DELETE FROM create_company_tem_detail_tab
   WHERE template_id = template_id_
   AND component = component_;

   DELETE FROM create_company_tem_lu_tab
   WHERE template_id = template_id_
   AND component = component_;

   DELETE FROM create_company_tem_comp_tab
   WHERE template_id = template_id_
   AND component = component_;
END;


FUNCTION Is_System_Template___ (
   template_id_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_   PLS_INTEGER;
   CURSOR is_system_template IS
      SELECT 1 
      FROM   system_company_template_tab
      WHERE  template_id = template_id_;
BEGIN
   OPEN is_system_template;
   FETCH is_system_template INTO dummy_;
   IF (is_system_template%FOUND) THEN
      CLOSE is_system_template;
      RETURN TRUE;
   ELSE
      CLOSE is_system_template;
      RETURN FALSE;
   END IF;
END Is_System_Template___;


FUNCTION Get_Temporary_Id___ RETURN VARCHAR2
IS
   temp_id_  VARCHAR2(30);
   CURSOR get_next_id IS
   SELECT TO_CHAR(company_template_temp_seq.NEXTVAL)
   FROM  DUAL;
BEGIN
   OPEN  get_next_id;
   FETCH get_next_id INTO temp_id_;
   CLOSE get_next_id;
   IF (Check_Exist___(temp_id_)) THEN
      RETURN Get_Temporary_Id___;
   END IF;
   RETURN temp_id_;
END Get_Temporary_Id___;


PROCEDURE Move_Child_Lu_Data___ (
   template_id_      IN VARCHAR2,
   old_component_    IN VARCHAR2, 
   new_component_    IN VARCHAR2 )
IS
BEGIN   
   UPDATE create_company_tem_detail_tab
      SET component     = new_component_
      WHERE template_id = template_id_
      AND component     = old_component_;
   UPDATE create_company_tem_lu_tab
      SET component     = new_component_
      WHERE template_id = template_id_
      AND component     = old_component_; 
   UPDATE create_company_tem_comp_tab
      SET   component   = new_component_
      WHERE template_id = template_id_
      AND   component   = old_component_;
END Move_Child_Lu_Data___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     create_company_tem_tab%ROWTYPE,
   newrec_ IN OUT create_company_tem_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   Fnd_User_API.Exist(newrec_.created_by_user);
END Check_Common___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT create_company_tem_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF (Is_System_Template___(newrec_.template_id)) THEN
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP', lu_name_, newrec_.template_id, newrec_.description);
   ELSE
      Basic_Data_Translation_API.Insert_Basic_Data_Translation('ENTERP', lu_name_, newrec_.template_id, NULL, newrec_.description);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     create_company_tem_tab%ROWTYPE,
   newrec_     IN OUT create_company_tem_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN   
   newrec_.last_modification_date := SYSDATE;
   Client_SYS.Add_To_Attr('LAST_MODIFICATION_DATE',  newrec_.last_modification_date, attr_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (Is_System_Template___(newrec_.template_id)) THEN
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP', lu_name_, newrec_.template_id, newrec_.description);
   ELSE
      Basic_Data_Translation_API.Insert_Basic_Data_Translation('ENTERP', lu_name_, newrec_.template_id, NULL, newrec_.description);
   END IF;
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN create_company_tem_tab%ROWTYPE )
IS   
BEGIN   
   IF (Change_Template_Allowed(remrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'REMNOTALLOWED: Not allowed to remove a template created by another user. '||
                               'Only a company template super user is allowed to remove other users templates');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN create_company_tem_tab%ROWTYPE )
IS   
BEGIN
   DELETE
      FROM key_lu_translation_tab
      WHERE key_name  = 'TemplKeyLu'
      AND   key_value = remrec_.template_id;
   -- remove from the imp-table as well.
   DELETE
      FROM key_lu_translation_imp_tab
      WHERE key_name  = 'TemplKeyLu'
      AND   key_value = remrec_.template_id;
   DELETE
      FROM key_lu_tab
      WHERE key_name  = 'TemplKeyLu'
      AND   key_value = remrec_.template_id;
   DELETE
      FROM key_master_tab
      WHERE key_name  = 'TemplKeyLu'
      AND   key_value = remrec_.template_id;
   DELETE
      FROM create_company_tem_detail_tab
      WHERE template_id = remrec_.template_id;
   DELETE
      FROM create_company_tem_lu_tab
      WHERE template_id = remrec_.template_id;
   DELETE
      FROM create_company_tem_comp_tab
      WHERE template_id = remrec_.template_id;
   DELETE
      FROM  create_company_tem_tab
      WHERE ROWID = objid_;   
   Basic_Data_Translation_API.Remove_Basic_Data_Translation('ENTERP', lu_name_, remrec_.template_id);
   super(objid_, remrec_);
END Delete___;


FUNCTION Is_Job_Posted___ (
   template_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   msg_              VARCHAR2(32000);
   attrib_value_     VARCHAR2(32000);
   value_            VARCHAR2(2000);
   deferred_call_    VARCHAR2(200):= 'CREATE_COMPANY_TEM_API'||'.Modify_Installed_Templ_Head__';
   name_             VARCHAR2(30);
   job_id_tab_       Message_SYS.Name_Table;
   attrib_tab_       Message_SYS.Line_Table;
   job_template_id_  VARCHAR2(30);
   count_            NUMBER;
   ptr_              NUMBER;
BEGIN
   Transaction_SYS.Get_Posted_Job_Arguments(msg_, deferred_call_);
   Message_SYS.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);
   FOR i_ IN 1..count_ LOOP
      attrib_value_   := attrib_tab_(i_);
      ptr_ := NULL;
      -- Loop through the parameter list to check whether template_id exists
      WHILE (Client_SYS.Get_Next_From_Attr(attrib_value_, ptr_, name_, value_)) LOOP
         IF (name_ = 'TEMPLATE_ID') THEN
            job_template_id_ := value_;
            IF (job_template_id_ = template_id_) THEN
               -- Job already posted for the template_id, Return TRUE
               RETURN TRUE;
            END IF;
         END IF;
      END LOOP;
   END LOOP;
   -- No job_id found posted for the template_id, Return FALSE
   RETURN FALSE;
END Is_Job_Posted___;


PROCEDURE Post_Job___ (
   attr_       IN VARCHAR2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   Transaction_SYS.Deferred_Call('CREATE_COMPANY_TEM_API'||'.Modify_Installed_Templ_Head__', 'ATTRIBUTE', attr_, 'Modify Installed Company Template Head Attributes');
   @ApproveTransactionStatement(2012-10-23,chwilk)
   COMMIT;
END Post_Job___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT create_company_tem_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);   
   Create_Company_API.Exist_Wildcard(newrec_.template_id);   
   Create_Company_API.Exist_Illegal_Character(newrec_.template_id);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     create_company_tem_tab%ROWTYPE,
   newrec_ IN OUT create_company_tem_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   IF (Change_Template_Allowed(newrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'UPDNOTALLOWED: Not allowed to update a template created by another user. '||
                               'Only a company template super user is allowed to change other users templates');
   END IF;   
   super(oldrec_, newrec_, indrec_, attr_);   
END Check_Update___;
 
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_Template__ (
   template_id_     IN VARCHAR2,
   template_id_new_ IN VARCHAR2,
   description_new_ IN VARCHAR2 )
IS
   user_id_      VARCHAR2(30);
   allowed_      BOOLEAN := FALSE;
BEGIN
   Create_Company_Tem_API.Exist(template_id_);
   IF (Check_Exist___(template_id_new_)) THEN
      Error_SYS.Record_Exist(lu_name_);
   END IF;
   IF Is_System_Template___(template_id_new_) THEN
      user_id_ := Fnd_Session_API.Get_App_Owner;
      IF (Change_Template_Allowed(template_id_new_) = 'TRUE') THEN 
         allowed_ := TRUE;
      ELSE
         allowed_ := FALSE;
      END IF;
   ELSE
      allowed_ := TRUE;
      user_id_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   IF NOT (allowed_) THEN
      Error_SYS.Record_General(lu_name_, 'COPYNOTALLOWED: The New Template Id is a reserved Id. '||
                               'Only a company template super user or application owner is allowed to use '||
                               'reserved Template Ids');
   END IF;
   IF (template_id_ = template_id_new_) THEN
      Error_SYS.Record_General(lu_name_, 'COPYEXIST: Template Id :P1 aldready exist.', template_id_new_);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', template_id_);
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID_NEW', template_id_new_);
   Create_Company_API.Exist_Wildcard(template_id_new_);   
   Create_Company_API.Exist_Illegal_Character(template_id_new_);
   INSERT INTO create_company_tem_tab
       (  template_id,
          description,
          default_template,
          valid,
          creation_date,
          created_by_user,
          rowversion)
   SELECT template_id_new_,
          description_new_,
          'FALSE',
          valid,
          SYSDATE,
          user_id_,
          SYSDATE
   FROM create_company_tem_tab
   WHERE template_id = template_id_;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('ENTERP', lu_name_, template_id_new_, NULL, description_new_);
   INSERT INTO create_company_tem_comp_tab
       (  template_id,
          component,
          version,
          rowversion)
   SELECT template_id_new_,
          component,
          version,
          SYSDATE
   FROM create_company_tem_comp_tab
   WHERE template_id = template_id_;
   INSERT INTO create_company_tem_lu_tab
       (  template_id,
          component,
          lu,
          rowversion)
   SELECT template_id_new_,
          component,
          lu,
          SYSDATE
   FROM create_company_tem_lu_tab
   WHERE template_id = template_id_;
   INSERT INTO create_company_tem_detail_tab
       (  template_id,
          component,
          lu,
          item_id,
          c1,
          c2,
          c3,
          c4,
          c5,
          c6,
          c7,
          c8,
          c9,
          c10,
          c11,
          c12,
          c13,
          c14,
          c15,
          c16,
          c17,
          c18,
          c19,
          c20,
          c21,
          c22,
          c23,
          c24,
          c25,
          c26,
          c27,
          c28,
          c29,
          c30,
          c31,
          c32,
          c33,
          c34,
          c35,
          c36,
          c37,
          c38,
          c39,
          c40,
          c41,
          c42,
          c43,
          c44,
          c45,
          c46,
          c47,
          c48,
          c49,
          c50,
          c51,
          c52,
          c53,
          c54,
          c55,
          c56,
          c57,
          c58,
          c59,
          c60,
          c61,
          c62,
          c63,
          c64,
          c65,
          c66,
          c67,
          c68,
          c69,
          c70,
          ext_c1,
          ext_c2,
          ext_c3,
          ext_c4,
          ext_c5,
          ext_c6,
          ext_c7,
          ext_c8,
          ext_c9,
          ext_c10,
          ext_c11,
          ext_c12,
          ext_c13,
          ext_c14,
          ext_c15,
          ext_c16,
          ext_c17,
          ext_c18,
          ext_c19,
          ext_c20,
          ext_c21,
          ext_c22,
          ext_c23,
          ext_c24,
          ext_c25,
          ext_c26,
          ext_c27,
          ext_c28,
          ext_c29,
          ext_c30,          
          n1,
          n2,
          n3,
          n4,
          n5,
          n6,
          n7,
          n8,
          n9,
          n10,
          n11,
          n12,
          n13,
          n14,
          n15,
          n16,
          n17,
          n18,
          n19,
          n20,
          ext_n1,
          ext_n2,
          ext_n3,
          ext_n4,
          ext_n5,
          ext_n6,
          ext_n7,
          ext_n8,
          ext_n9,
          ext_n10,
          ext_n11,
          ext_n12,
          ext_n13,
          ext_n14,
          ext_n15,
          ext_n16,
          ext_n17,
          ext_n18,
          ext_n19,
          ext_n20,          
          d1,
          d2,
          d3,
          d4,
          d5,
          ext_d1,
          ext_d2,
          ext_d3,
          ext_d4,
          ext_d5,          
          selected,
          rowversion)
   SELECT template_id_new_,
          component,
          lu,
          item_id,
          c1,
          c2,
          c3,
          c4,
          c5,
          c6,
          c7,
          c8,
          c9,
          c10,
          c11,
          c12,
          c13,
          c14,
          c15,
          c16,
          c17,
          c18,
          c19,
          c20,
          c21,
          c22,
          c23,
          c24,
          c25,
          c26,
          c27,
          c28,
          c29,
          c30,
          c31,
          c32,
          c33,
          c34,
          c35,
          c36,
          c37,
          c38,
          c39,
          c40,
          c41,
          c42,
          c43,
          c44,
          c45,
          c46,
          c47,
          c48,
          c49,
          c50,
          c51,
          c52,
          c53,
          c54,
          c55,
          c56,
          c57,
          c58,
          c59,
          c60,
          c61,
          c62,
          c63,
          c64,
          c65,
          c66,
          c67,
          c68,
          c69,
          c70,
          ext_c1,
          ext_c2,
          ext_c3,
          ext_c4,
          ext_c5,
          ext_c6,
          ext_c7,
          ext_c8,
          ext_c9,
          ext_c10,
          ext_c11,
          ext_c12,
          ext_c13,
          ext_c14,
          ext_c15,
          ext_c16,
          ext_c17,
          ext_c18,
          ext_c19,
          ext_c20,
          ext_c21,
          ext_c22,
          ext_c23,
          ext_c24,
          ext_c25,
          ext_c26,
          ext_c27,
          ext_c28,
          ext_c29,
          ext_c30,          
          n1,
          n2,
          n3,
          n4,
          n5,
          n6,
          n7,
          n8,
          n9,
          n10,
          n11,
          n12,
          n13,
          n14,
          n15,
          n16,
          n17,
          n18,
          n19,
          n20,
          ext_n1,
          ext_n2,
          ext_n3,
          ext_n4,
          ext_n5,
          ext_n6,
          ext_n7,
          ext_n8,
          ext_n9,
          ext_n10,
          ext_n11,
          ext_n12,
          ext_n13,
          ext_n14,
          ext_n15,
          ext_n16,
          ext_n17,
          ext_n18,
          ext_n19,
          ext_n20,          
          d1,
          d2,
          d3,
          d4,
          d5,
          ext_d1,
          ext_d2,
          ext_d3,
          ext_d4,
          ext_d5,          
          selected,
          SYSDATE
   FROM create_company_tem_detail_tab
   WHERE template_id = template_id_;
   Enterp_Comp_Connect_V170_API.Insert_Key_Master__('TemplKeyLu', template_id_new_);
   Enterp_Comp_Connect_V170_API.Copy_Templ_Translations(template_id_, template_id_new_);
END Copy_Template__;


PROCEDURE Rename_Template__ (
   template_id_     IN VARCHAR2,
   template_id_new_ IN VARCHAR2 )
IS
   newrec_       create_company_tem_tab%ROWTYPE;
   description_  create_company_tem_tab.description%TYPE;
   allowed_      BOOLEAN := FALSE;
   allowed_new_  BOOLEAN := FALSE;
BEGIN
   IF (Change_Template_Allowed(template_id_) = 'TRUE') THEN 
      allowed_ := TRUE;
      IF (Is_System_Template___(template_id_new_)) THEN
         IF (Change_Template_Allowed(template_id_new_) = 'TRUE') THEN 
            allowed_new_ := TRUE;
         ELSE
            allowed_new_ := FALSE;
         END IF;
      ELSE
         allowed_new_ := TRUE;
      END IF;
   ELSE
      allowed_ := FALSE;
   END IF;
   IF NOT (allowed_) THEN
      Error_SYS.Record_General(lu_name_, 'RENOTALLOWED: Not allowed to rename a template created by another user. '||
                               'Only a template super user is allowed to change other users templates');
   END IF;
   IF NOT (allowed_new_) THEN
      Error_SYS.Record_General(lu_name_, 'NEWNOTALLOWED: Not allowed to rename a template to :P1. Template Id :P1 is '||
                               'a reserved system template Id. '||
                               'Only a template super user and application owner is allowed to use system templates Ids',
                               template_id_new_);
   END IF;
   Create_Company_Tem_API.Exist(template_id_);
   newrec_ := Get_Object_By_Keys___(template_id_);
   IF (Check_Exist___(template_id_new_)) THEN
      Error_SYS.Record_Exist(lu_name_);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', template_id_);
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID_NEW', template_id_new_);
   Create_Company_API.Exist_Wildcard(template_id_new_);   
   Create_Company_API.Exist_Illegal_Character(template_id_new_);
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('ENTERP', lu_name_, template_id_ ),1,100);   
   IF (description_ IS NULL) THEN
      description_ := SUBSTR(Basic_Data_Translation_API.Get_Prog_Text__('ENTERP', lu_name_, template_id_ ),1,100);
   END IF;
   UPDATE create_company_tem_tab
   SET    template_id = template_id_new_,
          description = description_,
          last_modification_date = SYSDATE
   WHERE  template_id = template_id_;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('ENTERP', lu_name_, template_id_new_, NULL, description_);
   Basic_Data_Translation_API.Remove_Basic_Data_Translation('ENTERP', lu_name_, template_id_);
   UPDATE create_company_tem_comp_tab
   SET    template_id = template_id_new_
   WHERE  template_id = template_id_;
   UPDATE create_company_tem_lu_tab
   SET    template_id = template_id_new_
   WHERE  template_id = template_id_;
   UPDATE create_company_tem_detail_tab
   SET    template_id = template_id_new_
   WHERE  template_id = template_id_;
   Enterp_Comp_Connect_V170_API.Rename_Templ_Translation(template_id_, template_id_new_);
END Rename_Template__;


PROCEDURE Set_Standard_Template__ (
   template_id_ IN VARCHAR2 )
IS
BEGIN
   Trace_SYS.Message('Method ' || 'CREATE_COMPANY_TEM_API' || '.Set_Standard_Template__ is obsolete');
END Set_Standard_Template__;


PROCEDURE Set_Userdefined_Template__ (
   template_id_ IN VARCHAR2 )
IS
BEGIN
   Trace_SYS.Message('Method ' || 'CREATE_COMPANY_TEM_API' || '.Set_Userdefined_Template__ is obsolete');
END Set_Userdefined_Template__;


PROCEDURE Set_Invalid_Templates__ (
   version_    IN VARCHAR2,
   component_  IN VARCHAR2 )
IS
   CURSOR find_dif_version IS
      SELECT   template_id
      FROM     create_company_tem_comp
      WHERE    version != version_
      AND      component = component_
      GROUP BY template_id;
BEGIN
   FOR i_ IN find_dif_version LOOP
      UPDATE   create_company_tem_tab
      SET      valid = 'FALSE'
      WHERE    template_id = i_.template_id;
   END LOOP;
END Set_Invalid_Templates__;


PROCEDURE Get_Default_Template__ ( 
   template_id_ IN OUT VARCHAR2 )
IS
   CURSOR get_attr IS
      SELECT template_id
      FROM   create_company_tem_tab
      WHERE  default_template = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO template_id_;
   CLOSE get_attr;
END Get_Default_Template__;


PROCEDURE Set_Default_Template__ (
   template_id_ IN VARCHAR2 )
IS
   objid_        create_company_tem.objid%TYPE;
   objversion_   create_company_tem.objversion%TYPE;
   attr_         VARCHAR2(100);
   oldrec_       create_company_tem_tab%ROWTYPE;
   newrec_       create_company_tem_tab%ROWTYPE;
   old_default_  create_company_tem.template_id%TYPE;
BEGIN
   --Since there can be only one default company at a time we have to check
   --wether there is a Default Template already exists.
   --If there is default template first we have to make remove it.
   Get_Default_Template__(old_default_); 
   IF (old_default_ IS NOT NULL) THEN
      Get_Id_Version_By_Keys___ ( objid_,objversion_,old_default_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      newrec_.default_template := 'FALSE';
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   --This part will make our Template as the Default
   Get_Id_Version_By_Keys___ (objid_,objversion_,template_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.default_template := 'TRUE';
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Default_Template__;


FUNCTION Exist_Curr_Code_In_Template__ (
   template_id_   IN VARCHAR2,
   currency_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_curr_code IS
      SELECT 1
      FROM   create_company_tem_detail_tab
      WHERE  template_id = template_id_
      AND    component = 'ACCRUL'
      AND    lu = 'CurrencyCode'
      AND    c1 = currency_code_;
   dummy_ NUMBER;      
BEGIN
   OPEN get_curr_code;
   FETCH get_curr_code INTO dummy_;
   IF (get_curr_code%FOUND) THEN
      CLOSE get_curr_code;
      RETURN 'TRUE';
   ELSE
      CLOSE get_curr_code;
      RETURN 'FALSE';      
   END IF;
END Exist_Curr_Code_In_Template__;   


FUNCTION Exist_Iso_Curr_In_Template__ (
   template_id_   IN VARCHAR2,
   currency_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_active_curr_code IS
      SELECT *
      FROM   create_company_tem_detail_tab
      WHERE  template_id = template_id_
      AND    component = 'ENTERP'
      AND    lu = 'CreateCompany';
   index_            NUMBER;
   active_curr_code_ VARCHAR2(3);
   temp_             VARCHAR2(2000);
   found_curr_code_  BOOLEAN := FALSE;
   pkg_              VARCHAR2(30);
BEGIN
   FOR rec_ IN get_active_curr_code LOOP
      index_ := INSTR(rec_.c1, '''');
      temp_ := SUBSTR(rec_.c1, index_ +1, LENGTH(rec_.c1));
      index_ := INSTR(temp_, '''');
      active_curr_code_ := SUBSTR(SUBSTR(temp_, 1, index_ -1),1,3);      
      index_ := INSTR(rec_.c1, '.');
      pkg_ := UPPER(SUBSTR(rec_.c1, 1, index_ -1));      
      IF (pkg_ = 'ISO_CURRENCY_API') THEN
         IF (active_curr_code_ = currency_code_) THEN
            found_curr_code_ := TRUE;
         END IF;
      END IF;
   END LOOP;
   IF (found_curr_code_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';      
   END IF;
END Exist_Iso_Curr_In_Template__;   


PROCEDURE Remove_Template__ (
   template_id_  IN VARCHAR2,
   check_        IN BOOLEAN )
IS
   objid_            create_company_tem.objid%TYPE;
   objversion_       create_company_tem.objversion%TYPE;   
   remrec_           create_company_tem_tab%ROWTYPE;
BEGIN
   IF (Change_Template_Allowed(template_id_) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'REMNOTALLOWED: Not allowed to remove a template created by another user. '||
                               'Only a company template super user is allowed to remove other users templates');
   END IF;
   Get_Id_Version_By_Keys___(objid_, objversion_, template_id_);
   remrec_ := Get_Object_By_Id___(objid_);
   IF (check_) THEN
      Check_Delete___(remrec_);   
   END IF;
   Delete___(objid_, remrec_);
END Remove_Template__;


FUNCTION Get_Temporary_Id__ RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Temporary_Id___;
END Get_Temporary_Id__;


PROCEDURE Modify_Installed_Templ_Head__ (
   attr_             IN VARCHAR2)
IS
   template_id_      create_company_tem_tab.template_id%TYPE;
   lock_rec_         create_company_tem_tab%ROWTYPE;
   newrec_           create_company_tem_tab%ROWTYPE;
   new_attr_         VARCHAR2(2000);
   objid_            create_company_tem.objid%TYPE;
   objversion_       create_company_tem.objversion%TYPE;
   ptr_              NUMBER;
   name_             VARCHAR2(30);
   value_            VARCHAR2(2000);
   indrec_           Indicator_Rec;
BEGIN
   template_id_ := Client_SYS.Get_Item_Value('TEMPLATE_ID', attr_);
   IF (template_id_ IS NOT NULL) THEN
      IF (Change_Template_Allowed(template_id_) = 'TRUE') THEN
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
            IF (name_ = 'TEMPLATE_ID') THEN
               NULL;
            ELSE
               Client_SYS.Add_To_Attr(name_, value_, new_attr_);
            END IF;
         END LOOP;
         lock_rec_ := Lock_By_Keys___(template_id_);
         newrec_ := lock_rec_;
         Unpack___(newrec_, indrec_, new_attr_);
         Check_Update___(lock_rec_, newrec_, indrec_, new_attr_);
         Update___(objid_, lock_rec_, newrec_, new_attr_, objversion_, TRUE);         
      END IF;
   END IF;
END Modify_Installed_Templ_Head__;


PROCEDURE Remove_Company_Templ_Comp__ (
   template_id_   VARCHAR2,
   component_     VARCHAR2 )
IS
BEGIN
   -- Check if the user allowed to remove the template
   User_Allowed_To_Modify(template_id_);
   -- Delete all data on the component level and below
   Delete_Child_Lu_Data___(template_id_, component_);
   -- Delete PROG translation for the template.
   Templ_Key_Lu_API.Remove_Templ_Key_Lu__(template_id_, component_);
END Remove_Company_Templ_Comp__;


PROCEDURE Move_User_Def_Co_Templ_Comp__ (
   template_id_     VARCHAR2,
   old_component_   VARCHAR2,
   new_component_   VARCHAR2 )
IS 
BEGIN
   -- Move all data on the component level and below to a new component
   Move_Child_Lu_Data___(template_id_, old_component_, new_component_);
END Move_User_Def_Co_Templ_Comp__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE User_Allowed_To_Modify (
   template_id_      IN VARCHAR2,
   created_by_user_  IN VARCHAR2 DEFAULT NULL )
IS
   fnd_user_      VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User();
BEGIN
   IF (Change_Template_Allowed(template_id_) != 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'USERNOTAUTH: User :P1 Is not allowed to modify/remove company '||
                             'template :P2.',
                             fnd_user_,
                             template_id_);
   END IF;
END User_Allowed_To_Modify;


PROCEDURE Insert_Data (
   public_rec_ IN Public_Rec_Templ,
   interface_  IN NUMBER DEFAULT 170 )
IS
   objid_               create_company_tem.objid%TYPE;
   objversion_          create_company_tem.objversion%TYPE;
   attr_                VARCHAR2(2000);
   newrec_              create_company_tem_tab%ROWTYPE;
   oldrec_              create_company_tem_tab%ROWTYPE;
   empty_rec_           create_company_tem_tab%ROWTYPE;
   error_text_          VARCHAR2(2000);
   temp_template_id_    VARCHAR2(30);
   version_             VARCHAR2(50);
   existing_version_    VARCHAR2(50);
   newer_version_       BOOLEAN := FALSE;
   fnd_user_            VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User();
   app_owner_           VARCHAR2(30) := Fnd_Session_API.Get_App_Owner();
   is_system_template_  BOOLEAN := FALSE;
   new_template_id_     create_company_tem_tab.template_id%TYPE;
   description_         create_company_tem_tab.description%TYPE;
   raise_error_         BOOLEAN := FALSE;
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', public_rec_.template_id);
   Create_Company_API.Exist_Wildcard(public_rec_.template_id);   
   Create_Company_API.Exist_Illegal_Character(public_rec_.template_id);   
   newrec_.template_id     := public_rec_.template_id;
   newrec_.description     := public_rec_.description;
   newrec_.valid           := public_rec_.valid;
   newrec_.creation_date   := SYSDATE;
   is_system_template_ := Is_System_Template___(newrec_.template_id);
   -- A system template is always owned by the application owner, although that an company template super user
   -- might be installing the template.
   IF (is_system_template_) THEN
      newrec_.created_by_user := Fnd_Session_API.Get_App_Owner;
   ELSE
      newrec_.created_by_user := Fnd_Session_API.Get_Fnd_User;
   END IF;
   oldrec_ := Get_Object_By_Keys___(newrec_.template_id);
   IF (is_system_template_) THEN
      IF (oldrec_.template_id IS NOT NULL) THEN
         IF (fnd_user_ = app_owner_) AND (oldrec_.created_by_user != app_owner_) THEN
            -- IF the user is the appowner and the template exist check if the template is created by appowner
            -- IF not created by the appowner then rename the template since the template could be a template
            -- that haven't been a system template before and in a new release the template id is used by the
            -- system and therefore in order to not overwrite then end users template we rename it. It will be
            -- renamed according to a sequence number and the description will be set to "Renamed from "<old
            -- template_id> concatenated with <old description>.
            new_template_id_ := Get_Temporary_Id___();
            Rename_Template__(newrec_.template_id, new_template_id_);
            description_  := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'RENAMEDFROM: Renamed from ":P1" :P2', NULL, newrec_.template_id, oldrec_.description),1,100); 
            UPDATE create_company_tem_tab
               SET description = description_
               WHERE template_id = new_template_id_;
            IF (Is_System_Template___(new_template_id_)) THEN
               Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP', lu_name_, new_template_id_, description_);   
            ELSE
               Basic_Data_Translation_API.Insert_Basic_Data_Translation('ENTERP', lu_name_, new_template_id_, NULL, description_);
            END IF;
            oldrec_ := empty_rec_;
         END IF;
      END IF;
   END IF;
   version_ := public_rec_.version;
   existing_version_ := Create_Company_Tem_Comp_API.Get_Version(public_rec_.template_id, public_rec_.component);
   newer_version_ := Check_Template_Version___(version_, existing_version_);
   IF (NOT newer_version_) THEN
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_API.Older_Version_Templ_', public_rec_.template_id);     
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_API.Older_Version_Comp_', public_rec_.component);            
      Error_SYS.Record_General(lu_name_, 'OLDERVERSION: The component version of the template is older than an existing version of the template :P1 component :P2 ', public_rec_.template_id, public_rec_.component);   
   END IF;
   IF (oldrec_.template_id IS NULL) THEN
      IF (is_system_template_) THEN
         IF NOT (Create_Company_API.Is_Template_Super_User = 'TRUE') THEN
            IF (app_owner_ != fnd_user_) THEN
               Error_SYS.Record_General(lu_name_, 'IMPNOTALLOWED: User :P1 is not allowed to import a system company template', fnd_user_);   
            END IF;
         END IF;
      END IF;
      Get_Default_Template__(temp_template_id_);
      IF (temp_template_id_ IS NULL) THEN
         newrec_.default_template := 'TRUE';
      ELSE
         newrec_.default_template := 'FALSE';         
      END IF;      
      New___(newrec_);
      -- register the template in Key_Master
      Enterp_Comp_Connect_V170_API.Insert_Key_Master__('TemplKeyLu', newrec_.template_id);
      Create_Company_Tem_Comp_API.Insert_Data__(public_rec_);
   ELSE
      IF (is_system_template_) THEN
         IF NOT (Create_Company_API.Is_Template_Super_User = 'TRUE') THEN
            IF (app_owner_ != fnd_user_) THEN
               Error_SYS.Record_General(lu_name_, 'IMPNOTALLOWED: User :P1 is not allowed to import a system company template', fnd_user_);
            END IF;
         END IF;
      ELSE
         IF (oldrec_.created_by_user != fnd_user_) THEN
            IF NOT (Create_Company_API.Is_Template_Super_User = 'TRUE') THEN
               Error_SYS.Record_General(lu_name_, 'IMPNOTALLOWED2: User: :P1 is not allowed to import company template: :P2', fnd_user_, newrec_.template_id);   
            END IF;
         END IF;
      END IF;
      Delete_Child_Lu_Data___(newrec_.template_id, public_rec_.component);
      -- The raise_error_ := TRUE row is added with the purpose that if something fails 
      -- below the Delete_Child_Lu_Data___ statement then the error should be raised up
      -- to the client so that the template detail data is not deleted.
      raise_error_ := TRUE;
      -- Delete all system defined translations for the template for given component.
      -- Only delete if interface is equal or newer than 170 eg. using Enterp_Comp_Connect_V170_API.
      IF (interface_ < 170) THEN
         NULL;
      ELSE
         Templ_Key_Lu_API.Remove_Templ_Key_Lu__(newrec_.template_id, public_rec_.component);
      END IF;
      Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.template_id);
      -- To get rid of locking problem (due to parallel installation processes over several templates and components) 
      -- the template head is updated through a background job.
      IF (Is_Job_Posted___(newrec_.template_id)) THEN
         NULL;
      ELSE
         Client_SYS.Add_To_Attr('TEMPLATE_ID', newrec_.template_id, attr_);
         Client_SYS.Add_To_Attr('DESCRIPTION', newrec_.description, attr_);
         Client_SYS.Add_To_Attr('VALID', newrec_.valid, attr_);
         Client_SYS.Add_To_Attr('CREATED_BY_USER', newrec_.created_by_user, attr_);
         Post_Job___(attr_);
      END IF;
      Create_Company_Tem_Comp_API.Insert_Data__(public_rec_);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      error_text_ := SQLERRM;
      Create_Company_Tem_Log_API.Log_Error__(error_text_, public_rec_.template_id, public_rec_.component, public_rec_.lu);
      IF (raise_error_) THEN
         RAISE;
      END IF;  
END Insert_Data;


PROCEDURE Insert_Detail_Data (
   public_rec_ IN Public_Rec_Templ )
IS
   error_text_          VARCHAR2(2000);
   allowed_             BOOLEAN := TRUE;
   rec_                 create_company_tem_tab%ROWTYPE;
   fnd_user_            VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User();
   app_owner_           VARCHAR2(30) := Fnd_Session_API.Get_App_Owner();
   older_version_templ_ VARCHAR2(30);
   older_version_comp_  VARCHAR2(30);
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', public_rec_.template_id);
   rec_ := Get_Object_By_Keys___(public_rec_.template_id);
   -- Check user for STD and UserDefined templates
   IF (rec_.template_id IS NOT NULL) THEN
      IF (rec_.created_by_user != fnd_user_) THEN
         IF NOT (Create_Company_API.Is_Template_Super_User = 'TRUE') THEN
            IF (app_owner_ != fnd_user_) THEN
               allowed_ := FALSE;
            END IF;   
         END IF;
      END IF;
   END IF;   
   IF (allowed_) THEN
      older_version_templ_ := App_Context_SYS.Find_Value('CREATE_COMPANY_TEM_API.Older_Version_Templ_', NULL);
      older_version_comp_  := App_Context_SYS.Find_Value('CREATE_COMPANY_TEM_API.Older_Version_Comp_', NULL);    
      IF (older_version_comp_ = public_rec_.component AND older_version_templ_ = public_rec_.template_id) THEN
         NULL; 
         -- do not insert any rows since a newer version of the component exist in the template storage
      ELSE
         Create_Company_Tem_Lu_API.Insert_Data__ (public_rec_);
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      error_text_ := SQLERRM;
      Create_Company_Tem_Log_API.Log_Error__(error_text_, public_rec_.template_id, public_rec_.component, public_rec_.lu);
END Insert_Detail_Data;


FUNCTION Check_Exist (
   template_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Check_Exist___(template_id_)) THEN
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Check_Exist;


PROCEDURE Initiate_Log
IS
BEGIN
   Create_Company_Tem_Log_API.Initiate_Log__;
END Initiate_Log;


PROCEDURE Reset_Log
IS
BEGIN
   Create_Company_Tem_Log_API.Reset_Log__;
END Reset_Log;


PROCEDURE Set_Last_Modification_Date (
   template_id_ IN VARCHAR2 )
IS
   objid_        create_company_tem.objid%TYPE;
   objversion_   create_company_tem.objversion%TYPE;
   attr_         VARCHAR2(100);
   oldrec_       create_company_tem_tab%ROWTYPE;
   newrec_       create_company_tem_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, template_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Last_Modification_Date;


PROCEDURE Set_Valid (
   template_id_ IN VARCHAR2 )
IS
   objid_        create_company_tem.objid%TYPE;
   objversion_   create_company_tem.objversion%TYPE;
   attr_         VARCHAR2(100);
   oldrec_       create_company_tem_tab%ROWTYPE;
   newrec_       create_company_tem_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, template_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.valid := 'TRUE';
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   UPDATE create_company_tem_comp_tab a
   SET    version     = Crecomp_Component_API.Get_Version(a.component)
   WHERE  a.template_id = template_id_
   AND EXISTS (SELECT 1 
               FROM   crecomp_component_tab b 
               WHERE  b.module = a.component);
END Set_Valid;


PROCEDURE Set_Invalid (
   template_id_ IN VARCHAR2 )
IS
   objid_        create_company_tem.objid%TYPE;
   objversion_   create_company_tem.objversion%TYPE;
   attr_         VARCHAR2(100);
   oldrec_       create_company_tem_tab%ROWTYPE;
   newrec_       create_company_tem_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, template_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.valid := 'FALSE';
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Invalid;


PROCEDURE Update_Diff_Template ( 
   public_rec_  IN  Public_Rec_Templ )
IS
BEGIN
   Create_Company_Tem_Detail_API.Update_Diff_Template__(public_rec_);
END Update_Diff_Template;


@UncheckedAccess
FUNCTION Exp_Comp_Templ_Date_Str (
   in_date_       IN DATE,                   
   end_character_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN VARCHAR2
IS
   date_string_      VARCHAR2(200);
   string_out_       VARCHAR2(200);
BEGIN
   IF (in_date_ IS NULL) THEN
      string_out_ := CHR(39) || CHR(39);
   ELSE
      date_string_ := TO_CHAR(in_date_,'YYYY-MM-DD','nls_calendar=GREGORIAN'); 
      string_out_ := 'TO_DATE('''||date_string_||''',''YYYY-MM-DD'',''nls_calendar=GREGORIAN'')';
   END IF;
   IF (end_character_ = 'TRUE') THEN
      string_out_ := string_out_ || CHR(30);
   END IF;
   RETURN string_out_;
END Exp_Comp_Templ_Date_Str;


@UncheckedAccess
FUNCTION Export_Company_Template_String (
   in_string_     IN VARCHAR2,
   end_character_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN VARCHAR2
IS
   temp_       VARCHAR2(32000);
BEGIN
   -- In earlier releases (before Enterp 2.0.0) there was a replace statement to replace
   -- CHR(13)||CHR(10) with the string '''||CHR(13)||CHR(10)||'''.
   -- This is removed in Enterp 2.0.0 and placed in the client instead to prevent that the 
   -- concatenated column "column_values" in the view export_company_tempate did not exceed
   -- 4000 characters. This could still happen though but not very likeley so therefore
   -- the design should be changed in the future.
   -- The export client now replace CHR(13)||CHR(10) with a global package constant
   -- Enterp_Comp_Connect_V190_API.crlf_.

   -- In order to not add Unistr function on every string check if there are any
   -- unicode characters by checking the length of the string
   temp_ := Database_SYS.Asciistr(in_string_);
   IF (LENGTH(NVL(temp_,' ')) = LENGTH(NVL(in_string_,' '))) THEN
      temp_ := CHR(39) || REPLACE(REPLACE(in_string_,
                                          '''',
                                          ''''''),
                                  '&',
                                  '''||CHR(38)||''') || CHR(39);
   ELSE
      temp_ := 'Database_SYS.Unistr(' || CHR(39) || REPLACE(REPLACE(temp_,
                                                                    '''',
                                                                    ''''''),
                                                            '&',
                                                            '''||CHR(38)||''') || CHR(39) || ')';
   END IF;
   -- Always add CHR(30) if FALSE is not set
   IF (end_character_ = 'TRUE') THEN
      temp_ := temp_ || CHR(30);
   END IF;
   RETURN temp_;
END Export_Company_Template_String;


@UncheckedAccess
FUNCTION Change_Template_Allowed (
   template_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   fnd_user_            VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User();
   app_owner_           VARCHAR2(30) := Fnd_Session_API.Get_App_Owner();
BEGIN
   IF (Is_System_Template___(template_id_)) THEN
      IF (Create_Company_API.Is_Template_Super_User = 'TRUE') OR (app_owner_ = fnd_user_) THEN
         RETURN 'TRUE';
      END IF;
   ELSE
      IF (Get_Created_By_User(template_id_) = fnd_user_) OR (Create_Company_API.Is_Template_Super_User = 'TRUE') THEN
         RETURN 'TRUE';
      END IF;
      -- IF the template does not exist return TRUE
      IF NOT (Check_Exist___(template_id_)) THEN
         RETURN 'TRUE';
      END IF;
   END IF;
   RETURN 'FALSE';
END Change_Template_Allowed;


@UncheckedAccess
FUNCTION Is_System_Template (
   template_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Is_System_Template___(template_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_System_Template;



