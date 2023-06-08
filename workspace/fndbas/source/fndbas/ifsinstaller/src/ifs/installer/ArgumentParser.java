package ifs.installer;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.LinkedHashMap;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

import ifs.installer.util.Helper;

public class ArgumentParser {

   private ArgumentParser() {
   }

   public static Map<String, Object> parse(String... args) throws IOException {
      Map<String, Object> arguments = new LinkedHashMap<>();
      Map<String, Object> argumentsSet = new LinkedHashMap<>();
      for (int index = 0; index < args.length; index += 2) {
         String nextArg = args[index];
         if (index == args.length - 1) {
            System.err.println("Ignoring dangling value: " + args[index]);
            break;
         }
         switch (nextArg) {
         case "-f":
         case "--values":
            arguments.putAll(readYaml(args[index + 1]));
            break;
         case "--set-file":
            String[] setFile = setFile(args[index + 1]);
            argumentsSet.put(setFile[0], setFile[1]);
            break;
         case "--set":
         case "--set-string":
            argumentsSet.putAll(set(args[index + 1]));
            break;
         case "--kubeconfig":
            parse(arguments, "kubeconfigFlag", "--kubeconfig", args[index + 1]);
            break;
         case "--context":
            parse(arguments, "kubeconfigFlag", "--context", args[index + 1]);
            break;
         default:
            index--;
         }
      }

      arguments.putAll(argumentsSet);
      return arguments;
   }

   private static void parse(Map<String, Object> arguments, String key, String envKey, String envValue) {
      
      String temp = arguments.containsKey(key) ? (String)arguments.get(key) + " " : "";
      temp += envKey + " " + envValue;
      arguments.put(key, temp);
   }
   
   @SuppressWarnings("unchecked")
   private static Map<String, Object> readYaml(String yamlFile) throws FileNotFoundException {
      Yaml yaml = new Yaml();
      InputStream inputStream = new FileInputStream(new File(yamlFile));

      Map<String, Object> values = new LinkedHashMap<>();
      for (Object data : yaml.loadAll(inputStream)) {
         if (data instanceof Map<?, ?>) {
            values.putAll(getFlatMap((Map<String, Object>) data, ""));
         }
      }
      return values;
   }

   @SuppressWarnings("unchecked")
   private static Map<String, Object> getFlatMap(Map<String, Object> map, String root) {
      Map<String, Object> values = new LinkedHashMap<>();
      for (String s : map.keySet()) {
         if (map.get(s) instanceof Map<?, ?>) {
            values.putAll(
                  getFlatMap((Map<String, Object>) map.get(s), "".equals(root) ? s : root.concat(".").concat(s)));
         } else {
            values.put("".equals(root) ? s : root.concat(".").concat(s), map.get(s));
         }
      }
      return values;
   }

   private static String[] setFile(String keyValuePair) throws IOException {
      String[] keyValue = keyValuePair.split("=");
      if (keyValue.length != 2) {
         throw new IOException("Unable to parse argument " + keyValuePair + " for --set-file");
      }
      return new String[] { keyValue[0], Helper.readFile(keyValue[1]) };
   }

   private static Map<String, Object> set(String setCommand) throws IOException {
      String[] setCommandArr = setCommand.split("(?<!\\\\),");
      Map<String, Object> result = new LinkedHashMap<>();
      for (String s : setCommandArr) {
         String[] keyValue = s.split("=", 2);
         if (keyValue.length == 1) {
            throw new IOException("--set/--set-string must be followed by a key=value. Failed to parse " + s);
         }
         result.put(keyValue[0], keyValue[1]);
      }
      return result;
   }
}
