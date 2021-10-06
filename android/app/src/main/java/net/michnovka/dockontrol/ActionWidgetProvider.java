package net.michnovka.dockontrol;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import net.michnovka.dockontrol.db.DatabaseHelper;

import io.paperdb.Paper;

import static net.michnovka.dockontrol.ActionService.MY_WIDGET_ACTION;

public class ActionWidgetProvider extends AppWidgetProvider {
    public final static String EXTRA_USERNAME = "EXTRA_USERNAME";
    public final static String EXTRA_PASSWORD = "EXTRA_PASSWORD";
    public final static String EXTRA_ACTION = "EXTRA_ACTION";
    public final static String EXTRA_WIDGET_ID = "EXTRA_WIDGET_ID";
    
    static DatabaseHelper databaseHelper;
    private static final String TAG = "ActionWidgetProvider";
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        super.onUpdate(context, appWidgetManager, appWidgetIds);
        updateWidget(context, appWidgetManager, appWidgetIds);
        Log.e(TAG, "onUpdate_____RRRRRRRRRRRRRRRRROOOOOTTTTTT: " );
    }


    public static void updateWidget(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds){
        Log.e(TAG, "updateWidget_____________YAAAAAAAAaa: " );
        Paper.init(context);
        try {
            databaseHelper = DatabaseHelper.getInstance();
            for (int i = 0; i < appWidgetIds.length; i++) {
                int appWidgetId = appWidgetIds[i];
                RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_action_layout);
                if(databaseHelper.getSaveData() != null && !TextUtils.isEmpty(databaseHelper.getSaveData().getUsername())) {
                    Log.e(TAG, "updateWidget_NOTTTTTTTTTTTTT_NULLLLLLL " );
//                    int appWidgetId = -1;
                    Intent intent = new Intent(context, ActionService.class);
                    intent.setAction(MY_WIDGET_ACTION);
                    Log.e(TAG, "onUpdate: ************************************************************\t" + databaseHelper.getSaveData().getUsername());
                    intent.putExtra(EXTRA_USERNAME, databaseHelper.getSaveData().getUsername());
                    intent.putExtra(EXTRA_PASSWORD, databaseHelper.getSaveData().getPassword());
                    intent.putExtra(EXTRA_ACTION, databaseHelper.getSaveData().getData().get(0).getAction());
                    intent.putExtra(EXTRA_WIDGET_ID, appWidgetId);
                    PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
                    Log.e(TAG, "onUpdate: " + appWidgetId);
                    views.setViewVisibility(R.id.tx_login, View.GONE);
                    views.setViewVisibility(R.id.btn_action_name, View.VISIBLE);
                    views.setTextViewText(R.id.btn_action_name, databaseHelper.getSaveData().getData().get(0).getName());

//            RemoteViews.RemoteResponse remoteResponse;
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//                remoteResponse= RemoteViews.RemoteResponse.fromPendingIntent(pendingIntent);
//                views.setOnClickResponse(R.id.btn_action_name, remoteResponse);
//            }else {
//            }
                    if (!ActionService.isActionTrigger) {
                        views.setOnClickPendingIntent(R.id.btn_action_name, pendingIntent);
                    }
                    // Tell the AppWidgetManager to perform an update on the current app widget.
                    appWidgetManager.updateAppWidget(appWidgetId, views);
                }else {
                    views.setViewVisibility(R.id.tx_login, View.VISIBLE);
                    views.setViewVisibility(R.id.btn_action_name, View.GONE);
                    appWidgetManager.updateAppWidget(appWidgetId, views);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
        //in this case, nothing is necessary, since it is handled for every widget.
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
        //it's all handled by the onDelete, so there is nothing here.
    }

}
