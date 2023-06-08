-----------------------------------------------------------------------------
--
--  Logical unit: SourcingAlternative
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130709  MaRalk  TIBE-1032, Removed global LU constant inst_Supplier_ and modified Unpack_Check_Insert___, 
--  130709          Unpack_Check_Update___, Check_Vendor_Category___ methods accodingly.
--  100513  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060124  JaJalk  Added Assert safe annotation.
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040226  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------Version 13.3.0---------------------------------------------
--  031028  DaZa    Added extra check for valid supply codes in Unpack_Check_Insert___/Unpack_Check_Update___.
--  030820  GaSolk  Performed CR Merge(CR Only).
--  030815  JoAnSe  Corrected errormessages created for illegal rules.
--  030516  DaZa    Changed view comments on RULE_ID to Sourcing Rule.
--  030513  JoEd    Changed Supply (selection or code) null check.
--  030505  JoEd    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Priority___
--   Checks that a priority value hasn't been entered for the same rule already.
--   Displays an error message if the same priority is found.
PROCEDURE Check_Priority___ (
   rule_id_  IN VARCHAR2,
   line_no_  IN NUMBER,
   priority_ IN NUMBER )
IS
   CURSOR check_exist IS
      SELECT 1
      FROM SOURCING_ALTERNATIVE_TAB
      WHERE priority = priority_
      AND rule_id = rule_id_
      AND line_no != line_no_;
   dummy_ NUMBER;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      CLOSE check_exist;
      Error_SYS.Record_General(lu_name_, 'PRIOEXIST: Priority :P1 already exists for rule :P2.', priority_, rule_id_);
   ELSE
      CLOSE check_exist;
   END IF;
END Check_Priority___;


-- Check_Vendor_Category___
--   The supplier must be Internal or External depending on the supply code value.
--   Error message is displayed if wrong combination.
PROCEDURE Check_Vendor_Category___ (
   vendor_no_   IN VARCHAR2,
   supply_code_ IN VARCHAR2 )
IS
   category_ VARCHAR2(20) := NULL;
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(vendor_no_)); 
      IF (supply_code_ IN ('PD', 'PT')) THEN
         IF (nvl(category_, 'I') != 'E') THEN
            Error_SYS.Record_General(lu_name_, 'SUPPLIEREXT: :P1 is not an external supplier!', vendor_no_);
         END IF;
      ELSIF (supply_code_ IN ('IPD', 'IPT')) THEN
         IF (nvl(category_, 'E') != 'I') THEN
            Error_SYS.Record_General(lu_name_, 'SUPPLIERINT: :P1 is not an internal supplier!', vendor_no_);
         END IF;
      END IF;      
   $ELSE
       NULL;    
   $END
   
END Check_Vendor_Category___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SOURCING_ALTERNATIVE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
  CURSOR get_line_no IS
    SELECT nvl(max(line_no), 0) + 1
    FROM SOURCING_ALTERNATIVE_TAB
    WHERE rule_id = newrec_.rule_id;
BEGIN   
   OPEN get_line_no;
   FETCH get_line_no INTO newrec_.line_no;
   CLOSE get_line_no;
   IF (newrec_.line_no IS NULL) THEN
      newrec_.line_no := 1;
   END IF;
   Client_SYS.Add_To_Attr('LINE_NO', newrec_.line_no, attr_);
   Check_Priority___(newrec_.rule_id, newrec_.line_no, newrec_.priority);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SOURCING_ALTERNATIVE_TAB%ROWTYPE,
   newrec_     IN OUT SOURCING_ALTERNATIVE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (oldrec_.priority != newrec_.priority) THEN
      Check_Priority___(newrec_.rule_id, newrec_.line_no, newrec_.priority);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     sourcing_alternative_tab%ROWTYPE,
   newrec_ IN OUT sourcing_alternative_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   selection_   BOOLEAN := FALSE;
   force_empty_ BOOLEAN := FALSE;
BEGIN   
   selection_ := (newrec_.supplier_selection IS NOT NULL);
   
   IF (indrec_.supply_code) THEN   
      IF (newrec_.supply_code IS NOT NULL) THEN
         IF selection_ THEN
            force_empty_ := TRUE;
         ELSE
            Order_Supply_Type_API.Exist_Db(newrec_.supply_code);
         END IF;
      END IF;      
   END IF;
         
   IF (indrec_.vendor_no) THEN   
      IF (newrec_.vendor_no IS NOT NULL) THEN
         IF selection_ THEN
            force_empty_ := TRUE;
         ELSE
            $IF Component_Purch_SYS.INSTALLED $THEN
               Supplier_API.Exist(newrec_.vendor_no);           
            $ELSE
               NULL;    
            $END
         END IF;
      END IF;      
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (NOT selection_) THEN
      IF (newrec_.supply_code IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'SUPPLYSELECT: Either Supplier Selection or Supply code must be entered.');
      END IF;
      IF (newrec_.supply_code NOT IN ('IO', 'SO', 'PD', 'PT', 'IPD', 'IPT')) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDSUPPLYCODE: Supply Code :P1 is not a valid Supply Code here.', Order_Supply_Type_API.Decode(newrec_.supply_code));      
      END IF;
      IF (newrec_.supply_code IN ('PD', 'PT', 'IPD', 'IPT')) THEN
         Error_SYS.Check_Not_Null(lu_name_, 'VENDOR_NO', newrec_.vendor_no);
         Check_Vendor_Category___(newrec_.vendor_no, newrec_.supply_code);
      ELSIF (newrec_.vendor_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'VENDOR: Supplier may not be entered when supply code is Invent Order or Shop Order.');
      END IF;
   -- ... and not editable if supplier selection is chosen
   ELSE
      IF force_empty_ OR ((newrec_.supply_code IS NOT NULL) OR (newrec_.vendor_no IS NOT NULL)) THEN
         Error_SYS.Record_General(lu_name_, 'SUPPLYEMPTY: Supply Code and Supplier may not be entered when selection method is chosen.');
      END IF;
   END IF;
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   rule_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR exist_control IS
      SELECT 1
      FROM SOURCING_ALTERNATIVE_TAB
      WHERE rule_id = rule_id_;
   found_  NUMBER;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF exist_control%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Check_Exist;



