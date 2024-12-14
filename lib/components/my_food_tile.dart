import 'package:damaz/models/food.dart';
import 'package:flutter/material.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  const FoodTile({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 10.0 : 15.0), // Adjust padding for smaller screens
            child: Row(
              children: [
                // Text food details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16.0 : 18.0, // Adjust text size for smaller screens
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$' + food.price.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: isSmallScreen ? 14.0 : 16.0, // Adjust text size for smaller screens
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        food.description,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: isSmallScreen ? 12.0 : 14.0, // Adjust text size for smaller screens
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacer between text and image
                const SizedBox(width: 15),

                // Food image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    food.imagePath,
                    height: isSmallScreen ? 100 : 120, // Adjust image size for smaller screens
                    width: isSmallScreen ? 100 : 120, // Adjust image size for smaller screens
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Divider line
        Divider(
          color: Theme.of(context).colorScheme.tertiary,
          endIndent: 25,
          indent: 25,
        ),
      ],
    );
  }
}
