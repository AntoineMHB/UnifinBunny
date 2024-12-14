import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BatteryService {
  // Singleton pattern
  static final BatteryService _instance = BatteryService._internal();
  factory BatteryService() => _instance;
  BatteryService._internal();

  // Battery and notification plugins
  final Battery _battery = Battery();
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Notification tracking
  DateTime? _lastNotificationTime;
  static const Duration NOTIFICATION_COOLDOWN = Duration(minutes: 5);

  // Initialize the service
  Future<void> init() async {
    // Initialize notification plugin
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Start monitoring battery
    startBatteryMonitoring();
  }

  // Start continuous battery monitoring
  void startBatteryMonitoring() {
    // Check initial battery level
    _checkBatteryLevel();

    // Set up listener for battery state changes
    _battery.onBatteryStateChanged.listen((_) {
      _checkBatteryLevel();
    });
  }

  // Check and potentially notify about battery level
  Future<void> _checkBatteryLevel() async {
    try {
      // Get current battery level and state
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;

      // Determine notification conditions
      if (_shouldSendNotification(batteryLevel, batteryState)) {
        _sendBatteryNotification(batteryLevel, batteryState);
      }
    } catch (e) {
      print('Error checking battery level: $e');
    }
  }

  // Decide whether to send a notification
  bool _shouldSendNotification(int batteryLevel, BatteryState batteryState) {
    // Prevent too frequent notifications
    if (_lastNotificationTime != null &&
        DateTime.now().difference(_lastNotificationTime!) < NOTIFICATION_COOLDOWN) {
      return false;
    }

    // Low battery warning (20% or less and discharging)
    if (batteryLevel <= 20 &&
        (batteryState == BatteryState.discharging || batteryState == BatteryState.unknown)) {
      return true;
    }

    // Fully charged notification
    if (batteryLevel >= 95 && batteryState == BatteryState.full) {
      return true;
    }

    return false;
  }

  // Send battery level notification
  Future<void> _sendBatteryNotification(int batteryLevel, BatteryState batteryState) async {
    // Prepare notification details
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'battery_channel',
      'Battery Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Determine notification content based on battery state
    String title;
    String body;

    if (batteryLevel <= 20) {
      title = 'Low Battery Warning';
      body = 'Battery level is at $batteryLevel%. Please charge your device soon.';
    } else {
      title = 'Battery Fully Charged';
      body = 'Battery level is at $batteryLevel%. You can unplug your charger.';
    }

    // Send the notification
    await _flutterLocalNotificationsPlugin.show(
      1, // Unique notification ID
      title,
      body,
      platformChannelSpecifics,
    );

    // Update last notification time
    _lastNotificationTime = DateTime.now();
  }

  // Get current battery level
  Future<int> getBatteryLevel() async {
    return await _battery.batteryLevel;
  }

  // Get current battery state
  Future<BatteryState> getBatteryState() async {
    return await _battery.batteryState;
  }
}