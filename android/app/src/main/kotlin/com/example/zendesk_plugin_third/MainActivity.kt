package com.example.zendesk_plugin_third

override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine)
    flutterEngine.plugins.add(ZendeskPluginPlugin())
}

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // Remove the manual plugin registration as it will be handled by the plugin registry
        // flutterEngine.plugins.add(ZendeskPluginPlugin())
    }
}
