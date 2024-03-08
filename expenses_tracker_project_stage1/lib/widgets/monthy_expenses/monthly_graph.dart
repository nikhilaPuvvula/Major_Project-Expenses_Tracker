// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_label, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyGraph extends StatelessWidget {
  MonthlyGraph({super.key, required this.monthyear});
  String type = "debit";
  final userId = FirebaseAuth.instance.currentUser!.uid;

  final String monthyear;

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('monthyear', isEqualTo: monthyear)
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
        Map<String, double> expensesByCategory = {};

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

          if (date.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
            String category = doc['category'];
            int amount = doc['amount'];
            expensesByCategory[category] =
                (expensesByCategory[category] ?? 0) + amount;
          }
        }

        if (expensesByCategory.isEmpty) {
          return Container(
            padding: EdgeInsets.only(top:190.0,left:20.0,right:20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No data available for the selected month.',
                    style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
          );
        }

        double maxYValue = expensesByCategory.values
            .reduce((value, element) => value > element ? value : element);
        List<BarChartGroupData> barGroups = [];
        int index = 0;
        expensesByCategory.forEach((category, amount) {
          barGroups.add(BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                y: amount.toDouble(),
                colors: [Colors.purple],
              ),
            ],
          ));
          index++;
        });

        return Container(
          height: 230,
          margin: EdgeInsets.fromLTRB(20, 40, 20, 130),
          child: BarChart(
            BarChartData(
              groupsSpace: 20,
              barGroups: barGroups,
              titlesData: FlTitlesData(
                show: true,
                leftTitles: SideTitles(
                  showTitles: true,
                  interval: maxYValue / 5,
                  getTitles: (value) {
                    if (value == 0) return '0';
                    if (value % 1000 == 0) return '${(value ~/ 1000)}';
                    return '';
                  },
                ),
                rightTitles: SideTitles(
                  showTitles: false,
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  rotateAngle: 90,
                  getTitles: (value) {
                    if (value.toInt() < expensesByCategory.length) {
                      return expensesByCategory.keys.elementAt(value.toInt());
                    }
                    return '';
                  },
                ),
                topTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
