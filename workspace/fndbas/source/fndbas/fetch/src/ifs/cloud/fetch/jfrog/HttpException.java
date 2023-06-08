package ifs.cloud.fetch.jfrog;

import ifs.cloud.fetch.FetchException;

public class HttpException extends FetchException {

   private static final long serialVersionUID = 1L;
   private final int code;

   public HttpException(String message, int code) {
      super(message);
      this.code = code;
   }

   public HttpException(Throwable cause) {
      super(cause);
      code = -1;
   }

   public int getCode() {
      return code;
   }

   public String toString() {
      switch (code) {
      case 202:
         return "202 Accepted.";
      case 208:
         return "208 Already Reported.";
      case 502:
         return "502 Bad Gateway.";
      case 400:
         return "400 Bad Request.";
      case 409:
         return "409 Conflict.";
      case 100:
         return "100 Continue.";
      case 201:
         return "201 Created.";
      case 421:
         return "421 Destination Locked.";
      case 417:
         return "417 Expectation Failed.";
      case 424:
         return "424 Failed Dependency.";
      case 403:
         return "403 Forbidden.";
      case 302:
         return "302 Found.";
      case 504:
         return "504 Gateway Timeout.";
      case 410:
         return "410 Gone.";
      case 505:
         return "505 HTTP Version Not Supported.";
      case 226:
         return "226 IM Used.";
      case 419:
         return "419 Insufficient Space on Resource.";
      case 507:
         return "507 Insufficient Storage.";
      case 500:
         return "500 Internal Server Error.";
      case 411:
         return "411 Length Required.";
      case 423:
         return "423 Locked.";
      case 508:
         return "508 Loop Detected.";
      case 420:
         return "420 Method Failure.";
      case 405:
         return "405 Method Not Allowed.";
      case 301:
         return "301 Moved Permanently.";
      case 207:
         return "207 Multi-Status.";
      case 300:
         return "300 Multiple Choices.";
      case 204:
         return "204 No Content.";
      case 203:
         return "203 Non-Authoritative Information.";
      case 406:
         return "406 Not Acceptable.";
      case 510:
         return "510 Not Extended";
      case 404:
         return "404 Not Found.";
      case 501:
         return "501 Not Implemented.";
      case 304:
         return "304 Not Modified.";
      case 200:
         return "200 OK.";
      case 206:
         return "206 Partial Content.";
      case 402:
         return "402 Payment Required.";
      case 412:
         return "412 Precondition failed.";
      case 102:
         return "102 Processing.";
      case 407:
         return "407 Proxy Authentication Required.";
      case 413:
         return "413 Request Entity Too Large.";
      case 408:
         return "408 Request Timeout.";
      case 414:
         return "414 Request-URI Too Long.";
      case 416:
         return "416 Requested Range Not Satisfiable.";
      case 205:
         return "205 Reset Content.";
      case 303:
         return "303 See Other.";
      case 503:
         return "503 Service Unavailable.";
      case 101:
         return "101 Switching Protocols.";
      case 307:
         return "307 Temporary Redirect.";
      case 401:
         return "401 Unauthorized.";
      case 422:
         return "422 Unprocessable Entity.";
      case 415:
         return "415 Unsupported Media Type.";
      case 426:
         return "426 Upgrade Required.";
      case 305:
         return "305 Use Proxy.";
      case 506:
         return "506 Variant Also Negotiates.";
      }
      return super.toString();
   }
}
