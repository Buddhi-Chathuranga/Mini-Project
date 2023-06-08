/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *
 *
 * ---------------------------------------------------------------------------
 *
 *  Logical unit: SharedSecret
 *  Component:    FNDBAS
 *
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import com.ifsworld.fndadm.projection.util.IdentityAndAccessHandlingUtils;
import static com.ifsworld.fndadm.projection.util.IdentityAndAccessHandlingUtils.jsonToBytes;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.json.Json;
import javax.json.JsonObjectBuilder;
import org.apache.logging.log4j.util.Strings;

/*
 * Implementation class for all global actions defined in the SharedSecret projection model.
 */

@Stateless(name="SharedSecretActions")
@TransactionAttribute(value = TransactionAttributeType.REQUIRED)
public class SharedSecretActionsImpl implements SharedSecretActions {
   
   private static final Logger LOGGER = Logger.getLogger(SharedSecretActionsImpl.class.getName());

   @Override
   public Map<String, Object> setSecret(Map<String, Object> parameters, Connection connection) {
      Map<String, Object> rec = new HashMap<>();      
      final JsonObjectBuilder builder = Json.createObjectBuilder();
      
      String userName = (String) parameters.get("Id");
      String secret = (String) parameters.get("Secret");
      if (secret.isEmpty()) {
         try {
            secret = generateKey();
         } catch (NoSuchAlgorithmException ex) {
            throw new ProjectionException("Could not generate a key: " + ex.getMessage(), ex);
         }
      }
      
      Map<String, Object> attributesObject = new HashMap<>();
      attributesObject.put("sharedSecret", secret);
      Map<String, Object> putParams = new HashMap<>();
      putParams.put("attributes", attributesObject);
     
      String userId = Strings.EMPTY;
      try {
         userId = IdentityAndAccessHandlingUtils.getUserId(userName);
      } catch (ProjectionException pe) {
         Map<String, Object> userSyncParams = new HashMap<>();
         userSyncParams.put("username", userName);
         try {
            IdentityAndAccessHandlingUtils.postResource("/F1/users", userSyncParams, IdentityAndAccessHandlingUtils.IAM_URL + "/auth/realms/" + IdentityAndAccessHandlingUtils.IAM_REALM);
            userId = IdentityAndAccessHandlingUtils.getUserId(userName);
         } catch (IOException ex) {
            throw new ProjectionException("Could not sync user: " + ex.getMessage(), ex);
         }
      }
      
      try {
         IdentityAndAccessHandlingUtils.putResource("/users/" + userId, putParams);
      } catch (IOException ex) {
         throw new ProjectionException("Exception while saving secret: " + ex.getMessage(), ex);
      }
      
      builder.add("Id", (Boolean) true);
      rec.put("SetSecret", jsonToBytes(builder));
      return rec;
   }
   
   private static String generateKey() throws NoSuchAlgorithmException {

      KeyGenerator generator = KeyGenerator.getInstance("HmacSHA1");
      generator.init(96);
      SecretKey key = generator.generateKey();
      String encodedKey = encodeHexString(key.getEncoded());
      return encodedKey;
   }
   
   private static String encodeHexString(byte[] byteArray) {
      StringBuilder hexStringBuffer = new StringBuilder();
      for (int i = 0; i < byteArray.length; i++) {
         hexStringBuffer.append(byteToHex(byteArray[i]));
      }
      return hexStringBuffer.toString();
   }
   
      protected static String byteToHex(byte num) {
      char[] hexDigits = new char[2];
      hexDigits[0] = Character.forDigit((num >> 4) & 0xF, 16);
      hexDigits[1] = Character.forDigit((num & 0xF), 16);
      return new String(hexDigits);
   }
   
}