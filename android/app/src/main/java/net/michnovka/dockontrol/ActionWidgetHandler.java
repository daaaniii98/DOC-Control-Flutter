package net.michnovka.dockontrol;

import android.appwidget.AppWidgetManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.AudioAttributes;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.text.TextUtils;
import android.util.Log;
import android.view.HapticFeedbackConstants;
import android.view.View;
import android.widget.RemoteViews;

import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.MutableLiveData;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import net.michnovka.dockontrol.db.DatabaseHelper;
import net.michnovka.dockontrol.model.WidgetInfoModel;
import net.michnovka.dockontrol.network.API;
import net.michnovka.dockontrol.network.NetworkResourceHolder;
import net.michnovka.dockontrol.network.NetworkStatus;
import net.michnovka.dockontrol.network.UnsafeOkHttpClient;

import okhttp3.OkHttpClient;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

import static androidx.core.content.ContextCompat.getSystemService;

/**
 * [BroadcastReceiver] that is trigger everytime the widget is pressed
 */
public class ActionWidgetHandler extends BroadcastReceiver {
    private static final String TAG = "ActionService";
    private Context context;
    // Broadcast Action
    public static final String MY_WIDGET_ACTION = "action.action.button.press";
    public static boolean isActionTrigger = false;
    // To update Widget
    AppWidgetManager appWidgetManager;
    RemoteViews remoteViews;

    //To trigger API action
        private static final String BASE_URL = "https://cp.libenskedoky.cz";
    private API api;
    private Retrofit retrofitService;

    // Extra Tag used to pass data using [INTENT]
    public final static String EXTRA_USERNAME = "EXTRA_USERNAME";
    public final static String EXTRA_PASSWORD = "EXTRA_PASSWORD";
    public final static String EXTRA_ACTION = "EXTRA_ACTION";
    public final static String EXTRA_WIDGET_ID = "EXTRA_WIDGET_ID";
    public final static String EXTRA_WIDGET_NAME = "EXTRA_WIDGET_NAME";
    
    // Current Widget ID/Name
    int widgetId;
//    String widgetName;
    
    public void triggerActionCallApi(String username, String password, String action) {
        isActionTrigger = true;
       statusLoading();

        Call<String> response = api.triggerActionApi(username, password, action);
        response.enqueue(new Callback<String>() {
            @Override
            public void onResponse(Call<String> call, Response<String> response) {
                if (response.isSuccessful()) {
                    String resultResponse = response.body();
                    if (!TextUtils.isEmpty(resultResponse)) {
                        Gson gson = new Gson();
                        NetworkResourceHolder myResponse = gson.fromJson(resultResponse, NetworkResourceHolder.class);
                        if (myResponse.isSuccess()) {
                            myResponse.setmStatus(NetworkStatus.SUCCESS);
                        } else {
                            myResponse.setmStatus(NetworkStatus.ERROR);
                        }
                        statusSuccess();
                        destroyState();
                    } else {
                        destroyState();
                        statusFailed();
                    }
                } else {
                    destroyState();
                    statusFailed();
                }
            }

            @Override
            public void onFailure(Call<String> call, Throwable t) {
                destroyState();
                statusFailed();
            }
        });
    }

    private void statusLoading() {
        remoteViews.setViewVisibility(R.id.btn_action_name, View.GONE);
        remoteViews.setViewVisibility(R.id.progress, View.VISIBLE);
        appWidgetManager.updateAppWidget(widgetId,remoteViews);
    }

    private void statusSuccess(){
        // Vibrate on Success
        Vibrator v = (Vibrator) context.getSystemService(Context.VIBRATOR_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            long[] pattern = {500, 500};
            if (v != null) {
                AudioAttributes audioAttributes = new AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setUsage(AudioAttributes.USAGE_ALARM) //key
                        .build();
                v.vibrate(pattern, 0, audioAttributes);
                /*
                To stop endless loop of vibration
                 */
                new Handler().postDelayed(v::cancel,600);
               setSuccessViews();
            }
        } else {
            if(v.hasVibrator()){
                v.vibrate(600);
                setSuccessViews();
            }
        }
    }

    private void setSuccessViews() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                remoteViews.setViewVisibility(R.id.progress, View.GONE);
                remoteViews.setViewVisibility(R.id.img_status_success, View.VISIBLE);
                appWidgetManager.updateAppWidget(widgetId,remoteViews);
                new Handler(Looper.getMainLooper()).postDelayed(() -> statusNormal(), 2000);
            }
        },800);
    }

    private void statusNormal() {
        remoteViews.setViewVisibility(R.id.btn_action_name, View.VISIBLE);
        remoteViews.setViewVisibility(R.id.img_status_failure, View.GONE);
        remoteViews.setViewVisibility(R.id.img_status_success, View.GONE);
        appWidgetManager.updateAppWidget(widgetId,remoteViews);
    }

    private void statusFailed(){
        remoteViews.setViewVisibility(R.id.progress, View.GONE);
        remoteViews.setViewVisibility(R.id.img_status_failure, View.VISIBLE);
        appWidgetManager.updateAppWidget(widgetId,remoteViews);
        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                statusNormal();
            }
        },2000);
    }

    private void destroyState() {
        isActionTrigger = false;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        appWidgetManager = AppWidgetManager.getInstance(context);
        remoteViews = new RemoteViews(context.getPackageName(), R.layout.widget_action_layout);
        widgetId = intent.getExtras().getInt(EXTRA_WIDGET_ID);
//        widgetName= intent.getExtras().getString(EXTRA_WIDGET_NAME);
        this.context = context;
        OkHttpClient client = UnsafeOkHttpClient.getUnsafeOkHttpClient();
        Gson gson = new GsonBuilder()
                .setLenient()
                .create();
        retrofitService = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(ScalarsConverterFactory.create())
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(client)
                .build();
        api = retrofitService.create(API.class);
        if (intent.getAction().contains(MY_WIDGET_ACTION)) {
            triggerActionCallApi(intent.getExtras().getString(EXTRA_USERNAME),
                    intent.getExtras().getString(EXTRA_PASSWORD),
                    intent.getExtras().getString(EXTRA_ACTION));
        }
    }

}
