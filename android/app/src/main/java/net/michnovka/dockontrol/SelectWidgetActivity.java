package net.michnovka.dockontrol;

import android.app.Activity;
import android.app.AlertDialog;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RemoteViews;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.asksira.dropdownview.DropDownView;

import net.michnovka.dockontrol.db.DatabaseHelper;
import net.michnovka.dockontrol.model.ActionModel;
import net.michnovka.dockontrol.model.WidgetInfoModel;

import java.util.ArrayList;
import java.util.List;

import static net.michnovka.dockontrol.ActionWidgetHandler.EXTRA_WIDGET_ID;
import static net.michnovka.dockontrol.ActionWidgetProvider.getBitmapImg;

public class SelectWidgetActivity extends Activity {

    DropDownView dropDownView;
    private static final String TAG = "SelectWidgetActivity";
    DatabaseHelper databaseHelper;
    //    DialogWidgetChooser dialogWidgetChooser;
    ArrayList<String> actions = new ArrayList<>();
    List<ActionModel> myActions;
    Button btnSelect;

    int selectedPosition = -1;
    EditText edName;
    
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_layout);
        // [appWidgetId] to update the widget
        int widgetId = getIntent().getExtras().getInt(EXTRA_WIDGET_ID);
        getActionBar().hide();
        // init Views
        dropDownView = findViewById(R.id.dropdownview);
        edName = findViewById(R.id.ed_name);
        btnSelect = findViewById(R.id.btn_select);
        // init [DatabaseHelper] to insert widget data into database
        databaseHelper = DatabaseHelper.getInstance();
        // Getting widgets data to populate spinner
        myActions = databaseHelper.getSaveData().getData();
        for (ActionModel actionModel :
                myActions) {
            if (actionModel.isAllowWidget()) {
                actions.add(actionModel.getName());
            }
        }

        dropDownView.setDropDownListItem(actions);
        dropDownView.setOnSelectionListener((view, position) -> {
            selectedPosition = position;
            ActionModel actionModel = myActions.get(selectedPosition);
            edName.setText(actionModel.getName());
        });
        btnSelect.setOnClickListener(v -> {
            String name = edName.getText().toString();
            if(TextUtils.isEmpty(name)){
                edName.setError("Can't be empty");
                return;
            }
            if (selectedPosition != -1) {
                ActionModel actionModel = myActions.get(selectedPosition);
                // Save Selected Widget in database
                databaseHelper.saveWidgetInformation(new WidgetInfoModel(actionModel, widgetId,name));
                //Update the views
                AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(this);
                RemoteViews remoteViews = new RemoteViews(getPackageName(), R.layout.widget_action_layout);
                remoteViews.setViewVisibility(R.id.btn_select_widget, View.GONE);
                remoteViews.setViewVisibility(R.id.btn_action_name, View.VISIBLE);
                remoteViews.setTextViewText(R.id.tx_widget_name, name);
                remoteViews.setImageViewResource(R.id.btn_action_name, getBitmapImg(actionModel.getAction(),this));
    
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
    }

}
