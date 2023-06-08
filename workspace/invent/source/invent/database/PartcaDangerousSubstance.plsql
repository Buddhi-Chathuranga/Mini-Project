-----------------------------------------------------------------------------
--
--  Logical unit: PartcaDangerousSubstance
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100927 AndDse BP-2273, Moved this LU from mfgstd to invent, and changed connection for substance_no from Chemical_Substance to Substance.
--  090929 KiSalk Renamed Copy_From_Template as Copy.
--  090602 KiSalk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Add_Remove_Records___
--   Remove all the records of to_part_no_ and insert those from from_part_no_.
--   If from_part_no_ is null just remove all the records of to_part_no_.
PROCEDURE Add_Remove_Records___ (
   from_part_no_ IN VARCHAR2,
   to_part_no_   IN VARCHAR2 )
IS
   newrec_     PARTCA_DANGEROUS_SUBSTANCE_TAB%ROWTYPE;
   objid_      PARTCA_DANGEROUS_SUBSTANCE.objid%TYPE;
   objversion_ PARTCA_DANGEROUS_SUBSTANCE.objversion%TYPE;
   attr_       VARCHAR2(30000);
   CURSOR get_recs(part_no_ VARCHAR2) IS
      SELECT rowid, part_no, substance_no
      FROM  PARTCA_DANGEROUS_SUBSTANCE_TAB
      WHERE part_no = part_no_;
   TYPE record_table IS TABLE OF get_recs%ROWTYPE;
   record_tab_ record_table;
   indrec_     Indicator_Rec;
BEGIN

   -- Delete existing records with part_no as to_part_no_
   OPEN  get_recs(to_part_no_);
   FETCH get_recs BULK COLLECT INTO record_tab_;
   CLOSE get_recs;
   IF (record_tab_.COUNT > 0) THEN
      FOR i_ IN record_tab_.FIRST .. record_tab_.LAST LOOP
         newrec_ := Lock_By_Keys___(record_tab_(i_).part_no, record_tab_(i_).substance_no);
         Check_Delete___(newrec_);
         Delete___(record_tab_(i_).rowid, newrec_);
      END LOOP;
   END IF;

   -- Insert new records from  part_no as from_part_no_
   record_tab_.DELETE;
   OPEN  get_recs(from_part_no_);
   FETCH get_recs BULK COLLECT INTO record_tab_;
   CLOSE get_recs;
   IF (record_tab_.COUNT > 0) THEN
      FOR i_ IN record_tab_.FIRST .. record_tab_.LAST LOOP
         newrec_ := Get_Object_By_Keys___(record_tab_(i_).part_no, record_tab_(i_).substance_no);

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('PART_NO', to_part_no_ , attr_);
         Client_SYS.Add_To_Attr('SUBSTANCE_NO', newrec_.substance_no , attr_);
         Client_SYS.Add_To_Attr('RESPONSIBLE_FOR_PSN_DB', newrec_.responsible_for_psn, attr_);
         Client_SYS.Add_To_Attr('MARINE_POLLUTANT_DB', newrec_.marine_pollutant, attr_);
         Client_SYS.Add_To_Attr('ADR_ENVIRONMENTAL_HAZARD_DB', newrec_.adr_environmental_hazard, attr_);
         Client_SYS.Add_To_Attr('IATA_ENVIRONMENTAL_HAZARD_DB', newrec_.iata_environmental_hazard, attr_);

         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;

END Add_Remove_Records___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('RESPONSIBLE_FOR_PSN_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('MARINE_POLLUTANT_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ADR_ENVIRONMENTAL_HAZARD_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('IATA_ENVIRONMENTAL_HAZARD_DB', 'FALSE', attr_);

END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Remove all the records of to_part_no_ and insert those from from_part_no_.
--   If from_part_no_ is null just remove all the records of to_part_no_.
PROCEDURE Copy (
   from_part_no_ IN VARCHAR2,
   to_part_no_   IN VARCHAR2 )
IS
BEGIN
   Add_Remove_Records___(from_part_no_, to_part_no_);
END Copy;



