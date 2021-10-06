package net.michnovka.dockontrol.network;

public class NetworkResourceHolder {
    private String status;
    private String message;
    private NetworkStatus mStatus;

    public NetworkResourceHolder(){}
    public NetworkResourceHolder(String status,String message, NetworkStatus mStatus) {
        this.message = message;
        this.mStatus = mStatus;
        this.status = status;
    }

    public NetworkResourceHolder success(String statusCode, String message) {
        return new NetworkResourceHolder(statusCode, message, NetworkStatus.SUCCESS);
    }

    public NetworkResourceHolder error(String statusCode, String message) {
        return new NetworkResourceHolder(statusCode, message, NetworkStatus.ERROR);
    }

    public NetworkResourceHolder loading() {
        return new NetworkResourceHolder(null, null, NetworkStatus.LOADING);
    }

    public boolean isSuccess() {
        return status.equals("ok");
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus(){
        return this.status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public NetworkStatus getmStatus() {
        return mStatus;
    }

    public void setmStatus(NetworkStatus mStatus) {
        this.mStatus = mStatus;
    }

}