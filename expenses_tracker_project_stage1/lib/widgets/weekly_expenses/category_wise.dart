// ignore_for_file: prefer_const_declarations, use_key_in_widget_constructors, prefer_const_constructors, unused_local_variable, curly_braces_in_flow_control_structures, unused_label

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CategoryWise extends StatelessWidget {
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
            // showingTooltipIndicators: [0],
          ));
          index++;
        });

        return Container(
          height: 300,
          margin: EdgeInsets.fromLTRB(20, 50, 20, 75),
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
                    Style:
                    TextStyle(fontSize:5); 
                    // Show values in k format
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
                    Style:
                    TextStyle(fontSize: 10);
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
