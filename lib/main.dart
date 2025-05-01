import 'package:flutter/material.dart';
import 'zendesk_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zendesk Plugin Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Zendesk Plugin Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isInitialized = false;
  int _unreadCount = 0;
  final TextEditingController _channelKeyController = TextEditingController();

  @override
  void dispose() {
    _channelKeyController.dispose();
    super.dispose();
  }

  Future<void> _initializeZendesk() async {
    // In a real app, you would store the channel key securely
    final channelKey = _channelKeyController.text.trim();
    
    if (channelKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid channel key')),
      );
      return;
    }

    try {
      final isInitialized = await ZendeskPlugin.initialize(channelKey: channelKey);
      setState(() {
        _isInitialized = isInitialized;
      });

      if (isInitialized) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zendesk SDK initialized successfully')),
        );
        // Get initial unread count
        _getUnreadMessageCount();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to initialize Zendesk SDK')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showMessages() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please initialize Zendesk SDK first')),
      );
      return;
    }

    try {
      final result = await ZendeskPlugin.showMessages();
      if (result) {
        // Update unread count after conversation is shown
        _getUnreadMessageCount();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error showing messages: $e')),
      );
    }
  }

  Future<void> _getUnreadMessageCount() async {
    if (!_isInitialized) return;

    try {
      final count = await ZendeskPlugin.getUnreadMessageCount();
      setState(() {
        _unreadCount = count;
      });
    } catch (e) {
      debugPrint('Failed to get unread count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Zendesk Messaging SDK Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text('1. Initialize the SDK with your channel key:'),
            const SizedBox(height: 8),
            TextField(
              controller: _channelKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your Zendesk channel key',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeZendesk,
              child: const Text('Initialize Zendesk SDK'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('2. Show the Zendesk Messaging screen:'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isInitialized ? _showMessages : null,
              child: const Text('Show Messages'),
            ),
            if (_isInitialized) ...[  
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Unread message count: ', 
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('$_unreadCount',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _getUnreadMessageCount,
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ],
            const Spacer(),
            Text(
              'Status: ${String.fromCharCode(0x2022)} SDK ${String.fromCharCode(0x2022)} ${_isInitialized ? 'Initialized' : 'Not Initialized'}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
