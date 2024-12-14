class Food {
  final String name;               // cheese burger 
  final String description;       // a burger full of cheese
  final String imagePath;        // lib/images/cheese_burger.png
  final double price;           // 4.99
  final FoodCategory category; // [ extra cheese, sauce, extra patty ]
  List<Addon> availableAddons;

  Food({
    required this.name, 
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons
    });
}

// food categories
enum FoodCategory{
  adventure,//burgers,
  athletic,//salads,
  casual,//sides,
  highTop,//desserts,
  luxury,//drinks
}

// food addons
class Addon {
  String name;
  double price;

  Addon({
    required this.name,
    required this.price,
  });
}