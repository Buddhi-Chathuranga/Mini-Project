-----------------------------------------------------------------------------
--
--  Logical unit: EnterpCompConnectV190
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  061025  ChBalk  Created.
--  130417  JuKoDE  EDEL-2130, Added C51..C70 attributes to Record_Assign___(), Record_Assign_Exp___(
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
TYPE Crecomp_Lu_Public_Rec IS RECORD (
   company              VARCHAR2(20),
   old_company          VARCHAR2(20),
   template_id          VARCHAR2(30),
   version              VARCHAR2(30),
   valid_from           DATE,
   action               VARCHAR2(20),
   user_data            VARCHAR2(5),
   user_template_id     VARCHAR2(30),
   update_acc_rel_data  VARCHAR2(5),
   update_non_acc_data  VARCHAR2(5),
   make_company         VARCHAR2(20),
   languages            VARCHAR2(200),
   translation          VARCHAR2(30),
   acc_year             NUMBER DEFAULT NULL,
   cal_start_year       NUMBER DEFAULT NULL,
   cal_start_month      NUMBER DEFAULT NULL,
   number_of_years      NUMBER DEFAULT NULL,
   user_defined         VARCHAR2(5) DEFAULT 'FALSE',
   main_process         VARCHAR2(30) DEFAULT NULL,
   master_company       VARCHAR2(5) DEFAULT 'FALSE');

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

TYPE Value_Array_Type IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER ;

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

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

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
      IF (old_translation_ IS NOT NULL) THEN
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


@UncheckedAccess
FUNCTION Get_Crecomp_Lu_Rec (
   component_     IN VARCHAR2,
   attr_          IN VARCHAR2) RETURN Crecomp_Lu_Public_Rec
IS
   ptr_            NUMBER;
   name_           VARCHAR2(30);
   value_          VARCHAR2(2000);
   rec_            Enterp_Comp_Connect_V190_API.Crecomp_Lu_Public_Rec;
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
      END IF;
   END LOOP;
   RETURN rec_;
END Get_Crecomp_Lu_Rec;


PROCEDURE Tem_Insert_Data (
   tem_public_rec_ IN Tem_Public_Rec )
IS
   public_rec_ Create_Company_Tem_API.Public_Rec_Templ;
BEGIN
   Record_Assign___(public_rec_, tem_public_rec_);
   Create_Company_Tem_API.Insert_Data( public_rec_);
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
   Create_Company_Tem_API.Insert_Detail_Data(public_rec_);
END Tem_Insert_Detail_Data;


PROCEDURE Tem_Insert_Detail_Data_Exp (
   tem_public_rec_ IN Tem_Public_Rec )
IS
   public_rec_ Create_Company_Tem_API.Public_Rec_Templ;
BEGIN
   Record_Assign_Exp___(public_rec_, tem_public_rec_);
   Create_Company_Tem_API.Insert_Detail_Data(public_rec_);
END Tem_Insert_Detail_Data_Exp;



