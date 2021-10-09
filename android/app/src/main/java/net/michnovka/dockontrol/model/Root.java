package net.michnovka.dockontrol.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * The data which is passed from flutter 
 */
public class Root implements Serializable {
    String username;
    String password;
    List<ActionModel> data;

    public Root(){
        this.username = "";
        this.password = "";
        data = new ArrayList<>();
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public List<ActionModel> getData() {
        return data;
    }

    public void setData(List<ActionModel> data) {
        this.data = data;
    }
}
