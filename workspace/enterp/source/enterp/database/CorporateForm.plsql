-----------------------------------------------------------------------------
--
--  Logical unit: CorporateForm
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020130  jakalk  Created.
--  020213  Jakalk  Added Insert_Lu_Data_Rec__
--  020215  Upulp   IID 10090 Z5 Proposal Added Get_Corporate_Form_
--  020313  jakalk  Call ID 78405 Rename Corporate Forms to Form of Business.
--  131015  Isuklk  CAHOOK-2725 Refactoring in CorporateForm.entity
--  061115  Clstlk  Bug 122600, Added Validate_Corporate_Form().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
country_code_   IN VARCHAR2,
corporate_form_ IN VARCHAR2 )
IS
BEGIN  
   Error_SYS.Record_General(lu_name_, 'CORPFORMNOTEXIST: The Form of Business :P1 is not defined for :P2.', corporate_form_, Iso_Country_API.Decode(country_code_));   
   super(country_code_, corporate_form_);
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_        IN corporate_form_tab%ROWTYPE)
IS
   dummy_      NUMBER;
   CURSOR Exist IS
      SELECT 1
      FROM   corporate_form_tab
      WHERE  country_code = newrec_.country_code
      AND    corporate_form = newrec_.corporate_form;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO corporate_form_tab(
            country_code,
            corporate_form,
            corporate_form_desc,
            rowversion)
         VALUES(
            newrec_.country_code,
            newrec_.corporate_form,
            newrec_.corporate_form_desc,
            newrec_.rowversion);
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP', lu_name_, newrec_.corporate_form, newrec_.corporate_form_desc);
   ELSE
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP', lu_name_, newrec_.corporate_form, newrec_.corporate_form_desc);
      UPDATE corporate_form_tab
      SET    corporate_form_desc = newrec_.corporate_form_desc
      WHERE  corporate_form = newrec_.corporate_form;
   END IF;
   CLOSE Exist;
END Insert_Lu_Data_Rec__;
             
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Get_Corporate_Form_ (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ corporate_form_tab.corporate_form%TYPE;
   CURSOR get_c_form IS
      SELECT corporate_form
      FROM corporate_form_tab
      WHERE country_code = country_code_;
BEGIN
   OPEN get_c_form;
   FETCH get_c_form INTO temp_;
   CLOSE get_c_form;
   RETURN temp_;
END Get_Corporate_Form_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


