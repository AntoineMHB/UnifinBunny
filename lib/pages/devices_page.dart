import 'package:carousel_slider/carousel_slider.dart';
import 'package:damaz/pages/location_tracking_page.dart';
import 'package:damaz/pages/motion_detection_page.dart';
import 'package:damaz/pages/smart_light_page.dart';
import 'package:damaz/themes/theme_provider.dart';
import 'package:damaz/utils/responsive_util.dart';
import 'package:damaz/utils/smart_device_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../themes/color_schemes.dart';


class DevicesPage extends StatefulWidget {
  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isSearching = false;

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  late List mySmartDevices;


  // power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
  }
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });

    });
  }

  void _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      _searchQuery = "";
    });
  }
  @override
  Widget build(BuildContext context) {
    // list of smart devices
     mySmartDevices = [
      // [ smartDeviceName, iconPath, powerStatus, statusText ]
      [AppLocalizations.of(context)!.smartDevicesText, "lib/images/light-bulb.png", true, SmartLightPage()],
      [AppLocalizations.of(context)!.motionDetectionText, "lib/images/motionIcon.png", false, MotionDetectionPage()],
      [AppLocalizations.of(context)!.locationTrackingText, "lib/images/gpsIcon.png", false, LocationTrackingPage()],
      [AppLocalizations.of(context)!.smartFunText, "lib/images/air-conditioner.png", false, SmartLightPage()],
    ];

    ResponsiveUtil().init(context);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    final themeProvider = Provider.of<ThemeProvider>(context);

    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;
    final secondaryColor =
    isLightMode ? ColorSchemes.secondaryLight : ColorSchemes.secondaryDark;
    final textColor =
    isLightMode ? ColorSchemes.textLight : ColorSchemes.textDark;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // custom app bar
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // menu icon
                      Image.asset(
                        'lib/images/menu.png',
                        height: 45,
                        color: Colors.grey[800],
                      ),

                      // account icon
                      Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.grey[800],
                      )
                    ],
                  ),
                  ),

                  const SizedBox(height: 20),

                  // welcome home
                  Padding(padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcomeDevicesPage,
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                      ),
                      Text(
                        "ALPHIE",
                        style: GoogleFonts.bebasNeue(
                          fontSize: 72,
                        ),
                      )
                    ],
                  ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Divider(
                        color: Colors.grey[200],
                        thickness: 1,
                      ),
                  ),

                  const SizedBox(height: 25),

                  // Smart devices + grid
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Text(
                        AppLocalizations.of(context)!.smartDevicesText,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        selectionColor: Colors.grey[800],
                      ),
                  ),

                  Expanded(
                      child: CarouselSlider.builder(
                        itemCount: mySmartDevices.length,
                        options: CarouselOptions(
                          height: 400,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          viewportFraction: 0.8,
                        ),
                        itemBuilder: (context, index, realIndex){
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the specific device page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => mySmartDevices[index][3],
                                  ),
                              );
                            },
                            child: SmartDeviceBox(
                                smartDeviceName: mySmartDevices[index][0],
                                iconPath: mySmartDevices[index][1],
                                powerOn: mySmartDevices[index][2],
                                onChanged: (value) => powerSwitchChanged(value, index),
                            ),
                          );
                        },
                      )
                  )
                ],
              ))),
    );
  }
}
