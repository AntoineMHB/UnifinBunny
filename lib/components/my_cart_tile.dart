import 'package:damaz/components/my_quantity_selector.dart';
import 'package:damaz/models/cart_item.dart';
import 'package:damaz/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 15 : 25, // Adjust margin
          vertical: 10,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 6 : 8), // Adjust padding
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // food image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      cartItem.food.imagePath,
                      height: isSmallScreen ? 80 : 100, // Adjust size
                      width: isSmallScreen ? 80 : 100, // Adjust size
                    ),
                  ),

                  SizedBox(width: isSmallScreen ? 8 : 10), // Adjust spacing

                  // name and price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // food name
                      Text(
                        cartItem.food.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16, // Adjust font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // food price
                      Text(
                        '\$${cartItem.food.price}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: isSmallScreen ? 12 : 14, // Adjust font size
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // increment and decrement the quantity
                  QuantitySelector(
                    quantity: cartItem.quantity,
                    food: cartItem.food,
                    onDecrement: () {
                      restaurant.removeFromCart(cartItem);
                    },
                    onIncrement: () {
                      restaurant.addToCart(
                        cartItem.food,
                        cartItem.selectedAddons,
                      );
                    },
                  ),
                ],
              ),
            ),

            // addons
            SizedBox(
              height: cartItem.selectedAddons.isEmpty
                  ? 0
                  : (isSmallScreen ? 50 : 60), // Adjust height
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                children: cartItem.selectedAddons
                    .map(
                      (addon) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Row(
                        children: [
                          // addon name
                          Text(
                            addon.name,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12, // Adjust font size
                            ),
                          ),

                          // addon price
                          Text(
                            ' (\$${addon.price})',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12, // Adjust font size
                            ),
                          ),
                        ],
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onSelected: (value) {},
                      backgroundColor:
                      Theme.of(context).colorScheme.secondary,
                      labelStyle: TextStyle(
                        color:
                        Theme.of(context).colorScheme.inversePrimary,
                        fontSize: isSmallScreen ? 10 : 12, // Adjust font size
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
