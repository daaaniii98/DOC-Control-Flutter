package net.michnovka.dockontrol;

import android.app.Activity;
import android.app.AlertDialog;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.RemoteViews;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.asksira.dropdownview.DropDownView;

import net.michnovka.dockontrol.db.DatabaseHelper;
import net.michnovka.dockontrol.model.ActionModel;
import net.michnovka.dockontrol.model.WidgetInfoModel;

import java.util.ArrayList;
import java.util.List;

import static net.michnovka.dockontrol.ActionWidgetProvider.EXTRA_WIDGET_ID;
import static net.michnovka.dockontrol.ActionWidgetProvider.getBitmapImg;

public class SelectWidgetActivity extends Activity {

    DropDownView dropDownView;
    private static final String TAG = "SelectWidgetActivity";
    DatabaseHelper databaseHelper;
    //    DialogWidgetChooser dialogWidgetChooser;
    ArrayList<String> actions = new ArrayList<>();
    List<ActionModel> myActions;
    AlertDialog dialog;
    Button btnSelect;

    int selectedPosition = -1;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_layout);
        int widgetId = getIntent().getExtras().getInt(EXTRA_WIDGET_ID);
        getActionBar().hide();
        dropDownView = findViewById(R.id.dropdownview);
        btnSelect = findViewById(R.id.btn_select);
        databaseHelper = DatabaseHelper.getInstance();
        myActions = databaseHelper.getSaveData().getData();
        for (ActionModel actionModel :
                myActions) {
            if (actionModel.isAllowWidget()) {
                actions.add(actionModel.getName());
            }
        }

        Log.e(TAG, "onReceive:  ACTION_SELECT_WIDGET");

        dropDownView.setDropDownListItem(actions);
        dropDownView.setOnSelectionListener((view, position) -> {
            selectedPosition = position;
        });
        btnSelect.setOnClickListener(v -> {
            if (selectedPosition != -1) {
                ActionModel actionModel = myActions.get(selectedPosition);
                // Save Selected Widget in database
                databaseHelper.saveWidgetInformation(new WidgetInfoModel(actionModel, widgetId));
                //Update the views
                AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(this);
                RemoteViews remoteViews = new RemoteViews(getPackageName(), R.layout.widget_action_layout);
                remoteViews.setViewVisibility(R.id.btn_select_widget, View.GONE);
                remoteViews.setViewVisibility(R.id.btn_action_name, View.VISIBLE);
                remoteViews.setImageViewResource(R.id.btn_action_name, getBitmapImg(actionModel.getAction(),this));

//                remoteViews.setImageViewBitmap(R.id.btn_action_name, getBitmapImg(actionModel.getAction(),this));
//                remoteViews.setTextViewText(R.id.btn_action_name, actionModel.getName());
                appWidgetManager.updateAppWidget(widgetId, remoteViews);

                ComponentName thisWidget = new ComponentName(this, ActionWidgetProvider.class);
                ActionWidgetProvider.updateWidget(this,appWidgetManager,appWidgetManager.getAppWidgetIds(thisWidget));

                runOnUiThread(() -> {
                    Toast.makeText(SelectWidgetActivity.this, actionModel.getName() + " Selected!", Toast.LENGTH_SHORT).show();
                    finish();
                });
            } else {
                Toast.makeText(this, "Select a widget!", Toast.LENGTH_SHORT).show();
            }
        });
//        dialogWidgetChooser.showDialog((actionModel, context1) -> {
//            // Save Selected Widget in database
//            databaseHelper.saveWidgetInformation(new WidgetInfoModel(actionModel,widgetId));
//            //Update the views
//            AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context1);
//            RemoteViews remoteViews = new RemoteViews(context1.getPackageName(), R.layout.widget_action_layout);
//            remoteViews.setViewVisibility(R.id.btn_select_widget, View.GONE);
//            remoteViews.setViewVisibility(R.id.btn_action_name,View.VISIBLE);
//            remoteViews.setTextViewText(R.id.btn_action_name,actionModel.getName());
//            appWidgetManager.updateAppWidget(widgetId,remoteViews);
//        },this);
    }

}
