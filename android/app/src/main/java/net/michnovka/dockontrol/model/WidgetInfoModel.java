package net.michnovka.dockontrol.model;

public class WidgetInfoModel extends ActionModel {
    int widgetId;

    public WidgetInfoModel(ActionModel actionModel,int widgetId){
        this.action = actionModel.action;
        this.allow1minOpen = actionModel.allow1minOpen;
        this.allowWidget = actionModel.allowWidget;
        this.cameras = actionModel.cameras;
        this.hasCamera = actionModel.hasCamera;
        this.id = actionModel.id;
        this.name = actionModel.name;
        this.type = actionModel.type;
        this.widgetId = widgetId;
    }
    public int getWidgetId() {
        return widgetId;
    }

    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
    }
}
