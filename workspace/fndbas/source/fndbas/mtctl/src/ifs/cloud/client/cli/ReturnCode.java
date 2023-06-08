package ifs.cloud.client.cli;

public class ReturnCode {
   public static final ReturnCode Success = new ReturnCode(0);
   public static final ReturnCode Failed = new ReturnCode(1);
   public static final ReturnCode NoArgs = new ReturnCode(2);
   public static final ReturnCode Exception = new ReturnCode(3);
   
   private final int code;

   protected ReturnCode(int code) {
      this.code = code;
   }

   public int toInt() {
      return code;
   }
}
