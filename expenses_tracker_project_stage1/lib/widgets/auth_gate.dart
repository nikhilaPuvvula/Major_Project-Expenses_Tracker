// ignore_for_file: prefer_const_constructors

import 'package:expenses_tracker_project_stage1/screens/login_screen.dart';
import 'package:expenses_tracker_project_stage1/services/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoginView();
          }
          return Dashboard();
        });
  }
}
