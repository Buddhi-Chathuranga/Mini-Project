-----------------------------------------------------------------------------
--
--  Logical unit: ConnectProperty
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -------------------------------------------------------
--  2019-12-23  japase  PACZDATA-1733: Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('PROPERTY_GROUP', 'Ifs', attr_);
   Jsf_Property_API.New__(info_, objid_, objversion_, attr_, action_);
END New__;


PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('PROPERTY_GROUP', 'Ifs', attr_);
   Jsf_Property_API.Modify__(info_, objid_, objversion_, attr_, action_);
END Modify__;


PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
BEGIN
   Jsf_Property_API.Remove__(info_, objid_, objversion_, action_);
END Remove__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

