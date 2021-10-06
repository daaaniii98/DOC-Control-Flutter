package net.michnovka.dockontrol.callback;

import net.michnovka.dockontrol.network.NetworkResourceHolder;

public interface IWidgetCallback {
    void onStateUpdated(NetworkResourceHolder response);
}
