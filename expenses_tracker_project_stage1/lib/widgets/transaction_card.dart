// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:expenses_tracker_project_stage1/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.data,
  });

  final dynamic data;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    String formattedDate = DateFormat('d MMM hh:mma').format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                color: Colors.grey.withOpacity(0.09),
                blurRadius: 10.0,
                spreadRadius: 4.0,
              )
            ]),
        child: ListTile(
            minVerticalPadding: 4,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            leading: Container(
              width: 60,
              height: 90,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:data['type']=='credit' ?
                   Colors.green.withOpacity(0.2)
                   :Colors.red.withOpacity(0.2),
                ),
                child: Center(
                  child: FaIcon(
                      appIcons.getExpensesCategoryIcons('${data['category']}'),
                      color:data['type']=='credit' 
                      ?Colors.green
                      :Colors.red),
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                    child: Text('${data['title']}',
                        style: TextStyle(fontSize: 13))),
                Text(
                  "${data['type']=='credit'? '+' : '-'} ₹${data['amount']}",
                  style: TextStyle(color:data['type']=='credit' ?
                    Colors.green
                   :Colors.red, fontSize: 13),
                )
              ],
            ),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Balance",
                          style: TextStyle(color: Colors.grey, fontSize: 11)),
                      Spacer(),
                      Text("₹${data['remainingAmount']}",
                          style: TextStyle(color: Colors.grey, fontSize: 11))
                    ],
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  )
                ])),
      ),
    );
  }
}
