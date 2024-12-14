// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
//
//
// class LocationTrackingPage extends StatefulWidget {
//   @override
//   _LocationTrackingPageState createState() => _LocationTrackingPageState();
// }
//
// class _LocationTrackingPageState extends State<LocationTrackingPage> {
//   // Map controller
//   Completer<GoogleMapController> _mapController = Completer();
//
//   // Initial location
//   geo.Position? _initialPosition;
//   geo.Position? _currentPosition;
//
//   // Notification plugin
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   // Geofencing parameters
//   static const double GEOFENCE_RADIUS = 5.0; // 5 meters
//   bool _hasLeftGeofence = false;
//
//   // Markers
//   Set<Marker> _markers = {};
//
//   // Location stream subscription
//   StreamSubscription<geo.Position>? _locationSubscription;
//
//   // Permission status
//   bool _locationPermissionGranted = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize notification plugin
//     _initNotifications();
//
//     // Request location permissions
//     _requestLocationPermissions();
//   }
//
//   void _initNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> _requestLocationPermissions() async {
//     // Request location permissions using permission_handler
//     final locationStatus = await Permission.location.request();
//
//     setState(() {
//       _locationPermissionGranted = locationStatus.isGranted;
//     });
//
//     if (_locationPermissionGranted) {
//       // Check if location services are enabled
//       bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         // Show dialog to enable location services
//         _showLocationServiceDialog();
//         return;
//       }
//
//       // Start location tracking
//       _startLocationTracking();
//     }
//   }
//
//   void _showLocationServiceDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Location Services Disabled'),
//           content: Text('Please enable location services to use this feature.'),
//           actions: [
//             TextButton(
//               child: Text('Open Settings'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 geo.Geolocator.openLocationSettings();
//               },
//             ),
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _startLocationTracking() async {
//     // Get initial position
//     try {
//       _initialPosition = await geo.Geolocator.getCurrentPosition();
//
//       // Update map with initial position
//       _updateMapLocation(_initialPosition!);
//
//       // Start location updates
//       _locationSubscription = geo.Geolocator.getPositionStream(
//         locationSettings: geo.LocationSettings(
//           accuracy: geo.LocationAccuracy.high,
//           distanceFilter: 1, // Minimum distance (in meters) between location updates
//         ),
//       ).listen(_onLocationUpdate);
//     } catch (e) {
//       // Handle any errors in getting location
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error getting location: $e')),
//       );
//     }
//   }
//
//   void _updateMapLocation(geo.Position position) async {
//     final GoogleMapController controller = await _mapController.future;
//
//     // Move camera to new location
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(position.latitude, position.longitude),
//           zoom: 16,
//         ),
//       ),
//     );
//
//     // Update markers
//     setState(() {
//       _markers.clear();
//       _markers.add(
//         Marker(
//           markerId: MarkerId('current_location'),
//           position: LatLng(position.latitude, position.longitude),
//           infoWindow: InfoWindow(
//             title: 'Current Location',
//             snippet: 'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
//           ),
//         ),
//       );
//     });
//   }
//
//   void _onLocationUpdate(geo.Position position) {
//     // Calculate distance from initial position
//     double distanceFromInitial = geo.Geolocator.distanceBetween(
//       _initialPosition!.latitude,
//       _initialPosition!.longitude,
//       position.latitude,
//       position.longitude,
//     );
//
//     setState(() {
//       _currentPosition = position;
//
//       // Check geofencing condition
//       _checkGeofence(distanceFromInitial);
//
//       // Update map location
//       _updateMapLocation(position);
//     });
//   }
//
//   void _checkGeofence(double distance) {
//     // Check if user has left the geofence
//     if (distance > GEOFENCE_RADIUS && !_hasLeftGeofence) {
//       _sendGeofenceNotification();
//       setState(() {
//         _hasLeftGeofence = true;
//       });
//     } else if (distance <= GEOFENCE_RADIUS) {
//       setState(() {
//         _hasLeftGeofence = false;
//       });
//     }
//   }
//
//   void _sendGeofenceNotification() async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'geofence_channel',
//       'Geofencing Notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Geofence Alert',
//       'You have moved more than 5 meters from your initial position',
//       platformChannelSpecifics,
//     );
//   }
//
//   @override
//   void dispose() {
//     // Cancel location subscription
//     _locationSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // If permissions are not granted, show permission request screen
//     if (!_locationPermissionGranted) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Location Tracking'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Location Permissions Required'),
//               ElevatedButton(
//                 onPressed: _requestLocationPermissions,
//                 child: Text('Grant Permissions'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // If initial position is not set, show loading
//     if (_initialPosition == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Location Tracking'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     // Main location tracking view
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Tracking'),
//       ),
//       body: Column(
//         children: [
//           // Google Maps Widget
//           Expanded(
//             child: GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                     _initialPosition!.latitude,
//                     _initialPosition!.longitude
//                 ),
//                 zoom: 16,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController.complete(controller);
//               },
//               markers: _markers,
//             ),
//           ),
//
//           // Location Details
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 if (_currentPosition != null)
//                   Text(
//                     'Current Position: '
//                         '${_currentPosition!.latitude.toStringAsFixed(4)}, '
//                         '${_currentPosition!.longitude.toStringAsFixed(4)}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 SizedBox(height: 10),
//                 Text(
//                   _hasLeftGeofence
//                       ? 'Geofence Boundary Crossed!'
//                       : 'Within Geofence',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: _hasLeftGeofence ? Colors.red : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationTrackingPage extends StatefulWidget {
  const LocationTrackingPage({super.key});

  @override
  State<LocationTrackingPage> createState() => _LocationTrackingPageState();
}

class _LocationTrackingPageState extends State<LocationTrackingPage> {
  final _geofenceService = GeofenceService.instance.setup(
    interval: 5000,
    accuracy: 100,
    loiteringDelayMs: 60000,
    statusChangeDelayMs: 10000,
    useActivityRecognition: true,
    allowMockLocations: false,
    printDevLog: true,
    geofenceRadiusSortType: GeofenceRadiusSortType.ASC,
  );

  List<Geofence> _geofenceList = [];
  geo.Position? _initialPosition;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  GoogleMapController? _mapController;
  Set<Circle> _circles = {};
  CameraPosition? _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _setupGeofenceAndMap();
  }

  void _initializeNotifications() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _setupGeofenceAndMap() async {
    try {
      bool serviceEnabled;
      geo.LocationPermission permission;

      serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.locationPermissionsDesabledText)),
        );
        return;
      }

      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Location permissions are denied")),
          );
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permissions are permanently denied")),
        );
        return;
      }

      _initialPosition = await geo.Geolocator.getCurrentPosition();

      setState(() {
        _initialCameraPosition = CameraPosition(
            target: LatLng(_initialPosition!.latitude, _initialPosition!.longitude),
            zoom: 15,
        );

        _geofenceList = [
          Geofence(
            id: 'current_location',
            latitude: _initialPosition!.latitude,
            longitude: _initialPosition!.longitude,
            radius: [GeofenceRadius(id: 'radius_5m', length: 5.0)],
          ),
        ];
      });


      WidgetsBinding.instance.addPostFrameCallback((_) {
        _geofenceService
            .addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
        _geofenceService.addLocationChangeListener(_onLocationChanged);
        _geofenceService.addLocationServicesStatusChangeListener(
            _onLocationServicesStatusChanged);
        _geofenceService.addActivityChangeListener(_onActivityChanged);
        _geofenceService.addStreamErrorListener(_onError);
        _geofenceService.start(_geofenceList).catchError(_onError);
      });
    } catch (e) {
      print("Error setting up geofence and map: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error setting up location: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.locationTrackingText),
      ),
      body: _initialCameraPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: _initialCameraPosition!,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        circles: _circles,
    ),
    );
  }

  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    print('Geofence Status FULL DEBUG: geofence=$geofence, radius=$geofenceRadius, status=$geofenceStatus, location=$location');

    if (geofenceStatus == GeofenceStatus.EXIT) {
      print('Geofence EXIT detected');
      await _showNotification(
          'You have moved more than 5 meters from your initial position.');
    }
    _updateMap(LatLng(location.latitude, location.longitude));
  }

  void _onLocationChanged(Location location) {
    print('Location Change FULL DEBUG: lat=${location.latitude}, lon=${location.longitude}');

    double distance = geo.Geolocator.distanceBetween(
      _initialPosition!.latitude,
      _initialPosition!.longitude,
      location.latitude,
      location.longitude,
    );

    print('Distance from initial position: $distance meters');

    if (distance > 5) {
      print('Distance threshold exceeded, showing notification');
      _showNotification(
          'You have moved more than 5 meters from your initial position.');
    }
    _updateMap(LatLng(location.latitude, location.longitude));
  }

  void _updateMap(LatLng newPosition) {
    setState(() {
      _circles = {
        Circle(
          circleId: CircleId('currentLocation'),
          center: newPosition,
          radius: 5,
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
        Circle(
          circleId: CircleId('geofence'),
          center: LatLng(_initialPosition!.latitude, _initialPosition!.longitude),
          radius: 5,
          fillColor: Colors.red.withOpacity(0.3),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      };
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
  }

  void _onLocationServicesStatusChanged(bool status) {
    print('Location services status: $status');
  }

  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('Current activity: ${currActivity.type}');
  }

  void _onError(error) {
    print('Error: $error');
  }

  Future<void> _showNotification(String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'geofence_channel',
      'Geofence Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Location Alert',
      message,
      platformChannelSpecifics,
    );
  }
}