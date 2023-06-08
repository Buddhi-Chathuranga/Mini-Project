-----------------------------------------------------------------------------
--
--  Logical unit: ShipPackProposal
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210727  RasDlk  SC21R2-1023, Modified Prepare_Insert___ and Check_Insert___ to set the default values of PACK_BY_RESERVATION_LINE_DB, EXCL_FULLY_RESERVED_HU_DB,
--  210727          SORT_PRIORITY1_DB and ALLOW_MIX_SOURCE_OBJECT_DB. Also, removed codes related to PACK_BY_RESERVATION_DB and EXCLUDE_FULLY_RESERVED_HU_DB.
--  210727          Overrode Check_Common___ to validate sort_priority1 and sort_priority2 values.
--  210707  Aabalk  SC21R2-1027, Overrode Prepare_Insert___ and Check_Insert___ to allow for default setting of
--  210707          packing method values.
--  210528  Aabalk  SC21R2-1019, Created. Added Get_Description function to fetch packing proposal description.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PACK_BY_SOURCE_OBJECT_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('PACK_BY_RESERVATION_LINE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('PACK_BY_PIECE_DB', Fnd_Boolean_API.DB_TRUE, attr_);
   Client_SYS.Add_To_Attr('EXCL_FULLY_RESERVED_HU_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('SORT_PRIORITY1_DB', Ship_Pack_Proposal_Sorting_API.DB_RESERVATION_LINE_VOLUME, attr_);
   Client_SYS.Add_To_Attr('ALLOW_MIX_SOURCE_OBJECT_DB', Mix_Source_Object_API.DB_ALWAYS, attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT ship_pack_proposal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (NOT indrec_.pack_by_source_object) THEN
      newrec_.pack_by_source_object := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (NOT indrec_.pack_by_reservation_line) THEN
      newrec_.pack_by_reservation_line := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (NOT indrec_.pack_by_piece) THEN
      newrec_.pack_by_piece := Fnd_Boolean_API.DB_TRUE;
   END IF;
   IF (NOT indrec_.excl_fully_reserved_hu) THEN
      newrec_.excl_fully_reserved_hu := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (NOT indrec_.allow_mix_source_object) THEN
      newrec_.allow_mix_source_object := Mix_Source_Object_API.DB_ALWAYS;
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;

@Override 
PROCEDURE Check_Common___ (
   oldrec_ IN     ship_pack_proposal_tab%ROWTYPE,
   newrec_ IN OUT ship_pack_proposal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.sort_priority1 IS NULL AND newrec_.sort_priority2 IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ENTERPRIORITY1: Please enter a value for Priority 1 before entering a value for Priority 2.');
   END IF;
   IF (newrec_.sort_priority1 = newrec_.sort_priority2 AND newrec_.sort_priority1 IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'SAMEPRIORITY: Please use different values for Priority 1 and Priority 2.');
   END IF;
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Description (
   packing_proposal_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ ship_pack_proposal_tab.description%TYPE;
BEGIN
   IF (packing_proposal_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
      SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('SHPMNT', 'ShipPackProposal',
                 packing_proposal_id), description), 1, 200)
         INTO  temp_
         FROM  ship_pack_proposal_tab
         WHERE packing_proposal_id = packing_proposal_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(packing_proposal_id_, 'Get_Description');
END Get_Description;

