import 'package:damaz/components/my_button.dart';
import 'package:damaz/models/food.dart';
import 'package:damaz/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:damaz/services/languageProvider.dart';

class FoodPage extends StatefulWidget {
  final Food food;
  final Map<Addon, bool> selectedAddons = {};

  FoodPage({
    super.key,
    required this.food,
  }) {
    for (Addon addon in food.availableAddons) {
      selectedAddons[addon] = false;
    }
  }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  void addToCart(Food food, Map<Addon, bool> selectedAddons) {
    Navigator.pop(context);

    List<Addon> currentlySelectedAddons = [];
    for (Addon addon in widget.food.availableAddons) {
      if (widget.selectedAddons[addon] == true) {
        currentlySelectedAddons.add(addon);
      }
    }

    context.read<Restaurant>().addToCart(food, currentlySelectedAddons);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Image
                AspectRatio(
                  aspectRatio: isLargeScreen ? 16 / 9 : 4 / 3,
                  child: Image.asset(
                    widget.food.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 40.0 : 25.0,
                    vertical: isLargeScreen ? 20.0 : 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food Name
                      Text(
                        widget.food.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isLargeScreen ? 24 : 20,
                        ),
                      ),

                      // Food Price
                      Text(
                        '\$${widget.food.price}',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 20 : 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      SizedBox(height: isLargeScreen ? 20 : 10),

                      // Food Description
                      Text(
                        widget.food.description,
                        style: TextStyle(
                          fontSize: isLargeScreen ? 18 : 14,
                        ),
                      ),

                      SizedBox(height: isLargeScreen ? 20 : 10),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: isLargeScreen ? 2 : 1,
                      ),

                      SizedBox(height: isLargeScreen ? 20 : 10),

                      // Add-ons Header
                      Text(
                        AppLocalizations.of(context)!.addonHeader,
                        style: TextStyle(
                          fontSize: isLargeScreen ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),

                      SizedBox(height: 10),

                      // Add-ons List
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: widget.food.availableAddons.length,
                          itemBuilder: (context, index) {
                            Addon addon = widget.food.availableAddons[index];
                            return CheckboxListTile(
                              title: Text(addon.name),
                              subtitle: Text(
                                '\$${addon.price}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              value: widget.selectedAddons[addon],
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.selectedAddons[addon] = value!;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Add to Cart Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 40.0 : 25.0,
                  ),
                  child: MyButton(
                    text: AppLocalizations.of(context)!.addToCart,
                    onTap: () => addToCart(widget.food, widget.selectedAddons),
                  ),
                ),

                SizedBox(height: isLargeScreen ? 40 : 25),
              ],
            ),
          ),
        ),

        // Back Button
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
