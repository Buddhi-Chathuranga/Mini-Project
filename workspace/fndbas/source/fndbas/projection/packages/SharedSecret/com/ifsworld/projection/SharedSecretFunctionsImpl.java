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

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ifsworld.fndadm.projection.util.IdentityAndAccessHandlingUtils;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import javax.ejb.Stateless;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;

/*
 * Implementation class for all global functions defined in the SharedSecret projection model.
 * Note: Functions should not change database state!
 */

@Stateless(name="SharedSecretFunctions")
public class SharedSecretFunctionsImpl implements SharedSecretFunctions {
   
   private static final Logger LOGGER = Logger.getLogger(SharedSecretFunctionsImpl.class.getName());
   private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

   @Override
   public Map<String, Object> getSecret(final Map<String, Object> parameters, final Connection connection) {
      Map<String, Object> rec = new HashMap<>();
      final JsonArrayBuilder jab = Json.createArrayBuilder();
      JsonObjectBuilder secret = Json.createObjectBuilder();
      String username = (String) parameters.get("Id");
      secret.add("UserId", "" + username);
            
      try {        
         if (username != null) {
            Map<String, String> queryParams = new HashMap<>();
            queryParams.put("username", username);
            String body = IdentityAndAccessHandlingUtils.getResource("users", queryParams);
            JsonNode userJson = OBJECT_MAPPER.readTree(body);
            if (userJson.get(0) != null) {
               JsonNode attributes = userJson.get(0).get("attributes");
               if (attributes != null) {
                  JsonNode sharedSecretNode = attributes.get("sharedSecret");
                  String sharedSecret = sharedSecretNode.get(0).asText();
                  secret.add("Secret", sharedSecret);
                  jab.add(secret);
                  rec.put("GetSecret", new ByteArrayInputStream(jab.build().toString().getBytes(StandardCharsets.UTF_8)));
                  return rec;
               } 
            } 
         } 
      } catch (IOException ex) {
         LOGGER.log(Level.WARNING, "IOException while retrieving shared secret: {0}", ex.getLocalizedMessage());
      }
      
      secret.add("Secret", "");
      jab.add(secret);
      rec.put("GetSecret", new ByteArrayInputStream(jab.build().toString().getBytes(StandardCharsets.UTF_8)));
      return rec;
   }

}