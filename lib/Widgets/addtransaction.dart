import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction(this.funct, {Key? key}) : super(key: key);
  final Function funct;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    void _presentDatePicker() async {
      await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime.now())
          .then((pickedDate) {
        //this means if picked date is null then assign current time and date
        // if (pickedDate == null) return;

        // setState(() {
        //   _selected = pickedDate;
        // });

        // log('$_selected');

        pickedDate ??= DateTime.now();

        setState(() {
          _selected = pickedDate;
        });
      });
    }

//for keyboard setup from the bottom side
// you Need  to access the MediaQuery.of(context).viewinset.bottom + 15

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: 'Enter your title ',
                  labelText: 'Enter your title',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: amountController,
              decoration: const InputDecoration(
                  hintText: 'Enter your amount',
                  labelText: 'Enter your amount',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selected == null
                      ? 'Date Not choosen'
                      : DateFormat.yMd().format(_selected!),
                  style: const TextStyle(color: Colors.black),
                ),
                OutlinedButton(
                    onPressed: _presentDatePicker,
                    child: const Text('Select Date'))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      double amountDouble = double.parse(amountController.text);
                      if (titleController.text.isEmpty ||
                          amountDouble < 0 ||
                          amountDouble.toString().isEmpty) {
                        return;
                      }
                      widget.funct(
                          titleController.text, amountDouble, _selected);
                      Navigator.pop(context);
                    },
                    child: const Text('Save Transaction'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
