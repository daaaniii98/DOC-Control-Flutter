package net.michnovka.dockontrol;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.widget.RemoteViews;

import net.michnovka.dockontrol.db.DatabaseHelper;

public class ActionWidgetProvider extends AppWidgetProvider {
    DatabaseHelper databaseHelper;
    private static final String TAG = "ActionWidgetProvider";
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        super.onUpdate(context, appWidgetManager, appWidgetIds);
        databaseHelper = DatabaseHelper.getInstance();
        for (int i = 0; i < appWidgetIds.length; i++) {
            int appWidgetId = appWidgetIds[i];
            // Create an Intent to launch ExampleActivity
            Intent intent = new Intent(context, ActionActivity.class);

            intent.putExtra(ActionActivity.EXTRA_USERNAME,databaseHelper.getSaveData().getUsername());
            intent.putExtra(ActionActivity.EXTRA_PASSWORD,databaseHelper.getSaveData().getPassword());
            intent.putExtra(ActionActivity.EXTRA_ACTION,databaseHelper.getSaveData().getData().get(0).getId());
            PendingIntent pendingIntent = PendingIntent.getActivity(
                    /* context = */ context,
                    /* requestCode = */ 0,
                    /* intent = */ intent,
                    /* flags = */ PendingIntent.FLAG_UPDATE_CURRENT
            );
            Log.e(TAG, "onUpdate: "+appWidgetId );
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_action_layout);
            views.setTextViewText(R.id.btn_action_name,databaseHelper.getSaveData().getData().get(0).getName());

            RemoteViews.RemoteResponse remoteResponse;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                remoteResponse= RemoteViews.RemoteResponse.fromPendingIntent(pendingIntent);
                views.setOnClickResponse(R.id.btn_action_name, remoteResponse);
            }else {
                views.setOnClickPendingIntent(R.id.btn_action_name, pendingIntent);
            }

            // Tell the AppWidgetManager to perform an update on the current app widget.
            appWidgetManager.updateAppWidget(appWidgetId, views);
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
