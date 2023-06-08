-----------------------------------------------------------------------------
--
--  Logical unit: BinaryObjectDataBlock
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980810  DAJO  Created
--  980924  DAJO  Added Copy function
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030317  ROOD  Replaced General_SYS.Put_Line with Trace_SYS.Put_Line (ToDo#4143).
--  090123  HAAR  Attribute Data has changed data type from Long Raw to Blob (Bug#78975).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
--  101104  JAPA  Upgraded to new template
--  121206  Hidilk Added new method Get_Data.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BINARY_OBJECT_DATA_BLOCK_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.length := 0;
   Client_SYS.Add_To_Attr('LENGTH', newrec_.length, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     BINARY_OBJECT_DATA_BLOCK_TAB%ROWTYPE,
   newrec_     IN OUT BINARY_OBJECT_DATA_BLOCK_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.length := length(newrec_.data);
   Client_SYS.Add_To_Attr('LENGTH', newrec_.length, attr_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

PROCEDURE New__(
   objversion_       OUT VARCHAR2,
   objid_            OUT VARCHAR2,
   blob_id_          IN  NUMBER,
   application_data_ IN VARCHAR2 )
IS
BEGIN
   INSERT INTO binary_object_data_block_tab (blob_id, seq, application_data, rowversion)
   VALUES (blob_id_, 1, application_data_, SYSDATE)
   RETURNING rowid, to_char(rowversion,'YYYYMMDDHH24MISS') INTO objid_, objversion_;
END New__;


PROCEDURE New__(
   objversion_       OUT VARCHAR2,
   objid_            OUT VARCHAR2,
   blob_id_          IN  NUMBER,
   application_data_ IN  VARCHAR2,
   blob_loc_         IN  BLOB )
IS
BEGIN
   New__(objversion_, objid_, blob_id_, application_data_);
   Write_Data__(objversion_, objid_, blob_loc_);
END New__;

PROCEDURE New_Binary_Object__(
   objversion_       OUT VARCHAR2,
   objid_            OUT VARCHAR2,
   blob_id_          IN  NUMBER,
   application_data_ IN  VARCHAR2,
   blob_loc_         IN  BLOB )
IS
BEGIN
   New__(objversion_, objid_, blob_id_, application_data_);
   Write_Data__(objversion_, objid_, blob_loc_);
END New_Binary_Object__;


@Override
PROCEDURE Write_Data__ (
   objversion_ IN OUT VARCHAR2,
   rowid_      IN ROWID,
   lob_loc_    IN BLOB )
IS
BEGIN
   super(objversion_, rowid_, lob_loc_);
   UPDATE BINARY_OBJECT_DATA_BLOCK_TAB
   SET length = length(lob_loc_)
   WHERE rowid = rowid_;
END Write_Data__;


-- Remove_
--    Removes all data blocks for a binary object. This function is used by
--    BinaryObject when updating an existing object.
PROCEDURE Remove_ (
   blob_id_ IN NUMBER )
IS
BEGIN
   Trace_SYS.Put_Line( 'Removing existing data blocks for binary object :P1', to_char(blob_id_));
   DELETE FROM BINARY_OBJECT_DATA_BLOCK_tab WHERE blob_id = blob_id_;
END Remove_;


PROCEDURE Copy_ (
   blob_id_source_ IN NUMBER,
   blob_id_destination_ IN NUMBER )
IS
   CURSOR blocks IS
      SELECT *
      FROM binary_object_data_block
      WHERE blob_id = blob_id_source_;
BEGIN
   Trace_SYS.Put_Line( 'Copying existing data blocks for binary object :P1 to binary object :P2', to_char( blob_id_source_ ), to_char( blob_id_destination_ ) );
   FOR block IN blocks LOOP
     Trace_SYS.Put_Line( 'Copying data block :P1', to_char( block.seq ) );
     INSERT INTO binary_object_data_block_tab (blob_id, seq, data, length, application_data, rowversion )
     VALUES ( blob_id_destination_, block.seq, block.data, block.length, block.application_data, SYSDATE );
   END LOOP;
END Copy_;

@UncheckedAccess
FUNCTION Get_Objid (
   blob_id_ IN NUMBER,
   seq_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ BINARY_OBJECT_DATA_BLOCK.application_data%TYPE;
   CURSOR get_attr IS
      SELECT objid
      FROM BINARY_OBJECT_DATA_BLOCK
      WHERE blob_id = blob_id_
      AND   seq = seq_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Objid;


@UncheckedAccess
FUNCTION Get_Data (
   blob_id_ IN NUMBER,
   seq_ IN NUMBER ) RETURN BLOB
IS
   temp_ BINARY_OBJECT_DATA_BLOCK.data%TYPE;
   CURSOR get_attr IS
      SELECT data
      FROM BINARY_OBJECT_DATA_BLOCK
      WHERE blob_id = blob_id_
      AND   seq = seq_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Data;


