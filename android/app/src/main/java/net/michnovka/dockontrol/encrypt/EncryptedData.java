package net.michnovka.dockontrol.encrypt;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;

public class EncryptedData {
    private static final String TAG = "EncryptedData";
    private byte[] ciphertext;
    private byte[] initializationVector;

    public EncryptedData(byte[] ciphertext, byte[] initializationVector) {
        this.ciphertext = ciphertext;
        this.initializationVector = initializationVector;
    }

    public byte[] getCiphertext() {
        return ciphertext;
    }

    public void setCiphertext(byte[] ciphertext) {
        this.ciphertext = ciphertext;
    }

    public byte[] getInitializationVector() {
        return initializationVector;
    }

    public void setInitializationVector(byte[] initializationVector) {
        this.initializationVector = initializationVector;
    }

    public String toJson(){
        JSONObject finalUTFjson = new JSONObject();
        try {
            String tempA=   new String(ciphertext, StandardCharsets.UTF_8);
            String tempB=   new String(initializationVector, StandardCharsets.UTF_8);
            try {
                String convertedA  = new String(tempA.getBytes(StandardCharsets.ISO_8859_1), "utf-8");
                String convertedB  = new String(tempB.getBytes(StandardCharsets.ISO_8859_1), "utf-8");
                Log.e(TAG, "toJson: " + convertedA );
                Log.e(TAG, "toJsonconvertedB: " + convertedB );
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            finalUTFjson.put("ciphertext", new String(ciphertext, StandardCharsets.UTF_8));
            finalUTFjson.put("initializationVector", new String(initializationVector, StandardCharsets.UTF_8));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return finalUTFjson.toString();
    }
}
