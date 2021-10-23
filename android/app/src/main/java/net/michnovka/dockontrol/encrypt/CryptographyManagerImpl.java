package net.michnovka.dockontrol.encrypt;

import android.os.Build;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;

import androidx.annotation.RequiresApi;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.Key;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;

public class CryptographyManagerImpl implements CryptographyManager {

    private int KEY_SIZE = 256;
    String ANDROID_KEYSTORE = "AndroidKeyStore";
    private String ENCRYPTION_BLOCK_MODE = KeyProperties.BLOCK_MODE_GCM;
    private String ENCRYPTION_PADDING = KeyProperties.ENCRYPTION_PADDING_NONE;
    private String ENCRYPTION_ALGORITHM = KeyProperties.KEY_ALGORITHM_AES;

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public Cipher getInitializedCipherForEncryption(String keyName) {
        Cipher cipher = getCipher();
        try {
            SecretKey secretKey;
            secretKey = getOrCreateSecretKey(keyName);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cipher;
    }


    private Cipher getCipher() {
        String transformation = ENCRYPTION_ALGORITHM + "/" + ENCRYPTION_BLOCK_MODE + "/" + ENCRYPTION_PADDING;
        try {
            return Cipher.getInstance(transformation);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    @RequiresApi(api = Build.VERSION_CODES.M)
    private SecretKey getOrCreateSecretKey(String keyName) throws KeyStoreException, CertificateException, NoSuchAlgorithmException, IOException, UnrecoverableKeyException, NoSuchProviderException, InvalidAlgorithmParameterException {
        // If Secretkey was previously created for that keyName, then grab and return it.
        KeyStore keyStore = KeyStore.getInstance(ANDROID_KEYSTORE);
        keyStore.load(null); // Keystore must be loaded before it can be accessed
        Key myKey = keyStore.getKey(keyName, null);
        if (myKey != null) {
            return (SecretKey) myKey;
        }
        // if you reach here, then a new SecretKey must be generated for that keyName
        KeyGenParameterSpec.Builder paramsBuilder = new KeyGenParameterSpec.Builder(keyName, KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT);
        paramsBuilder.setBlockModes(ENCRYPTION_BLOCK_MODE);
        paramsBuilder.setEncryptionPaddings(ENCRYPTION_PADDING);
        paramsBuilder.setKeySize(KEY_SIZE);
        paramsBuilder.setUserAuthenticationRequired(true);


        KeyGenParameterSpec keyGenParams = paramsBuilder.build();
        KeyGenerator keyGenerator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES,
                ANDROID_KEYSTORE);
        keyGenerator.init(keyGenParams);
        return keyGenerator.generateKey();
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public Cipher getInitializedCipherForDecryption(String keyName, byte[] initializationVector) {
        Cipher cipher = getCipher();
        try {
            SecretKey secretKey;
            secretKey = getOrCreateSecretKey(keyName);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, new GCMParameterSpec(128, initializationVector));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cipher;
    }

    @Override
    public EncryptedData encryptData(String plaintext, Cipher cipher) {
        byte[] ciphertext = new byte[0];
        try {
            ciphertext = cipher.doFinal(plaintext.getBytes("UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new EncryptedData(ciphertext, cipher.getIV());
    }

    @Override
    public String decryptData(byte[] ciphertext, Cipher cipher) {
        byte[] plaintext = new byte[0];
        try {
            plaintext = cipher.doFinal(ciphertext);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new String(plaintext, StandardCharsets.UTF_8);
    }
}
