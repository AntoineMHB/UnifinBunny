import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Motion data model to track accelerometer readings
class MotionData {
  final DateTime timestamp;
  final double motionIntensity;

  MotionData(this.timestamp, this.motionIntensity);
}

class MotionDetectionPage extends StatefulWidget {
  @override
  _MotionDetectionPageState createState() => _MotionDetectionPageState();
}

class _MotionDetectionPageState extends State<MotionDetectionPage> {
  // Motion sensor data
  List<MotionData> motionIntensityData = [];

  // Notification plugin
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Motion status
  bool isMoving = false;
  double currentMotionIntensity = 0.0;

  // Sensor stream subscription
  StreamSubscription? _accelerometerSubscription;

  // Threshold for detecting significant movement
  static const double MOVEMENT_THRESHOLD = 2.0;

  // Debounce for notifications
  DateTime? _lastNotificationTime;
  static const Duration NOTIFICATION_COOLDOWN = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();

    // Initialize notification plugin
    _initNotifications();

    // Start listening to accelerometer
    _startMotionDetection();
  }

  void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _startMotionDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculate motion intensity using vector magnitude
      double motionIntensity = sqrt(
          pow(event.x, 2) +
              pow(event.y, 2) +
              pow(event.z, 2)
      );

      setState(() {
        currentMotionIntensity = motionIntensity;

        // Add new motion data point
        motionIntensityData.add(MotionData(DateTime.now(), motionIntensity));

        // Keep only last 20 data points
        if (motionIntensityData.length > 20) {
          motionIntensityData.removeAt(0);
        }

        // Check for significant movement
        _checkMotionAndNotify(motionIntensity);
      });
    });
  }

  void _checkMotionAndNotify(double motionIntensity) {
    // Detect significant movement
    if (motionIntensity > MOVEMENT_THRESHOLD) {
      // Prevent too frequent notifications
      if (_lastNotificationTime == null ||
          DateTime.now().difference(_lastNotificationTime!) > NOTIFICATION_COOLDOWN) {
        _sendMotionDetectionNotification(motionIntensity);
        _lastNotificationTime = DateTime.now();
      }

      setState(() {
        isMoving = true;
      });
    } else {
      setState(() {
        isMoving = false;
      });
    }
  }

  void _sendMotionDetectionNotification(double intensity) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'motion_channel',
      'Motion Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Movement Detected',
      'Motion intensity: ${intensity.toStringAsFixed(2)}',
      platformChannelSpecifics,
    );
  }

  @override
  void dispose() {
    // Cancel sensor subscription to prevent memory leaks
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motion Detection'),
      ),
      body: Column(
        children: [
          // Motion intensity chart
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(text: 'Time'),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Motion Intensity'),
            ),
            series: <LineSeries<MotionData, DateTime>>[
              LineSeries<MotionData, DateTime>(
                dataSource: motionIntensityData,
                xValueMapper: (MotionData data, _) => data.timestamp,
                yValueMapper: (MotionData data, _) => data.motionIntensity,
                color: isMoving ? Colors.red : Colors.blue,
              )
            ],
          ),

          // Current motion status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Current Motion Intensity: ${currentMotionIntensity.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  isMoving ? 'Movement Detected!' : 'No Significant Movement',
                  style: TextStyle(
                    fontSize: 18,
                    color: isMoving ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}