import 'package:damaz/components/my_button.dart';
import 'package:damaz/components/my_cart_tile.dart';
import 'package:damaz/models/restaurant.dart';
import 'package:damaz/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        // cart
        final userCart = restaurant.cart;

        // scaffold UI
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Cart",
              style: TextStyle(
                fontSize: isLargeScreen ? 24 : 18,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // clear cart button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        "Are you sure you want to clear the cart?",
                      ),
                      actions: [
                        // cancel button
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),

                        // yes button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            restaurant.clearCart();
                          },
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              )
            ],
          ),
          body: Column(
            children: [
              // list of cart
              Expanded(
                child: userCart.isEmpty
                    ? Center(
                  child: Text(
                    "Cart is empty..",
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 40 : 16,
                    vertical: isLargeScreen ? 20 : 10,
                  ),
                  itemCount: userCart.length,
                  itemBuilder: (context, index) {
                    // get individual cart item
                    final cartItem = userCart[index];

                    // return cart tile UI
                    return MyCartTile(cartItem: cartItem);
                  },
                ),
              ),

              // button to pay
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 40.0 : 20.0,
                  vertical: isLargeScreen ? 20.0 : 10.0,
                ),
                child: MyButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentPage(),
                    ),
                  ),
                  text: "Go to checkout",
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }
}
