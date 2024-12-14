import 'package:damaz/auth/onboarding_facebook.dart';
import 'package:damaz/auth/onboarding_github.dart';
import 'package:damaz/components/my_button.dart';
import 'package:damaz/components/my_textfield.dart';
import 'package:damaz/components/square_tile.dart';
import 'package:damaz/pages/register_page.dart';
import 'package:damaz/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Try sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Pop the loading circle
      Navigator.pop(context);
    } catch (e) {
      // Pop the loading circle
      Navigator.pop(context);

      // Handle sign-in errors
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          wrongEmailMessage();
        } else if (e.code == 'wrong-password') {
          wrongPasswordMessage();
        } else {
          showErrorMessage(e.message ?? 'Unknown error occurred');
        }
      } else {
        showErrorMessage('An unexpected error occurred. Please try again.');
      }
    }
  }

  // Error message dialogs
  void wrongEmailMessage() {
    showErrorDialog('Incorrect Email', 'The email address you entered does not exist.');
  }

  void wrongPasswordMessage() {
    showErrorDialog('Incorrect Password', 'The password you entered is incorrect.');
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void showErrorMessage(String message) {
    showErrorDialog('Sign In Error', message);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? screenWidth * 0.1 : 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),

                // Logo
                Icon(
                  Icons.lock,
                  size: isLargeScreen ? 150 : 100,
                ),
                SizedBox(height: screenHeight * 0.05),

                // Welcome back text
                Text(
                  'Welcome back, you\'ve been missed',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isLargeScreen ? 20 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.03),

                // Email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: screenHeight * 0.02),

                // Password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: screenHeight * 0.03),

                // Sign 'lib/images/google_logo.png'In button
                MyButton(
                  text: "Sign In",
                  onTap: signUserIn,
                ),
                SizedBox(height: screenHeight * 0.05),

                // Or continue with
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: isLargeScreen ? 18 : 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Google and Apple buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'https://www.googleusercontent.com/google-logo.png',
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    SquareTile(imagePath: 'lib/images/apple_logo.png'),
                  ],
                ),
                //SizedBox(height: screenHeight * 0.05),

                const FacebookAuthentication(),
                const GithubAuthentication(),

                SizedBox(height: screenHeight * 0.03),

                // Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: isLargeScreen ? 18 : 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  RegisterPage(
                              onTap: () => Navigator.pop(context),
                            )),
                        );
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: isLargeScreen ? 18 : 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
