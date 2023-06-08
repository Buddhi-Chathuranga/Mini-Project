-----------------------------------------------------------------------------
--
--  Logical unit: AssortmentStructure
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210511  AyAmlk   PR21R2-170, STRATEGIC_PROCUREMENT: Override Check_Insert___ so that there is always a value for the mandatory column proc_category_assortment.
--  210115  SBalLK   Issue SC2020R1-11830, Modified Copy_Assortment() method by removing attr_ functionality to optimize the performance.
--  200702  LaDelk   PR2020R1-181, Handling deletion of AssortmentNodes when AssortmentStructure is removed.
--  200625  AyAmlk   PR2020R1-154, STRATEGIC_PROCUREMENT: Modified Copy_Assortment and Copy_Nodes_To_Assortment so that the copied from assortment
--  200625           PROC_CATEGORY_ASSORTMENT_DB is copied to the new assortment.
--  200624  AyAmlk   PR2020R1-51, STRATEGIC_PROCUREMENT: Modified Check_Update___ to prevent updating proc_category_assortment to FALSE when there are
--  200624           representatives or dimensions connected to the assortment.
--  170221  IsSalk   STRSC-6097, Added Copy_Nodes_To_Assortment() to copy node structure to an another assortment.
--  160307  ApWilk   Bug 127618, Indroduced a new parameter as insert_from_client_ in the Insert___() method and modified the Copy_Assortment() method
--  160307           in order to prevent the assortment node getting duplicated.
--  130731  UdGnlk   TIBE-827, Removed the dynamic code and modify to conditional compilation.
--  091001  ChFolk   Removed unused variables in the package.
--  ------------------------------ 14.0.0 --------------------------------------
--  111215  GanNLK   In the insert__ procedure, moved objversion to the bottom of the procedure.
--  090930  RiLase   Added campaign assortment connection check in Validate_Connected_Objects___.
--  090623  KiSalk   Modified Validate_Connected_Objects___ to check for connected SalesPriceList records.
--  081211  KiSalk   Added Customer_Assortment_Struct_API.Delete_Assortment_Connections call in Update___
--  081208  KiSalk   Added methods Get_Objstate, Validate_Connected_Objects___ and used in Finite_State_Set___.
--  081019  KiSalk   Made CLASSIFICATION_STANDARD to be copied in Copy_Assortment
--  080925  JeLise   Added new method Get_Parent_On_Level. 
--  080402  MaHplk   Modified Unpack_Check_Update___ to connect classification standard to any number of planned assortments.
--  080331  MaHplk   Reduce the number of characters used in error massage tag in Unpack_Check_Update___.
--  080328  MaHplk   Modified Check_Customer_Connected method.
--  080311  MaHplk   Added new method Check_Customer_Connected.
--  080310  MaHplk   Added validation on classification standard.
--  080306  KiSalk   Added view ASSORTMENT_CLASSIFICATION_LOV and method Get_Assort_For_Classification.
--  080304  MaHplk   Added classification_standard.
--  ----------------------------Nice Price--------------------------------------
--  070427  ChBalk   Added SUBSTR for Basic_Data_Translation_API.Get_Basic_Data_Translation returning value.
--  070212  MiErlk   Added Method Get_State.
--  070208  MiErlk   Added state diagram.
--  070206  ViWilk   Enable the LOV flag of Assortment Description in ASSORTMENT_STRUCTURE View
--  061220  KeFelk   Corrected minor linguistic errors.
--  061208  AmPalk   Made the State Change activity of an Assortment a blind process. Logic that was implemented has been removed.
--  061123  MiErlk   Added Method Get_Status.
--  061116  AmPalk   Made method Change_Status Private.
--  061113  MiErlk   Added Method Get_Description.
--  061111  AmPalk   Added History Records for the new and status change functionalities.
--  061109  AmPalk   Set Initial state to 'Planned' and added a Default Root for the structure and added method Change_Status.
--  061026  IsWiLK   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Insert___ (
   objid_               OUT NOCOPY    VARCHAR2,
   objversion_          OUT NOCOPY    VARCHAR2,
   newrec_              IN OUT NOCOPY assortment_structure_tab%ROWTYPE,
   attr_                IN OUT NOCOPY VARCHAR2,
   insert_from_client_  IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF (insert_from_client_) THEN
      Assortment_Node_API.Create_Sub_Node__(newrec_.assortment_id , newrec_.assortment_id, newrec_.description,NULL,NULL);
      Assortment_History_API.New(newrec_.assortment_id,'Assortment created in Planned state.');
      Assortment_Structure_Level_API.New(newrec_.assortment_id,1,'Root Level') ;
   END IF;
END Insert___;
   

@Override
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT assortment_structure_tab%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('EVENT', event_, attr_);
   super(rec_, event_, attr_);
   attr_ := Client_SYS.Remove_Attr('EVENT', attr_);
END Finite_State_Machine___;

-- Validate_Connected_Objects___
--   Check the connections with other LUs and raise errors.
PROCEDURE Validate_Connected_Objects___ (
   rec_  IN OUT assortment_structure_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   return_val_         NUMBER;
   event_              VARCHAR2(15);  
BEGIN
   event_  := Client_SYS.Get_Item_Value('EVENT', attr_); 
   $IF (Component_Order_SYS.INSTALLED) $THEN     
       return_val_ := Customer_Assortment_Struct_API.Check_Assort_Connected_Cust(rec_.assortment_id);   
      IF (return_val_ = 1) THEN
         IF (event_ = 'ChangeToPlanned') THEN
            Error_SYS.Record_General(lu_name_, 'NOTCHANGETOPLANNED: Assortment :P1 cannot be changed to status Planned as it is connected to the customer(s).', rec_.assortment_id);
         ELSIF (event_ = 'Close') THEN
            Error_SYS.Record_General(lu_name_, 'NOTCHANGETOCLOSED: Assortment :P1 cannot be closed as it is connected to the customer(s).', rec_.assortment_id);
         END IF;
      END IF;
      
      return_val_ := Customer_Agreement_API.Check_Active_Agree_Per_Assort(rec_.assortment_id);
      IF (return_val_ = 1) THEN
         IF (event_ = 'ChangeToPlanned') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOPLANNEDERAGR: Assortment :P1 cannot be changed to status Planned as it is connected to active customer agreement(s).', rec_.assortment_id);
         ELSIF (event_ = 'Close') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOCLOSEDERAGR: Assortment :P1 cannot be closed as it is connected to active customer agreement(s).', rec_.assortment_id);
         END IF;
      END IF;
      
      return_val_ := Campaign_API.Check_Active_Camp_Per_Assort(rec_.assortment_id);
      IF (return_val_ = 1) THEN
         IF (event_ = 'ChangeToPlanned') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOPLANNEDERCAM: Assortment :P1 cannot be changed to status Planned as it is connected to active campaign(s).', rec_.assortment_id);
         ELSIF (event_ = 'Close') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOCLOSEDERCAM: Assortment :P1 cannot be closed as it is connected to active campaign(s).', rec_.assortment_id);
         END IF;
      END IF;
      
      return_val_ := Sales_Price_List_API.Check_Records_Exist_Per_Assort(rec_.assortment_id);
      IF (return_val_ = 1) THEN
         IF (event_ = 'ChangeToPlanned') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOPLANNEDERSPL: Assortment :P1 cannot be changed to status Planned as it is connected to Sales Price List(s).', rec_.assortment_id);
         ELSIF (event_ = 'Close') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOCLOSEDERSPL: Assortment :P1 cannot be closed as it is connected to Sales Price List(s).', rec_.assortment_id);
         END IF;
      END IF;
      
      return_val_ := Cust_Hierarchy_Rebate_Attr_API.Check_Hierarchy_Reb_Per_Assort(rec_.assortment_id);
      IF (return_val_ = 1) THEN
         IF (event_ = 'ChangeToPlanned') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOPLANNEDERHIE: Assortment :P1 cannot be changed to status Planned as it is used in customer hierarchy rebate set-up.', rec_.assortment_id);
         ELSIF (event_ = 'Close') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOCLOSEDERRHIE: Assortment :P1 cannot be closed as it is used in customer hierarchy rebate set-up.', rec_.assortment_id);
         END IF;
      END IF;
      
      return_val_ := Rebate_Agreement_Assort_API.Check_Active_Deal_Per_Assort(rec_.assortment_id);
      IF (return_val_ = 1) THEN
         IF (event_ = 'ChangeToPlanned') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOPLANREBDEAL: Assortment :P1 cannot be changed to status Planned as it is connected to active rebate agreement(s).', rec_.assortment_id);
         ELSIF (event_ = 'Close') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOCLOSEREBDEAL: Assortment :P1 cannot be closed as it is connected to active rebate agreement(s).', rec_.assortment_id);
         END IF;
      END IF;
   $ELSE
      NULL;   
   $END
 
   $IF (Component_Disord_SYS.INSTALLED) $THEN
      return_val_ := Distribution_Allocation_API.Check_Active_Alloc_Per_Assort(rec_.assortment_id);  
      IF (return_val_ = 1) THEN
         IF (event_ = 'ChangeToPlanned') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOPLANERRDISAL: Assortment :P1 cannot be changed to status Planned as it is connected to active distribution allocation(s).', rec_.assortment_id);
         ELSIF (event_ = 'Close') THEN
            Error_SYS.Record_General(lu_name_, 'CHANGETOCLOSEDDISALL: Assortment :P1 cannot be closed as it is connected to active distribution allocation(s).', rec_.assortment_id);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Connected_Objects___;


PROCEDURE Create_Assortment_History___ (
   rec_  IN OUT NOCOPY assortment_structure_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS   
    message_    VARCHAR2(2000);
    event_      VARCHAR2(15);
BEGIN
   event_  := Client_Sys.Get_Item_Value('EVENT', attr_);  
   IF event_ IS NOT NULL THEN 
      CASE
         WHEN (rec_.rowstate = 'Planned') THEN
            message_ := 'Status changed to Planned.';   
         WHEN (rec_.rowstate = 'Closed') THEN
            message_ := 'Status changed to Closed.';
         WHEN (rec_.rowstate = 'Active') THEN
            message_ := 'Status changed to Active.';
      END CASE;

      Assortment_History_API.New(rec_.assortment_id, message_);  
   END IF;   
   
END Create_Assortment_History___;


PROCEDURE Validate_Classification___ (
   rec_  IN OUT NOCOPY assortment_structure_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   
BEGIN
   IF Get_Assort_For_Classification(rec_.classification_standard) IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'DUPLICATESTD: Classification standard :P1 cannot be defined for more than one active assortment.', rec_.classification_standard);
   END IF;
END Validate_Classification___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     assortment_structure_tab%ROWTYPE,
   newrec_     IN OUT assortment_structure_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS   
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Update Data in Basic Data Translations tab
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT',
                                                            'AssortmentStructure',
                                                            newrec_.assortment_id,
                                                            NULL,
                                                            newrec_.description,
                                                            oldrec_.description);
   
   $IF (Component_Order_SYS.INSTALLED) $THEN
      IF (NVL(oldrec_.classification_standard, Database_SYS.string_null_) != NVL(newrec_.classification_standard, Database_SYS.string_null_)) THEN      
         Customer_Assortment_Struct_API.Update_Assortment_Connections(newrec_.assortment_id, newrec_.classification_standard);     
      END IF;
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     assortment_structure_tab%ROWTYPE,
   newrec_ IN OUT assortment_structure_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF newrec_.classification_standard IS NOT NULL THEN
      IF newrec_.rowstate != 'Planned' AND Get_Assort_For_Classification(newrec_.classification_standard) IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'DUPLICATESTD: Classification standard :P1 cannot be defined for more than one active assortment.',newrec_.classification_standard);
      END IF;

      IF (Assortment_Node_API.Classification_Parts_Exist(newrec_.assortment_id) = 1) THEN
         Error_SYS.Record_General(lu_name_, 'MODIFYSTDERR: The classification standard cannot be removed or modified as the classification part number has been defined for the connected part in the given assortment.');
      END IF;
   END IF;
   
   -- STRATEGIC_PROCUREMENT: start
   $IF (Component_Srm_SYS.INSTALLED) $THEN
   -- If there are connected dimensions or representative setup in any of the assortment nodes, it is not allowed to set proc_category_assortment to FALSE.
   IF indrec_.proc_category_assortment AND newrec_.proc_category_assortment = Fnd_Boolean_API.DB_FALSE THEN
      IF Proc_Category_Manager_API.Dimension_Connection_Exists(newrec_.assortment_id) OR Proc_Cat_Representative_API.Rep_Setup_Connection_Exists(newrec_.assortment_id) THEN
         Error_SYS.Record_General(lu_name_, 'CANNOT_MODIFY: Cannot set Procurement Category Assortment to false when there are dimension(s) / Representative(s) connected.');
      END IF;
   END IF;
   $END
   -- STRATEGIC_PROCUREMENT: end
   
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN assortment_structure_tab%ROWTYPE )
IS
BEGIN
   Assortment_Node_API.Remove_Root_Node(remrec_.assortment_id);
   super(objid_, remrec_);
END Delete___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT NOCOPY assortment_structure_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF NOT indrec_.proc_category_assortment THEN
      newrec_.proc_category_assortment := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   super(newrec_, indrec_, attr_);
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   assortment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ assortment_structure_tab.description%TYPE;
BEGIN
   IF (assortment_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', 'AssortmentStructure',
              assortment_id), description), 1, 200)
      INTO  temp_
      FROM  assortment_structure_tab
      WHERE assortment_id = assortment_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(assortment_id_, 'Get_Description');
END Get_Description;



PROCEDURE Copy_Assortment (
   assortment_id_ IN VARCHAR2,
   new_assort_id_ IN VARCHAR2,
   new_description_ IN VARCHAR2 DEFAULT NULL )
IS
   attr_                      VARCHAR2(2000);
   objid_                     assortment_structure.objid%TYPE;
   objversion_                assortment_structure.objversion%TYPE;
   newrec_                    assortment_structure_tab%ROWTYPE;
   indrec_                    Indicator_Rec;
   copy_from_assort_struct_   assortment_structure_tab%ROWTYPE;

   CURSOR get_assort_nodes IS
      SELECT assortment_node_id
      FROM assortment_node_tab
      WHERE assortment_id = assortment_id_;

   CURSOR get_assort_levels IS
      SELECT structure_level
      FROM  assortment_structure_level_tab
      WHERE assortment_id = assortment_id_;
BEGIN
   copy_from_assort_struct_         := Get_Object_By_Keys___(assortment_id_);
   newrec_.assortment_id            := new_assort_id_;
   newrec_.description              := new_description_;
   newrec_.classification_standard  := copy_from_assort_struct_.classification_standard;
   -- STRATEGIC_PROCUREMENT: start
   newrec_.proc_category_assortment := copy_from_assort_struct_.proc_category_assortment;
   -- STRATEGIC_PROCUREMENT: end
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_,FALSE);
   
   Assortment_History_API.New(newrec_.assortment_id,'Assortment '||newrec_.assortment_id||' created in Planned state as a copy of assortment '||assortment_id_||'.');

   FOR nodes_rec_ IN get_assort_nodes LOOP
       Assortment_Node_API.Copy_Node(assortment_id_,nodes_rec_.assortment_node_id,new_assort_id_,nodes_rec_.assortment_node_id, NULL);
   END LOOP;

   FOR levels_rec_ IN get_assort_levels LOOP
       Assortment_Structure_Level_API.Copy_Level(assortment_id_,levels_rec_.structure_level,new_assort_id_,levels_rec_.structure_level);
   END LOOP;
END Copy_Assortment;


@UncheckedAccess
FUNCTION Get_Assort_For_Classification (
   classification_standard_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ assortment_structure_tab.assortment_id%TYPE;
   CURSOR get_attr IS
      SELECT assortment_id
      FROM assortment_structure_tab
      WHERE ROWSTATE  = 'Active'
      AND   classification_standard  = classification_standard_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Assort_For_Classification;


@UncheckedAccess
FUNCTION Check_Customer_Connected (
   assortment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   return_val_         NUMBER;
   stmt_               VARCHAR2(2000);
BEGIN
   stmt_ :='BEGIN
                :return_val := Customer_Assortment_Struct_API.Check_Assort_Connected_Cust(:assortment_id);
             END;';
     @ApproveDynamicStatement(2008-03-28,MaHplk)
     EXECUTE IMMEDIATE stmt_
        USING OUT return_val_,
              IN  assortment_id_;      
   RETURN return_val_;
END Check_Customer_Connected;


@UncheckedAccess
FUNCTION Get_Parent_On_Level (
   assortment_id_   IN VARCHAR2,
   structure_level_ IN NUMBER,
   part_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   parent_node_id_   VARCHAR2(50);
   child_level_no_   NUMBER;
   level_count_      NUMBER;
BEGIN
   -- Check whether this node exists in the assortment
   IF (Assortment_Node_API.Is_Part_Belongs_To_Node(assortment_id_, part_no_, part_no_)) = 1 THEN
      child_level_no_ := Assortment_Node_API.Get_Level_No(assortment_id_, part_no_);
      -- Then we should traverse till the agreement header defined level
      parent_node_id_ := part_no_;
      level_count_ := child_level_no_ - structure_level_;
      WHILE (level_count_ > 0 ) LOOP
         parent_node_id_ := Assortment_Node_API.Get_Parent_Node(assortment_id_, parent_node_id_);
         level_count_ := level_count_ - 1;
      END LOOP;
   END IF;
   RETURN parent_node_id_;
END Get_Parent_On_Level;


-- Copy_Nodes_To_Assortment
--    Copy node structure to an another assortment.
PROCEDURE Copy_Nodes_To_Assortment (
   from_assortment_id_        IN VARCHAR2,
   from_assortment_node_id_   IN VARCHAR2, 
   to_assortment_id_          IN VARCHAR2,
   to_assortment_desc_        IN VARCHAR2,
   to_assort_node_id_         IN VARCHAR2,
   create_new_assortment_     IN VARCHAR2 )
IS
   newrec_                    assortment_structure_tab%ROWTYPE;
   copy_from_assort_struct_   assortment_structure_tab%ROWTYPE;
BEGIN
   IF (create_new_assortment_ = Fnd_Boolean_API.DB_TRUE) THEN
      IF (Check_Exist___(to_assortment_id_)) THEN
         Error_SYS.Record_General(lu_name_, 'ASSORTEXIST: The Assortment Structure Already Exist.');
      END IF;
      newrec_.assortment_id := to_assortment_id_;
      newrec_.description := to_assortment_desc_;
      copy_from_assort_struct_ := Get_Object_By_Keys___(from_assortment_id_);
      newrec_.classification_standard := copy_from_assort_struct_.classification_standard;
      -- STRATEGIC_PROCUREMENT: start
      newrec_.proc_category_assortment := copy_from_assort_struct_.proc_category_assortment;
      -- STRATEGIC_PROCUREMENT: end
      New___(newrec_);
   ELSE
      Exist(to_assortment_id_);
   END IF;
   
   Assortment_Node_API.Copy_Node_Structure(from_assortment_id_, from_assortment_node_id_, to_assortment_id_, to_assortment_desc_, to_assort_node_id_, create_new_assortment_);

END Copy_Nodes_To_Assortment;


