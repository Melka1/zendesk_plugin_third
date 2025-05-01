import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ZendeskPlugin {
  static const MethodChannel _channel = MethodChannel('zendesk_plugin_third');
  
  static Future<bool> initialize({required String channelKey}) async {
    try {
      final bool result = await _channel.invokeMethod('initialize', {
        'channelKey': channelKey,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint('Failed to initialize Zendesk: ${e.message}');
      return false;
    }
  }
  
  static Future<bool> showMessages() async {
    try {
      final bool result = await _channel.invokeMethod('showMessages');
      return result;
    } on PlatformException catch (e) {
      debugPrint('Failed to show Zendesk messages: ${e.message}');
      return false;
    }
  }
  
  static Future<int> getUnreadMessageCount() async {
    try {
      final int count = await _channel.invokeMethod('getUnreadMessageCount');
      return count;
    } on PlatformException catch (e) {
      debugPrint('Failed to get unread message count: ${e.message}');
      return 0;
    }
  }
}
