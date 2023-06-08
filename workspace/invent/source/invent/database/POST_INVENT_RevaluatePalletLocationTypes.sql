-----------------------------------------------------------------------------
--
--  Filename      : POST_INVENT_RevaluatePalletLocationTypes.sql
--
--  Module        : INVENT
--
--  Purpose       : Revalutes inventory by moving value from the old pallet location types
--                  to their new upgraded location types if the affected companies
--                  have any posting control on location type.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  170323  Chfose  LIM-4350, Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RevaluatePalletLocationTypes.sql','Timestamp_1');
PROMPT Starting POST_INVENT_RevaluatePalletLocationTypes.sql

DECLARE
   table_name_    VARCHAR2(30) := 'INVENTORY_LOCATION_GROUP_TAB';
   column_name_   VARCHAR2(30) := 'INVENTORY_LOCATION_TYPE_1410';
BEGIN
   -- Create the column if it doesn't exist to make the script re-runnable & work for fresh installs.
   -- When doing an upgrade the column is created and filled with data in 1500.upg.
   IF (NOT Database_SYS.Column_Exist(table_name_, column_name_)) THEN
      Database_SYS.Alter_Table_Column(table_name_, 'A', Database_SYS.Set_Column_Values(column_name_, 'VARCHAR2(20)', 'Y'), TRUE);
   END IF;
END;
/

DECLARE
   CURSOR get_removed_pallet_loc_types IS
      SELECT DISTINCT inventory_location_type_1410
        FROM INVENTORY_LOCATION_GROUP_TAB
       WHERE inventory_location_type_1410 IS NOT NULL;

   CURSOR get_companies IS
      SELECT company
        FROM COMPANY_INVENT_INFO_TAB;

   CURSOR get_contracts(company_ VARCHAR2) IS
      SELECT DISTINCT contract
        FROM SITE_TAB
       WHERE company = company_;

   CURSOR get_locations(company_ VARCHAR2) IS
      SELECT wbb.contract, wbb.location_no,
             ilg.location_group new_location_group,
             ilg2.location_group old_location_group
        FROM SITE_TAB s, WAREHOUSE_BAY_BIN_TAB wbb,
             INVENTORY_LOCATION_GROUP_TAB ilg, INVENTORY_LOCATION_GROUP_TAB ilg2
       WHERE s.contract          = wbb.contract
         AND wbb.location_group  = ilg.location_group
         AND ilg.inventory_location_type_1410 IS NOT NULL
         AND ilg.inventory_location_type_1410 = ilg2.inventory_location_type
         AND s.company = company_;

   upg_index_                    NUMBER := 1;
   m1_exists_                    BOOLEAN;
   m3_exists_                    BOOLEAN;
   m60_exists_                   BOOLEAN;
   fnd_user_                     VARCHAR2(30);

   index_                        NUMBER;
   info_                         VARCHAR2(2000);
   attr_                         VARCHAR2(32000);

   TYPE Access_Rec IS RECORD (
        objid       VARCHAR2(20),
        objversion  VARCHAR2(100));
   TYPE Access_Tab IS TABLE OF Access_Rec INDEX BY PLS_INTEGER;

   company_access_added_         Access_Tab;
   user_group_access_added_      Access_Tab;

   TYPE User_Allowed_Site_Tab IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
   user_allowed_sites_added_     User_Allowed_Site_Tab;
BEGIN
   -- Create dummy location groups with the old pallet location types.
   FOR old_location_type_rec_ IN get_removed_pallet_loc_types LOOP
      BEGIN
         INSERT
            INTO INVENTORY_LOCATION_GROUP_TAB (
               location_group,
               description,
               inventory_location_type,
               rowversion)
            VALUES (
               '#UPG' || upg_index_,
               'For upg of pallet loc type (APPS10)',
               old_location_type_rec_.inventory_location_type_1410,
               SYSDATE);
      EXCEPTION
         WHEN dup_val_on_index THEN
            NULL;
      END;
      upg_index_ := upg_index_ + 1;
   END LOOP;

   fnd_user_ := Fnd_Session_API.Get_Fnd_User;

   -- Get companies with a location that belongs to any of the upgraded location groups.
   FOR company_rec_ IN get_companies LOOP
      -- Check which posting types that have C46 enabled in this company
      m1_exists_ := Posting_Ctrl_API.Exist_Posting_Control(company_       => company_rec_.company,
                                                           posting_type_  => 'M1',
                                                           control_type_  => 'C46',
                                                           code_part_     => NULL);

      m3_exists_ := Posting_Ctrl_API.Exist_Posting_Control(company_       => company_rec_.company,
                                                           posting_type_  => 'M3',
                                                           control_type_  => 'C46',
                                                           code_part_     => NULL);

      m60_exists_ := Posting_Ctrl_API.Exist_Posting_Control(company_       => company_rec_.company,
                                                            posting_type_  => 'M60',
                                                            control_type_  => 'C46',
                                                            code_part_     => NULL);

      IF (m1_exists_ OR m3_exists_ OR m60_exists_) THEN

         -- Give the fnd_user access to the company, user group and sites needed in order to be able to create transactions.
         -- All the access that was added in this script will also be removed in the end of the script.
         IF (NOT User_Finance_API.Check_User(company_    => company_rec_.company,
                                             userid_     => fnd_user_)) THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('COMPANY', company_rec_.company, attr_);
            Client_SYS.Add_To_Attr('USERID', fnd_user_, attr_);
            index_ := company_access_added_.COUNT + 1;
            User_Finance_API.New__(info_        => info_,
                                   objid_       => company_access_added_(index_).objid,
                                   objversion_  => company_access_added_(index_).objversion,
                                   attr_        => attr_,
                                   action_      => 'DO');
         END IF;

         IF (NOT User_Group_Member_Finance_API.Exists(company_    => company_rec_.company,
                                                      user_group_ => 'AC',
                                                      userid_     => fnd_user_)) THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('COMPANY', company_rec_.company, attr_);
            Client_SYS.Add_To_Attr('USER_GROUP', 'AC', attr_);
            Client_SYS.Add_To_Attr('USERID', fnd_user_, attr_);
            -- If this is the first user group access for this user on the company then it has to be the default group.
            Client_SYS.Add_To_Attr('DEFAULT_GROUP', CASE WHEN User_Group_Member_Finance_API.Get_Default_Group(company_rec_.company, fnd_user_) IS NULL THEN 'Yes' ELSE 'No' END, attr_);
            index_ := user_group_access_added_.COUNT + 1;
            User_Group_Member_Finance_API.New__(info_       => info_,
                                                objid_      => user_group_access_added_(index_).objid,
                                                objversion_ => user_group_access_added_(index_).objversion,
                                                attr_       => attr_,
                                                action_     => 'DO');
         END IF;

         FOR contract_rec_ IN get_contracts(company_rec_.company) LOOP
            IF (NOT User_Allowed_Site_API.Check_Exist(fnd_user_, contract_rec_.contract)) THEN
               User_Allowed_Site_API.New(userid_               => fnd_user_,
                                         contract_             => contract_rec_.contract);
               user_allowed_sites_added_(user_allowed_sites_added_.COUNT + 1) := contract_rec_.contract;
            END IF;
         END LOOP;

         -- Loop through all of the locations that has an upgraded location group.
         FOR location_rec_ IN get_locations(company_rec_.company) LOOP
            Inventory_Location_Manager_API.Handle_Location_Group_Change__ (
                  contract_               => location_rec_.contract,
                  location_no_            => location_rec_.location_no,
                  old_location_group_     => location_rec_.old_location_group,
                  new_location_group_     => location_rec_.new_location_group,
                  onhand_                 => m1_exists_,
                  in_transit_             => m3_exists_,
                  supplier_consignment_   => m60_exists_);
         END LOOP;
      END IF;
   END LOOP;

   -- In order to restore the access as it was before starting the script, we remove
   -- the company, user group and site access that we added previously.
   IF (user_allowed_sites_added_.COUNT > 0) THEN
      FOR i IN user_allowed_sites_added_.FIRST .. user_allowed_sites_added_.LAST LOOP
         User_Allowed_Site_API.Remove(userid_      => fnd_user_,
                                      contract_    => user_allowed_sites_added_(i));
      END LOOP;
   END IF;

   IF (user_group_access_added_.COUNT > 0) THEN
      FOR i IN user_group_access_added_.FIRST .. user_group_access_added_.LAST LOOP
         User_Group_Member_Finance_API.Remove__(info_       => info_,
                                                objid_      => user_group_access_added_(i).objid,
                                                objversion_ => user_group_access_added_(i).objversion,
                                                action_     => 'DO');
      END LOOP;
   END IF;

   IF (company_access_added_.COUNT > 0) THEN
      FOR i IN company_access_added_.FIRST .. company_access_added_.LAST LOOP
         User_Finance_API.Remove__(info_        => info_,
                                   objid_       => company_access_added_(i).objid,
                                   objversion_  => company_access_added_(i).objversion,
                                   action_      => 'DO');
      END LOOP;
   END IF;

   Database_SYS.Alter_Table_Column('INVENTORY_LOCATION_GROUP_TAB', 'D', Database_SYS.Set_Column_Values('INVENTORY_LOCATION_TYPE_1410'));
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RevaluatePalletLocationTypes.sql','Done');
PROMPT Finished with POST_INVENT_RevaluatePalletLocationTypes.sql
