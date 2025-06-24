package com.agroconnect.smsgateway.network

import com.agroconnect.smsgateway.data.model.*
import retrofit2.Response
import retrofit2.http.*

interface ApiService {

    @POST("register")
    suspend fun registerDevice(@Body request: DeviceRegistrationRequest): Response<ApiResponse<DeviceRegistrationResponse>>

    @GET("pending-messages")
    suspend fun getPendingMessages(): Response<ApiResponse<PendingMessagesResponse>>

    @POST("report-status")
    suspend fun reportMessageStatus(@Body request: MessageStatusRequest): Response<ApiResponse<Unit>>

    @POST("ping")
    suspend fun ping(@Body request: PingRequest): Response<ApiResponse<PingResponse>>

    @GET("config")
    suspend fun getConfig(): Response<ApiResponse<GatewayConfigResponse>>
}

// Data classes for API requests and responses

data class ApiResponse<T>(
    val success: Boolean,
    val message: String? = null,
    val data: T? = null,
    val errors: Map<String, List<String>>? = null
)

data class DeviceRegistrationRequest(
    val device_name: String,
    val device_id: String,
    val phone_number: String,
    val android_version: String,
    val app_version: String,
    val device_model: String,
    val network_operator: String? = null
)

data class DeviceRegistrationResponse(
    val gateway_id: Long,
    val api_key: String,
    val device_name: String,
    val status: String,
    val polling_interval: Int,
    val max_messages_per_batch: Int
)

data class PendingMessagesResponse(
    val messages: List<PendingMessage>,
    val count: Int,
    val gateway_status: String,
    val polling_interval: Int
)

data class PendingMessage(
    val id: Long,
    val phone_number: String,
    val message: String,
    val priority: Int,
    val created_at: String,
    val retry_count: Int
)

data class MessageStatusRequest(
    val message_id: Long,
    val status: String, // sent, failed, delivered
    val error_message: String? = null,
    val sent_at: String? = null,
    val delivered_at: String? = null
)

data class PingRequest(
    val device_info: Map<String, Any>? = null
)

data class PingResponse(
    val server_time: String,
    val gateway_status: String,
    val pending_count: Int,
    val polling_interval: Int
)

data class GatewayConfigResponse(
    val gateway_id: Long,
    val device_name: String,
    val phone_number: String,
    val status: String,
    val settings: GatewaySettings,
    val server_info: ServerInfo
)

data class GatewaySettings(
    val polling_interval: Int,
    val max_messages_per_batch: Int,
    val retry_failed_messages: Boolean,
    val max_retry_count: Int,
    val auto_delete_sent_messages: Boolean,
    val battery_optimization_warning: Boolean
)

data class ServerInfo(
    val server_time: String,
    val api_version: String,
    val platform: String
)
