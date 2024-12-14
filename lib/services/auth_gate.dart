import 'package:damaz/auth/login_or_register.dart';
import 'package:damaz/pages/home_page.dart';
import 'package:damaz/pages/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          // user is logged in
          if(snapshot.hasData) {
            return  MainScreen();
          }

          // user is NOT logged in
          else {
            return const LoginOrRegister();
          }
        }),
    );
  }
}