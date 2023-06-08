-----------------------------------------------------------------------------
--
--  Logical unit: IntersiteDataTransfer
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140707  MAHPLK  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Unpack___ (
   newrec_   IN OUT NOCOPY INTERSITE_DATA_TRANSFER_TMP%ROWTYPE,
   attr_     IN VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(32000);
   msg_   VARCHAR2(32000);
BEGIN   
   Client_SYS.Clear_Attr(msg_);
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('MESSAGE_ID') THEN
         newrec_.message_id := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('MESSAGE_LINE') THEN
         newrec_.message_line := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('NAME') THEN
         newrec_.name := value_;
      WHEN ('ERROR_MESSAGE') THEN
         newrec_.error_message := value_;
      WHEN ('C00') THEN
         newrec_.c00 := value_;
      WHEN ('C01') THEN
         newrec_.c01 := value_;
      WHEN ('C02') THEN
         newrec_.c02 := value_;
      WHEN ('C03') THEN
         newrec_.c03 := value_;
      WHEN ('C04') THEN
         newrec_.c04 := value_;
      WHEN ('C05') THEN
         newrec_.c05 := value_;
      WHEN ('C06') THEN
         newrec_.c06 := value_;
      WHEN ('C07') THEN
         newrec_.c07 := value_;
      WHEN ('C08') THEN
         newrec_.c08 := value_;
      WHEN ('C09') THEN
         newrec_.c09 := value_;
      WHEN ('C10') THEN
         newrec_.c10 := value_;
      WHEN ('C11') THEN
         newrec_.c11 := value_;
      WHEN ('C12') THEN
         newrec_.c12 := value_;
      WHEN ('C13') THEN
         newrec_.c13 := value_;
      WHEN ('C14') THEN
         newrec_.c14 := value_;
      WHEN ('C15') THEN
         newrec_.c15 := value_;
      WHEN ('C16') THEN
         newrec_.c16 := value_;
      WHEN ('C17') THEN
         newrec_.c17 := value_;
      WHEN ('C18') THEN
         newrec_.c18 := value_;
      WHEN ('C19') THEN
         newrec_.c19 := value_;
      WHEN ('C20') THEN
         newrec_.c20 := value_;
      WHEN ('C21') THEN
         newrec_.c21 := value_;
      WHEN ('C22') THEN
         newrec_.c22 := value_;
      WHEN ('C23') THEN
         newrec_.c23 := value_;
      WHEN ('C24') THEN
         newrec_.c24 := value_;
      WHEN ('C25') THEN
         newrec_.c25 := value_;
      WHEN ('C26') THEN
         newrec_.c26 := value_;
      WHEN ('C27') THEN
         newrec_.c27 := value_;
      WHEN ('C28') THEN
         newrec_.c28 := value_;
      WHEN ('C29') THEN
         newrec_.c29 := value_;
      WHEN ('C30') THEN
         newrec_.c30 := value_;
      WHEN ('C31') THEN
         newrec_.c31 := value_;
      WHEN ('C32') THEN
         newrec_.c32 := value_;
      WHEN ('C33') THEN
         newrec_.c33 := value_;
      WHEN ('C34') THEN
         newrec_.c34 := value_;
      WHEN ('C35') THEN
         newrec_.c35 := value_;
      WHEN ('C36') THEN
         newrec_.c36 := value_;
      WHEN ('C37') THEN
         newrec_.c37 := value_;
      WHEN ('C38') THEN
         newrec_.c38 := value_;
      WHEN ('C39') THEN
         newrec_.c39 := value_;
      WHEN ('C40') THEN
         newrec_.c40 := value_;
      WHEN ('C41') THEN
         newrec_.c41 := value_;
      WHEN ('C42') THEN
         newrec_.c42 := value_;
      WHEN ('C43') THEN
         newrec_.c43 := value_;
      WHEN ('C44') THEN
         newrec_.c44 := value_;
      WHEN ('C45') THEN
         newrec_.c45 := value_;
      WHEN ('C46') THEN
         newrec_.c46 := value_;
      WHEN ('C47') THEN
         newrec_.c47 := value_;
      WHEN ('C48') THEN
         newrec_.c48 := value_;
      WHEN ('C49') THEN
         newrec_.c49 := value_;
      WHEN ('C50') THEN
         newrec_.c50 := value_;
      WHEN ('C51') THEN
         newrec_.c51 := value_;
      WHEN ('C52') THEN
         newrec_.c52 := value_;
      WHEN ('C53') THEN
         newrec_.c53 := value_;
      WHEN ('C54') THEN
         newrec_.c54 := value_;
      WHEN ('C55') THEN
         newrec_.c55 := value_;
      WHEN ('C56') THEN
         newrec_.c56 := value_;
      WHEN ('C57') THEN
         newrec_.c57 := value_;
      WHEN ('C58') THEN
         newrec_.c58 := value_;
      WHEN ('C59') THEN
         newrec_.c59 := value_;
      WHEN ('C60') THEN
         newrec_.c60 := value_;
      WHEN ('C61') THEN
         newrec_.c61 := value_;
      WHEN ('C62') THEN
         newrec_.c62 := value_;
      WHEN ('C63') THEN
         newrec_.c63 := value_;
      WHEN ('C64') THEN
         newrec_.c64 := value_;
      WHEN ('C65') THEN
         newrec_.c65 := value_;
      WHEN ('C66') THEN
         newrec_.c66 := value_;
      WHEN ('C67') THEN
         newrec_.c67 := value_;
      WHEN ('C68') THEN
         newrec_.c68 := value_;
      WHEN ('C69') THEN
         newrec_.c69 := value_;
      WHEN ('C70') THEN
         newrec_.c70 := value_;
      WHEN ('C71') THEN
         newrec_.c71 := value_;
      WHEN ('C72') THEN
         newrec_.c72 := value_;
      WHEN ('C73') THEN
         newrec_.c73 := value_;
      WHEN ('C74') THEN
         newrec_.c74 := value_;
      WHEN ('C75') THEN
         newrec_.c75 := value_;
      WHEN ('C76') THEN
         newrec_.c76 := value_;
      WHEN ('C77') THEN
         newrec_.c77 := value_;
      WHEN ('C78') THEN
         newrec_.c78 := value_;
      WHEN ('C79') THEN
         newrec_.c79 := value_;
      WHEN ('C80') THEN
         newrec_.c80 := value_;
      WHEN ('C81') THEN
         newrec_.c81 := value_;
      WHEN ('C82') THEN
         newrec_.c82 := value_;
      WHEN ('C83') THEN
         newrec_.c83 := value_;
      WHEN ('C84') THEN
         newrec_.c84 := value_;
      WHEN ('C85') THEN
         newrec_.c85 := value_;
      WHEN ('C86') THEN
         newrec_.c86 := value_;
      WHEN ('C87') THEN
         newrec_.c87 := value_;
      WHEN ('C88') THEN
         newrec_.c88 := value_;
      WHEN ('C89') THEN
         newrec_.c89 := value_;
      WHEN ('C90') THEN
         newrec_.c90 := value_;
      WHEN ('C91') THEN
         newrec_.c91 := value_;
      WHEN ('C92') THEN
         newrec_.c92 := value_;
      WHEN ('C93') THEN
         newrec_.c93 := value_;
      WHEN ('C94') THEN
         newrec_.c94 := value_;
      WHEN ('C95') THEN
         newrec_.c95 := value_;
      WHEN ('C96') THEN
         newrec_.c96 := value_;
      WHEN ('C97') THEN
         newrec_.c97 := value_;
      WHEN ('C98') THEN
         newrec_.c98 := value_;
      WHEN ('C99') THEN
         newrec_.c99 := value_;
      WHEN ('N00') THEN
         newrec_.n00 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N01') THEN
         newrec_.n01 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N02') THEN
         newrec_.n02 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N03') THEN
         newrec_.n03 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N04') THEN
         newrec_.n04 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N05') THEN
         newrec_.n05 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N06') THEN
         newrec_.n06 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N07') THEN
         newrec_.n07 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N08') THEN
         newrec_.n08 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N09') THEN
         newrec_.n09 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N10') THEN
         newrec_.n10 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N11') THEN
         newrec_.n11 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N12') THEN
         newrec_.n12 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N13') THEN
         newrec_.n13 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N14') THEN
         newrec_.n14 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N15') THEN
         newrec_.n15 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N16') THEN
         newrec_.n16 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N17') THEN
         newrec_.n17 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N18') THEN
         newrec_.n18 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N19') THEN
         newrec_.n19 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N20') THEN
         newrec_.n20 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N21') THEN
         newrec_.n21 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N22') THEN
         newrec_.n22 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N23') THEN
         newrec_.n23 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N24') THEN
         newrec_.n24 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N25') THEN
         newrec_.n25 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N26') THEN
         newrec_.n26 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N27') THEN
         newrec_.n27 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N28') THEN
         newrec_.n28 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N29') THEN
         newrec_.n29 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N30') THEN
         newrec_.n30 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N31') THEN
         newrec_.n31 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N32') THEN
         newrec_.n32 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N33') THEN
         newrec_.n33 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N34') THEN
         newrec_.n34 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N35') THEN
         newrec_.n35 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N36') THEN
         newrec_.n36 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N37') THEN
         newrec_.n37 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N38') THEN
         newrec_.n38 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N39') THEN
         newrec_.n39 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N40') THEN
         newrec_.n40 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N41') THEN
         newrec_.n41 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N42') THEN
         newrec_.n42 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N43') THEN
         newrec_.n43 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N44') THEN
         newrec_.n44 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N45') THEN
         newrec_.n45 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N46') THEN
         newrec_.n46 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N47') THEN
         newrec_.n47 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N48') THEN
         newrec_.n48 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N49') THEN
         newrec_.n49 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N50') THEN
         newrec_.n50 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N51') THEN
         newrec_.n51 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N52') THEN
         newrec_.n52 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N53') THEN
         newrec_.n53 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N54') THEN
         newrec_.n54 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N55') THEN
         newrec_.n55 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N56') THEN
         newrec_.n56 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N57') THEN
         newrec_.n57 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N58') THEN
         newrec_.n58 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N59') THEN
         newrec_.n59 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N60') THEN
         newrec_.n60 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N61') THEN
         newrec_.n61 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N62') THEN
         newrec_.n62 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N63') THEN
         newrec_.n63 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N64') THEN
         newrec_.n64 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N65') THEN
         newrec_.n65 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N66') THEN
         newrec_.n66 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N67') THEN
         newrec_.n67 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N68') THEN
         newrec_.n68 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N69') THEN
         newrec_.n69 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N70') THEN
         newrec_.n70 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N71') THEN
         newrec_.n71 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N72') THEN
         newrec_.n72 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N73') THEN
         newrec_.n73 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N74') THEN
         newrec_.n74 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N75') THEN
         newrec_.n75 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N76') THEN
         newrec_.n76 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N77') THEN
         newrec_.n77 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N78') THEN
         newrec_.n78 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N79') THEN
         newrec_.n79 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N80') THEN
         newrec_.n80 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N81') THEN
         newrec_.n81 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N82') THEN
         newrec_.n82 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N83') THEN
         newrec_.n83 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N84') THEN
         newrec_.n84 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N85') THEN
         newrec_.n85 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N86') THEN
         newrec_.n86 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N87') THEN
         newrec_.n87 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N88') THEN
         newrec_.n88 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N89') THEN
         newrec_.n89 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N90') THEN
         newrec_.n90 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N91') THEN
         newrec_.n91 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N92') THEN
         newrec_.n92 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N93') THEN
         newrec_.n93 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N94') THEN
         newrec_.n94 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N95') THEN
         newrec_.n95 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N96') THEN
         newrec_.n96 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N97') THEN
         newrec_.n97 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N98') THEN
         newrec_.n98 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('N99') THEN
         newrec_.n99 := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('D00') THEN
         newrec_.d00 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D01') THEN
         newrec_.d01 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D02') THEN
         newrec_.d02 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D03') THEN
         newrec_.d03 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D04') THEN
         newrec_.d04 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D05') THEN
         newrec_.d05 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D06') THEN
         newrec_.d06 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D07') THEN
         newrec_.d07 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D08') THEN
         newrec_.d08 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D09') THEN
         newrec_.d09 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D10') THEN
         newrec_.d10 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D11') THEN
         newrec_.d11 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D12') THEN
         newrec_.d12 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D13') THEN
         newrec_.d13 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D14') THEN
         newrec_.d14 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D15') THEN
         newrec_.d15 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D16') THEN
         newrec_.d16 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D17') THEN
         newrec_.d17 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D18') THEN
         newrec_.d18 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D19') THEN
         newrec_.d19 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D20') THEN
         newrec_.d20 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D21') THEN
         newrec_.d21 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D22') THEN
         newrec_.d22 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D23') THEN
         newrec_.d23 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D24') THEN
         newrec_.d24 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D25') THEN
         newrec_.d25 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D26') THEN
         newrec_.d26 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D27') THEN
         newrec_.d27 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D28') THEN
         newrec_.d28 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D29') THEN
         newrec_.d29 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D30') THEN
         newrec_.d30 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D31') THEN
         newrec_.d31 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D32') THEN
         newrec_.d32 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D33') THEN
         newrec_.d33 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D34') THEN
         newrec_.d34 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D35') THEN
         newrec_.d35 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D36') THEN
         newrec_.d36 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D37') THEN
         newrec_.d37 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D38') THEN
         newrec_.d38 := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('D39') THEN
         newrec_.d39 := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, msg_);
      END CASE;
   END LOOP;
END Unpack___;

PROCEDURE Insert___ (
   newrec_     IN OUT NOCOPY INTERSITE_DATA_TRANSFER_TMP%ROWTYPE,
   attr_       IN VARCHAR2 )
IS
BEGIN
   newrec_.name := upper(newrec_.name);
   INSERT
      INTO intersite_data_transfer_tmp
      VALUES newrec_;  
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Message_Line (attr_ IN VARCHAR2)
IS
   temp_rec_ INTERSITE_DATA_TRANSFER_TMP%ROWTYPE;   
BEGIN
   Unpack___(temp_rec_, attr_);         
   Insert___(temp_rec_, attr_);
END Create_Message_Line;

PROCEDURE Delete_Intersite_Data_Tmp
IS   
BEGIN
   DELETE FROM intersite_data_transfer_tmp;   
END Delete_Intersite_Data_Tmp;

PROCEDURE Fill_Intersite_Data_Tmp (message_id_ IN NUMBER)
IS   
BEGIN
   -- Fill temporary table intersite_data_transfer_tmp
   INSERT INTO intersite_data_transfer_tmp 
      (SELECT *
       FROM IN_MESSAGE_LINE_PUB
       WHERE message_id = message_id_);
END Fill_Intersite_Data_Tmp;

FUNCTION Get_Acquisition_Site (message_id_ IN NUMBER, message_type_ IN VARCHAR2) RETURN VARCHAR2
IS  
    acquisition_site_ VARCHAR2(5);
    c1_               VARCHAR2(2000);
    c2_               VARCHAR2(2000);
    -- 'Acquisition Site' passes through the C01 massage column by Purchase_Order_Transfer_API.Send_Order_Change - 'ORDCHG'
    -- 'Acquisition Site' passes through the C02 massage column by Customer_Order_Transfer_API.Send_Order_Confirmation - 'ORDRSP'
    CURSOR get_acquisition_site(message_id_ VARCHAR2) IS
      SELECT C01, C02
      FROM intersite_data_transfer_tmp
      WHERE message_id = message_id_
      AND   name = 'HEADER';
BEGIN
   OPEN get_acquisition_site(message_id_);
   FETCH get_acquisition_site INTO c1_, c2_;
   CLOSE get_acquisition_site;
   
   IF (message_type_ = 'ORDCHG') THEN
      acquisition_site_ := c1_;
   END IF;
   IF (message_type_ = 'ORDRSP') THEN
      acquisition_site_ := c2_;
   END IF;
   RETURN acquisition_site_;
END Get_Acquisition_Site;