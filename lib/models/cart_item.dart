import 'package:damaz/models/food.dart';

class CartItem {
  Food food;
  List<Addon> selectedAddons;
  int quantity;

  CartItem({
    required this.food, 
    required this.selectedAddons, 
    this.quantity = 1,
  });

  // this variable holds the total price. It means the price of the food and the selected addons
  double get totalPrice {
    double addonsPrice = 
         selectedAddons.fold(0, (sum, addon) => sum + addon.price);
    return (food.price + addonsPrice) * quantity;
  }
}