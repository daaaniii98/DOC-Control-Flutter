package net.michnovka.dockontrol;

import android.appwidget.AppWidgetManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.MutableLiveData;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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

public class ActionService extends BroadcastReceiver {
    public static final String MY_WIDGET_ACTION = "action.action.button.press";
//    private LifecycleRegistry lifecycleRegistry = new LifecycleRegistry(this);
    public static boolean isActionTrigger = false;
    AppWidgetManager appWidgetManager;
    RemoteViews remoteViews;

    private static final String TAG = "ActionService";
    private static final String BASE_URL = "https://cp.libenskedoky.cz";
    private API api;
    private Retrofit retrofitService;

    public final static String EXTRA_USERNAME = "EXTRA_USERNAME";
    public final static String EXTRA_PASSWORD = "EXTRA_PASSWORD";
    public final static String EXTRA_ACTION = "EXTRA_ACTION";
    public final static String EXTRA_WIDGET_ID = "EXTRA_WIDGET_ID";
    int widgetId;
    public void triggerActionCallApi(String username, String password, String action) {
        isActionTrigger = true;
       statusLoading();

//        MutableLiveData<NetworkResourceHolder> responseData = new MutableLiveData<>();
//        responseData.setValue(new NetworkResourceHolder().loading());

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
//                        responseData.setValue(new NetworkResourceHolder().success(myResponse.getStatus(),
//                                myResponse.getMessage()));
                        statusSuccess();
                        destroyState();
                    } else {
//                        responseData.setValue(new NetworkResourceHolder().error("Error", "Unknown-Error"));
                        destroyState();
                        statusFailed();
                    }
                } else {
//                    responseData.setValue(new NetworkResourceHolder().error("Error", "Unknown-Error"));
                    destroyState();
                    statusFailed();
                }
            }

            @Override
            public void onFailure(Call<String> call, Throwable t) {
//                responseData.setValue(new NetworkResourceHolder().error("Error", t.getMessage()));
                destroyState();
                statusFailed();
            }
        });
//        return responseData;
    }

    private void statusLoading() {
        remoteViews.setViewVisibility(R.id.btn_action_name, View.GONE);
        remoteViews.setViewVisibility(R.id.progress, View.VISIBLE);
        appWidgetManager.updateAppWidget(widgetId,remoteViews);
//        appWidgetManager.updateAppWidget((int[]) null,remoteViews);

    }

    private void statusSuccess(){
        remoteViews.setViewVisibility(R.id.progress, View.GONE);
        remoteViews.setViewVisibility(R.id.img_status_success, View.VISIBLE);
        appWidgetManager.updateAppWidget(widgetId,remoteViews);

        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                statusNormal();
            }
        },2000);
    }

    private void statusNormal() {
        remoteViews.setViewVisibility(R.id.btn_action_name, View.VISIBLE);
        remoteViews.setViewVisibility(R.id.img_status_failure, View.GONE);
        remoteViews.setViewVisibility(R.id.img_status_success, View.GONE);
        appWidgetManager.updateAppWidget(widgetId,remoteViews);
//        appWidgetManager.updateAppWidget((int[]) null,remoteViews);
    }

    private void statusFailed(){
        remoteViews.setViewVisibility(R.id.progress, View.GONE);
        remoteViews.setViewVisibility(R.id.img_status_failure, View.VISIBLE);
        appWidgetManager.updateAppWidget(widgetId,remoteViews);
//        appWidgetManager.updateAppWidget((int[]) null,remoteViews);

        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                statusNormal();
            }
        },2000);
    }

    private void destroyState() {
//        new Handler().postDelayed(() -> lifecycleRegistry.setCurrentState(Lifecycle.State.DESTROYED), 3000);
        isActionTrigger = false;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        appWidgetManager = AppWidgetManager.getInstance(context);
        remoteViews = new RemoteViews(context.getPackageName(), R.layout.widget_action_layout);
        widgetId = intent.getExtras().getInt(EXTRA_WIDGET_ID);

//        lifecycleRegistry.setCurrentState(Lifecycle.State.CREATED);

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

//        lifecycleRegistry.setCurrentState(Lifecycle.State.STARTED);
        if (intent.getAction().equals(MY_WIDGET_ACTION)) {
            Log.e(TAG, "onReceive: " + MY_WIDGET_ACTION);
            triggerActionCallApi(intent.getExtras().getString(EXTRA_USERNAME),
                    intent.getExtras().getString(EXTRA_PASSWORD),
                    intent.getExtras().getString(EXTRA_ACTION));
//            .observe(this, networkResourceHolder -> {
//                Log.e(TAG, "onReceive_OBSERVER: " + networkResourceHolder.getmStatus().name());
//            });
        }
    }

}
