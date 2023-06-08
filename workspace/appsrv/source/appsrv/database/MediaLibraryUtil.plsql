-----------------------------------------------------------------------------
--
--  Logical unit: MediaLibraryUtil
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140818  SHEPLK  SAUXXW4-9309, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Media_File_Ext_List RETURN VARCHAR2
IS
BEGIN
   RETURN '.png,.jpg,.jpeg,.gif,.bmp,.tif,.mp3,.wma,.ogg,.mid,.aac,.wmv,.wav,.txt,.mov,.mp4,.flv,.vob,.avi,.mkv,.mng,.amv,.mpeg,.m4v,.3gp,.mxf,.mpv';   
END Get_Media_File_Ext_List;

-------------------- LU  NEW METHODS -------------------------------------
