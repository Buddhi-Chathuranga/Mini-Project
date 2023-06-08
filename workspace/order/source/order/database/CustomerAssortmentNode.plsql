-----------------------------------------------------------------------------
--
--  Logical unit: CustomerAssortmentNode
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210528   SWiclk  COM21R2-89, Created and added Prepare_Insert___(), Delete_All_By_Assortment_Id(), 
--  210528           Modify_Limit_Sales_To_Node_All() and Restricted_Node_Exists().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('LIMIT_SALES_TO_NODE_DB', Fnd_Boolean_API.DB_TRUE, attr_); 
END Prepare_Insert___;

@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_assortment_node_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   -- Disable child nodes.
   IF (newrec_.limit_sales_to_node = Fnd_Boolean_API.DB_TRUE) THEN
      Disable_Or_Enable_Child_Nodes(newrec_.customer_no, newrec_.assortment_id, newrec_.assortment_node_id, Fnd_Boolean_API.DB_FALSE);
   END IF;
   
END Insert___;

@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customer_assortment_node_tab%ROWTYPE,
   newrec_     IN OUT customer_assortment_node_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
    -- Disable child nodes.
   IF (newrec_.limit_sales_to_node = Fnd_Boolean_API.DB_TRUE) THEN
      Disable_Or_Enable_Child_Nodes(newrec_.customer_no, newrec_.assortment_id, newrec_.assortment_node_id, Fnd_Boolean_API.DB_FALSE);   
   END IF;
END Update___;






-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Note: This method will modify Limit Sales to Node attribute to TRUE/FALSE 
--       in all assortment nodes defined in this LU to the given assortment.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify_Limit_Sales_To_Node_All(
   customer_no_ IN VARCHAR2,
   assortment_id_ IN VARCHAR2,
   limit_sales_to_node_ IN VARCHAR2)
IS
   newrec_  customer_assortment_node_tab%ROWTYPE;
    CURSOR get_assortment_nodes IS
         SELECT *
         FROM   customer_assortment_node_tab
         WHERE  customer_no = customer_no_
         AND    assortment_id = assortment_id_;
   
 BEGIN
   FOR rec_ IN get_assortment_nodes LOOP
      newrec_ := rec_;
      newrec_.limit_sales_to_node := limit_sales_to_node_;
      Modify___(newrec_);
   END LOOP;   
END Modify_Limit_Sales_To_Node_All;

@UncheckedAccess
FUNCTION Restricted_Node_Exists(
   customer_no_ IN VARCHAR2,
   assortment_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR check_restricted_nodes IS
      SELECT 1
      FROM   customer_assortment_node_tab
      WHERE  customer_no = customer_no_
      AND    assortment_id = assortment_id_
      AND    limit_sales_to_node = 'TRUE';   
BEGIN
   OPEN check_restricted_nodes;  
   FETCH check_restricted_nodes INTO dummy_;
   CLOSE check_restricted_nodes;
   IF (dummy_ = 1) THEN
      RETURN Fnd_Boolean_API.DB_TRUE;
   ELSE
      RETURN Fnd_Boolean_API.DB_FALSE;
   END IF;
END Restricted_Node_Exists;

@IgnoreUnitTest DMLOperation
PROCEDURE Delete_All_By_Assortment_Id(
   customer_no_ IN VARCHAR2,
   assortment_id_ IN VARCHAR2)
IS
   newrec_  customer_assortment_node_tab%ROWTYPE;
    CURSOR get_assortment_nodes IS
         SELECT *
         FROM   customer_assortment_node_tab
         WHERE  customer_no = customer_no_
         AND    assortment_id = assortment_id_;
   
 BEGIN
   FOR rec_ IN get_assortment_nodes LOOP      
      Check_Delete___(rec_);       
      Remove___(rec_);
   END LOOP;   
END Delete_All_By_Assortment_Id;

@UncheckedAccess
FUNCTION Node_Exists_In_Limit_Hierarchy(
   customer_no_ IN VARCHAR2,
   assortment_id_ IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2) RETURN NUMBER
IS
   dummy_ NUMBER := 0;
   CURSOR get_restricted_nodes IS
      SELECT assortment_node_id
      FROM   customer_assortment_node_tab
      WHERE  customer_no = customer_no_
      AND    assortment_id = assortment_id_      
      AND    limit_sales_to_node = 'TRUE' ;   
BEGIN
   FOR rec_ IN get_restricted_nodes LOOP
      -- check whether the restricted node is a child node 
      dummy_ := Assortment_Node_API.Check_Node_Exist_As_Child(assortment_id_      => assortment_id_,
                                                              assortment_node_id_ => assortment_node_id_,
                                                              child_node_id_      => rec_.assortment_node_id);
      IF (dummy_ = 0) THEN
         -- check whether the restricted node is a parent node
         dummy_ := Assortment_Node_API.Check_Node_Exist_As_Child(assortment_id_   => assortment_id_,
                                                              assortment_node_id_ => rec_.assortment_node_id,
                                                              child_node_id_      => assortment_node_id_);        
      END IF;
      IF (dummy_ = 1) THEN
          RETURN dummy_;
      END IF;      
   END LOOP;   
     RETURN dummy_;   
END Node_Exists_In_Limit_Hierarchy;


@UncheckedAccess
FUNCTION Restricted_Child_Nodes_Exist(
   customer_no_ IN VARCHAR2,
   assortment_id_ IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER := 0;
   CURSOR get_restricted_nodes IS
      SELECT assortment_node_id
      FROM   customer_assortment_node_tab
      WHERE  customer_no = customer_no_
      AND    assortment_id = assortment_id_  
      AND    assortment_node_id != assortment_node_id_
      AND    limit_sales_to_node = 'TRUE' ;   
BEGIN
   FOR rec_ IN get_restricted_nodes LOOP
      -- check whether the restricted node is a child node 
      dummy_ := Assortment_Node_API.Check_Node_Exist_As_Child(assortment_id_      => assortment_id_,
                                                              assortment_node_id_ => assortment_node_id_,
                                                              child_node_id_      => rec_.assortment_node_id);
      IF (dummy_ = 1) THEN
          RETURN Fnd_Boolean_API.DB_TRUE;
      END IF;      
   END LOOP;   
     RETURN Fnd_Boolean_API.DB_FALSE;   
END Restricted_Child_Nodes_Exist;

@UncheckedAccess
FUNCTION Restricted_Parent_Node_Exists(
   customer_no_ IN VARCHAR2,
   assortment_id_ IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER := 0;
   CURSOR get_restricted_nodes IS
      SELECT assortment_node_id
      FROM   customer_assortment_node_tab
      WHERE  customer_no = customer_no_
      AND    assortment_id = assortment_id_  
      AND    assortment_node_id != assortment_node_id_
      AND    limit_sales_to_node = 'TRUE' ;   
BEGIN
   FOR rec_ IN get_restricted_nodes LOOP
      -- check whether the restricted node is a Parent node 
      dummy_ := Assortment_Node_API.Check_Node_Exist_As_Child(assortment_id_      => assortment_id_,
                                                              assortment_node_id_ => rec_.assortment_node_id ,
                                                              child_node_id_      => assortment_node_id_);
      IF (dummy_ = 1) THEN
          RETURN Fnd_Boolean_API.DB_TRUE;
      END IF;      
   END LOOP;   
     RETURN Fnd_Boolean_API.DB_FALSE;   
END Restricted_Parent_Node_Exists;

@IgnoreUnitTest DMLOperation
PROCEDURE Disable_Or_Enable_Child_Nodes(
   customer_no_         IN VARCHAR2,
   assortment_id_       IN VARCHAR2,
   assortment_node_id_  IN VARCHAR2,
   limit_sales_to_node_ IN VARCHAR2)
IS
   newrec_  customer_assortment_node_tab%ROWTYPE;
    CURSOR get_restricted_nodes IS
      SELECT *
      FROM   customer_assortment_node_tab
      WHERE  customer_no = customer_no_
      AND    assortment_id = assortment_id_   
      AND    assortment_node_id != assortment_node_id_
      AND    limit_sales_to_node = 'TRUE' ;   
   
 BEGIN
   FOR rec_ IN get_restricted_nodes LOOP
      IF (Assortment_Node_API.Check_Node_Exist_As_Child(assortment_id_,assortment_node_id_, rec_.assortment_node_id) = 1) THEN          
         newrec_ := rec_;
         newrec_.limit_sales_to_node := limit_sales_to_node_;
         Modify___(newrec_);
      END IF;     
   END LOOP;   
END Disable_Or_Enable_Child_Nodes;