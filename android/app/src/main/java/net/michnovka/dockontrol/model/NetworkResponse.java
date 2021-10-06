package net.michnovka.dockontrol.model;

import java.io.Serializable;

public class NetworkResponse implements Serializable {
    String status;
    String message;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isSuccess() {
        return status.equals("ok");
    }
}
//{"status":"ok","message":"Elevator opened"}
