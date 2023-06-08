package ifs.fnd.connect;

import org.junit.Assert;
import org.junit.Test;

import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.util.Objects;

public class AppTest {

    @Test
    public void testTransformer1() throws IOException {
        String xmlString =
                "<key1>" +
                "   <subKey2>value</subKey2>" +
                "   <subKey3>123</subKey3>" +
                "   <subKey4>true</subKey4>" +
                "</key1>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"key1\": {\n" +
                "    \"subKey3\": \"123\",\n" +
                "    \"subKey4\": \"true\",\n" +
                "    \"subKey2\": \"value\"\n" +
                "}}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer2() throws IOException {
        String xmlString =
                "<results type=\"Compound\">" +
                "   <result><value>1</value></result>" +
                "   <result><value>2</value></result>" +
                "</results>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"results\": [\n" +
                "    {\"value\": \"1\"},\n" +
                "    {\"value\": \"2\"}\n" +
                "]}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer3() throws IOException {
        String xmlString =
                "<results1>abc</results1>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"results1\": \"abc\"}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer4() throws IOException {
        String xmlString =
                "<c><results1>abc</results1>" +
                "<results type=\"Compound\"><result><a>abc</a></result></results></c>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"c\": {\n" +
                "    \"results1\": \"abc\",\n" +
                "    \"results\": [{\"a\": \"abc\"}]\n" +
                "}}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer5() throws IOException {
        String xmlString =
                "<results1>abc</results1>" +
                "<results type=\"Compound\"><result><a>abc</a></result></results>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\n" +
                "    \"results1\": \"abc\",\n" +
                "    \"results\": [{\"a\": \"abc\"}]\n" +
                "}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer6() throws IOException {
        String xmlString =
                "<results1>abc</results1>" +
                "<results type=\"Compound\"><result><a>abc</a><b>bcd</b></result></results>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\n" +
                "    \"results1\": \"abc\",\n" +
                "    \"results\": [{\n" +
                "        \"a\": \"abc\",\n" +
                "        \"b\": \"bcd\"\n" +
                "    }]\n" +
                "}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer7() throws IOException {
        String xmlString =
                "<c><results1>abc</results1>" +
                "<b>" +
                "   <d>test</d>" +
                "   <results>" +
                "       <result><a>abc</a></result>" +
                "   </results>" +
                "</b></c>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"c\": {\n" +
                "    \"b\": {\n" +
                "        \"d\": \"test\",\n" +
                "        \"results\": {\"result\": {\"a\": \"abc\"}}\n" +
                "    },\n" +
                "    \"results1\": \"abc\"\n" +
                "}}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer8() throws IOException {
        String xmlString =
                "<c>" +
                "   <b>abc</b>" +
                "   <b>" +
                "       <d>test</d>" +
                "       <results type=\"Compound\">" +
                "           <result><a>abc</a></result>" +
                "       </results>" +
                "   </b>" +
                "</c>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"c\": [\n" +
                "    \"abc\",\n" +
                "    {\n" +
                "        \"d\": \"test\",\n" +
                "        \"results\": [{\"a\": \"abc\"}]\n" +
                "    }\n" +
                "]}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer9() throws IOException {
        String xmlString =
                "<c>" +
                "   <b>abc</b>" +
                "   <b type=\"Compound\">" +
                "       <result><a>abc</a></result>" +
                "       <result><a>bcd</a></result>" +
                "   </b>" +
                "</c>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"c\": [\n" +
                "    \"abc\",\n" +
                "    [\n" +
                "        {\"a\": \"abc\"},\n" +
                "        {\"a\": \"bcd\"}\n" +
                "    ]\n" +
                "]}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer10() throws IOException {
        String xmlString =
                "<c>" +
                        "   <b>abc</b>" +
                        "   <b type=\"Compound\">" +
                        "       <result><a>abc</a></result>" +
                        "   </b>" +
                        "</c>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"c\": [\n" +
                "    \"abc\",\n" +
                "    [{\"a\": \"abc\"}]\n" +
                "]}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer11() throws IOException {
        String xmlString =
                "<MODULES type = \"Compound\">" +
                    "<MODULEX>" +
                        "<NAME1 >123</NAME1>" +
                        "<MYFLOAT type=\"Float\">123.4</MYFLOAT>" +
                        "<MYINTEGER type=\"Integer\">123</MYINTEGER>" +
                        "<MYTEXT type=\"Text\">123</MYTEXT>" +
                        "<MY_FLAG type=\"Boolean\">true</MY_FLAG>" +
                        "<MY_FLAG1>true</MY_FLAG1>" +
                        "<EMPTY></EMPTY>" +
                        "<EMPTY2/>" +
                        "<EMPTY3>null</EMPTY3>" +
                        "<MYFLOAT1 type=\"Float\"></MYFLOAT1>" +
                        "<MYFLOAT2 type=\"Float\"/>" +
                    "</MODULEX>" +
                "</MODULES>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"MODULES\": [{\n" +
                "    \"EMPTY2\": null,\n" +
                "    \"MY_FLAG\": true,\n" +
                "    \"EMPTY3\": \"null\",\n" +
                "    \"MYTEXT\": \"123\",\n" +
                "    \"MYFLOAT\": 123.4,\n" +
                "    \"MYINTEGER\": 123,\n" +
                "    \"MY_FLAG1\": \"true\",\n" +
                "    \"EMPTY\": null,\n" +
                "    \"MYFLOAT1\": null,\n" +
                "    \"MYFLOAT2\": null,\n" +
                "    \"NAME1\": \"123\"\n" +
                "}]}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer12() throws IOException {
        String xmlString =
                "<MY_FLAG type=\"Boolean\">true</MY_FLAG>\n" +
                "<MyFlags><MY_FLAG3 type=\"Boolean\"></MY_FLAG3>\n" +
                "<MY_FLAG3 type=\"Boolean\">null</MY_FLAG3>\n" +
                "<MY_FLAG3 type=\"Boolean\">false</MY_FLAG3></MyFlags>\n" +
                "<MY_FLAG4 type=\"Boolean\">null</MY_FLAG4>\n" +
                "<MY_FLAG_BOOLEAN_2 type=\"Boolean\"/>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\n" +
                "    \"MY_FLAG_BOOLEAN_2\": null,\n" +
                "    \"MY_FLAG\": true,\n" +
                "    \"MY_FLAG4\": null,\n" +
                "    \"MyFlags\": [\n" +
                "        null,\n" +
                "        null,\n" +
                "        false\n" +
                "    ]\n" +
                "}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer13() throws IOException {
        String xmlString = loadFileContent("suppliers.xml");
        String resultJson = transform(xmlString);
        writeResult(resultJson);
        String expectedJson = loadFileContent("suppliersResult.json");
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer14() throws Exception {
        // Not expecting to be an array
        String xmlString =
                "<a>" +
                "   <b>abc</b>" +
                "   <results>" +
                "       <result>1</result>" +
                "   </results>" +
                "</a>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"a\": {\n" +
                "    \"b\": \"abc\",\n" +
                "    \"results\": {\"result\": \"1\"}\n" +
                "}}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer15() throws Exception {
        String xmlString =
                "<result><value1 attr=\"val1\">1</value1>" +
                        "<value2 type=\"Integer\" attr=\"val2\">2</value2>" +
                "</result>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"result\": {\n" +
                "    \"value2\": {\n" +
                "        \"attr\": \"val2\",\n" +
                "        \"content\": 2\n" +
                "    },\n" +
                "    \"value1\": {\n" +
                "        \"attr\": \"val1\",\n" +
                "        \"content\": \"1\"\n" +
                "    }\n" +
                "}}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer16() throws Exception {
        String xmlString =
                "<result><value attr=\"val1\">1</value>" +
                "<value type=\"Integer\" attr=\"val2\">2</value>" +
                "</result>";
        String resultJson = transform(xmlString);
        String expectedJson = "{\"result\": [\n" +
                "    {\n" +
                "        \"attr\": \"val1\",\n" +
                "        \"content\": \"1\"\n" +
                "    },\n" +
                "    {\n" +
                "        \"attr\": \"val2\",\n" +
                "        \"content\": 2\n" +
                "    }\n" +
                "]}";
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    @Test
    public void testTransformer17() throws IOException {
        String xmlString = loadFileContent("project.xml");
        String resultJson = transform(xmlString);
        String expectedJson = loadFileContent("projectResult.json");
        Assert.assertEquals(expectedJson.trim(), resultJson.trim());
        writeResult(resultJson);
    }

    private String loadFileContent(String fileName) throws IOException {
        URL resource = getClass().getClassLoader().getResource(fileName);
        File file = new File(Objects.requireNonNull(resource).getFile());
        return new String(Files.readAllBytes(file.toPath()));
    }

    private void writeResult(String resultString) throws IOException {
        System.out.println("Result : \n" + resultString);
//        FileWriter myWriter = new FileWriter("./output.json");
//        myWriter.write(resultString);
//        myWriter.close();
    }

    private String transform(String xmlString) {
        JsonTransformer jsonTransformer = new JsonTransformer();
        return jsonTransformer.transform(xmlString);
    }
}
