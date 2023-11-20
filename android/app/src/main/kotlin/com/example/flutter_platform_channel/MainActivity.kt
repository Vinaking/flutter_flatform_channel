package com.example.flutter_platform_channel

import MessageApi
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.*
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONException
import org.json.JSONObject
import java.nio.ByteBuffer
import java.nio.ByteOrder

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))

        demoMethodChannelString()
        demoMethodChannelJson()

        demoBasicMessageChannelString()
        demoBasicMessageChannelJson()
        demoBasicMessageChannelBinary()
        demoBasicMessageChannelStandard()

        demoEventChannel()
    }

    // Pigeon
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MessageApi.setUp(flutterEngine.dartExecutor.binaryMessenger, MyMessageApi())
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("NativeViewType",
                NativeViewFactory())
    }

    override fun onDestroy() {
        super.onDestroy()
        if (callback != null) {
            handler.removeCallbacks(callback!!)
        }
    }

    companion object {
        const val StringCodecChannel = "StringCodec"
        const val JSONMessageCodecChannel = "JSONMessageCodec"
        const val BinaryCodecChannel = "BinaryCodec"
        const val StandardMessageCodecChannel = "StandardMessageCodec"

        const val StreamChannel = "stream"
    }

    // METHOD CHANNEL

    private fun demoMethodChannelString() {
        flutterEngine?.let {
            MethodChannel(it.dartExecutor.binaryMessenger, "com.flutter/method1")
                .setMethodCallHandler { call, result ->
                    if (call.method.equals("getDeviceInfoString")) {
                        val type = call.argument<String>("type") ?: ""
                        if (type.isEmpty()) {
                            result.error("ERROR", "type can not null", null)
                            return@setMethodCallHandler
                        }

                        result.success(getDeviceInfoString(type))
                        return@setMethodCallHandler
                    }

                    result.notImplemented()
                }
        }

    }

    private fun demoMethodChannelJson() {
        flutterEngine?.let {
            MethodChannel(
                it.dartExecutor.binaryMessenger,
                "com.flutter/method2",
                JSONMethodCodec.INSTANCE
            )
                .setMethodCallHandler { call, result ->
                    if (call.method.equals("getDeviceInfo")) {
                        val type = call.argument<String>("type") ?: ""
                        if (type.isEmpty()) {
                            result.error("ERROR", "type can not null", null)
                            return@setMethodCallHandler
                        }
                        result.success(getDeviceInfo(type))
                        return@setMethodCallHandler
                    }
                    result.notImplemented()
                }
        }
    }

    private fun getDeviceInfoString(type: String): String? {
        return if (type == "MODEL") {
            Build.MODEL
        } else null
    }

    private fun getDeviceInfo(type: String): JSONObject? {
        val json = JSONObject()
        if (type == "MODEL") {
            try {
                json.put("model", Build.MODEL)
                json.put("device", Build.DEVICE)
                json.put("time", Build.TIME)
            } catch (e: JSONException) {
                e.printStackTrace()
            }
            return json
        }
        return null
    }

    // BASIC MESSAGE CHANNEL

    private fun demoBasicMessageChannelString() {
        flutterEngine?.let {
            val messageChannel = BasicMessageChannel<String>(
                it.dartExecutor.binaryMessenger,
                StringCodecChannel,
                StringCodec.INSTANCE
            )
            messageChannel.setMessageHandler { message, reply ->
                messageChannel.send("Hello " + message + " from native code")
                reply.reply(null)
            }
        }
    }

    private fun demoBasicMessageChannelJson() {
        flutterEngine?.let {
            val messageChannel = BasicMessageChannel<Any>(
                it.dartExecutor.binaryMessenger,
                JSONMessageCodecChannel,
                JSONMessageCodec.INSTANCE
            )
            messageChannel.setMessageHandler { message, reply ->
                val jsonObject = JSONObject()
                try {
                    jsonObject.put("name", message)
                    jsonObject.put("phone", "0396106619")
                    jsonObject.put("email", "tungh@yah.com")
                } catch (_: Exception) {
                }
                messageChannel.send(jsonObject)
                reply.reply(null)
            }
        }
    }

    private fun demoBasicMessageChannelBinary() {
        flutterEngine?.let {
            val messageChannel = BasicMessageChannel(
                it.dartExecutor.binaryMessenger,
                BinaryCodecChannel,
                BinaryCodec.INSTANCE
            )
            messageChannel.setMessageHandler { message, reply ->
                message?.order(ByteOrder.nativeOrder())
                val echo = ByteBuffer.allocateDirect(16)
                echo.putDouble(123.456)

                reply.reply(echo)
            }
        }
    }

    private fun demoBasicMessageChannelStandard() {
        val messageChannel = BasicMessageChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            StandardMessageCodecChannel,
            StandardMessageCodec.INSTANCE
        )
        messageChannel.setMessageHandler { message, reply ->
            val list = message as MutableList<Int>?
            for (i in list!!.indices) {
                list[i] = list[i] * 10
            }
            reply.reply(list)
        }
    }

    // EVENT CHANNEL
    var handler: Handler = Handler(Looper.getMainLooper())
    var i = 0
    var callback: Runnable? = null

    private fun buildCallBack(events: EventSink): Runnable? {
        if (callback == null) {
            callback = Runnable {
                events.success(i++.toString())
                handler.postDelayed(callback!!, 500)
            }
        }
        return callback
    }

    private fun demoEventChannel() {
        flutterEngine?.let {
            EventChannel(it.dartExecutor.binaryMessenger, StreamChannel)
                .setStreamHandler(object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventSink?) {
                        events?.let {
                            buildCallBack(events)?.let { it ->
                                handler.postDelayed(it, 500)
                            }
                        }

                    }

                    override fun onCancel(arguments: Any) {}
                })
        }

    }
}
