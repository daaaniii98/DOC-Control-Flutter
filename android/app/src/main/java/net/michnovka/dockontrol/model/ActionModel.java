package net.michnovka.dockontrol.model;

import java.io.Serializable;
import java.util.List;

/**
 * Action Model that was received from the Login API
 */
public class ActionModel implements Serializable {
    String id;
    String action;
    String type;
    String name;
    boolean hasCamera;
    boolean allowWidget;
    boolean allow1minOpen;
    List<String> cameras;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isHasCamera() {
        return hasCamera;
    }

    public void setHasCamera(boolean hasCamera) {
        this.hasCamera = hasCamera;
    }

    public boolean isAllowWidget() {
        return allowWidget;
    }

    public void setAllowWidget(boolean allowWidget) {
        this.allowWidget = allowWidget;
    }

    public boolean isAllow1minOpen() {
        return allow1minOpen;
    }

    public void setAllow1minOpen(boolean allow1minOpen) {
        this.allow1minOpen = allow1minOpen;
    }

    public List<String> getCameras() {
        return cameras;
    }

    public void setCameras(List<String> cameras) {
        this.cameras = cameras;
    }
}
