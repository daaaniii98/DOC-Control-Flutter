package net.michnovka.dockontrol.model;

public class WidgetInfoModel extends ActionModel {
    int widgetId;
    String widgetName;
    
    public WidgetInfoModel(ActionModel actionModel,int widgetId,String widgetName){
        this.action = actionModel.action;
        this.allow1minOpen = actionModel.allow1minOpen;
        this.allowWidget = actionModel.allowWidget;
        this.cameras = actionModel.cameras;
        this.hasCamera = actionModel.hasCamera;
        this.id = actionModel.id;
        this.name = actionModel.name;
        this.type = actionModel.type;
        this.widgetId = widgetId;
        this.widgetName = widgetName;
    }
    public int getWidgetId() {
        return widgetId;
    }

    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
    }

    public String getWidgetName() {
        return widgetName;
    }

    public void setWidgetName(String widgetName) {
        this.widgetName = widgetName;
    }
}
