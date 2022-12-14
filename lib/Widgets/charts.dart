import 'dart:developer';

import 'package:flutter/material.dart';
import '../Models/tracnsaction.dart';
import 'package:intl/intl.dart';
import '../Widgets/char_bar.dart';

class Charts extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Charts(this.recentTransaction);

  List<Map<String, dynamic>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].dateTime.day == weekDay.day &&
            recentTransaction[i].dateTime.month == weekDay.month &&
            recentTransaction[i].dateTime.year == weekDay.year) {
          totalSum += recentTransaction[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    log('$groupTransactionValues');
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Card(
            elevation: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupTransactionValues.map((e) {
                return ChartBar(
                  label: e['day'],
                  spendingAmount: e['amount'],
                  spendingPctOfTotal:
                      totalSpending == 0 ? 0.0 : (e['amount']) / totalSpending,
                );
              }).toList(),
            ),
          ),
        ));
  }
}
