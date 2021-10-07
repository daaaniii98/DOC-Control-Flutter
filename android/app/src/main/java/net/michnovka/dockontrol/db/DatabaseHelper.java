package net.michnovka.dockontrol.db;

import net.michnovka.dockontrol.model.Root;
import net.michnovka.dockontrol.model.WidgetInfoModel;

import io.paperdb.Paper;

public class DatabaseHelper {
    private static final String KEY_RESPONSE = "KEY_RESPONSE";
    private static final String BOOK_NAME = "DatabaseHelper";

    private DatabaseHelper() {}

    private static volatile DatabaseHelper instance;

    public static synchronized DatabaseHelper getInstance(){
        if(instance == null){
            instance = new DatabaseHelper();
        }
        return instance;
    }

    public void saveData(Root root){
        Paper.book(BOOK_NAME).write(KEY_RESPONSE, root);
    }

    public Root getSaveData(){
        return Paper.book(BOOK_NAME).read(KEY_RESPONSE);
    }

    public void deleteData() {
        Paper.book(BOOK_NAME).write(KEY_RESPONSE,new Root());
    }
    
    public void saveWidgetInformation(WidgetInfoModel widgetInfoModel){
        Paper.book(BOOK_NAME).write(String.valueOf(widgetInfoModel.getWidgetId()),widgetInfoModel);
    }

    public WidgetInfoModel getWidgetInformation(int widgetId){
        return Paper.book(BOOK_NAME).read(String.valueOf(widgetId),null);
    }
}
