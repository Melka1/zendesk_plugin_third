# Zendesk Plugin for Flutter

A Flutter plugin for integrating Zendesk Messaging SDK with Android applications.

## Features

- Initialize the Zendesk Messaging SDK
- Show the Zendesk conversation screen
- Get unread message count

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  zendesk_plugin_third: ^1.0.0
```

## Requirements

### Android

- Minimum SDK version: 21
- Target SDK version: 32 or higher
- Java 8 compatibility

## Getting Started

### 1. Obtain your Zendesk Channel Key

Before using the plugin, you need to obtain a channel key from the Zendesk Admin Center. For instructions, see [Working with messaging in the Zendesk SDKs for Android and iOS](https://support.zendesk.com/hc/en-us/articles/1260801714930).

### 2. Initialize the SDK

Initialize the Zendesk SDK early in your application's lifecycle:

```dart
import 'package:zendesk_plugin_third/zendesk_plugin.dart';

// In your app initialization
Future<void> initializeZendesk() async {
  try {
    final isInitialized = await ZendeskPlugin.initialize(
      channelKey: 'YOUR_ZENDESK_CHANNEL_KEY',
    );
    print('Zendesk SDK initialized: $isInitialized');
  } catch (e) {
    print('Failed to initialize Zendesk: $e');
  }
}
```

### 3. Show the Zendesk Conversation Screen

When you want to show the conversation screen to the user:

```dart
Future<void> showZendeskChat() async {
  try {
    await ZendeskPlugin.showMessages();
  } catch (e) {
    print('Error showing Zendesk messages: $e');
  }
}
```

### 4. Get Unread Message Count

To retrieve the current unread message count:

```dart
Future<void> checkUnreadMessages() async {
  try {
    final count = await ZendeskPlugin.getUnreadMessageCount();
    print('Unread messages: $count');
  } catch (e) {
    print('Error getting unread count: $e');
  }
}
```

## Complete Example

See the `zendesk_example.dart` file in the package for a full implementation example including a ready-to-use support button widget with badge for unread messages.

## Android Configuration

The plugin automatically adds the following to your AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

To support API level 25 and below, add the desugar_jdk_libs dependency:

```groovy
android {
  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
  }
}

dependencies {
  coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.1.5'
}
```

## Troubleshooting

- **SDK not initialized error**: Make sure you call `ZendeskPlugin.initialize()` before any other Zendesk method calls.
- **Unread count always returns 0**: The unread count is updated after user interactions with the conversation screen or when new messages arrive through push notifications.
- **Android build fails**: Ensure that your project is configured with Java 8 compatibility and has access to the Zendesk Maven repository.

## License

This plugin is available under the MIT license.
