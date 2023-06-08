-----------------------------------------------------------------------------
--
--  Logical unit: FndMobProxy
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

FUNCTION Remove_Component_Metadata_ (
   component_     IN VARCHAR2,
   show_info_     IN BOOLEAN DEFAULT FALSE,
   simulate_only_ IN BOOLEAN DEFAULT FALSE) RETURN NUMBER
IS
   count_apps_ NUMBER := 0;
   apps_       Utility_SYS.STRING_TABLE;
                                 
   PROCEDURE Show_Info(text_ IN VARCHAR2)
   IS
   BEGIN
      IF (simulate_only_) THEN
         Dbms_Output.Put_Line('(Simulation) ' || text_);     
      ELSIF (show_info_) THEN
         Dbms_Output.Put_Line(text_);     
      END IF;
   END Show_Info;
   
   $IF Component_Fndmob_SYS.INSTALLED $THEN
   PROCEDURE Clear_App(
     app_name_ IN VARCHAR2,
     show_info_ IN BOOLEAN)
   IS
   BEGIN
      -- Metadata
      Model_Design_SYS.Remove_App_Metadata(app_name_);
         
      -- Mobile App Data
      Mobile_Application_API.Remove_App(app_name_ => app_name_, show_info_ => show_info_);
               
      @ApproveTransactionStatement(2020-09-15,rakuse)
      COMMIT;      
   END Clear_App;
   $END

BEGIN   
   $IF Component_Fndmob_SYS.INSTALLED $THEN
   apps_ := Fndmob_Installation_API.List_Installed_Apps(component_);
   IF (apps_.COUNT > 0) THEN
     FOR i IN apps_.FIRST .. apps_.LAST LOOP
        count_apps_ := count_apps_ + 1;      

        Show_Info(count_apps_ || '. Removing app ' || apps_(i));
        IF (NOT simulate_only_) THEN
           Clear_App(apps_(i), show_info_);  
        END IF;
          
     END LOOP;
   END IF;
   $END
   RETURN count_apps_;
END Remove_Component_Metadata_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
