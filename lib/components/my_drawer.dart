import 'package:damaz/components/my_drawer_tile.dart';
import 'package:damaz/pages/login_page.dart';
import 'package:damaz/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    final localizations = AppLocalizations.of(context);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Profile Avatar
          Padding(
            padding: EdgeInsets.only(top: isSmallScreen ? 50.0 : 100.0), // Adjust padding
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: isSmallScreen ? 30 : 40, // Adjust avatar size
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                child: _imageFile == null
                    ? Icon(
                  Icons.person_add_alt_1,
                  size: isSmallScreen ? 40 : 50, // Adjust icon size
                  color: Theme.of(context).colorScheme.primary,
                )
                    : ClipOval(
                  child: Image.file(
                    File(_imageFile!.path),
                    width: isSmallScreen ? 60 : 80, // Adjust image size
                    height: isSmallScreen ? 60 : 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 15.0 : 25.0), // Adjust padding
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // Home list tile
          MyDrawerTile(
            text: localizations!.homes,
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          // Settings list title
          MyDrawerTile(
            text: localizations.settings,
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),

          const Spacer(),

          // Logout list title
          MyDrawerTile(
            text: localizations.logout,
            icon: Icons.logout,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
            },
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
