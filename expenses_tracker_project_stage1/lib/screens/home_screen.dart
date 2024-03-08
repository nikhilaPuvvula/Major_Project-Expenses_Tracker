// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, unused_element

import 'package:expenses_tracker_project_stage1/screens/login_screen.dart';
import 'package:expenses_tracker_project_stage1/widgets/add_transaction.dart';
import 'package:expenses_tracker_project_stage1/widgets/hero_card.dart';
import 'package:expenses_tracker_project_stage1/widgets/transaction_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoading = false;

  logOut() async {
    setState(() {
      isLogoutLoading = false;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: ((context) => LoginView()),
    ));
    setState(() {
      isLogoutLoading = false;
    });
  }
  final userId = FirebaseAuth.instance.currentUser!.uid;
  _dialoBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AddTransactionForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 147, 54, 163),
        onPressed: (() {
          _dialoBuilder(context);
        }),
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Hello,",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                logOut();
              },
              icon: isLogoutLoading
                  ? CircularProgressIndicator()
                  : Icon(Icons.exit_to_app, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              HeroCard(userId: userId,),
              transactionsCard(),
            ],
          )),
    );
  }
}
