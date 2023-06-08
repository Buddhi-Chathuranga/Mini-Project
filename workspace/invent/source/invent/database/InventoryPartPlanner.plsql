-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartPlanner
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160622  ChFolk  STRSC-1953, Removed some overrides which was done to support blocked_for_use as it is now supported with datavalidity.
--  130801  MaRalk  TIBE-881, Removed global LU constant inst_EngTransferSiteRole_   
--  130801          and modified Exist_As_Default_Planner, Modify_Default_Planner 
--  130801          using conditional compilation instead.
--  100507  KRPELK  Merge Rose Method Documentation.
--  100107  Umdolk  Refactoring in Communication Methods in Enterprise.
--  090930  ChFolk  Removed unused variables in the package.
--  ------------------------------- 14.0.0 ----------------------------------
--  090606  PraWlk  Bug 83548, Modified Unpack_Check_Insert___ by assigning FALSE for blocked_for_use
--  090606          attibute when it is NULL.
--  090511  PraWlk  Bug 81853, Added new parameter error_when_blocked_ in Exist.
--  090319   PraWlk  Bug 77435, Added column blocked_for_use to INVENTORY_PART_PLANNER view and 
--  090319          modified INVENTORY_PART_PLANNER_LOV view. Added Get_Blocked_For_Use,
--  090319          Get_Blocked_For_Use_Db, Exist_As_Default_Planner and Modify_Default_Planner.  
--  090319          Modified Exist to validate BUYER_CODE.
--  060119  SeNslk  Modified the template version as 2.3 and added UNDEFINE 
--  060119          according to the new template.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  -------------------------------------- 13.3.0 ---------------------------
--  020212  MKrase  Bug fix 27884, Removed UPPERCASE for buyer_name in VIEW_LOV.
--  000925  JOHESE  Added undefines.
--  000417  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc
--                  and Replace_Person_Id.
--  990709  MATA    Changed substr to substrb in VIEW definitions
--  990602  ROOD    Added pseudo column planner_buyer in view (for zoom functionality).
--  990602  JakH    Changed Replace_Person_Id for ENTKIT.
--  990512  JakH    Added Replace_Person_Id for ENTKIT.
--  990421  JOHW    General performance improvements.
--  990409  JOHW    Upgraded to performance optimized template.
--  990305  ANHO    Removed uppercase on planner title.
--  990224  ANHO    Changed name on prompts from buyer to planner.
--  990127  TOBE    Added /NOCHECK on ref to PersonInfo in VIEW_LOV.
--  981230  TOBE    Name and phone is now stored in PersonInfo, public get_methods preserved.
--  971201  GOPE    Upgrade to fnd 2.0
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970312  MAGN    Changed tablename from buyer_list to inventory_part_planner_tab.
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  970122  JOKE    Modified prompts on columns in view to Planner instead of Buyer.
--  961214  AnAr    Modified file for new template standard.
--  961105  MAOR    Modified file to Rational Rose Model-standard.
--  960307  JICE    Renamed from InvBuyerList
--  951012  SHR     Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Exist_As_Default_Planner (
   buyer_code_     IN VARCHAR2) RETURN VARCHAR2
IS
   exist_      VARCHAR2(5) := 'FALSE'; 
BEGIN
   exist_ := User_Default_API.Default_Role_Exist(buyer_code_, 'PLANNER');
   IF (exist_ = 'FALSE') THEN
      $IF Component_Mfgstd_SYS.INSTALLED $THEN
         exist_ := Eng_Transfer_Site_Role_API.Default_Planner_Exist(buyer_code_); 
      $ELSE
         NULL;    
      $END
   END IF;
   RETURN exist_;
END Exist_As_Default_Planner;


PROCEDURE Modify_Default_Planner (
   old_buyer_code_   IN  VARCHAR2,
   new_buyer_code_   IN  VARCHAR2)
IS    
BEGIN
   User_Default_Api.Modify_Default_Role(old_buyer_code_, new_buyer_code_, 'PLANNER');
   $IF Component_Mfgstd_SYS.INSTALLED $THEN
      Eng_Transfer_Site_Role_API.Modify_Default_Planner(old_buyer_code_, new_buyer_code_); 
   $END
END Modify_Default_Planner;


-- Get_Control_Type_Value_Desc
--   Procedure to get description for accounting rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   description_ := Get_Buyer_Name(value_);
END Get_Control_Type_Value_Desc;


-- Get_Buyer_Name
--   Gets the name from Person Info.
@UncheckedAccess
FUNCTION Get_Buyer_Name (
   buyer_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Person_Info_API.Get_Name(buyer_code_);
END Get_Buyer_Name;


-- Get_Buyer_Extension
--   Gets the phone number from Person Info.
@UncheckedAccess
FUNCTION Get_Buyer_Extension (
   buyer_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Comm_Method_API.Get_Default_Value('PERSON', buyer_code_, 'PHONE');
END Get_Buyer_Extension;


-- Replace_Person_Id
--   The procedure does not really replace any person data, instead it works
--   like this: it ads a person-id if its not already in the list of active
--   salesmen. The title of the old planner is copied to the new guy.
FUNCTION Replace_Person_Id (
   new_person_id_ IN VARCHAR2,
   old_person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_        VARCHAR2(500);
   newrec_      INVENTORY_PART_PLANNER_TAB%ROWTYPE;
   oldrec_      INVENTORY_PART_PLANNER_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   IF new_person_id_ = old_person_id_ THEN
      -- no need to change, either neither exists or both
      RETURN 'TRUE';
   END IF;

   IF check_exist___(new_person_id_) THEN
      -- ok he's already here don't do anything
      RETURN 'FALSE';
   ELSIF (NOT check_exist___(old_person_id_)) THEN
      -- the old guy is nonexisting so the new guy is not really a planner
      RETURN 'TRUE';
   ELSE
      -- get old data to copy
      oldrec_ := Get_Object_By_Keys___ (old_person_id_);
      -- add new_person_id
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('BUYER_CODE', new_person_id_ , attr_);
      Client_SYS.Add_To_Attr('BUYER_TITLE',  oldrec_.buyer_title, attr_);      
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      RETURN 'TRUE';
   END IF;
END Replace_Person_Id;

