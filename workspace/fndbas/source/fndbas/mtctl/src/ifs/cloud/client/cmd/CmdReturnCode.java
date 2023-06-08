package ifs.cloud.client.cmd;

import ifs.cloud.client.cli.ReturnCode;

public class CmdReturnCode extends ReturnCode {
   /* timeout waiting for status */
   public static final CmdReturnCode Timeout = new CmdReturnCode(11);
   /* some of the resources are not ready */
   public static final CmdReturnCode PartiallyFailed = new CmdReturnCode(12);

   private CmdReturnCode(int code) {
      super(code);
   }
}
