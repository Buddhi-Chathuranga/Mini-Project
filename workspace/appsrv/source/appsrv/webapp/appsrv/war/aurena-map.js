
// Where to get the positions from, record in the client or projection
var mapDataMode = "projection";

var searchWidget;
var currentRecord = null;
var mapMetadata;
var mapMetadataProjection;
var pluginStub;
var graphicsLayer;
var appConfig;
var allObjects = [];
var scenario;
var userCategory = "b2b"; // Keep this as b2b to support old code which was developed for b2b scenario only.
var keyRef;
var map;
var ElementmarkerSymbol;
var addPosition = "false";
var deleteGraphic= "false";
require(["dojo/on"], function(on) {
   on(window, "load", function(e) {
      pluginStub = IfsPluginStub;
      setMapMetadata ();
      pluginStub.onRecordChange = onIfsRecordChanged;
   });
});

function onIfsRecordChanged (rec) {

   currentRecord = JSON.parse(rec).record;

   console.log ("record = ", currentRecord);

   // When the map loads, it first fetch all metadata it needs. The
   // plugin framework however does not wait firing
   // onRecordChanged. So, we need to save the record data to be
   // used when all metadata has been loaded. The record is saved
   // in the global currentRecord variable.

   if (graphicsLayer && mapDataMode === "record") {
      plotCurrentRecordPosition ();
   } else {
      console.log("graphicsLayer not set yet, probably metadata is not set. Using saved record later...");
   }

}

function plotCurrentRecordPosition () {

   require([
      "esri/geometry/Point",
      "esri/Graphic",
      "dojo/domReady!"
   ], function (Point, Graphic) {

      graphicsLayer.removeAll ();

      if (currentRecord.DefaultMapPositionLongLatAlt) {

         posData = currentRecord.DefaultMapPositionLongLatAlt.split (";").map (function (p) {
            return parseFloat (p);
         });

         console.log ("posData = ", posData);

         var zValue = (!!posData[2]) ? posData[2] : undefined;

         console.log ("zValue = ", zValue);

         var p = new Point({
            longitude: posData [0], // example: 15
            latitude: posData[1],    // example: 65
            z: zValue
         });

         var markerSymbol = getSymbol ( (mapMetadata.defaultSymbol) ? mapMetadata.defaultSymbol : "blue");
         console.log("symbol =", markerSymbol);

         var pointAttr = {};

         var graphic = new Graphic(p, markerSymbol, pointAttr);

         graphicsLayer.add(graphic);

         appConfig.mapView.center = p;

      }

   });

}

// FETCH AND PLOT OBJECTS ON MAP

function plotAndZoom (objects) {
   console.log ("objects = ", objects);

   if (mapDataMode === "record") {
      console.log("currentRecord is set:", currentRecord);
      plotCurrentRecordPosition ();
   } else {
      objects.forEach (function (o) {
         plotObject (o);
      });
      addLabels ();
      centerAndZoom (allObjects);
   }
}

function plotObject (obj) {

   require([
      "esri/geometry/Point",
      "esri/Graphic",
      "dojo/domReady!"
   ], function (Point, Graphic) {

      console.log ("plotObject, obj = ", obj);

      var posData;

      // TODO - Try to handle Z (elevation/altitude) as well
      //         var zValue = (!!posData[2]) ? posData[2] : undefined;

      var p = new Point({
         longitude: obj.Longitude, // example: 15
         latitude: obj.Latitude,   // example: 65
         z: undefined
      });

      var markerSymbol = getSymbol (obj.Symbol);

      var popupTemplate = { // autocasts as new PopupTemplate()
         title: "{PopupTitle}",
         content: processTemplateExpressions (mapMetadata.popupTemplate, obj)
      };

      var graphic = new Graphic ({
         geometry: p,
         symbol: markerSymbol,
         attributes: obj,
         popupTemplate: popupTemplate
      });

      graphicsLayer.add (graphic);

      allObjects.push (graphic);

   });

}

// ZOOM AND CENTER

function positionExists (position, positions) {
   return positions.filter (function (pos) {
      return (pos.x === position.x && pos.y === position.y);
   }).length > 0;
}

function expandAndMaybeCorrectExtent (extent) {

   // Expand the extent. Also, in some cases the max and min values
   // for x and y might be the same. To get a valid extent, nudge the
   // max value a little bit so that a proper rectangle is created.

   var newExtent = extent;

   if (newExtent.xmin === newExtent.xmax)
      newExtent.xmax+= 0.000000001;

   if (newExtent.ymin === newExtent.ymax)
      newExtent.ymax+= 0.000000001;

   // Zoom out a little bit to make sure all objects will be seen

   newExtent = newExtent.expand(1.5);

   return newExtent;
}

function getMaxAndMinCoordinates (features) {
   var maxx = -1000000000;
   var maxy = -1000000000;
   var minx = 1000000000;
   var miny = 1000000000;

   var uniquePositions = [];

   // Find the extreme coordinates of all features

   features.forEach (function (f) {

      if (!positionExists (f.geometry, uniquePositions)) {

         uniquePositions.push (f.geometry);

         maxx = Math.max(maxx, f.geometry.x);
         maxy = Math.max(maxy, f.geometry.y);
         minx = Math.min(minx, f.geometry.x);
         miny = Math.min(miny, f.geometry.y);
      }

   });

   if (uniquePositions.length > 1)
      return {minx: minx,
              maxx: maxx,
              miny: miny,
              maxy: maxy};
   else
      return "ONEUNIQUEONLY";

}

function centerAndZoom (features) {

   if (!mapMetadata.disableAutoZoom) {

      // Center objects on the map, zoom if possible.

      require (
         ["esri/geometry/Extent",
          "esri/geometry/SpatialReference"],
         function (Extent, SpatialReference) {

            var maxAndMin;

            // Nothing to do...

            if (features.length === 0)
               return;

            if (features.length > 1)
               maxAndMin = getMaxAndMinCoordinates (features);

            // If there is one object only or if there are more than one
            // object but only one unique position, we cannot calculate a
            // valid extent. The only thing we can do is to center the map
            // on the single position.

            if (features.length === 1 || maxAndMin === "ONEUNIQUEONLY"){
               appConfig.mapView.center = features[0].geometry;
               appConfig.mapView.zoom = 10;
            }
            else
               appConfig.mapView.extent = expandAndMaybeCorrectExtent (new Extent(maxAndMin.minx, maxAndMin.miny,
                                                                                  maxAndMin.maxx, maxAndMin.maxy,
                                                                                  features [0].spatialReference));

            // It might be a bit goofy to support both plotting objects and
            // searching at the same time, but it also does not make any
            // harm, in case someone finds a use for it.

            if (mapMetadata.search && searchWidget)
               searchWidget.search (mapMetadata.search);

         });
   }

}

// MISC

function inIframe () {
    try {
        return window.self !== window.top;
    } catch (e) {
        return true;
    }
}

function setViewPortHeight() {
   if (inIframe ()) {

      var containerHeight = window.parent.document.body.scrollHeight - 200;

      if (mapMetadata.pluginHeight) {
         containerHeight = mapMetadata.pluginHeight;
         console.log("Using containerHeight from metadata:", containerHeight);
      } else {
         console.log ("Using containerHeight from parent:", containerHeight);
      }

      pluginStub.setViewPortHeight(containerHeight);
   }
}

function navigate (projection, page, filter) {

   console.log("Navigation to:");
   console.log("  ", projection);
   console.log("  ", page);
   console.log("  ", filter);

   if (inIframe ())
      pluginStub.navigateToPage (projection, page, filter);
   else
      console.log("Nah, I don't want to...");

}

function getQueryStringParams() {
   var params = {};
   if (location.search) {
      var queryString = location.search.substring(1).split("&").forEach(function(item) {
         var kv = item.split("=");
         if (kv.length > 1) {
            params[kv[0]] = decodeURIComponent(kv[1]);
         }
      });
   }
   return params;
}

function handleQueryParameters () {

   var params = getQueryStringParams ();

   console.log("handleQueryParameters, params =", params);

   if (params.mapdatamode) {
      mapDataMode = params.mapdatamode;
   }

   if (params.scenario)
      scenario = params.scenario;

   mapMetadataProjection = params.projection;

   if (params.userCategory)
      userCategory = params.userCategory;

   if (params.keyRef)
      keyRef = params.keyRef;

   if (params.addPosition)
      addPosition = params.addPosition;

   console.log("setParameters, scenario = ", scenario);
   console.log("               projection = ", mapMetadataProjection);

   if (!scenario) scenario = "EquipmentObjectEndCustomer";
}

function getText (name) {
   var retVal = mapMetadata.texts.filter (function (t) {
      return (t [0] === name);
   });

   if (retVal && retVal [0])
      retVal = retVal [0] [1];
   else
      retVal = name; // Default to the name of the label

   return retVal;
}

function capitalize (string) {
   return string.charAt(0).toUpperCase() + string.slice(1);
}

function getSymbol (name) {

   var realName = name;
   var shapeAndColor;
   var shape;
   var color;

   // Fallback to support simple naming with just the color name

   if (!(name.startsWith ("picture") || name.startsWith ("simple")))
      realName = "simple_circle_" + name;

   console.log("getSymbol, realName =", realName);

   if (realName.startsWith ("simple")) {

      // Examples: simple_circle_red, simple_diamond_blue

      shapeAndColor = realName.substring (realName.indexOf ("_") + 1);
      shape = shapeAndColor.substring (0, shapeAndColor.indexOf ("_"));
      color = shapeAndColor.substring (shapeAndColor.indexOf ("_") + 1);

      return getSimpleMarkerSymbol (shape, color);

   } else if (realName.startsWith ("picture")) {

      // Examples: picture_Star_Red, picture_Circle_Green

      // Available picture symbol color names: Purple, Black, Blue, Green, Orange , Yellow, Red
      // Shapes: Pin1, Pin2, Circle, Square, Diamond, Star

      // Example name sent in: picture_Star_Red

      shapeAndColor = realName.substring (realName.indexOf ("_") + 1);
      shape = shapeAndColor.substring (0, shapeAndColor.indexOf ("_"));
      color = shapeAndColor.substring (shapeAndColor.indexOf ("_") + 1);

      return getPictureMarkerSymbol (capitalize (shape), capitalize (color));

   }

}

function getPictureMarkerSymbol (shape, color) {
   return {
      "type"    : "picture-marker", // autocasts as new PictureMarkerSymbol()
      "angle"   : 0,
      "xoffset" : 0,
      "yoffset" : getShapeSymbolYOffset (shape),
      "url"     : getShapeSymbolUrl (shape, color),
      "width"   : 24,
      "height"  : 24
   };
}

function getSimpleMarkerSymbol (shape, color) {
   return {
      type: "simple-marker",
      shape: shape,
      color: color,
      outline: {
         color: [255, 255, 255],
         width: 2
      }
   };
}

function getShapeSymbolYOffset (shape) {
   return (shape === "Pin1" || shape === "Pin2") ? 10 : 0;
}

function getShapeSymbolUrl (shape, color) {
   //      return "http://static.arcgis.com/images/Symbols/Shapes/" + color + shape + "LargeB.png";
   return "symbols/" + color + shape + "LargeB.png";
}

function processTemplateExpressions (template, attributes) {

   // Check for conditions in the template and determine if certain
   // sections in the template should be visible or not.

   // A condition expression looks like this: [#ATTRIBUTENAME:OPTIONAL CODE GOES HERE#]

   // Above, ATTRIBUTENAME must be the name of an attribute added to
   // the JSON data for the object and used in the map. In this way, a
   // link (for example) can be hidden from the template if a certain
   // attribute is not set.

   var newTemplate = template;
   var regex = /\[#([A-Za-z0-9]+):(.*?)#\]/m;

   while (regex.test (newTemplate)) {
      var match = regex.exec (newTemplate);
      var expression = match [1];
      if (attributes && attributes [expression]) {
         newTemplate = newTemplate.replace (match [0], match [2]);
      } else {
         newTemplate = newTemplate.replace (match [0], "");
      }
   }

   return newTemplate;
}

// FAKE DATA

// There are two functions here, to fake data such that we don't need
// to develop and debug most of the map "inside" IFS. This is very
// powerful and allows for fast development. If you make changes to
// this code, please make sure there is good fake data so that the map
// can be tested "outside" IFS.

function getFakeMapMetadata () {

   var textsForAll = [["2dLabel",                    "2D"                       ],
                      ["3dLabel",                    "3D"                       ],
                      ["toggle2d3dtooltip",          "Toggle between 2D and 3D" ],
                      ["changeBasemapTooltip",       "Change basemap"           ],
                      ["togglePositionLabelLabel",   "Labels"                   ],
                      ["togglePositionLabelTooltip", "Toggle position labels"   ]];

   // TODO - Think about whether these symbols, or more should be part
   // of a base setup of symbols that are already there.

   var basemap;
   var template;
   var featureLayers;
   var search;
   var pluginHeight;

   template = "Scenario \"" + scenario + "\" not handled";

   if (scenario === "EquipmentObjectMainCustomer") {
      template = "<p>" +
      "<a href=\"#\" onclick=\"navigate('EquipmentObjects', 'FunctionalObject',         'Contract   eq \\'{Site}\\'');\"          >Object Details     </a>" +
      "[#LocationId: | <a href=\"#\" onclick=\"navigate('EquipmentObjects', 'MainCustEquipmentObjects', 'LocationId eq \\'{LocationId}\\'');\">Objects at Location</a>#]</p>" +
      "<table>" +
      "  <tr><td><strong> Object Type       </strong></td><td> {ObjectType}      </td></tr>" +
      "  <tr><td><strong> Belongs to Object </strong></td><td> {BelongsToObject} </td></tr>" +
      "  <tr><td><strong> Serial Number     </strong></td><td> {SerialNo}        </td></tr>" +
      "  <tr><td><strong> Location Name     </strong></td><td> {LocationName}    </td></tr>" +
      "  <tr><td><strong> Address           </strong></td><td> {Address1}        </td></tr>" +
      "  <tr><td><strong> City              </strong></td><td> {City}            </td></tr>" +
      "</table>";
      basemap = "osm";
//      search = "Oslo";
   }

   if (scenario === "EquipmentObjectEndCustomer" ) {
      template = "<p>" +
      "<a href=\"#\" onclick=\"navigate('EquipmentObjects', 'EquipmentObjectEndConsumer',         'Contract   eq \\'{Site}\\'');\"          >Object Details     </a>" +
      "[#LocationId: | <a href=\"#\" onclick=\"navigate('EquipmentObjects', 'EquipmentObjectsEndConsumer', 'LocationId eq \\'{LocationId}\\'');\">Objects at Location</a>#]</p>" +
      "<table>" +
      "  <tr><td><strong> Object Type       </strong></td><td> {ObjectType}      </td></tr>" +
      "  <tr><td><strong> Belongs to Object </strong></td><td> {BelongsToObject} </td></tr>" +
      "  <tr><td><strong> Serial Number     </strong></td><td> {SerialNo}        </td></tr>" +
      "  <tr><td><strong> Location Name     </strong></td><td> {LocationName}    </td></tr>" +
      "  <tr><td><strong> Address           </strong></td><td> {Address1}        </td></tr>" +
      "  <tr><td><strong> City              </strong></td><td> {City}            </td></tr>" +
      "</table>";
      basemap = "osm";
//      search = "Oslo";
   }

   if (scenario === "ExecutionInstance") {
      template = "<p>" +
      "<a href=\"#\" onclick=\"navigate('B2BTaskExecutor', 'ExecutorTask', 'TaskSeq eq 123');\">Assignment Detail</a> </p>" +
      "<table>" +
      "  <tr><td><strong> Coordinator      </strong></td><td> {Coordinator  } </td></tr>" +
      "  <tr><td><strong> Work Start       </strong></td><td> {PlannedStart } </td></tr>" +
      "  <tr><td><strong> Work Completion  </strong></td><td> {PlannedFinish} </td></tr>" +
      "</table>";
      basemap = "dark-gray";
      featureLayers = [{
         "url": "https://services.arcgis.com/u1pyDfVudZJk1pG6/ArcGIS/rest/services/Test/FeatureServer/0",
         "popupTitle": "My title - {Name}",
         "popupContent": "Category = {Category}"
      }];
      pluginHeight = 800;
   }

   if (scenario === "TasksForVendor")
      template = "<p>" +
      "<a href=\"#\" onclick=\"navigate('B2BTask', 'PlannerTask', 'TaskSeq eq 123');\">Assignment Detail</a> </p>" +
      "<table>" +
      "<tr><td><strong> Coordinator </strong></td><td> {Coordinator}   </td></tr>" +
      "<tr><td><strong> Asset       </strong></td><td> {Asset}         </td></tr>" +
      "<tr><td><strong> Start       </strong></td><td> {PlannedStart}  </td></tr>" +
      "<tr><td><strong> Completion  </strong></td><td> {PlannedFinish} </td></tr>" +
      "</table>";

   return {
      "texts": textsForAll,
      "basemap": basemap,
      "popupTemplate" : template,
      "featureLayers": featureLayers,
      "search": search,
      "pluginHeight": pluginHeight,
      "disableSearch": false,
      "disableBasemapSelector": false,
      "disableScaleBar": false,
      "disable3D": false,
      "disableLabelButton": false,
      "disableAutoZoom": false,
      "disableCount": false,
      "centerAt": [11, 55],
      "zoomLevel": 4,
      "objects": getFakeObjectsData (scenario)
   };
}

function getFakeObjectsData (scenario) {

   console.log("getFakeObjectsData, scenario =", scenario);

   // Fake some data/positions for each scenario.

   if (scenario === "EquipmentObjectMainCustomer")
      return [
         {
            // Common
            "Longitude"       : "11.998598414448",
            "Latitude"        : "57.6587432632518",
            "Symbol"          : "red",
            "PopupTitle"      : "The Title 3",
            "Label"           : "PU-26-32 - Connector",
//            "LabelProperties" : {"color" : "red"},
            // Specific
            "Status"          : "OUT_OF_OPERATION",
            "Site"            : "STHLM",
            "MchCode"         : "MD001",
            "ObjectDesc"      : "Mathias 1",
            "ObjectType"      : "Type 1",
            "BelongsToObject" : "Belongs 1",
            "LocationName"    : "Loc 1",
            "ClientStatus"    : "Out Of Operation",
            "SerialNo"        : "123",
            "Address1"        : "Stenbrogatan",
            "ZipCode"         : "43143",
            "City"            : "Molndal",
            "Contact"         : "Mathias",
            "ContactPhone"    : "12345",
            "ContactEmail"    : "foo@bar.com",
            "WindowTitle"     : "MD001",
            "LocationId"      : "HOT001"
         },
         {
            "Longitude"       : "0.98814155744928",
            "Latitude"        : "45.9968046309211",
            "Symbol"          : "blue",
            "PopupTitle"      : "The Title 2",
//            "Label"           : "PM-23-1 - Rotary pump",
            "Status"          : "IN_OPERATION",
            "Site"            : "STHLM",
            "MchCode"         : "PRI-7891",
            "ObjectDesc"      : "Radiator",
            "ObjectType"      : "Type 2",
            "BelongsToObject" : "Belongs 2",
            "LocationName"    : "Loc 2",
            "ClientStatus"    : "In Operation",
            "SerialNo"        : "456",
            "Address1"        : "Bagskyttegatan",
            "ZipCode"         : "45161",
            "City"            : "Uddevalla",
            "Contact"         : "Johan",
            "ContactPhone"    : "789",
            "ContactEmail"    : "bar@foo.com",
            "WindowTitle"     : "PRI-7891",
            "LocationId"      : ""
         },
         {
            "Longitude"       : "0.98814155744928",
            "Latitude"        : "45.9968046309211",
            "Symbol"          : "blue",
            "PopupTitle"      : "The Title 2b",
            "Label"           : "PM-23-2 - Rotary pump",
            "Status"          : "IN_OPERATION",
            "Site"            : "STHLM",
            "MchCode"         : "PRI-7891B",
            "ObjectDesc"      : "Radiator B",
            "ObjectType"      : "Type 2",
            "BelongsToObject" : "Belongs 2",
            "LocationName"    : "Loc 2",
            "ClientStatus"    : "In Operation",
            "SerialNo"        : "456",
            "Address1"        : "Bagskyttegatan",
            "ZipCode"         : "45161",
            "City"            : "Uddevalla",
            "Contact"         : "Johan",
            "ContactPhone"    : "789",
            "ContactEmail"    : "bar@foo.com",
            "WindowTitle"     : "PRI-7891",
            "LocationId"      : ""
         }
      ];

   if (scenario === "EquipmentObjectEndCustomer")
      return [
         {
            "Longitude"       : "11.998598414448",
            "Latitude"        : "57.6587432632518",
            "Symbol"          : "yellow",
            "PopupTitle"      : "The Title 2",
            "Label"           : "Label 2",
            "Status"          : "OUT_OF_OPERATION",
            "Site"            : "STHLM",
            "MchCode"         : "MD001",
            "ObjectDesc"      : "Mathias 1",
            "ObjectType"      : "Sicken typ",
            "BelongsToObject" : "Does not belong",
            "LocationName"    : "Where?",
            "ClientStatus"    : "Out Of Operation",
            "SerialNo"        : "00001",
            "Address1"        : "Ostanvindsvaegen 13",
            "ZipCode"         : "45152",
            "City"            : "Uddevalla",
            "Contact"         : "Farmor",
            "ContactPhone"    : "123-4566",
            "ContactEmail"    : "a@b.com",
            "WindowTitle"     : "MD001",
            "LocationId"      : "HOT001"
         }];

   if (scenario === "ExecutionInstance")
      return [
         {
            "Longitude"            : "12.9765701293945" ,
            "Latitude"             : "57.9405521497399",
            "Symbol"               : "green",
            "PopupTitle"           : "The Title 1",
            "Label"                : "Label 2",
            "ObjectState"          : "1",
            "TaskSeq"              : "2358",
            "ExecutionInstanceSeq" : "4",
            "Name"                 : "2358 - Assign 5",
            "PlannedStart"         : "25-JAN-18",
            "PlannedFinish"        : "25-JAN-18",
            "Status"               : "Assigned",
            "Coordinator"          : "Andrew Pete"
         },
         {
            "Longitude"            :"12.9765701293945" ,
            "Latitude"             :"57.7405521497399",
            "Symbol"               : "blue",
            "PopupTitle"           : "The Title 2",
            "Label"                : "Label 2",
            "ObjectState"          :"1",
            "TaskSeq"              :"2358",
            "ExecutionInstanceSeq" :"2",
            "Name"                 :"2358 - Assign 5",
            "PlannedStart"         :"11-JAN-18",
            "PlannedFinish"        :"11-JAN-18",
            "Status"               :"Assigned",
            "Coordinator"          :"Andrew Pete"
         },
         {
            "Longitude"            :  "-1.70116424560547",
            "Latitude"             :  "53.3859903951964",
            "Symbol"               : "red",
            "PopupTitle"           : "The Title 3",
            "Label"                : "Label 2",
            "ObjectState"          :  "1",
            "TaskSeq"              :  "2976",
            "ExecutionInstanceSeq" :  "2",
            "Name"                 :  "2976 - Sub Contract wor - kA1 - Task1",
            "PlannedStart"         :  "26-JAN-18",
            "PlannedFinish"        :  "26-JAN-18",
            "Status"               :  "Assigned",
            "Coordinator"          :  "Andrew Pete"
         }];

   if (scenario === "TasksForVendor")
      return [
         {
            "Longitude"     : "-1.996968",
            "Latitude"      : "51.979369",
            "Symbol"        : "blue",
            "PopupTitle"    : "The Title 3",
            "Label"         : "Label 2",
            "StatusLevel"   : "4",
            "TaskSeq"       : "1557",
            "TaskDesc"      : "Monthly Inspeacti...",
            "PlannedStart"  : "",
            "PlannedFinish" : "",
            "Status"        : "Released",
            "Asset"         : "GAS-BOLIER 78 - Shellbol Mk.II 78, Shellbol Mk.II ,Output 3,000 kg/h (BS 2790 -1989)",
            "Coordinator"   : "Kathrin Fiest"
         },
         {
            "Longitude"     : "-2.996968",
            "Latitude"      : "52.979369",
            "Symbol"        : "blue",
            "PopupTitle"    : "The Title 1",
            "Label"         : "Label 3",
            "StatusLevel"   : "5",
            "TaskSeq"       : "1559",
            "TaskDesc"      : "Monthly Inspectio...",
            "PlannedStart"  : "31-JAN-18",
            "PlannedFinish" : "31-JAN-18",
            "Status"        : "Something 1",
            "Asset"         : "GAS-BOLIER 78 - Shellbol Mk.II 78, Shellbol Mk.II ,Output 3,000 kg/h (BS 2790 -1989)",
            "Coordinator"   : "Andrew Pete"
         },
         {
            "Longitude"     : "-3.996968",
            "Latitude"      : "53.979369",
            "Symbol"        : "blue",
            "PopupTitle"    : "The Title 2",
            "Label"         : "Label 1",
            "StatusLevel"   : "3",
            "TaskSeq"       : "1559",
            "TaskDesc"      : "Monthly Inspectio...",
            "PlannedStart"  : "31-JAN-18",
            "PlannedFinish" : "31-JAN-18",
            "Status"        : "Somethin 2",
            "Asset"         : "GAS-BOLIER 78 - Shellbol Mk.II 78, Shellbol Mk.II ,Output 3,000 kg/h (BS 2790 -1989)",
            "Coordinator"   : "Andrew Pete"
         }
      ];

   // Fallback
   return [];

}

// LABEL HANDLING

// Since labels only work for feature layers, we will simulate them
// using normal text symbols.

function labelsExist () {
   return getLabels ().length > 0;
}

function getLabels () {
   return graphicsLayer.graphics.items.filter (function (g) {
      return (g.symbol.type === "text");
   });
}

function removeLabels () {
   getLabels ().forEach (function (l) {
      graphicsLayer.remove (l);
   });
}

function createTextSymbol (text, overriddenProperties) {

   // Allow override of almost all properties of the text symbol.

   // Get property of the overridden properties if it exist, otherwise
   // return a default value.

   function prop (name, defaultValue) {
      return (overriddenProperties && overriddenProperties [name]) ? overriddenProperties [name] : defaultValue;
   }

   return {
      type                : "text",
      text                : text,
      horizontalAlignment : prop ("horizontalAlignment", "left"),
      color               : prop ("color",               "black"),
      haloColor           : prop ("haloColor",           "white"),
      haloSize            : prop ("haloSize",            "1px"),
      xoffset             : prop ("xoffset",             0),
      yoffset             : prop ("yoffset",             15),
      font : {
         size             : prop ("fontSize",                  12),
         family           : prop ("fontFamily",                "sans-serif"),
         decoration       : prop ("fontDecoration",            "none"),
         weight           : prop ("fontWeight",                "bolder")
      }
   };
}

function getAllLabelGeometries () {
   return graphicsLayer.graphics.items.filter (function (g) {
      return (g && g.symbol.type === "text");
   }).map (function (g) {
      return g.geometry;
   });
}

function getAllObjectGeometries () {
   return graphicsLayer.graphics.items.filter (function (g) {
      return (g && g.symbol.type !== "text" && g.attributes);
   }).map (function (g) {
      return g.geometry;
   });
}

function countAllObjectGeometriesAtLocation (geometry) {
   return getAllObjectGeometries ().filter (function (g) {
      return (g.x === geometry.x && g.y === geometry.y);
   }).length;
}

function labelWithGeometryExist (geometry) {
   return getAllLabelGeometries ().filter (function (g) {
      return (g.x === geometry.x && g.y === geometry.y);
   }).length > 0;
}

function addLabels () {
   require([
      "esri/Graphic"
   ], function (Graphic) {
      graphicsLayer.graphics.items.filter (function (g) {
         return (g && g.symbol.type !== "text");
         // The reason for drawing the labels in reversed order is
         // that the label that end up being visible should match the
         // first object that is shown in the information dialog that
         // opens up.
      }).reverse ().forEach (addLabel);
   });
}

function addLabel (g) {

   require([
      "esri/Graphic"
   ], function (Graphic) {

      // Only add a label if it has a value and only if no other
      // label is on the same place

      if (!labelWithGeometryExist (g.geometry)) {

         var labelText;

         // By default, the label text comes from the object's
         // Label property.

         if (g.attributes && g.attributes.Label)
            labelText = g.attributes.Label;

         var objectCount;

         if (!mapMetadata.disableCount) {

            objectCount = countAllObjectGeometriesAtLocation (g.geometry);

            // Override and only show the number of objects.

            if (objectCount > 1)
               labelText = "(" + objectCount + ")";

         }

         if (labelText) {
            var labelGraphic = new Graphic ({
               geometry: g.geometry,
               symbol: createTextSymbol (labelText, g.attributes.LabelProperties)
            });

            graphicsLayer.add (labelGraphic);
         }
      }
   });

}

// MAIN

function createMap () {
   require([
      "esri/Map",
      "esri/views/MapView",
      "esri/views/SceneView",
      "esri/layers/GraphicsLayer",
      "esri/layers/FeatureLayer",
      "esri/layers/TileLayer",
      "esri/widgets/Search",
      "esri/widgets/BasemapGallery",
      "esri/widgets/Expand",
      "esri/widgets/Compass",
      "esri/widgets/ScaleBar",
      "dojo/domReady!"
   ], function(Map, MapView, SceneView, GraphicsLayer, FeatureLayer, TileLayer, Search, BasemapGallery, Expand, Compass, ScaleBar) {

      // OSM (Open Street Map) is a very detailed and nice map on street
      // level. Better than "streets", which is the default we had in the
      // GIS Integration (but there the customer can pick any basemap
      // they like).

      var basemap = "streets";

      if (mapMetadata.basemap)
         basemap = mapMetadata.basemap;


      if (mapMetadata.basemapUrl)
         map = new Map({
            //basemap: basemap,
            ground: "world-elevation"
         });
      else
         map = new Map({
            basemap: basemap,
            ground: "world-elevation"
         });

      appConfig = {
         mapView: null,
         sceneView: null,
         activeView: null,
         container: "viewDiv" // use same container for views
      };

      var initialViewParams = {
         map: map,
         zoom: (mapMetadata.zoomLevel) ? mapMetadata.zoomLevel : 2,
         center: (mapMetadata.centerAt) ? mapMetadata.centerAt : null,
         container: appConfig.container
      };

      // create 2D view and and set active
      appConfig.mapView = createView(initialViewParams, "2d");
      appConfig.activeView = appConfig.mapView;


      // Load the basemap
      try {

         var layerId = -1;
         // Use a fallback basemap
         var baseMapLayerUrl = "https://www.arcgis.com/home/webmap/viewer.html?webmap=b834a68d7a484c5fb473d4ba90d35e71";

         if (mapMetadata.basemapUrl)
            baseMapLayerUrl = mapMetadata.basemapUrl;

         if (baseMapLayerUrl.lastIndexOf('/') + 1 < baseMapLayerUrl.length) {
            layerId = baseMapLayerUrl.substring(baseMapLayerUrl.lastIndexOf('/') + 1);
         }

         if (layerId > -1) {
            baseMapLayerUrl = baseMapLayerUrl.substring(0, baseMapLayerUrl.lastIndexOf('/'));
         }


         // Basemap layers are always loaded as TileLayers.
         var baseMapServiceLayer = new TileLayer({
            url: baseMapLayerUrl,
            visible: true
         });

         map.add(baseMapServiceLayer);  // adds the layer to the map

      } catch (e) {
         alert("Error when loading the basemap" + e);
      }
      //-------

      if (mapMetadata.featureLayers && mapMetadata.featureLayers.length > 0) {

         console.log("Adding featurelayers:", mapMetadata.featureLayers);

         mapMetadata.featureLayers.forEach (function (l) {
            featureLayer = new FeatureLayer({
               url: l.url,
               outFields: ["*"],
               popupTemplate: (l.popupTitle && l.popupContent) ? {title: l.popupTitle, content: l.popupContent} : null
            });
            map.add (featureLayer);
         })
      }

      graphicsLayer = new GraphicsLayer({id:'pointLayer'});
      map.add (graphicsLayer);

      if (!mapMetadata.disableSearch) {
         searchWidget = new Search({
            view: appConfig.mapView
         });
         appConfig.mapView.ui.add(searchWidget, {
            position: "top-right",
            index: 2
         });
      }

      var compass = new Compass({
         view: appConfig.mapView
      });

      appConfig.mapView.ui.add(compass, "top-left");

      var scaleBar;

      function addScaleBar () {

         if (scaleBar && scaleBar.destroy)
            scaleBar.destroy ();

         scaleBar = new ScaleBar({
            view: appConfig.mapView,
            unit: "dual" // The scale bar displays both metric and non-metric units.
         });

         appConfig.mapView.ui.add(scaleBar, {
            position: "bottom-left"
         });
      }

      if (!mapMetadata.disableScaleBar) {
         addScaleBar ();
      }

      if (!mapMetadata.disableBasemapSelector) {

         var basemapGallery = new BasemapGallery({
            view: appConfig.mapView,
            container: document.createElement("div")
         });

         // Put the basemap gallery inside an expand widget such that it
         // does not take up any room when the user does not need it.

         var bgExpand = new Expand({
            view: appConfig.mapView,
            content: basemapGallery.domNode,
            expandTooltip: getText ("changeBasemapTooltip"),
            expandIconClass: "esri-icon-basemap"
         });

         appConfig.mapView.ui.add(bgExpand, "bottom-right");
      }

      // create 3D view, won't initialize until container is set
      initialViewParams.container = null;
      appConfig.sceneView = createView(initialViewParams, "3d");

      var switchButton = document.getElementById("switch-btn");

      if (mapMetadata.disable3D) {
         switchButton.style.display = "none";
      } else {
         switchButton.value = getText ("3dLabel");
         switchButton.title = getText ("toggle2d3dtooltip");

         // switch the view between 2D and 3D each time the button is clicked
         switchButton.addEventListener("click", function() {
            switchView();
         });
      }

      var labelButton = document.getElementById("label-btn");

      if (mapMetadata.disableLabelButton) {
         labelButton.style.display = "none";
      } else {
         labelButton.value = getText ("togglePositionLabelLabel");
         labelButton.title = getText ("togglePositionLabelTooltip");

         labelButton.addEventListener("click", function() {
            if (labelsExist ())
               removeLabels ();
            else
               addLabels ();
         });
      }


      // Switches the view from 2D to 3D and vice versa
      function switchView () {
         var is3D = appConfig.activeView.type === "3d";

         var oldViewpoint = appConfig.activeView.viewpoint.clone();

         // remove the reference to the container for the previous view
         appConfig.activeView.container = null;

         if (is3D) {
            // If the input view is a SceneView, set the viewpoint on the
            // mapView instance. Set the container on the mapView and flag
            // it as the active view
            appConfig.mapView.viewpoint = oldViewpoint;
            appConfig.mapView.container = appConfig.container;
            appConfig.activeView = appConfig.mapView;
            switchButton.value = getText ("3dLabel");

            if (!mapMetadata.disableScaleBar) {
               console.log("Add back scale bar...");
               addScaleBar ();
            }

         } else {
            appConfig.sceneView.viewpoint = oldViewpoint;
            appConfig.sceneView.container = appConfig.container;
            appConfig.activeView = appConfig.sceneView;
            switchButton.value = getText ("2dLabel");
            switchButton.title = getText ("toggle2d3dtooltip");
         }
      }

      function createView(params, type) {
         var view;
         var is2D = type === "2d";
         if (is2D) {
            view = new MapView(params);
            return view;
         } else {
            view = new SceneView(params);
         }
         return view;
      }

      plotAndZoom (mapMetadata.objects);
      createContextMenu();
   });

}


function setMapMetadata () {

   // The scenario is important since it identifies the use of the
   // map.

   handleQueryParameters ();

   // Next, get the base metadata for the map (texts, popup template,
   // etc.) as well as all objects.

   if (inIframe ()) {

      if (!mapMetadataProjection)
      {
         alert ("Projection name must be set!")
      } else {

         // TODO - As others start to use this map, we probably cannot
         // have this hardcoded against B2B...  When that happens we
         // can introduce another query parameter (default can be B2B
         // to avoid changing old code) for controlling if it should
         // be main or B2B.

         if (userCategory == "b2b")
            $.ajax({

               url: "/" + userCategory + "/ifsapplications/projection/v1/" + mapMetadataProjection + ".svc/GetMapMetadata(Scenario='" + scenario + "')",
               data: "", // No special data to be sent apart from the query parameters
               contentType: "application/json; charset=utf-8",
               type: "GET",
               async: true,
               success: function (stuff) {
                  if (stuff.value === "NODATAFOUND") {
                     alert ("No metadata found for scenario " + scenario);
                  }
                  else {
                     mapMetadata = JSON.parse (stuff.value);

                     console.log("mapMetadata =", mapMetadata);
                     setViewPortHeight ();
                     createMap ();
                  }
               },
               error: function (x, y, z) {
                  alert(x.responseText + "  " + x.status);
               }
            });
         else
            $.ajax({

            url: "/" + userCategory + "/ifsapplications/projection/v1/" + mapMetadataProjection + ".svc/GetMapMetadata(KeyRef=" + keyRef + ")",
            data: "", // No special data to be sent apart from the query parameters
            contentType: "application/json; charset=utf-8",
            type: "GET",
            async: true,
            success: function (stuff) {
               if (stuff.value === "NODATAFOUND") {
                  alert ("No metadata found for scenario " + scenario);
               }
               else {
                  mapMetadata = JSON.parse (stuff.value);

                  console.log("mapMetadata =", mapMetadata);
                  setViewPortHeight ();
                  createMap ();
               }
            },
            error: function (x, y, z) {
               alert(x.responseText + "  " + x.status);
            }
         });

      }
   } else {
      mapMetadata = getFakeMapMetadata ();
      setViewPortHeight ();
      createMap ();
   }
}
 function createContextMenu() {
      require([
         "dijit/Menu",
         "dijit/MenuItem",
         "dijit/MenuSeparator",
         "dijit/CheckedMenuItem",
         "dijit/popup",
		   "esri/Graphic",
		   "esri/geometry/support/jsonUtils",
		   "esri/symbols/SimpleMarkerSymbol",
		   "esri/geometry/Point"
      ], function (Menu, MenuItem, MenuSeparator, CheckedMenuItem,popup,Graphic,geometryJsonUtils,SimpleMarkerSymbol,Point) {
	       let contextMenuClickLocation  ;

		  	   ctxMenuForMap = new Menu({
          onOpen: function (box) {
            if (appConfig.activeView.type != "3d"){
            contextMenuClickLocation = getMapPointFromMenuPosition(box);
            }
            else{
               popup.close();
               return;
            }
            }
          });
  
          var ElementmarkerSymbol = getSymbol ( (mapMetadata.defaultSymbol) ? mapMetadata.defaultSymbol : "blue");
          
	         AddPosition = new CheckedMenuItem({
               label: "Add Position",
               id: "ADD_POSITION",
               disable : true,
            onClick: function () {
		      moveGraphic(new Graphic(geometryJsonUtils.fromJSON(contextMenuClickLocation.toJSON()),ElementmarkerSymbol));
		      CRUD_Operation(contextMenuClickLocation.latitude ,contextMenuClickLocation.longitude,"C");
            }
         });
         RemovePosition = new CheckedMenuItem({
            label: "Remove Position",
            id: "REMOVE_POSITION",
            disable : true,
            onClick: function () {
      
            deleteGraphic = 'true';
            removeGraphic();
            CRUD_Operation(null ,null,"D");
         }
         });

		    if(addPosition =="true"){
            ctxMenuForMap.addChild(AddPosition);
            ctxMenuForMap.addChild(RemovePosition);

            ctxMenuForMap.startup();
            ctxMenuForMap.bindDomNode(appConfig.mapView.container);
			 }
    
			function getMapPointFromMenuPosition(box) {
			    var screenPoint;
				var x = box.x;
				var y = box.y;


			   switch (box.corner) {
			   case "TR":
				  x += box.w;
				  break;
			   case "BL":
				  y += box.h;
				  break;
			   case "BR":
				  x += box.w;
				  y += box.h;
				  break;
			   }
              const rect = appConfig.mapView.container.getBoundingClientRect();
				screenPoint =new Point(x - rect.left, y - rect.top);
				console.log(screenPoint);

			return appConfig.mapView.toMap(screenPoint) ;
			}
   });

}

function CRUD_Operation(latitude ,longitude,Operation){
	var returnValue;
     if(Operation =="C"){
	     if (isEmpty(mapMetadata.objects)){
	                        $.ajax({
                                    url: "/main/ifsapplications/projection/v1/"+mapMetadataProjection+".svc/CreateMapPosition",
                                    data: JSON.stringify({"LuName":currentRecord.luname,"KeyRef":currentRecord.keyref,"Longitude":longitude,"Latitude":latitude}),
                                    contentType: "application/json; charset=utf-8",
                                    type: "POST",
                                    beforeSend: function (request) {
                                    // We need to set this header to protect from CSRF
                                    request.setRequestHeader("X-XSRF-TOKEN",GetXsrfToken());
                                    },			
                                    async: false,
                                    success: function (stuff) {
                                       returnValue = stuff.value;
                                    },
                                    error: function (x, y, z) {
                                       alert(x.responseText + "  " + x.status);
                                    }
                                 });
		 }
      else {

							$.ajax({
                                    url: "/main/ifsapplications/projection/v1/"+mapMetadataProjection+".svc/CreateAndReplaceMapPosition",
                                    data: JSON.stringify({"LuName":currentRecord.luname,"KeyRef":currentRecord.keyref,"Longitude":longitude,"Latitude":latitude,"Altitude":NaN}),
                                    contentType: "application/json; charset=utf-8",
                                    type: "POST",
                                    headers: postHeaders,
                                    beforeSend: function (request) {
                                    // We need to set this header to protect from CSRF
                                    request.setRequestHeader("X-XSRF-TOKEN", GetXsrfToken());
                                    },			
                                    async: false,
                                    success: function (stuff) {
                                       returnValue = stuff.value;
                                    },
                                    error: function (x, y, z) {
                                       alert(x.responseText + "  " + x.status);
                                    }
                                 });
       }
      }
      if(Operation =="D"){
    
                     $.ajax({
                        url: "/main/ifsapplications/projection/v1/"+mapMetadataProjection+".svc/RemoveMapPosition",
                        data: JSON.stringify({"LuName":currentRecord.luname,"KeyRef":currentRecord.keyref}),
                        contentType: "application/json; charset=utf-8",
                        type: "POST",
                        beforeSend: function (request) {
                        // We need to set this header to protect from CSRF
                        request.setRequestHeader("X-XSRF-TOKEN", GetXsrfToken());
                        },			
                        async: false,
                        success: function (stuff) {
                           returnValue = stuff.value;
                        },
                        error: function (x, y, z) {
                           alert(x.responseText + "  " + x.status);
                        }
                     });
       }

}

function isEmpty(obj) {
    for(var key in obj) {
        if(obj.hasOwnProperty(key))
            return false;
    }
    return true;
}
function moveGraphic(graphic){
  newGraphic = graphic.clone();
  graphicsLayer.removeAll ();
  graphicsLayer.add(newGraphic);
}
function removeGraphic(graphic){
   graphicsLayer.removeAll ();
}
// Get CSRF cookie and use in post, patch request headers.
function GetXsrfToken() {
   var name = "XSRF-TOKEN=";               
   var decodedCookie = decodeURIComponent(parent.document.cookie);             
   var ca = decodedCookie.split(';');
  for (var i = 0; i < ca.length; i++) {            
       var c = ca[i];
      while (c.charAt(0) == ' ') {
          c = c.substring(1);
       }
       if (c.indexOf(name) == 0) {               
           return c.substring(name.length, c.length);
       }
   }        
   return "";
}
