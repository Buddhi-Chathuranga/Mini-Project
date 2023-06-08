-----------------------------------------------------------------------------
--
--  Logical unit: BulletinBoardTopicUsers
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000401  Mangala  Created for Webkit 300Bx. This supports BulletinBoard Portlet
--                   server methods.
--  000531  ROOD     Changed all type declarations of type NUMBER(X) to NUMBER.
--                   Changed the calls to Fnd_Session_API.Get_Fnd_User and
--                   changed db-value '1' to 'WRITER'.
--  000601  ROOD     Added method New_.
--  020624  ROOD     Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD     Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR     Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE New_ (
   topic_id_                     IN NUMBER,
   identity_                     IN VARCHAR2,
   bulletin_board_user_level_db_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('TOPIC_ID', topic_id_, attr_);
   Client_SYS.Add_To_Attr('IDENTITY', identity_ , attr_);
   Client_SYS.Add_To_Attr('BULLETIN_BOARD_USER_LEVEL_DB', bulletin_board_user_level_db_ , attr_);
   New__(info_,objid_,objversion_,attr_,'DO');
END New_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Is_Writer (
   topic_id_ IN NUMBER ) RETURN VARCHAR2
IS
   fnd_user_   VARCHAR2(30);
   user_level_ VARCHAR2(20);
BEGIN
   fnd_user_   := Fnd_Session_Api.Get_Fnd_User;
   user_level_ := Get_Bulletin_Board_User_Level(topic_id_, fnd_user_);
   IF (Bulletin_Board_User_Level_API.Encode(user_level_) = 'WRITER') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Writer;



