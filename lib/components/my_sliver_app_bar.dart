import 'package:damaz/pages/cart_page.dart';
import 'package:flutter/material.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;

  const MySliverAppBar({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SliverAppBar(
      expandedHeight: isSmallScreen ? 220 : 340, // Reduced height for small screens
      collapsedHeight: isSmallScreen ? 80 : 120, // Smaller collapsed height for small screens
      floating: false,
      pinned: true,
      actions: [
        // Cart button
        IconButton(
          onPressed: () {
            // Go to the cart page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartPage(),
              ),
            );
          },
          icon: Icon(
            Icons.shopping_cart,
            size: isSmallScreen ? 20 : 24, // Adjust icon size for smaller screens
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(
        "SAPATO_fresh",
        style: TextStyle(
          fontSize: isSmallScreen ? 18 : 22, // Adjust title size for smaller screens
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 30.0 : 50.0), // Adjust padding for smaller screens
          child: child,
        ),
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 0, right: 0),
        expandedTitleScale: 1,
      ),
    );
  }
}
