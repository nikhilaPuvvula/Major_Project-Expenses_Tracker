// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Db {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(data, context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await users
        .doc(userId)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Sign up failed"),
              content: Text(error.toString()),
            );
          });
    });
  }
}
