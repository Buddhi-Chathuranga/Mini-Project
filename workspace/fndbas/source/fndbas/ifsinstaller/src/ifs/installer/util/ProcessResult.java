package ifs.installer.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ProcessResult {

   private Process p;
   private String result;

   public ProcessResult(Process p, String result) {
      this.p = p;
      this.result = result;
   }

   public Process getProcess() {
      return p;
   }

   public String getResult() {
      return result;
   }

   public String getWashedResult() {
      return wash(result);
   }

   /* Wash off passwords and other sensitive information */
   private String wash(final String input) {
      String blurred = input.concat(" ");
      blurred = blurLine("(\\bglobal.imageCredentials.username=)(.*?\\s)", blurred);
      blurred = blurLine("(\\bhelmUser=)(.*?\\s)", blurred);
      blurred = blurLine("(\\bhelmPwd=)(.*?\\s)", blurred);
      blurred = blurLine("(\\b\\S*secret\\S*=)(.*?\\s)", blurred);
      blurred = blurLine("(\\b\\S*password\\S*=)(.*?\\s)", blurred);
      return blurred;
   }

   private String blurLine(String var, String input) {
      Pattern p = Pattern.compile(var, Pattern.CASE_INSENSITIVE);
      Matcher m = p.matcher(input);

      if (m.find()) {
         return m.replaceAll("$1****** ");
      }
      return input;
   }
}
