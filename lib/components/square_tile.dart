import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap; // Using VoidCallback for better readability

  const SquareTile({
    super.key,
    required this.imagePath,
    this.onTap, // Make onTap optional
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // You can adjust this threshold as needed

    return GestureDetector(
      onTap: onTap, // Ensure the onTap callback is used
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 20), // Smaller padding on small screens
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.network(
          imagePath,
          height: isSmallScreen ? 30 : 40, // Adjust image height for small screens
        ),
      ),
    );
  }
}
