// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_declarations, prefer_for_elements_to_map_fromiterable, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedGraph extends StatelessWidget {
  final String year;
  final String type = "debit";
  final userId = FirebaseAuth.instance.currentUser!.uid;

  SelectedGraph({Key? key, required this.year}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('type', isEqualTo: type)
          .where('timestamp',isGreaterThanOrEqualTo: DateTime(int.parse(year), 1, 1))
          .where('timestamp', isLessThan: DateTime(int.parse(year) + 1, 1, 1))
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<DocumentSnapshot> docs = snapshot.data!.docs;
        Map<int, double> monthlyExpenses = Map.fromIterable(
          List.generate(12, (index) => index + 1),
          key: (index) => index,
          value: (index) => 0.0,
        );

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
          int month = date.month;
          double amount = doc['amount'].toDouble();
          print(month);
          print(amount);
          monthlyExpenses[month] = monthlyExpenses[month]! + amount;
        }

        List<FlSpot> dataPoints = [];
        for (int i = 1; i <= 12; i++) {
          dataPoints.add(FlSpot(i.toDouble(), monthlyExpenses[i] ?? 0));
        }

        double maxYValue = monthlyExpenses.values
            .reduce((value, element) => value > element ? value : element);

        if (maxYValue == 0) {
          maxYValue =
              1; // Set a minimum value for maxYValue to avoid division by zero
        }

        return Column(
          children: [
            Container(
              height: 300,
              margin: EdgeInsets.all(20),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: maxYValue / 5,
                      getTitles: (value) {
                        if (value == 0) return '0';
                        if (value % 1000 == 0) return '${(value ~/ 1000)}k';
                        return '${value.toInt()}'; // Show the actual expense value
                      },
                      margin: 8,
                    ),
                    rightTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        int month = value.toInt();
                        if (month < 1 || month > 12) return '';
                        return DateFormat('MMM')
                            .format(DateTime(int.parse(year), month));
                      },
                      margin: 8,
                    ),
                    topTitles: SideTitles(showTitles: false),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: true,
                      colors: [Colors.purple],
                      barWidth: 2,
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
