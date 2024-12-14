import 'package:collection/collection.dart';
import 'package:damaz/models/cart_item.dart';
import 'package:damaz/models/food.dart';
import 'package:flutter/material.dart';

class Restaurant extends ChangeNotifier{
  // list of food menu
  final List<Food> _menu = [
    // burgers / adventure
    Food(
      name: "Adidias Hyperturf",
      description: "A sneaker with endurance, perfect for your adventures.",
      imagePath: "lib/images/adventure/adidas_hyperturf.jpeg",
      price: 0.99, 
      category: FoodCategory.adventure,
      availableAddons: [
        Addon(name: "Extra cheese", price: 0.99),
        Addon(name: "Bacon", price: 1.99),
        Addon(name: "Avocado", price: 2.99),
      ],
    ),

      Food(
      name: "Camel Adventure",
      description: 
          "Strong, stylish and ready for great adventures.",
      imagePath: "lib/images/adventure/camel.jpeg",
      price: 10.99, 
      category: FoodCategory.adventure,
      availableAddons: [
        Addon(name: "Grilled Onions", price: 0.99),
        Addon(name: "Jalapenos", price: 1.49),
        Addon(name: "Extra BBQ Sauce", price: 1.99),
      ],
    ),

      Food(
      name: "Merrel Adventure",
      description: 
         "A tout-terrain sneaker.",
      imagePath: "lib/images/adventure/merrel.jpeg",
      price: 9.99, 
      category: FoodCategory.adventure,
      availableAddons: [
        Addon(name: "Vegan Cheese", price: 0.99),
        Addon(name: "Grilled Mushrooms", price: 1.49),
        Addon(name: "Hummus Spread", price: 1.99),
      ],
    ),

      Food(
      name: "Polo Adventure",
      description: 
         "Design by Polo just for you and your future adventure.",
      imagePath: "lib/images/adventure/polo.jpeg",
      price: 9.49, 
      category: FoodCategory.adventure,
      availableAddons: [
        Addon(name: "Sauteed Mushrooms", price: 0.99),
        Addon(name: "Fried Egg", price: 1.49),
        Addon(name: "Spicy Mayo", price: 0.99),
      ],
    ),

    // salads / athletic
      Food(
      name: "Athletic Adidas",
      description: 
        "A nice Adidas sneaker to make you run after your dreams.",
      imagePath: "lib/images/athletic/adidas_athletic.jpeg",
      price: 7.99, 
      category: FoodCategory.athletic,
      availableAddons: [
        Addon(name: "Grilled Chicken", price: 0.99),
        Addon(name: "Anchovies", price: 1.99),
        Addon(name: "Extra Parmesan", price: 1.99),
      ],
    ),

    Food(
      name: "Airmax Athletic",
      description: 
        "Feel the magic in the air with this Airmax.",
      imagePath: "lib/images/athletic/airmax_athletic.jpeg",
      price: 8.49, 
      category: FoodCategory.athletic,
      availableAddons: [
        Addon(name: "Feta Cheese", price: 0.99),
        Addon(name: "Kalamata Olives", price: 1.49),
        Addon(name: "Grilled Shrimp", price: 1.99),
      ],
    ),

    Food(
      name: "Hotsale Athletic",
      description: 
        "Stylish and accurate. Run in style.",
      imagePath: "lib/images/athletic/hotsale_athletic.jpeg",
      price: 9.99, 
      category: FoodCategory.athletic,
      availableAddons: [
        Addon(name: "Avocado", price: 0.99),
        Addon(name: "Feta Cheese", price: 1.49),
        Addon(name: "Grilled Chicken", price: 1.99),
      ],
    ),

    Food(
      name: "Newbalance Athletic",
      description: 
        "Simple but strong. Run with an new balance",
      imagePath: "lib/images/athletic/newbalance_athletic.jpeg",
      price: 7.99, 
      category: FoodCategory.athletic,
      availableAddons: [
        Addon(name: "Mandarin Oranges", price: 0.99),
        Addon(name: "Almond Slivers", price: 1.49),
        Addon(name: "Extra Teriyaka", price: 1.99),
      ],
    ),

    Food(
      name: "Nike Athletic",
      description: 
        "Run with the new trend. Run with a Nike",
      imagePath: "lib/images/athletic/nike_athletic.jpeg",
      price: 7.99, 
      category: FoodCategory.athletic,
      availableAddons: [
        Addon(name: "Grilled Chicken", price: 0.99),
        Addon(name: "Anchovies", price: 1.99),
        Addon(name: "Extra Parmesan", price: 1.99),
      ],
    ),

    // sides / casual
    Food(
      name: "Business Casual",
      description: 
        "Look casual even doing business.",
      imagePath: "lib/images/casual/business_casual.jpeg",
      price: 4.99, 
      category: FoodCategory.casual,
      availableAddons: [
        Addon(name: "Cheese Sauce", price: 0.99),
        Addon(name: "Truffle Oil", price: 1.49),
        Addon(name: "Cajun Spice", price: 1.99),
      ],
    ),

     Food(
      name: "Puma Casual",
      description: 
        "A fresh and white Puma for casual occasions.",
      imagePath: "lib/images/casual/puma_casual.jpeg",
      price: 3.99, 
      category: FoodCategory.casual,
      availableAddons: [
        Addon(name: "Ranch Dip", price: 0.99),
        Addon(name: "Spicy Mayo", price: 1.49),
        Addon(name: "Parmesan Dust", price: 1.99),
      ],
    ),

    Food(
      name: "Samba Casual",
      description: 
        "Trending, casual and beautiful.",
      imagePath: "lib/images/casual/samba_casual.jpeg",
      price: 3.99, 
      category: FoodCategory.casual,
      availableAddons: [
        Addon(name: "Extra Garlic", price: 0.99),
        Addon(name: "Mozzarella Cheese", price: 1.49),
        Addon(name: "Marinara Dip", price: 1.99),
      ],
    ),

    Food(
      name: "Shorts Casual",
      description: 
        "Stylish and simple.",
      imagePath: "lib/images/casual/short_casual.jpeg",
      price: 4.49, 
      category: FoodCategory.casual,
      availableAddons: [
        Addon(name: "Sour Cream", price: 0.99),
        Addon(name: "Bacon Bits", price: 1.49),
        Addon(name: "Green Onions", price: 0.99),
      ],
    ),

     Food(
      name: "Vans Casual",
      description: 
        "Vans, you know...",
      imagePath: "lib/images/casual/vans_casual.jpeg",
      price: 4.49, 
      category: FoodCategory.casual,
      availableAddons: [
        Addon(name: "Bacon Bits", price: 0.99),
        Addon(name: "Jalapeno Slices", price: 1.49),
        Addon(name: "Sriracha", price: 0.99),
      ],
    ),



    // desserts / highTop
     Food(
      name: "AllBlack HighTop",
      description: 
        "Look mysterious in the AllBlack.",
      imagePath: "lib/images/highTop/allblack_hightop.jpeg",
      price: 3.99, 
      category: FoodCategory.highTop,
      availableAddons: [
        Addon(name: "Strawberry Topping", price: 0.99),
        Addon(name: "Blueberry Compote", price: 1.49),
        Addon(name: "Chocolate Chips", price: 1.99),
      ],
    ),

       Food(
      name: "AllRed HighTop",
      description: 
        "What a color? It appeals to freshness.",
      imagePath: "lib/images/highTop/allred_hightop.jpeg",
      price: 3.99, 
      category: FoodCategory.highTop,
      availableAddons: [
        Addon(name: "Strawberry Topping", price: 0.99),
        Addon(name: "Blueberry Compote", price: 1.49),
        Addon(name: "Chocolate Chips", price: 1.99),
      ],
    ),

    Food(
      name: "AllWhite HighTop",
      description: 
        "Full in white and stylish.",
      imagePath: "lib/images/highTop/allwhite_hightop.jpeg",
      price: 3.99, 
      category: FoodCategory.highTop,
      availableAddons: [
        Addon(name: "Caramel Sauce", price: 0.99),
        Addon(name: "Vanilla Ice Cream", price: 1.49),
        Addon(name: "Cinnamon Spice", price: 1.99),
      ],
    ),

    Food(
      name: "Jordan 1 HighTop",
      description: 
        "Follow the fashion of the era.",
      imagePath: "lib/images/highTop/jordan1_hightop.jpeg",
      price: 5.49, 
      category: FoodCategory.highTop,
      availableAddons: [
        Addon(name: "Caramel Sauce", price: 0.99),
        Addon(name: "Vanilla Ice Cream", price: 1.49),
        Addon(name: "Cinnamon Spice", price: 1.99),
      ],
    ),

    Food(
      name: "Stylish HighTop",
      description: 
        "Do you care about style? Then you should get these ones.",
      imagePath: "lib/images/highTop/stylish_hightop.jpeg",
      price: 2.99, 
      category: FoodCategory.highTop,
      availableAddons: [
        Addon(name: "Strawberry Topping", price: 0.99),
        Addon(name: "Blueberry Compote", price: 4.49),
        Addon(name: "Chocolate Chips", price: 1.99),
      ],
    ),


    // drinks / luxury
    Food(
      name: "Brown Luxury",
      description: 
        "Where luxury is classic.",
      imagePath: "lib/images/luxury/brown_luxury.jpeg",
      price: 3.99, 
      category: FoodCategory.luxury,
      availableAddons: [
        Addon(name: "Strawberry Flavor", price: 0.99),
        Addon(name: "Mint Leaves", price: 1.49),
        Addon(name: "Ginger Zest", price: 1.99),
      ],
    ),

    Food(
      name: "Business Luxury",
      description: 
        "Do business and look luxious.",
      imagePath: "lib/images/luxury/business_luxury.jpeg",
      price: 3.99, 
      category: FoodCategory.luxury,
      availableAddons: [
        Addon(name: "Peach Flavor", price: 0.99),
        Addon(name: "Lemon Slices", price: 1.49),
        Addon(name: "Honey", price: 1.99),
      ],
    ),

    Food(
      name: "Croco Luxury",
      description: 
        "Put on a croco skin and record compliments.",
      imagePath: "lib/images/luxury/croco_luxury.jpeg",
      price: 3.99, 
      category: FoodCategory.luxury,
      availableAddons: [
        Addon(name: "Protein Powder", price: 0.99),
        Addon(name: "Almond Milk", price: 1.49),
        Addon(name: "Chia Seeds", price: 1.99),
      ],
    ),

    Food(
      name: "Leather Luxury",
      description: 
        "A beautiful white leather. Yeah it's luxury.",
      imagePath: "lib/images/luxury/leather_luxury.jpeg",
      price: 3.99, 
      category: FoodCategory.luxury,
      availableAddons: [
        Addon(name: "Extra Mint", price: 0.99),
        Addon(name: "Raspberry Puree", price: 1.49),
        Addon(name: "Splash of Coconut Rum", price: 1.99),
      ],
    ),

  ];

  /*

  G E T T E R S

  */

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;

   /*

  O P E R A T I O N S
  */

  // user cart
  final List<CartItem> _cart = [];

  // add to cart
  void addToCart(Food food, List<Addon> selectedAddons) {
    // see if there is a cart item already with the same food and selected addons
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      // check if the food items are the same
      bool isSameFood  = item.food == food;

      // check if the list of selected addons are the same
      bool isSameAddons = 
          ListEquality().equals(item.selectedAddons, selectedAddons);
      return isSameFood && isSameAddons;
    });

    // if item already exists, increase it's quantity
    if (cartItem != null) {
      cartItem.quantity++;
    }

    // otherwise, add a new cart item to the cart
    else {
      _cart.add(CartItem(
        food: food, 
        selectedAddons: selectedAddons,
      ),
    );
    }
    notifyListeners();
  }
  

  // remove from cart 
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }

    }

    notifyListeners();

  }

  // get total price of cart
  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart){
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity; 
    }
    return total;
  }

  // get total number of items in cart
  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }

  // clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

   /*

  H E L P E R S
  */

  // generate a receipt


}