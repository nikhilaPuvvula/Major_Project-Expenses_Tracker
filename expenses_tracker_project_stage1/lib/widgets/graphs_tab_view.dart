// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:expenses_tracker_project_stage1/widgets/monthly.dart';
import 'package:expenses_tracker_project_stage1/widgets/weekly.dart';
import 'package:expenses_tracker_project_stage1/widgets/yearly.dart';
import 'package:flutter/material.dart';

class GraphTabView extends StatelessWidget {
  const GraphTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  text: "Weekly",
                ),
                Tab(
                  text: "Monthly",
                ),
                Tab(
                  text: "Yearly",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Weekly(),
                  Monthly(),
                  Yearly(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
