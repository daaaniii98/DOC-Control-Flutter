package net.michnovka.dockontrol.encrypt;

import javax.crypto.Cipher;

/**
 * Java version of
 * Git repo [https://github.com/isaidamier/blogs.biometrics.cryptoBlog]
 */
public interface CryptographyManager {

    /**
     * This method first gets or generates an instance of SecretKey and then initializes the Cipher
     * with the key. The secret key uses [ENCRYPT_MODE][Cipher.ENCRYPT_MODE] is used.
     */
    Cipher getInitializedCipherForEncryption(String keyName);

    /**
     * This method first gets or generates an instance of SecretKey and then initializes the Cipher
     * with the key. The secret key uses [DECRYPT_MODE][Cipher.DECRYPT_MODE] is used.
     */
    Cipher getInitializedCipherForDecryption(String keyName,  byte[]  initializationVector);

    /**
     * The Cipher created with [getInitializedCipherForEncryption] is used here
     */
    EncryptedData encryptData(String plaintext, Cipher cipher);

    /**
     * The Cipher created with [getInitializedCipherForDecryption] is used here
     */
    String decryptData( byte[]  ciphertext, Cipher cipher);

}
