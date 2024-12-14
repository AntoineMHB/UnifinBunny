import 'package:damaz/models/food.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Food food;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.food,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(isSmallScreen ? 25 : 50), // Adjust border radius for smaller screens
      ),
      padding: EdgeInsets.all(isSmallScreen ? 6 : 8), // Adjust padding for smaller screens
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          GestureDetector(
            onTap: onDecrement,
            child: Icon(
              Icons.remove,
              size: isSmallScreen ? 18 : 20, // Adjust icon size for smaller screens
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // Quantity count
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6 : 8), // Adjust padding for quantity text
            child: SizedBox(
              width: isSmallScreen ? 18 : 20, // Adjust width for smaller screens
              child: Center(
                child: Text(
                  quantity.toString(),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16, // Adjust text size for smaller screens
                  ),
                ),
              ),
            ),
          ),

          // Increase button
          GestureDetector(
            onTap: onIncrement,
            child: Icon(
              Icons.add,
              size: isSmallScreen ? 18 : 20, // Adjust icon size for smaller screens
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
