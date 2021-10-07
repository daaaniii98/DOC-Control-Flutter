package net.michnovka.dockontrol.dialog;

import android.app.AlertDialog;
import android.content.Context;

import net.michnovka.dockontrol.db.DatabaseHelper;
import net.michnovka.dockontrol.model.ActionModel;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DialogWidgetChooser {
    private IDialogCallback callback;
    private Context context;
    static DatabaseHelper databaseHelper;
    ArrayList<String> actions = new ArrayList<>();
    List<ActionModel> myActions;
    AlertDialog dialog;
    
    public DialogWidgetChooser(){
        databaseHelper = DatabaseHelper.getInstance();
        myActions = databaseHelper.getSaveData().getData();
        for (ActionModel actionModel :
                myActions) {
            if(actionModel.isAllowWidget()){
                actions.add(actionModel.getName());
            }
        }
    }
    
    public void showDialog(IDialogCallback callback,Context context){
        this.callback = callback;
        this.context = context;
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle("Choose a widget");

        builder.setItems(Arrays.copyOf(actions.toArray(),actions.toArray().length,String[].class), (dialog, position) -> {
            callback.onItemSelected(myActions.get(position),context);
            dialog.dismiss();
        });
        dialog = builder.create();
        dialog.show();
    }


    public interface IDialogCallback {
        void onItemSelected(ActionModel actionModel, Context context);
    }
}
