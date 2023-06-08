-----------------------------------------------------------------------------
--
--  Logical unit: CreateCompanyTemDetail
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010419  ovjose  Created.
--  010816  LiSv    Added call to Create_Company_Tem_API.Set_Last_Modification_Date.
--  020125  ovjose  Added Insert_Translated_Data__
--  021112  ovjose  Glob06. Added support to insert PROG-texts to template translation storage.
--  030324  ovjose  Added fields n9-20 in table
--  030902  lalise  Minor modifications
--  031013  ovjose  Removed Insert_Translated_Data__
--  040615  sachlk  FIPR338A2: Unicode Changes.
--  040722  anpelk  Moved unicode changes to ENTERP_COMP_CONNECT_V170_API
--  041214  KaGalk  LCS Merge 29607.
--  061013  ChBalk  Added C41..C50 attributes to CREATE_COMPANY_TEM_DETAIL_TAB
--                  and respective methods.
--  100217  Umdolk  EANE-4175, Added new base view.
--  110331  ovjose  Removed the above "new base view" and instead used ordinary 
--                  base view CREATE_COMPANY_TEM_DETAIL (moved from api file)
--  130417  JuKoDE  EDEL-2130, Added C51..C70 attributes to TABLE
--  131015  Isuklk  CAHOOK-2736 Refactoring in CreateCompanyTemDetail.entity
--  151209  Nudilk  STRFI-756, Merged bug 125619.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Suffix_Array_Type IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER ;

TYPE Value_Array_Type IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER ;
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Record_Assign___ (
   outrec_ OUT create_company_tem_detail_tab%ROWTYPE,
   inrec_  IN  Create_Company_Tem_API.Public_Rec_Templ )
IS
BEGIN
   outrec_.template_id          := inrec_.template_id;
   outrec_.component            := inrec_.component;
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
   outrec_.rowversion           := SYSDATE;
END Record_Assign___;


PROCEDURE Check_If_Translatable___(
   attr_          IN VARCHAR2,
   rec_           IN create_company_tem_detail_tab%ROWTYPE,
   option_        IN VARCHAR2 DEFAULT NULL)
IS
   ptr_           NUMBER;
   value_         VARCHAR2(2000);
   key_attr_      VARCHAR2(2000);
   suffix_attr_   VARCHAR2(2000);
   value_attr_    VARCHAR2(2000);
   suffix_array_  Suffix_Array_Type;
   value_array_   Value_Array_Type;
   i_             NUMBER := 1;
   j_             NUMBER := 1;
   key_           VARCHAR2(500);
   tmp_key_       VARCHAR2(500);
   translatable_  BOOLEAN := FALSE;
   count_suffix_  NUMBER;
   count_values_  NUMBER;
   system_templ_  VARCHAR2(5) := Create_Company_Tem_API.Is_System_Template(rec_.template_id);
   language_code_ VARCHAR2(5);
   inst_method_   VARCHAR2(100);
   temp_attr_     VARCHAR2(2000) := attr_;
BEGIN
   translatable_ := Enterp_Comp_Connect_V170_API.Get_Translation_Reg_Info(key_attr_, suffix_attr_, value_attr_, rec_.component, rec_.lu);
   IF (translatable_) THEN   
      inst_method_ := NVL(Client_SYS.Cut_Item_Value('FROM_METHOD', temp_attr_), 'DUMMY');   
      -- for Get_Next_From_Attr___ to work
      key_attr_ := key_attr_||'^';
      suffix_attr_ := suffix_attr_||',';
      value_attr_ := value_attr_||',';
      WHILE (Get_Next_From_Attr___(key_attr_, ptr_, value_, '^' )) LOOP
         tmp_key_ := Get_Lu_Key_Values___(value_, rec_);
         key_ := key_ || tmp_key_ || '^';
      END LOOP;
      -- remove last '^'
      key_ := SUBSTR(key_, 1, LENGTH(key_)-1);
      ptr_ := NULL;
      value_ := NULL;
      WHILE (Get_Next_From_Attr___(suffix_attr_, ptr_, value_, ',' )) LOOP
         suffix_array_(i_) := value_;
         i_ := i_ + 1;
      END LOOP;
         i_ := 1;
      ptr_ := NULL;
      value_ := NULL;
      WHILE (Get_Next_From_Attr___(value_attr_, ptr_, value_, ',')) LOOP
         IF (temp_attr_ IS NOT NULL) THEN
            value_array_(i_) := Client_SYS.Get_Item_Value(value_, temp_attr_);
         ELSE
            value_array_(i_) := Get_Lu_Key_Values___(value_, rec_);
         END IF;
         i_ := i_ + 1;
      END LOOP;
      count_values_ := value_array_.COUNT;
      count_suffix_ := suffix_array_.COUNT;
      i_ := value_array_.FIRST;
      j_ := value_array_.LAST;
      IF (count_suffix_ = count_values_) THEN
         LOOP
            tmp_key_ := key_;
            IF ((suffix_array_(i_) != '<NULL>') AND (suffix_array_(i_) IS NOT NULL)) THEN
               tmp_key_ := tmp_key_||'^'||suffix_array_(i_);
            END IF;
            IF (option_ = 'REMOVE') THEN
               -- remove attribute key from translation storage
               Enterp_Comp_Connect_V170_API.Remove_Template_Attribute_Key(rec_.template_id, rec_.component, rec_.lu, tmp_key_);
            ELSE
               IF (tmp_key_ IS NOT NULL) THEN
                  -- call to translation storage
                  Enterp_Comp_Connect_V170_API.Insert_Prog(rec_.template_id, rec_.component, rec_.lu, tmp_key_, value_array_(i_));                                          
                  -- If the template is a system template then add the text/description as 'en' translation. This since the application 
                  -- is normally not translated to english since the default system texts/descriptions (system templates in this case) is in english.
                  -- For non system templates the translation for english and any other lanugage needs to be handled using the translation
                  -- forms/interface in the application.
                  IF (system_templ_ = 'TRUE') THEN
                     IF (RTRIM(value_array_(i_)) IS NOT NULL) THEN                           
                        language_code_ := 'en';
                        Templ_Key_Lu_Translation_API.Insert_Translation__(rec_.template_id, rec_.component, rec_.lu, tmp_key_, language_code_, value_array_(i_));                              
                     END IF;
                  END IF;                     
               END IF;
            END IF;
            EXIT WHEN i_ = j_;
            i_ := value_array_.NEXT(i_);
         END LOOP;
      END IF;
   END IF;
END Check_If_Translatable___;


FUNCTION Get_Lu_Key_Values___ (
   name_    IN VARCHAR2,
   rec_     IN create_company_tem_detail_tab%ROWTYPE ) RETURN VARCHAR2
IS
   value_      VARCHAR2(2000);
BEGIN
   IF (name_ = 'C1') THEN
      value_ := rec_.c1;
   ELSIF (name_ = 'C2') THEN
      value_ := rec_.c2;
   ELSIF (name_ = 'C3') THEN
      value_ := rec_.c3;
   ELSIF (name_ = 'C4') THEN
      value_ := rec_.c4;
   ELSIF (name_ = 'C5') THEN
      value_ := rec_.c5;
   ELSIF (name_ = 'C6') THEN
      value_ := rec_.c6;
   ELSIF (name_ = 'C7') THEN
      value_ := rec_.c7;
   ELSIF (name_ = 'C8') THEN
      value_ := rec_.c8;
   ELSIF (name_ = 'C9') THEN
      value_ := rec_.c9;
   ELSIF (name_ = 'C10') THEN
      value_ := rec_.c10;
   ELSIF (name_ = 'C11') THEN
      value_ := rec_.c11;
   ELSIF (name_ = 'C12') THEN
      value_ := rec_.c12;
   ELSIF (name_ = 'C13') THEN
      value_ := rec_.c13;
   ELSIF (name_ = 'C14') THEN
      value_ := rec_.c14;
   ELSIF (name_ = 'C15') THEN
      value_ := rec_.c15;
   ELSIF (name_ = 'C16') THEN
      value_ := rec_.c16;
   ELSIF (name_ = 'C17') THEN
      value_ := rec_.c17;
   ELSIF (name_ = 'C18') THEN
      value_ := rec_.c18;
   ELSIF (name_ = 'C19') THEN
      value_ := rec_.c19;
   ELSIF (name_ = 'C20') THEN
      value_ := rec_.c20;
   ELSIF (name_ = 'C21') THEN
      value_ := rec_.c21;
   ELSIF (name_ = 'C22') THEN
      value_ := rec_.c22;
   ELSIF (name_ = 'C23') THEN
      value_ := rec_.c23;
   ELSIF (name_ = 'C24') THEN
      value_ := rec_.c24;
   ELSIF (name_ = 'C25') THEN
      value_ := rec_.c25;
   ELSIF (name_ = 'C26') THEN
      value_ := rec_.c26;
   ELSIF (name_ = 'C27') THEN
      value_ := rec_.c27;
   ELSIF (name_ = 'C28') THEN
      value_ := rec_.c28;
   ELSIF (name_ = 'C29') THEN
      value_ := rec_.c29;
   ELSIF (name_ = 'C30') THEN
      value_ := rec_.c30;
   ELSIF (name_ = 'C31') THEN
      value_ := rec_.c31;
   ELSIF (name_ = 'C32') THEN
      value_ := rec_.c32;
   ELSIF (name_ = 'C33') THEN
      value_ := rec_.c33;
   ELSIF (name_ = 'C34') THEN
      value_ := rec_.c34;
   ELSIF (name_ = 'C35') THEN
      value_ := rec_.c35;
   ELSIF (name_ = 'C36') THEN
      value_ := rec_.c36;
   ELSIF (name_ = 'C37') THEN
      value_ := rec_.c37;
   ELSIF (name_ = 'C38') THEN
      value_ := rec_.c38;
   ELSIF (name_ = 'C39') THEN
      value_ := rec_.c39;
   ELSIF (name_ = 'C40') THEN
      value_ := rec_.c40;
   ELSIF (name_ = 'C41') THEN
      value_ := rec_.c41;
   ELSIF (name_ = 'C42') THEN
      value_ := rec_.c42;
   ELSIF (name_ = 'C43') THEN
      value_ := rec_.c43;
   ELSIF (name_ = 'C44') THEN
      value_ := rec_.c44;
   ELSIF (name_ = 'C45') THEN
      value_ := rec_.c45;
   ELSIF (name_ = 'C46') THEN
      value_ := rec_.c46;
   ELSIF (name_ = 'C47') THEN
      value_ := rec_.c47;
   ELSIF (name_ = 'C48') THEN
      value_ := rec_.c48;
   ELSIF (name_ = 'C49') THEN
      value_ := rec_.c49;
   ELSIF (name_ = 'C50') THEN
      value_ := rec_.c50;
   ELSIF (name_ = 'C51') THEN
      value_ := rec_.c51;
   ELSIF (name_ = 'C52') THEN
      value_ := rec_.c52;
   ELSIF (name_ = 'C53') THEN
      value_ := rec_.c53;
   ELSIF (name_ = 'C54') THEN
      value_ := rec_.c54;
   ELSIF (name_ = 'C55') THEN
      value_ := rec_.c55;
   ELSIF (name_ = 'C56') THEN
      value_ := rec_.c56;
   ELSIF (name_ = 'C57') THEN
      value_ := rec_.c57;
   ELSIF (name_ = 'C58') THEN
      value_ := rec_.c58;
   ELSIF (name_ = 'C59') THEN
      value_ := rec_.c59;
   ELSIF (name_ = 'C60') THEN
      value_ := rec_.c60;
   ELSIF (name_ = 'C61') THEN
      value_ := rec_.c61;
   ELSIF (name_ = 'C62') THEN
      value_ := rec_.c62;
   ELSIF (name_ = 'C63') THEN
      value_ := rec_.c63;
   ELSIF (name_ = 'C64') THEN
      value_ := rec_.c64;
   ELSIF (name_ = 'C65') THEN
      value_ := rec_.c65;
   ELSIF (name_ = 'C66') THEN
      value_ := rec_.c66;
   ELSIF (name_ = 'C67') THEN
      value_ := rec_.c67;
   ELSIF (name_ = 'C68') THEN
      value_ := rec_.c68;
   ELSIF (name_ = 'C69') THEN
      value_ := rec_.c69;
   ELSIF (name_ = 'C70') THEN
      value_ := rec_.c70;
   ELSIF (name_ = 'EXT_C1') THEN
      value_ := rec_.ext_c1;
   ELSIF (name_ = 'EXT_C2') THEN
      value_ := rec_.ext_c2;
   ELSIF (name_ = 'EXT_C3') THEN
      value_ := rec_.ext_c3;
   ELSIF (name_ = 'EXT_C4') THEN
      value_ := rec_.ext_c4;
   ELSIF (name_ = 'EXT_C5') THEN
      value_ := rec_.ext_c5;
   ELSIF (name_ = 'EXT_C6') THEN
      value_ := rec_.ext_c6;
   ELSIF (name_ = 'EXT_C7') THEN
      value_ := rec_.ext_c7;
   ELSIF (name_ = 'EXT_C8') THEN
      value_ := rec_.ext_c8;
   ELSIF (name_ = 'EXT_C9') THEN
      value_ := rec_.ext_c9;
   ELSIF (name_ = 'EXT_C10') THEN
      value_ := rec_.ext_c10;
   ELSIF (name_ = 'EXT_C11') THEN
      value_ := rec_.ext_c11;
   ELSIF (name_ = 'EXT_C12') THEN
      value_ := rec_.ext_c12;
   ELSIF (name_ = 'EXT_C13') THEN
      value_ := rec_.ext_c13;
   ELSIF (name_ = 'EXT_C14') THEN
      value_ := rec_.ext_c14;
   ELSIF (name_ = 'EXT_C15') THEN
      value_ := rec_.ext_c15;
   ELSIF (name_ = 'EXT_C16') THEN
      value_ := rec_.ext_c16;
   ELSIF (name_ = 'EXT_C17') THEN
      value_ := rec_.ext_c17;
   ELSIF (name_ = 'EXT_C18') THEN
      value_ := rec_.ext_c18;
   ELSIF (name_ = 'EXT_C19') THEN
      value_ := rec_.ext_c19;
   ELSIF (name_ = 'EXT_C20') THEN
      value_ := rec_.ext_c20;
   ELSIF (name_ = 'EXT_C21') THEN
      value_ := rec_.ext_c21;
   ELSIF (name_ = 'EXT_C22') THEN
      value_ := rec_.ext_c22;
   ELSIF (name_ = 'EXT_C23') THEN
      value_ := rec_.ext_c23;
   ELSIF (name_ = 'EXT_C24') THEN
      value_ := rec_.ext_c24;
   ELSIF (name_ = 'EXT_C25') THEN
      value_ := rec_.ext_c25;
   ELSIF (name_ = 'EXT_C26') THEN
      value_ := rec_.ext_c26;
   ELSIF (name_ = 'EXT_C27') THEN
      value_ := rec_.ext_c27;
   ELSIF (name_ = 'EXT_C28') THEN
      value_ := rec_.ext_c28;
   ELSIF (name_ = 'EXT_C29') THEN
      value_ := rec_.ext_c29;
   ELSIF (name_ = 'EXT_C30') THEN
      value_ := rec_.ext_c30;      
   ELSIF (name_ = 'N1') THEN
      value_ := TO_CHAR(rec_.n1);
   ELSIF (name_ = 'N2') THEN
      value_ := TO_CHAR(rec_.n2);
   ELSIF (name_ = 'N3') THEN
      value_ := TO_CHAR(rec_.n3);
   ELSIF (name_ = 'N4') THEN
      value_ := TO_CHAR(rec_.n4);
   ELSIF (name_ = 'N5') THEN
      value_ := TO_CHAR(rec_.n5);
   ELSIF (name_ = 'N6') THEN
      value_ := TO_CHAR(rec_.n6);
   ELSIF (name_ = 'N7') THEN
      value_ := TO_CHAR(rec_.n7);
   ELSIF (name_ = 'N8') THEN
      value_ := TO_CHAR(rec_.n8);
   ELSIF (name_ = 'N9') THEN
      value_ := TO_CHAR(rec_.n9);
   ELSIF (name_ = 'N10') THEN
      value_ := TO_CHAR(rec_.n10);
   ELSIF (name_ = 'N11') THEN
      value_ := TO_CHAR(rec_.n11);
   ELSIF (name_ = 'N12') THEN
      value_ := TO_CHAR(rec_.n12);
   ELSIF (name_ = 'N13') THEN
      value_ := TO_CHAR(rec_.n13);
   ELSIF (name_ = 'N14') THEN
      value_ := TO_CHAR(rec_.n14);
   ELSIF (name_ = 'N15') THEN
      value_ := TO_CHAR(rec_.n15);
   ELSIF (name_ = 'N16') THEN
      value_ := TO_CHAR(rec_.n16);
   ELSIF (name_ = 'N17') THEN
      value_ := TO_CHAR(rec_.n17);
   ELSIF (name_ = 'N18') THEN
      value_ := TO_CHAR(rec_.n18);
   ELSIF (name_ = 'N19') THEN
      value_ := TO_CHAR(rec_.n19);
   ELSIF (name_ = 'N20') THEN
      value_ := TO_CHAR(rec_.n20);
   ELSIF (name_ = 'EXT_N1') THEN
      value_ := TO_CHAR(rec_.ext_n1);
   ELSIF (name_ = 'EXT_N2') THEN
      value_ := TO_CHAR(rec_.ext_n2);
   ELSIF (name_ = 'EXT_N3') THEN
      value_ := TO_CHAR(rec_.ext_n3);
   ELSIF (name_ = 'EXT_N4') THEN
      value_ := TO_CHAR(rec_.ext_n4);
   ELSIF (name_ = 'EXT_N5') THEN
      value_ := TO_CHAR(rec_.ext_n5);
   ELSIF (name_ = 'EXT_N6') THEN
      value_ := TO_CHAR(rec_.ext_n6);
   ELSIF (name_ = 'EXT_N7') THEN
      value_ := TO_CHAR(rec_.ext_n7);
   ELSIF (name_ = 'EXT_N8') THEN
      value_ := TO_CHAR(rec_.ext_n8);
   ELSIF (name_ = 'EXT_N9') THEN
      value_ := TO_CHAR(rec_.ext_n9);
   ELSIF (name_ = 'EXT_N10') THEN
      value_ := TO_CHAR(rec_.ext_n10);
   ELSIF (name_ = 'EXT_N11') THEN
      value_ := TO_CHAR(rec_.ext_n11);
   ELSIF (name_ = 'EXT_N12') THEN
      value_ := TO_CHAR(rec_.ext_n12);
   ELSIF (name_ = 'EXT_N13') THEN
      value_ := TO_CHAR(rec_.ext_n13);
   ELSIF (name_ = 'EXT_N14') THEN
      value_ := TO_CHAR(rec_.ext_n14);
   ELSIF (name_ = 'EXT_N15') THEN
      value_ := TO_CHAR(rec_.ext_n15);
   ELSIF (name_ = 'EXT_N16') THEN
      value_ := TO_CHAR(rec_.ext_n16);
   ELSIF (name_ = 'EXT_N17') THEN
      value_ := TO_CHAR(rec_.ext_n17);
   ELSIF (name_ = 'EXT_N18') THEN
      value_ := TO_CHAR(rec_.ext_n18);
   ELSIF (name_ = 'EXT_N19') THEN
      value_ := TO_CHAR(rec_.ext_n19);
   ELSIF (name_ = 'EXT_N20') THEN
      value_ := TO_CHAR(rec_.ext_n20);      
   ELSIF (name_ = 'D1') THEN
      value_ := TO_DATE(rec_.d1, 'YYYY-MM-DD');
   ELSIF (name_ = 'D2') THEN
      value_ := TO_DATE(rec_.d2, 'YYYY-MM-DD');
   ELSIF (name_ = 'D3') THEN
      value_ := TO_DATE(rec_.d3, 'YYYY-MM-DD');
   ELSIF (name_ = 'D4') THEN
      value_ := TO_DATE(rec_.d4, 'YYYY-MM-DD');
   ELSIF (name_ = 'D5') THEN
      value_ := TO_DATE(rec_.d5, 'YYYY-MM-DD');
   ELSIF (name_ = 'EXT_D1') THEN
      value_ := TO_DATE(rec_.ext_d1, 'YYYY-MM-DD');
   ELSIF (name_ = 'EXT_D2') THEN
      value_ := TO_DATE(rec_.ext_d2, 'YYYY-MM-DD');
   ELSIF (name_ = 'EXT_D3') THEN
      value_ := TO_DATE(rec_.ext_d3, 'YYYY-MM-DD');
   ELSIF (name_ = 'EXT_D4') THEN
      value_ := TO_DATE(rec_.ext_d4, 'YYYY-MM-DD');
   ELSIF (name_ = 'EXT_D5') THEN
      value_ := TO_DATE(rec_.ext_d5, 'YYYY-MM-DD');
   END IF;
   RETURN value_;
END Get_Lu_Key_Values___;


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

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     create_company_tem_detail_tab%ROWTYPE,
   newrec_ IN OUT create_company_tem_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN 
   IF (indrec_.selected = TRUE) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.selected);
   END IF;      
   super(oldrec_, newrec_, indrec_, attr_);   
   IF (Create_Company_Tem_API.Change_Template_Allowed(newrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'INSNOTALLOWED: Not allowed to change a template created by another user. '||
                               'Only a company template super user is allowed to change other users templates');
   END IF;   
   Create_Company_Tem_API.User_Allowed_To_Modify(newrec_.template_id);   
END Check_Common___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT create_company_tem_detail_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   dummy_attr_    VARCHAR2(100);
   inst_method_   VARCHAR2(100);
BEGIN
   newrec_.selected := NVL(newrec_.selected, 'TRUE');
   super(objid_, objversion_, newrec_, attr_);   
   -- To know from where the process started   
   inst_method_ := NVL(Client_SYS.Cut_Item_Value('FROM_METHOD', attr_), 'INSERT___');
   Client_SYS.Add_To_Attr('FROM_METHOD', inst_method_, dummy_attr_);   
   Check_If_Translatable___(dummy_attr_, newrec_, 'INSERT');   
   Create_Company_Tem_API.Set_Last_Modification_Date(newrec_.template_id);               
   Client_SYS.Add_To_Attr('ITEM_ID', newrec_.item_id, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     create_company_tem_detail_tab%ROWTYPE,
   newrec_     IN OUT create_company_tem_detail_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS   
   dummy_attr_    VARCHAR2(100);
   inst_method_   VARCHAR2(100);   
BEGIN
   newrec_.selected := NVL(newrec_.selected, 'TRUE');
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   inst_method_ := NVL(Client_SYS.Cut_Item_Value('FROM_METHOD', attr_), 'UPDATE___');
   Client_SYS.Add_To_Attr('FROM_METHOD', inst_method_, dummy_attr_);
   Check_If_Translatable___(dummy_attr_, newrec_, 'UPDATE');
   Create_Company_Tem_API.Set_Last_Modification_Date(newrec_.template_id);            
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN create_company_tem_detail_tab%ROWTYPE )
IS   
BEGIN
   Create_Company_Tem_API.User_Allowed_To_Modify(remrec_.template_id);
   IF (Create_Company_Tem_API.Change_Template_Allowed(remrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'REMNOTALLOWED: Not allowed to remove a template created by another user. '||
                               'Only a company template super user is allowed to remove other users templates');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN create_company_tem_detail_tab%ROWTYPE )
IS  
BEGIN
   super(objid_, remrec_);
   Check_If_Translatable___(NULL, remrec_, 'REMOVE');
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT create_company_tem_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   item_id_ NUMBER;
   CURSOR get_max_item_id IS
      SELECT MAX(item_id)
      FROM   create_company_tem_detail_tab
      WHERE  template_id = newrec_.template_id
      AND    component = newrec_.component
      AND    lu = newrec_.lu;
BEGIN   
   OPEN get_max_item_id;
   FETCH get_max_item_id INTO item_id_;
   CLOSE get_max_item_id;
   IF (item_id_ IS NULL) THEN
      item_id_ := 0;
   END IF;
   newrec_.item_id := item_id_ + 1;      
   super(newrec_, indrec_, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Data__ (
   detail_rec_ IN Create_Company_Tem_API.Public_Rec_Templ )
IS
   objid_        create_company_tem_detail.objid%TYPE;
   objversion_   create_company_tem_detail.objversion%TYPE;
   attr_         VARCHAR2(2000);
   newrec_       create_company_tem_detail_tab%ROWTYPE;
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', detail_rec_.template_id);
   Error_SYS.Check_Not_Null(lu_name_, 'COMPONENT', detail_rec_.component);
   Error_SYS.Check_Not_Null(lu_name_, 'LU', detail_rec_.lu);
   Error_SYS.Check_Not_Null(lu_name_, 'ITEM_ID', detail_rec_.item_id);
   Record_Assign___(newrec_, detail_rec_);
   Client_SYS.Add_To_Attr('FROM_METHOD', 'INSERT_DATA__', attr_);
   Insert___(objid_, objversion_, newrec_,  attr_);
END Insert_Data__;


PROCEDURE Insert_New_Data__( newrec_ IN create_company_tem_detail_tab%ROWTYPE )
IS
   objid_        create_company_tem_detail.objid%TYPE;
   objversion_   create_company_tem_detail.objversion%TYPE;
   attr_         VARCHAR2(100);
   newrec2_      create_company_tem_detail_tab%ROWTYPE;
BEGIN
   newrec2_ := newrec_;
   Client_SYS.Add_To_Attr('FROM_METHOD', 'INSERT_NEW_DATA__', attr_);
   Insert___(objid_, objversion_, newrec2_,  attr_);
END Insert_New_Data__;


PROCEDURE Update_Diff_Template__(
   public_rec_  IN  Create_Company_Tem_API.Public_Rec_Templ )
IS
   newrec_       create_company_tem_detail_tab%ROWTYPE;
   oldrec_       create_company_tem_detail_tab%ROWTYPE;
   objid_        create_company_tem_detail.objid%TYPE;
   objversion_   create_company_tem_detail.objversion%TYPE;
   attr_         VARCHAR2(2000);
BEGIN
   IF (public_rec_.description = 'Temporary Difference Template') THEN
      Record_Assign___ (newrec_, public_rec_);
      newrec_.rowkey := Get_Objkey(newrec_.template_id, newrec_.component, newrec_.lu, newrec_.item_id);               
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Update_Diff_Template__;


FUNCTION Get_Curr_Bal_Code_Part__ (
   template_id_ IN VARCHAR2 ) RETURN VARCHAR2 
IS  
   code_part_     create_company_tem_detail_tab.c1%TYPE := '';
   CURSOR get_curr_bal_code_part IS
      SELECT c1         code_part
      FROM   create_company_tem_detail_tab
      WHERE  template_id = template_id_
      AND    component   = 'ACCRUL'
      AND    lu          = 'AccountingCodeParts'
      AND    c4          = 'CURR';
BEGIN
   OPEN get_curr_bal_code_part;
   FETCH get_curr_bal_code_part INTO code_part_;
   CLOSE get_curr_bal_code_part;
   RETURN code_part_;
END Get_Curr_Bal_Code_Part__;


FUNCTION Get_Internal_Name__ (
   template_id_ IN VARCHAR2,
   code_part_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   internal_name_    create_company_tem_detail_tab.c2%TYPE := '';
   CURSOR get_internal_name IS
      SELECT c2      internal_name
      FROM   create_company_tem_detail_tab
      WHERE  template_id = template_id_        
      AND    component   = 'ACCRUL'
      AND    lu          = 'AccountingCodeParts'
      AND    c1          = code_part_; 
BEGIN
   OPEN get_internal_name;
   FETCH get_internal_name INTO internal_name_;   
   CLOSE get_internal_name;
   RETURN internal_name_;   
END Get_Internal_Name__;
   

FUNCTION Is_Valid_Code_Part__ (
   template_id_ IN VARCHAR2,
   code_part_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_     create_company_tem_detail_tab.c1%TYPE := '';
   CURSOR get_curr_bal_code_part IS
      SELECT c1      code_part
      FROM   create_company_tem_detail_tab
      WHERE  template_id = template_id_      
      AND    component   = 'ACCRUL'
      AND    lu          = 'AccountingCodeParts'
      AND    c4          = 'NOFUNC'
      AND    c1          = code_part_;
BEGIN   
   OPEN get_curr_bal_code_part;
   FETCH get_curr_bal_code_part INTO dummy_;
   IF (get_curr_bal_code_part%FOUND) THEN
      CLOSE get_curr_bal_code_part;
      RETURN 'TRUE';
   END IF;
   CLOSE get_curr_bal_code_part;
   RETURN 'FALSE';  
END Is_Valid_Code_Part__;


@UncheckedAccess
FUNCTION Get_Use_No_Period_Template__(
   template_id_    IN  VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_temp_value IS
   SELECT C6 AS use_vou_no_period
   FROM   create_company_tem_detail_tab
   WHERE  template_id = template_id_
   AND    component     = 'ACCRUL'
   AND    lu            = 'CompanyFinance';
   use_vou_no_period_    create_company_tem_detail_tab.c6%TYPE;
BEGIN
   OPEN get_temp_value;
   FETCH get_temp_value INTO use_vou_no_period_;
   CLOSE get_temp_value;
   RETURN NVL(use_vou_no_period_, 'FALSE');
END Get_Use_No_Period_Template__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--This method is to be used by Aurena
PROCEDURE Modify_Create_Comp_Tem_Detail (
   newrec_ IN OUT create_company_tem_detail_tab%ROWTYPE )
IS
   oldrec_ create_company_tem_detail_tab%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys_Nowait___(newrec_.template_id, newrec_.component, newrec_.lu, newrec_.item_id);
   newrec_ := oldrec_;
   newrec_.selected := 'FALSE';
   Modify___(newrec_);
END Modify_Create_Comp_Tem_Detail;