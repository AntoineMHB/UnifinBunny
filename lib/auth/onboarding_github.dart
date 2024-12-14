import 'package:damaz/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:status_alert/status_alert.dart';

class GithubAuthentication extends StatefulWidget {
  const GithubAuthentication({super.key});

  @override
  State<GithubAuthentication> createState() => _GithubAuthenticationState();
}

class _GithubAuthenticationState extends State<GithubAuthentication> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: 60,
      child: SignInButton(
        buttonType: ButtonType.github,
        width: MediaQuery.of(context).size.width,
        onPressed: () async {
          try {
            UserCredential userCredential = await signInwithGithub();
            if(context.mounted) {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage())
              );
            }

          } catch (e) {
            StatusAlert.show(context,
                duration: const Duration(seconds: 2),
                title: "User Authentication",
                subtitle: e.toString(),
                configuration: const IconConfiguration(
                    icon: Icons.close, color: Colors.red),
                maxWidth: 360);

          }
        },
      ),
    );
  }

  Future<UserCredential> signInwithGithub() async {
    GithubAuthProvider githubAuthProvider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);
  }
}
