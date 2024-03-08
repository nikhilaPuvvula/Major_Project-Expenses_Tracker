// ignore_for_file: unused_import, non_constant_identifier_names, avoid_types_as_parameter_names, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';

class TimeLineYear extends StatefulWidget {
  const TimeLineYear({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;
  @override
  State<TimeLineYear> createState() => _TimeLineYearState();
}

class _TimeLineYearState extends State<TimeLineYear> {
  String currentYear = "";
  List<String> years = [];
  final scrollController = ScrollController();
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    for (int i = -18; i <= 0; i++) {
      years.add(
          DateFormat('y').format(DateTime(now.year+i, 1)));
    }
    currentYear = DateFormat('y').format(now);

    Future.delayed(Duration(seconds: 1), () {
      scrollToSelectedMonth();
    });
  }

  scrollToSelectedMonth() {
    final selectedMonthIndex = years.indexOf(currentYear);
    if (selectedMonthIndex != -1) {
      final scrollOffset = (selectedMonthIndex * 100.0) - 170;
      scrollController.animateTo(scrollOffset,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: ListView.builder(
            controller: scrollController,
            itemCount: years.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentYear = years[index];
                    widget.onChanged(years[index]);
                  });
                  scrollToSelectedMonth();
                },
                child: Container(
                  width: 80,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: currentYear == years[index]
                          ? Colors.purple
                          : Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Text(years[index],
                          style: TextStyle(
                              color: currentYear == years[index]
                                  ? Colors.white
                                  : Colors.purple))),
                ),
              );
            }));
  }
}
