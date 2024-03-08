// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker_project_stage1/widgets/weekly_expenses/category_wise.dart';
import 'package:expenses_tracker_project_stage1/widgets/weekly_expenses/total_expenses.dart';
import 'package:flutter/material.dart';

class Weekly extends StatelessWidget {
  const Weekly({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
            length: 2,
            child: Column(children: [
              TabBar(tabs: [
                Tab(
                  text: "Total Expenses",
                ),
                Tab(
                  text: "Category Based",
                ),
              ]),
              Expanded(
                  child: TabBarView(
                children: [
                  TotalExpenses(),
                  CategoryWise()
                ],
              ))
            ]))
            )
            ;
  }
}