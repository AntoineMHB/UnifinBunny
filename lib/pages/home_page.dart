import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:damaz/components/my_current_location.dart';
import 'package:damaz/components/my_description_box.dart';
import 'package:damaz/components/my_drawer.dart';
import 'package:damaz/components/my_food_tile.dart';
import 'package:damaz/components/my_sliver_app_bar.dart';
import 'package:damaz/components/my_tab_bar.dart';
import 'package:damaz/models/food.dart';
import 'package:damaz/models/restaurant.dart';
import 'package:damaz/pages/food_page.dart';
import 'package:damaz/services/connectivity_service.dart';
import 'package:damaz/services/battery_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // tab controller
  late TabController _tabController;

  // Connectivity and Battery status
  bool _isConnected = true;
  int _batteryLevel = 100;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: FoodCategory.values.length, vsync: this);

    // Check initial connectivity and battery status
    _checkConnectivityAndBattery();
  }

  void _checkConnectivityAndBattery() {
    final connectivityService = Provider.of<ConnectivityService>(context, listen: false);
    final batteryService = Provider.of<BatteryService>(context, listen: false);

    // Subscribe to connectivity changes
    connectivityService.connectivityStream.listen((isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
    });

    // Check initial battery status
    batteryService.getBatteryLevel().then((batteryLevel) {
      setState(() {
        _batteryLevel = batteryLevel;
      });
    }).catchError((e) {
      print('Error getting battery level: $e');
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sort out and return a list of food items that belong to a specific category
  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  // return list of foods in given category
  List<Widget> getFoodInThisCategory(List<Food> fullMenu, BoxConstraints constraints) {
    return FoodCategory.values.map((category) {
      // get category menu
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);

      // Use GridView for wider screens, ListView for narrower ones
      if (constraints.maxWidth > 600) {
        // GridView for tablet/web
        return GridView.builder(
          itemCount: categoryMenu.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 1200 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final food = categoryMenu[index];
            return FoodTile(
                food: food,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodPage(food: food),
                  ),
                ));
          },
        );
      } else {
        // ListView for mobile
        return ListView.builder(
          itemCount: categoryMenu.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final food = categoryMenu[index];
            return FoodTile(
                food: food,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodPage(food: food),
                  ),
                ));
          },
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: screenWidth < 800 ? const MyDrawer() : null, // Drawer only for smaller screens
      body: LayoutBuilder(
        builder: (context, constraints) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            MySliverAppBar(
              title: MyTabBar(tabController: _tabController),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Connection and Battery Status Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isConnected ? Icons.wifi : Icons.wifi_off,
                        color: _isConnected ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Battery: $_batteryLevel%',
                        style: TextStyle(
                          fontSize: screenWidth < 400 ? 12 : 16, // Responsive font size
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    indent: 25,
                    endIndent: 25,
                    color: Theme.of(context).colorScheme.secondary,
                  ),

                  // My current location
                  const MyCurrentLocation(),

                  // Description box
                  const MyDescriptionBox(),
                ],
              ),
            ),
          ],
          body: Consumer<Restaurant>(
            builder: (context, restaurant, child) => TabBarView(
              controller: _tabController,
              children: getFoodInThisCategory(restaurant.menu, constraints),
            ),
          ),
        ),
      ),
    );
  }
}
