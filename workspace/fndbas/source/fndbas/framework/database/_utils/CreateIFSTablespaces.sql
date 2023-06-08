SET serverout ON
   
--PROMPT CREATE IFS TABLESPACES

DECLARE
   file_size_large_ VARCHAR2(10) := '1000M';
   file_size_small_ VARCHAR2(10) := '100M';
   inc_size_large_  VARCHAR2(10) := '100M';
   inc_size_small_  VARCHAR2(10) := '10M';
   found_folder_    BOOLEAN;
   folder_          VARCHAR2(1000);
   default_folder_  VARCHAR2(1000);
   file_name_       VARCHAR2(1000);
   CURSOR get_default_folder IS
      SELECT file_name
      FROM dba_data_files
      ORDER BY DECODE(SUBSTR(tablespace_name, 1, 6), 'IFSAPP', '0', 'SYSTEM', '1', '2'), file_name;

   PROCEDURE Add_Tablespace (
      tablespace_ IN VARCHAR2,
      size_       IN VARCHAR2,
      inc_size_   IN VARCHAR2,
      datafile_   IN VARCHAR2 )
   IS
      dummy_   NUMBER;
      stmt_    VARCHAR2(1000);
      CURSOR check_exist (name_ VARCHAR2) IS
         SELECT 1
         FROM dba_tablespaces
         WHERE tablespace_name = UPPER(name_);
   BEGIN
      OPEN check_exist (tablespace_);
      FETCH check_exist INTO dummy_;
      IF check_exist%FOUND THEN
         CLOSE check_exist;
         Dbms_Output.Put_Line('Tablespace '|| tablespace_ ||' already exists');
      ELSE
         CLOSE check_exist;
         Dbms_Output.Put_Line('Creating tablespace '|| tablespace_);
         stmt_ := ' CREATE TABLESPACE "'||tablespace_||'" LOGGING '||
                  ' DATAFILE '''||datafile_||''' SIZE '||size_||' AUTOEXTEND ON NEXT '||inc_size_||
                  ' EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO';
         EXECUTE IMMEDIATE stmt_;
      END IF;
   END Add_Tablespace;
BEGIN
   OPEN get_default_folder;
   FETCH get_default_folder INTO file_name_;
   IF get_default_folder%FOUND THEN
      CLOSE get_default_folder;
      found_folder_ := TRUE;
      file_name_ := REPLACE(file_name_, '\', '/');    -- Front slash to support both Windows and Unix/Linux
      default_folder_ := SUBSTR(file_name_, 1, INSTR(file_name_, '/', -1));
   ELSE
      CLOSE get_default_folder;
      found_folder_ := FALSE;
   END IF;
   IF found_folder_ THEN
      folder_ := '&IFSAPP_DATA_PATH';
      IF UPPER(folder_) = 'DEFAULT' 
      OR folder_ IS NULL THEN
         folder_ := default_folder_;
      ELSE 
         folder_ := REPLACE(folder_, '\', '/');    -- Front slash to support both Windows and Unix/Linux
         IF SUBSTR(folder_, -1) != '/' THEN
            folder_ := folder_ || '/';
         END IF;
      END IF;
      Add_Tablespace('&IFSAPP_DATA', file_size_large_, inc_size_large_, folder_||LOWER('&IFSAPP_DATA')||'01.dbf');
      folder_ := '&IFSAPP_INDEX_PATH';
      IF UPPER(folder_) = 'DEFAULT' 
      OR folder_ IS NULL THEN
         folder_ := default_folder_;
      ELSE 
         folder_ := REPLACE(folder_, '\', '/');    -- Front slash to support both Windows and Unix/Linux
         IF SUBSTR(folder_, -1) != '/' THEN
            folder_ := folder_ || '/';
         END IF;
      END IF;
      Add_Tablespace('&IFSAPP_INDEX', file_size_large_, inc_size_large_, folder_||LOWER('&IFSAPP_INDEX')||'01.dbf');
      folder_ := '&IFSAPP_ARCHIVE_DATA_PATH';
      IF UPPER(folder_) = 'DEFAULT' 
      OR folder_ IS NULL THEN
         folder_ := default_folder_;
      ELSE 
         folder_ := REPLACE(folder_, '\', '/');    -- Front slash to support both Windows and Unix/Linux
         IF SUBSTR(folder_, -1) != '/' THEN
            folder_ := folder_ || '/';
         END IF;
      END IF;
      Add_Tablespace('&IFSAPP_ARCHIVE_DATA', file_size_small_, inc_size_small_, folder_||LOWER('&IFSAPP_ARCHIVE_DATA')||'01.dbf');
      folder_ := '&IFSAPP_ARCHIVE_INDEX_PATH';
      IF UPPER(folder_) = 'DEFAULT' 
      OR folder_ IS NULL THEN
         folder_ := default_folder_;
      ELSE 
         folder_ := REPLACE(folder_, '\', '/');    -- Front slash to support both Windows and Unix/Linux
         IF SUBSTR(folder_, -1) != '/' THEN
            folder_ := folder_ || '/';
         END IF;
      END IF;
      Add_Tablespace('&IFSAPP_ARCHIVE_INDEX', file_size_small_, inc_size_small_, folder_||LOWER('&IFSAPP_ARCHIVE_INDEX')||'01.dbf');
      folder_ := '&IFSAPP_LOB_PATH';
      IF UPPER(folder_) = 'DEFAULT' 
      OR folder_ IS NULL THEN
         folder_ := default_folder_;
      ELSE 
         folder_ := REPLACE(folder_, '\', '/');    -- Front slash to support both Windows and Unix/Linux
         IF SUBSTR(folder_, -1) != '/' THEN
            folder_ := folder_ || '/';
         END IF;
      END IF;
      Add_Tablespace('&IFSAPP_LOB', file_size_large_, inc_size_large_, folder_||LOWER('&IFSAPP_LOB')||'01.dbf');
      folder_ := '&IFSAPP_REPORT_DATA_PATH';
      IF UPPER(folder_) = 'DEFAULT' 
      OR folder_ IS NULL THEN
         folder_ := default_folder_;
      ELSE 
         folder_ := REPLACE(folder_, '\', '/');    -- Front slash to support both Windows and Unix/Linux
         IF SUBSTR(folder_, -1) != '/' THEN
            folder_ := folder_ || '/';
         END IF;
      END IF;
      Add_Tablespace('&IFSAPP_REPORT_DATA', file_size_small_, inc_size_small_, folder_||LOWER('&IFSAPP_REPORT_DATA')||'01.dbf');
      folder_ := '&IFSAPP_REPORT_INDEX_PATH';
      IF UPPER(folder_) = 'DEFAULT' 
      OR folder_ IS NULL THEN
         folder_ := default_folder_;
      ELSE 
         folder_ := REPLACE(folder_, '\', '/');    -- Front slash to support both Windows and Unix/Linux
         IF SUBSTR(folder_, -1) != '/' THEN
            folder_ := folder_ || '/';
         END IF;
      END IF;
      Add_Tablespace('&IFSAPP_REPORT_INDEX', file_size_small_, inc_size_small_, folder_||LOWER('&IFSAPP_REPORT_INDEX')||'01.dbf');
   END IF;
END;
/




