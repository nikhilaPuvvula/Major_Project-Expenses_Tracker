// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors, unused_import, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker_project_stage1/widgets/graphs_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('Expenses Reports',style:TextStyle(color: Colors.white)),
      backgroundColor: Colors.purple,
    ),
    body:Column(
      children: [
        GraphTabView()],
    )
    );
  }
}
