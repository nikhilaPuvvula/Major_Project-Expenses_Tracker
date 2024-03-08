// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'package:expenses_tracker_project_stage1/screens/login_screen.dart';
import 'package:expenses_tracker_project_stage1/services/auth_service.dart';
import 'package:expenses_tracker_project_stage1/utils/appvalidator.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        "username": _userNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "phone": _phoneController.text,
        'remainingAmount':0,
        'totalCredit':0,
        'totalDebit':0,
      };
      await authService.createUser(data, context);
      setState(() {
        isLoader = false;
      });
      //ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
      //    const SnackBar(content: Text('Form Submitted Succesfully')));
    }
  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Expenses Tracker'),
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFCCBC), Color(0xFFAB47BC)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          "Create new Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                          controller: _userNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              _buildInputDecoration("Username", Icons.person),
                          validator: appValidator.validateUsername),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              _buildInputDecoration("Email", Icons.email),
                          validator: appValidator.validateEmail),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _phoneController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              _buildInputDecoration("Phone Number", Icons.call),
                          validator: appValidator.validatePhoneNumber),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              _buildInputDecoration("Password", Icons.lock),
                          validator: appValidator.validatePassword),
                      SizedBox(
                        height: 16.0,
                      ),
                      SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple),
                              onPressed: () {
                                isLoader ? print("Loading") : _submitForm();
                              },
                              child: isLoader
                                  ? Center(child: CircularProgressIndicator())
                                  : Text("Create",
                                      style: TextStyle(color: Colors.white)))),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginView()),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
            )));
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFAB47BC)),
          borderRadius: BorderRadius.circular(10.0)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelStyle: TextStyle(color: Colors.black),
      labelText: label,
      suffixIcon: Icon(suffixIcon),
    );
  }
}
