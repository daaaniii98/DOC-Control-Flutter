package net.michnovka.dockontrol.callback;

public interface ICryptoCallback {
    void onEncrypt(String encryptString);
    void onDecrypt(String decryptString);
    void onAuthError(String error);
    void onAuthFailed(String error);
}
