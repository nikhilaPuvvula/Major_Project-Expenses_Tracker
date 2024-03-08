// ignore_for_file: unused_import, prefer_const_declarations, curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Yearly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final String type = "debit";
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('type', isEqualTo: type)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<DocumentSnapshot> docs = snapshot.data!.docs;
        Map<int, double> yearlyExpenses = {};

        for (var doc in docs) {
          dynamic timestampData = doc['timestamp'];
          Timestamp timestamp;

          if (timestampData is Timestamp) {
            timestamp = timestampData;
          } else if (timestampData is int) {
            timestamp = Timestamp.fromMillisecondsSinceEpoch(timestampData);
          } else {
            // Handle other cases if necessary
            continue;
          }

          DateTime date = timestamp.toDate();
          int year = date.year;
          double amount = doc['amount'].toDouble();

          if (year >= DateTime.now().year - 9 && year <= DateTime.now().year) {
            if (yearlyExpenses.containsKey(year)) {
              yearlyExpenses[year] = yearlyExpenses[year]! + amount;
            } else {
              yearlyExpenses[year] = amount;
            }
          }
        }

        List<FlSpot> dataPoints = [];
        for (int i = 9; i >= 0; i--) {
          int year = DateTime.now().year - i;
          double expense = yearlyExpenses[year] ?? 0;
          dataPoints.add(FlSpot(9 - i.toDouble(), expense));
        }

        double maxYValue = yearlyExpenses.values
            .reduce((value, element) => value > element ? value : element);

        return ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 60, 30, 40),
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: maxYValue / 5,
                      getTitles: (value) {
                        if (value == 0) return '0';
                        if (value % 1000 == 0)
                          return '${(value ~/ 1000)}';
                        return ''; // Show the actual expense value
                      },
                      margin: 15,
                    ),
                    rightTitles: SideTitles(
                      margin: 20,
                      showTitles: false,
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        int index = value.toInt();
                        if (index < 0 || index >= 10) return '';
                        return (DateTime.now().year - (9 - index)).toString();
                      },
                      margin: 16,
                    ),
                    topTitles: SideTitles(showTitles: false),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    if (dataPoints.length > 1)
                      LineChartBarData(
                        spots: dataPoints,
                        isCurved: true,
                        colors: [Colors.purple],
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                      ),
                  ],
                  minY: 0,
                  maxY: maxYValue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
