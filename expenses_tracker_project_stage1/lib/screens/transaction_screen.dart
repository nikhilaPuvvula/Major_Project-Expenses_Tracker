// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors, curly_braces_in_flow_control_structures

import 'package:expenses_tracker_project_stage1/widgets/category_list.dart';
import 'package:expenses_tracker_project_stage1/widgets/tab_bar_view.dart';
import 'package:expenses_tracker_project_stage1/widgets/time_line_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var category = "All";
  var monthyear = "";

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      monthyear = DateFormat('MMM y').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detailed Transactions ",style:TextStyle(color: Colors.white)),
         backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          TimeLineMonth(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  monthyear = value;
                });
              }
            },
          ),
          CategoryList(
            onChanged: (String? value) {
              if (value != null)
                setState(() {
                  category = value;
                });
            },
          ),
          TypeTabBar(
            category: category,
            monthyear: monthyear,
          ),
        ],
      ),
    );
  }
}
