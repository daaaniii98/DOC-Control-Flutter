package net.michnovka.dockontrol;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.VectorDrawable;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import androidx.core.content.ContextCompat;

import net.michnovka.dockontrol.db.DatabaseHelper;
import net.michnovka.dockontrol.model.ActionModel;

import io.paperdb.Paper;

import static android.provider.MediaStore.Images.Media.getBitmap;
import static net.michnovka.dockontrol.ActionService.MY_WIDGET_ACTION;

public class ActionWidgetProvider extends AppWidgetProvider {
    public final static String EXTRA_USERNAME = "EXTRA_USERNAME";
    public final static String EXTRA_PASSWORD = "EXTRA_PASSWORD";
    public final static String EXTRA_ACTION = "EXTRA_ACTION";
    public final static String EXTRA_WIDGET_ID = "EXTRA_WIDGET_ID";

    private final static String ACTION_SELECT_WIDGET = "com.dockontrol.action.select.widget";

    static DatabaseHelper databaseHelper;
    //    static DialogWidgetChooser dialogWidgetChooser;
    private static final String TAG = "ActionWidgetProvider";

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        super.onUpdate(context, appWidgetManager, appWidgetIds);
//        dialogWidgetChooser = new DialogWidgetChooser();

        updateWidget(context, appWidgetManager, appWidgetIds);
        Log.e(TAG, "onUpdate_____RRRRRRRRRRRRRRRRROOOOOTTTTTT: ");
    }


    public static void updateWidget(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        Log.e(TAG, "updateWidget_____________YAAAAAAAAaa: ");
        Paper.init(context);
        try {
            databaseHelper = DatabaseHelper.getInstance();
            for (int appWidgetId : appWidgetIds) {
                RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_action_layout);
                if (databaseHelper.getSaveData() != null && !TextUtils.isEmpty(databaseHelper.getSaveData().getUsername())) {
                    //Login Successful
                    views.setViewVisibility(R.id.tx_login, View.GONE);
                    views.setViewVisibility(R.id.btn_select_widget, View.VISIBLE);
                    Log.e(TAG, "updateWidget_NOTTTTTTTTTTTTT_NULLLLLLL ");

                    /*
                      Check if widget information [ActionModel] is already contain
                      in database or not. If the returned information is empty then
                      widget has not initialized before
                     */
                    ActionModel actionModel = databaseHelper.getWidgetInformation(appWidgetId);
                    if (actionModel == null) {
                        Log.e(TAG, "updateWidget: ******** SELECT WIDGET ******** ");
                        Intent intent = new Intent(context, SelectWidgetActivity.class);
                        intent.setAction(ACTION_SELECT_WIDGET);
                        intent.putExtra(EXTRA_WIDGET_ID, appWidgetId);
                        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent,
                                PendingIntent.FLAG_UPDATE_CURRENT);
                        views.setOnClickPendingIntent(R.id.btn_select_widget, pendingIntent);
                        Log.e(TAG, "onUpdate: " + appWidgetId);
                    } else {

                        Intent intent = new Intent(context, ActionService.class);
                        intent.setAction(MY_WIDGET_ACTION + appWidgetId);
                        Log.e(TAG, "onUpdate: ************************************************************\t" + databaseHelper.getSaveData().getUsername());
                        intent.putExtra(EXTRA_USERNAME, databaseHelper.getSaveData().getUsername());
                        intent.putExtra(EXTRA_PASSWORD, databaseHelper.getSaveData().getPassword());
                        intent.putExtra(EXTRA_ACTION, actionModel.getAction());
                        intent.putExtra(EXTRA_WIDGET_ID, appWidgetId);
                        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
                        Log.e(TAG, "onUpdate: " + appWidgetId);
//                        views.setViewVisibility(R.id.tx_login, View.GONE);
                        views.setViewVisibility(R.id.btn_select_widget, View.GONE);

                        views.setViewVisibility(R.id.btn_action_name, View.VISIBLE);
                        views.setImageViewResource(R.id.btn_action_name, getBitmapImg(actionModel.getAction(),context));
//                        views.setTextViewText(R.id.btn_action_name,actionModel.getName());
                        views.setOnClickPendingIntent(R.id.btn_action_name, pendingIntent);
                    }
                } else {
                    /*
                    User has not logged In yet or already logged out
                     */
                    views.setViewVisibility(R.id.tx_login, View.VISIBLE);
                    views.setViewVisibility(R.id.btn_action_name, View.GONE);
                    views.setViewVisibility(R.id.btn_select_widget, View.GONE);
                }
                // Tell the AppWidgetManager to perform an update on the current app widget.
                appWidgetManager.updateAppWidget(appWidgetId, views);
            }
        } catch (Exception e) {
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

    public static int getBitmapImg(String action, Context context){

        Drawable drawable = null;
        int drawId = 0;
        if(action.contains("enter")){
            drawId = R.drawable.ic_enter;
            drawable = ContextCompat.getDrawable(context,drawId );
        }else if(action.contains("gate")){
            drawId = R.drawable.ic_gate;
            drawable = ContextCompat.getDrawable(context,drawId );
        }else if(action.contains("garage")){
            drawId = R.drawable.ic_garage;
            drawable = ContextCompat.getDrawable(context,drawId );
        }else if(action.contains("exit")) {
            drawId = R.drawable.ic_exit;
            drawable = ContextCompat.getDrawable(context,drawId );
        }else if(action.contains("elevator")) {
            drawId = R.drawable.ic_elevator;
            drawable = ContextCompat.getDrawable(context,drawId );
        }else if(action.contains("entrance")) {
            drawId = R.drawable.ic_entrance;
            drawable = ContextCompat.getDrawable(context,drawId );
        }else{
            drawId = R.drawable.ic_nuki;
            drawable = ContextCompat.getDrawable(context,drawId );
        }
return drawId;

//        Resources res = getResources();
//        Drawable drawable = res.getDrawable(R.drawable.myimage, getTheme());

//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            VectorDrawable vectorDrawable = (VectorDrawable) drawable;
//        } else {
//            BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
//        }
//
//        if (drawable instanceof BitmapDrawable) {
//            return BitmapFactory.decodeResource(context.getResources(), drawId);
//        }
//        else if (drawable instanceof VectorDrawable) {
//            return getBitmap((VectorDrawable) drawable);
//        }
//        else {
//            throw new IllegalArgumentException("unsupported drawable type");
//        }
    }

}
