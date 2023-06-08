package ifs.fnd.connect;

import ifs.fnd.base.IfsException;
import ifs.fnd.connect.xml.Transformer;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.XML;

import java.util.HashSet;
import java.util.Iterator;

public class JsonTransformer implements Transformer {

    @Override
    public void init() throws IfsException {
    }

    @Override
    public String transform(String xmlString) {
        JSONObject jsonObject = XML.toJSONObject(xmlString);
        processJsonObject(jsonObject);
        return jsonObject.toString(4);
    }

    private void processJsonObject(JSONObject jsonObject) {
        HashSet<String> subKeySet = getKeySetFromIterator(jsonObject.keys());
        String type = extractType(jsonObject, subKeySet);
        for (String key : subKeySet) {
            Object object = jsonObject.get(key);
            if (isSingleObjectArray(object, type)) {
                JSONArray newJsonArray = convertObjectToArray((JSONObject) object);
                jsonObject.put(key, processJsonArray(newJsonArray));
            } else if (object instanceof JSONObject) {
                JSONObject subJsonObject = (JSONObject) object;
                processInnerJsonObject(jsonObject, key, subJsonObject);
            } else if (object instanceof JSONArray) {
                JSONArray jsonArray = (JSONArray) object;
                jsonObject.put(key, processJsonArray(jsonArray));
            } else if (isEmptyString(object)) {
                jsonObject.put(key, JSONObject.NULL);
            } else {
                jsonObject.put(key, String.valueOf(object));
            }
        }
    }

    private JSONArray processJsonArray(JSONArray jsonArray) {
        int arrayLength = jsonArray.length();
        for (int i = 0; i < arrayLength; i++) {
            Object subArrayObject = jsonArray.get(i);
            if (subArrayObject instanceof JSONObject) {
                JSONArray cloneArray = new JSONArray(jsonArray.toString());
                processJsonObjectOfArray((JSONObject) subArrayObject, i, cloneArray);
                jsonArray = cloneArray;
            } else if (subArrayObject instanceof JSONArray) {
                JSONArray cloneArray = new JSONArray(jsonArray.toString());
                cloneArray.put(i, processJsonArray((JSONArray) subArrayObject));
                jsonArray = cloneArray;
            } else {
                jsonArray.put(i, String.valueOf(subArrayObject));
            }
        }
        return jsonArray;
    }

    private void processJsonObjectOfArray(JSONObject subArrayObject, int index, JSONArray jsonArray) {
        HashSet<String> subKeySet = getKeySetFromIterator(subArrayObject.keys());
        String type = extractType(subArrayObject, subKeySet);
        if (subArrayObject.length() == 0) jsonArray.put(index, JSONObject.NULL);
        for (String subKey : subKeySet) {
            Object object = subArrayObject.opt(subKey);
            if (isSingleObjectArray(object, type)) {
                JSONArray newJsonArray = convertObjectToArray(subArrayObject);
                jsonArray.put(index, newJsonArray);
            } else if (object instanceof JSONObject) {
                processInnerJsonObject(subArrayObject, subKey, (JSONObject) object);
                jsonArray.put(index, subArrayObject);
            } else if (object instanceof JSONArray) {
                jsonArray.put(index, processJsonArray((JSONArray) object));
            } else if ("content".equals(subKey)) {
                if (!type.isEmpty() && subKeySet.size() < 2) convertAndPutToArray(jsonArray, type, object, index);
                else convertAndPutToObject(subArrayObject, "content", type, object);
            } else if ("xsi:nil".equals(subKey)) {
                jsonArray.put(index, JSONObject.NULL);
            } else if (isEmptyString(object)) {
                subArrayObject.put(subKey, JSONObject.NULL);
                jsonArray.put(index, subArrayObject);
            } else {
                subArrayObject.put(subKey, String.valueOf(object));
                jsonArray.put(index, subArrayObject);
            }
        }
    }

    private void processInnerJsonObject(JSONObject jsonObject, String key, JSONObject subJsonObject) {
        HashSet<String> subKeySet = getKeySetFromIterator(subJsonObject.keys());
        String type = extractType(subJsonObject, subKeySet);
        if (subJsonObject.length() == 0) jsonObject.put(key, JSONObject.NULL);
        for (String subKey : subKeySet) {
            Object object = subJsonObject.opt(subKey);
            if (isSingleObjectArray(subJsonObject, type)) {
                JSONArray newJsonArray = convertObjectToArray(subJsonObject);
                jsonObject.put(key, processJsonArray(newJsonArray));
            } else if (object instanceof JSONObject) {
                processInnerJsonObject(subJsonObject, subKey, (JSONObject) object);
                jsonObject.put(key, subJsonObject);
            } else if (object instanceof JSONArray) {
                jsonObject.put(key, processJsonArray((JSONArray) object));
            } else if ("content".equals(subKey)) {
                if (!type.isEmpty() && subKeySet.size() < 2) convertAndPutToObject(jsonObject, key, type, object);
                else convertAndPutToObject(subJsonObject, "content", type, object);
            } else if ("xsi:nil".equals(subKey)) {
                jsonObject.put(key, JSONObject.NULL);
            } else if (isEmptyString(object)) {
                subJsonObject.put(subKey, JSONObject.NULL);
                jsonObject.put(key, subJsonObject);
            } else {
                subJsonObject.put(subKey, String.valueOf(object));
                jsonObject.put(key, subJsonObject);
            }
        }
    }

    private boolean isSingleObjectArray(Object object, String type) {
        boolean isSingleObjectArray = false;
        if (object instanceof JSONObject) {
            JSONObject jsonObject = (JSONObject) object;
            if ((jsonObject.length() == 1) && "Compound".equals(type)) {
                isSingleObjectArray = true;
            }
        }
        return isSingleObjectArray;
    }

    private JSONArray convertObjectToArray(JSONObject jsonObject) {
        Object innerObject = jsonObject.get(jsonObject.keys().next());
        if (innerObject instanceof JSONArray) {
            return (JSONArray) innerObject;
        } else {
            JSONArray newJsonArray = new JSONArray();
            newJsonArray.put(innerObject);
            return newJsonArray;
        }
    }

    private void convertAndPutToObject(JSONObject jsonObject, String key, String type, Object object) {
        if ("Integer".equals(type))
            jsonObject.put(key, Integer.valueOf(String.valueOf(object)));
        else if ("Float".equals(type) || "Decimal".equals(type))
            jsonObject.put(key, Double.valueOf(String.valueOf(object)));
        else if ("Text".equals(type) || "Date".equals(type) || "Time".equals(type) || "TimeStamp".equals(type))
            jsonObject.put(key, String.valueOf(object));
        else if ("Boolean".equals(type)) {
            object = "null".equals(String.valueOf(object)) ? JSONObject.NULL : Boolean.valueOf(String.valueOf(object));
            jsonObject.put(key, object);
        } else {
            jsonObject.put(key, String.valueOf(object));
        }
    }

    private void convertAndPutToArray(JSONArray jsonArray, String type, Object object, int index) {
        if ("Integer".equals(type))
            jsonArray.put(index, Integer.valueOf(String.valueOf(object)));
        else if ("Float".equals(type) || "Decimal".equals(type))
            jsonArray.put(index, Double.valueOf(String.valueOf(object)));
        else if ("Text".equals(type) || "Date".equals(type) || "Time".equals(type) || "TimeStamp".equals(type))
            jsonArray.put(index, String.valueOf(object));
        else if ("Boolean".equals(type)) {
            object = "null".equals(String.valueOf(object)) ? JSONObject.NULL : Boolean.valueOf(String.valueOf(object));
            jsonArray.put(index, object);
        } else {
            jsonArray.put(index, String.valueOf(object));
        }
    }

    private HashSet<String> getKeySetFromIterator(Iterator<String> keys) {
        HashSet<String> keySet = new HashSet<>();
        while (keys.hasNext()) {
            String key = keys.next();
            keySet.add(key);
        }
        return keySet;
    }

    private boolean isEmptyString(Object object) {
        return object instanceof String && ((String) object).isEmpty();
    }

    private String extractType(JSONObject jsonObject, HashSet<String> subKeySet) {
        String type = "";
        if (subKeySet.contains("type")) {
            type = jsonObject.getString("type");
            jsonObject.remove("type");
            subKeySet.remove("type");
        }
        return type;
    }
}
