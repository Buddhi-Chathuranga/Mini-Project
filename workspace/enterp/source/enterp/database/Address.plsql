-----------------------------------------------------------------------------
--
--  Logical unit: Address
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981012  Camk    Created
--  981126  Camk    New table names. Domain_id is hardcode (DEFAULT)
--  981203  Camk    Get_Country() added.
--  991228  LiSv    Corrected bug #13129, changed substr_b to substr in function
--                  Get_Line.
--  060712  Paralk  Change length of address_id 20 characters to 50 characters
--  091202  Yothlk  Bug 87326, Added new function Get_Address_Name
--  091208  Krpelk  Eagle Project - Added new function Get_Address_Name to avoid
--                  fresh installation erros. Model changes were not merged.
--  130614  DipeLK  TIBE-726, Removed global variable which check the exsistance of INVENT component
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Split_Addr_Line___ (
   zip_code_   OUT VARCHAR2,
   city_       OUT VARCHAR2,
   domain_id_  IN  VARCHAR2,
   party_      IN  VARCHAR2,
   address_id_ IN  VARCHAR2,
   country_    IN  VARCHAR2 )
IS
   line_       VARCHAR2(200);
   tmp_zip_    VARCHAR2(20) := NULL;
   chr_        VARCHAR2(1);
   s_exists_   BOOLEAN := FALSE;
   digit_cnt_  NUMBER := 0;
BEGIN
   zip_code_ := NULL;
   city_ := NULL;
   IF (country_ = 'SE') THEN
      line_ := Get_Line(domain_id_, party_, address_id_, 0);
      FOR i IN 1..LENGTH(line_) LOOP
         chr_ := SUBSTR(line_, i, 1);
         IF (chr_ = CHR(32)) THEN
            NULL;
         ELSIF (UPPER(chr_) = 'S' AND digit_cnt_ = 0) THEN
            s_exists_ := TRUE;
         ELSIF (chr_ = '-' AND s_exists_ AND digit_cnt_ = 0) THEN
            NULL;
         ELSIF (ASCII(chr_) BETWEEN 48 AND 57 AND digit_cnt_ < 5) THEN
            digit_cnt_ := digit_cnt_ + 1;
            tmp_zip_ := tmp_zip_ || chr_;
            IF (digit_cnt_ = 3) THEN
               tmp_zip_ := tmp_zip_ || CHR(32);
            END IF;
         ELSIF (digit_cnt_ = 5) THEN
            zip_code_ := tmp_zip_;
            city_ := SUBSTR(line_, i);
            EXIT;
         ELSE
            EXIT;
         END IF;
      END LOOP;
   END IF;
END Split_Addr_Line___;


FUNCTION Check_Exist___ (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   address
      WHERE  domain_id = domain_id_
      AND    party = party_
      AND    address_id = address_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Zip_Code (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   zip_code_  VARCHAR2(20);
   city_      VARCHAR2(200);
   country_   VARCHAR2(20);
   CURSOR getattr IS
      SELECT country
      FROM   address
      WHERE  domain_id = domain_id_
      AND    party = party_
      AND    address_id = address_id_;
BEGIN
   OPEN getattr;
   FETCH getattr INTO country_;
   CLOSE getattr;
   Split_Addr_Line___(zip_code_, city_, domain_id_, party_, address_id_, Iso_Country_API.Encode(country_));
   RETURN zip_code_;
END Get_Zip_Code;


@UncheckedAccess
FUNCTION Get_City (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   zip_code_  VARCHAR2(20);
   city_      VARCHAR2(200);
   country_   VARCHAR2(20);
   CURSOR getattr IS
      SELECT country
      FROM   address
      WHERE  domain_id = domain_id_
      AND    party = party_
      AND    address_id = address_id_;
BEGIN
   OPEN getattr;
   FETCH getattr INTO country_;
   CLOSE getattr;
   Split_Addr_Line___(zip_code_, city_, domain_id_, party_, address_id_, Iso_Country_API.Encode(country_));
   RETURN city_;
END Get_City;


@UncheckedAccess
FUNCTION Get_Line (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   address_id_ IN VARCHAR2,
   line_no_    IN NUMBER DEFAULT 1 ) RETURN VARCHAR2
IS
   addr_   VARCHAR2(2000) := CHR(10) || RTRIM(REPLACE(Get_Address(domain_id_, party_, address_id_), CHR(13), ''), CHR(10)) || CHR(10);
   start_  NUMBER;
   end_    NUMBER;
   cnt_    NUMBER;
BEGIN
   -- If line_no_ = 0 then return last line
   IF (line_no_ = 0) THEN
      cnt_ := Get_Lines_Count(domain_id_, party_, address_id_);
   ELSE
      cnt_ := line_no_;
   END IF;
   start_ := NVL(INSTR(addr_, CHR(10), 1, cnt_), 0);
   end_   := NVL(INSTR(addr_, CHR(10), 1, cnt_ + 1), 0);
   RETURN SUBSTR(addr_, start_ + 1, end_ - start_ - 1);
END Get_Line;


@UncheckedAccess
FUNCTION Get_Lines_Count (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   addr_  VARCHAR2(2000) := RTRIM(REPLACE(Get_Address(domain_id_, party_, address_id_), CHR(13), ''), CHR(10));
   ptr_   NUMBER;
   cnt_   NUMBER := 1;
BEGIN
   LOOP
      ptr_ := INSTR(addr_, CHR(10));
      IF (ptr_ > 0 AND ptr_ < LENGTH(addr_)) THEN
         cnt_ := cnt_ + 1;
         addr_ := SUBSTR(addr_, ptr_ + 1);
      ELSE
         EXIT;
      END IF;
   END LOOP;
   RETURN cnt_;
END Get_Lines_Count;


@UncheckedAccess
PROCEDURE Exist (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(domain_id_, party_, address_id_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Address (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ address.address%TYPE;
   CURSOR get_attr IS
      SELECT address
      FROM   address
      WHERE  domain_id = domain_id_
      AND    party = party_
      AND    address_id = address_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address;


@UncheckedAccess
FUNCTION Get_Address_Name (
   company_    IN  VARCHAR2,
   address_id_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   name_  VARCHAR2(100);
BEGIN
   $IF Component_Invent_SYS.INSTALLED $THEN
      name_ := Company_Address_Deliv_Info_API.Get_Address_Name(company_, address_id_);
   $ELSE
      name_ :=NULL;
   $END
   RETURN name_;
END Get_Address_Name;


@UncheckedAccess
FUNCTION Get_Country (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ address.country%TYPE;
   CURSOR get_attr IS
      SELECT country
      FROM   address
      WHERE  domain_id = domain_id_
      AND    party = party_
      AND    address_id = address_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Country;



