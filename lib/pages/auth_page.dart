import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieapp/pages/main_navigation.dart';
import 'package:movieapp/pages/signin_page.dart';
import 'package:movieapp/widgets/app_loader.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child:AppLoader()),
          );
        } else if (snapshot.hasData) {
          return const MainNavigation();
        } else {
          return const SigninPage();
        }
      },
    );
  }
}
