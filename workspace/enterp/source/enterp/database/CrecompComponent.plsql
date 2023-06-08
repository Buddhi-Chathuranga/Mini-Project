-----------------------------------------------------------------------------
--
--  Logical unit: CrecompComponent
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020109  ovjose  Created.
--  021112  ovjose  Glob06. Added parameters to Add_Component_Detail.
--  021114  ovjose  Glob06. Added Get_Translation_Reg_Info__.
--  021202  ovjose  Glob06. Added Get_Comp_Detail_List_Lu__.
--  050816  ovjose  Changed the purpose of Export_view to mean Create And Export. (TRUE/FALSE)
--  120302  AsHelk  SFI-2567, Added New Method Remove_Crecomp_Component
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE ComponentTab IS TABLE OF VARCHAR2(10)
      INDEX BY BINARY_INTEGER;

TYPE PackageTab IS TABLE OF VARCHAR2(30)
      INDEX BY BINARY_INTEGER;

TYPE ActiveTab IS TABLE OF VARCHAR2(5)
      INDEX BY BINARY_INTEGER;

TYPE LuTab IS TABLE OF VARCHAR2(30)
      INDEX BY BINARY_INTEGER;
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Use_Make_Company___  (
   use_make_company_   IN VARCHAR2 )
IS
   temp_use_make_company_    crecomp_component_tab.use_make_company%TYPE;
BEGIN
   temp_use_make_company_ := use_make_company_;
   -- Treat NULL as TRUE
   IF (temp_use_make_company_ IS NULL) THEN
      temp_use_make_company_ := 'TRUE';
   END IF;
   -- In Apps 8 the support for old create company concept is removed so therefore it will only be
   -- allowed to set Use_Make_Company to TRUE
   IF (temp_use_make_company_ != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'ONLYTRUE: Old Create Company concept is not supported. Only value :P1 is allowed for attribute Support Company Template.', Fnd_Boolean_API.Decode('TRUE'));
   END IF;
END Validate_Use_Make_Company___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     crecomp_component_tab%ROWTYPE,
   newrec_ IN OUT crecomp_component_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Use_Make_Company___(newrec_.use_make_company);
END Check_Common___;
                         
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Get_Active_Component__ (
   component_msg_ OUT VARCHAR2 )
IS
   i_          NUMBER;
   submsg_     VARCHAR2(2000);
   error_msg_  VARCHAR2(2000);
   CURSOR active_components( module_ IN VARCHAR2) IS
      SELECT module, version, parent_component
      FROM   crecomp_component_tab
      WHERE  active = 'TRUE'
      START WITH module = module_
      CONNECT BY parent_component = PRIOR module;
   CURSOR get_others IS
      SELECT module
      FROM crecomp_component_tab
      WHERE parent_component IS NOT NULL
      AND parent_component NOT IN (SELECT module
                                   FROM   crecomp_component_tab );
BEGIN
   -- initiate main msg
   component_msg_ := Message_SYS.Construct('FNDCLI.TEXTMESSAGE');
   --loop that retrieves components
   i_ := 0;
   FOR rec_ IN active_components('ENTERP') LOOP
      i_ := i_ + 1;
      submsg_ := NULL;
      submsg_ := Message_SYS.Construct('SM' );
      Message_SYS.Add_Attribute(submsg_, 'COMPONENT', rec_.module);
      Message_SYS.Add_Attribute(submsg_, 'VERSION', rec_.version);
      -- create attribute in main msg
      Message_SYS.Add_Attribute(component_msg_, TO_CHAR(i_) , submsg_);
   END LOOP;
   FOR rec2_ IN get_others LOOP
      FOR rec_ IN active_components(rec2_.module) LOOP
         i_ := i_ + 1;
         submsg_ := NULL;
         submsg_ := Message_SYS.Construct('SM' );
         Message_SYS.Add_Attribute(submsg_, 'COMPONENT', rec_.module);
         Message_SYS.Add_Attribute(submsg_, 'VERSION', rec_.version);
         -- create attribute in main msg
         Message_SYS.Add_Attribute(component_msg_, TO_CHAR(i_) , submsg_);
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      error_msg_ := SQLERRM;
      Message_SYS.Add_Attribute(component_msg_, TO_CHAR(i_) , error_msg_);
END Get_Active_Component__;


PROCEDURE Do_Final_Check__ (
   result_ OUT VARCHAR2,
   module_ IN  VARCHAR2 )
IS
   i_             NUMBER;
   null_parent_   NUMBER;
   CURSOR get_component_order(module_ IN VARCHAR2) IS
      SELECT module
      FROM   crecomp_component_tab
      START WITH module = module_
      CONNECT BY parent_component = PRIOR module
      FOR UPDATE;
   CURSOR get_others IS
      SELECT module
      FROM   crecomp_component_tab
      WHERE  parent_component IS NOT NULL
      AND    parent_component NOT IN (SELECT module
                                      FROM   crecomp_component_tab )
      FOR UPDATE;
   CURSOR check_null_parent IS
      SELECT COUNT(*)
      FROM   crecomp_component_tab
      WHERE  parent_component IS NULL;
BEGIN
   OPEN check_null_parent;
   FETCH check_null_parent INTO null_parent_;
   IF (null_parent_ > 1) THEN
      CLOSE check_null_parent;
      Error_SYS.Record_General(lu_name_, 'NULLPARENT: Only the Module ENTERP is allowed to have no Parent Component specified.');
   END IF;
   CLOSE check_null_parent;
   i_ := 0;
   FOR rec_ IN get_component_order('ENTERP') LOOP
      UPDATE crecomp_component_tab
         SET component_seq = i_
         WHERE module = rec_.module;
      i_ := i_ + 1;
   END LOOP;
   FOR rec2_ IN get_others LOOP
      FOR rec_ IN get_component_order(rec2_.module) LOOP
         UPDATE crecomp_component_tab
            SET component_seq = i_
            WHERE module = rec_.module;
         i_ := i_ + 1;
      END LOOP;
   END LOOP;
   UPDATE crecomp_component_tab
      SET last_modified_date = SYSDATE
      WHERE module = module_;
   result_ := 'TRUE';
END Do_Final_Check__;


PROCEDURE Add_Component__ (
   module_            IN VARCHAR2,
   version_           IN VARCHAR2,
   parent_component_  IN VARCHAR2,
   active_            IN VARCHAR2,
   use_make_company_  IN VARCHAR2 DEFAULT 'TRUE',
   registration_date_ IN DATE DEFAULT SYSDATE )
IS
   newrec_        crecomp_component_tab%ROWTYPE;
   result_        VARCHAR2(5);
   rec_           crecomp_component_tab%ROWTYPE;
   CURSOR lock_tab IS
      SELECT *
      FROM   crecomp_component_tab 
      FOR UPDATE;
BEGIN
   -- Due to issues with deadlocks in some situations (parallel installation through multiple sessions),  lock 
   -- the table throughout the "add component" process
   OPEN lock_tab;
   FETCH lock_tab INTO rec_;
   CLOSE lock_tab;
   newrec_.module := module_;
   newrec_.version := version_;
   newrec_.parent_component := parent_component_;
   newrec_.active := active_;
   newrec_.use_make_company := use_make_company_;
   newrec_.registration_date := registration_date_;
   IF Check_Exist___(newrec_.module) THEN
      IF (parent_component_ IS NOT NULL) THEN
         Module_API.Exist(parent_component_);
      END IF;
      IF (use_make_company_ = 'TRUE') THEN
         UPDATE crecomp_component_tab
         SET   use_make_company = use_make_company_,
               version = version_,
               parent_component = parent_component_,
               active = active_
         WHERE module = module_;
      END IF;
   ELSE
      New___(newrec_);
   END IF;
   Do_Final_Check__(result_, module_);
   IF (version_ IS NOT NULL) THEN
      IF (module_ IS NOT NULL) THEN
         Create_Company_Tem_API.Set_Invalid_Templates__(version_, module_);
      END IF;
   END IF;
END Add_Component__;


FUNCTION Get_Translation_Reg_Info__ (
   key_attr_      OUT VARCHAR2,
   suffix_attr_   OUT VARCHAR2,
   value_attr_    OUT VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Crecomp_Component_Lu_API.Get_Translation_Reg_Info__(key_attr_, suffix_attr_, value_attr_, module_, lu_);
END Get_Translation_Reg_Info__;


PROCEDURE Get_Comp_Detail_List_Lu__ (
   active_list_      OUT ActiveTab,
   package_          OUT PackageTab,
   lu_list_          OUT LuTab,
   number_of_rows_   OUT NUMBER,
   module_           IN  VARCHAR2,
   update_id_        IN  VARCHAR2 DEFAULT NULL )
IS
   i_                NUMBER := 0;
   sel_for_update_   BOOLEAN;
   CURSOR get_component_detail IS
      SELECT package, active_detail, lu
      FROM   crecomp_component_detail2
      WHERE  module = module_
      ORDER BY exec_order;
BEGIN
   FOR rec_ IN get_component_detail LOOP
      IF (rec_.active_detail IS NULL) THEN
         rec_.active_detail := 'FALSE';
      END IF;
      IF (update_id_ IS NOT NULL) THEN
         sel_for_update_ := Update_Company_Select_Lu_API.Lu_Is_Selected__(update_id_, module_, rec_.lu);
         IF (NOT sel_for_update_) THEN
            rec_.active_detail := 'FALSE';
         END IF;
      END IF;
      i_ := i_ + 1;
      package_(i_)     := rec_.package;
      active_list_(i_) := rec_.active_detail;
      lu_list_(i_)     := rec_.lu;
   END LOOP;
   number_of_rows_ := i_;
END Get_Comp_Detail_List_Lu__;
 
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Active (
   module_ IN VARCHAR2,
   active_ IN VARCHAR2 )
IS
   newrec_        crecomp_component_tab%ROWTYPE;
   oldrec_        crecomp_component_tab%ROWTYPE;
   attr_          VARCHAR2(2000);
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, module_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.active := active_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Active;


PROCEDURE Remove_Component (
   module_ IN VARCHAR2 )
IS
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
   remrec_        crecomp_component_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, module_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Delete___(objid_, remrec_);
END Remove_Component;


PROCEDURE Remove_Crecomp_Component (
   module_ IN VARCHAR2 )
IS
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
   remrec_        crecomp_component_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, module_);
   IF (objid_ IS NOT NULL) THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Delete___(objid_, remrec_);
   END IF;
END Remove_Crecomp_Component;


PROCEDURE Add_Component_Detail (
   module_               IN VARCHAR2,
   lu_                   IN VARCHAR2,
   package_              IN VARCHAR2,
   export_view_          IN VARCHAR2,
   exec_order_           IN NUMBER,
   active_               IN VARCHAR2,
   account_lu_           IN VARCHAR2,
   mapping_id_           IN VARCHAR2,
   attribute_key_col_    IN VARCHAR DEFAULT NULL,
   attribute_key_suffix_ IN VARCHAR DEFAULT NULL,
   attribute_key_value_  IN VARCHAR DEFAULT NULL )
IS
   detail_rec_  crecomp_component_lu_tab%ROWTYPE;
BEGIN
   detail_rec_.module      := module_;
   detail_rec_.lu          := lu_;
   detail_rec_.package     := package_;
   detail_rec_.export_view := export_view_;
   detail_rec_.exec_order  := exec_order_;
   detail_rec_.active      := active_;
   detail_rec_.rowversion  := SYSDATE;
   detail_rec_.account_lu  := account_lu_;
   detail_rec_.mapping_id  := mapping_id_;
   detail_rec_.attribute_key_col  := attribute_key_col_;
   detail_rec_.attribute_key_suffix  := attribute_key_suffix_;
   detail_rec_.attribute_key_value  := attribute_key_value_;
   Crecomp_Component_Lu_API.Add_Component_Detail__(detail_rec_);
END Add_Component_Detail;


PROCEDURE Set_Active_Detail (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2,
   active_     IN VARCHAR2 )
IS
BEGIN
   Crecomp_Component_Lu_API.Set_Active_Detail__(module_, lu_, active_);
END Set_Active_Detail;


PROCEDURE Remove_Component_Detail (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2 )
IS
BEGIN
   Crecomp_Component_Lu_API.Remove_Detail__(module_, lu_);
END Remove_Component_Detail;


PROCEDURE Get_Component_List (
   module_           OUT ComponentTab,
   active_list_      OUT ActiveTab,
   number_of_rows_   OUT NUMBER )
IS
   i_             NUMBER := 0;
   CURSOR get_component( module_ IN VARCHAR2) IS
      SELECT module, active
      FROM   crecomp_component
      START WITH module = module_
      CONNECT BY parent_component = PRIOR module;
   CURSOR get_others IS
      SELECT module
      FROM   crecomp_component
      WHERE  parent_component IS NOT NULL
      AND    parent_component NOT IN (SELECT module
                                      FROM   crecomp_component );
BEGIN
   FOR rec_ IN get_component('ENTERP') LOOP
      IF (rec_.active IS NULL) THEN
         rec_.active := 'FALSE';
      END IF;
      i_ := i_ + 1;
      module_(i_) := rec_.module;
      active_list_(i_) := rec_.active;
   END LOOP;
   FOR rec2_ IN get_others LOOP
      FOR rec_ IN get_component(rec2_.module) LOOP
         IF (rec_.active IS NULL) THEN
            rec_.active := 'FALSE';
         END IF;
         i_ := i_ + 1;
         module_(i_) := rec_.module;
         active_list_(i_) := rec_.active;
      END LOOP;
   END LOOP;
   number_of_rows_ := i_;
END Get_Component_List;


PROCEDURE Get_Use_Make_Company_List (
   module_           OUT ComponentTab,
   active_list_      OUT ActiveTab,
   number_of_rows_   OUT NUMBER,
   update_id_        IN  VARCHAR2 DEFAULT NULL )
IS
   i_             NUMBER := 0;
   module_is_sel_ BOOLEAN;
   CURSOR get_component(module_ IN VARCHAR2) IS
      SELECT module, active
      FROM   crecomp_component
      START WITH module = module_
      CONNECT BY parent_component = PRIOR module;
   CURSOR get_others IS
      SELECT module
      FROM   crecomp_component
      WHERE  parent_component IS NOT NULL
      AND    parent_component NOT IN (SELECT module
                                      FROM   crecomp_component );
BEGIN
   FOR rec_ IN get_component('ENTERP') LOOP
      IF (rec_.active IS NULL) THEN
         rec_.active := 'FALSE';
      END IF;
      IF (update_id_ IS NOT NULL ) THEN
         module_is_sel_ := Update_Company_Select_Lu_API.Module_Is_Selected__(update_id_, rec_.module);
         IF (NOT module_is_sel_) THEN
            rec_.active := 'FALSE';
         END IF;
      END IF;
      IF (rec_.active = 'TRUE') THEN
         i_ := i_ + 1;
         module_(i_) := rec_.module;
         active_list_(i_) := rec_.active;
      END IF;
   END LOOP;
   FOR rec2_ IN get_others LOOP
      FOR rec_ IN get_component(rec2_.module) LOOP
         IF (rec_.active IS NULL) THEN
            rec_.active := 'FALSE';
         END IF;
         IF (update_id_ IS NOT NULL ) THEN
            module_is_sel_ := Update_Company_Select_Lu_API.Module_Is_Selected__(update_id_, rec_.module);
            IF (NOT module_is_sel_) THEN
               rec_.active := 'FALSE';
            END IF;
         END IF;
         IF (rec_.active = 'TRUE') THEN
            i_ := i_ + 1;
            module_(i_) := rec_.module;
            active_list_(i_) := rec_.active;
         END IF;
      END LOOP;
   END LOOP;
   number_of_rows_ := i_;
END Get_Use_Make_Company_List;


PROCEDURE Get_Component_Detail_List (
   active_list_      OUT ActiveTab,
   package_          OUT PackageTab,
   number_of_rows_   OUT NUMBER,
   module_           IN  VARCHAR2 )
IS
   i_     NUMBER := 0;
   CURSOR get_component_detail IS
      SELECT package, active_detail
      FROM   crecomp_component_detail2
      WHERE  module = module_
      ORDER BY exec_order;
BEGIN
   FOR rec_ IN get_component_detail LOOP
      IF (rec_.active_detail IS NULL) THEN
         rec_.active_detail := 'FALSE';
      END IF;
      i_ := i_ + 1;
      package_(i_)     := rec_.package;
      active_list_(i_) := rec_.active_detail;
   END LOOP;
   number_of_rows_ := i_;
END Get_Component_Detail_List;


PROCEDURE Add_Table (
   module_           IN VARCHAR2,
   table_name_       IN VARCHAR2,
   column_name_      IN VARCHAR2,
   standard_table_   IN VARCHAR2 )
IS
   remove_rec_  remove_company_tab%ROWTYPE;
BEGIN
   remove_rec_.module          := module_;
   remove_rec_.table_name      := table_name_;
   remove_rec_.standard_table  := standard_table_;
   remove_rec_.rowversion      := 0;
   Remove_Company_API.Add_Table__(remove_rec_);
END Add_Table;


PROCEDURE Remove_Table (
   module_           IN VARCHAR2,
   table_name_       IN VARCHAR2 )
IS
BEGIN
   Remove_Company_API.Remove_Table__(module_, table_name_);
END Remove_Table;


PROCEDURE Start_Remove_Company (
   info_        OUT VARCHAR2,
   company_     IN  VARCHAR2 )
IS
BEGIN   
   Remove_Company_API.Start_Remove_Company__(company_);
   info_  := Client_SYS.Get_All_Info;
END Start_Remove_Company;


PROCEDURE Check_If_All_Use_Make_Company (
   use_make_company_  OUT VARCHAR2,
   component_list_    OUT VARCHAR2 )
IS
   i_         NUMBER := 0;
   CURSOR check_use_make_company IS
      SELECT module
      FROM   crecomp_component t
      WHERE  use_make_company = 'FALSE';
BEGIN
   FOR rec_ IN check_use_make_company LOOP
      i_ := i_ + 1;
      IF (i_ = 1) THEN
         component_list_ := rec_.module;
      ELSE
         component_list_ := component_list_||', '||rec_.module;
      END IF;
   END LOOP;
   IF (i_ > 0) THEN
      use_make_company_ := 'FALSE';
   ELSE
      use_make_company_ := 'TRUE';
   END IF;
END Check_If_All_Use_Make_Company;


PROCEDURE Delete_Remove_Company_Info (
   module_               IN VARCHAR2,
   remove_standard_only_ IN BOOLEAN )
IS
BEGIN
   Remove_Company_API.Delete_Info__(module_, remove_standard_only_);
END Delete_Remove_Company_Info;


PROCEDURE Add_Component (
   module_           IN VARCHAR2,
   version_          IN VARCHAR2,
   parent_component_ IN VARCHAR2,
   active_           IN VARCHAR2 )
IS
   use_make_company_  VARCHAR2(5) := 'TRUE';
   registration_date_ DATE := SYSDATE;
BEGIN
   Add_Component__(module_, version_, parent_component_, active_, use_make_company_, registration_date_);
END Add_Component;


PROCEDURE Check_Component (
   exist_               OUT VARCHAR2,
   use_make_company_    OUT VARCHAR2,
   component_           IN  VARCHAR2 )
IS
BEGIN
   use_make_company_ := Get_Use_Make_Company(component_);
   IF (use_make_company_ IS NULL) THEN
      exist_ := 'FALSE';
      use_make_company_ := 'FALSE';
   ELSE
      exist_ := 'TRUE';
   END IF;
END Check_Component;


FUNCTION Is_Account_Lu (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Crecomp_Component_Lu_API.Is_Account_Lu__(module_, lu_);
END Is_Account_Lu;


PROCEDURE Add_Table_Detail (
   module_           IN VARCHAR2,
   table_name_       IN VARCHAR2,
   column_name_      IN VARCHAR2,
   column_value_     IN VARCHAR2 )
IS
BEGIN
   Remove_Company_API.Add_Table_Detail__(module_, table_name_, column_name_, column_value_); 
END Add_Table_Detail;


@Override
FUNCTION Get_Version (
   module_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ crecomp_component_tab.version%TYPE;
BEGIN
   IF (Database_SYS.Get_Installation_Mode) THEN
      IF (module_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT version
         INTO  temp_
         FROM  crecomp_component_tab
         WHERE module = module_;
      RETURN temp_;
   ELSE
      RETURN super(module_);
   END IF;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(module_, 'Get_Version');
END Get_Version;
