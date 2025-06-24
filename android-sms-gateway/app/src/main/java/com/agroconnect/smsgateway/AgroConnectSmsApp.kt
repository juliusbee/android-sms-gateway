package com.agroconnect.smsgateway

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.work.*
import com.agroconnect.smsgateway.data.AppDatabase
import com.agroconnect.smsgateway.data.repository.SmsRepository
import com.agroconnect.smsgateway.network.ApiClient
import com.agroconnect.smsgateway.service.SmsPollingWorker
import com.agroconnect.smsgateway.utils.PreferenceManager
import java.util.concurrent.TimeUnit

class AgroConnectSmsApp : Application() {

    companion object {
        const val NOTIFICATION_CHANNEL_ID = "sms_gateway_channel"
        const val NOTIFICATION_CHANNEL_NAME = "SMS Gateway Service"
        const val NOTIFICATION_CHANNEL_DESCRIPTION = "Notifications for SMS Gateway operations"
        
        lateinit var instance: AgroConnectSmsApp
            private set
    }

    lateinit var database: AppDatabase
        private set
    
    lateinit var smsRepository: SmsRepository
        private set
    
    lateinit var apiClient: ApiClient
        private set
    
    lateinit var preferenceManager: PreferenceManager
        private set

    override fun onCreate() {
        super.onCreate()
        instance = this
        
        // Initialize components
        initializeDatabase()
        initializeApiClient()
        initializeRepository()
        initializePreferences()
        
        // Create notification channel
        createNotificationChannel()
        
        // Start background services if configured
        if (preferenceManager.isGatewayConfigured()) {
            startBackgroundServices()
        }
    }

    private fun initializeDatabase() {
        database = AppDatabase.getDatabase(this)
    }

    private fun initializeApiClient() {
        apiClient = ApiClient.getInstance(this)
    }

    private fun initializeRepository() {
        smsRepository = SmsRepository(database.smsDao(), apiClient)
    }

    private fun initializePreferences() {
        preferenceManager = PreferenceManager(this)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                NOTIFICATION_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = NOTIFICATION_CHANNEL_DESCRIPTION
                setShowBadge(false)
                enableLights(false)
                enableVibration(false)
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun startBackgroundServices() {
        // Start periodic SMS polling
        val pollingRequest = PeriodicWorkRequestBuilder<SmsPollingWorker>(
            30, TimeUnit.SECONDS,
            15, TimeUnit.SECONDS
        )
            .setConstraints(
                Constraints.Builder()
                    .setRequiredNetworkType(NetworkType.CONNECTED)
                    .setRequiresBatteryNotLow(false)
                    .build()
            )
            .addTag("sms_polling")
            .build()

        WorkManager.getInstance(this).enqueueUniquePeriodicWork(
            "sms_polling_work",
            ExistingPeriodicWorkPolicy.REPLACE,
            pollingRequest
        )
    }

    fun stopBackgroundServices() {
        WorkManager.getInstance(this).cancelAllWorkByTag("sms_polling")
    }

    fun restartBackgroundServices() {
        stopBackgroundServices()
        if (preferenceManager.isGatewayConfigured()) {
            startBackgroundServices()
        }
    }

    fun isGatewayActive(): Boolean {
        return preferenceManager.isGatewayConfigured() && 
               preferenceManager.getGatewayStatus() == "active"
    }

    fun getGatewayInfo(): Map<String, Any> {
        return mapOf(
            "device_name" to preferenceManager.getDeviceName(),
            "device_id" to preferenceManager.getDeviceId(),
            "phone_number" to preferenceManager.getPhoneNumber(),
            "server_url" to preferenceManager.getServerUrl(),
            "api_key" to preferenceManager.getApiKey(),
            "status" to preferenceManager.getGatewayStatus(),
            "last_sync" to preferenceManager.getLastSyncTime(),
            "messages_sent_today" to preferenceManager.getMessagesSentToday(),
            "total_messages_sent" to preferenceManager.getTotalMessagesSent()
        )
    }
}
