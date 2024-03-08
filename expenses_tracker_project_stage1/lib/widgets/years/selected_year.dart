// ignore_for_file: prefer_const_constructors, annotate_overrides

//import 'package:expenses_tracker_project_stage1/widgets/years/selected_graph.dart';
import 'package:expenses_tracker_project_stage1/widgets/years/selected_graph.dart';
import 'package:expenses_tracker_project_stage1/widgets/years/time_line_years.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedYear extends StatefulWidget {
  const SelectedYear({super.key});

  @override
  State<SelectedYear> createState() => _SelectedYearState();
}

class _SelectedYearState extends State<SelectedYear> {
   var year = "";
   void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      year = DateFormat('y').format(now);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Column(
        children: [
          TimeLineYear(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  year = value;
                });
              }
            },
          ),
          SelectedGraph(year: year)
        ],
      ),
    );
  }
}