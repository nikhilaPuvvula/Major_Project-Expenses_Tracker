// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:expenses_tracker_project_stage1/services/dashboard.dart';
import 'package:expenses_tracker_project_stage1/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final Db db = Db();

  Future<void> createUser(Map<String, dynamic> data, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      await db.addUser(data, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: ((context) => Dashboard()),
      ));
    } catch (e) {
      _showErrorDialog(context, "Sign up failed", e.toString());
    }
  }

  Future<void> login(Map<String, dynamic> data, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: ((context) => Dashboard()),
      ));
    } catch (e) {
      _showErrorDialog(context, "Login Error", e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    final currentContext = Navigator.of(context).context;
    if (Navigator.of(context).canPop()) {
      showDialog(
        context: currentContext,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
          );
        },
      );
    }
  }
}

