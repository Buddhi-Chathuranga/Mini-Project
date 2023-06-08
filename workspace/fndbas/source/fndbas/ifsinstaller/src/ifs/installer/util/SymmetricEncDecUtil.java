/*
 *                  IFS Research & Development
 * 
 *   This program is protected by copyright law and by international
 *   conventions. All licensing, renting, lending or copying (including
 *   for private use), and all other use of the program, which is not
 *   explicitly permitted by IFS, is a violation of the rights
 *   of IFS. Such violations will be reported to the
 *   appropriate authorities.
 * 
 *   VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 *   TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 *  ----------------------------------------------------------------------------
 *  File        : SymmetricEncDecUtil.java
 *  Description :
 *  Notes       :
 *  ----------------------------------------------------------------------------
 *  Revision History
 *  ----------------------------------------------------------------------------
 *  200912    SJayLK, Created
 *  ----------------------------------------------------------------------------
 * 
 */
package ifs.installer.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.SecretKey;

/**
 *
 * @author IFS RnD
 */
public class SymmetricEncDecUtil {
   public static final String DEFAULT_SYMMETRIC_KEY_SECRET_NAME = "symmetric-key";
   public static final String DEFAULT_SYMMETRIC_KEY_ALGORITHM = "AES";
   public static final int DEFAULT_SYMMETRIC_KEY_LENGTH = 128;
   
   public static String generateAndHexEncodeSymmetricKey(String keyAlgorithm, int keyLength) throws NoSuchAlgorithmException {
      KeyGenerator generator;
      generator = KeyGenerator.getInstance(keyAlgorithm);
      generator.init(keyLength);
      String encodedKey = String.valueOf(encodeHex(generator.generateKey().getEncoded()));
      return encodedKey;
   }
   
   public static String generateAndHexEncodeSymmetricKey() throws NoSuchAlgorithmException{
      KeyGenerator generator;
      generator = KeyGenerator.getInstance(DEFAULT_SYMMETRIC_KEY_ALGORITHM);
      generator.init(DEFAULT_SYMMETRIC_KEY_LENGTH);
      String encodedKey = String.valueOf(encodeHex(generator.generateKey().getEncoded()));
      return encodedKey;
   }
   
   private static SecretKey getSymmetricKey(String symmetricKeySecretName, String symmetricKeyAlgorithm) throws IOException, InterruptedException{
      byte[] secretKeyEncoded;
      Process p;
      List<String> commandList = new ArrayList<>();
      commandList.add("sh");
      commandList.add("/opt/ifs/.secrets/get_secret.sh");
      commandList.add(symmetricKeySecretName);
      ProcessBuilder pb = new ProcessBuilder(commandList);          
      p = pb.start();
      p.waitFor();
      BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
      char[] allChars = readToCharArray(reader);
      secretKeyEncoded = decodeHex(allChars);      
      if(secretKeyEncoded == null || secretKeyEncoded.length == 0) {
         throw new SecurityException(symmetricKeySecretName + " could not be aquired. Encryption/Decryption tasks cannot continue.");
      }
      SecretKey keyout = new SecretKeySpec(secretKeyEncoded, 0, secretKeyEncoded.length, symmetricKeyAlgorithm);      
      return keyout;
   }   

   private static char[] readToCharArray(BufferedReader bufferedReader) throws IOException {      
      char[] allChars = null;          
      char[] theChars = new char[128];
      int charsRead = bufferedReader.read(theChars, 0, theChars.length);
      while(charsRead != -1) {
         int allCharsLength = allChars == null ? 0 : allChars.length;
         char[] allCharsTemp = new char[allCharsLength + charsRead];
         for(int i = 0; i < allCharsTemp.length; i++){
            allCharsTemp[i] = i < allCharsLength ? allChars[i] : theChars[i - allCharsLength];
         }
         allChars = allCharsTemp;
         charsRead = bufferedReader.read(theChars, 0, theChars.length);
      }
      return allChars;
   }   
   
   public static byte[] encrypt(byte[] toEncrypt) throws NoSuchAlgorithmException, IOException, NoSuchPaddingException, InterruptedException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException{
      return encrypt(DEFAULT_SYMMETRIC_KEY_SECRET_NAME, DEFAULT_SYMMETRIC_KEY_ALGORITHM, toEncrypt);
   }
   
   public static byte[] decrypt(byte[] toDecrypt) throws NoSuchAlgorithmException, IOException, NoSuchPaddingException, InterruptedException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException{
      return decrypt(DEFAULT_SYMMETRIC_KEY_SECRET_NAME, DEFAULT_SYMMETRIC_KEY_ALGORITHM, toDecrypt);
   }
   
   public static byte[] encrypt(String symmetricKeySecretName, String symmetricKeyAlgorithm, byte[] toEncrypt) throws NoSuchAlgorithmException, IOException, NoSuchPaddingException, InterruptedException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException{
      Cipher encCipher = Cipher.getInstance(symmetricKeyAlgorithm);
      encCipher.init(Cipher.ENCRYPT_MODE, getSymmetricKey(symmetricKeySecretName, symmetricKeyAlgorithm));
      return encCipher.doFinal(toEncrypt);
   }
   
   public static byte[] decrypt(String symmetricKeySecretName, String symmetricKeyAlgorithm, byte[] toDecrypt) throws NoSuchAlgorithmException, IOException, NoSuchPaddingException, InterruptedException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException{
      Cipher aesCipher2 = Cipher.getInstance(symmetricKeyAlgorithm);
      aesCipher2.init(Cipher.DECRYPT_MODE, getSymmetricKey(symmetricKeySecretName, symmetricKeyAlgorithm));
      return aesCipher2.doFinal(toDecrypt);
   }
   
   public static char[] encodeHex(final byte[] data) {
      char[] toDigits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
      final int l = data.length;
      final char[] out = new char[l << 1];        
      int dataLen = data.length;
      // two characters form the hex value.
      for (int i = 0, j = 0; i < dataLen; i++) {
         out[j++] = toDigits[(0xF0 & data[i]) >>> 4];
         out[j++] = toDigits[0x0F & data[i]];
      }
      return out;
   }
   
   public static byte[] decodeHex(final char[] data){
      final byte[] out = new byte[data.length >> 1]; 
      final int len = data.length;
      if ((len & 0x01) != 0) {
         throw new IllegalArgumentException("Decoding from HEX cannot continue. Odd number of characters.");
      }
      
      final int outLen = len >> 1;
      if (out.length < outLen) {
         throw new IllegalArgumentException("Decoding from HEX cannot continue. Output array is not large enough to accommodate decoded data.");
      }
      
      // two characters form the hex value.
      for (int i = 0, j = 0; j < len; i++) {
         int f = toDigit(data[j], j) << 4;
         j++;
         f = f | toDigit(data[j], j);
         j++;
         out[i] = (byte) (f & 0xFF);
      }
      return out;
   }
   
   private static int toDigit(final char ch, final int index){
      final int digit = Character.digit(ch, 16);
      if (digit == -1) {
         throw new IllegalArgumentException("Illegal hexadecimal character " + ch + " at index " + index);
      }
      return digit;
   }
}