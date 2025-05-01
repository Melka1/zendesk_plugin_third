package com.example.zendesk_plugin_third

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.PluginRegistry

object ZendeskPluginPluginRegistrant {
  fun registerWith(registry: PluginRegistry) {
    if (alreadyRegisteredWith(registry)) {
      return
    }
    
    // This is where we actually register the plugin with the registry
    registry.registrarFor(ZendeskPluginPlugin::class.java.canonicalName)
      ?.let { ZendeskPluginPlugin().onAttachedToEngine(it.messenger()) }
  }

  private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
    val key = ZendeskPluginPlugin::class.java.canonicalName
    if (registry.registrarFor(key) != null) {
      return true
    }
    return false
  }
}
