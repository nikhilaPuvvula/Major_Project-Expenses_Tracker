// ignore_for_file: prefer_const_declarations, use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, curly_braces_in_flow_control_structures, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TotalExpenses extends StatelessWidget {
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
        Map<String, double> expensesByDate = {};

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
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(date); // Format date as string

          int amount = doc['amount'];

          if (date.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
            expensesByDate[formattedDate] =
                (expensesByDate[formattedDate] ?? 0) + amount;
          }
        }
        List<FlSpot> dataPoints = [];
        DateTime currentDate = DateTime.now();
        for (int i = 0; i < 7; i++) {
          DateTime date = currentDate.subtract(Duration(days: 6 - i));
          String fDate = DateFormat('yyyy-MM-dd').format(date);
          double expense = expensesByDate[fDate] ?? 0;
          //print('Date: $fDate, Expense: $expense');
          dataPoints.add(FlSpot(i.toDouble(), expense));
        }

        double maxYValue = expensesByDate.values
            .reduce((value, element) => value > element ? value : element);

        return ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  20, 50, 20, 40), // Add a right margin of 20 pixels
              // width: 400, // Set the width of the box
              height: 300, // Set the height of the box
              /*decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey), // Add a border around the box
                borderRadius: BorderRadius.circular(
                    10), // Optional: Add rounded corners to the box
              ),*/

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
                            return '${(value ~/ 1000)}'; // Show values in k format
                          return '';
                        },
                        margin: 15,
                      ),
                      rightTitles: SideTitles(
                        margin: 20,
                        //showTitles: false,
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          int index = value.toInt();
                          if (index < 0 || index >= 7) return '';
                          DateTime date =
                              currentDate.subtract(Duration(days: 6 - index));
                          return DateFormat('E').format(date);
                        },
                        margin: 16,
                      ),
                      topTitles: SideTitles(showTitles: false)),
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
