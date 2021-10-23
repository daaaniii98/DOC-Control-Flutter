package net.michnovka.dockontrol;

import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.biometric.BiometricManager;
import androidx.biometric.BiometricPrompt;
import androidx.core.content.ContextCompat;

import com.google.gson.Gson;

import net.michnovka.dockontrol.callback.ICryptoCallback;
import net.michnovka.dockontrol.db.DatabaseHelper;
import net.michnovka.dockontrol.db.NukiPinPref;
import net.michnovka.dockontrol.encrypt.CryptographyManager;
import net.michnovka.dockontrol.encrypt.CryptographyManagerImpl;
import net.michnovka.dockontrol.encrypt.EncryptedData;
import net.michnovka.dockontrol.model.Root;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.Executor;

import javax.crypto.Cipher;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.paperdb.Paper;

public class MainActivity extends FlutterFragmentActivity implements PluginRegistry.PluginRegistrantCallback {
    private static final String TAG = "MainActivity";
    private final String CHANNEL = "dockontrol.yorbax/widget_data";
    public Root rootResponse;
    private DatabaseHelper databaseHelper;

    private BiometricPrompt biometricPrompt;
    private BiometricPrompt.PromptInfo promptInfo;
    private Boolean readyToEncrypt = false;
    private CryptographyManager cryptographyManager;
    private String secretKeyName;
    private byte[] ciphertext;
    private byte[] initializationVector;

    private EncryptedData decryptObject;
    NukiPinPref nukiPinPref;
    /*
    On time on encryption two fields are received from
    flutter action_id and entered pin_code
     */
    private String actionId;
    private String pinCode;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Paper.init(this);
        nukiPinPref = NukiPinPref.getInstance(this);
        databaseHelper = DatabaseHelper.getInstance();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("widget_data")) {
                        Gson gson = new Gson();
                        com.google.gson.stream.JsonReader reader = new com.google.gson.stream.JsonReader(new StringReader(call.arguments.toString()));
                        reader.setLenient(true);
                        rootResponse = gson.fromJson(reader, Root.class);
                        databaseHelper.saveData(rootResponse);
                        // TODO Add a valid response
                        updateWidget();
                        result.success("YESS GOT IT");
                    } else if (call.method.equals("logout")) {
                        // TODO Add a valid response
                        DatabaseHelper.getInstance().deleteData();
                        result.success("YESS GOT IT");
                        updateWidget();
                    } else if (call.method.equals("encrypt")) {
                        pinCode = call.argument("pin");
                        actionId = call.argument("allowActionId");
                        Log.e(TAG, "configureFlutterEngine_ENCRYPT: " + pinCode);
                        Log.e(TAG, "configureFlutterEngine_ENCRYPT_actionId: " + actionId);
                        initCrypto(new ICryptoCallback() {
                            @Override
                            public void onEncrypt(String encryptString) {
                                result.success(encryptString);
                            }

                            @Override
                            public void onDecrypt(String decryptString) {
                                /*No Implementation*/
                            }

                            @Override
                            public void onAuthError(String error) {
                                result.error(error, error, 11);
                            }

                            @Override
                            public void onAuthFailed(String error) {
                                /*No Implementation*/
                            }
                        });
                        authenticateToEncrypt();
                    } else if (call.method.equals("decrypt")) {
                        actionId = call.argument("allowActionId");
                        Log.e(TAG, "configureFlutterEngine: "+"actionId ::: " + actionId);
                        decryptObject = nukiPinPref.getNukiEncPin(actionId);
//                        decryptObject = new EncryptedData(call.argument("ciphertext").toString().getBytes(StandardCharsets.UTF_8)
//                                , call.argument("initializationVector").toString().getBytes(StandardCharsets.UTF_8));
                        readyToEncrypt = false;
                        Log.e(TAG, "configureFlutterEngine_DE_CRYPT: " + new Gson().toJson(decryptObject));
                        initCrypto(new ICryptoCallback()    {
                            @Override
                            public void onEncrypt(String encryptString) {
                                /*No Implementation*/
                            }

                            @Override
                            public void onDecrypt(String decryptString) {
                                result.success(decryptString);
                            }

                            @Override
                            public void onAuthError(String error) {
                                result.error(error, error, 11);
                            }

                            @Override
                            public void onAuthFailed(String error) {
//                                result.error(error, error, 11);
                            }
                        });
                        authenticateToDecrypt();
//                        Log.e(TAG, "configureFlutterEngine: " + call.arguments.toString() );
//                        try {
//                            JSONObject jsonObject = new JSONObject(call.arguments.toString());
//                            Log.e(TAG, "configureFlutterEngine_DECCCCCCCCRPYT: " + call.arguments.toString());
//
//                        } catch (JSONException e) {
//                            e.printStackTrace();
//                        }
                    }
                });
    }

    private void initCrypto(ICryptoCallback cryptoCallback) {
        cryptographyManager = CryptographyManager();
        secretKeyName = getString(R.string.secret_key_name);
        biometricPrompt = createBiometricPrompt(cryptoCallback);
        promptInfo = createPromptInfo();

    }

    private BiometricPrompt createBiometricPrompt(ICryptoCallback cryptoCallback) {
        Executor executor = ContextCompat.getMainExecutor(this);

        BiometricPrompt.AuthenticationCallback callback = new BiometricPrompt.AuthenticationCallback() {
            @Override
            public void onAuthenticationError(int errorCode, @NonNull CharSequence errString) {
                super.onAuthenticationError(errorCode, errString);
                Log.d(TAG, "$errorCode :: $errString");
                cryptoCallback.onAuthError(errString.toString());
            }

            @Override
            public void onAuthenticationSucceeded(@NonNull BiometricPrompt.AuthenticationResult result) {
                super.onAuthenticationSucceeded(result);
                Log.d(TAG, "Authentication was successful");
                processData(result.getCryptoObject(), cryptoCallback);
            }

            @Override
            public void onAuthenticationFailed() {
                super.onAuthenticationFailed();
                cryptoCallback.onAuthFailed("Authentication failed for an unknown reason");
                Log.d(TAG, "Authentication failed for an unknown reason");
            }
        };
        //The API requires the client/Activity context for displaying the prompt view
        BiometricPrompt biometricPrompt = new BiometricPrompt(this, executor, callback);
        return biometricPrompt;
    }

    private BiometricPrompt.PromptInfo createPromptInfo() {
        BiometricPrompt.PromptInfo promptInfo = new BiometricPrompt.PromptInfo.Builder()
                .setTitle(getString(R.string.prompt_info_title)) // e.g. "Sign in"
                .setSubtitle(getString(R.string.prompt_info_subtitle)) // e.g. "Biometric for My App"
                .setDescription(getString(R.string.prompt_info_description)) // e.g. "Confirm biometric to continue"
                .setConfirmationRequired(false)
                .setNegativeButtonText(getString(R.string.prompt_info_use_app_password)) // e.g. "Use Account Password"
                .setDeviceCredentialAllowed(false) // Allow PIN/pattern/password authentication.
                // Also note that setDeviceCredentialAllowed and setNegativeButtonText are
                // incompatible so that if you uncomment one you must comment out the other
                .build();
        return promptInfo;
    }

    private void authenticateToEncrypt() {
        readyToEncrypt = true;
        if (BiometricManager.from(this).canAuthenticate() == BiometricManager
                .BIOMETRIC_SUCCESS) {
            Cipher cipher = cryptographyManager.getInitializedCipherForEncryption(secretKeyName);
            biometricPrompt.authenticate(promptInfo, new BiometricPrompt.CryptoObject(cipher));
        }
    }

    private void authenticateToDecrypt() {
        if (BiometricManager.from(this).canAuthenticate() == BiometricManager
                .BIOMETRIC_SUCCESS) {
            initializationVector = decryptObject.getInitializationVector();
            Log.e(TAG, "authenticateToDecrypt: " + new String(initializationVector,Charset.forName("UTF-8")));
            Cipher cipher = cryptographyManager.getInitializedCipherForDecryption(secretKeyName, initializationVector);
            biometricPrompt.authenticate(promptInfo, new BiometricPrompt.CryptoObject(cipher));
        }
    }

    private void processData(BiometricPrompt.CryptoObject cryptoObject, ICryptoCallback cryptoCallback) {
        if (readyToEncrypt) {
            EncryptedData encryptedData = cryptographyManager.encryptData(pinCode, cryptoObject.getCipher());
            ciphertext = encryptedData.getCiphertext();
            initializationVector = encryptedData.getInitializationVector();
            Log.e(TAG, "processData_encrptedText: " + new Gson().toJson(encryptedData));
            cryptoCallback.onEncrypt(encryptedData.toJson());
            //Save data in preference
            nukiPinPref.saveNukiEncPin(actionId,encryptedData.getCiphertext(),encryptedData.getInitializationVector());
        } else {
            String decryptData = cryptographyManager.decryptData(decryptObject.getCiphertext(), cryptoObject.getCipher());
            Log.e(TAG, "processData_decryptData: " + decryptData);
            cryptoCallback.onDecrypt(decryptData);
        }
    }

    private CryptographyManager CryptographyManager() {
        return new CryptographyManagerImpl();
    }

    private void updateWidget() {
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(this);
        ComponentName thisWidget = new ComponentName(this, ActionWidgetProvider.class);
        ActionWidgetProvider.updateWidget(this, appWidgetManager, appWidgetManager.getAppWidgetIds(thisWidget));
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    }
}
