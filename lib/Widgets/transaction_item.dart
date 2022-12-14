import 'package:flutter/material.dart';
import '../Models/tracnsaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required expenses,
    required Function? deleteItem,
  })  : _expenses = expenses,
        _deleteItem = deleteItem,
        super(key: key);

  final Transaction _expenses;
  final Function? _deleteItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
          leading: CircleAvatar(
            radius: 50,
            foregroundColor: Theme.of(context).primaryColor,
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              child: Text(
                '${_expenses.amount}',
                style: const TextStyle(color: Colors.purple, fontSize: 14),
              ),
            ),
          ),
          title: Text(
            _expenses.title,
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            DateFormat.yMd().format(_expenses.dateTime),
            style: const TextStyle(color: Colors.black),
          ),
          trailing: MediaQuery.of(context).size.width > 400
              ? ElevatedButton.icon(
                  onPressed: () => _deleteItem!(_expenses.id),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  label: const Text('Delete'))
              : IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => _deleteItem!(_expenses.id),
                )),
    );
  }
}
