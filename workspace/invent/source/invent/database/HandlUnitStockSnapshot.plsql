-----------------------------------------------------------------------------
--
--  Logical unit: HandlUnitStockSnapshot
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210518  ChWkLk  MFZ-7568, Modified Insert_Snapshot() to improve performance by eliminating redundant server calls
--  210518          during handling unit insertion and removed Update_Records___().
--  180815  ChFolk  SCUXXW4-6502, Added new method Get_Id_Version_By_Keys as a public interface which returns objid- and version.
--  170525  UdGnlk  STRSC-8457, Added method Handling_Unit_Exist() to check of existance
--  170525          for a source reference and handling unit in the snapshot.  
--  170503  Chfose  LIM-11458, Added new convenience method for getting a outermost hu id 
--  170503          and also disconnecting its parent (Get_Outerm_Hu_And_Disc_Parent).
--  170227  KhVese  LIM-5836, Added method Get_Object_By_Id. 
--  170123	Jhalse  LIM-10150, Added method Remove_Handling_Unit.
--  161219  Chfose  LIM-10070, Added Modify_Process_Control methods.
--  160307  Chfose  LIM-6169, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


TYPE Handl_Unit_Stock_Rec IS RECORD (handling_unit_id     NUMBER,
                                     contract             VARCHAR2(5),
                                     location_no          VARCHAR2(35),
                                     outermost            VARCHAR2(5),
                                     outermost_hu_id      NUMBER);
                                              
TYPE Handl_Unit_Stock_Tab IS TABLE OF Handl_Unit_Stock_Rec INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


PROCEDURE Insert_Records___ (
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref5_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2,
   handl_unit_stock_tab_   IN Handl_Unit_Stock_Tab )
IS
BEGIN
   Handl_Unit_Snapshot_Type_API.Exist_Db(source_ref_type_db_);
   
   IF (handl_unit_stock_tab_.COUNT > 0) THEN
      FORALL i IN handl_unit_stock_tab_.FIRST .. handl_unit_stock_tab_.LAST
         INSERT INTO handl_unit_stock_snapshot_tab
            (source_ref1,
             source_ref2,
             source_ref3,
             source_ref4,
             source_ref5,
             source_ref_type,
             handling_unit_id,
             contract,
             location_no,
             outermost,
             outermost_hu_id,
             rowversion,
             rowkey)
         VALUES
            (source_ref1_,
             source_ref2_,
             source_ref3_,
             source_ref4_,
             source_ref5_,
             source_ref_type_db_,
             handl_unit_stock_tab_(i).handling_unit_id,
             handl_unit_stock_tab_(i).contract,
             handl_unit_stock_tab_(i).location_no,
             handl_unit_stock_tab_(i).outermost,
             handl_unit_stock_tab_(i).outermost_hu_id,
             sysdate,
             sys_guid());
   END IF;
END Insert_Records___;


PROCEDURE Delete_Records___ (
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref5_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2,
   handl_unit_stock_tab_   IN Handl_Unit_Stock_Tab )
IS
BEGIN
   IF (handl_unit_stock_tab_.COUNT > 0) THEN
      FORALL i IN handl_unit_stock_tab_.FIRST .. handl_unit_stock_tab_.LAST
         DELETE FROM handl_unit_stock_snapshot_tab
               WHERE source_ref1       = source_ref1_
                 AND source_ref2       = source_ref2_
                 AND source_ref3       = source_ref3_
                 AND source_ref4       = source_ref4_
                 AND source_ref5       = source_ref5_
                 AND source_ref_type   = source_ref_type_db_
                 AND handling_unit_id  = handl_unit_stock_tab_(i).handling_unit_id
                 AND contract          = handl_unit_stock_tab_(i).contract
                 AND location_no       = handl_unit_stock_tab_(i).location_no;
   END IF;
END Delete_Records___;


PROCEDURE Delete_Snapshot___ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS
BEGIN
   DELETE FROM handl_unit_stock_snapshot_tab
         WHERE source_ref1       = source_ref1_
           AND source_ref2       = source_ref2_
           AND source_ref3       = source_ref3_
           AND source_ref4       = source_ref4_
           AND source_ref5       = source_ref5_
           AND source_ref_type   = source_ref_type_db_;
END Delete_Snapshot___;


FUNCTION Get_Old_Snapshot___ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 ) RETURN Handl_Unit_Stock_Tab
IS
   CURSOR get_old_snapshot IS
      SELECT handling_unit_id, contract, location_no, outermost, outermost_hu_id
        FROM handl_unit_stock_snapshot_tab
       WHERE source_ref1      = source_ref1_
         AND source_ref2      = source_ref2_
         AND source_ref3      = source_ref3_
         AND source_ref4      = source_ref4_
         AND source_ref5      = source_ref5_
         AND source_ref_type  = source_ref_type_db_;
         
   old_snapshot_tab_    Handl_Unit_Stock_Tab;
BEGIN
   OPEN get_old_snapshot;
   FETCH get_old_snapshot BULK COLLECT INTO old_snapshot_tab_;
   CLOSE get_old_snapshot;
   
   RETURN(old_snapshot_tab_);
END Get_Old_Snapshot___;


-- Compares two collections to find out which records exists in new_handl_unit_stock_tab_ that
-- does not exist in old_handl_unit_stock_tab_.
FUNCTION Get_Added_Records___ (
   new_handl_unit_stock_tab_  IN Handl_Unit_Stock_Tab,
   old_handl_unit_stock_tab_  IN Handl_Unit_Stock_Tab ) RETURN Handl_Unit_Stock_Tab
IS
   index_                        NUMBER := 1;
   added_handl_unit_stock_tab_   Handl_Unit_Stock_Tab;
BEGIN
   IF (old_handl_unit_stock_tab_.COUNT = 0) THEN
      added_handl_unit_stock_tab_ := new_handl_unit_stock_tab_;
   ELSIF (new_handl_unit_stock_tab_.COUNT > 0) THEN
      <<outer>>
      FOR i IN new_handl_unit_stock_tab_.FIRST .. new_handl_unit_stock_tab_.LAST LOOP      
         FOR j IN old_handl_unit_stock_tab_.FIRST .. old_handl_unit_stock_tab_.LAST LOOP
            
            IF (new_handl_unit_stock_tab_(i).handling_unit_id = old_handl_unit_stock_tab_(j).handling_unit_id) THEN
               IF (new_handl_unit_stock_tab_(i).handling_unit_id != 0) THEN
                  CONTINUE outer;
               ELSIF (new_handl_unit_stock_tab_(i).contract    = old_handl_unit_stock_tab_(j).contract AND 
                      new_handl_unit_stock_tab_(i).location_no = old_handl_unit_stock_tab_(j).location_no) THEN
                  CONTINUE outer;
               END IF;
            END IF;
            
         END LOOP;
         added_handl_unit_stock_tab_(index_) := new_handl_unit_stock_tab_(i);
         index_ := index_ + 1;
      END LOOP;
   END IF;
   
   RETURN(added_handl_unit_stock_tab_);
END Get_Added_Records___;


-- Compares two collections to find out which records exists in both collections but 
-- have had its data modified (i.e. the outermost_hu_id has changed or it's on another location etc.)
FUNCTION Get_Updated_Records___ (
   new_handl_unit_stock_tab_  IN Handl_Unit_Stock_Tab,
   old_handl_unit_stock_tab_  IN Handl_Unit_Stock_Tab ) RETURN Handl_Unit_Stock_Tab
IS
   index_                        NUMBER := 1;
   updated_handl_unit_stock_tab_ Handl_Unit_Stock_Tab;
BEGIN
   IF (new_handl_unit_stock_tab_.COUNT > 0 AND old_handl_unit_stock_tab_.COUNT > 0) THEN
      <<outer>>
      FOR i IN new_handl_unit_stock_tab_.FIRST .. new_handl_unit_stock_tab_.LAST LOOP        
         FOR j IN old_handl_unit_stock_tab_.FIRST .. old_handl_unit_stock_tab_.LAST LOOP
            
            IF (new_handl_unit_stock_tab_(i).handling_unit_id != 0 AND 
                new_handl_unit_stock_tab_(i).handling_unit_id = old_handl_unit_stock_tab_(j).handling_unit_id) THEN
                
               IF (new_handl_unit_stock_tab_(i).contract                != old_handl_unit_stock_tab_(j).contract     OR
                   new_handl_unit_stock_tab_(i).location_no             != old_handl_unit_stock_tab_(j).location_no  OR
                   new_handl_unit_stock_tab_(i).outermost               != old_handl_unit_stock_tab_(j).outermost    OR
                   NVL(new_handl_unit_stock_tab_(i).outermost_hu_id, 0) != NVL(old_handl_unit_stock_tab_(j).outermost_hu_id, 0)) THEN
                  updated_handl_unit_stock_tab_(index_) := new_handl_unit_stock_tab_(i);
                  index_ := index_ + 1;
               END IF;
               CONTINUE outer;
               
            END IF;
            
         END LOOP;       
      END LOOP;
   END IF;
   
   RETURN(updated_handl_unit_stock_tab_);
END Get_Updated_Records___;


-- Compares two collections to find out which records exists in old_handl_unit_stock_tab_ that
-- does not no longer exist in new_handl_unit_stock_tab_.
FUNCTION Get_Deleted_Records___ (
   new_handl_unit_stock_tab_  IN Handl_Unit_Stock_Tab,
   old_handl_unit_stock_tab_  IN Handl_Unit_Stock_Tab ) RETURN Handl_Unit_Stock_Tab
IS
   index_                        NUMBER := 1;
   removed_handl_unit_stock_tab_ Handl_Unit_Stock_Tab;
BEGIN
   IF (new_handl_unit_stock_tab_.COUNT = 0) THEN
      removed_handl_unit_stock_tab_ := old_handl_unit_stock_tab_;
   ELSIF (old_handl_unit_stock_tab_.COUNT > 0) THEN
      <<outer>>
      FOR i IN old_handl_unit_stock_tab_.FIRST .. old_handl_unit_stock_tab_.LAST LOOP
         FOR j IN new_handl_unit_stock_tab_.FIRST .. new_handl_unit_stock_tab_.LAST LOOP
            
            IF (old_handl_unit_stock_tab_(i).handling_unit_id = new_handl_unit_stock_tab_(j).handling_unit_id) THEN
               IF (old_handl_unit_stock_tab_(i).handling_unit_id != 0) THEN
                  CONTINUE outer;
               ELSIF (old_handl_unit_stock_tab_(i).contract    = new_handl_unit_stock_tab_(j).contract AND 
                      old_handl_unit_stock_tab_(i).location_no = new_handl_unit_stock_tab_(j).location_no) THEN
                  CONTINUE outer;
               END IF;
            END IF;
            
         END LOOP;   
         removed_handl_unit_stock_tab_(index_) := old_handl_unit_stock_tab_(i);
         index_ := index_ + 1;
      END LOOP;
   END IF;
   
   RETURN(removed_handl_unit_stock_tab_);
END Get_Deleted_Records___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-- Inserts a new snapshot into the table.
PROCEDURE Insert_Snapshot (
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref5_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2,
   handl_unit_stock_tab_   IN Handl_Unit_Stock_Tab )
IS
BEGIN
   Delete_Snapshot___(source_ref1_,
                      source_ref2_,
                      source_ref3_,
                      source_ref4_,
                      source_ref5_,
                      source_ref_type_db_);

   Insert_Records___(source_ref1_,
                     source_ref2_,
                     source_ref3_,
                     source_ref4_,
                     source_ref5_,
                     source_ref_type_db_,
                     handl_unit_stock_tab_); 
END Insert_Snapshot;


PROCEDURE Delete_Snapshot (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS
BEGIN
   Delete_Snapshot___(source_ref1_,
                      source_ref2_,
                      source_ref3_,
                      source_ref4_,
                      source_ref5_,
                      source_ref_type_db_);
END Delete_Snapshot;


PROCEDURE Delete_Old_Snapshots (
   source_ref_type_db_  IN VARCHAR2,
   amount_of_days_      IN NUMBER )
IS
BEGIN
   DELETE FROM handl_unit_stock_snapshot_tab
      WHERE source_ref_type   = source_ref_type_db_
        AND rowversion < sysdate - amount_of_days_;
END Delete_Old_Snapshots;


@UncheckedAccess
FUNCTION Snapshot_Exist (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Snapshot_Exist(source_ref1_        => source_ref1_,
                         source_ref2_        => '*',
                         source_ref3_        => '*',
                         source_ref4_        => '*',
                         source_ref5_        => '*',
                         source_ref_type_db_ => source_ref_type_db_);
END Snapshot_Exist;


@UncheckedAccess
FUNCTION Snapshot_Exist (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   snapshot_exist_ BOOLEAN := FALSE;
   
   CURSOR check_exist IS
      SELECT 1
      FROM  handl_unit_stock_snapshot_tab
      WHERE source_ref1       = source_ref1_
      AND   source_ref2       = source_ref2_
      AND   source_ref3       = source_ref3_
      AND   source_ref4       = source_ref4_
      AND   source_ref5       = source_ref5_
      AND   source_ref_type   = source_ref_type_db_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      snapshot_exist_ := TRUE;
   END IF;
   CLOSE check_exist;
   
   RETURN snapshot_exist_;
END Snapshot_Exist;


@UncheckedAccess
FUNCTION Get_Outermost_Db (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Outermost_Db(source_ref1_         => source_ref1_,
                           source_ref2_         => '*',
                           source_ref3_         => '*',
                           source_ref4_         => '*',
                           source_ref5_         => '*',
                           source_ref_type_db_  => source_ref_type_db_,
                           handling_unit_id_    => handling_unit_id_);
END Get_Outermost_Db;


@UncheckedAccess
FUNCTION Get_Outermost_Db (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER ) RETURN VARCHAR2
IS
   outermost_  VARCHAR2(5);
   
   CURSOR get_outermost IS
      SELECT outermost
      FROM  handl_unit_stock_snapshot_tab
      WHERE source_ref1       = source_ref1_
      AND   source_ref2       = source_ref2_
      AND   source_ref3       = source_ref3_
      AND   source_ref4       = source_ref4_
      AND   source_ref5       = source_ref5_
      AND   source_ref_type   = source_ref_type_db_
      AND   handling_unit_id  = handling_unit_id_;
BEGIN
   OPEN get_outermost;
   FETCH get_outermost INTO outermost_;
   CLOSE get_outermost;
   
   RETURN outermost_;
END Get_Outermost_Db;


@UncheckedAccess
FUNCTION Get_Outermost_Hu_Id (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Outermost_Hu_Id(source_ref1_         => source_ref1_,
                              source_ref2_         => '*',
                              source_ref3_         => '*',
                              source_ref4_         => '*',
                              source_ref5_         => '*',
                              source_ref_type_db_  => source_ref_type_db_,
                              handling_unit_id_    => handling_unit_id_);
END Get_Outermost_Hu_Id;


@UncheckedAccess
FUNCTION Get_Outermost_Hu_Id (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER ) RETURN NUMBER
IS
   outermost_hu_id_  NUMBER;
   
   CURSOR get_outermost_hu_id IS
      SELECT outermost_hu_id
      FROM  handl_unit_stock_snapshot_tab
      WHERE source_ref1       = source_ref1_
      AND   source_ref2       = source_ref2_
      AND   source_ref3       = source_ref3_
      AND   source_ref4       = source_ref4_
      AND   source_ref5       = source_ref5_
      AND   source_ref_type   = source_ref_type_db_
      AND   handling_unit_id  = handling_unit_id_;
BEGIN
   OPEN get_outermost_hu_id;
   FETCH get_outermost_hu_id INTO outermost_hu_id_;
   CLOSE get_outermost_hu_id;
   
   RETURN outermost_hu_id_;
END Get_Outermost_Hu_Id;


-- Gets the Outermost Handling Unit Id and also disconnects it from its parent if there is any.
FUNCTION Get_Outerm_Hu_And_Disc_Parent (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Outerm_Hu_And_Disc_Parent(source_ref1_         => source_ref1_,
                                        source_ref2_         => '*',
                                        source_ref3_         => '*',
                                        source_ref4_         => '*',
                                        source_ref5_         => '*',
                                        source_ref_type_db_  => source_ref_type_db_,
                                        handling_unit_id_    => handling_unit_id_);
END Get_Outerm_Hu_And_Disc_Parent;


-- Gets the Outermost Handling Unit Id and also disconnects it from its parent if there is any.
FUNCTION Get_Outerm_Hu_And_Disc_Parent (
    source_ref1_        IN VARCHAR2,
    source_ref2_        IN VARCHAR2,
    source_ref3_        IN VARCHAR2,
    source_ref4_        IN VARCHAR2,
    source_ref5_        IN VARCHAR2,
    source_ref_type_db_ IN VARCHAR2,
    handling_unit_id_   IN NUMBER ) RETURN NUMBER
IS
   outermost_hu_id_     NUMBER;
BEGIN
   outermost_hu_id_ := Get_Outermost_Hu_Id(source_ref1_         => source_ref1_,
                                           source_ref2_         => source_ref2_,
                                           source_ref3_         => source_ref3_,
                                           source_ref4_         => source_ref4_,
                                           source_ref5_         => source_ref5_,
                                           source_ref_type_db_  => source_ref_type_db_,
                                           handling_unit_id_    => handling_unit_id_);
                                           
   IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(outermost_hu_id_) IS NOT NULL) THEN
      Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_        => outermost_hu_id_, 
                                                       parent_handling_unit_id_ => NULL);
   END IF;
   
   RETURN outermost_hu_id_;
END Get_Outerm_Hu_And_Disc_Parent;


@UncheckedAccess
FUNCTION Handling_Unit_Exist (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Handling_Unit_Exist(source_ref1_         => source_ref1_,
                              source_ref2_         => '*',
                              source_ref3_         => '*',
                              source_ref4_         => '*',
                              source_ref5_         => '*',
                              source_ref_type_db_  => source_ref_type_db_,
                              handling_unit_id_    => handling_unit_id_);
END Handling_Unit_Exist;


@UncheckedAccess
FUNCTION Handling_Unit_Exist (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
      INTO  dummy_
      FROM  handl_unit_stock_snapshot_tab
      WHERE source_ref1       = source_ref1_
      AND   source_ref2       = source_ref2_
      AND   source_ref3       = source_ref3_
      AND   source_ref4       = source_ref4_
      AND   source_ref5       = source_ref5_
      AND   source_ref_type   = source_ref_type_db_
      AND   handling_unit_id  = handling_unit_id_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
END Handling_Unit_Exist;


@UncheckedAccess
FUNCTION Handling_Unit_Exist (   
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
      INTO  dummy_
      FROM  handl_unit_stock_snapshot_tab
      WHERE source_ref1       IS NOT NULL      
      AND   source_ref_type   = source_ref_type_db_
      AND   handling_unit_id  = handling_unit_id_;
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Handling_Unit_Exist;

@UncheckedAccess
PROCEDURE Remove_Handling_Unit (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER )
IS
BEGIN
   Remove_Handling_Unit(source_ref1_         => source_ref1_,
                        source_ref2_         => '*',
                        source_ref3_         => '*',
                        source_ref4_         => '*',
                        source_ref5_         => '*',
                        source_ref_type_db_  => source_ref_type_db_,
                        handling_unit_id_    => handling_unit_id_);
END Remove_Handling_Unit;


@UncheckedAccess
PROCEDURE Remove_Handling_Unit (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER )
IS
   CURSOR get_handling_units_ IS
      SELECT *
        FROM  handl_unit_stock_snapshot_tab huss
       WHERE huss.source_ref1       = source_ref1_
       AND   huss.source_ref2       = source_ref2_
       AND   huss.source_ref3       = source_ref3_
       AND   huss.source_ref4       = source_ref4_
       AND   huss.source_ref5       = source_ref5_
       AND   huss.source_ref_type   = source_ref_type_db_
       AND   huss.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_);
BEGIN
   FOR remrec__ IN get_handling_units_ LOOP
      Remove___(remrec__);
   END LOOP;

EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Fnd_Record_Removed('HandlUnitStockSnapShot');
END Remove_Handling_Unit;

PROCEDURE Modify_Process_Control (
   objid_            IN VARCHAR2,
   process_control_  IN VARCHAR2,
   modify_children_  IN BOOLEAN DEFAULT FALSE )
IS
   rec_     HANDL_UNIT_STOCK_SNAPSHOT_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Id___(objid_);
   Modify_Process_Control(rec_.source_ref1,
                          rec_.source_ref2,
                          rec_.source_ref3,
                          rec_.source_ref4,
                          rec_.source_ref5,
                          rec_.source_ref_type,
                          rec_.handling_unit_id,
                          rec_.contract,
                          rec_.location_no,
                          process_control_,
                          modify_children_);
END Modify_Process_Control;

         
PROCEDURE Modify_Process_Control (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER,
   contract_            IN VARCHAR2,
   location_no_         IN VARCHAR2,
   process_control_     IN VARCHAR2,
   modify_children_     IN BOOLEAN DEFAULT FALSE )
IS
   rec_     HANDL_UNIT_STOCK_SNAPSHOT_TAB%ROWTYPE;
   
   CURSOR get_children IS
      SELECT *
        FROM HANDLING_UNIT
       WHERE parent_handling_unit_id = handling_unit_id_;
BEGIN
   rec_ := Get_Object_By_Keys___(source_ref1_, 
                                 source_ref2_, 
                                 source_ref3_, 
                                 source_ref4_, 
                                 source_ref5_, 
                                 source_ref_type_db_, 
                                 handling_unit_id_, 
                                 contract_, 
                                 location_no_);
   rec_.process_control := process_control_;
   Modify___(rec_);
   
   IF (modify_children_) THEN
      FOR childrec_ IN get_children LOOP
         IF (Exists_Db(source_ref1_, 
                       source_ref2_, 
                       source_ref3_, 
                       source_ref4_, 
                       source_ref5_, 
                       source_ref_type_db_, 
                       childrec_.handling_unit_id, 
                       contract_, 
                       location_no_)) THEN
            Modify_Process_Control(source_ref1_,
                                   source_ref2_,
                                   source_ref3_,
                                   source_ref4_,
                                   source_ref5_,
                                   source_ref_type_db_,
                                   childrec_.handling_unit_id,
                                   contract_,
                                   location_no_,
                                   process_control_,
                                   modify_children_);
         END IF;
      END LOOP;
   END IF;
END Modify_Process_Control;


@UncheckedAccess
FUNCTION Get_Object_By_Id (
   objid_ IN VARCHAR2 ) RETURN Handl_Unit_Stock_Snapshot_API.Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (objid_ IS NULL) THEN
      RETURN NULL;
   END IF;
   
   SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, source_ref_type, 
          handling_unit_id, contract, location_no,
          rowid, rowversion, rowkey, process_control
     INTO temp_
     FROM handl_unit_stock_snapshot_tab
    WHERE rowid = objid_;   

   RETURN temp_;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
END Get_Object_By_Id;
   
   
PROCEDURE Get_Id_Version_By_Keys (
   objid_               IN OUT VARCHAR2,
   objversion_          IN OUT VARCHAR2,
   source_ref1_         IN     VARCHAR2,
   source_ref2_         IN     VARCHAR2,
   source_ref3_         IN     VARCHAR2,
   source_ref4_         IN     VARCHAR2,
   source_ref5_         IN     VARCHAR2,
   source_ref_type_db_  IN     VARCHAR2,
   handling_unit_id_    IN     NUMBER,
   contract_            IN     VARCHAR2,
   location_no_         IN     VARCHAR2 )
IS
BEGIN
   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             source_ref1_,
                             source_ref2_,
                             source_ref3_,
                             source_ref4_,
                             source_ref5_,
                             source_ref_type_db_,
                             handling_unit_id_,
                             contract_,
                             location_no_);
END Get_Id_Version_By_Keys;
