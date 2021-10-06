package net.michnovka.dockontrol;

import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.os.Bundle;
import android.util.JsonReader;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.gson.Gson;

import net.michnovka.dockontrol.db.DatabaseHelper;
import net.michnovka.dockontrol.model.Root;

import java.io.StringReader;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.paperdb.Paper;

public class MainActivity extends FlutterActivity implements PluginRegistry.PluginRegistrantCallback {
    private static final String TAG = "MainActivity";
    private final String CHANNEL = "dockontrol.yorbax/widget_data";
    public Root rootResponse;
    private DatabaseHelper databaseHelper;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Paper.init(this);
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
                        Log.e(TAG, "configureFlutterEngine__JSON_PARSING");
                        rootResponse = gson.fromJson(reader, Root.class);
                        databaseHelper.saveData(rootResponse);
                        Log.e(TAG, "configureFlutterEngine: " + new Gson().toJson(rootResponse));
                        Log.e(TAG, "configureFlutterEngine: " + call.method);
                        Log.e(TAG, "configureFlutterEngine: sending REsponse ");
                        result.success("YESS GOT IT");
                    } else if (call.method.equals("logout")) {
                        DatabaseHelper.getInstance().deleteData();
                        result.success("YESS GOT IT");
                    }
                    AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(this);
                    ComponentName thisWidget = new ComponentName(this, ActionWidgetProvider.class);
                    ActionWidgetProvider.updateWidget(this,appWidgetManager,appWidgetManager.getAppWidgetIds(thisWidget));
                });
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    }
}
