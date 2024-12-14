import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Padding(
      padding: EdgeInsets.only(left: isSmallScreen ? 15.0 : 25.0), // Adjust left padding based on screen size
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 5.0 : 15.0, // Adjust vertical padding based on screen size
          horizontal: isSmallScreen ? 10.0 : 20.0, // Adjust horizontal padding for smaller screens
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: isSmallScreen ? 14.0 : 16.0, // Adjust font size for smaller screens
          ),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
          size: isSmallScreen ? 20.0 : 24.0, // Adjust icon size for smaller screens
        ),
        onTap: onTap,
      ),
    );
  }
}
