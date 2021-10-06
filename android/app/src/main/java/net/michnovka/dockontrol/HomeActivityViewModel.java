package net.michnovka.dockontrol;

import android.text.TextUtils;
import android.util.Log;

import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import net.michnovka.dockontrol.network.API;
import net.michnovka.dockontrol.network.NetworkResourceHolder;
import net.michnovka.dockontrol.network.NetworkStatus;
import net.michnovka.dockontrol.network.UnsafeOkHttpClient;

import okhttp3.OkHttpClient;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

public class HomeActivityViewModel extends ViewModel {
    private static final String TAG = "HomeActivityViewModel";
    private static final String BASE_URL = "https://cp.libenskedoky.cz";
    private API api;
    private Retrofit retrofitService;

    public HomeActivityViewModel() {
        OkHttpClient client = UnsafeOkHttpClient.getUnsafeOkHttpClient();
        Gson gson = new GsonBuilder()
                .setLenient()
                .create();
        retrofitService = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(ScalarsConverterFactory.create())
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(client)
                .build();
        api = retrofitService.create(API.class);
    }

    public MutableLiveData<NetworkResourceHolder> triggerActionCallApi(String username, String password, String action) {
        MutableLiveData<NetworkResourceHolder> responseData = new MutableLiveData<>();
        responseData.setValue(new NetworkResourceHolder().loading());

        Call<String> response = api.triggerActionApi(username, password, action);
        response.enqueue(new Callback<String>() {
            @Override
            public void onResponse(Call<String> call, Response<String> response) {
                if (response.isSuccessful()) {
                    String resultResponse = response.body();
                    if (!TextUtils.isEmpty(resultResponse)) {
                        Gson gson = new Gson();
                        NetworkResourceHolder myResponse = gson.fromJson(resultResponse, NetworkResourceHolder.class);
                        if (myResponse.isSuccess()) {
                            myResponse.setmStatus(NetworkStatus.SUCCESS);
                        } else {
                            myResponse.setmStatus(NetworkStatus.ERROR);
                        }
                        responseData.setValue(new NetworkResourceHolder().success(myResponse.getStatus(),
                                myResponse.getMessage()));
                    } else {
                        responseData.setValue(new NetworkResourceHolder().error("Error", "Unknown-Error"));
                    }
                } else {
                    responseData.setValue(new NetworkResourceHolder().error("Error", "Unknown-Error"));
                }
            }

            @Override
            public void onFailure(Call<String> call, Throwable t) {
                responseData.setValue(new NetworkResourceHolder().error("Error", t.getMessage()));
            }
        });
        return responseData;
    }

}
