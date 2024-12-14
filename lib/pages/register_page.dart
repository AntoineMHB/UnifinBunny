import 'package:damaz/auth/onboarding_facebook.dart';
import 'package:damaz/auth/onboarding_github.dart';
import 'package:damaz/components/my_button.dart';
import 'package:damaz/components/my_textfield.dart';
import 'package:damaz/components/square_tile.dart';
import 'package:damaz/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // register method
  void register() async {
    // get auth service
    final _authService = AuthService();

    // check if passwords match -> create user
    if (passwordController.text == confirmPasswordController.text) {
      // try creating the user
      try {
        await _authService.signUpWithEmailPassword(emailController.text, passwordController.text);
      }

      // display any errors
      catch (e){
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(title: Text(e.toString()),
        ),
      );
      }
    }

    // if passowrds don't match -> show error
    else {
       showDialog(
          context: context, 
          builder: (context) => const AlertDialog(
            title: Text("Passwords don't match"),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      // here we access those different colors from the theme
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.lock_clock_rounded,
                size: 100,  
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
        
              const SizedBox(height: 25),
          
              // message, app slogan
              Text(
                "Let's create an account for you",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),),
        
                const SizedBox(height: 25),

              // Localized message
              Text(
                localizations.register_title,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 25),
          
              // email textfield
              MyTextField(
                controller: emailController, 
                hintText: "Email", 
                obscureText: false,
                ),
        
                const SizedBox(height: 10),
        
              // password textfield
              MyTextField(
                controller: passwordController, 
                hintText: "Password", 
                obscureText: true,
                ),
        
                           const SizedBox(height: 10),
        
              // confirm password textfield
              MyTextField(
                controller: confirmPasswordController, 
                hintText: "Confirm password", 
                obscureText: true,
                ),
        
                const SizedBox(height: 10),
        
              // sign up button
              MyButton(
                text: "Sign Up", 
                onTap: () {
                  register();
                },
              ), 
        
              const SizedBox(height: 25),
        
              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  // google button
                  SquareTile(
                    onTap: () => AuthService(),
                    imagePath: 'lib/images/google.png',
                  ),
        
                  SizedBox(width: 25),
        
                  // apple button
                  SquareTile(
                    onTap: () {},
                    imagePath: 'lib/images/apple.png',
                  )
                ],
              ),

              const GithubAuthentication(),
              const FacebookAuthentication(),


              SizedBox(width: 15),
          
              // already have an account? Login here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "already have an account?", 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(),
                          ),
                      );
                    },
                    child: Text(
                      "Login now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold),),
                  ),
            
                ],)
            ],
          ),
        ),
      ),
    );
}
}