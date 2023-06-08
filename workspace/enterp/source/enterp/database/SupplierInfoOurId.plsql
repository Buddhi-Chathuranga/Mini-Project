-----------------------------------------------------------------------------
--
--  Logical unit: SupplierInfoOurId
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990125  Camk    Created.
--  000221  Camk    New public method Get_Supplier_By_Our_Id added.
--  000224  Camk    New public method Get_Company_By_Our_Id added.
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  091203  Kanslk  Reverse-Engineering, changed company to a parent key
--  140703  Hawalk  Bug 116673 (merged via PRFI-287), User-company authorization added inside Check_Common___().
--  210721  NaLrlk  PR21R2-401, Added Modify() to update a record.
--  210728  NaLrlk  PR21R2-398, Added New() to create a record.
--  210817  NaLrlk  PR21R2-589, Removed NOCOPY from IN OUT parameters in Modify() and New().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE string_suppliers IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;

TYPE string_company IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
                                             
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     supplier_info_our_id_tab%ROWTYPE,
   newrec_ IN OUT supplier_info_our_id_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.our_id IS NOT NULL) THEN
      Attribute_Definition_API.Check_Value(newrec_.our_id, lu_name_, 'OUR_ID');
   END IF;   
   -- Note: Validate that the user is one within the company.
   -- Note: No need for ELSE as application doesn't run without ACCRUL - only installation issue addressed here!
   $IF Component_Accrul_SYS.INSTALLED $THEN
      User_Finance_API.Exist_Current_User(newrec_.company);
   $END
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Copy_Supplier (
   supplier_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2 )
IS   
   newrec_ supplier_info_our_id_tab%ROWTYPE;
   oldrec_ supplier_info_our_id_tab%ROWTYPE;
   CURSOR get_attr IS
      SELECT *
      FROM   supplier_info_our_id_tab
      WHERE  supplier_id = supplier_id_;
BEGIN   
   FOR rec_ IN get_attr LOOP
      oldrec_ := Lock_By_Keys___(supplier_id_, rec_.company);   
      newrec_ := oldrec_ ;
      newrec_.supplier_id := new_id_;         
      New___(newrec_);
   END LOOP; 
END Copy_Supplier;


FUNCTION Get_Company_By_Our_Id (
   supplier_id_ IN VARCHAR2,
   our_id_      IN VARCHAR2 ) RETURN string_company
IS
   company_array_ string_company;
   index_no_ NUMBER := 0;
   CURSOR get_company IS
      SELECT company
      FROM supplier_info_our_id_tab
      WHERE our_id = our_id_
      AND supplier_id = supplier_id_;
BEGIN
   FOR i IN get_company LOOP
      company_array_(index_no_) := i.company;
      index_no_ := index_no_ + 1;
   END LOOP;
   RETURN company_array_;
END Get_Company_By_Our_Id;


@UncheckedAccess
FUNCTION Get_Supplier_By_Our_Id (
   our_id_ IN VARCHAR2 ) RETURN string_suppliers
IS
   supplier_array_ string_suppliers;
   index_no_ NUMBER := 0;
   CURSOR get_supplier IS
      SELECT supplier_id
      FROM supplier_info_our_id_tab
      WHERE our_id = our_id_;
BEGIN
   FOR i IN get_supplier LOOP
      supplier_array_(index_no_) := i.supplier_id;
      index_no_ := index_no_ + 1;
   END LOOP;
   RETURN supplier_array_;
END Get_Supplier_By_Our_Id;


-- Modify
--   Public interface to modify a record by sending changed values in an attr_.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify (
   attr_        IN OUT VARCHAR2,
   supplier_id_ IN     VARCHAR2,
   company_     IN     VARCHAR2 )
IS
   indrec_     Indicator_Rec;
   newrec_     supplier_info_our_id_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(supplier_id_, company_);
   Unpack___(newrec_, indrec_, attr_);
   Modify___(newrec_);
END Modify;


-- New
--   Public interface to create a record sending an attr_.
@IgnoreUnitTest DMLOperation
PROCEDURE New (
   attr_  IN OUT VARCHAR2 )
IS
   indrec_     Indicator_Rec;
   newrec_     supplier_info_our_id_tab%ROWTYPE;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   New___(newrec_);
END New;

   

