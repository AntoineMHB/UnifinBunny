import 'package:flutter/material.dart';

class MyDescriptionBox extends StatelessWidget {
  const MyDescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    // TextStyle
    var myPrimaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
    );
    var mySecondaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(isSmallScreen ? 15 : 25), // Adjust padding
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 15 : 25, vertical: 15), // Adjust margin
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Delivery fee
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$0.99",
                style: myPrimaryTextStyle.copyWith(
                  fontSize: isSmallScreen ? 14 : 16, // Adjust font size
                ),
              ),
              Text(
                "Delivery fee",
                style: mySecondaryTextStyle.copyWith(
                  fontSize: isSmallScreen ? 12 : 14, // Adjust font size
                ),
              ),
            ],
          ),

          // Delivery time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "15-30 min",
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16, // Adjust font size
                ),
              ),
              Text(
                "Delivery time",
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14, // Adjust font size
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
