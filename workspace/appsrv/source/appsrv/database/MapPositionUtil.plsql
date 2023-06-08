-----------------------------------------------------------------------------
--
--  Logical unit: MapPositionUtil
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171110  MDAHSE  Created.
--  ------------- Project Spring2020 ----------------------------------------
--  190925  TAJALK  SASPRING20-24, SCA changes
--  -------------------------------------------------------------------------
--  210726  puvelk  AM21R2-2220, Created Get_Map_Metadata() and Get_Map_Object_Info() methods
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE Validate_Parameter (
   object_lu_      IN VARCHAR2,
   object_key_     IN VARCHAR2,
   property_name_  IN VARCHAR2,
   property_value_ IN VARCHAR2 )
IS
   basemap_        VARCHAR2 (100);
   basemap_count_  NUMBER;
   basemaps_       Utility_Sys.STRING_TABLE;
   allowed_basemaps_ VARCHAR2 (100) := 'osm,satellite,hybrid,streets,topo,gray,dark-gray,national-geographic,oceans,terrain';
BEGIN
   IF object_lu_ = 'MapPosition' THEN

      IF property_name_ = 'ESRI_BASEMAPS' THEN

         IF NOT property_value_ = 'Use default' THEN
            Utility_Sys.Tokenize(property_value_, ',', basemaps_, basemap_count_);
            FOR i IN 1..basemap_count_ LOOP
               basemap_ := basemaps_(i);
               IF INSTR (',' || allowed_basemaps_ || ',', ',' || basemap_ || ',') < 1 THEN
                  Error_SYS.Record_General(lu_name_, 'ALLOWEDBASEMAPS: :P1 is not an allowed basemap. The allowed basemaps are: :P2. If you want to use the default basemaps, set the value to ''Use default''.',
                                                     basemap_, allowed_basemaps_);
               END IF;
            END LOOP;
         END IF;


      ELSIF property_name_ = 'ESRI_HTML_PAGE' THEN
         IF NOT (REGEXP_LIKE (property_value_, '^https?://.+\.html?$') OR property_value_ = 'Use default') THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDHTMLPAGEURL: Parameter :P1 has an invalid HTML page URL (:P2). Allowed format: http(s)://<servername>(:<port>)/<pagename>.htm(l). To use the default HTML page, set the value to ''Use default''.', property_name_, property_value_);
         END IF;


      ELSIF property_name_ = 'ESRI_PAID_ACCOUNT' THEN
         IF property_value_ NOT IN ('Yes', 'No') THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDPAIDACCTVALUE: Parameter :P1 should be either Yes or No', property_name_);
         END IF;


      ELSE
         Error_SYS.Record_General(lu_name_, 'UNKNOWNPARAMETER: Unknown parameter :P1.', property_name_);
      END IF;

   ELSE
      Error_SYS.Record_General(lu_name_, 'UNKNOWNPARAMETER: Unknown parameter :P1.', property_name_);
   END IF;
END Validate_Parameter;

FUNCTION Get_Map_Metadata_Std_Texts RETURN CLOB
IS
   metadata_   CLOB;

   PROCEDURE Append_Clob___ (text_ IN VARCHAR2 )
   IS
   BEGIN
      IF (metadata_ IS NULL AND text_ IS NOT NULL) THEN
         metadata_ := to_clob(text_);
      ELSIF (text_ IS NOT NULL AND LENGTH (text_) > 0) THEN
         DBMS_LOB.Writeappend(metadata_, LENGTH (text_), text_);
      END IF;
   END Append_Clob___;

   PROCEDURE Add_Text___ (name_      IN VARCHAR2,
                          value_     IN VARCHAR2,
                          add_comma_ IN BOOLEAN DEFAULT TRUE) IS
   BEGIN
      Append_Clob___ ('["' || name_ || '", "' || value_ || '"]');
      IF add_comma_ THEN
         Append_Clob___ (',');
      END IF;
   END Add_Text___;

BEGIN
   Append_Clob___ ('"texts": [');
   Add_Text___ ('2dLabel',                    Language_SYS.Translate_Constant (lu_name_, 'MAPTEXT2DLABEL: 2D'));
   Add_Text___ ('3dLabel',                    Language_SYS.Translate_Constant (lu_name_, 'MAPTEXT3DLABEL: 3D'));
   Add_Text___ ('toggle2d3dtooltip',          Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTTOG2D3D: Toggle between 2D and 3D'));
   Add_Text___ ('changeBasemapTooltip',       Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTCHGBMAP: Change basemap'));
   Add_Text___ ('togglePositionLabelLabel',   Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTLABELS: Labels'));
   Add_Text___ ('togglePositionLabelTooltip', Language_SYS.Translate_Constant (lu_name_, 'MAPTEXTLABELSTT: Toggle position labels'), FALSE);
   Append_Clob___ (']');
   RETURN metadata_;
END Get_Map_Metadata_Std_Texts;

FUNCTION Get_Map_Metadata (
   key_ref_ IN VARCHAR2,
   lu_name_ IN VARCHAR2) RETURN CLOB
IS
   metadata_   CLOB;   
   basemap_url_ VARCHAR2(32000);
   
   PROCEDURE Append_Clob___ (text_ IN VARCHAR2 )
   IS
   BEGIN
      IF (metadata_ IS NULL AND text_ IS NOT NULL) THEN
         metadata_ := to_clob(text_);
      ELSIF (text_ IS NOT NULL AND LENGTH (text_) > 0) THEN
         DBMS_LOB.Writeappend(metadata_, LENGTH (text_), text_);
      END IF;
   END Append_Clob___;
   
   PROCEDURE Append_Clob___(src_ IN CLOB)
   IS
   BEGIN
      IF (metadata_ IS NULL AND src_ IS NOT NULL) THEN
         metadata_ := src_;
      ELSIF (src_ IS NOT NULL) THEN
         DBMS_LOB.Append(metadata_, src_);
      END IF;
   END Append_Clob___;

   PROCEDURE Add_Row___ (label_ IN VARCHAR2,
                         value_ IN VARCHAR2) IS
   BEGIN
      Append_Clob___ ('<tr><td><strong>' || label_ || '</strong></td><td>' || value_ || '</td></tr>');
   END Add_Row___;

BEGIN   

   -- We will now build some JSON so that the map knows what information it
   -- should display, from where to get the data, etc.

   -- Beginning of JSON

   Append_Clob___ ('{');

   -- First add translations for all static texts we use in the map. In
   -- most cases, the standard texts defined in APPSRV should suffice.

   Append_Clob___ (Get_Map_Metadata_Std_Texts ());
   Append_Clob___ (',');

   -- Next, pick which basemap to use. 
   
   --basemap_url_ := Get_Basemap_Url(key_ref_);
   
   IF basemap_url_ IS NOT NULL THEN
      --Append_Clob___('"basemapUrl": "'|| basemap_url_ || '",');
      Append_Clob___('"featureLayers": [{"url":"'|| basemap_url_ || '"}],');
   END IF;   

   -- Optionally we can add special symbols we might want to have. The map
   -- contains some basic symbols that you don't need to define here. In
   -- the object data, the attribute Symbol will be used to refer to the
   -- name of the symbol below ("cyan"). It's easy to control the color and
   -- size of the circle that makes up the symbol.

   Append_Clob___ ('"symbols": [{"name": "cyan", "symbol": {"color": [0, 150, 150], "outline": {"color": [255, 255, 255], "width": 2}}}],');

   -----
   Append_Clob___ ('"popupTemplate": "');
   Append_Clob___ ('<table>');     
   -- Below, the syntax "{ATTRIBUTENAME}" is used to inject actual object
   -- attribute data into the template. In order for that to work, the
   -- object must have an attribute with that name as part of the JSON data
   -- used by the map. Esri's API will do the replacement for us.
   
   Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPLONGITUDE: Longitude'),      '{Longitude}');
   Add_Row___ (Language_SYS.Translate_Constant (lu_name_, 'MAPLATITUDE: Latitude'),          '{Latitude}');
   
  
   Append_Clob___ ('</table>",');
   -----
     
   -- Add all objects

   Append_Clob___('"objects":');
   
   Append_Clob___(Get_Map_Object_Info (key_ref_,lu_name_));  
   
   -- End JSON

   Append_Clob___ ('}'); 

   RETURN metadata_;

END Get_Map_Metadata;


FUNCTION Get_Map_Object_Info (
   key_ref_   IN VARCHAR2 DEFAULT NULL,
   lu_name_   IN VARCHAR2)RETURN CLOB
IS
   longitude_        NUMBER;
   latitude_         NUMBER;
   json_             CLOB;
   
   CURSOR get_obj_map_positions IS
      SELECT t.longitude, t.latitude
      FROM map_position t
      WHERE lu_name = lu_name_
      AND key_ref = key_ref_
      AND default_position = 1;
        
   FUNCTION Attribute___ (name_      IN VARCHAR2,
                          value_     IN VARCHAR2,
                          add_comma_ IN BOOLEAN DEFAULT TRUE) RETURN VARCHAR2 IS
      attr_ VARCHAR2 (4000);
   BEGIN
      attr_ := '"' || name_ || '": "' || REPLACE (value_, '"', '\"') || '"';
      IF add_comma_ THEN
         attr_ := attr_ || ',';
      END IF;
      RETURN attr_;
   END Attribute___;

BEGIN
      
   OPEN get_obj_map_positions;
   FETCH get_obj_map_positions INTO longitude_,latitude_;
   IF get_obj_map_positions%FOUND THEN
         json_ := json_ ||
                 '{' ||
                 Attribute___ ('Longitude'       , longitude_)               ||
                 Attribute___ ('Latitude'        , latitude_)                ||
                 Attribute___ ('Symbol'          , 'blue', FALSE)            ||
                 '},'; -- This comma must be removed on the last record
   END IF;
   CLOSE get_obj_map_positions;
 
   

   IF json_ IS NULL THEN
      RETURN '[]';
   ELSE
      RETURN '[' || SUBSTR(json_, 0, LENGTH (json_) - 1) || ']'; -- Strip last comma
   END IF;

END Get_Map_Object_Info;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
