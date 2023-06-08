-----------------------------------------------------------------------------
--
--  Logical unit: TranspTaskHandlUnitOvw
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Purpose: This package main job is to be an interface for the Handling Units
--           on Transport Tasks overview window so we call the regular 
--           Modify__/Remove__ methods in Transport_Task_Handl_Unit_API with a
--           flag indication that this is from the overview windows without 
--           doing any special client tricks to handle this. This will help methods 
--           in Transport_Task_Handl_Unit_API fetching transport_task_id and 
--           handling_unit_id from the correct datasource.
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200506  JaThlk  SC2020R1-7030, Removed declarations to avoid code generation errors.
--  160419  DaZase  LIM-5066, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      Transport_Task_Handl_Unit_API.Modify__(objid_ , attr_, window_source_ => 'OVERVIEW');
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      Transport_Task_Handl_Unit_API.Remove__(objid_, window_source_ => 'OVERVIEW');
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Remove__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

