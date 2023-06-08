/*=====================================================================================
 * PlsqlBlockFactory.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import javax.swing.text.Document;
import org.netbeans.api.lexer.Token;
import org.netbeans.api.lexer.TokenHierarchy;
import org.netbeans.api.lexer.TokenSequence;

/**
 * Class that will maintain code blocks of the file.
 * @author MaBose
 */
public class PlsqlBlockFactory {

    private List<PlsqlBlock> blockHierarchy;
    private HashMap<String, String> definesMap;
    private TokenHierarchy tokenHierarchy;
    private int docStartOffset = 0;
    private int docEndOffset = 0;
    private int startParse = 0;
    private int endParse = 0;

    public PlsqlBlockFactory() {
        blockHierarchy = new ArrayList<>();
        tokenHierarchy = null;
        definesMap = new HashMap<>();
    }

    /**
     * Method used to re-parse the whole document
     * @param doc Document
     */
    public void reParse(Document doc) {
        clear();

        if (doc == null) {
            return;
        }

        docStartOffset = doc.getStartPosition().getOffset();
        docEndOffset = doc.getEndPosition().getOffset();
        startParse = docStartOffset;
        endParse = docEndOffset - 1;

        //clean block hierarchy
        blockHierarchy.clear();
        generateBlocks(doc);
    }

    /**
     * Return block hierarchy
     * @return
     */
    public List<PlsqlBlock> getBlockHierarchy() {
        return blockHierarchy;
    }

    /**
     * Check whether there are children of this fold here, if so add them
     * @param block
     * @param immediateBlockHier
     */
    private void addImmediateChildren(PlsqlBlock block, List<PlsqlBlock> immediateBlockHier) {
        for (int i = immediateBlockHier.size() - 1; i >= 0; i--) {
            PlsqlBlock tmp = immediateBlockHier.get(i);
            if ((tmp.getStartOffset() > block.getStartOffset())
                    && (tmp.getEndOffset() < block.getEndOffset())) {
                block.addChild(tmp);
            }
        }
    }

    /**
     * Method that will check for a Java Source block
     * @param tempToken
     * @param ts
     * @param immediateBlockHier
     * @return
     */
    private PlsqlBlock checkJavaSource(Token<PlsqlTokenId> tempToken, TokenSequence<PlsqlTokenId> ts) {
        Token<PlsqlTokenId> begin = tempToken;
        Token<PlsqlTokenId> tmp;
        PlsqlBlock block = null;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        while (ts.moveNext()) {
            tmp = ts.token();
            String image = tmp.text().toString();
            PlsqlTokenId tokenID = tmp.id();

            if ((tmp != null) && (!"/".equals(image)) && (tmp.offset(tokenHierarchy) > endParse)) {
                break;
            }

            //We might have come to the end of the procedure/function declaration
            if ((tokenID == PlsqlTokenId.OPERATOR) && "/".equals(image)) {
                //check whether previous Non white space token to the identifier is END
                int offset = ts.offset();
                if (checkForOnlyChar(ts, offset)) {
                    ts.move(offset);
                    ts.moveNext();
                    ts.moveNext();
                    block = new PlsqlBlock(begin.offset(tokenHierarchy), offset, "", "", PlsqlBlockType.JAVA_SOURCE);
                    checkPrefix(begin.offset(tokenHierarchy), ts, block);
                    break;
                }
            }
        }
        return block;
    }

    /**
     * Check whether this current token is the only token in this line
     * @param ts
     * @param offset
     * @return
     */
    private boolean checkForOnlyChar(TokenSequence<PlsqlTokenId> ts, int offset) {
        boolean isStartOk = true;
        boolean isEndOk = true;
        ts.move(offset);
        Token<PlsqlTokenId> token;
        while (ts.movePrevious()) {
            token = ts.token();
            if (token.id() == PlsqlTokenId.WHITESPACE) {
                if (token.toString().contains("\n")) {
                    break;
                }
            } else if (token.id() == PlsqlTokenId.JAVA_SOUCE) {
                break;
            } else {
                isStartOk = false;
                break;
            }
        }

        ts.move(offset);
        ts.moveNext(); //current token
        while (ts.moveNext()) {
            token = ts.token();
            if (token.id() == PlsqlTokenId.WHITESPACE) {
                if (token.toString().contains("\n")) {
                    break;
                }
            } else {
                isEndOk = false;
                break;
            }
        }

        ts.move(offset);
        ts.moveNext();

        if (isStartOk && isEndOk) {
            return true;
        }
        return false;
    }

    /**
     * Method that will check for statement blocks other than the CURSOR and VIEW
     * @param tempToken
     * @param ts
     * @param immediateBlockHier
     * @return
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkStatementBlock(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> stmtBegin;
        Token<PlsqlTokenId> token;
        List<PlsqlBlock> lstChild = new ArrayList<>();
        PlsqlBlock block = null;
        boolean moveNext;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        moveNext = ts.moveNext();
        token = ts.token();
        stmtBegin = current;
        boolean getName = true;
        String name = current.text().toString();

        while (moveNext) {
            String image = token.text().toString();
            PlsqlTokenId tokenID = token.id();
            if ((token != null) && (!";".equals(image)) && (!"/".equals(image)) && (token.offset(tokenHierarchy) > endParse)) {
                break;
            }

            if (";".equals(image) || ("/".equals(image) && checkForOnlyChar(ts, ts.offset()))) {
                block = new PlsqlBlock(stmtBegin.offset(tokenHierarchy), token.offset(tokenHierarchy), name.trim(), "", PlsqlBlockType.STATEMENT);
                checkPrefix(stmtBegin.offset(tokenHierarchy), ts, block);
                break;
            } else if (image.equalsIgnoreCase("CREATE")
                    || image.equalsIgnoreCase("DECLARE")
                    || image.equalsIgnoreCase("BEGIN")
                    || (image.equalsIgnoreCase("WHEN") && !name.equalsIgnoreCase("MERGE"))
                    || (image.equalsIgnoreCase("THEN") && !name.equalsIgnoreCase("MERGE"))
                    || image.equalsIgnoreCase("IF")
                    || image.equalsIgnoreCase("END")
                    || image.equalsIgnoreCase("ELSE")
                    || image.equalsIgnoreCase("LOOP")) {
                break;
            } else if (image.equalsIgnoreCase("CASE")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkCaseBlock(token, ts, lstChild, true);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(token, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = token.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + token.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.WHITESPACE && image.contains("\n")) {
                getName = false;
            } else if (getName) {
                name = name + image;
            }

            moveNext = ts.moveNext();
            token = ts.token();
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);
        }

        return block;
    }

    /**
     * Method that will look for trigger blocks
     * @param tiggerToken Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkTrigger(Token<PlsqlTokenId> tiggerToken, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> triggerBegin = tiggerToken;
        Token<PlsqlTokenId> tmp;
        PlsqlBlock block = null;
        List<PlsqlBlock> lstChild = new ArrayList<>();

        String triggerName;
        boolean moveNext;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        //Get procedure/function name which is the next non whitespace token
        moveNext = getNextNonWhitespace(ts, true);
        tmp = ts.token();
        if (moveNext == false) {
            return block;
        }

        triggerName = tmp.text().toString();
        triggerName = checkForOtherSchema(ts, triggerName);
        String alias = "";
        if (triggerName.indexOf('&') != -1) {
            alias = triggerName;
        }
        triggerName = getDefine(triggerName);

        while (moveNext) {
            String image = tmp.text().toString();
            PlsqlTokenId tokenID = tmp.id();

            if ((tmp != null) && (!";".equals(image)) && (tmp.offset(tokenHierarchy) > endParse)) {
                break;
            }

            //We might have come to the end of the procedure/function declaration
            if ((tokenID == PlsqlTokenId.OPERATOR) && ";".equals(image)) {
                //check whether previous Non white space token to the identifier is END
                int offset = ts.offset();
                getPreviousNonWhitespace(ts, true);
                Token<PlsqlTokenId> previousNWS = ts.token();
                String prevText = previousNWS.text().toString();
                getPreviousNonWhitespace(ts, true);
                previousNWS = ts.token();
                if ("".equals(alias)) {
                    if ((prevText.equalsIgnoreCase(triggerName)
                            && previousNWS.text().toString().equalsIgnoreCase("END"))
                            || prevText.equalsIgnoreCase("END")) {
                        ts.move(offset);
                        moveNext = ts.moveNext();
                        moveNext = ts.moveNext();
                        block = new PlsqlBlock(triggerBegin.offset(tokenHierarchy),
                                ts.offset(), triggerName, alias, PlsqlBlockType.TRIGGER);
                        checkPrefix(triggerBegin.offset(tokenHierarchy), ts, block);
                        break;
                    }
                } else {
                    if ((prevText.equalsIgnoreCase(alias)
                            && previousNWS.text().toString().equalsIgnoreCase("END"))
                            || prevText.equalsIgnoreCase("END")) {
                        ts.move(offset);
                        moveNext = ts.moveNext();
                        moveNext = ts.moveNext();
                        block = new PlsqlBlock(triggerBegin.offset(tokenHierarchy),
                                ts.offset(), triggerName, alias, PlsqlBlockType.TRIGGER);
                        checkPrefix(triggerBegin.offset(tokenHierarchy), ts, block);
                        break;
                    }
                }
                ts.move(offset);
                moveNext = ts.moveNext();
            } else if (image.equalsIgnoreCase("TABLE")
                    || image.equalsIgnoreCase("INDEX")
                    || image.equalsIgnoreCase("SELECT")
                    || image.equalsIgnoreCase("UPDATE")
                    || image.equalsIgnoreCase("DELETE")
                    || image.equalsIgnoreCase("INSERT")
                    || image.equalsIgnoreCase("DROP")
                    || image.equalsIgnoreCase("SEQUENCE")) {
                if (!isNotBlockStart(tmp, ts)) {
                    int offset = tmp.offset(tokenHierarchy);
                    PlsqlBlock child = checkStatementBlock(tmp, ts, parentBlocks);
                    if (child == null) {//If inner check seems to have failed need to continue this one

                        ts.move(offset);
                        ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("PROCEDURE")) {
                int beforeOff = tmp.offset(tokenHierarchy);
                PlsqlBlock child = checkMethod(tmp, ts, PlsqlBlockType.PROCEDURE_IMPL, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } //Inner procedure
            else if (image.equalsIgnoreCase("FUNCTION")) {
                int beforeOff = tmp.offset(tokenHierarchy);
                PlsqlBlock child = checkMethod(tmp, ts, PlsqlBlockType.FUNCTION_IMPL, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("/")
                    || image.equalsIgnoreCase("PACKAGE")) {
                break;
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(tmp, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = tmp.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + tmp.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            }

            moveNext = ts.moveNext();
            tmp = ts.token();
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);
        }

        return block;
    }

    /**
     * Method that will check the prefix of the given block and change the block values accordingly
     * @param startOffset in 
     * @param ts TokenSequence<PlsqlTokenId>
     * @param block PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private void checkPrefix(int startOffset, TokenSequence<PlsqlTokenId> ts, PlsqlBlock block) {
        String prefix = "";
        int offset = ts.offset();
        ts.move(startOffset);
        ts.moveNext();
        Token<PlsqlTokenId> token = ts.token();
        int beginOffset = startOffset;

        while (ts.movePrevious()) {
            token = ts.token();
            String image = token.text().toString();

            if (image.contains("\n") || (token.id() != PlsqlTokenId.KEYWORD && token.id() != PlsqlTokenId.WHITESPACE)) {
                break;
            }

            prefix = token.text().toString() + prefix;
            if (token.id() != PlsqlTokenId.WHITESPACE) {
                beginOffset = ts.offset();
            }
        }

        ts.move(offset);
        ts.moveNext();
        block.setStartOffset(beginOffset);
        block.setPrefix(prefix);
    }

    /**
     * Check whether there is a block existing with the given offset as the start offset
     * @param blockHierarchy List<PlsqlBlock>
     * @param offset int
     * @return
     */
    private boolean isBlockStartExisting(List<PlsqlBlock> blockHierarchy, int offset) {
        boolean isExisting = false;
        for (int i = blockHierarchy.size() - 1; i >= 0; i--) {
            PlsqlBlock tmp = blockHierarchy.get(i);
            if (tmp.getStartOffset() == offset) {
                isExisting = true;
                break;
            }

            if (!isExisting) {
                if (isBlockStartExisting(tmp.getChildBlocks(), offset)) {
                    isExisting = true;
                    break;
                }
            }
        }

        return isExisting;
    }

    private boolean isEqual(PlsqlBlock parent, PlsqlBlock block) {
        if ((parent == null) || (block == null)) {
            return false;
        }

        if ((parent.getStartOffset() == block.getStartOffset())
                || (parent.getEndOffset() == block.getEndOffset())
                || (parent.getName().equalsIgnoreCase(block.getName()))) {
            return true;
        }
        return false;
    }

    private String readLine(TokenSequence<PlsqlTokenId> ts, Token<PlsqlTokenId> token) {
        String line = token.toString();
        while (ts.moveNext()) {
            token = ts.token();
            if (token.id() == PlsqlTokenId.WHITESPACE && token.text().toString().contains("\n")) {
                ts.movePrevious();
                break;
            }

            line = line + token.toString();
        }

        return line;
    }

    /**
     * Method that will remove the begin block of this declare block if there
     * @param declareBlock PlsqlBlock
     */
    private void removeChildBegin(PlsqlBlock declareBlock) {
        //can check from the root hierarchies since begin/declare cannot be child blocks
        for (int i = blockHierarchy.size() - 1; i >= 0; i--) {
            PlsqlBlock tmp = blockHierarchy.get(i);
            if ((tmp.getStartOffset() > declareBlock.getStartOffset())
                    && (tmp.getEndOffset() == declareBlock.getEndOffset())
                    && (tmp.getType() == PlsqlBlockType.BEGIN_END)) {
                blockHierarchy.remove(tmp);
            }
        }
    }

    /**
     * Method that will make CURSOR blocks
     * @param current Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    private PlsqlBlock checkCursor(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> cursorBegin = current;
        Token<PlsqlTokenId> tmp;
        Token<PlsqlTokenId> cursorEnd = null;
        PlsqlBlock block = null;
        List<PlsqlBlock> lstChild = new ArrayList<>();
        boolean moveNext;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        //Get next token which is the name
        int offset = ts.offset();
        moveNext = getNextNonWhitespace(ts, false);
        tmp = ts.token();
        if (moveNext == false) {
            ts.move(offset);
            ts.moveNext();
            return block;
        }
        String cursorName = tmp.text().toString();
        String alias = "";
        if (cursorName.indexOf('&') != -1) {
            alias = cursorName;
        }
        cursorName = getDefine(cursorName);

        //Next token has to be IS or ( if not leave
        moveNext = getNextNonWhitespace(ts, false);
        tmp = ts.token();
        boolean isFound = false;
        boolean parameter = false;

        while (moveNext) {
            PlsqlTokenId tokenID = tmp.id();
            String image = tmp.text().toString();

            if ((tmp != null) && (!";".equals(image)) && (tmp.offset(tokenHierarchy) > endParse)) {
                break;
            }

            //When we have come up to ';' stop
            if ((tokenID == PlsqlTokenId.OPERATOR) && (";".equals(image))) {
                if (isFound) {
                    if (ts.moveNext()) {
                        tmp = ts.token();
                    }
                    cursorEnd = tmp;
                    break;
                } else {
                    ts.move(offset);
                    ts.moveNext();
                    return null;
                }
            } else if ((tokenID == PlsqlTokenId.LPAREN) && (!isFound)) {
                parameter = true;
            } else if ((tokenID == PlsqlTokenId.RPAREN) && (!isFound)) {
                parameter = false;
            } else if (tokenID == PlsqlTokenId.KEYWORD) {
                if (image.equalsIgnoreCase("IS")) {
                    isFound = true;
                } else if ((!parameter) && //If this keyword is a parameter inside cursor ignore
                        ((image.equalsIgnoreCase("SUBTYPE"))
                        || (image.equalsIgnoreCase("CONSTANT"))
                        || (image.equalsIgnoreCase("NUMBER"))
                        || (image.equalsIgnoreCase("VARCHAR2")))) { //Avoid catching ';' of other statements

                    return null;
                } else if ((image.equalsIgnoreCase("VIEW"))
                        || (image.equalsIgnoreCase("PROCEDURE"))
                        || (image.equalsIgnoreCase("FUNCTION"))
                        || (image.equalsIgnoreCase("BEGIN"))
                        || (image.equalsIgnoreCase("DECLARE"))
                        || (image.equalsIgnoreCase("CREATE"))
                        || (image.equalsIgnoreCase("CURSOR"))
                        || (image.equalsIgnoreCase("EXCEPTION"))
                        || (image.equalsIgnoreCase("PRAGMA"))
                        || (image.equalsIgnoreCase("END"))
                        || (image.equalsIgnoreCase("COMMENT"))) { //Avoid catching ';' of other statements

                    return null;
                }
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(tmp, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = tmp.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + tmp.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            }

            moveNext = ts.moveNext();
            tmp = ts.token();
        }

        if (cursorEnd != null) {
            block = new PlsqlBlock(cursorBegin.offset(tokenHierarchy), ts.offset(),
                    cursorName, alias, PlsqlBlockType.CURSOR);
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);
        }

        return block;
    }

    /**
     * Check whether we have caught a begin of a declare block
     * @param ts TokenSequence<PlsqlTokenId>
     * @param immediate List<PlsqlBlock>
     * @return boolean
     */
    @SuppressWarnings("UnusedAssignment")
    private boolean isDeclare(TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> immediate) {
        int offset = ts.offset();
        Token<PlsqlTokenId> token = ts.token();
        Token<PlsqlTokenId> tokenPre = ts.token();

        while (ts.movePrevious()) {
            token = ts.token();
            String image = token.text().toString();
            if (image.equalsIgnoreCase("DECLARE") && (!isBlockStartExisting(immediate, ts.offset()))) {
                PlsqlBlock block = checkDeclareBlock(token, ts, immediate);
                if (block != null && (checkExisting(block, immediate) == false)) {//If inner check seems to have failed need to continue this one
                    immediate.add(block);
                } else {
                    //Since we have not found the block we have to avoid getting caught up in a loop
                    ts.move(offset);
                    ts.moveNext();
                }
                return true;
            } else if (("/".equals(image)) || ("BEGIN".equalsIgnoreCase(image))
                    || (("END".equalsIgnoreCase(image)) && (tokenPre.text().toString().equals(";")))) {
                break;
            }

            if ((token.id() != PlsqlTokenId.WHITESPACE)
                    && (token.id() != PlsqlTokenId.LINE_COMMENT)
                    && (token.id() != PlsqlTokenId.BLOCK_COMMENT)) {
                tokenPre = token;
            }
        }

        ts.move(offset);
        ts.moveNext();
        return false;
    }

    /**
     * Check whether the given block is already there in block hierachy
     * @param block PlsqlBlock
     * @param childList List<PlsqlBlock>
     * @return boolean
     */
    private boolean checkExisting(PlsqlBlock block, List<PlsqlBlock> childList) {
        boolean existing = false;
        int count = childList.size();
        for (int i = 0; i < count; i++) {
            PlsqlBlock tmp = childList.get(i);
            if ((tmp.getName().equals(block.getName()) && tmp.getEndOffset() == block.getEndOffset())
                    || (tmp.getName().equals(block.getName()) && tmp.getStartOffset() == block.getStartOffset())
                    || (tmp.getEndOffset() == block.getEndOffset() && tmp.getStartOffset() == block.getStartOffset())) {
                existing = true;
                break;
            }
        }

        return existing;
    }

    /**
     * Clear internal variables used in a parse
     */
    private void clear() {
        startParse = 0;
        endParse = 0;
        resetPreviousValues(blockHierarchy);
    }

    private void resetPreviousValues(List<PlsqlBlock> blockList) {
        for (PlsqlBlock block : blockList) {
            block.setPreviousStart(-1);
            block.setPreviousEnd(-1);
            resetPreviousValues(block.getChildBlocks());
        }
    }

    private String checkForOtherSchema(TokenSequence<PlsqlTokenId> ts, String currentName) {
        int offset = ts.offset();
        if (ts.moveNext()) {
            Token<PlsqlTokenId> token = ts.token();
            if (token.id() == PlsqlTokenId.DOT) {
                if (ts.moveNext()) {
                    token = ts.token();
                    if (token.id() == PlsqlTokenId.DOT) {
                        if (ts.moveNext()) {
                            return ts.token().toString();
                        }
                    } else {
                        return ts.token().toString();
                    }
                }
            }
        }

        //Reset the original location
        ts.move(offset);
        ts.moveNext();

        return currentName;
    }

    /**
     * Update block hierarchy on a document event
     * @param doc Document
     */
    public synchronized void initHierarchy(Document doc) {
        clear();

        if (doc == null) {
            return;
        }

        docStartOffset = doc.getStartPosition().getOffset();
        docEndOffset = doc.getEndPosition().getOffset();
        Object obj = doc.getProperty("Listener");

        if ((obj == null) || (!obj.equals("YES"))) {
            startParse = docStartOffset;
            endParse = docEndOffset - 1;

            //clean block hierarchy
            blockHierarchy.clear();
            getAliases(doc);
            generateBlocks(doc);
            //This property is added only to ensure that document listener is added only once
            doc.putProperty("Listener", "YES");
        }
    }

    /**
     * Method that will return the block within the start & end parse
     * @param start
     * @param end
     * @return
     */
    private PlsqlBlock getParentBlock(List<PlsqlBlock> lstBlock, int start, int end) {
        PlsqlBlock parent = null;
        int count = lstBlock.size();
        for (int i = 0; i < count; i++) {
            PlsqlBlock tmp = lstBlock.get(i);
            if ((tmp.getStartOffset() < start) && (tmp.getEndOffset() > end)) {
                PlsqlBlock child = getParentBlock(tmp.getChildBlocks(), start, end);
                if (child != null) {
                    parent = child;
                } else {
                    parent = tmp;
                }

                break;
            }
        }

        return parent;
    }

    private boolean isNotBlockStart(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts) {
        boolean isNotBlockStart = false;
        int offset = current.offset(tokenHierarchy);
        Token<PlsqlTokenId> token = current;
        Token<PlsqlTokenId> tokenPre = current;
        int loopCount = 0;
        while (ts.movePrevious()) {
            token = ts.token();

            if (loopCount == 0 && token.id() == PlsqlTokenId.DOT) {
                isNotBlockStart = true;
                break;
            } else if (token.id() == PlsqlTokenId.WHITESPACE) {
                String preText = tokenPre.text().toString();
                if (token.text().toString().contains("\n")) {
                    if (preText.equalsIgnoreCase("TYPE")
                            || preText.equalsIgnoreCase("GRANT")) {
                        isNotBlockStart = true;
                    }
                    break;
                }
            } else if (token.text().toString().equalsIgnoreCase("TYPE")) {
                isNotBlockStart = true;
                break;
            } else {
                tokenPre = token;
            }
            loopCount++;
        }

        if (token.text().toString().equalsIgnoreCase("TYPE")
                || token.text().toString().equalsIgnoreCase("GRANT")) {
            isNotBlockStart = true;
        }

        ts.move(offset);
        ts.moveNext();
        return isNotBlockStart;
    }

    /**
     * If given block exists in the hierarchy delete
     * @param child PlsqlBlock
     * @param parentBlocks List<PlsqlBlock>
     */
    private void removeFromParent(PlsqlBlock child, List<PlsqlBlock> parentBlocks) {
        for (int i = 0; i < parentBlocks.size(); i++) {
            PlsqlBlock tmp = parentBlocks.get(i);
            if ((tmp.getEndOffset() == child.getEndOffset())
                    && (tmp.getStartOffset() == child.getStartOffset())) {
                parentBlocks.remove(tmp);
                break;
            }
        }
    }

    private boolean sqlPlusLine(TokenSequence<PlsqlTokenId> ts) {
        int offset = ts.offset();
        boolean isSqlPlus = false;
        Token<PlsqlTokenId> token;
        Token<PlsqlTokenId> tokenPre = null;
        while (ts.movePrevious()) {
            token = ts.token();
            if (token.id() == PlsqlTokenId.WHITESPACE && token.toString().contains("\n")) {
                if (tokenPre != null && tokenPre.id() == PlsqlTokenId.SQL_PLUS) {
                    isSqlPlus = true;
                }
                break;
            }

            if (token.id() != PlsqlTokenId.WHITESPACE) {
                tokenPre = token;
            }
        }
        if (tokenPre != null && tokenPre.id() == PlsqlTokenId.SQL_PLUS) {
            isSqlPlus = true;
        }

        ts.move(offset);
        ts.moveNext();
        return isSqlPlus;
    }

    /**
     * Method that will generate blocks of the given offset range
     * @param doc Document
     */
    private synchronized void generateBlocks(Document doc) {
        List<PlsqlBlock> immediateBlockHier;
        tokenHierarchy = TokenHierarchy.get(doc);
        @SuppressWarnings("unchecked")
        TokenSequence<PlsqlTokenId> ts = tokenHierarchy.tokenSequence(PlsqlTokenId.language());

        PlsqlBlock parent = getParentBlock(blockHierarchy, startParse, endParse);
        if (parent != null) {
            immediateBlockHier = parent.getChildBlocks();
        } else {
            immediateBlockHier = blockHierarchy;
        }

        if (ts != null) {
            //move offset
            ts.move(startParse);
            Token<PlsqlTokenId> tempToken;

            //Go through all the available tokens
            while (ts.moveNext()) {
                tempToken = ts.token();
                PlsqlTokenId tokenID = tempToken.id();
                String image = tempToken.text().toString();

                //Check end offset and break (exception for semicolon which will mark end of some blocks)
                if ((tempToken != null) && (!";".equals(image)) && (tempToken.offset(tokenHierarchy) > endParse)) {
                    break;
                }
                if (tokenID == PlsqlTokenId.KEYWORD) {
                    if (image.equalsIgnoreCase("VIEW")) {
                        int offset = ts.offset();
                        PlsqlBlock block;
                        block = checkView(tempToken, ts, immediateBlockHier);
                        if (block == null) {
                            //pass from the immediate next token to get inner blocks
                            ts.move(offset);
                            ts.moveNext();
                        } else {
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("FUNCTION")) {
                        int offset = ts.offset();
                        PlsqlBlock block;
                        block = checkMethod(tempToken, ts, PlsqlBlockType.FUNCTION_IMPL, immediateBlockHier);
                        if (block == null) {
                            //pass from the immediate next token to get inner blocks
                            ts.move(offset);
                            ts.moveNext();
                        } else {
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("PROCEDURE")) {
                        int offset = ts.offset();
                        PlsqlBlock block;
                        block = checkMethod(tempToken, ts, PlsqlBlockType.PROCEDURE_IMPL, immediateBlockHier);
                        if (block == null) {
                            //pass from the immediate next token to get inner blocks
                            ts.move(offset);
                            ts.moveNext();
                        } else {
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("PACKAGE")) {
                        int offset = ts.offset();
                        PlsqlBlock block;
                        block = checkPackage(tempToken, ts, immediateBlockHier);
                        if (block == null) {
                            //pass from the immediate next token to get inner blocks
                            ts.move(offset);
                            ts.moveNext();
                        } else {
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("TYPE")) {
                        int offset = ts.offset();
                        PlsqlBlock block;
                        block = checkType(tempToken, ts, immediateBlockHier);
                        if (block == null) {
                            //pass from the immediate next token to get inner blocks
                            ts.move(offset);
                            ts.moveNext();
                        } else {
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("CURSOR")) {
                        int offset = ts.offset();
                        PlsqlBlock block;
                        block = checkCursor(tempToken, ts, immediateBlockHier);
                        if (block == null) {
                            //pass from the immediate next token to get inner blocks
                            ts.move(offset);
                            ts.moveNext();
                        } else {
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("TRIGGER")) {
                        int offset = ts.offset();
                        PlsqlBlock block;
                        block = checkTrigger(tempToken, ts, immediateBlockHier);
                        if (block == null) {
                            //pass from the immediate next token to get inner blocks
                            ts.move(offset);
                            ts.moveNext();
                        } else {
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("COMMENT")) {
                        int offset = ts.offset();
                        PlsqlBlock block;
                        block = checkTblColComment(tempToken, ts, immediateBlockHier);
                        if (block == null) {
                            //pass from the immediate next token to get inner blocks
                            ts.move(offset);
                            ts.moveNext();
                        } else {
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("DECLARE")) {
                        PlsqlBlock block = checkDeclareBlock(tempToken, ts, immediateBlockHier);
                        if (block != null) {//If inner check seems to have failed need to continue this one
                            checkAndAddNew(block, parent, immediateBlockHier);
                        }
                    } else if (image.equalsIgnoreCase("BEGIN")) {
                        if (!isDeclare(ts, immediateBlockHier)) {//We need to check whether the declare is isolated by a CURSOR block

                            int offset = ts.offset();
                            PlsqlBlock block = checkBeginBlock(tempToken, ts, immediateBlockHier);
                            if (block == null) {//If inner check seems to have failed need to continue this one

                                ts.move(offset);
                                ts.moveNext();
                            } else {
                                checkAndAddNew(block, parent, immediateBlockHier);
                            }
                        }
                    } else if (image.equalsIgnoreCase("IF")
                            || image.equalsIgnoreCase("ELSIF")) {
                        if (!isNotBlockStart(tempToken, ts)) {
                            int offset = tempToken.offset(tokenHierarchy);
                            List children = checkIfBlock(tempToken, ts, immediateBlockHier);
                            if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one
                                ts.move(offset);
                                ts.moveNext();
                            } else {
                                for (int i = 0; i < children.size(); i++) {
                                    PlsqlBlock child = (PlsqlBlock) children.get(i);
                                    checkAndAddNew(child, parent, immediateBlockHier);
                                }
                            }
                        }
                    } else if (image.equalsIgnoreCase("ELSE")) {
                        if (!isNotBlockStart(tempToken, ts)) {
                            int offset = tempToken.offset(tokenHierarchy);
                            List children = checkIfBlock(tempToken, ts, immediateBlockHier);
                            if (children == null || children.isEmpty()) {
                                children = checkCaseBlock(tempToken, ts, immediateBlockHier, false);
                            }

                            if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                                ts.move(offset);
                                ts.moveNext();
                            } else {
                                for (int i = 0; i < children.size(); i++) {
                                    PlsqlBlock child = (PlsqlBlock) children.get(i);
                                    checkAndAddNew(child, parent, immediateBlockHier);
                                }
                            }
                        }
                    } else if (image.equalsIgnoreCase("CASE")
                            || image.equalsIgnoreCase("WHEN")) {
                        if (!isNotBlockStart(tempToken, ts)) {
                            int offset = tempToken.offset(tokenHierarchy);
                            List children = checkCaseBlock(tempToken, ts, immediateBlockHier, false);
                            if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                                ts.move(offset);
                                ts.moveNext();
                            } else {
                                for (int i = 0; i < children.size(); i++) {
                                    PlsqlBlock child = (PlsqlBlock) children.get(i);
                                    checkAndAddNew(child, parent, immediateBlockHier);
                                }
                            }
                        }
                    } else if (image.equalsIgnoreCase("LOOP")
                            || image.equalsIgnoreCase("WHILE")
                            || image.equalsIgnoreCase("FOR")) {
                        if (!isNotBlockStart(tempToken, ts)) {
                            int offset = tempToken.offset(tokenHierarchy);
                            PlsqlBlock child = checkLoopBlock(tempToken, ts, immediateBlockHier);
                            if (child == null) {//If inner check seems to have failed need to continue this one
                                ts.move(offset);
                                ts.moveNext();
                            } else {
                                checkAndAddNew(child, parent, immediateBlockHier);
                            }
                        }
                    } else if (image.equalsIgnoreCase("TABLE")
                            || image.equalsIgnoreCase("INDEX")
                            || image.equalsIgnoreCase("SELECT")
                            || image.equalsIgnoreCase("UPDATE")
                            || image.equalsIgnoreCase("DELETE")
                            || image.equalsIgnoreCase("INSERT")
                            || image.equalsIgnoreCase("MERGE")
                            || image.equalsIgnoreCase("DROP")
                            || image.equalsIgnoreCase("SEQUENCE")) {
                        if (!isNotBlockStart(tempToken, ts)) {
                            int offset = tempToken.offset(tokenHierarchy);
                            PlsqlBlock child = checkStatementBlock(tempToken, ts, immediateBlockHier);
                            if (child == null) {//If inner check seems to have failed need to continue this one

                                ts.move(offset);
                                ts.moveNext();
                            } else {
                                checkAndAddNew(child, parent, immediateBlockHier);
                            }
                        }
                    }
                } else if (tokenID == PlsqlTokenId.JAVA_SOUCE) {
                    int offset = ts.offset();
                    PlsqlBlock block;
                    block = checkJavaSource(tempToken, ts);
                    if (block == null) {
                        //pass from the immediate next token to get inner blocks
                        ts.move(offset);
                        ts.moveNext();
                    } else {
                        checkAndAddNew(block, parent, immediateBlockHier);
                    }
                } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                    //only single comment line
                    PlsqlBlock block = checkComment(tempToken, ts);
                    if (block != null) {
                        checkAndAddNew(block, parent, immediateBlockHier);
                    }
                } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                    int start = tempToken.offset(tokenHierarchy);
                    PlsqlBlock block = new PlsqlBlock(start,
                            start + tempToken.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                    if (block != null) {
                        checkAndAddNew(block, parent, immediateBlockHier);
                    }
                } else if ((tokenID == PlsqlTokenId.OPERATOR) && (";".equals(image))) {
                    PlsqlBlock block = checkEnd(tempToken, ts);
                    //check whether this is the parent can happen in a remove
                    if (!isEqual(parent, block)) {
                        if ((block != null) && (checkExisting(block, immediateBlockHier) == false)) {
                            addImmediateChildren(block, immediateBlockHier);
                            immediateBlockHier.add(block);
                            if (parent != null) {
                                block.setParent(parent);
                            }
                        }
                    }
                }
            }   //we have come to the end now
        }
    }

    private void checkAndAddNew(PlsqlBlock block, PlsqlBlock parent, List<PlsqlBlock> immediateBlockHier) {
        if (checkExisting(block, immediateBlockHier) == false && !isEqual(parent, block)) {
            immediateBlockHier.add(block);
            if (parent != null) {
                block.setParent(parent);
            }
        }
    }

    /**
     * Check whether current ';' is the end of a function/procedure/view/package/type
     * @param endToken Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @return PlsqlBlock
     */
    private PlsqlBlock checkEnd(Token<PlsqlTokenId> endToken, TokenSequence<PlsqlTokenId> ts) {
        Token<PlsqlTokenId> end = endToken; //means ';' here

        Token<PlsqlTokenId> begin = null;
        String methodName = "";
        int type = -1; //1 for FUNCTION/PROCEDURE/PACKAGE/TYPE

        boolean moveBack;
        PlsqlBlock block = null;
        moveBack = getPreviousNonWhitespace(ts, true);
        Token<PlsqlTokenId> tmp = ts.token();

        if (moveBack == false) {
            ts.move(end.offset(tokenHierarchy));
            ts.moveNext();
            return block;
        }

        //If this is a function/procedure end take the name
        if ((tmp.id() == PlsqlTokenId.KEYWORD) && (tmp.text().toString().equalsIgnoreCase("END"))) {
            type = 0;
        } else if (tmp.id() == PlsqlTokenId.IDENTIFIER || tmp.id() == PlsqlTokenId.KEYWORD) {
            methodName = tmp.text().toString();

            //Check whether this is an 'end <ide>;'
            moveBack = getPreviousNonWhitespace(ts, true);
            tmp = ts.token();

            if (moveBack == false) {
                ts.move(end.offset(tokenHierarchy));
                ts.moveNext();
                return block;
            }

            if ((tmp.id() == PlsqlTokenId.KEYWORD)
                    && (tmp.text().toString().equalsIgnoreCase("END"))) {
                type = 1;
            }

        }

        if (type == 1) {
            begin = checkMethodBegin(ts, methodName);
        } else if (type == 0) {
            begin = checkMethodBegin(ts);

            Token<PlsqlTokenId> nameToken;
            if (getNextNonWhitespace(ts, true)) {
                nameToken = ts.token();
                if (!nameToken.text().toString().equalsIgnoreCase("BODY")) {
                    methodName = nameToken.text().toString();
                } else {
                    if (getNextNonWhitespace(ts, true)) {
                        nameToken = ts.token();
                        methodName = nameToken.text().toString();
                    }
                }
            }
        }

        //Cold block is found
        if (begin != null) {
            String image = begin.text().toString();
            String alias = "";
            if (methodName.indexOf('&') != -1) {
                alias = methodName;
            }

            methodName = getDefine(methodName);

            //Get the token after the end token
            ts.move(end.offset(tokenHierarchy));
            ts.moveNext();
            ts.moveNext();

            if (image.equalsIgnoreCase("PROCEDURE")) {
                block = new PlsqlBlock(begin.offset(tokenHierarchy), ts.offset(),
                        methodName, alias, PlsqlBlockType.PROCEDURE_IMPL);
                checkPrefix(begin.offset(tokenHierarchy), ts, block);
            } else if (image.equalsIgnoreCase("PACKAGE")) {
                //get next token & check
                //find semicolon
                int endPos = ts.offset();
                ts.move(begin.offset(tokenHierarchy));
                ts.moveNext();
                boolean moveNext;
                moveNext = getNextNonWhitespace(ts, true);
                Token<PlsqlTokenId> next = ts.token();
                PlsqlBlockType foldType = PlsqlBlockType.PACKAGE;
                if ((moveNext != false) && (next.text().toString().equalsIgnoreCase("BODY"))) {
                    foldType = PlsqlBlockType.PACKAGE_BODY;
                }

                block = new PlsqlBlock(begin.offset(tokenHierarchy), endPos,
                        methodName, alias, foldType);
                checkPrefix(begin.offset(tokenHierarchy), ts, block);
            } else if (image.equalsIgnoreCase("TYPE")) {
                //get next token & check
                //find semicolon
                int endPos = ts.offset();
                ts.move(begin.offset(tokenHierarchy));
                ts.moveNext();
                boolean moveNext;
                moveNext = getNextNonWhitespace(ts, true);
                Token<PlsqlTokenId> next = ts.token();
                PlsqlBlockType foldType = PlsqlBlockType.TYPE;
                if ((moveNext != false) && (next.text().toString().equalsIgnoreCase("BODY"))) {
                    foldType = PlsqlBlockType.TYPE_BODY;
                }

                block = new PlsqlBlock(begin.offset(tokenHierarchy), endPos,
                        methodName, alias, foldType);
                checkPrefix(begin.offset(tokenHierarchy), ts, block);
            } else {
                block = new PlsqlBlock(begin.offset(tokenHierarchy), ts.offset(),
                        methodName, alias, PlsqlBlockType.FUNCTION_IMPL);
                checkPrefix(begin.offset(tokenHierarchy), ts, block);
            }
        }

        ts.move(end.offset(tokenHierarchy));
        ts.moveNext();
        return block;
    }

    /**
     * Check whether there is a function/procedure in this block
     * @param ts TokenSequence<PlsqlTokenId>
     * @param methodName String
     * @return Token<PlsqlTokenId>
     */
    private Token<PlsqlTokenId> checkMethodBegin(TokenSequence<PlsqlTokenId> ts, String methodName) {
        Token<PlsqlTokenId> begin = null;
        boolean moveBack = ts.movePrevious();
        Token<PlsqlTokenId> tmp = ts.token();
        int endCount = 0;

        while (moveBack) {
            String image = tmp.text().toString();

            if (image.equalsIgnoreCase(methodName)) {
                //Go to previous word
                boolean move = getPreviousNonWhitespace(ts, true);
                Token<PlsqlTokenId> token = ts.token();

                if ((move != false) && (token.id() == PlsqlTokenId.KEYWORD)) {
                    if ((token.text().toString().equalsIgnoreCase("FUNCTION"))
                            || (token.text().toString().equalsIgnoreCase("PROCEDURE"))) {
                        //if there were inner functions & procedures
                        if (endCount != 0) {
                            endCount--;
                        } else {
                            return token;
                        }
                    } else if (token.text().toString().equalsIgnoreCase("BODY")) {
                        boolean pre = getPreviousNonWhitespace(ts, true);
                        Token<PlsqlTokenId> previous = ts.token();
                        if ((pre != false) && (previous.text().toString().equalsIgnoreCase("PACKAGE") || previous.text().toString().equalsIgnoreCase("TYPE"))) {
                            return previous;
                        }

                    } else if (token.text().toString().equalsIgnoreCase("END")) {
                        ++endCount;
                    }
                }
            }
            moveBack = getPreviousNonWhitespace(ts, true);
            tmp = ts.token();
        }

        return begin;
    }

    /**
     * Check whether there is a function/procedure in this block
     * Method name is not there in the 'END;'
     * @param ts TokenSequence<PlsqlTokenId>
     * @return Token<PlsqlTokenId>
     */
    private Token<PlsqlTokenId> checkMethodBegin(TokenSequence<PlsqlTokenId> ts) {
        Token<PlsqlTokenId> begin = null;
        boolean moveBack = ts.movePrevious();
        Token<PlsqlTokenId> tmp = ts.token();
        int endCount = 0;

        while (moveBack) {
            String image = tmp.text().toString();

            if (tmp.id() == PlsqlTokenId.KEYWORD) {
                if ((image.equalsIgnoreCase("BEGIN"))) {
                    endCount--;
                } else if ((image.equalsIgnoreCase("END"))) {
                    int off = ts.offset();
                    if (getNextNonWhitespace(ts, true)) {
                        tmp = ts.token();
                    }

                    if ((tmp.text().toString().equals(";")) || (tmp.id() == PlsqlTokenId.IDENTIFIER)
                            || (tmp.id() == PlsqlTokenId.KEYWORD && (!tmp.toString().equalsIgnoreCase("IF")
                            && !tmp.toString().equalsIgnoreCase("CASE") && !tmp.toString().equalsIgnoreCase("LOOP")))) {
                        endCount++;
                    }

                    ts.move(off);
                    ts.moveNext();
                } else if ((endCount == 0) & (image.equalsIgnoreCase("PACKAGE") || image.equalsIgnoreCase("TYPE"))) {
                    return tmp;
                } else if ((endCount == -1) && ((image.equalsIgnoreCase("PROCEDURE"))
                        || (image.equalsIgnoreCase("FUNCTION")))) {
                    return tmp;
                } else if ((endCount == 0) & (image.equalsIgnoreCase("BODY"))) {
                    boolean pre = getPreviousNonWhitespace(ts, true);
                    Token<PlsqlTokenId> previous = ts.token();
                    if ((pre != false) && (previous.text().toString().equalsIgnoreCase("PACKAGE") || previous.text().toString().equalsIgnoreCase("TYPE"))) {
                        return previous;
                    }
                }
            }

            moveBack = getPreviousNonWhitespace(ts, true);
            tmp = ts.token();
        }

        return begin;
    }

    /**
     * Check whether this is a block comment, single line or multi lined comment
     * @param current Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @return PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkComment(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts) {
        //If the line don't start with the comment ignore
        String prefix = getPreceedingText(current.offset(tokenHierarchy), ts);
        if (!prefix.trim().equals("")) {
            return null;
        }

        Token<PlsqlTokenId> commentBegin = current;
        Token<PlsqlTokenId> tmp;
        Token<PlsqlTokenId> commentEnd = current;
        PlsqlBlock block ;
        String text = commentBegin.text().toString();
        int offset = ts.offset();
        boolean moveNext = getNextNonWhitespace(ts, false);
        tmp = ts.token();
        boolean takeDesc = true;
        String desc = getCommentDescription(text);
        if (!"COMMENT...".equals(desc)) {
            takeDesc = false;
        }

        while (moveNext) {
            PlsqlTokenId tokenID = tmp.id();

            //We have come to the end of the view declaration
            if (tokenID != PlsqlTokenId.LINE_COMMENT) {
                break;
            } else {
                commentEnd = tmp;
                if (takeDesc) {
                    text = text + tmp.text().toString();
                    desc = getCommentDescription(text);
                    if (!"COMMENT...".equals(desc)) {
                        takeDesc = false;
                    }
                }
                moveNext = getNextNonWhitespace(ts, false);
                tmp = ts.token();
            }
        }

        offset = commentEnd.offset(tokenHierarchy);
        ts.move(offset);
        ts.moveNext();

        //Calculate end offset
        int endOffset = commentEnd.offset(tokenHierarchy) + commentEnd.length();

        block = new PlsqlBlock(commentBegin.offset(tokenHierarchy),
                endOffset, desc, "", PlsqlBlockType.COMMENT);

        return block;
    }

    /**
     * Method that will give the description of the comment fold
     * @param text String
     * @return String
     */
    private String getCommentDescription(String text) {
        String description = "COMMENT...";

        //Get first -- character from begin to end
        char[] textArr = text.toCharArray();
        int begin = 0;
        int end;

        //Get the start character which is not -
        int i = 0;
        while (textArr.length > i) {
            if ((textArr[i] != '-') && (textArr[i] != ' ')) {
                begin = i;
                break;
            }
            i++;
        }

        //Get end character which is -
        i++;
        while (textArr.length > i) {
            if (textArr[i] == '-') {
                break;
            }
            i++;
        }

        end = i;

        if (begin != 0) {
            description = "-- " + text.substring(begin, end);
        }

        return description;
    }

    /**
     * Check whether this is the start of a PROCEDURE/FUNCTION block
     * @param methodToken Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param type PlsqlBlockType
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkMethod(Token<PlsqlTokenId> methodToken, TokenSequence<PlsqlTokenId> ts, PlsqlBlockType type, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> methodBegin = methodToken;
        Token<PlsqlTokenId> tmp;
        PlsqlBlock block = null;
        List<PlsqlBlock> lstChild = new ArrayList<>();
        boolean isFound = false;
        boolean pragmaFound = false;
        int semicolonCount = 0;
        String methodName;
        boolean moveNext;
        int beginCount = 0; //workaround to identify end of method...

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        //Get procedure/function name which is the next non whitespace token
        moveNext = getNextNonWhitespace(ts, true);
        tmp = ts.token();
        if (moveNext == false) {
            return block;
        }

        methodName = tmp.text().toString();
        methodName = checkForOtherSchema(ts, methodName);
        String alias = "";
        if (methodName.indexOf('&') != -1) {
            alias = methodName;
        }

        methodName = getDefine(methodName);
        Token<PlsqlTokenId> previous = tmp;

        //Check whether there is the keyword 'IS' before ';'
        while (moveNext) {
            String image = tmp.text().toString();
            PlsqlTokenId tokenID = tmp.id();

            if ((tmp != null) && (!";".equals(image)) && (!image.equalsIgnoreCase("END")) && (!previous.toString().equalsIgnoreCase("END")) && (tmp.offset(tokenHierarchy) > endParse)) { //end is added here for the abnormal case in code templates
                break;
            }

            //Increment semicolon count, if IS is not found before first break
            if ((tokenID == PlsqlTokenId.OPERATOR) && ";".equals(image)) {
                ++semicolonCount;
                boolean isEndFound = false;
                int offset = ts.offset();
                boolean preMove;
                preMove = getPreviousNonWhitespace(ts, true);

                //workaround for issue with functions/procedures ending with End; (no name)
                Token<PlsqlTokenId> previousNWS = ts.token();
                PlsqlTokenId previd = previousNWS.id();
                if ((preMove != false) && previousNWS.text().toString().equalsIgnoreCase("END")) {
                    if (beginCount < 1) {
                        isEndFound = true;
                    }
                } else {
                    preMove = getPreviousNonWhitespace(ts, true);
                    previousNWS = ts.token();
                    if ((previd == PlsqlTokenId.IDENTIFIER || previd == PlsqlTokenId.KEYWORD)
                            && (previousNWS.text().toString().equalsIgnoreCase("END"))) {
                        isEndFound = true;
                    }
                    if ((previd == PlsqlTokenId.IDENTIFIER || previd == PlsqlTokenId.KEYWORD)
                            && (previousNWS.text().toString().equalsIgnoreCase("USING"))) {
                        if (beginCount < 1) {
                            ts.move(offset);
                            moveNext = ts.moveNext();
                            moveNext = ts.moveNext();
                            block = new PlsqlBlock(methodBegin.offset(tokenHierarchy),
                                    ts.offset(), methodName, alias, type);
                            checkPrefix(methodBegin.offset(tokenHierarchy), ts, block);
                            break;
                        }
                    }
                }

                ts.move(offset);
                if ((semicolonCount == 1) && (!isFound) && (!pragmaFound) && (!isEndFound)) {
                    //Although we were looking for impl's we have found a def here
                    ts.moveNext();
                    ts.moveNext();
                    if (type == PlsqlBlockType.PROCEDURE_IMPL) {
                        block = new PlsqlBlock(methodBegin.offset(tokenHierarchy),
                                ts.offset(), methodName, alias, PlsqlBlockType.PROCEDURE_DEF);
                    } else {
                        block = new PlsqlBlock(methodBegin.offset(tokenHierarchy),
                                ts.offset(), methodName, alias, PlsqlBlockType.FUNCTION_DEF);
                    }

                    return block;
                }
                ts.moveNext();
            }

            //We might have come to the end of the procedure/function declaration
            if (((tokenID == PlsqlTokenId.OPERATOR) && ";".equals(image)) && isFound) {
                //check whether previous Non white space token to the identifier is END
                int offset = ts.offset();
                boolean preMove;
                preMove = getPreviousNonWhitespace(ts, true);
                //workaround for issue with functions/procedures ending with End; (no name)
                Token<PlsqlTokenId> previousNWS = ts.token();
                String prevText = previousNWS.text().toString();
                if ((preMove != false) && prevText.equalsIgnoreCase("END")) {
                    if (beginCount <= 0) {
                        ts.move(offset);
                        moveNext = ts.moveNext();
                        moveNext = ts.moveNext();
                        block = new PlsqlBlock(methodBegin.offset(tokenHierarchy),
                                ts.offset(), methodName, alias, type);
                        checkPrefix(methodBegin.offset(tokenHierarchy), ts, block);
                        break;
                    }
                } else {
                    preMove = getPreviousNonWhitespace(ts, true);
                    previousNWS = ts.token();
                    if (previousNWS.text().toString().equalsIgnoreCase("END")) {
                        if (beginCount <= 0) {
                            ts.move(offset);
                            moveNext = ts.moveNext();
                            moveNext = ts.moveNext();
                            block = new PlsqlBlock(methodBegin.offset(tokenHierarchy),
                                    ts.offset(), methodName, alias, type);
                            checkPrefix(methodBegin.offset(tokenHierarchy), ts, block);
                            break;
                        }
                    }
                }
                ts.move(offset);
                moveNext = ts.moveNext();
            } else if ((tokenID == PlsqlTokenId.KEYWORD)
                    && ((image.equalsIgnoreCase("PROCEDURE"))
                    || (image.equalsIgnoreCase("FUNCTION"))
                    || (image.equalsIgnoreCase("CURSOR")))) {
                if (isFound && beginCount <= 0) {
                    int beforeOff = tmp.offset(tokenHierarchy);

                    if (image.equalsIgnoreCase("PROCEDURE")) {
                        PlsqlBlock child = checkMethod(tmp, ts, PlsqlBlockType.PROCEDURE_IMPL, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            moveNext = ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner procedure
                    else if (image.equalsIgnoreCase("FUNCTION")) {
                        PlsqlBlock child = checkMethod(tmp, ts, PlsqlBlockType.FUNCTION_IMPL, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            moveNext = ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner function
                    else if (image.equalsIgnoreCase("CURSOR")) {
                        PlsqlBlock child = checkCursor(tmp, ts, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            moveNext = ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner cursor
                } else {
                    break;
                }
            } else if ((image.equalsIgnoreCase("IF")) && isFound) {
                int beforeOff = tmp.offset(tokenHierarchy);
                List children = checkIfBlock(tmp, ts, lstChild);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i
                            < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } //If block
            else if ((image.equalsIgnoreCase("CASE")) && isFound) {
                int beforeOff = tmp.offset(tokenHierarchy);
                List children = checkCaseBlock(tmp, ts, lstChild, false);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i
                            < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if ((tokenID == PlsqlTokenId.KEYWORD)
                    && ((image.equalsIgnoreCase("LOOP"))
                    || (image.equalsIgnoreCase("WHILE"))
                    || (image.equalsIgnoreCase("FOR")))) {
                if (isFound) {
                    int beforeOff = tmp.offset(tokenHierarchy);
                    PlsqlBlock child = checkLoopBlock(tmp, ts, lstChild);
                    if (child == null) {//If inner check seems to have failed need to continue this one
                        ts.move(beforeOff);
                        moveNext = ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if ((tokenID == PlsqlTokenId.KEYWORD) && (image.equalsIgnoreCase("TABLE")
                    || image.equalsIgnoreCase("INDEX")
                    || image.equalsIgnoreCase("SELECT")
                    || image.equalsIgnoreCase("UPDATE")
                    || image.equalsIgnoreCase("DELETE")
                    || image.equalsIgnoreCase("INSERT")
                    || image.equalsIgnoreCase("DROP")
                    || image.equalsIgnoreCase("SEQUENCE"))) {
                if (!isNotBlockStart(tmp, ts)) {
                    int offset = tmp.offset(tokenHierarchy);
                    PlsqlBlock child = checkStatementBlock(tmp, ts, parentBlocks);
                    if (child == null) {//If inner check seems to have failed need to continue this one
                        ts.move(offset);
                        ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(tmp, ts);
                if ((child != null) && (checkExisting(child, lstChild) == false)) {
                    lstChild.add(child);
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = tmp.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + tmp.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if ((child != null) && (checkExisting(child, lstChild) == false)) {
                    lstChild.add(child);
                }
            } else if (tokenID == PlsqlTokenId.KEYWORD && (image.equalsIgnoreCase("BEGIN"))) {
                beginCount++;
            } else if (tokenID == PlsqlTokenId.KEYWORD && image.equalsIgnoreCase("END")) {
                int off = ts.offset();
                if (getNextNonWhitespace(ts, true)) {
                    tmp = ts.token();
                }

                if ((tmp.text().toString().equals(";")) || (tmp.id() == PlsqlTokenId.IDENTIFIER)
                        || (tmp.id() == PlsqlTokenId.KEYWORD && (!tmp.toString().equalsIgnoreCase("IF")
                        && !tmp.toString().equalsIgnoreCase("CASE") && !tmp.toString().equalsIgnoreCase("LOOP")))) {
                    beginCount--;
                }

                ts.move(off);
                ts.moveNext();
                tmp = ts.token();
            } else if (tokenID == PlsqlTokenId.KEYWORD && image.equalsIgnoreCase("PRAGMA")) {
                pragmaFound = true;
            } else {
                //Mark when we come to 'IS'
                if ((tokenID == PlsqlTokenId.KEYWORD)
                        && ((image.equalsIgnoreCase("IS")))) {
                    isFound = true;
                }
            }
            if (tokenID != PlsqlTokenId.WHITESPACE) {
                previous = tmp;
            }

            moveNext = ts.moveNext();
            tmp = ts.token();
        }

        if (block != null) {
            //check whether there is a parent block
            PlsqlBlock parent = getParentBlock(blockHierarchy, block.getStartOffset(), block.getEndOffset());
            if ((parent != null) && (parent.getName().equals(block.getName()))) {
                if (parent.getEndOffset() == block.getEndOffset()) {
                    return null;
                }
            }

            //add children
            addChildren(block, lstChild, parentBlocks);
        }

        return block;
    }

    /**
     * Check whether this is the start of a PACKAGE block
     * @param tempToken Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkPackage(Token<PlsqlTokenId> packToken, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> packBegin = packToken;
        Token<PlsqlTokenId> tmp;
        Token<PlsqlTokenId> tmpPre = packToken;
        boolean isFound = false;
        String packageName;
        boolean isPackageBody = false;
        boolean moveNext;
        PlsqlBlock block = null;
        List<PlsqlBlock> lstChild = new ArrayList<>();
        int beginCount = 0;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        //Get package name which is the next non whitespace token in api
        moveNext = getNextNonWhitespace(ts, true);
        tmp = ts.token();
        if (moveNext == false) {
            return block;
        }

        if (tmp.text().toString().equalsIgnoreCase("BODY")) {
            isPackageBody = true;
            moveNext = getNextNonWhitespace(ts, true);
            tmp = ts.token();
            if (moveNext == false) {
                return block;
            }
        }

        packageName = tmp.text().toString();
        packageName = checkForOtherSchema(ts, packageName);
        String alias = "";
        if (packageName.indexOf('&') != -1) {
            alias = packageName;
        }

        packageName = getDefine(packageName);

        while (moveNext) {
            String image = tmp.text().toString();
            PlsqlTokenId tokenID = tmp.id();

            if ((tmp != null) && (!";".equals(image)) && (tmp.offset(tokenHierarchy) > endParse)) {
                break;
            }

            //We might have come to the end of the package
            if (((tokenID == PlsqlTokenId.OPERATOR) && (";".equals(image) || ("/".equals(image) && checkForOnlyChar(ts, ts.offset())))) && (isFound)
                    && ((tmpPre.text().toString().equalsIgnoreCase(packageName))
                    || ((!"".equals(alias)) && (tmpPre.text().toString().equalsIgnoreCase(alias)))
                    || ((tmpPre.text().toString().equalsIgnoreCase("END")) && (beginCount < 0)))) {
                boolean isPackage = false;
                if (tmpPre.text().toString().equalsIgnoreCase(packageName)
                        || tmpPre.text().toString().equalsIgnoreCase(alias)) {
                    //check whether previous Non white space token to the identifier is END
                    int offset = ts.offset();
                    boolean preMove;
                    preMove = getPreviousNonWhitespace(ts, true);
                    preMove = getPreviousNonWhitespace(ts, true);
                    Token<PlsqlTokenId> previousNWS = ts.token();

                    ts.move(offset);
                    ts.moveNext();

                    if ((preMove != false)
                            && previousNWS.text().toString().equalsIgnoreCase("END")) {
                        isPackage = true;
                    }
                } else if ((tmpPre.text().toString().equalsIgnoreCase("END")) && (beginCount < 0)) {
                    isPackage = true;
                }

                //If this is a package end create the block
                if (isPackage) {
                    PlsqlBlockType type = PlsqlBlockType.PACKAGE;

                    if (isPackageBody) {
                        type = PlsqlBlockType.PACKAGE_BODY;
                    }

                    ts.moveNext();

                    block = new PlsqlBlock(packBegin.offset(tokenHierarchy),
                            ts.offset(), packageName, alias, type);
                    checkPrefix(packBegin.offset(tokenHierarchy), ts, block);
                    break;
                }
            } else if ((tokenID == PlsqlTokenId.KEYWORD)
                    && ((image.equalsIgnoreCase("PROCEDURE"))
                    || (image.equalsIgnoreCase("FUNCTION"))
                    || (image.equalsIgnoreCase("CURSOR")))) {
                if (isFound) {
                    int beforeOff = tmp.offset(tokenHierarchy);

                    if (image.equalsIgnoreCase("PROCEDURE")) {
                        PlsqlBlock child = checkMethod(tmp, ts, PlsqlBlockType.PROCEDURE_IMPL, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner procedure
                    else if (image.equalsIgnoreCase("FUNCTION")) {
                        PlsqlBlock child = checkMethod(tmp, ts, PlsqlBlockType.FUNCTION_IMPL, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner function
                    else if (image.equalsIgnoreCase("CURSOR")) {
                        PlsqlBlock child = checkCursor(tmp, ts, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner cursor

                } else {
                    break;
                }
            } else if (tokenID == PlsqlTokenId.KEYWORD && (image.equalsIgnoreCase("BEGIN"))) {
                beginCount++;
            } else if ((tokenID == PlsqlTokenId.KEYWORD)
                    && (image.equalsIgnoreCase("END"))) {
                int off = ts.offset();
                if (getNextNonWhitespace(ts, true)) {
                    tmp = ts.token();
                }

                if ((tmp.text().toString().equals(";")) || (tmp.id() == PlsqlTokenId.IDENTIFIER)
                        || (tmp.id() == PlsqlTokenId.KEYWORD && (!tmp.toString().equalsIgnoreCase("IF")
                        && !tmp.toString().equalsIgnoreCase("CASE") && !tmp.toString().equalsIgnoreCase("LOOP")))) {
                    beginCount--;
                }

                ts.move(off);
                ts.moveNext();
                tmp = ts.token();
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(tmp, ts);
                if ((child != null) && (checkExisting(child, lstChild) == false)) {
                    lstChild.add(child);
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = tmp.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + tmp.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if ((child != null) && (checkExisting(child, lstChild) == false)) {
                    lstChild.add(child);
                }
            } else {
                //Mark when we come to 'IS'
                if ((tokenID == PlsqlTokenId.KEYWORD)
                        && ((image.equalsIgnoreCase("IS")) || (image.equalsIgnoreCase("AS")))) {
                    isFound = true;
                }
            }

            if (tokenID != PlsqlTokenId.WHITESPACE) {//previous non whitespace token

                tmpPre = tmp;
            }

            moveNext = ts.moveNext();
            tmp = ts.token();
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);

            //Add immediate children
            addImmediateChildren(block, parentBlocks);
        }

        return block;
    }

    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkType(Token<PlsqlTokenId> typeToken, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> typeBegin = typeToken;
        Token<PlsqlTokenId> tmp;
        Token<PlsqlTokenId> tmpPre = typeToken;
        boolean isFound = false;
        String typeName;
        boolean isTypeBody = false;
        boolean moveNext;
        PlsqlBlock block = null;
        List<PlsqlBlock> lstChild = new ArrayList<>();
        int beginCount = 0;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        //Get type name which is the next non whitespace token in api
        moveNext = getNextNonWhitespace(ts, true);
        tmp = ts.token();
        if (moveNext == false) {
            return block;
        }

        if (";".equals(tmp.text().toString())) {
            return null;
        }

        if (tmp.text().toString().equalsIgnoreCase("BODY")) {
            isTypeBody = true;
            moveNext = getNextNonWhitespace(ts, true);
            tmp = ts.token();
            if (moveNext == false) {
                return block;
            }
        }

        typeName = tmp.text().toString();
        typeName = checkForOtherSchema(ts, typeName);
        String alias = "";
        if (typeName.indexOf('&') != -1) {
            alias = typeName;
        }

        typeName = getDefine(typeName);

        while (moveNext) {
            String image = tmp.text().toString();
            PlsqlTokenId tokenID = tmp.id();
            if ((tmp != null) && (!";".equals(image)) && (tmp.offset(tokenHierarchy) > endParse)) {
                break;
            }
            //We might have come to the end of the type
            if (((tokenID == PlsqlTokenId.OPERATOR) && (";".equals(image) || ("/".equals(image) && checkForOnlyChar(ts, ts.offset())))) && (isFound)
                    && ((tmpPre.text().toString().equalsIgnoreCase(typeName))
                    || ((!"".equals(alias)) && (tmpPre.text().toString().equalsIgnoreCase(alias)))
                    || ((tmpPre.text().toString().equalsIgnoreCase("END")) && (beginCount < 0)))
                    || ((";".equals(image) || "/".equals(image) && checkForOnlyChar(ts, ts.offset())) && (!isTypeBody))) {
                boolean isType = false;
                if (tmpPre.text().toString().equalsIgnoreCase(typeName)
                        || tmpPre.text().toString().equalsIgnoreCase(alias)) {
                    //check whether previous Non white space token to the identifier is END
                    int offset = ts.offset();
                    boolean preMove;
                    preMove = getPreviousNonWhitespace(ts, true);
                    preMove = getPreviousNonWhitespace(ts, true);
                    Token<PlsqlTokenId> previousNWS = ts.token();

                    ts.move(offset);
                    ts.moveNext();

                    if ((preMove != false)
                            && previousNWS.text().toString().equalsIgnoreCase("END")) {
                        isType = true;
                    }
                } else if ((tmpPre.text().toString().equalsIgnoreCase("END")) && (beginCount < 0)) {
                    isType = true;
                } else if ((";".equals(image) || "/".equals(image) && checkForOnlyChar(ts, ts.offset())) && (!isTypeBody)) {
                    isType = true;
                }

                //If this is a type end create the block
                if (isType) {
                    PlsqlBlockType type = PlsqlBlockType.TYPE;

                    if (isTypeBody) {
                        type = PlsqlBlockType.TYPE_BODY;
                    }
                    if (!("/".equals(image) && checkForOnlyChar(ts, ts.offset()))) {
                        ts.moveNext();
                    }

                    block = new PlsqlBlock(typeBegin.offset(tokenHierarchy),
                            ts.offset(), typeName, alias, type);
                    checkPrefix(typeBegin.offset(tokenHierarchy), ts, block);
                    break;
                }
            } else if ((tokenID == PlsqlTokenId.KEYWORD) && (isTypeBody)
                    && ((image.equalsIgnoreCase("PROCEDURE"))
                    || (image.equalsIgnoreCase("FUNCTION"))
                    || (image.equalsIgnoreCase("CURSOR")))) {
                if (isFound) {
                    int beforeOff = tmp.offset(tokenHierarchy);

                    if (image.equalsIgnoreCase("PROCEDURE")) {
                        PlsqlBlock child = checkMethod(tmp, ts, PlsqlBlockType.PROCEDURE_IMPL, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner procedure
                    else if (image.equalsIgnoreCase("FUNCTION")) {
                        PlsqlBlock child = checkMethod(tmp, ts, PlsqlBlockType.FUNCTION_IMPL, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner function
                    else if (image.equalsIgnoreCase("CURSOR")) {
                        PlsqlBlock child = checkCursor(tmp, ts, lstChild);
                        if (child == null) {//If inner check seems to have failed need to continue this one

                            ts.move(beforeOff);
                            ts.moveNext();
                        } else {
                            if (checkExisting(child, lstChild) == false) {
                                lstChild.add(child);
                            }
                        }
                    } //Inner cursor

                } else {
                    break;
                }
            } else if (tokenID == PlsqlTokenId.KEYWORD && (image.equalsIgnoreCase("BEGIN"))) {
                beginCount++;
            } else if ((tokenID == PlsqlTokenId.KEYWORD)
                    && (image.equalsIgnoreCase("END"))) {
                int off = ts.offset();
                if (getNextNonWhitespace(ts, true)) {
                    tmp = ts.token();
                }

                if ((tmp.text().toString().equals(";")) || (tmp.id() == PlsqlTokenId.IDENTIFIER)
                        || (tmp.id() == PlsqlTokenId.KEYWORD && (!tmp.toString().equalsIgnoreCase("IF")
                        && !tmp.toString().equalsIgnoreCase("CASE") && !tmp.toString().equalsIgnoreCase("LOOP")))) {
                    beginCount--;
                }

                ts.move(off);
                ts.moveNext();
                tmp = ts.token();
            } else if ((tokenID == PlsqlTokenId.KEYWORD)
                    && ((image.equalsIgnoreCase("CREATE")) || (image.equalsIgnoreCase("TYPE")))) {
                return block;
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(tmp, ts);
                if ((child != null) && (checkExisting(child, lstChild) == false)) {
                    lstChild.add(child);
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = tmp.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + tmp.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if ((child != null) && (checkExisting(child, lstChild) == false)) {
                    lstChild.add(child);
                }
            } else {
                //Mark when we come to 'IS'
                if ((tokenID == PlsqlTokenId.KEYWORD)
                        && ((image.equalsIgnoreCase("IS")) || (image.equalsIgnoreCase("AS")))) {
                    isFound = true;
                }
            }
            if (tokenID != PlsqlTokenId.WHITESPACE) {//previous non whitespace token
                tmpPre = tmp;
            }

            moveNext = ts.moveNext();
            tmp = ts.token();
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);

            //Add immediate children
            addImmediateChildren(block, parentBlocks);
        }
        return block;
    }

    /**
     * Method that will check declare end blocks
     * @param current Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkDeclareBlock(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> declareBegin;
        Token<PlsqlTokenId> token;
        boolean moveNext;
        boolean isBeginFound = false;
        List<PlsqlBlock> lstChild = new ArrayList<>();
        PlsqlBlock block = null;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        moveNext = ts.moveNext();
        token = ts.token();
        declareBegin = current;

        while (moveNext) {
            PlsqlTokenId tokenID = token.id();
            String image = token.text().toString();

            if ((token != null) && (!";".equals(image)) && (token.offset(tokenHierarchy) > endParse)) {
                break;
            }

            //We have come to the end of the comment
            if ((tokenID == PlsqlTokenId.OPERATOR) && (("/".equals(image) && checkForOnlyChar(ts, ts.offset())) || ";".equals(image))) {
                //check whether its END; or END before /
                boolean movePre = getPreviousNonWhitespace(ts, true);
                Token<PlsqlTokenId> pre = ts.token();
                if (!movePre) {
                    ts.move(token.offset(tokenHierarchy));
                    ts.moveNext();
                }

                if ("/".equals(image)) {
                    if (pre.toString().equals(";")) {
                        movePre = getPreviousNonWhitespace(ts, true);
                        pre = ts.token();
                        if ((movePre) && (pre.toString().equalsIgnoreCase("END"))) {
                            ts.move(token.offset(tokenHierarchy));
                            ts.moveNext();
                            ts.moveNext();
                            block = new PlsqlBlock(declareBegin.offset(tokenHierarchy),
                                    ts.offset(), "", "", PlsqlBlockType.DECLARE_END);
                            removeChildBegin(block);
                            break;
                        }
                    } else {
                        //something has gone wrong '/' is a terminal
                        break;
                    }
                } else {
                    if ((movePre) && (pre.toString().equalsIgnoreCase("END"))) {
                        ts.move(token.offset(tokenHierarchy));
                        ts.moveNext();
                        ts.moveNext();
                        block = new PlsqlBlock(declareBegin.offset(tokenHierarchy),
                                ts.offset(), "", "", PlsqlBlockType.DECLARE_END);
                        removeChildBegin(block);
                        break;
                    }
                }
                ts.move(token.offset(tokenHierarchy));
                ts.moveNext();
            } else if (image.equalsIgnoreCase("CURSOR")) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkCursor(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("PROCEDURE")) {
                if (isBeginFound) {//Can be there only before begin in a declare block

                    break;
                }

                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkMethod(token, ts, PlsqlBlockType.PROCEDURE_IMPL, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("FUNCTION")) {
                if (isBeginFound) {//Can be there only before begin in a declare block

                    break;
                }

                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkMethod(token, ts, PlsqlBlockType.FUNCTION_IMPL, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (isBeginFound && image.equalsIgnoreCase("DECLARE")) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkDeclareBlock(token, ts, lstChild);
                if (child != null) {//If inner check seems to have failed need to continue this one
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("BEGIN")) {
                if (isBeginFound) {
                    int beforeOff = token.offset(tokenHierarchy);
                    PlsqlBlock child = checkBeginBlock(token, ts, lstChild);
                    if (child == null) {//If inner check seems to have failed need to continue this one

                        ts.move(beforeOff);
                        moveNext = ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                } else {
                    isBeginFound = true;
                }
            } else if (image.equalsIgnoreCase("IF")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkIfBlock(token, ts, lstChild);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("CASE")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkCaseBlock(token, ts, lstChild, false);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("LOOP")
                    || image.equalsIgnoreCase("WHILE")
                    || image.equalsIgnoreCase("FOR")) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkLoopBlock(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("TABLE")
                    || image.equalsIgnoreCase("INDEX")
                    || image.equalsIgnoreCase("SELECT")
                    || image.equalsIgnoreCase("UPDATE")
                    || image.equalsIgnoreCase("DELETE")
                    || image.equalsIgnoreCase("INSERT")
                    || image.equalsIgnoreCase("DROP")
                    || image.equalsIgnoreCase("SEQUENCE")) {
                if (!isNotBlockStart(token, ts)) {
                    int offset = token.offset(tokenHierarchy);
                    PlsqlBlock child = checkStatementBlock(token, ts, parentBlocks);
                    if (child == null) {//If inner check seems to have failed need to continue this one

                        ts.move(offset);
                        ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(token, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = token.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + token.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            }

            moveNext = ts.moveNext();
            token = ts.token();
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);
        } else {
            if (moveNext) { //If have come to last return otherwise we will loop with begin
                ts.move(declareBegin.offset(tokenHierarchy));
                ts.moveNext();
            }
        }

        return block;
    }

    /**
     * Method that will check begin end blocks
     * @param current Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkBeginBlock(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> begin;
        Token<PlsqlTokenId> token;
        PlsqlBlock block = null;
        List<PlsqlBlock> lstChild = new ArrayList<>();
        boolean moveNext;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        moveNext = ts.moveNext();
        token = ts.token();
        begin = current;

        while (moveNext) {
            PlsqlTokenId tokenID = token.id();
            String image = token.text().toString();

            if ((token != null) && (!";".equals(image)) && (token.offset(tokenHierarchy) > endParse)) {
                break;
            }

            //We have come to the end of the comment
            if ((tokenID == PlsqlTokenId.OPERATOR) && (("/".equals(image) && checkForOnlyChar(ts, ts.offset())) || ";".equals(image))) {
                //check whether its END; or END; before /
                boolean movePre = getPreviousNonWhitespace(ts, true);
                Token<PlsqlTokenId> pre = ts.token();
                if (!movePre) {
                    ts.move(token.offset(tokenHierarchy));
                    ts.moveNext();
                }

                if ("/".equals(image)) {
                    if (pre.toString().equals(";")) {
                        movePre = getPreviousNonWhitespace(ts, true);
                        pre = ts.token();
                        if ((movePre) && (pre.toString().equalsIgnoreCase("END"))) {
                            //check whether there is a  DECLARE_END parent block with the same offset
                            ts.move(token.offset(tokenHierarchy));
                            ts.moveNext();
                            ts.moveNext();
                            int start = begin.offset(tokenHierarchy);
                            int end = ts.offset();
                            PlsqlBlock parent = getParentBlock(blockHierarchy, start, end);
                            if ((parent == null) || (parent.getEndOffset() != end)) {
                                block = new PlsqlBlock(start, end, "", "", PlsqlBlockType.BEGIN_END);
                            }

                            break;

                        }
                    } else {
                        //something has gone wrong '/' is a terminal
                        break;
                    }
                } else {
                    if ((movePre) && (pre.toString().equalsIgnoreCase("END"))) {
                        //check whether there is a  DECLARE_END parent block with the same offset
                        ts.move(token.offset(tokenHierarchy));
                        ts.moveNext();
                        ts.moveNext();
                        int start = begin.offset(tokenHierarchy);
                        int end = ts.offset();
                        PlsqlBlock parent = getParentBlock(blockHierarchy, start, end);
                        if ((parent == null) || (parent.getEndOffset() != end)) {
                            block = new PlsqlBlock(start, end, "", "", PlsqlBlockType.BEGIN_END);
                        }

                        break;
                    }
                }
                ts.move(token.offset(tokenHierarchy));
                ts.moveNext();
            } else if (tokenID == PlsqlTokenId.KEYWORD && image.equalsIgnoreCase("DECLARE")) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkDeclareBlock(token, ts, lstChild);
                if (child != null) {//If inner check seems to have failed need to continue this one
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.KEYWORD && (image.equalsIgnoreCase("BEGIN"))) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkBeginBlock(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("IF")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkIfBlock(token, ts, lstChild);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("CASE")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkCaseBlock(token, ts, lstChild, false);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("LOOP")
                    || image.equalsIgnoreCase("WHILE")
                    || image.equalsIgnoreCase("FOR")) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkLoopBlock(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("TABLE")
                    || image.equalsIgnoreCase("INDEX")
                    || image.equalsIgnoreCase("SELECT")
                    || image.equalsIgnoreCase("UPDATE")
                    || image.equalsIgnoreCase("DELETE")
                    || image.equalsIgnoreCase("INSERT")
                    || image.equalsIgnoreCase("DROP")
                    || image.equalsIgnoreCase("SEQUENCE")) {
                if (!isNotBlockStart(token, ts)) {
                    int offset = token.offset(tokenHierarchy);
                    PlsqlBlock child = checkStatementBlock(token, ts, parentBlocks);
                    if (child == null) {//If inner check seems to have failed need to continue this one

                        ts.move(offset);
                        ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("PROCEDURE")
                    || image.equalsIgnoreCase("FUNCTION")) {
                break;
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(token, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = token.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + token.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            }

            moveNext = ts.moveNext();
            token = ts.token();
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);
        }

        return block;
    }

    /**
     * Method to check table & column comments
     * @param current Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkTblColComment(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> commentBegin = current;
        Token<PlsqlTokenId> tmpPre = current;
        PlsqlBlock block = null;
        List<PlsqlBlock> lstChild = new ArrayList<>();

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        int beginOffset = ts.offset();
        boolean isTable = false;
        boolean isEnd = false;
        Token<PlsqlTokenId> previousBlock = null;
        String tableName = "";
        boolean moveNext;
        moveNext = getNextNonWhitespace(ts, true);
        String alias = "";

        //Check whether that is table/column comment
        if (moveNext == false) {
            return block;
        }

        Token<PlsqlTokenId> tmp = ts.token(); //catching ON

        moveNext = getNextNonWhitespace(ts, true);
        tmp = ts.token();    //TABLE OR VIEW

        if ((moveNext != false) && (tmp.id() == PlsqlTokenId.KEYWORD)) {
            String image = tmp.text().toString();
            if (image.equalsIgnoreCase("TABLE")) {
                isTable = true;

                moveNext = getNextNonWhitespace(ts, true);
                tmp = ts.token();

                if (moveNext != false) {
                    tableName = tmp.text().toString();
                    tableName = checkForOtherSchema(ts, tableName);
                    if (tableName.indexOf('&') != -1) {
                        alias = tableName;
                    }

                    tableName = getDefine(tableName);
                    if (ts.moveNext()) {
                        tmp = ts.token();
                        if ((tmp.id() == PlsqlTokenId.DOT) && ts.moveNext()) {
                            tmp = ts.token();
                        }
                    }
                }

            } else if (image.equalsIgnoreCase("COLUMN")) {
                isTable = false;
                moveNext = getNextNonWhitespace(ts, true);
                tmp = ts.token();

                if (moveNext != false) {
                    tableName = tmp.text().toString();
                    if (tableName.indexOf('&') != -1) {
                        alias = tableName;
                    }

                    tableName = getDefine(tableName);
                    if (ts.moveNext()) {
                        tmp = ts.token();
                        if ((tmp.id() == PlsqlTokenId.DOT) && ts.moveNext()) {
                            tmp = ts.token();
                        }
                    }
                }
            } else {
                ts.move(beginOffset);
                ts.moveNext();
                ts.moveNext();
                return block;
            }
        }

        while (moveNext) {
            PlsqlTokenId tokenID = tmp.id();
            String image = tmp.text().toString();

            //Check end offset and break (exception for semicolon which will mark end of some blocks)
            if ((tmp != null) && (tmp.offset(tokenHierarchy) > endParse) && (!";".equals(image)) && (!("/".equals(image) && checkForOnlyChar(ts, ts.offset())))) {
                ts.move(beginOffset);
                ts.moveNext();
                ts.moveNext();
                break;
            }

            //We have come to the end of the comment
            if ((tokenID == PlsqlTokenId.OPERATOR)
                    && (";".equals(image) || ("/".equals(image) && checkForOnlyChar(ts, ts.offset())))) {
                isEnd = true;
                previousBlock = tmp;
                int offset = ts.offset();
                boolean mNext = getNextNonWhitespace(ts, false); //after ';' dont ignore comments

                Token<PlsqlTokenId> next = ts.token();
                ts.move(offset);
                ts.moveNext();

                if ((mNext == false) || (!next.text().toString().equalsIgnoreCase("COMMENT"))
                        || ((next.text().toString().equalsIgnoreCase("COMMENT")) && (next.offset(tokenHierarchy) > endParse))) {                  //we have come to the end of the comments

                    if (isTable) {
                        block = new PlsqlBlock(commentBegin.offset(tokenHierarchy),
                                previousBlock.offset(tokenHierarchy), tableName, alias, PlsqlBlockType.TABLE_COMMENT);
                    } else {
                        block = new PlsqlBlock(commentBegin.offset(tokenHierarchy),
                                previousBlock.offset(tokenHierarchy), tableName, alias, PlsqlBlockType.COLUMN_COMMENT);
                    }

                    break;
                }
            } else if ((tokenID == PlsqlTokenId.KEYWORD)) {
                if (image.equalsIgnoreCase("COLUMN")) {
                    if (isTable == true) {
                        isTable = false;

                        if (previousBlock != null) {
                            //Create table comment fold
                            block = new PlsqlBlock(commentBegin.offset(tokenHierarchy),
                                    previousBlock.offset(tokenHierarchy), tableName, alias, PlsqlBlockType.TABLE_COMMENT);
                            ts.move(tmpPre.offset(tokenHierarchy));
                            break;
                        }
                    }
                } else if (image.equalsIgnoreCase("TABLE")) {
                    if (isTable == false) {
                        isTable = true;

                        if (previousBlock != null) {
                            //Create column comment fold
                            block = new PlsqlBlock(commentBegin.offset(tokenHierarchy),
                                    previousBlock.offset(tokenHierarchy), tableName, alias, PlsqlBlockType.COLUMN_COMMENT);
                            ts.move(tmpPre.offset(tokenHierarchy));
                            break;
                        }
                    }
                } else if (image.equalsIgnoreCase("COMMENT")) {
                    tmpPre = tmp;
                    moveNext = getNextNonWhitespace(ts, true);
                    tmp = ts.token();
                    if (isEnd == false) {
                        commentBegin = tmpPre;
                    }
                }
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(tmp, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = tmp.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + tmp.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            }

            moveNext = getNextNonWhitespace(ts, true);
            tmp = ts.token();
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);
        }

        return block;
    }

    /**
     * Get Return next non whitespace token
     * @param ts TokenSequence<PlsqlTokenId>
     * @param ignoreComment boolean: if true will ignore comments also
     * @return boolean
     */
    private boolean getNextNonWhitespace(TokenSequence<PlsqlTokenId> ts, boolean ignoreComment) {
        boolean moveNext = ts.moveNext();
        Token<PlsqlTokenId> tmp = ts.token();


        while (moveNext) {
            if (tmp.id() == PlsqlTokenId.WHITESPACE) {
                moveNext = ts.moveNext();
                tmp = ts.token();
            } else {
                if ((ignoreComment == true) && (tmp.id() == PlsqlTokenId.LINE_COMMENT
                        || tmp.id() == PlsqlTokenId.BLOCK_COMMENT)) {
                    moveNext = ts.moveNext();
                    tmp = ts.token();
                } else {
                    break;
                }
            }
        }

        return moveNext;
    }

    /**
     * Return previous non whitespace token
     * @param ts TokenSequence<PlsqlTokenId>
     * @param ignoreComment boolean
     * @return boolean
     */
    private boolean getPreviousNonWhitespace(TokenSequence<PlsqlTokenId> ts, boolean ignoreComment) {
        boolean movePrevious = ts.movePrevious();
        Token<PlsqlTokenId> tmp = ts.token();

        while (movePrevious) {
            if (tmp.id() == PlsqlTokenId.WHITESPACE) {
                movePrevious = ts.movePrevious();
                tmp = ts.token();
            } else {
                if ((ignoreComment == true) && (tmp.id() == PlsqlTokenId.LINE_COMMENT
                        || tmp.id() == PlsqlTokenId.BLOCK_COMMENT)) {
                    movePrevious = ts.movePrevious();
                    tmp = ts.token();
                } else {
                    break;
                }
            }
        }
        return movePrevious;
    }

    /**
     * Check whether this is the start of a VIEW block
     * @param viewToken Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    private PlsqlBlock checkView(Token<PlsqlTokenId> viewToken, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> viewBegin = viewToken;
        Token<PlsqlTokenId> tmp;
        PlsqlBlock block = null;
        List<PlsqlBlock> lstChild = new ArrayList<>();

        boolean moveNext;
        String viewName;
        int offset = ts.offset();

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        //second non whitespace character should be the name
        moveNext = getNextNonWhitespace(ts, true);
        if (moveNext == false) {
            ts.move(offset);
            ts.moveNext();
            return block;
        }

        tmp = ts.token();

        //Second token is the view name
        viewName = tmp.text().toString().trim();
        viewName = checkForOtherSchema(ts, viewName);
        String alias = "";
        if (viewName.indexOf('&') != -1) {
            alias = viewName;
            viewName = getDefine(viewName);
        }

        boolean isOk = false;

        while (moveNext) {
            String image = tmp.text().toString();
            PlsqlTokenId tokenID = tmp.id();

            //Check end offset and break(exception for semicolon which will mark end of some blocks)
            if ((tmp != null) && (tmp.offset(tokenHierarchy) > endParse) && (!";".equals(image))) {
                break;
            }

            if ((tokenID == PlsqlTokenId.KEYWORD) && (image.equalsIgnoreCase("AS"))) {
                isOk = true;
            }

            //We have come to the end of the view declaration
            if ((tokenID == PlsqlTokenId.OPERATOR)
                    && (";".equals(image) || ("/".equals(image) && checkForOnlyChar(ts, ts.offset())))) {
                if (isOk) {
                    block = new PlsqlBlock(viewBegin.offset(tokenHierarchy),
                            tmp.offset(tokenHierarchy), viewName, alias, PlsqlBlockType.VIEW);
                    checkPrefix(viewBegin.offset(tokenHierarchy), ts, block);
                    break;
                } else {
                    ts.move(offset);
                    ts.moveNext();
                    ts.moveNext(); // to avoid getting caught here again we have to move next
                    break;
                }
            } else if ((tokenID == PlsqlTokenId.KEYWORD)
                    && ((image.equalsIgnoreCase("COMMENT"))
                    || (image.equalsIgnoreCase("CREATE")))) { //Avoid catching ';' of other statements

                ts.move(offset);
                ts.moveNext();
                ts.moveNext(); // to avoid getting caught here again we have to move next

                break;

            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(tmp, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
                moveNext = ts.moveNext();
                tmp = ts.token();
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = tmp.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + tmp.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
                moveNext = ts.moveNext();
                tmp = ts.token();
            } else {
                moveNext = ts.moveNext();
                tmp = ts.token();
            }
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);
        }

        return block;
    }

    /**
     * Get the name defined by &Name
     * @param inputName String
     * @return String
     */
    public String getDefine(String inputName) {
        String name = inputName;

        if (name.indexOf('&', 0) != -1) {
            String val = definesMap.get(name.substring(1).toUpperCase());
            if (val != null) {
                name = val;
            }
        }

        return name;
    }

    public Map<String, String> getDefines() {
        return Collections.unmodifiableMap(definesMap);
    }

    /**
     * Method that will parse the document and initialize the aliases
     * @param doc Document
     */
    @SuppressWarnings("UnusedAssignment")
    private void getAliases(Document doc) {
        TokenHierarchy tokenHier = TokenHierarchy.get(doc);
        @SuppressWarnings("unchecked")
        TokenSequence<PlsqlTokenId> ts = tokenHier.tokenSequence(PlsqlTokenId.language());
        if (ts == null) {
            return;
        }

        //start to check aliases from the previous line end
        ts.move(startParse);
        Token<PlsqlTokenId> token = ts.token();

        //Get the difine by the name
        while (ts.moveNext() && ts.offset() <= endParse) {
            token = ts.token();
            //Check whether this is DEFINE
            if (token.id() == PlsqlTokenId.SQL_PLUS
                    && (token.toString().equalsIgnoreCase("DEF")
                    || token.toString().equalsIgnoreCase("DEFI")
                    || token.toString().equalsIgnoreCase("DEFIN")
                    || token.toString().equalsIgnoreCase("DEFINE"))) {
                String tokenTxt = readLine(ts, token);
                if (!tokenTxt.contains(" = ") && tokenTxt.contains("=")) {
                    tokenTxt = tokenTxt.substring(0, tokenTxt.indexOf('=')) + " = " + tokenTxt.substring(tokenTxt.indexOf('=') + 1);
                }

                StringTokenizer tokenizer = new StringTokenizer(tokenTxt);
                tokenizer.nextToken();
                String alias;
                String value = "";
                boolean isNext = tokenizer.hasMoreTokens();

                //alias
                if (isNext) {
                    alias = tokenizer.nextToken();
                } else {
                    break;
                }

                isNext = tokenizer.hasMoreTokens();

                if ((isNext) && (tokenizer.nextToken().equals("="))) {
                    boolean isComment = false;
                    while (tokenizer.hasMoreTokens() && !isComment) {
                        String temp = tokenizer.nextToken();
                        if (temp.startsWith("--") || temp.startsWith("/*")) {
                            isComment = true;
                        } else {
                            value = value + " " + temp;
                        }
                    }

                    value = value.trim();

                    if ((value.startsWith("\"") && value.endsWith("\""))
                            || (value.startsWith("\'") && value.endsWith("\'"))) {
                        value = value.substring(1, value.length() - 1);
                    }

                    definesMap.put(alias.toUpperCase(), value);
                }
            }
        }
    }

    /**
     * Replace exStr in the given text with newStr
     * @param plsqlString String
     * @param exStr String
     * @param newStr String
     * @return String
     */
    public String replaceText(String plsqlString, String exStr, String newStr) {
        if (plsqlString.indexOf(exStr) >= 0) {
            plsqlString = plsqlString.replace(exStr, newStr);
        }

        return plsqlString;
    }

    /**
     * Method that will check if blocks
     * @param current Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return List<PlsqlBlock>
     */
    @SuppressWarnings("UnusedAssignment")
    private List<PlsqlBlock> checkIfBlock(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> ifBegin;
        Token<PlsqlTokenId> token;
        int preOffset = -1;
        List<PlsqlBlock> ifBlocks = new ArrayList<>();
        List<PlsqlBlock> lstChild = new ArrayList<>();
        boolean moveNext;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        moveNext = ts.moveNext();
        token = ts.token();
        ifBegin = current;
        String name = ifBegin.text().toString() + " ";
        boolean isThen = false;
        //If this is an else check we need to ignore then
        if (name.trim().equalsIgnoreCase("ELSE")) {
            isThen = true;
        }
        while (moveNext) {
            String image = token.text().toString();
            PlsqlTokenId tokenID = token.id();

            if ((token != null) && (!";".equals(image)) && (token.offset(tokenHierarchy) > endParse)) {
                break;
            }

            if (image.equalsIgnoreCase("ELSE")) {
                if (isThen) {
                    PlsqlBlock block = new PlsqlBlock(ifBegin.offset(tokenHierarchy), preOffset, name.trim(), "", PlsqlBlockType.IF);
                    if (block != null) {
                        //add children
                        addChildren(block, lstChild, parentBlocks);
                        ifBlocks.add(block);
                        lstChild.clear();
                    }

                    name = "ELSE";
                    ifBegin = token;
                } else {
                    break;
                }
            } else if (image.equalsIgnoreCase("ELSIF")) {
                if (isThen) {
                    PlsqlBlock block = new PlsqlBlock(ifBegin.offset(tokenHierarchy), preOffset, name.trim(), "", PlsqlBlockType.IF);
                    if (block != null) {
                        //add children
                        addChildren(block, lstChild, parentBlocks);
                        ifBlocks.add(block);
                        lstChild.clear();
                    }
                    //reset everything for ELSE IF
                    name = "ELSIF";
                    isThen = false;
                    ifBegin = token;
                } else {
                    break;
                }
            } else if (image.equalsIgnoreCase("END")) {
                if (isThen) {
                    boolean next = getNextNonWhitespace(ts, true);
                    Token<PlsqlTokenId> nextTok = ts.token();
                    if (next && nextTok.text().toString().equalsIgnoreCase("IF")) {
                        next = getNextNonWhitespace(ts, true);
                        nextTok = ts.token();
                        if (next && nextTok.text().toString().equalsIgnoreCase(";")) {
                            ts.moveNext();
                            PlsqlBlock block = new PlsqlBlock(ifBegin.offset(tokenHierarchy), ts.offset(), name.trim(), "", PlsqlBlockType.IF);
                            if (block != null) {
                                //add children
                                addChildren(block, lstChild, parentBlocks);
                                ifBlocks.add(block);
                                lstChild.clear();
                                break;
                            }
                        } else {
                            break;
                        }
                    }
                } else {
                    break;
                }
            } else if (image.equalsIgnoreCase("THEN")) {
                isThen = true;
            } else if (image.equalsIgnoreCase("IF")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkIfBlock(token, ts, lstChild);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("CASE")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkCaseBlock(token, ts, lstChild, false);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (tokenID == PlsqlTokenId.KEYWORD && image.equalsIgnoreCase("DECLARE")) {
                PlsqlBlock child = checkDeclareBlock(token, ts, lstChild);
                if (child != null) {//If inner check seems to have failed need to continue this one
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.KEYWORD && (image.equalsIgnoreCase("BEGIN"))) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkBeginBlock(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("WHILE")
                    || image.equalsIgnoreCase("FOR")
                    || image.equalsIgnoreCase("LOOP")) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkLoopBlock(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("TABLE")
                    || image.equalsIgnoreCase("INDEX")
                    || image.equalsIgnoreCase("SELECT")
                    || image.equalsIgnoreCase("UPDATE")
                    || image.equalsIgnoreCase("DELETE")
                    || image.equalsIgnoreCase("INSERT")
                    || image.equalsIgnoreCase("DROP")
                    || image.equalsIgnoreCase("SEQUENCE")) {
                if (!isNotBlockStart(token, ts)) {
                    int offset = token.offset(tokenHierarchy);
                    PlsqlBlock child = checkStatementBlock(token, ts, parentBlocks);
                    if (child == null) {//If inner check seems to have failed need to continue this one

                        ts.move(offset);
                        ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("PROCEDURE")
                    || image.equalsIgnoreCase("FUNCTION")
                    || image.equalsIgnoreCase("CREATE")) {
                // This is too far, something is wrong. This solution might be needed in other break scenarios as well...
                return null;
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(token, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = token.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + token.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (!isThen) {
                name = name + image;
            }

            preOffset = ts.offset();
            moveNext = ts.moveNext();
            token = ts.token();
        }

        return ifBlocks;
    }

    /**
     * Method that will check case blocks
     * @param current Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @param isStatement boolean
     * @return List<PlsqlBlock>
     */
    @SuppressWarnings("UnusedAssignment")
    private List<PlsqlBlock> checkCaseBlock(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks, boolean isStatement) {
        Token<PlsqlTokenId> caseBegin;
        Token<PlsqlTokenId> token;
        int preOffset = -1;
        List<PlsqlBlock> caseBlocks = new ArrayList<>();
        List<PlsqlBlock> lstChild = new ArrayList<>();
        boolean moveNext;

        //Check whether the beginning is in a SQL Plus command
        if (!isStatement && sqlPlusLine(ts)) {
            return null;
        }

        moveNext = ts.moveNext();
        token = ts.token();
        caseBegin = current;
        String name = caseBegin.text().toString() + " ";
        boolean isThen = false;
        //If this is an else check we need to ignore then
        if (name.trim().equalsIgnoreCase("ELSE")) {
            isThen = true;
        }

        while (moveNext) {
            String image = token.text().toString();
            PlsqlTokenId tokenID = token.id();

            if ((token != null) && (!";".equals(image)) && (token.offset(tokenHierarchy) > endParse)) {
                break;
            }

            if (image.equalsIgnoreCase("ELSE")) {
                if (isThen) {
                    PlsqlBlock block = new PlsqlBlock(caseBegin.offset(tokenHierarchy), preOffset, name.trim(), "", PlsqlBlockType.CASE);
                    if (block != null) {
                        //add children
                        addChildren(block, lstChild, parentBlocks);
                        caseBlocks.add(block);
                        lstChild.clear();
                    }

                    name = "ELSE";
                    caseBegin = token;
                } else {
                    break;
                }
            } else if (image.equalsIgnoreCase("WHEN")) {
                if (isThen) {
                    PlsqlBlock block = new PlsqlBlock(caseBegin.offset(tokenHierarchy), preOffset, name.trim(), "", PlsqlBlockType.CASE);
                    if (block != null) {
                        //add children
                        addChildren(block, lstChild, parentBlocks);
                        caseBlocks.add(block);
                        lstChild.clear();
                    }
                    //reset everything for ELSE IF
                    name = "WHEN";
                    isThen = false;
                    caseBegin = token;
                } else if (name.trim().startsWith("CASE")) { //first WHEN
                    name = name + image;
                } else {
                    break;
                }
            } else if (image.equalsIgnoreCase("END")) {
                if (isThen) {
                    boolean next;
                    Token<PlsqlTokenId> nextTok;
                    int offset = ts.offset();

                    next = getNextNonWhitespace(ts, true);
                    nextTok = ts.token();
                    if (next && nextTok.text().toString().equalsIgnoreCase("CASE")) {
                        next = getNextNonWhitespace(ts, true);
                        nextTok = ts.token();
                    }
                    if (!(!isStatement && next && nextTok.text().toString().equalsIgnoreCase(";"))) {
                        ts.move(offset);
                        ts.moveNext();
                    }

                    ts.moveNext();
                    PlsqlBlock block = new PlsqlBlock(caseBegin.offset(tokenHierarchy), ts.offset(), name.trim(), "", PlsqlBlockType.CASE);
                    if (block != null) {
                        //add children
                        addChildren(block, lstChild, parentBlocks);
                        caseBlocks.add(block);
                        lstChild.clear();
                        if (isStatement && ts.token().toString().equals(";")) {
                            ts.movePrevious();
                        }
                        break;
                    }
                } else {
                    break;
                }
            } else if (image.equalsIgnoreCase("THEN")) {
                isThen = true;
            } else if (image.equalsIgnoreCase("IF")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkIfBlock(token, ts, lstChild);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("CASE")) {
                int beforeOff = token.offset(tokenHierarchy);
                List children = checkCaseBlock(token, ts, lstChild, isStatement);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = (PlsqlBlock) children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("WHILE")
                    || image.equalsIgnoreCase("FOR")
                    || image.equalsIgnoreCase("LOOP")) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkLoopBlock(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.KEYWORD && (image.equalsIgnoreCase("BEGIN"))) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkBeginBlock(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("TABLE")
                    || image.equalsIgnoreCase("INDEX")
                    || image.equalsIgnoreCase("SELECT")
                    || image.equalsIgnoreCase("UPDATE")
                    || image.equalsIgnoreCase("DELETE")
                    || image.equalsIgnoreCase("INSERT")
                    || image.equalsIgnoreCase("DROP")
                    || image.equalsIgnoreCase("SEQUENCE")) {
                if (!isNotBlockStart(token, ts)) {
                    int offset = token.offset(tokenHierarchy);
                    PlsqlBlock child = checkStatementBlock(token, ts, parentBlocks);
                    if (child == null) {//If inner check seems to have failed need to continue this one

                        ts.move(offset);
                        ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("PROCEDURE")
                    || image.equalsIgnoreCase("FUNCTION")
                    || image.equalsIgnoreCase("CREATE")) {
                break;
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(token, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = token.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + token.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (!isThen) {
                name = name + image;
            }

            preOffset = ts.offset();
            moveNext = ts.moveNext();
            token = ts.token();
        }

        return caseBlocks;
    }

    /**
     * Method that will return the prefix of the given block
     * @param startOffset int
     * @param ts TokenSequence<PlsqlTokenId>
     * @return String
     */
    @SuppressWarnings("UnusedAssignment")
    private String getPreceedingText(int startOffset, TokenSequence<PlsqlTokenId> ts) {
        String prefix = "";
        int offset = ts.offset();
        ts.move(startOffset);
        ts.moveNext();
        Token<PlsqlTokenId> token = ts.token();

        while (ts.movePrevious()) {
            token = ts.token();
            String image = token.text().toString();

            if (image.contains("\n")) {
                break;
            }

            prefix = token.text().toString() + prefix;
        }

        ts.move(offset);
        ts.moveNext();
        return prefix;
    }

    /**
     * Method that will check loop blocks
     * @param current Token<PlsqlTokenId>
     * @param ts TokenSequence<PlsqlTokenId>
     * @param parentBlocks List<PlsqlBlock>
     * @return PlsqlBlock
     */
    @SuppressWarnings("UnusedAssignment")
    private PlsqlBlock checkLoopBlock(Token<PlsqlTokenId> current, TokenSequence<PlsqlTokenId> ts, List<PlsqlBlock> parentBlocks) {
        Token<PlsqlTokenId> loopBegin;
        Token<PlsqlTokenId> token;
        List<PlsqlBlock> lstChild = new ArrayList<>();
        PlsqlBlock block = null;
        boolean moveNext;

        //Check whether the beginning is in a SQL Plus command
        if (sqlPlusLine(ts)) {
            return null;
        }

        moveNext = ts.moveNext();
        token = ts.token();
        loopBegin = current;
        boolean isLoop = false;
        PlsqlBlockType type = PlsqlBlockType.LOOP;
        String name = "";
        if (loopBegin.text().toString().equalsIgnoreCase("LOOP")) {
            isLoop = true;
        } else if (loopBegin.text().toString().equalsIgnoreCase("WHILE")) {
            type = PlsqlBlockType.WHILE_LOOP;
        } else if (loopBegin.text().toString().equalsIgnoreCase("FOR")) {
            type = PlsqlBlockType.FOR_LOOP;
        }

        while (moveNext) {
            String image = token.text().toString();
            PlsqlTokenId tokenID = token.id();

            if ((token != null) && (!";".equals(image)) && (token.offset(tokenHierarchy) > endParse)) {
                break;
            }

            if (!isLoop && image.equalsIgnoreCase("LOOP")) {
                isLoop = true;
            } else if (image.equalsIgnoreCase("END")) {
                if (isLoop) {
                    boolean next = getNextNonWhitespace(ts, true);
                    Token<PlsqlTokenId> nextTok = ts.token();
                    if (next && nextTok.text().toString().equalsIgnoreCase("LOOP")) {
                        next = getNextNonWhitespace(ts, true);
                        nextTok = ts.token();
                        if (next && nextTok.text().toString().equalsIgnoreCase(";")) {
                            ts.moveNext();
                            block = new PlsqlBlock(loopBegin.offset(tokenHierarchy), ts.offset(), name.trim(), "", type);
                            break;
                        } else {
                            break;
                        }
                    }
                } else {
                    break;
                }
            } else if (image.equalsIgnoreCase("IF")) {
                int beforeOff = token.offset(tokenHierarchy);
                List<PlsqlBlock> children = checkIfBlock(token, ts, lstChild);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("CASE")) {
                int beforeOff = token.offset(tokenHierarchy);
                List<PlsqlBlock> children = checkCaseBlock(token, ts, lstChild, false);
                if (children == null || children.isEmpty()) {//If inner check seems to have failed need to continue this one

                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    for (int i = 0; i < children.size(); i++) {
                        PlsqlBlock child = children.get(i);
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("LOOP")
                    || image.equalsIgnoreCase("WHILE")
                    || image.equalsIgnoreCase("FOR")) {
                int beforeOff = token.offset(tokenHierarchy);
                PlsqlBlock child = checkLoopBlock(token, ts, lstChild);
                if (child == null) {//If inner check seems to have failed need to continue this one
                    ts.move(beforeOff);
                    moveNext = ts.moveNext();
                } else {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (image.equalsIgnoreCase("TABLE")
                    || image.equalsIgnoreCase("INDEX")
                    || image.equalsIgnoreCase("SELECT")
                    || image.equalsIgnoreCase("UPDATE")
                    || image.equalsIgnoreCase("DELETE")
                    || image.equalsIgnoreCase("INSERT")
                    || image.equalsIgnoreCase("DROP")
                    || image.equalsIgnoreCase("SEQUENCE")) {
                if (!isNotBlockStart(token, ts)) {
                    int offset = token.offset(tokenHierarchy);
                    PlsqlBlock child = checkStatementBlock(token, ts, parentBlocks);
                    if (child == null) {//If inner check seems to have failed need to continue this one

                        ts.move(offset);
                        ts.moveNext();
                    } else {
                        if (checkExisting(child, lstChild) == false) {
                            lstChild.add(child);
                        }
                    }
                }
            } else if (image.equalsIgnoreCase("PROCEDURE")
                    || image.equalsIgnoreCase("FUNCTION")
                    || image.equalsIgnoreCase("CREATE")) {
                break;
            } else if (tokenID == PlsqlTokenId.LINE_COMMENT) {
                //only single comment line
                PlsqlBlock child = checkComment(token, ts);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (tokenID == PlsqlTokenId.BLOCK_COMMENT) {
                int start = token.offset(tokenHierarchy);
                PlsqlBlock child = new PlsqlBlock(start,
                        start + token.length(), "BLOCK COMMENT", "", PlsqlBlockType.COMMENT);
                if (child != null) {
                    if (checkExisting(child, lstChild) == false) {
                        lstChild.add(child);
                    }
                }
            } else if (!isLoop) {
                name = name + image;
            }

            moveNext = ts.moveNext();
            token = ts.token();
        }

        if (block != null) {
            //add children
            addChildren(block, lstChild, parentBlocks);
        }

        return block;
    }

    /**
     * Method that will add the given child blocks to the block and
     * remove from parent blocks if existing there
     * @param block PlsqlBlock
     * @param lstChild List<PlsqlBlock>
     * @param parentBlocks List<PlsqlBlock>
     */
    private void addChildren(PlsqlBlock block, List<PlsqlBlock> lstChild, List<PlsqlBlock> parentBlocks) {
        int size = lstChild.size();
        for (int i = 0; i < size; i++) {
            PlsqlBlock child = lstChild.get(i);
            block.addChild(child);
            removeFromParent(child, parentBlocks);
        }
    }

    public int getStartParse() {
        return startParse;
    }

    public int getEndParse() {
        return endParse;
    }
}
