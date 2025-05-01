package com.example.zendesk_plugin_third

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import zendesk.android.Zendesk
import zendesk.android.messaging.Messaging
import zendesk.messaging.android.DefaultMessagingFactory

/** ZendeskPluginPlugin */
class ZendeskPluginPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var activity: Activity? = null
  private val TAG = "ZendeskPluginPlugin"
  private var isZendeskInitialized = false
  private var messagingInstance: Messaging? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zendesk_plugin_third")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "initialize" -> {
        val channelKey = call.argument<String>("channelKey")
        Log.d(TAG, "Channel key: $channelKey")
        if (channelKey.isNullOrEmpty()) {
          result.error("INVALID_ARGUMENT", "Channel key is required", null)
          return
        }
        
        initializeZendesk(channelKey, result)
      }
      "showMessages" -> {
        showZendeskMessages(result)
      }
      "getUnreadMessageCount" -> {
        getUnreadMessages(result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun initializeZendesk(channelKey: String, result: Result) {
    try {
      Zendesk.initialize(
        context = context,
        channelKey = channelKey,
        successCallback = { zendesk ->
          Log.i(TAG, "Zendesk initialization successful")
          isZendeskInitialized = true
          // Safe cast to the appropriate Messaging type
          messagingInstance = zendesk.messaging as? Messaging
          result.success(true)
        },
        failureCallback = { error ->
          Log.e(TAG, "Zendesk initialization failed", error)
          isZendeskInitialized = false
          messagingInstance = null
          result.error("INITIALIZATION_FAILED", error.message, null)
        },
        messagingFactory = DefaultMessagingFactory()
      )
    } catch (e: Exception) {
      Log.e(TAG, "Exception during Zendesk initialization", e)
      result.error("EXCEPTION", e.message, null)
    }
  }

  private fun showZendeskMessages(result: Result) {
    try {
      if (!isZendeskInitialized) {
        result.error("NOT_INITIALIZED", "Zendesk SDK is not initialized", null)
        return
      }

      if (activity == null) {
        result.error("ACTIVITY_UNAVAILABLE", "Activity is not available", null)
        return
      }

      activity?.let {
        messagingInstance?.showMessaging(it)
        result.success(true)
      }
    } catch (e: Exception) {
      Log.e(TAG, "Exception showing Zendesk messages", e)
      result.error("EXCEPTION", e.message, null)
    }
  }

  private fun getUnreadMessages(result: Result) {
    try {
      if (!isZendeskInitialized) {
        result.error("NOT_INITIALIZED", "Zendesk SDK is not initialized", null)
        return
      }

      // Get unread message count
      val count = messagingInstance?.getUnreadMessageCount() ?: 0
      result.success(count)
    } catch (e: Exception) {
      Log.e(TAG, "Exception getting unread message count", e)
      result.error("EXCEPTION", e.message, null)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
