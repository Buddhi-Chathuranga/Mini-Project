/*=====================================================================================
 * PlsqlTokenId.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.Collection;
import java.util.EnumSet;
import java.util.Map;
import org.netbeans.api.lexer.Language;
import org.netbeans.api.lexer.TokenId;
import org.netbeans.spi.lexer.LanguageHierarchy;
import org.netbeans.spi.lexer.Lexer;
import org.netbeans.spi.lexer.LexerRestartInfo;

/**
 *
 * @author malolk
 */
public enum PlsqlTokenId implements TokenId {
    ERROR("error"),
    WHITESPACE("whitespace"),
    LINE_COMMENT("line_comment"),
    BLOCK_COMMENT("block_comment"),
    STRING_LITERAL("string-literal"),
    INCOMPLETE_STRING("incomplete-string-literal"),
    IDENTIFIER("identifier"),
    OPERATOR("operator"),
    INVALID_COMMENT_END("invalid-comment-end"),
    INT_LITERAL("int-literal"),
    DOUBLE_LITERAL("double-literal"),
    DOT("dot"),
    KEYWORD("keyword"),
    LPAREN("lparen"),
    RPAREN("rparen"),
    RBRACKET("rbracket"),
    LBRACKET("lbracket"),
    LBRACE("lbrace"),
    RBRACE("rbrace"),
    SQL_PLUS("sql-plus-command"),
    JAVA_SOUCE("java-source"),
    IGNORE_MARKER("ignore-marker");


    private String primaryCategory;

    private PlsqlTokenId(String primaryCategory) {
        this.primaryCategory = primaryCategory;
    }
    
    @Override
    public String primaryCategory() {
        return primaryCategory;
    }

    private static final Language<PlsqlTokenId> language = new LanguageHierarchy<PlsqlTokenId>() {

        @Override
        protected String mimeType() {
            return "text/x-plsql";
        }

        @Override
        protected Collection<PlsqlTokenId> createTokenIds() {
            return EnumSet.allOf(PlsqlTokenId.class);
        }
        
        @Override
        protected Map<String,Collection<PlsqlTokenId>> createTokenCategories() {
            return null;
        }

        @Override
        protected Lexer<PlsqlTokenId> createLexer(LexerRestartInfo<PlsqlTokenId> info) {
            return new PlsqlLexer(info);
        }

    }.language();

    public static Language<PlsqlTokenId> language() {
        return language;
    }

}