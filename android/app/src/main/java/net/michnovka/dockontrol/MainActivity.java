package net.michnovka.dockontrol;

import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.pathprovider.PathProviderPlugin;

public class MainActivity extends FlutterActivity implements PluginRegistry.PluginRegistrantCallback {
    private static final String TAG = "MainActivity";
    private String CHANNEL = "dockontrol.yorbax/widget_data";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if(call.method.equals("test_message")) {
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
