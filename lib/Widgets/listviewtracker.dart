import 'package:expensestracker/Models/tracnsaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Widgets/transaction_item.dart';

class ListViewTracker extends StatelessWidget {
  const ListViewTracker(this._expenses, this._deleteItem);
  final List<Transaction> _expenses;
  final Function? _deleteItem;

  @override
  Widget build(BuildContext context) {
    return _expenses.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(children: [
              Container(
                height: constraints.maxHeight * 0.10,
                child: const Text(
                  'No Transactions Added yet ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w100),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.1,
              ),
              Container(
                height: constraints.maxHeight * 0.6,
                child: Image.asset(
                  'assets/waiting.png',
                  height: 100,
                ),
              ),
            ]);
          })
        : ListView.builder(
            itemCount: _expenses.length,
            itemBuilder: (ctx, index) => TransactionItem(
                expenses: _expenses[index], deleteItem: _deleteItem));
  }
}
