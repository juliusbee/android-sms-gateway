package com.agroconnect.smsgateway.service

import android.Manifest
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.telephony.SmsManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.agroconnect.smsgateway.AgroConnectSmsApp
import com.agroconnect.smsgateway.data.model.SmsMessage
import com.agroconnect.smsgateway.network.MessageStatusRequest
import com.agroconnect.smsgateway.network.PingRequest
import com.agroconnect.smsgateway.receiver.SmsDeliveredReceiver
import com.agroconnect.smsgateway.receiver.SmsSentReceiver
import com.agroconnect.smsgateway.utils.NotificationHelper
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.*

class SmsPollingWorker(
    context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    companion object {
        private const val TAG = "SmsPollingWorker"
        private const val MAX_SMS_LENGTH = 160
    }

    private val app = applicationContext as AgroConnectSmsApp
    private val apiService = app.apiClient.getApiService()
    private val smsRepository = app.smsRepository
    private val preferenceManager = app.preferenceManager
    private val notificationHelper = NotificationHelper(applicationContext)

    override suspend fun doWork(): Result {
        return withContext(Dispatchers.IO) {
            try {
                Log.d(TAG, "Starting SMS polling work")

                // Check if gateway is configured and active
                if (!preferenceManager.isGatewayConfigured()) {
                    Log.w(TAG, "Gateway not configured, skipping polling")
                    return@withContext Result.success()
                }

                // Send ping to server
                sendPing()

                // Get pending messages from server
                val pendingMessages = getPendingMessages()
                
                if (pendingMessages.isNotEmpty()) {
                    Log.d(TAG, "Found ${pendingMessages.size} pending messages")
                    
                    // Process each message
                    for (message in pendingMessages) {
                        try {
                            sendSmsMessage(message)
                        } catch (e: Exception) {
                            Log.e(TAG, "Failed to send message ${message.id}", e)
                            reportMessageStatus(message.id, "failed", e.message)
                        }
                    }
                }

                // Update last sync time
                preferenceManager.setLastSyncTime(System.currentTimeMillis())

                Log.d(TAG, "SMS polling work completed successfully")
                Result.success()

            } catch (e: Exception) {
                Log.e(TAG, "SMS polling work failed", e)
                Result.retry()
            }
        }
    }

    private suspend fun sendPing() {
        try {
            val deviceInfo = mapOf(
                "battery_level" to getBatteryLevel(),
                "network_type" to getNetworkType(),
                "app_version" to getAppVersion(),
                "last_activity" to System.currentTimeMillis()
            )

            val response = apiService.ping(PingRequest(deviceInfo))
            
            if (response.isSuccessful && response.body()?.success == true) {
                val pingResponse = response.body()?.data
                pingResponse?.let {
                    // Update polling interval if changed
                    if (it.polling_interval != preferenceManager.getPollingInterval()) {
                        preferenceManager.setPollingInterval(it.polling_interval)
                        app.restartBackgroundServices()
                    }
                    
                    // Update gateway status
                    preferenceManager.setGatewayStatus(it.gateway_status)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to send ping", e)
        }
    }

    private suspend fun getPendingMessages(): List<com.agroconnect.smsgateway.network.PendingMessage> {
        return try {
            val response = apiService.getPendingMessages()
            
            if (response.isSuccessful && response.body()?.success == true) {
                response.body()?.data?.messages ?: emptyList()
            } else {
                Log.w(TAG, "Failed to get pending messages: ${response.message()}")
                emptyList()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error getting pending messages", e)
            emptyList()
        }
    }

    private suspend fun sendSmsMessage(message: com.agroconnect.smsgateway.network.PendingMessage) {
        // Check SMS permission
        if (ActivityCompat.checkSelfPermission(
                applicationContext,
                Manifest.permission.SEND_SMS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            throw SecurityException("SMS permission not granted")
        }

        try {
            val smsManager = SmsManager.getDefault()
            val phoneNumber = message.phone_number
            val messageText = message.message

            // Save message to local database
            val localMessage = SmsMessage(
                serverId = message.id,
                phoneNumber = phoneNumber,
                message = messageText,
                status = "sending",
                priority = message.priority,
                createdAt = System.currentTimeMillis()
            )
            
            val localId = smsRepository.insertMessage(localMessage)

            // Create pending intents for delivery tracking
            val sentIntent = createSentIntent(message.id, localId)
            val deliveredIntent = createDeliveredIntent(message.id, localId)

            // Split long messages if necessary
            if (messageText.length > MAX_SMS_LENGTH) {
                val parts = smsManager.divideMessage(messageText)
                val sentIntents = ArrayList<PendingIntent>()
                val deliveredIntents = ArrayList<PendingIntent>()

                repeat(parts.size) {
                    sentIntents.add(sentIntent)
                    deliveredIntents.add(deliveredIntent)
                }

                smsManager.sendMultipartTextMessage(
                    phoneNumber,
                    null,
                    parts,
                    sentIntents,
                    deliveredIntents
                )
            } else {
                smsManager.sendTextMessage(
                    phoneNumber,
                    null,
                    messageText,
                    sentIntent,
                    deliveredIntent
                )
            }

            Log.d(TAG, "SMS sent to $phoneNumber")

            // Update local message status
            smsRepository.updateMessageStatus(localId, "sent")

            // Report to server
            reportMessageStatus(message.id, "sent")

            // Update statistics
            preferenceManager.incrementMessagesSent()

            // Show notification for high priority messages
            if (message.priority >= 5) {
                notificationHelper.showMessageSentNotification(phoneNumber, messageText)
            }

        } catch (e: Exception) {
            Log.e(TAG, "Failed to send SMS to ${message.phone_number}", e)
            throw e
        }
    }

    private fun createSentIntent(serverId: Long, localId: Long): PendingIntent {
        val intent = Intent(applicationContext, SmsSentReceiver::class.java).apply {
            putExtra("server_id", serverId)
            putExtra("local_id", localId)
        }
        
        return PendingIntent.getBroadcast(
            applicationContext,
            serverId.toInt(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun createDeliveredIntent(serverId: Long, localId: Long): PendingIntent {
        val intent = Intent(applicationContext, SmsDeliveredReceiver::class.java).apply {
            putExtra("server_id", serverId)
            putExtra("local_id", localId)
        }
        
        return PendingIntent.getBroadcast(
            applicationContext,
            (serverId + 100000).toInt(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private suspend fun reportMessageStatus(
        messageId: Long,
        status: String,
        errorMessage: String? = null
    ) {
        try {
            val currentTime = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US).format(Date())
            
            val request = MessageStatusRequest(
                message_id = messageId,
                status = status,
                error_message = errorMessage,
                sent_at = if (status == "sent") currentTime else null,
                delivered_at = if (status == "delivered") currentTime else null
            )

            val response = apiService.reportMessageStatus(request)
            
            if (!response.isSuccessful) {
                Log.w(TAG, "Failed to report message status: ${response.message()}")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error reporting message status", e)
        }
    }

    private fun getBatteryLevel(): Int {
        // Implementation to get battery level
        return 100 // Placeholder
    }

    private fun getNetworkType(): String {
        // Implementation to get network type
        return "wifi" // Placeholder
    }

    private fun getAppVersion(): String {
        return try {
            val packageInfo = applicationContext.packageManager.getPackageInfo(
                applicationContext.packageName, 0
            )
            packageInfo.versionName
        } catch (e: Exception) {
            "unknown"
        }
    }
}
