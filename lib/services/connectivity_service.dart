import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged.map((result) {
    // Convert ConnectivityResult to boolean
    return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
});

  Future<bool> get initialConnection async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
  }

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  ConnectivityResult _currentStatus = ConnectivityResult.none;
  ConnectivityResult get currentStatus => _currentStatus;

  DateTime? _lastNotificationTime;
  static const Duration NOTIFICATION_COOLDOWN = Duration(minutes: 5);

  Future<void> init(BuildContext context) async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final result = await Connectivity().checkConnectivity();
    _handleConnectivityChange(context, result as ConnectivityResult);

    Connectivity().onConnectivityChanged.listen((dynamic event) {
      if (event is List<ConnectivityResult>) {
        if (event.isNotEmpty) {
          _handleConnectivityChange(context, event.first);
        }
      } else if (event is ConnectivityResult) {
        _handleConnectivityChange(context, event);
      }
    });
  }

  void _handleConnectivityChange(BuildContext context, ConnectivityResult result) {
    _currentStatus = result;

    if (_lastNotificationTime == null ||
        DateTime.now().difference(_lastNotificationTime!) > NOTIFICATION_COOLDOWN) {
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        _sendConnectivityNotification(true);
      } else if (result == ConnectivityResult.none) {
        _sendConnectivityNotification(false);
      }
      _lastNotificationTime = DateTime.now();
    }
  }

  void _sendConnectivityNotification(bool isConnected) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'connectivity_channel',
      'Connectivity Notifications',
      importance: Importance.low,
      priority: Priority.low,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      isConnected ? 'Connected to Internet' : 'No Internet Connection',
      isConnected
          ? 'You are currently connected to the internet'
          : 'You are currently not connected to the internet',
      platformChannelSpecifics,
    );
  }

  bool get isConnected =>
      _currentStatus == ConnectivityResult.wifi || _currentStatus == ConnectivityResult.mobile;
}
