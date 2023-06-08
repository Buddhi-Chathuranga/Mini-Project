package ifs.fnd.connect;

import ifs.fnd.base.FndContext;
import ifs.fnd.base.IfsException;
import ifs.fnd.connect.readers.ConnectReader.PermanentFailureException;
import ifs.fnd.connect.xml.Transformer;
import ifs.fnd.record.FndRecord;
import ifs.fnd.record.FndSqlType;
import ifs.fnd.record.FndSqlValue;
import ifs.fnd.sf.FndServerContext;
import ifs.fnd.sf.storage.FndConnection;
import ifs.fnd.sf.storage.FndStatement;

import java.io.StringReader;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Objects;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class JsonModelBasedTransformer implements Transformer {

    @Override
    public void init() {
    }

    @Override
    public String transform(String str) throws IfsException {
        try {
            String transformedStr = transformData(str);
            System.out.println("JSON after model-based transformation : " + transformedStr);
            return transformedStr;
        } catch (Exception e) {
            e.printStackTrace();
            throw new PermanentFailureException("Failed transforming data due to error " + e);
        }
    }

    private String transformData(String requestData) throws Exception {
        DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        Document request = builder.parse(new InputSource(new StringReader(requestData)));
        Element reqElement = request.getDocumentElement();
        String data = getData(requestData);
        String projection = getValue(reqElement, "Projection");
        String structureName = getValue(reqElement, "Name");
        if (!projection.isEmpty() && !structureName.isEmpty() && !data.isEmpty()) {
            JSONObject metadataFromDB = getMetadataFromDB(projection);
            return structureXmlToJson(data, metadataFromDB, structureName);
        } else {
            return getDetailsFromContextAndConvert(requestData);
        }
    }

    private String getDetailsFromContextAndConvert(String requestData) throws Exception {
        String projection;
        FndRecord fndRecord = FndContext.getCurrentAppContext();
        String addressData = (String) fndRecord.getAttributeValue("ADDRESS_DATA");
        String addressData2 = (String) fndRecord.getAttributeValue("ADDRESS_DATA_2");
        if ("ACTION".equals(addressData2) && Objects.nonNull(addressData) && !addressData.isEmpty()) {
            String[] dataArray = addressData.split("[.]");
            projection = dataArray[0];
            String actionName = dataArray[1];
            JSONObject metadataFromDB = getMetadataFromDB(projection);
            String structure = getStructureNameFromActionName(metadataFromDB, actionName);
            return structureXmlToJson(requestData, metadataFromDB, structure);
        } else {
            return requestData;
        }
    }

    private String getData(String requestData) {
        if (requestData.contains("<Data>"))
            return requestData.substring(requestData.indexOf("<Data>") + 6, requestData.indexOf("</Data>"));
        else
            return "";
    }

    private String structureXmlToJson(String xml, final JSONObject metadataFromDB,
                                      final String structureName) throws Exception {
        JSONObject data = xmlToJsonGeneric(xml);
        String rootAttributeName = data.keys().next();
        JSONObject jsonObject = transformJsonStructure(data.getJSONObject(rootAttributeName), metadataFromDB, structureName);
        return new JSONObject().put(rootAttributeName, jsonObject).toString();
    }

    private JSONObject transformJsonStructure(JSONObject data, JSONObject projectionMetadata,
                                              final String structureName) throws Exception {
        JSONObject structureMetadata = getStructure(structureName, projectionMetadata);
        JSONArray attributes = structureMetadata.getJSONArray("Attributes");
        for (int i = 0; i < attributes.length(); i++) {
            JSONObject attribute = attributes.getJSONObject(i);
            processAttribute(data, projectionMetadata, attribute);
        }
        return data;
    }

    private void processAttribute(JSONObject data, JSONObject projectionMetadata, JSONObject attribute) throws Exception {
        String attributeName = attribute.getString("Name");
        Object value;
        if (data.has(attributeName)) {
            value = data.get(attributeName);
            boolean isEmptyValueForAttr = (value instanceof JSONObject) && value.toString().equals("{}");
            if (isEmptyValueForAttr) {
                data.remove(attributeName);
                return;
            }
            String dataType = attribute.getString("DataType");
            boolean isCollection = attribute.optBoolean("Collection", false);
            resolveDataTypes(data, attributeName, value, dataType, isCollection);
            if ("Structure".equals(dataType)) {
                if (value instanceof JSONArray) {
                    processJsonArray(projectionMetadata, attribute, value);
                } else if (value instanceof JSONObject && isCollection) {
                    convertToArrayAndPut(data, projectionMetadata, attribute, attributeName, (JSONObject) value);
                } else if ((value instanceof JSONObject) && (((JSONObject) value).length() != 0)) {
                    transformJsonStructure((JSONObject) value, projectionMetadata, attribute.getString("SubType"));
                }
            }
        }
    }

    private void convertToArrayAndPut(JSONObject data, JSONObject projectionMetadata, JSONObject attribute,
                                      String attributeName, JSONObject jsonObject) throws Exception {
        HashSet<String> keySet = getKeySetFromIterator(jsonObject.keys());
        if (keySet.size() == 1) {
            Object object = jsonObject.get(jsonObject.keys().next());
            if (object instanceof JSONArray) {
                data.remove(attributeName);
                data.put(attributeName, object);
                processJsonArray(projectionMetadata, attribute, object);
            } else if (object instanceof JSONObject) {
                JSONArray newJsonArray = convertObjectToArray((JSONObject) object);
                data.remove(attributeName);
                data.put(attributeName, newJsonArray);
                processJsonArray(projectionMetadata, attribute, newJsonArray);
            } else {
                throw new Exception("Model based transformation error : XML and the structure metadata does not match");
            }
        } else {
            throw new Exception("Model based transformation error : XML and the structure metadata does not match");
        }
    }

    private void resolveDataTypes(JSONObject data, String attributeName, Object value, String dataType, boolean isCollection) {
        if (isCollection && value.getClass() != JSONArray.class) {
            data.remove(attributeName);
            data.put(attributeName, new JSONArray().put(value));
        } else if ("Text".equals(dataType) && !(value instanceof String)) {
            data.remove(attributeName);
            data.put(attributeName, String.valueOf(value));
        } else if ("Boolean".equals(dataType)) {
            data.remove(attributeName);
            data.put(attributeName, Boolean.valueOf((String) value));
        } else if ("Number".equals(dataType) || "Integer".equals(dataType)) {
            resolveNumberDataType(data, attributeName, (String) value);
        }
    }

    private void resolveNumberDataType(JSONObject data, String attributeName, String valueStr) {
        data.remove(attributeName);
        if (valueStr.contains("."))
            data.put(attributeName, Double.valueOf(valueStr));
        else
            data.put(attributeName, Integer.valueOf(valueStr));
    }

    private void processJsonArray(JSONObject projectionMetadata, JSONObject attribute, Object value) throws Exception {
        JSONArray valueArray = (JSONArray) value;
        for (int j = 0; j < valueArray.length(); j++) {
            if (valueArray.getJSONObject(j).length() != 0) {
                transformJsonStructure(valueArray.getJSONObject(j), projectionMetadata, attribute.getString("SubType"));
            }
        }
    }

    private JSONArray convertObjectToArray(JSONObject jsonObject) {
        JSONArray newJsonArray = new JSONArray();
        newJsonArray.put(jsonObject);
        return newJsonArray;
    }

    private HashSet<String> getKeySetFromIterator(Iterator<String> keys) {
        HashSet<String> keySet = new HashSet<>();
        while (keys.hasNext()) {
            String key = keys.next();
            keySet.add(key);
        }
        return keySet;
    }

    private JSONObject xmlToJsonGeneric(String xml) throws JSONException {
        return org.json.XML.toJSONObject(xml, true);
    }

    private JSONObject getStructure(String structureName, JSONObject projectionMeta) throws Exception {
        JSONArray entityArray = projectionMeta.getJSONObject("projection").getJSONArray("Structures");
        for (int i = 0; i < entityArray.length(); i++) {
            if (entityArray.getJSONObject(i).getString("Name").equals(structureName)) {
                return entityArray.getJSONObject(i);
            }
        }
        throw new Exception(String.format("Model based transformation error : Structure %s not found", structureName));
    }

    private String getStructureNameFromActionName(JSONObject projectionMeta, String actionName) throws Exception {
        JSONArray actionsArray = projectionMeta.getJSONObject("projection").getJSONObject("Container").getJSONArray("Actions");
        for (int i = 0; i < actionsArray.length(); i++) {
            JSONObject jsonObject = actionsArray.getJSONObject(i);
            String actionNameStr = jsonObject.getString("Name");
            if (actionName.equals(actionNameStr)) {
                return jsonObject.getJSONArray("Parameters").getJSONObject(0).getString("SubType");
            }
        }
        throw new Exception(String.format("Model based transformation error : Structure not found for action %s", actionName));
    }

    private JSONObject getMetadataFromDB(String projectionName) throws IfsException, JSONException {
        FndConnection con = getConnection();
        return new JSONObject(readMetadata(projectionName, con));
    }

    private String readMetadata(final String projectionName, final FndConnection connection) throws IfsException {
        final String statement =
                "DECLARE\n" +
                        "BEGIN\n" +
                        "? := Model_Design_SYS.Get_Data_Content_(Model_Design_SYS.SERVER_METADATA, " +
                        "'projection', ? , language_ => Fnd_Session_API.Get_Language);\n" +
                        "END;";
        try (final FndStatement callableStatement = connection.createStatement()) {
            callableStatement.defineOutParameter("Result", FndSqlType.LONG_TEXT);
            callableStatement.defineInParameter(new FndSqlValue("projection", projectionName));
            callableStatement.prepareCall(statement);
            callableStatement.execute();
            return callableStatement.getLongText(1);
        }
    }

    private FndConnection getConnection() throws IfsException {
        return FndServerContext.getCurrentServerContext().getConnectionManager().getPlsqlConnection();
    }

    private String getValue(Element element, String tag) {
        String value = "";
        NodeList nl = element.getElementsByTagName(tag);
        if (nl.getLength() > 0 && nl.item(0).hasChildNodes()) {
            value = nl.item(0).getFirstChild().getNodeValue();
        }
        return value;
    }
}
