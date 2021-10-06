package net.michnovka.dockontrol.network;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

public interface API {
    @GET("api.php")
    Call<String> triggerActionApi(
            @Query("username") String username,
            @Query("password") String password,
            @Query("action") String action
    );

}
