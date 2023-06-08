/*
 *                 IFS Research & Development
 *
 *  This program is protected by copyright law and by international
 *  conventions. All licensing, renting, lending or copying (including
 *  for private use), and all other use of the program, which is not
 *  expressively permitted by IFS Research & Development (IFS), is a
 *  violation of the rights of IFS. Such violations will be reported to the
 *  appropriate authorities.
 *
 *  VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 *  TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 */
package ifs.cloud.fsmigtool.utils;

/**
 * @author IFS RnD
 */
public class Constants {

   //Request headers and their constant values
   public static final String IFS_DEPOSITION_HEADER                = "x-ifs-content-disposition";
   public static final String DISPOSITION_HEADER_VALUE_PREFIX      = "attachment;filename=";
   public static final String CONTENT_LENGTH_HEADER                = "content-length";
   public static final String CONTENT_TYPE_HEADER                  = "content-type";
   public static final String UPLOAD_CONTENT_TYPE_HEADER_VALUE     = "application/octet-stream";
   public static final String CREATE_VRT_CONTENT_TYPE_HEADER_VALUE = "application/json";
   public static final String FS_DELETE_CONTENT_TYPE_HEADER_VALUE  = "application/json";
   public static final String GET_AUTH_CONTENT_TYPE_HEADER_VALUE   = "application/x-www-form-urlencoded";
   public static final String IF_MATCH_HEADER                      = "If-Match";
   public static final String ACCEPT_TYPE_HEADER                   = "Accept";
   public static final String ACCEPT_TYPE_HEADER_VALUE             = "application/json";
   public static final String AUTH_HEADER                          = "Authorization";
   public static final String AUTH_HEADER_VALUE_PREFIX             = "Bearer ";
   public static final String ETAG_HEADER                          = "etag";

   //OAuth2.0 token
   public static final String ACCESS_TOKEN = "access_token";
   public static final String REFRESH_TOKEN = "refresh_token";

   //URL
   public static final String CREATE_FS_UPLOAD_VRT_URL = "/main/ifsapplications/projection/v1/FssMigrationHandling.svc/Reference_FileInfoVirtual";
   public static final String CLEANUP_FS_UPLOAD_VRT_URL = "/main/ifsapplications/projection/v1/FssMigrationHandling.svc/RemoveTempFileReferences";
   public static final String FS_UPLOAD_URL = "/main/ifsapplications/projection/v1/FssMigrationHandling.svc/Reference_FileInfoVirtual(Objkey='%s')/FileData";
   public static final String FS_DELETE_URL = "/main/ifsapplications/projection/v1/FssMigrationHandling.svc/RemoveFileData";
      
   //Create FS upload vrt request body
   public static final String BUCKET_NAME_PROPERTY = "BucketName";
   public static final String FILE_ID_PROPERTY = "FileId";
   public static final String FILE_NAME_PROPERTY = "FileName";
   
   //fs_mig_status_tab statuses
   public static final String TRANSFER_STATUS_INPROGRESS = "In Progress";
   public static final String TRANSFER_STATUS_DONE = "Done";
   public static final String TRANSFER_STATUS_FAILED = "Failed";
   
}
