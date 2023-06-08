-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseBinHuCapacity
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180206  LEPESE  STRSC-16027, Added method Validate_Bin_Hu_Type_Capacity.
--  180205  LEPESE  STRSC-16027, Added method Get_Hu_Types_Having_Cap_Limits.
--  180123  LEPESE  STRSC-16027, Added method Get_Operative_Hu_Type_Capacity.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     warehouse_bin_hu_capacity_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY warehouse_bin_hu_capacity_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Bin_Hu_Type_Capacity(newrec_.bin_hu_type_capacity); 
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Validate_Bin_Hu_Type_Capacity (
   bin_hu_type_capacity_ IN NUMBER )
IS 
BEGIN
   IF (bin_hu_type_capacity_ != ROUND(bin_hu_type_capacity_) OR bin_hu_type_capacity_ < 0) THEN 
      Error_SYS.Record_General(lu_name_, 'TYPECAPERR: Bin Handling Unit Type Capacity must be a positive integer or zero');
   END IF;   
END Validate_Bin_Hu_Type_Capacity;
   

@UncheckedAccess
FUNCTION Get_Hu_Types_Having_Cap_Limits (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN Handling_Unit_Type_API.Unit_Type_Tab
IS
   unit_type_tab_ Handling_Unit_Type_API.Unit_Type_Tab;

   CURSOR get_handling_unit_types IS
      SELECT handling_unit_type_id
        FROM warehouse_bin_hu_capacity_tab
       WHERE contract     = contract_        
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_      
         AND tier_id      = tier_id_     
         AND row_id       = row_id_      
         AND bin_id       = bin_id_
      UNION
      SELECT handling_unit_type_id
        FROM warehouse_tier_hu_capacity_tab
       WHERE contract     = contract_        
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_      
         AND tier_id      = tier_id_     
      UNION
      SELECT handling_unit_type_id
        FROM warehouse_row_hu_capacity_tab
       WHERE contract     = contract_        
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_      
         AND row_id       = row_id_      
      UNION
      SELECT handling_unit_type_id
        FROM warehouse_bay_hu_capacity_tab
       WHERE contract     = contract_        
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_      
      UNION
      SELECT handling_unit_type_id
        FROM warehouse_hu_capacity_tab
       WHERE contract     = contract_        
         AND warehouse_id = warehouse_id_
      UNION
      SELECT handling_unit_type_id
        FROM site_hu_capacity_tab
       WHERE contract     = contract_;
BEGIN
   OPEN  get_handling_unit_types;
   FETCH get_handling_unit_types BULK COLLECT INTO unit_type_tab_;
   CLOSE get_handling_unit_types;

   RETURN(unit_type_tab_);
END Get_Hu_Types_Having_Cap_Limits;


@UncheckedAccess
FUNCTION Get_Operative_Hu_Type_Capacity (
   contract_              IN VARCHAR2,
   warehouse_id_          IN VARCHAR2,
   bay_id_                IN VARCHAR2,
   tier_id_               IN VARCHAR2,
   row_id_                IN VARCHAR2,
   bin_id_                IN VARCHAR2,
   handling_unit_type_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   warehouse_capacity_ NUMBER;
   bay_capacity_       NUMBER;
   tier_capacity_      NUMBER;
   row_capacity_       NUMBER;
   bin_capacity_       NUMBER;
   operative_capacity_ NUMBER;
BEGIN
   bin_capacity_ := Get_Bin_Hu_Type_Capacity(contract_              => contract_,
                                             warehouse_id_          => warehouse_id_,
                                             bay_id_                => bay_id_,
                                             tier_id_               => tier_id_,
                                             row_id_                => row_id_,
                                             bin_id_                => bin_id_,
                                             handling_unit_type_id_ => handling_unit_type_id_);
   IF (bin_capacity_ IS NULL) THEN
      tier_capacity_ := Warehouse_Tier_Hu_Capacity_API.Get_Bin_Hu_Type_Capacity(contract_              => contract_,
                                                                                warehouse_id_          => warehouse_id_,
                                                                                bay_id_                => bay_id_,
                                                                                tier_id_               => tier_id_,
                                                                                handling_unit_type_id_ => handling_unit_type_id_);

      row_capacity_ := Warehouse_Row_Hu_Capacity_API.Get_Bin_Hu_Type_Capacity(contract_              => contract_,
                                                                              warehouse_id_          => warehouse_id_,
                                                                              bay_id_                => bay_id_,
                                                                              row_id_                => row_id_,
                                                                              handling_unit_type_id_ => handling_unit_type_id_);
      IF (tier_capacity_ IS NULL) THEN
         IF (row_capacity_ IS NULL) THEN
            bay_capacity_ := Warehouse_Bay_Hu_Capacity_API.Get_Bin_Hu_Type_Capacity(contract_              => contract_,
                                                                                    warehouse_id_          => warehouse_id_,
                                                                                    bay_id_                => bay_id_,
                                                                                    handling_unit_type_id_ => handling_unit_type_id_);
            IF (bay_capacity_ IS NULL) THEN
               warehouse_capacity_ := Warehouse_Hu_Capacity_API.Get_Bin_Hu_Type_Capacity(contract_              => contract_,
                                                                                         warehouse_id_          => warehouse_id_,
                                                                                         handling_unit_type_id_ => handling_unit_type_id_);
               IF (warehouse_capacity_ IS NULL) THEN
                  operative_capacity_ := Site_Hu_Capacity_API.Get_Bin_Hu_Type_Capacity(contract_              => contract_,
                                                                                       handling_unit_type_id_ => handling_unit_type_id_);
               ELSE
                  operative_capacity_ := warehouse_capacity_;
               END IF;
            ELSE
               operative_capacity_ := bay_capacity_;
            END IF;
         ELSE
            operative_capacity_ := row_capacity_;
         END IF;
      ELSE
         IF (row_capacity_ IS NULL) THEN
            operative_capacity_ := tier_capacity_;
         ELSE
            operative_capacity_ := LEAST(tier_capacity_, row_capacity_);
         END IF;
      END IF;
   ELSE
      operative_capacity_ := bin_capacity_;
   END IF;
   
   RETURN(operative_capacity_);
END Get_Operative_Hu_Type_Capacity;

