// ignore_for_file: prefer_const_constructors, duplicate_import, unused_import

import 'package:expenses_tracker_project_stage1/firebase_options.dart';
import 'package:expenses_tracker_project_stage1/screens/sign_up.dart';
import 'package:expenses_tracker_project_stage1/screens/sign_up.dart';
import 'package:expenses_tracker_project_stage1/widgets/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!);
      },
      /* theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),*/
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
