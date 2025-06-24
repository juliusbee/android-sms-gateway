package com.agroconnect.smsgateway.network

import android.content.Context
import com.agroconnect.smsgateway.BuildConfig
import com.agroconnect.smsgateway.utils.PreferenceManager
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

class ApiClient private constructor(context: Context) {

    companion object {
        @Volatile
        private var INSTANCE: ApiClient? = null

        fun getInstance(context: Context): ApiClient {
            return INSTANCE ?: synchronized(this) {
                INSTANCE ?: ApiClient(context.applicationContext).also { INSTANCE = it }
            }
        }
    }

    private val preferenceManager = PreferenceManager(context)
    private val retrofit: Retrofit

    init {
        val httpClient = OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .addInterceptor(createAuthInterceptor())
            .addInterceptor(createLoggingInterceptor())
            .build()

        retrofit = Retrofit.Builder()
            .baseUrl(getBaseUrl())
            .client(httpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    private fun getBaseUrl(): String {
        val customUrl = preferenceManager.getServerUrl()
        return if (customUrl.isNotEmpty()) {
            if (customUrl.endsWith("/")) customUrl else "$customUrl/"
        } else {
            BuildConfig.API_BASE_URL
        }
    }

    private fun createAuthInterceptor(): Interceptor {
        return Interceptor { chain ->
            val originalRequest = chain.request()
            val apiKey = preferenceManager.getApiKey()

            val newRequest = if (apiKey.isNotEmpty()) {
                originalRequest.newBuilder()
                    .header("Authorization", "Bearer $apiKey")
                    .header("Content-Type", "application/json")
                    .header("Accept", "application/json")
                    .header("User-Agent", "AgroConnect-SMS-Gateway/1.0")
                    .build()
            } else {
                originalRequest.newBuilder()
                    .header("Content-Type", "application/json")
                    .header("Accept", "application/json")
                    .header("User-Agent", "AgroConnect-SMS-Gateway/1.0")
                    .build()
            }

            chain.proceed(newRequest)
        }
    }

    private fun createLoggingInterceptor(): HttpLoggingInterceptor {
        return HttpLoggingInterceptor().apply {
            level = if (BuildConfig.DEBUG) {
                HttpLoggingInterceptor.Level.BODY
            } else {
                HttpLoggingInterceptor.Level.NONE
            }
        }
    }

    fun getApiService(): ApiService {
        return retrofit.create(ApiService::class.java)
    }

    fun updateBaseUrl(newUrl: String) {
        // Note: In a production app, you might want to recreate the Retrofit instance
        // For now, this will take effect on next app restart
        preferenceManager.setServerUrl(newUrl)
    }
}
