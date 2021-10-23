package net.michnovka.dockontrol.db;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import net.michnovka.dockontrol.encrypt.EncryptedData;

import java.util.Arrays;

public class NukiPinPref {
    private static final String TAG = "NukiPinPref";
    Context context;
    private static final String PREFS_NAME = "NukiDatabaseHelper";

    private NukiPinPref(Context context) {this.context = context;}

    private static volatile NukiPinPref instance;

    public static synchronized NukiPinPref getInstance(Context context){
        if(instance == null){
            instance = new NukiPinPref(context);
        }
        return instance;
    }

    public void saveNukiEncPin(String actionId,byte[] cipher,byte[] vector){
        SharedPreferences nukiPref = context.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = nukiPref.edit();
        Log.e(TAG, "saveNukiEncPin: SAVVING " + actionId );
        editor.putString(actionId, Arrays.toString(cipher));
        editor.putString(actionId+"_vector", Arrays.toString(vector));
        editor.apply();
    }

    public EncryptedData getNukiEncPin(String actionId){
        SharedPreferences nukiPref = context.getSharedPreferences(PREFS_NAME, 0);
        String stringArray = nukiPref.getString(actionId, null);
        Log.e(TAG, "getNukiEncPin: RETRIENVEONG " + actionId );

        Log.e(TAG, "getNukiEncPinCIPHERR: "+stringArray );
        byte[] array = new byte[0];
        if (stringArray != null) {
            String[] split = stringArray.substring(1, stringArray.length()-1).split(", ");
            array = new byte[split.length];
            for (int i = 0; i < split.length; i++) {
                array[i] = Byte.parseByte(split[i]);
            }
        }

        String vectorString = nukiPref.getString(actionId+"_vector", null);
        Log.e(TAG, "getNukiEncPinvectorString: "+vectorString );

        byte[] vectorArray = new byte[0];
        if (vectorString != null) {
            String[] split = vectorString.substring(1, vectorString.length()-1).split(", ");
            vectorArray = new byte[split.length];
            for (int i = 0; i < split.length; i++) {
                vectorArray[i] = Byte.parseByte(split[i]);
            }
        }
        return new EncryptedData(array,vectorArray);
    }
}
