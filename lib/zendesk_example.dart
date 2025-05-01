import 'package:flutter/material.dart';
import 'zendesk_plugin.dart';

class ZendeskExampleImplementation {
  static const String channelKey = 'YOUR_ZENDESK_CHANNEL_KEY';
  
  static Future<bool> initializeZendesk() async {
    try {
      // Initialize Zendesk with your channel key
      final bool isInitialized = await ZendeskPlugin.initialize(
        channelKey: channelKey,
      );
      
      print('Zendesk SDK initialized: $isInitialized');
      return isInitialized;
    } catch (e) {
      print('Failed to initialize Zendesk: $e');
      return false;
    }
  }
  
  static Future<void> showZendeskMessages() async {
    try {
      await ZendeskPlugin.showMessages();
    } catch (e) {
      print('Error showing Zendesk messages: $e');
    }
  }
  
  static Future<int> getUnreadCount() async {
    try {
      return await ZendeskPlugin.getUnreadMessageCount();
    } catch (e) {
      print('Error getting unread message count: $e');
      return 0;
    }
  }
}

class ZendeskSupportButton extends StatefulWidget {
  final String buttonText;
  
  const ZendeskSupportButton({
    Key? key, 
    this.buttonText = 'Contact Support',
  }) : super(key: key);

  @override
  _ZendeskSupportButtonState createState() => _ZendeskSupportButtonState();
}

class _ZendeskSupportButtonState extends State<ZendeskSupportButton> {
  bool _isInitialized = false;
  int _unreadCount = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeZendeskAndGetUnreadCount();
  }
  
  Future<void> _initializeZendeskAndGetUnreadCount() async {
    final initialized = await ZendeskExampleImplementation.initializeZendesk();
    
    if (initialized) {
      final unreadCount = await ZendeskExampleImplementation.getUnreadCount();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _unreadCount = unreadCount;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton(
          onPressed: _isInitialized
              ? () => ZendeskExampleImplementation.showZendeskMessages()
              : null,
          child: Text(widget.buttonText),
        ),
        if (_unreadCount > 0)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                _unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Usage example:
/// 
/// In your app's UI, simply add the ZendeskSupportButton where you want your
/// support button to appear:
/// 
/// ```dart
/// Scaffold(
///   appBar: AppBar(title: Text('My App')),
///   body: Center(
///     child: ZendeskSupportButton(
///       buttonText: 'Help & Support',
///     ),
///   ),
/// )
/// ```
