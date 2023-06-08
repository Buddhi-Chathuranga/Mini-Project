-----------------------------------------------------------------------------
--
--  Logical unit: EnterpCompConnectV170
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021112  ovjose  Created.
--  021115  stdafi  Glob06. Added Insert_Key_Master__,Insert_Prog and Insert_Translation.
--  021120  ovjose  Glob06. Added Get_Company_Translation, Insert_Company_Prog_Trans, Insert_Company_Translation
--                  Remove_Template_Attribute_Key and Remove_Company_Attribute_Key.
--  021121  ovjose  Glob06. Added Get_Translation_Lu_Value.
--  021202  stdafi  Glob06. Added Export_Company_Templ_Module
--  021203  ovjose  Glob06. Added some procedures.
--  021209  stdafi  Glob06. Added Init_Templ_Trans and Refresh_Templ_Trans.
--  030131  ovjose  Glob08. In Get_Crecomp_Lu_Rec added languages when unpack attr_ Crecomp_Lu_Public_Rec.
--  030324  ovjose  Added n9-n20 in Tem_Public_Rec
--  040722  anpelk  FIPR338 Added method to support unicode
--  061128  Vohelk  B140031 modified Get_Translation_Lu_Value function.
--  100204  cldase  EAFH-1508, Added variables to Crecomp_Lu_Public_Rec to handle a user defined calendar
--  150112  Umdolk  PRFI-4390, modified Record_Assign___ and Record_Assign_Exp___ methods.
--  180906  Nudilk  Bug 144055, Corrected Insert_Company_Translation, reintroduced the code removed from Jira id STRFI-5871.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Crecomp_Lu_Public_Rec IS RECORD (
   company                   VARCHAR2(20),
   old_company               VARCHAR2(20),
   template_id               VARCHAR2(30),
   version                   VARCHAR2(30),
   valid_from                DATE,
   action                    VARCHAR2(20),
   user_data                 VARCHAR2(5),
   user_template_id          VARCHAR2(30),
   update_acc_rel_data       VARCHAR2(5),
   update_non_acc_data       VARCHAR2(5),
   make_company              VARCHAR2(20),
   languages                 VARCHAR2(200),
   translation               VARCHAR2(30),
   acc_year                  NUMBER DEFAULT NULL,
   cal_start_year            NUMBER DEFAULT NULL,
   cal_start_month           NUMBER DEFAULT NULL,
   number_of_years           NUMBER DEFAULT NULL,
   user_defined              VARCHAR2(5) DEFAULT 'FALSE',
   main_process              VARCHAR2(30) DEFAULT NULL,
   master_company            VARCHAR2(5) DEFAULT 'FALSE',
   curr_bal_code_part        VARCHAR2(20),
   curr_bal_code_part_desc   VARCHAR2(200),
   logical_acc_types         VARCHAR2(20));

TYPE Tem_Public_Rec IS RECORD (
   template_id      VARCHAR2(30),
   description      VARCHAR2(100),
   template_type    VARCHAR2(20),
   method_type      VARCHAR2(20),
   valid            VARCHAR2(5),
   component        VARCHAR2(30),
   version          VARCHAR2(30),
   lu               VARCHAR2(30),
   item_id          NUMBER,
   c1               VARCHAR2(2000),
   c2               VARCHAR2(200),
   c3               VARCHAR2(200),
   c4               VARCHAR2(200),
   c5               VARCHAR2(2000),
   c6               VARCHAR2(200),
   c7               VARCHAR2(200),
   c8               VARCHAR2(200),
   c9               VARCHAR2(200),
   c10              VARCHAR2(200),
   c11              VARCHAR2(200),
   c12              VARCHAR2(200),
   c13              VARCHAR2(200),
   c14              VARCHAR2(200),
   c15              VARCHAR2(200),
   c16              VARCHAR2(200),
   c17              VARCHAR2(200),
   c18              VARCHAR2(200),
   c19              VARCHAR2(200),
   c20              VARCHAR2(200),
   c21              VARCHAR2(200),
   c22              VARCHAR2(200),
   c23              VARCHAR2(200),
   c24              VARCHAR2(200),
   c25              VARCHAR2(200),
   c26              VARCHAR2(200),
   c27              VARCHAR2(200),
   c28              VARCHAR2(200),
   c29              VARCHAR2(200),
   c30              VARCHAR2(200),
   c31              VARCHAR2(200),
   c32              VARCHAR2(200),
   c33              VARCHAR2(200),
   c34              VARCHAR2(200),
   c35              VARCHAR2(200),
   c36              VARCHAR2(200),
   c37              VARCHAR2(200),
   c38              VARCHAR2(200),
   c39              VARCHAR2(200),
   c40              VARCHAR2(200),
   c41              VARCHAR2(200),
   c42              VARCHAR2(200),
   c43              VARCHAR2(200),
   c44              VARCHAR2(200),
   c45              VARCHAR2(200),
   c46              VARCHAR2(200),
   c47              VARCHAR2(200),
   c48              VARCHAR2(200),
   c49              VARCHAR2(200),
   c50              VARCHAR2(200),
   c51              VARCHAR2(200),
   c52              VARCHAR2(200),
   c53              VARCHAR2(200),
   c54              VARCHAR2(200),
   c55              VARCHAR2(200),
   c56              VARCHAR2(200),
   c57              VARCHAR2(200),
   c58              VARCHAR2(200),
   c59              VARCHAR2(200),
   c60              VARCHAR2(200),
   c61              VARCHAR2(200),
   c62              VARCHAR2(200),
   c63              VARCHAR2(200),
   c64              VARCHAR2(200),
   c65              VARCHAR2(200),
   c66              VARCHAR2(200),
   c67              VARCHAR2(200),
   c68              VARCHAR2(200),
   c69              VARCHAR2(200),
   c70              VARCHAR2(200),
   ext_c1           VARCHAR2(200),
   ext_c2           VARCHAR2(200),
   ext_c3           VARCHAR2(200),
   ext_c4           VARCHAR2(200),
   ext_c5           VARCHAR2(200),
   ext_c6           VARCHAR2(200),
   ext_c7           VARCHAR2(200),
   ext_c8           VARCHAR2(200),
   ext_c9           VARCHAR2(200),
   ext_c10          VARCHAR2(200),
   ext_c11          VARCHAR2(200),
   ext_c12          VARCHAR2(200),
   ext_c13          VARCHAR2(200),
   ext_c14          VARCHAR2(200),
   ext_c15          VARCHAR2(200),
   ext_c16          VARCHAR2(200),
   ext_c17          VARCHAR2(200),
   ext_c18          VARCHAR2(200),
   ext_c19          VARCHAR2(200),
   ext_c20          VARCHAR2(200),
   ext_c21          VARCHAR2(200),
   ext_c22          VARCHAR2(200),
   ext_c23          VARCHAR2(200),
   ext_c24          VARCHAR2(200),
   ext_c25          VARCHAR2(200),
   ext_c26          VARCHAR2(200),
   ext_c27          VARCHAR2(200),
   ext_c28          VARCHAR2(200),
   ext_c29          VARCHAR2(200),
   ext_c30          VARCHAR2(200),
   n1               NUMBER,
   n2               NUMBER,
   n3               NUMBER,
   n4               NUMBER,
   n5               NUMBER,
   n6               NUMBER,
   n7               NUMBER,
   n8               NUMBER,
   n9               NUMBER,
   n10              NUMBER,
   n11              NUMBER,
   n12              NUMBER,
   n13              NUMBER,
   n14              NUMBER,
   n15              NUMBER,
   n16              NUMBER,
   n17              NUMBER,
   n18              NUMBER,
   n19              NUMBER,
   n20              NUMBER,
   ext_n1           NUMBER,
   ext_n2           NUMBER,
   ext_n3           NUMBER,
   ext_n4           NUMBER,
   ext_n5           NUMBER,
   ext_n6           NUMBER,
   ext_n7           NUMBER,
   ext_n8           NUMBER,
   ext_n9           NUMBER,
   ext_n10          NUMBER,
   ext_n11          NUMBER,
   ext_n12          NUMBER,
   ext_n13          NUMBER,
   ext_n14          NUMBER,
   ext_n15          NUMBER,
   ext_n16          NUMBER,
   ext_n17          NUMBER,
   ext_n18          NUMBER,
   ext_n19          NUMBER,
   ext_n20          NUMBER,
   d1               DATE,
   d2               DATE,
   d3               DATE,
   d4               DATE,
   d5               DATE,
   ext_d1           DATE,
   ext_d2           DATE,
   ext_d3           DATE,
   ext_d4           DATE,
   ext_d5           DATE,
   rowversion       DATE );

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Value_Array_Type IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

TYPE Suffix_Array_Type IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Record_Assign___ (
   outrec_ OUT Create_Company_Tem_API.Public_Rec_Templ,
   inrec_  IN  Tem_Public_Rec )
IS
BEGIN
   outrec_.template_id          := inrec_.template_id;
   outrec_.component            := inrec_.component;
   outrec_.description          := inrec_.description;
   outrec_.template_type        := inrec_.template_type;
   outrec_.method_type          := inrec_.method_type;
   outrec_.valid                := inrec_.valid;
   outrec_.version              := inrec_.version;
   outrec_.lu                   := inrec_.lu;
   outrec_.item_id              := inrec_.item_id;
   outrec_.c1                   := inrec_.c1;
   outrec_.c2                   := inrec_.c2;
   outrec_.c3                   := inrec_.c3;
   outrec_.c4                   := inrec_.c4;
   outrec_.c5                   := inrec_.c5;
   outrec_.c6                   := inrec_.c6;
   outrec_.c7                   := inrec_.c7;
   outrec_.c8                   := inrec_.c8;
   outrec_.c9                   := inrec_.c9;
   outrec_.c10                  := inrec_.c10;
   outrec_.c11                  := inrec_.c11;
   outrec_.c12                  := inrec_.c12;
   outrec_.c13                  := inrec_.c13;
   outrec_.c14                  := inrec_.c14;
   outrec_.c15                  := inrec_.c15;
   outrec_.c16                  := inrec_.c16;
   outrec_.c17                  := inrec_.c17;
   outrec_.c18                  := inrec_.c18;
   outrec_.c19                  := inrec_.c19;
   outrec_.c20                  := inrec_.c20;
   outrec_.c21                  := inrec_.c21;
   outrec_.c22                  := inrec_.c22;
   outrec_.c23                  := inrec_.c23;
   outrec_.c24                  := inrec_.c24;
   outrec_.c25                  := inrec_.c25;
   outrec_.c26                  := inrec_.c26;
   outrec_.c27                  := inrec_.c27;
   outrec_.c28                  := inrec_.c28;
   outrec_.c29                  := inrec_.c29;
   outrec_.c30                  := inrec_.c30;
   outrec_.c31                  := inrec_.c31;
   outrec_.c32                  := inrec_.c32;
   outrec_.c33                  := inrec_.c33;
   outrec_.c34                  := inrec_.c34;
   outrec_.c35                  := inrec_.c35;
   outrec_.c36                  := inrec_.c36;
   outrec_.c37                  := inrec_.c37;
   outrec_.c38                  := inrec_.c38;
   outrec_.c39                  := inrec_.c39;
   outrec_.c40                  := inrec_.c40;
   outrec_.c41                  := inrec_.c41;
   outrec_.c42                  := inrec_.c42;
   outrec_.c43                  := inrec_.c43;
   outrec_.c44                  := inrec_.c44;
   outrec_.c45                  := inrec_.c45;
   outrec_.c46                  := inrec_.c46;
   outrec_.c47                  := inrec_.c47;
   outrec_.c48                  := inrec_.c48;
   outrec_.c49                  := inrec_.c49;
   outrec_.c50                  := inrec_.c50;
   outrec_.c51                  := inrec_.c51;
   outrec_.c52                  := inrec_.c52;
   outrec_.c53                  := inrec_.c53;
   outrec_.c54                  := inrec_.c54;
   outrec_.c55                  := inrec_.c55;
   outrec_.c56                  := inrec_.c56;
   outrec_.c57                  := inrec_.c57;
   outrec_.c58                  := inrec_.c58;
   outrec_.c59                  := inrec_.c59;
   outrec_.c60                  := inrec_.c60;
   outrec_.c61                  := inrec_.c61;
   outrec_.c62                  := inrec_.c62;
   outrec_.c63                  := inrec_.c63;
   outrec_.c64                  := inrec_.c64;
   outrec_.c65                  := inrec_.c65;
   outrec_.c66                  := inrec_.c66;
   outrec_.c67                  := inrec_.c67;
   outrec_.c68                  := inrec_.c68;
   outrec_.c69                  := inrec_.c69;
   outrec_.c70                  := inrec_.c70;
   outrec_.ext_c1               := inrec_.ext_c1;
   outrec_.ext_c2               := inrec_.ext_c2;
   outrec_.ext_c3               := inrec_.ext_c3;
   outrec_.ext_c4               := inrec_.ext_c4;
   outrec_.ext_c5               := inrec_.ext_c5;
   outrec_.ext_c6               := inrec_.ext_c6;
   outrec_.ext_c7               := inrec_.ext_c7;
   outrec_.ext_c8               := inrec_.ext_c8;
   outrec_.ext_c9               := inrec_.ext_c9;
   outrec_.ext_c10              := inrec_.ext_c10;
   outrec_.ext_c11              := inrec_.ext_c11;
   outrec_.ext_c12              := inrec_.ext_c12;
   outrec_.ext_c13              := inrec_.ext_c13;
   outrec_.ext_c14              := inrec_.ext_c14;
   outrec_.ext_c15              := inrec_.ext_c15;
   outrec_.ext_c16              := inrec_.ext_c16;
   outrec_.ext_c17              := inrec_.ext_c17;
   outrec_.ext_c18              := inrec_.ext_c18;
   outrec_.ext_c19              := inrec_.ext_c19;
   outrec_.ext_c20              := inrec_.ext_c20;
   outrec_.ext_c21              := inrec_.ext_c21;
   outrec_.ext_c22              := inrec_.ext_c22;
   outrec_.ext_c23              := inrec_.ext_c23;
   outrec_.ext_c24              := inrec_.ext_c24;
   outrec_.ext_c25              := inrec_.ext_c25;
   outrec_.ext_c26              := inrec_.ext_c26;
   outrec_.ext_c27              := inrec_.ext_c27;
   outrec_.ext_c28              := inrec_.ext_c28;
   outrec_.ext_c29              := inrec_.ext_c29;
   outrec_.ext_c30              := inrec_.ext_c30;
   outrec_.n1                   := inrec_.n1;
   outrec_.n2                   := inrec_.n2;
   outrec_.n3                   := inrec_.n3;
   outrec_.n4                   := inrec_.n4;
   outrec_.n5                   := inrec_.n5;
   outrec_.n6                   := inrec_.n6;
   outrec_.n7                   := inrec_.n7;
   outrec_.n8                   := inrec_.n8;
   outrec_.n9                   := inrec_.n9;
   outrec_.n10                  := inrec_.n10;
   outrec_.n11                  := inrec_.n11;
   outrec_.n12                  := inrec_.n12;
   outrec_.n13                  := inrec_.n13;
   outrec_.n14                  := inrec_.n14;
   outrec_.n15                  := inrec_.n15;
   outrec_.n16                  := inrec_.n16;
   outrec_.n17                  := inrec_.n17;
   outrec_.n18                  := inrec_.n18;
   outrec_.n19                  := inrec_.n19;
   outrec_.n20                  := inrec_.n20;
   outrec_.ext_n1               := inrec_.ext_n1;
   outrec_.ext_n2               := inrec_.ext_n2;
   outrec_.ext_n3               := inrec_.ext_n3;
   outrec_.ext_n4               := inrec_.ext_n4;
   outrec_.ext_n5               := inrec_.ext_n5;
   outrec_.ext_n6               := inrec_.ext_n6;
   outrec_.ext_n7               := inrec_.ext_n7;
   outrec_.ext_n8               := inrec_.ext_n8;
   outrec_.ext_n9               := inrec_.ext_n9;
   outrec_.ext_n10              := inrec_.ext_n10;
   outrec_.ext_n11              := inrec_.ext_n11;
   outrec_.ext_n12              := inrec_.ext_n12;
   outrec_.ext_n13              := inrec_.ext_n13;
   outrec_.ext_n14              := inrec_.ext_n14;
   outrec_.ext_n15              := inrec_.ext_n15;
   outrec_.ext_n16              := inrec_.ext_n16;
   outrec_.ext_n17              := inrec_.ext_n17;
   outrec_.ext_n18              := inrec_.ext_n18;
   outrec_.ext_n19              := inrec_.ext_n19;
   outrec_.ext_n20              := inrec_.ext_n20;
   outrec_.d1                   := inrec_.d1;
   outrec_.d2                   := inrec_.d2;
   outrec_.d3                   := inrec_.d3;
   outrec_.d4                   := inrec_.d4;
   outrec_.d5                   := inrec_.d5;
   outrec_.ext_d1               := inrec_.ext_d1;
   outrec_.ext_d2               := inrec_.ext_d2;
   outrec_.ext_d3               := inrec_.ext_d3;
   outrec_.ext_d4               := inrec_.ext_d4;
   outrec_.ext_d5               := inrec_.ext_d5;
END Record_Assign___;


FUNCTION Get_Next_From_Attr___ (
   attr_             IN     VARCHAR2,
   ptr_              IN OUT NUMBER,
   value_            IN OUT VARCHAR2,
   record_separator_ IN     VARCHAR2 ) RETURN BOOLEAN
IS
   from_  NUMBER;
   to_    NUMBER;
   index_ NUMBER;
BEGIN
   from_ := NVL(ptr_, 1);
   to_   := INSTR(attr_, record_separator_, from_);
   IF (to_ > 0) THEN
      index_ := INSTR(attr_, record_separator_, from_);
      value_ := SUBSTR(attr_, from_, index_-from_);
      ptr_   := to_+1;
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Next_From_Attr___;


PROCEDURE Record_Assign_Exp___ (
   outrec_ OUT Create_Company_Tem_API.Public_Rec_Templ,
   inrec_  IN  Tem_Public_Rec )
IS
BEGIN
   outrec_.template_id          := inrec_.template_id;
   outrec_.component            := inrec_.component;
   outrec_.description          := Database_SYS.Unistr(inrec_.description);
   outrec_.template_type        := inrec_.template_type;
   outrec_.method_type          := inrec_.method_type;
   outrec_.valid                := inrec_.valid;
   outrec_.version              := inrec_.version;
   outrec_.lu                   := inrec_.lu;
   outrec_.item_id              := inrec_.item_id;
   outrec_.c1                   := Database_SYS.Unistr(inrec_.c1);
   outrec_.c2                   := Database_SYS.Unistr(inrec_.c2);
   outrec_.c3                   := Database_SYS.Unistr(inrec_.c3);
   outrec_.c4                   := Database_SYS.Unistr(inrec_.c4);
   outrec_.c5                   := Database_SYS.Unistr(inrec_.c5);
   outrec_.c6                   := Database_SYS.Unistr(inrec_.c6);
   outrec_.c7                   := Database_SYS.Unistr(inrec_.c7);
   outrec_.c8                   := Database_SYS.Unistr(inrec_.c8);
   outrec_.c9                   := Database_SYS.Unistr(inrec_.c9);
   outrec_.c10                  := Database_SYS.Unistr(inrec_.c10);
   outrec_.c11                  := Database_SYS.Unistr(inrec_.c11);
   outrec_.c12                  := Database_SYS.Unistr(inrec_.c12);
   outrec_.c13                  := Database_SYS.Unistr(inrec_.c13);
   outrec_.c14                  := Database_SYS.Unistr(inrec_.c14);
   outrec_.c15                  := Database_SYS.Unistr(inrec_.c15);
   outrec_.c16                  := Database_SYS.Unistr(inrec_.c16);
   outrec_.c17                  := Database_SYS.Unistr(inrec_.c17);
   outrec_.c18                  := Database_SYS.Unistr(inrec_.c18);
   outrec_.c19                  := Database_SYS.Unistr(inrec_.c19);
   outrec_.c20                  := Database_SYS.Unistr(inrec_.c20);
   outrec_.c21                  := Database_SYS.Unistr(inrec_.c21);
   outrec_.c22                  := Database_SYS.Unistr(inrec_.c22);
   outrec_.c23                  := Database_SYS.Unistr(inrec_.c23);
   outrec_.c24                  := Database_SYS.Unistr(inrec_.c24);
   outrec_.c25                  := Database_SYS.Unistr(inrec_.c25);
   outrec_.c26                  := Database_SYS.Unistr(inrec_.c26);
   outrec_.c27                  := Database_SYS.Unistr(inrec_.c27);
   outrec_.c28                  := Database_SYS.Unistr(inrec_.c28);
   outrec_.c29                  := Database_SYS.Unistr(inrec_.c29);
   outrec_.c30                  := Database_SYS.Unistr(inrec_.c30);
   outrec_.c31                  := Database_SYS.Unistr(inrec_.c31);
   outrec_.c32                  := Database_SYS.Unistr(inrec_.c32);
   outrec_.c33                  := Database_SYS.Unistr(inrec_.c33);
   outrec_.c34                  := Database_SYS.Unistr(inrec_.c34);
   outrec_.c35                  := Database_SYS.Unistr(inrec_.c35);
   outrec_.c36                  := Database_SYS.Unistr(inrec_.c36);
   outrec_.c37                  := Database_SYS.Unistr(inrec_.c37);
   outrec_.c38                  := Database_SYS.Unistr(inrec_.c38);
   outrec_.c39                  := Database_SYS.Unistr(inrec_.c39);
   outrec_.c40                  := Database_SYS.Unistr(inrec_.c40);
   outrec_.c41                  := Database_SYS.Unistr(inrec_.c41);
   outrec_.c42                  := Database_SYS.Unistr(inrec_.c42);
   outrec_.c43                  := Database_SYS.Unistr(inrec_.c43);
   outrec_.c44                  := Database_SYS.Unistr(inrec_.c44);
   outrec_.c45                  := Database_SYS.Unistr(inrec_.c45);
   outrec_.c46                  := Database_SYS.Unistr(inrec_.c46);
   outrec_.c47                  := Database_SYS.Unistr(inrec_.c47);
   outrec_.c48                  := Database_SYS.Unistr(inrec_.c48);
   outrec_.c49                  := Database_SYS.Unistr(inrec_.c49);
   outrec_.c50                  := Database_SYS.Unistr(inrec_.c50);
   outrec_.c51                  := Database_SYS.Unistr(inrec_.c51);
   outrec_.c52                  := Database_SYS.Unistr(inrec_.c52);
   outrec_.c53                  := Database_SYS.Unistr(inrec_.c53);
   outrec_.c54                  := Database_SYS.Unistr(inrec_.c54);
   outrec_.c55                  := Database_SYS.Unistr(inrec_.c55);
   outrec_.c56                  := Database_SYS.Unistr(inrec_.c56);
   outrec_.c57                  := Database_SYS.Unistr(inrec_.c57);
   outrec_.c58                  := Database_SYS.Unistr(inrec_.c58);
   outrec_.c59                  := Database_SYS.Unistr(inrec_.c59);
   outrec_.c60                  := Database_SYS.Unistr(inrec_.c60);
   outrec_.c61                  := Database_SYS.Unistr(inrec_.c61);
   outrec_.c62                  := Database_SYS.Unistr(inrec_.c62);
   outrec_.c63                  := Database_SYS.Unistr(inrec_.c63);
   outrec_.c64                  := Database_SYS.Unistr(inrec_.c64);
   outrec_.c65                  := Database_SYS.Unistr(inrec_.c65);
   outrec_.c66                  := Database_SYS.Unistr(inrec_.c66);
   outrec_.c67                  := Database_SYS.Unistr(inrec_.c67);
   outrec_.c68                  := Database_SYS.Unistr(inrec_.c68);
   outrec_.c69                  := Database_SYS.Unistr(inrec_.c69);
   outrec_.c70                  := Database_SYS.Unistr(inrec_.c70);
   outrec_.ext_c1               := Database_SYS.Unistr(inrec_.ext_c1);
   outrec_.ext_c2               := Database_SYS.Unistr(inrec_.ext_c2);
   outrec_.ext_c3               := Database_SYS.Unistr(inrec_.ext_c3);
   outrec_.ext_c4               := Database_SYS.Unistr(inrec_.ext_c4);
   outrec_.ext_c5               := Database_SYS.Unistr(inrec_.ext_c5);
   outrec_.ext_c6               := Database_SYS.Unistr(inrec_.ext_c6);
   outrec_.ext_c7               := Database_SYS.Unistr(inrec_.ext_c7);
   outrec_.ext_c8               := Database_SYS.Unistr(inrec_.ext_c8);
   outrec_.ext_c9               := Database_SYS.Unistr(inrec_.ext_c9);
   outrec_.ext_c10              := Database_SYS.Unistr(inrec_.ext_c10);
   outrec_.ext_c11              := Database_SYS.Unistr(inrec_.ext_c11);
   outrec_.ext_c12              := Database_SYS.Unistr(inrec_.ext_c12);
   outrec_.ext_c13              := Database_SYS.Unistr(inrec_.ext_c13);
   outrec_.ext_c14              := Database_SYS.Unistr(inrec_.ext_c14);
   outrec_.ext_c15              := Database_SYS.Unistr(inrec_.ext_c15);
   outrec_.ext_c16              := Database_SYS.Unistr(inrec_.ext_c16);
   outrec_.ext_c17              := Database_SYS.Unistr(inrec_.ext_c17);
   outrec_.ext_c18              := Database_SYS.Unistr(inrec_.ext_c18);
   outrec_.ext_c19              := Database_SYS.Unistr(inrec_.ext_c19);
   outrec_.ext_c20              := Database_SYS.Unistr(inrec_.ext_c20);
   outrec_.ext_c21              := Database_SYS.Unistr(inrec_.ext_c21);
   outrec_.ext_c22              := Database_SYS.Unistr(inrec_.ext_c22);
   outrec_.ext_c23              := Database_SYS.Unistr(inrec_.ext_c23);
   outrec_.ext_c24              := Database_SYS.Unistr(inrec_.ext_c24);
   outrec_.ext_c25              := Database_SYS.Unistr(inrec_.ext_c25);
   outrec_.ext_c26              := Database_SYS.Unistr(inrec_.ext_c26);
   outrec_.ext_c27              := Database_SYS.Unistr(inrec_.ext_c27);
   outrec_.ext_c28              := Database_SYS.Unistr(inrec_.ext_c28);
   outrec_.ext_c29              := Database_SYS.Unistr(inrec_.ext_c29);
   outrec_.ext_c30              := Database_SYS.Unistr(inrec_.ext_c30);
   outrec_.n1                   := inrec_.n1;
   outrec_.n2                   := inrec_.n2;
   outrec_.n3                   := inrec_.n3;
   outrec_.n4                   := inrec_.n4;
   outrec_.n5                   := inrec_.n5;
   outrec_.n6                   := inrec_.n6;
   outrec_.n7                   := inrec_.n7;
   outrec_.n8                   := inrec_.n8;
   outrec_.n9                   := inrec_.n9;
   outrec_.n10                  := inrec_.n10;
   outrec_.n11                  := inrec_.n11;
   outrec_.n12                  := inrec_.n12;
   outrec_.n13                  := inrec_.n13;
   outrec_.n14                  := inrec_.n14;
   outrec_.n15                  := inrec_.n15;
   outrec_.n16                  := inrec_.n16;
   outrec_.n17                  := inrec_.n17;
   outrec_.n18                  := inrec_.n18;
   outrec_.n19                  := inrec_.n19;
   outrec_.n20                  := inrec_.n20;
   outrec_.ext_n1               := inrec_.ext_n1;
   outrec_.ext_n2               := inrec_.ext_n2;
   outrec_.ext_n3               := inrec_.ext_n3;
   outrec_.ext_n4               := inrec_.ext_n4;
   outrec_.ext_n5               := inrec_.ext_n5;
   outrec_.ext_n6               := inrec_.ext_n6;
   outrec_.ext_n7               := inrec_.ext_n7;
   outrec_.ext_n8               := inrec_.ext_n8;
   outrec_.ext_n9               := inrec_.ext_n9;
   outrec_.ext_n10              := inrec_.ext_n10;
   outrec_.ext_n11              := inrec_.ext_n11;
   outrec_.ext_n12              := inrec_.ext_n12;
   outrec_.ext_n13              := inrec_.ext_n13;
   outrec_.ext_n14              := inrec_.ext_n14;
   outrec_.ext_n15              := inrec_.ext_n15;
   outrec_.ext_n16              := inrec_.ext_n16;
   outrec_.ext_n17              := inrec_.ext_n17;
   outrec_.ext_n18              := inrec_.ext_n18;
   outrec_.ext_n19              := inrec_.ext_n19;
   outrec_.ext_n20              := inrec_.ext_n20;
   outrec_.d1                   := inrec_.d1;
   outrec_.d2                   := inrec_.d2;
   outrec_.d3                   := inrec_.d3;
   outrec_.d4                   := inrec_.d4;
   outrec_.d5                   := inrec_.d5;
   outrec_.ext_d1               := inrec_.ext_d1;
   outrec_.ext_d2               := inrec_.ext_d2;
   outrec_.ext_d3               := inrec_.ext_d3;
   outrec_.ext_d4               := inrec_.ext_d4;
   outrec_.ext_d5               := inrec_.ext_d5;
END Record_Assign_Exp___;
                           
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Key_Master__ (
   key_name_  IN VARCHAR2,
   key_value_ IN VARCHAR2 )
IS
BEGIN
   Key_Master_API.Insert_Key_Master__(key_name_, key_value_);
END Insert_Key_Master__;
                           
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Reg_Add_Component_Detail (
   component_              IN VARCHAR2,
   lu_                     IN VARCHAR2,
   package_                IN VARCHAR2,
   export_view_            IN VARCHAR2,
   exec_order_             IN NUMBER,
   active_                 IN VARCHAR2,
   account_lu_             IN VARCHAR2,
   mapping_id_             IN VARCHAR2,
   attribute_key_col_      IN VARCHAR2 DEFAULT NULL,
   attribute_key_suffix_   IN VARCHAR2 DEFAULT NULL,
   attribute_key_value_    IN VARCHAR2 DEFAULT NULL )  
IS
   tmp_exec_order_      Crecomp_Component_Lu.exec_order%TYPE := exec_order_;   
   tmp_export_view_     Crecomp_Component_Lu.export_view%TYPE := export_view_;
   tmp_active_          Crecomp_Component_Lu.active%TYPE := active_;
   tmp_account_lu_      Crecomp_Component_Lu.account_lu%TYPE := account_lu_;
   CURSOR get_detail_data IS
      SELECT exec_order, export_view, active, account_lu
      FROM   crecomp_component_lu
      WHERE  module = component_
      AND    lu = lu_;   
BEGIN
   -- Check if exec_order_ IS NULL then refresh company template meta data if a post already exist. This to support
   -- when only changes has been done in the Entity-file of the LU.
   -- reuse the values of execution_order, active, account_lu, export_view(means create and export).
   IF (exec_order_ IS NULL) THEN
      OPEN get_detail_data;
      FETCH get_detail_data INTO tmp_exec_order_, tmp_export_view_, tmp_active_, tmp_account_lu_;
      CLOSE get_detail_data;      
      IF (tmp_exec_order_ IS NULL) THEN
         RETURN;
      END IF;          
   END IF;
   Crecomp_Component_API.Add_Component_Detail(component_, lu_, package_, tmp_export_view_, tmp_exec_order_, tmp_active_, tmp_account_lu_, mapping_id_, attribute_key_col_, attribute_key_suffix_, attribute_key_value_);
END Reg_Add_Component_Detail;


FUNCTION Is_Account_Lu (
   component_   IN VARCHAR2,
   lu_          IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Crecomp_Component_API.Is_Account_Lu(component_, lu_);
END Is_Account_Lu;


FUNCTION Use_Keys (
   component_     IN VARCHAR2,
   lu_            IN VARCHAR2,
   rec_           IN Crecomp_Lu_Public_Rec) RETURN BOOLEAN
IS
   update_by_key_ BOOLEAN;
   is_account_lu_ BOOLEAN;
BEGIN
   IF (rec_.update_acc_rel_data IS NULL OR rec_.update_non_acc_data IS NULL) THEN
      update_by_key_ := FALSE;
   ELSE
      IF (rec_.update_acc_rel_data = 'FALSE' AND rec_.update_non_acc_data = 'FALSE') THEN
         update_by_key_ := FALSE;
      ELSE
         is_account_lu_ := Crecomp_Component_API.Is_Account_Lu(component_, lu_);
         IF (rec_.update_acc_rel_data = 'FALSE' AND rec_.update_non_acc_data = 'TRUE' AND is_account_lu_) THEN
            update_by_key_ := FALSE;
         ELSIF (rec_.update_acc_rel_data = 'TRUE' AND rec_.update_non_acc_data = 'FALSE' AND NOT is_account_lu_) THEN
            update_by_key_ := FALSE;
         ELSE
            update_by_key_ := TRUE;
         END IF;
      END IF;
   END IF;
   RETURN update_by_key_;
END Use_Keys;


@UncheckedAccess
FUNCTION Get_Crecomp_Lu_Rec (
   component_     IN VARCHAR2,
   attr_          IN VARCHAR2) RETURN Crecomp_Lu_Public_Rec
IS
   ptr_            NUMBER;
   name_           VARCHAR2(30);
   value_          VARCHAR2(2000);
   rec_            Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec;
BEGIN
   rec_.version := Crecomp_Component_API.Get_Version(component_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'NEW_COMPANY') THEN
         rec_.company := value_;
      ELSIF (name_ = 'VALID_FROM') THEN
         rec_.valid_from := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TEMPLATE_ID') THEN
         rec_.template_id := value_;
      ELSIF (name_ = 'DUPL_COMPANY') THEN
         rec_.old_company := value_;
      ELSIF (name_ = 'ACTION') THEN
         rec_.action := value_;
      ELSIF (name_ = 'USER_DATA') THEN
         rec_.user_data := value_;
      ELSIF (name_ = 'USER_TEMPLATE_ID') THEN
         rec_.user_template_id := value_;
      ELSIF (name_ = 'MAKE_COMPANY') THEN
         rec_.make_company := value_;
      ELSIF (name_ = 'UPDATE_ACC_REL_DATA') THEN
         rec_.update_acc_rel_data := value_;
      ELSIF (name_ = 'UPDATE_NON_ACC_DATA') THEN
         rec_.update_non_acc_data := value_;
      ELSIF (name_ = 'LANGUAGES') THEN
         rec_.languages := value_;
      ELSIF (name_ = 'TRANSLATION') THEN
         rec_.translation := value_;
      ELSIF (name_ = 'START_YEAR') THEN
         rec_.cal_start_year := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'START_MONTH') THEN
         rec_.cal_start_month := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'ACC_YEAR') THEN
         rec_.acc_year := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'NUMBER_OF_YEARS') THEN
         rec_.number_of_years := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'USER_DEFINED') THEN
         rec_.user_defined := value_;
      ELSIF (name_ = 'MAIN_PROCESS') THEN
         rec_.main_process := value_;
      ELSIF (name_ = 'MASTER_COMPANY_DB') THEN
         rec_.master_company := value_;
      ELSIF (name_ = 'CURR_BAL_CODE_PART') THEN
         rec_.curr_bal_code_part := value_;
      ELSIF (name_ = 'CURR_BAL_CODE_PART_DESC') THEN
         rec_.curr_bal_code_part_desc := value_;
      ELSIF (name_ = 'LOGICAL_ACC_TYPES') THEN
         rec_.logical_acc_types := value_;
      END IF;
   END LOOP;
   RETURN rec_;
END Get_Crecomp_Lu_Rec;


PROCEDURE Template_Exist (
   template_id_ IN VARCHAR2 )
IS
BEGIN
   Create_Company_Tem_API.Exist(template_id_);
END Template_Exist;


PROCEDURE Refresh_Templ_Trans (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
BEGIN
   Templ_Key_Lu_API.Refresh_Templ_Trans__(key_value_, module_, language_code_);
END Refresh_Templ_Trans;


PROCEDURE Calc_New_Date (
   new_date_   OUT DATE,
   ref_date_   IN  DATE,
   first_date_ IN  DATE,
   cur_date_   IN  DATE )
IS
BEGIN
   Create_Company_API.Calc_New_Date(new_date_, ref_date_, first_date_, cur_date_);
END Calc_New_Date;


PROCEDURE Reg_Add_Component (
   component_        IN VARCHAR2,
   version_          IN VARCHAR2,
   parent_component_ IN VARCHAR2,
   active_           IN VARCHAR2 )
IS
BEGIN
   Crecomp_Component_API.Add_Component(component_, version_, parent_component_, active_);
END Reg_Add_Component;


PROCEDURE Reg_Add_Table (
   component_        IN VARCHAR2,
   table_name_       IN VARCHAR2,
   standard_table_   IN VARCHAR2 )
IS
BEGIN
   Crecomp_Component_API.Add_Table(component_, table_name_, NULL, standard_table_);
END Reg_Add_Table;


PROCEDURE Check_Component (
   exist_               OUT VARCHAR2,
   use_make_company_    OUT VARCHAR2,
   component_           IN  VARCHAR2 )
IS
BEGIN
   Crecomp_Component_API.Check_Component(exist_, use_make_company_, component_);
END Check_Component;


PROCEDURE Delete_Remove_Company_Info (
   component_            IN VARCHAR2,
   remove_standard_only_ IN BOOLEAN )
IS
BEGIN
   Crecomp_Component_API.Delete_Remove_Company_Info(component_, remove_standard_only_);
END Delete_Remove_Company_Info;


PROCEDURE Tem_Insert_Data (
   tem_public_rec_ IN Tem_Public_Rec )
IS
   public_rec_ Create_Company_Tem_API.Public_Rec_Templ;
BEGIN
   Record_Assign___(public_rec_, tem_public_rec_);
   Create_Company_Tem_API.Insert_Data( public_rec_);
   -- Delete all system defined translations for the template for given component.
   Templ_Key_Lu_API.Remove_Templ_Key_Lu__(public_rec_.template_id, public_rec_.component);
END Tem_Insert_Data;


PROCEDURE Tem_Insert_Data_Exp (
   tem_public_rec_ IN Tem_Public_Rec )
IS
   public_rec_ Create_Company_Tem_API.Public_Rec_Templ;
BEGIN
   Record_Assign_Exp___(public_rec_, tem_public_rec_);
   Create_Company_Tem_API.Insert_Data( public_rec_);
   Templ_Key_Lu_API.Remove_Templ_Key_Lu__(public_rec_.template_id, public_rec_.component);
END Tem_Insert_Data_Exp;


PROCEDURE Tem_Insert_Detail_Data (
   tem_public_rec_ IN Tem_Public_Rec )
IS
   public_rec_ Create_Company_Tem_API.Public_Rec_Templ;
BEGIN
   Record_Assign___(public_rec_, tem_public_rec_);
   Create_Company_Tem_API.Insert_Detail_Data( public_rec_);
END Tem_Insert_Detail_Data;


PROCEDURE Tem_Insert_Detail_Data_Exp (
   tem_public_rec_ IN Tem_Public_Rec )
IS
   public_rec_ Create_Company_Tem_API.Public_Rec_Templ;
BEGIN
   Record_Assign_Exp___(public_rec_, tem_public_rec_);
   Create_Company_Tem_API.Insert_Detail_Data( public_rec_);
END Tem_Insert_Detail_Data_Exp;


PROCEDURE Initiate_Template_Log
IS
BEGIN
   Create_Company_Tem_API.Initiate_Log;
END Initiate_Template_Log;


PROCEDURE Reset_Template_Log
IS
BEGIN
   Create_Company_Tem_API.Reset_Log;
END Reset_Template_Log;


PROCEDURE Log_Logging (
   company_    IN VARCHAR2,
   module_     IN VARCHAR2,
   lu_name_    IN VARCHAR2,
   status_     IN VARCHAR2,
   error_      IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Create_Company_Log_API.Logging(company_, module_, lu_name_, status_, error_);
END Log_Logging;


PROCEDURE Copy_Templ_To_Templ_Trans (
   source_template_id_  IN VARCHAR2,
   target_template_id_  IN VARCHAR2,
   module_              IN VARCHAR2,
   lu_                  IN VARCHAR2,
   source_attribute_    IN VARCHAR2 DEFAULT NULL,
   target_attribute_    IN VARCHAR2 DEFAULT NULL,
   language_codes_      IN VARCHAR2 DEFAULT 'ALL' )
IS
BEGIN
   Key_Lu_API.Copy_Translations__(source_template_id_,
                                  target_template_id_,
                                  module_,
                                  lu_,
                                  lu_,
                                  'TemplKeyLu',
                                  'TemplKeyLu',
                                  source_attribute_,
                                  target_attribute_,
                                  language_codes_,
                                  'COPY');
END Copy_Templ_To_Templ_Trans;


PROCEDURE Update_Diff_Template (
   template_rec_   IN  Create_Company_Tem_API.Public_Rec_Templ )
IS
BEGIN
   Create_Company_Tem_API.Update_Diff_Template(template_rec_);
END Update_Diff_Template;


@UncheckedAccess
FUNCTION Get_Version (
   component_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Crecomp_Component_API.Get_Version(component_);
END Get_Version;


PROCEDURE Init_Templ_Trans (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS

BEGIN
   Templ_Key_Lu_API.Init_Templ_Trans__(key_value_, module_, language_code_);
END Init_Templ_Trans;


PROCEDURE Insert_Prog (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   text_          IN VARCHAR2 )
IS
BEGIN
   Templ_Key_Lu_API.Insert_Prog__(key_value_, module_, lu_, attribute_key_, text_);
END Insert_Prog;


PROCEDURE Insert_Translation (
   msg_ IN VARCHAR2 )
IS
   ptr_           NUMBER;
   value_         VARCHAR2(2000);
   key_attr_      VARCHAR2(2000);
   value_array_   Value_Array_Type;
   i_             NUMBER := 1;
   module_        key_lu_translation_tab.module%TYPE;
   lu_            key_lu_translation_tab.lu%TYPE;
   key_value_     key_lu_translation_tab.key_value%TYPE;
   attribute_key_ key_lu_translation_tab.attribute_key%TYPE;
   language_code_ key_lu_translation_tab.language_code%TYPE;
   translation_   key_lu_translation_tab.installation_translation%TYPE;
BEGIN
   key_attr_ := msg_||'^';
   WHILE (Get_Next_From_Attr___(key_attr_, ptr_, value_, '^' )) LOOP
      value_array_(i_) := value_;
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 7) THEN
      key_value_     :=  value_array_(1);
      module_        :=  value_array_(2);
      lu_            :=  value_array_(3);
      attribute_key_ :=  REPLACE(value_array_(4),'~', '^');
      language_code_ :=  value_array_(5);
      translation_   :=  REPLACE(value_array_(6),'~', '^');
      Templ_Key_Lu_API.Insert_Translation__(key_value_, module_, lu_, attribute_key_, language_code_, translation_);
   END IF;
END Insert_Translation;


PROCEDURE Insert_Translation_Exp (
   msg_ IN VARCHAR2 )
IS
   ptr_           NUMBER;
   value_         VARCHAR2(2000);
   key_attr_      VARCHAR2(2000);
   value_array_   Value_Array_Type;
   i_             NUMBER := 1;
   module_        key_lu_translation_tab.module%TYPE;
   lu_            key_lu_translation_tab.lu%TYPE;
   key_value_     key_lu_translation_tab.key_value%TYPE;
   attribute_key_ key_lu_translation_tab.attribute_key%TYPE;
   language_code_ key_lu_translation_tab.language_code%TYPE;
   translation_   key_lu_translation_tab.installation_translation%TYPE;
BEGIN
   key_attr_ := msg_||'^';
   WHILE (Get_Next_From_Attr___(key_attr_, ptr_, value_, '^' )) LOOP
      value_array_(i_) := value_;
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 7) THEN
      key_value_     :=  value_array_(1);
      module_        :=  value_array_(2);
      lu_            :=  value_array_(3);
      value_array_(4):=  Database_SYS.Unistr(value_array_(4));
      attribute_key_ :=  REPLACE(value_array_(4),'~', '^');
      language_code_ :=  value_array_(5);
      value_array_(6):=  Database_SYS.Unistr(value_array_(6));
      translation_   :=  REPLACE(value_array_(6),'~', '^');
      Templ_Key_Lu_API.Insert_Translation__(key_value_, module_, lu_, attribute_key_, language_code_, translation_);
   END IF;
END Insert_Translation_Exp;


@UncheckedAccess
FUNCTION Get_Company_Translation (
   company_             IN VARCHAR2,
   module_              IN VARCHAR2,
   lu_                  IN VARCHAR2,
   attribute_           IN VARCHAR2,
   language_code_       IN VARCHAR2 DEFAULT NULL,
   only_chosen_lang_    IN VARCHAR2 DEFAULT 'YES' ) RETURN VARCHAR2
IS
BEGIN
   RETURN Company_Key_Lu_API.Get_Company_Translation__(company_, module_, lu_, attribute_, language_code_, only_chosen_lang_);
END Get_Company_Translation;


PROCEDURE Remove_Company_Attribute_Key (
   company_       IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 )
IS
BEGIN
   Company_Key_Lu_API.Remove_Attribute_key__(company_, module_, lu_, attribute_key_);
END Remove_Company_Attribute_Key;


@UncheckedAccess
FUNCTION Translate_Iid (
   lu_name_     IN VARCHAR2,
   client_list_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   text_        VARCHAR2(500);
   text_a_      VARCHAR2(20);
   text_b_      VARCHAR2(20);
   text_c_      VARCHAR2(20);
   text_d_      VARCHAR2(20);
   text_e_      VARCHAR2(20);
   text_f_      VARCHAR2(20);
   text_g_      VARCHAR2(20);
   text_h_      VARCHAR2(20);
   text_i_      VARCHAR2(20);
   text_j_      VARCHAR2(20);
   company_     VARCHAR2(20);
   userid_      VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   company_ := User_Profile_SYS.Get_Default('COMPANY', userid_);
   text_a_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'A');
   text_b_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'B');
   text_c_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'C');
   text_d_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'D');
   text_e_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'E');
   text_f_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'F');
   text_g_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'G');
   text_h_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'H');
   text_i_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'I');
   text_j_ := Get_Company_Translation(company_, 'ACCRUL', 'AccountingCodeParts', 'J');
   text_ := text_a_||'^'||text_b_||'^'||text_c_||'^'||text_d_||'^'||text_e_||'^'||text_f_||'^'||text_e_||'^'||text_f_||'^'||text_g_||'^'||text_h_||'^'||text_i_||'^'||text_j_||'^';
   RETURN(NVL(text_, client_list_));
END Translate_Iid;


PROCEDURE Reg_Remove_Component (
   module_ IN VARCHAR2 )
IS
BEGIN
   Crecomp_Component_API.Remove_Component(module_);
END Reg_Remove_Component;


PROCEDURE Reg_Remove_Component_Detail (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2 )
IS
BEGIN
   Crecomp_Component_API.Remove_Component_Detail(module_, lu_);
END Reg_Remove_Component_Detail;


PROCEDURE Add_Module_Detail (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2 )
IS
   rec_        module_lu_tab%ROWTYPE;
BEGIN
   rec_.module := module_;
   rec_.lu := lu_;
   Module_Lu_API.Add_Module_Detail__(rec_);
END Add_Module_Detail;


FUNCTION Check_Exist_Module_Lu (
   module_           IN VARCHAR2,
   lu_               IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Module_Lu_API.Check_Exist__(module_, lu_);
END Check_Exist_Module_Lu;


FUNCTION Get_Template_Version (
   template_id_      IN VARCHAR2,
   module_           IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Create_Company_Tem_Comp_API.Get_Version(template_id_, module_);
END Get_Template_Version;


FUNCTION Get_Translation_Lu_Value (
   template_id_   IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   translatable_  BOOLEAN := FALSE;
   key_           VARCHAR2(50);
   key_attr_      VARCHAR2(50);
   suffix_attr_   VARCHAR2(2000);
   value_attr_    VARCHAR2(2000);
   value_         VARCHAR2(2000);
   stmt_          VARCHAR2(2000);
   count_suffix_  NUMBER;
   i_             NUMBER := 1;
   j_             NUMBER := 1;
   k_             NUMBER := 0;
   real_key_      VARCHAR2(200);
   return_key_    VARCHAR2(200);
   tmp_key_       VARCHAR2(200);
   suffix_array_  Suffix_Array_Type;
   ptr_           NUMBER;
BEGIN
   translatable_ := Enterp_Comp_Connect_V170_API.Get_Translation_Reg_Info(key_attr_, suffix_attr_, value_attr_, module_, lu_);
   IF (translatable_) THEN
      key_attr_ := key_attr_ ||'^';
      WHILE Get_Next_From_Attr___(key_attr_, ptr_, value_, '^') LOOP
         key_ := value_;
         Assert_SYS.Assert_Is_View_Column('create_company_tem_detail', key_);
         IF (k_ > 0) THEN
            stmt_ := stmt_ || '||''^''||' || key_;
         ELSE
            stmt_ := stmt_ || key_;
         END IF;
         k_ := k_ + 1;
      END LOOP;
      stmt_ := 'SELECT '|| stmt_ || ' FROM create_company_tem_detail WHERE template_id = :template_id '
                                       || 'AND component = :module AND lu = :lu AND item_id = :item_id';
      @ApproveDynamicStatement(2005-11-10,ovjose)
      EXECUTE IMMEDIATE stmt_ INTO real_key_ USING template_id_, module_, lu_, item_id_;
      -- for the Get_Next_From_Attr___ to work
      suffix_attr_ := suffix_attr_||',';
      ptr_ := NULL;
      value_ := NULL;
      WHILE (Get_Next_From_Attr___(suffix_attr_, ptr_, value_, ',')) LOOP
         suffix_array_(i_) := value_;
         i_ := i_ + 1;
      END LOOP;
      count_suffix_ := suffix_array_.COUNT;
      i_ := suffix_array_.FIRST;
      j_ := suffix_array_.LAST;
      LOOP
         tmp_key_ := real_key_;
         IF ((suffix_array_(i_) != '<NULL>') AND (suffix_array_(i_) IS NOT NULL)) THEN
            tmp_key_ := tmp_key_||'^'||suffix_array_(i_);
         END IF;
         return_key_ := return_key_ || tmp_key_ ||',';
         EXIT WHEN i_ = j_;
         i_ := suffix_array_.NEXT(i_);
      END LOOP;
      return_key_ := substr(return_key_, 1, LENGTH(return_key_)-1);
      RETURN return_key_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Translation_Lu_Value;


FUNCTION Get_Translation_Reg_Info (
   key_attr_      OUT VARCHAR2,
   suffix_attr_   OUT VARCHAR2,
   value_attr_    OUT VARCHAR2,
   module_        IN  VARCHAR2,
   lu_            IN  VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Crecomp_Component_API.Get_Translation_Reg_Info__(key_attr_, suffix_attr_, value_attr_, module_, lu_);
END Get_Translation_Reg_Info;


PROCEDURE Insert_Company_Prog_Trans (
   company_       IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   text_          IN VARCHAR2 )
IS
BEGIN
   Company_Key_Lu_API.Insert_Prog__(company_, module_, lu_, attribute_key_, text_);
END Insert_Company_Prog_Trans;


PROCEDURE Insert_Company_Translation (
   key_value_        IN VARCHAR2,
   module_           IN VARCHAR2,
   lu_               IN VARCHAR2,
   attribute_key_    IN VARCHAR2,
   language_code_    IN VARCHAR2,
   translation_      IN VARCHAR2,
   old_translation_  IN VARCHAR2 DEFAULT NULL )
IS
   difference_    BOOLEAN := FALSE;
BEGIN
   -- Handle the possibility that either of the translation might be NULL.
   IF (translation_ IS NULL) THEN
      IF old_translation_ IS NOT NULL THEN
         difference_ := TRUE;
      END IF;
   ELSIF (old_translation_ IS NULL) THEN
      difference_ := TRUE;
   ELSIF (old_translation_ != translation_) THEN
      difference_ := TRUE;
   END IF;
   IF (difference_) THEN
      Company_Key_Lu_API.Insert_Company_Translation__(key_value_, module_, lu_, attribute_key_, language_code_, translation_);
   END IF;
END Insert_Company_Translation;


PROCEDURE Remove_Template_Attribute_Key (
   template_id_   IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 )
IS
BEGIN
   Templ_Key_Lu_API.Remove_Attribute_key__(template_id_, module_, lu_, attribute_key_);
END Remove_Template_Attribute_Key;


PROCEDURE Rename_Templ_Translation (
   old_template_id_     IN VARCHAR2,
   new_template_id_     IN VARCHAR2 )
IS
BEGIN
   Templ_Key_Lu_API.Rename_Templ_Translation__(old_template_id_, new_template_id_);
END Rename_Templ_Translation;


PROCEDURE Reg_Add_Table_Detail (
   component_        IN VARCHAR2,
   table_name_       IN VARCHAR2,
   column_name_      IN VARCHAR2,
   column_value_     IN VARCHAR2 )
IS
BEGIN
   Crecomp_Component_API.Add_Table_Detail(component_, table_name_, column_name_, column_value_);
END Reg_Add_Table_Detail;


PROCEDURE Copy_Comp_To_Templ_Trans (
   company_          IN VARCHAR2,
   template_id_      IN VARCHAR2,
   module_           IN VARCHAR2,
   source_lu_        IN VARCHAR2,
   target_lu_        IN VARCHAR2,
   source_attribute_ IN VARCHAR2 DEFAULT NULL,
   target_attribute_ IN VARCHAR2 DEFAULT NULL,
   language_codes_   IN VARCHAR2 DEFAULT 'ALL' )
IS
BEGIN
   Key_Lu_API.Copy_Translations__(company_,
                                  template_id_,
                                  module_,
                                  source_lu_,
                                  target_lu_,
                                  'CompanyKeyLu',
                                  'TemplKeyLu',
                                  source_attribute_,
                                  target_attribute_,
                                  language_codes_,
                                  'COPY');
END Copy_Comp_To_Templ_Trans;


PROCEDURE Copy_Templ_To_Comp_Trans (
   template_id_            IN VARCHAR2,
   company_                IN VARCHAR2,
   module_                 IN VARCHAR2,
   source_lu_              IN VARCHAR2,
   target_lu_              IN VARCHAR2,
   source_attribute_key_   IN VARCHAR2 DEFAULT NULL,
   target_attribute_key_   IN VARCHAR2 DEFAULT NULL,
   language_codes_         IN VARCHAR2 DEFAULT 'ALL',
   option_                 IN VARCHAR2 DEFAULT 'COPY' )
IS
BEGIN
   Key_Lu_API.Copy_Translations__(template_id_,
                                  company_,
                                  module_,
                                  source_lu_,
                                  target_lu_,
                                  'TemplKeyLu',
                                  'CompanyKeyLu',
                                  source_attribute_key_,
                                  target_attribute_key_,
                                  language_codes_,
                                  option_);
END Copy_Templ_To_Comp_Trans;


PROCEDURE Copy_Templ_Translations (
   old_template_id_     IN VARCHAR2,
   new_template_id_     IN VARCHAR2 )
IS
BEGIN
   Templ_Key_Lu_API.Copy_Templ_Translations__(old_template_id_, new_template_id_);
END Copy_Templ_Translations;


PROCEDURE Export_Company_Templ_Module (
   template_ids_  IN VARCHAR2,
   module_        IN VARCHAR2 )
IS
BEGIN
   Templ_Key_Lu_API.Export_Company_Templates__(template_ids_, module_);
END Export_Company_Templ_Module;


PROCEDURE Export_Company_Templates (
   template_ids_ IN VARCHAR2 )
IS
BEGIN
   Templ_Key_Lu_API.Export_Company_Templates__(template_ids_, NULL);
END Export_Company_Templates;


FUNCTION Get_Company_Templ_Module (
   module_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR StandardTemplates IS
      SELECT template_id
      FROM   create_company_tem
      WHERE  Create_Company_Tem_API.Is_System_Template(template_id) = 'TRUE'
      AND EXISTS (SELECT 1
                  FROM   key_lu_tab
                  WHERE  key_name  = 'TemplKeyLu'
                  AND    key_value = template_id
                  AND    module    = module_);
   field_separator_  VARCHAR2(1)       := Client_SYS.field_separator_;
   templates_        VARCHAR2(2000);
BEGIN
   FOR i_ IN StandardTemplates LOOP
      templates_ := templates_ || i_.template_id || field_separator_;
   END LOOP;
   RETURN templates_;
END Get_Company_Templ_Module;


FUNCTION Get_Company_Templates RETURN VARCHAR2
IS
   CURSOR StandardTemplates IS
      SELECT template_id
      FROM   create_company_tem
      WHERE  Create_Company_Tem_API.Is_System_Template(template_id) = 'TRUE'
      AND EXISTS (SELECT 1
                  FROM   key_lu_tab
                  WHERE  key_name = 'TemplKeyLu'
                  AND    key_value = template_id);
   field_separator_  VARCHAR2(1)       := Client_SYS.field_separator_;
   templates_        VARCHAR2(2000);
BEGIN
   FOR i_ IN StandardTemplates LOOP
      templates_ := templates_ || i_.template_id || field_separator_;
   END LOOP;
   RETURN templates_;
END Get_Company_Templates;


FUNCTION Check_Exist_Company_Lu_Trans (
   company_ IN VARCHAR2,
   module_  IN VARCHAR2,
   lu_      IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Company_Key_Lu_API.Check_Exist_Company_Lu_Trans('CompanyKeyLu', company_, module_, lu_);
END Check_Exist_Company_Lu_Trans;


PROCEDURE Copy_Comp_To_Comp_Trans (
   source_company_   IN VARCHAR2,
   target_company_   IN VARCHAR2,
   module_           IN VARCHAR2,
   lu_               IN VARCHAR2,
   target_lu_        IN VARCHAR2,
   source_attribute_ IN VARCHAR2 DEFAULT NULL,
   target_attribute_ IN VARCHAR2 DEFAULT NULL,
   language_codes_   IN VARCHAR2 DEFAULT 'ALL',
   option_           IN VARCHAR2 DEFAULT 'COPY' )
IS
BEGIN
   Key_Lu_API.Copy_Translations__(source_company_,
                                  target_company_,
                                  module_,
                                  lu_,
                                  target_lu_,
                                  'CompanyKeyLu',
                                  'CompanyKeyLu',
                                  source_attribute_,
                                  target_attribute_,
                                  language_codes_,
                                  option_);
END Copy_Comp_To_Comp_Trans;


PROCEDURE Export_Company_Templates_Lng (
   template_ids_  IN VARCHAR2,
   languages_     IN VARCHAR2,
   module_        IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Templ_Key_Lu_API.Export_Company_Templates_Lng__(template_ids_, languages_, module_);
END Export_Company_Templates_Lng;


PROCEDURE Reg_Special_Lu (
      lu_             IN   VARCHAR2,
      type_           IN   VARCHAR2,
      type_data_      IN   VARCHAR2 DEFAULT NULL )
IS
   idum_    PLS_INTEGER;
   CURSOR key_exist IS
      SELECT 1
      FROM   crecomp_special_lu_tab
      WHERE  lu = lu_
      AND    type = type_;
BEGIN
   OPEN key_exist;
   FETCH key_exist INTO idum_;
   IF (key_exist%FOUND) THEN
      DELETE 
         FROM  crecomp_special_lu_tab
         WHERE lu = lu_
         AND   type = type_;
   END IF;
   CLOSE key_exist;
   INSERT 
      INTO crecomp_special_lu_tab(
         lu, 
         type, 
         type_data, 
         rowversion)
      VALUES(
         lu_, 
         type_, 
         type_data_, 
         SYSDATE);
END Reg_Special_Lu;


PROCEDURE Reg_Remove_Cre_Comp_Lu (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2 )
IS   
BEGIN   
   Reg_Remove_Component_Detail(module_, lu_);
   Client_Mapping_API.Remove_Mapping_Per_Lu(module_, lu_);
END Reg_Remove_Cre_Comp_Lu;



