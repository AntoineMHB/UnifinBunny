import 'package:damaz/pages/login_page.dart';
import 'package:damaz/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;

    // Common container style for login and register pages
    final containerStyle = BoxDecoration(
      borderRadius: BorderRadius.circular(isLargeScreen ? 20 : 10),
      color: Theme.of(context).colorScheme.background,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: isLargeScreen ? 15 : 5,
          offset: const Offset(0, 5),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Container(
          width: isLargeScreen ? screenWidth * 0.5 : screenWidth * 0.9,
          height: isLargeScreen ? screenHeight * 0.7 : screenHeight * 0.9,
          decoration: containerStyle,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: showLoginPage
                ? LoginPage(
              key: const ValueKey("LoginPage"),
              onTap: togglePages,
            )
                : RegisterPage(
              key: const ValueKey("RegisterPage"),
              onTap: togglePages,
            ),
          ),
        ),
      ),
    );
  }
}
