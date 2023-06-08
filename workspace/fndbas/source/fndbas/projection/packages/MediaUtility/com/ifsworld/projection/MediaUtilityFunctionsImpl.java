/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio 9.802.3010.20161103
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: MediaUtility
 *  Type:         Projection
 *  Component:    FNDBAS
 *
 * ---------------------------------------------------------------------------
 */
package com.ifsworld.projection;

import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import com.sun.media.jai.codec.SeekableStream;
import com.sun.media.jai.codec.TIFFDecodeParam;
import com.sun.media.jai.codec.TIFFDirectory;

import java.awt.image.renderable.ParameterBlock;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.ejb.Stateless;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.imageio.ImageIO;
import javax.media.jai.JAI;
import javax.media.jai.PlanarImage;

/*
 * Implementation class for all global functions defined in the MediaUtility projection model.
 * Note: Functions should not change database state!
 *       Functinality also depends on the docman DocmanFileOperationUtil class. Without which there will be a runtime exception.
 */

@Stateless(name = "MediaUtilityFunctions")
public class MediaUtilityFunctionsImpl implements MediaUtilityFunctions {

   private Map<String, Object> getViewFile(final Map<String, Object> parameters, final Connection connection) {
      final Class<?>[] parameterTypes = new Class<?>[]{Map.class, Connection.class};
      final Object[] args = new Object[]{parameters, connection};
      Class<?> docmanFileOperationUtil;
      Object fileOpUtil;
      Method method;
      String message;
      try {
         docmanFileOperationUtil =
                 Class.forName("com.ifsworld.docman.projection.util.DocmanFileOperationUtil");
         fileOpUtil = docmanFileOperationUtil.newInstance();
         method = docmanFileOperationUtil.getMethod("viewFile", parameterTypes);
         return (Map<String, Object>) method.invoke(fileOpUtil, args);
      } catch (ProjectionException ex) {
         message = ex.getCause().getMessage();
         if (message == null) {
            throw new ProjectionException("Error in Document Management library.", ex, ex.getCustomCode());
         } else {
            throw new ProjectionException(message, ex, ex.getCustomCode());
         }
      } catch (ClassNotFoundException
              | InstantiationException
              | IllegalAccessException
              | NoSuchMethodException
              | SecurityException
              | IllegalArgumentException
              | InvocationTargetException ex) {
         message = ex.getCause().getMessage();
         if (message == null) {
            throw new ProjectionException("Error in Document Management library.");
         } else {
            throw new ProjectionException(message);
         }
      }
   }

   private String getFileExtention(final String filename) {
      final Class<?>[] parameterTypes = new Class<?>[]{String.class};
      final Object[] args = new Object[]{filename};
      Class<?> docmanFileOperationUtil;
      Object fileOpUtil;
      Method method;
      try {                                       
         docmanFileOperationUtil = Class.forName("com.ifsworld.docman.projection.util.DocmanFileOperationUtil");
         fileOpUtil = docmanFileOperationUtil.newInstance();
         method = docmanFileOperationUtil.getMethod("getFileExtention", parameterTypes);
         return (String) method.invoke(fileOpUtil, args);
      } catch (ProjectionException ex) {
         throw new ProjectionException("Error in Document Management library.", ex, ex.getCustomCode());
      } catch (ClassNotFoundException
              | InstantiationException
              | IllegalAccessException
              | NoSuchMethodException
              | SecurityException
              | IllegalArgumentException
              | InvocationTargetException ex) {
         throw new ProjectionException("Document Management library not found.", ex);
      }
   }

   @Override
   public Map<String, Object> tiffToPng(final Map<String, Object> parameters, final Connection connection) {
      int pageNo = ((Long) parameters.get("PageNo")).intValue();
      Map<String, Object> fileInfo = getViewFile(parameters, connection);
      InputStream in = (InputStream) fileInfo.get("ViewFile");
      final List<PlanarImage> planarImages = readTiffImage(in);

      OutputStream out = new ByteArrayOutputStream();
      final PlanarImage planarImage = planarImages.get(pageNo - 1);

      try {
         ImageIO.write(planarImage, "png", out);
      } catch (IOException ex) {
         throw new ProjectionException("Error writing image data.", ex);
      }

      InputStream result = new ByteArrayInputStream(((ByteArrayOutputStream) out).toByteArray());

      Map<String, Object> objectMap = new HashMap<>();
      objectMap.put("TiffToPng", result);
      objectMap.put("FileName", String.format("%s_%s.png", (String) fileInfo.get("FileName"), pageNo));
      return objectMap;

   }

   @Override
   public Map<String, Object> getFileMetadata(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> fileInfo = getViewFile(parameters, connection);
      InputStream in = (InputStream) fileInfo.get("ViewFile");
      final String fileName = (String) fileInfo.get("FileName");
      final String fileExt = getFileExtention(fileName).toUpperCase();
      final int pageCount;
      if (fileExt.startsWith("TIF")) {
         final List<PlanarImage> planarImages = readTiffImage(in);
         pageCount = planarImages.size();
      } else {
         pageCount = 1;
      }

      StringBuilder sb = new StringBuilder();
      sb.append("{\n");
      sb.append("\"PageCount\":").append(pageCount).append(",\n");
      sb.append("\"Extension\":\"").append(fileExt).append("\"\n");
      sb.append("}");

      Map<String, Object> responseMap = new HashMap<>();
      responseMap.put("GetFileMetadata", new ByteArrayInputStream(sb.toString().getBytes()));

      return responseMap;
   }

   private List<PlanarImage> readTiffImage(InputStream in) {
      List<PlanarImage> images = new ArrayList<>();

      SeekableStream s = SeekableStream.wrapInputStream(in, true);
      ParameterBlock pb = new ParameterBlock();
      pb.add(s);

      TIFFDecodeParam param = new TIFFDecodeParam();
      pb.add(param);

      long nextOffset = 0;
      do {
         PlanarImage pi = JAI.create("tiff", pb);
         TIFFDirectory dir = (TIFFDirectory) pi.getProperty("tiff_directory");

         images.add(pi);
         nextOffset = dir.getNextIFDOffset();

         if (nextOffset != 0) {
            param.setIFDOffset(nextOffset);
         }
      } while (nextOffset != 0);

      return images;
   }

   @Override
   public Map<String, Object> getFileStream(Map<String, Object> parameters, Connection connection) {
      Map<String, Object> fileInfo = getViewFile(parameters, connection);
      Object stream = fileInfo.remove("ViewFile");
      fileInfo.put("GetFileStream", stream);
      return fileInfo;
   }
}