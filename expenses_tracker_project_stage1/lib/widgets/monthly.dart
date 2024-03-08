// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member, annotate_overrides

import 'package:expenses_tracker_project_stage1/widgets/monthy_expenses/monthly_graph.dart';
import 'package:expenses_tracker_project_stage1/widgets/time_line_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Monthly extends StatefulWidget {
  const Monthly({super.key});

  @override
  State<Monthly> createState() => _MonthlyState();
}

class _MonthlyState extends State<Monthly> {
  @override
   var monthyear = "";
   void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      monthyear = DateFormat('MMM y').format(now);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
          MonthlyGraph(monthyear: monthyear,),
        ],
      ),
    );
  }
}