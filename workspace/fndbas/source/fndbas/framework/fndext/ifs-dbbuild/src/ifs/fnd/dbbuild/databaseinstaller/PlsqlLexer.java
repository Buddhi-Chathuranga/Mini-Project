/*=====================================================================================
 * PlsqlLexer.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.HashSet;
import java.util.StringTokenizer;
import org.netbeans.api.lexer.Token;
import org.netbeans.spi.lexer.Lexer;
import org.netbeans.spi.lexer.LexerInput;
import org.netbeans.spi.lexer.LexerRestartInfo;
import org.netbeans.spi.lexer.TokenFactory;

public class PlsqlLexer implements Lexer<PlsqlTokenId> {

   private static final int EOF = LexerInput.EOF;
   private LexerInput input;
   private TokenFactory<PlsqlTokenId> tokenFactory;
   private Token<PlsqlTokenId> lastToken = null;

   @Override
   public Object state() {
      return null;
   }

   public PlsqlLexer(LexerRestartInfo<PlsqlTokenId> info) {
      this.input = info.input();
      this.tokenFactory = info.tokenFactory();
   }

   @Override
   public Token<PlsqlTokenId> nextToken() {
      int c = '\n'; //Initially hope the best to be
      while (true) {
         int pre = c;
         c = input.read();
         switch (c) {
            case '_':
            case '&':
            case '$':
            case '#':
               return finishIdentifier();

            case '\t':
            case '\n':
            case 0x0b:
            case '\f':
            case '\r':
            case 0x1c:
            case 0x1d:
            case 0x1e:
            case 0x1f:
               return finishWhitespace();

            case ' ':
               c = input.read();
               if (c == EOF || !Character.isWhitespace(c)) { // Return single space as flyweight token
                  input.backup(1);
                  lastToken = tokenFactory.getFlyweightToken(PlsqlTokenId.WHITESPACE, " ");
                  return lastToken;
               }
               return finishWhitespace();

            case '(':
               return token(PlsqlTokenId.LPAREN);
            case ')':
               return token(PlsqlTokenId.RPAREN);
            case ']':
               return token(PlsqlTokenId.RBRACKET);
            case '[':
               return token(PlsqlTokenId.LBRACKET);
            case '{':
               return token(PlsqlTokenId.LBRACE);
            case '}':
               return token(PlsqlTokenId.RBRACE);

            case '=':
            case ':':
            case '>':
            case '<':
            case '+':
            case '|':
            case ',':
            case ';':
            case '%':
               return token(PlsqlTokenId.OPERATOR);

            case '*':
            case '!':
               return checkIdentifierOrOperator(pre);

            case '-':
               switch (input.read()) {
                  case '-': // in single-line comment
                     String line = readLine();
                     if (line.startsWith("@Ignore") || line.startsWith("@Approve") || line.startsWith("@Allow")) {
                        return token(PlsqlTokenId.IGNORE_MARKER);
                     } else {
                        return token(PlsqlTokenId.LINE_COMMENT);
                     }
                  default:
                     input.backup(1);
                     return token(PlsqlTokenId.OPERATOR);
               }

            case '/':
               switch (input.read()) {
                  case '*': // in block comment
                     return readBlockComment();
                  default:
                     input.backup(1);
                     return token(PlsqlTokenId.OPERATOR);
               }

            case 'a':
            case 'b':
            case 'c':
            case 'd':
            case 'e':
            case 'f':
            case 'g':
            case 'h':
            case 'i':
            case 'j':
            case 'k':
            case 'l':
            case 'm':
            case 'n':
            case 'o':
            case 'p':
            case 'r':
            case 's':
            case 't':
            case 'u':
            case 'v':
            case 'w':
            case 'x':
            case 'y':
            case 'z':
            case 'A':
            case 'B':
            case 'C':
            case 'D':
            case 'E':
            case 'F':
            case 'G':
            case 'H':
            case 'I':
            case 'J':
            case 'K':
            case 'L':
            case 'M':
            case 'N':
            case 'O':
            case 'P':
            case 'R':
            case 'S':
            case 'T':
            case 'U':
            case 'V':
            case 'W':
            case 'X':
            case 'Y':
            case 'Z':
               String word = getWordToken(c);
               return token(matchToken(word));

            case 'q':
            case 'Q':
                  if (input.read() == '\'') {
                     int delimiter = input.read();
                     while (true) {
                        int next = input.read();
                        if ((next == delimiter) ||
                                (delimiter == '<' && next == '>') ||
                                (delimiter == '(' && next == ')') ||
                                (delimiter == '{' && next == '}') ||
                                (delimiter == '[' && next == ']')) {
                           next = input.read();
                           if (next == '\'') {
                               //string
                              return token(PlsqlTokenId.STRING_LITERAL);
                           } else {
                              input.backup(1);
                           }
                        } else if (next == EOF) {
                              //Incomplete string
                             input.backup(1);
                              return token(PlsqlTokenId.INCOMPLETE_STRING);
                        }
                     }
                  } else {
                     String wordQ = getWordToken(c);
                     return token(matchToken(wordQ));
                  }

            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
               while (true) {
                  c = input.read();
                  switch (c) {
                     case '.':
                        if (checkDouble()) {
                           return token(PlsqlTokenId.DOUBLE_LITERAL);
                        } else {
                           //something like 788.  will return double for the moment
                           return token(PlsqlTokenId.DOUBLE_LITERAL);

                        }
                     case EOF:
                        return token(PlsqlTokenId.INT_LITERAL);
                     default:
                        if (!Character.isDigit(c)) {
                           input.backup(1);
                           return token(PlsqlTokenId.INT_LITERAL);
                        }
                  }
               }

            case '.':
               if (checkDouble()) {
                  return token(PlsqlTokenId.DOUBLE_LITERAL);
               } else {
                  return token(PlsqlTokenId.DOT);
               }

            case '\'':
               while (true) {
                  switch (input.read()) {
                     case '\'':
                        //string
                        return token(PlsqlTokenId.STRING_LITERAL);
                     case EOF:
                        //Incomplete string
                        input.backup(1);
                        return token(PlsqlTokenId.INCOMPLETE_STRING);
                  }
               }

            case '"':
               while (true) {
                  switch (input.read()) {
                     case '"':
                        //string
                        return token(PlsqlTokenId.STRING_LITERAL);
                     case EOF:
                        //Incomplete string
                        input.backup(1);
                        return token(PlsqlTokenId.INCOMPLETE_STRING);
                  }
               }

            case EOF:
               return null;

            default:
               if (c >= 0x80) { // lowSurr ones already handled above
                  c = translateSurrogates(c);
                  if (Character.isJavaIdentifierStart(c)) {
                     return finishIdentifier();
                  }
                  if (Character.isWhitespace(c)) {
                     return finishWhitespace();
                  }
               }

               // Invalid char
               return token(PlsqlTokenId.ERROR);
         }
      }
   }

   private PlsqlTokenId parseJavaSource() {
      int c = 0;
      String line = "";
      while (c != EOF) {
         c = input.read();
         if (c == '\n') {
            line = "";
         } else {
            line = line + (char) c;
         }

         if (c == '/') {
            String rest = readLine();
            line = line + rest;
            if (line.trim().equals("/")) {
               input.backup(1);
               return PlsqlTokenId.JAVA_SOUCE;
            }
         }
      }

      return PlsqlTokenId.JAVA_SOUCE;
   }

   /**
    * Method that will read block comments
    * @return
    */
   private Token<PlsqlTokenId> readBlockComment() {
      int c = 0;
      while (c != EOF) {
         c = input.read();
         if (c == '*') {
            switch (input.read()) {
               case '/': // in block comment
                  return token(PlsqlTokenId.BLOCK_COMMENT);
               default:
                  input.backup(1);
            }
         }
      }

      return token(PlsqlTokenId.INVALID_COMMENT_END);
   }

   /**
    * Method that will read through the comment line
    */
   private String readLine() {
      int c = 0;
      String line = "";
      while ((input.consumeNewline() == false) && (c != EOF)) {
         c = input.read();
         line = line + (char) c;
      }
      //get consumed \n
      if (c != EOF) {
         input.backup(1);
      }
      return line;
   }

   /**
    * Method that will check the end of the double literal
    * If the following character is not a digit will return the token as
    * dot 
    * @return true if double
    */
   private boolean checkDouble() {
      int ch = input.read();
      int count = 0;

      while (Character.isDigit(ch)) {
         ch = input.read();
         count++;
      }

      //we need to back up the last character that we read      
      input.backup(1);
      if (count > 0) {
         return true;
      } else {
         return false;
      }
   }

   /**
    * Check whether this is an identifier or operator
    * @param pre int
    * @return Token<PlsqlTokenId>
    */
   private Token<PlsqlTokenId> checkIdentifierOrOperator(int pre) {
      //We need to get the previous character of * or !
      if ((pre == '\t') || (pre == '\n') ||
              (pre == 0x0b) || (pre == '\f') ||
              (pre == '\r') || (pre == 0x1c) ||
              (pre == 0x1d) || (pre == 0x1e) ||
              (pre == 0x1f)) {
         int ch = input.read();
         if (!Character.isJavaIdentifierPart(ch)) {
            input.backup(1);
            return token(PlsqlTokenId.OPERATOR);
         } else {
            return finishIdentifier();
         }
      }
      return token(PlsqlTokenId.OPERATOR);
   }

   private int translateSurrogates(int c) {
      if (Character.isHighSurrogate((char) c)) {
         int lowSurr = input.read();
         if (lowSurr != EOF && Character.isLowSurrogate((char) lowSurr)) {
            // c and lowSurr form the integer unicode char.
            c = Character.toCodePoint((char) c, (char) lowSurr);
         } else {
            // Otherwise it's error: Low surrogate does not follow the high one.
            // Leave the original character unchanged.
            // As the surrogates do not belong to any
            // specific unicode category the lexer should finally
            // categorize them as a lexical error.
            input.backup(1);
         }
      }
      return c;
   }

   private Token<PlsqlTokenId> finishWhitespace() {
      while (true) {
         int c = input.read();
         // There should be no surrogates possible for whitespace
         // so do not call translateSurrogates()
         if (c == EOF || !Character.isWhitespace(c)) {
            input.backup(1);
            return token(PlsqlTokenId.WHITESPACE);
         }
      }
   }

   private Token<PlsqlTokenId> finishIdentifier() {
      return finishIdentifier(input.read());
   }

   private Token<PlsqlTokenId> finishIdentifier(int c) {
      while (true) {
         if (c == EOF || !Character.isJavaIdentifierPart(c = translateSurrogates(c))) {
            // For surrogate 2 chars must be backed up
            input.backup((c >= Character.MIN_SUPPLEMENTARY_CODE_POINT) ? 2 : 1);
            return token(PlsqlTokenId.IDENTIFIER);
         }
         c = input.read();
      }
   }

   private Token<PlsqlTokenId> token(PlsqlTokenId id) {
      Token<PlsqlTokenId> t = tokenFactory.createToken(id);
      lastToken = t;
      return t;
   }

   @Override
   public void release() {
   }
   /**
    * A hashset of keywords
    */
   private static HashSet<String> keywords = new HashSet<>();
   private static HashSet<String> sqlPlus = new HashSet<>();

   static {
      populateKeywords();
      populateSQLPlus();
   }

   /**
    * populates the hashset of keywords from the property in the
    * resource bundle
    */
   private static void populateKeywords() {
      String fullList = DbInstallerUtil.getListPlSqlKeywords();
      StringTokenizer st = new StringTokenizer(fullList, ","); // NOI18N
      while (st.hasMoreTokens()) {
         String token = st.nextToken();
         token = token.toUpperCase().trim();

         if (!keywords.contains(token)) {
            keywords.add(token);
         }
      }
   }

   /**
    * populates the hashset of keywords from the property in the resource bundle
    */
   private static void populateSQLPlus() {
      String fullList = DbInstallerUtil.getListSqlPlus();
      StringTokenizer st = new StringTokenizer(fullList, ","); // NOI18N
      while (st.hasMoreTokens()) {
         String token = st.nextToken();
         token = token.toUpperCase().trim();

         if (!sqlPlus.contains(token)) {
            sqlPlus.add(token);
         }
      }
   }

   /**
    * Tries to match the specified sequence of characters to a Plsql keyword.
    * @param candidate String
    * @return PlsqlTokenId
    */
   private PlsqlTokenId matchToken(String candidate) {
      candidate = candidate.toUpperCase();

      if (keywords.contains(candidate)) {
         if (candidate.equalsIgnoreCase("JAVA")) {
            int c = input.read();
            String word = getWordToken(c);
            if (word.trim().equalsIgnoreCase("SOURCE")) {
               return parseJavaSource();
            } else {
               input.backup(word.length());
            }
         }
         return PlsqlTokenId.KEYWORD;
      } else if (sqlPlus.contains(candidate)) {
         if (lastToken == null || lastToken.text() == null || lastToken.toString().contains("\n")) {
            if (candidate.equalsIgnoreCase("EXECUTE")) {
               int c = input.read();
               String word = getWordToken(c);
               if (word.trim().equalsIgnoreCase("IMMEDIATE")) {
                  input.backup(word.length());
                  return PlsqlTokenId.KEYWORD;
               }
               input.backup(word.length()); //If line break is before the next word
            } else if (candidate.equalsIgnoreCase("PROMPT")) {
                readLine();
            }
            return PlsqlTokenId.SQL_PLUS;
         } else {
            return PlsqlTokenId.KEYWORD;
         }
      } else if (candidate.equalsIgnoreCase("REM")) {
         //REM is a line comment
         readLine();
         return PlsqlTokenId.LINE_COMMENT;
      }

      return PlsqlTokenId.IDENTIFIER;
   }

   /**
    * Return character stream containing 'a-z' 'A-Z' '_'
    * @param c int
    * @return String
    */
   private String getWordToken(int c) {
      String word;
      word = Character.toString((char) c);
      int ch = input.read();

      while ((Character.isLetter(ch)) || (Character.isDigit(ch)) || (ch == '_') ||
              (ch == '$') || (ch == '&') || (ch == '#')) {
         word = word + Character.toString((char) ch);
         ch = input.read();
      }

      //we need to back up the last character that we read      
      input.backup(1);
      return word;
   }
}
