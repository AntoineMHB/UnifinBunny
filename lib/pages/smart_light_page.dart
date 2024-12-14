import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Light data model
class LightData {
  final DateTime timestamp;
  final double illuminance;

  LightData(this.timestamp, this.illuminance);
}

class SmartLightPage extends StatefulWidget {
  @override
  State<SmartLightPage> createState() => _SmartLightPageState();
}

class _SmartLightPageState extends State<SmartLightPage> {
  // Light sensor data
  List<LightData> lightIntensityData = [];

  // Notification plugin
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Light status
  bool isLampOn = false;
  double currentLightIntensity = 0.0;

  // Sensor stream subscription
  StreamSubscription? _lightSensorSubscription;

  // Notification permission status
  bool _notificationPermissionGranted = false;

  @override
  void initState() {
    super.initState();

    // Initialize notification plugin
    _initNotifications();

    // Request notification permissions
    _requestNotificationPermissions();
  }

  void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    setState(() {
      _notificationPermissionGranted = status.isGranted;

      if (_notificationPermissionGranted) {
        // Start listening to light sensor only after permissions are granted
        _startLightSensorListener();
      }
    });
  }

  void _startLightSensorListener() {
    _lightSensorSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Process light sensor data (Note: this is a placeholder, as Flutter doesn't have a direct light sensor API)
      setState(() {
        // Add new light data point (using accelerometer as a proxy)
        currentLightIntensity = event.x.abs(); // Just an example, not actual light intensity

        // Keep only last 10 data points
        lightIntensityData.add(LightData(DateTime.now(), currentLightIntensity));
        if (lightIntensityData.length > 10) {
          lightIntensityData.removeAt(0);
        }

        // Check and send notification
        _checkLightIntensityAndNotify();
      });
    });
  }

  void _checkLightIntensityAndNotify() {
    if (currentLightIntensity < 5.0) {
      if (!isLampOn) {
        // Send low light notification
        _sendLightNotification(
            title: 'Low Light Detected',
            body: 'There\'s not enough light, switch on the lamps'
        );
        setState(() {
          isLampOn = true;
        });
      }
    } else if (currentLightIntensity >= 5.0) {
      if (isLampOn) {
        // Send high light notification
        _sendLightNotification(
            title: 'High Light Detected',
            body: 'There\'s enough light, switch off the lamps'
        );
        setState(() {
          isLampOn = false;
        });
      }
    }
  }

  void _sendLightNotification({required String title, required String body}) async {
    if (!_notificationPermissionGranted) return;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'light_channel',
      'Light Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  @override
  void dispose() {
    _lightSensorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if notification permissions are granted
    if (!_notificationPermissionGranted) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.smartLightText),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Notification Permissions Required'),
              ElevatedButton(
                onPressed: _requestNotificationPermissions,
                child: Text('Grant Permissions'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Light'),
      ),
      body: Column(
        children: [
          // Chart with blue color for light intensity
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: <LineSeries<LightData, DateTime>>[
              LineSeries<LightData, DateTime>(
                dataSource: lightIntensityData,
                xValueMapper: (LightData data, _) => data.timestamp,
                yValueMapper: (LightData data, _) => data.illuminance,
                color: Colors.blue, // Blue curve for light intensity
                width: 3, // Slightly thicker line
              )
            ],
          ),
          Text('Current Light Intensity: ${currentLightIntensity.toStringAsFixed(2)}')
        ],
      ),
    );
  }
}