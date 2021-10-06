package net.michnovka.dockontrol;

import android.util.JsonReader;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import net.michnovka.dockontrol.model.Root;

import java.io.StringReader;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.pathprovider.PathProviderPlugin;

public class MainActivity extends FlutterActivity implements PluginRegistry.PluginRegistrantCallback {
    private static final String TAG = "MainActivity";
    private final String CHANNEL = "dockontrol.yorbax/widget_data";
    public Root rootResponse;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if(call.method.equals("widget_data")) {
                        Gson gson = new Gson();
                        com.google.gson.stream.JsonReader reader = new com.google.gson.stream.JsonReader(new StringReader(call.arguments.toString()));
                        reader.setLenient(true);
                        Log.e(TAG, "configureFlutterEngine__JSON_PARSING");
                        rootResponse = gson.fromJson(reader, Root.class);
                        Log.e(TAG, "configureFlutterEngine: " + new Gson().toJson(rootResponse));
                        Log.e(TAG, "configureFlutterEngine: " + call.method);
                        Log.e(TAG, "configureFlutterEngine: sending REsponse ");
                        result.success("YESS GOT IT");
                    }
        });
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    }
}
