

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime _selectedDate = DateTime.now();

const List<String> list = <String>['Income','Expense'];

class NewTransaction extends StatefulWidget{

  final Function addTransacrion;
  const NewTransaction(this.addTransacrion, {super.key});



  @override
  State<StatefulWidget> createState() {

    return _NewTransactionState();
  }
}


class _NewTransactionState extends State<NewTransaction> {
  String dropdownValue = list.first;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitData(){
    if(_amountController.text.isEmpty){
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse( _amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTransacrion(enteredTitle,dropdownValue,enteredAmount,_selectedDate);
    Navigator.of(context).pop();
  }



  void _showDatePicker(){
    showDatePicker(
      context:context, initialDate:DateTime.now(),
      firstDate:  DateTime(2019),
      lastDate: DateTime.now()
    ).then(((pickedDate){
      if(pickedDate == null){
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });

    }));

  }



  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_circle_down),
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
            ),
            Container(
              height: 70,
              child: Row(
                children: [

                  Expanded(child: Text(
                    _selectedDate == null ?
                        'No Date Chosen':
                        'Picked Date : ${DateFormat.yMd().format(_selectedDate)}'

                  )),
                  TextButton(onPressed:  () =>{ _showDatePicker()},
                    child: const Text("Choose Date",
                    style: TextStyle(
                    fontWeight: FontWeight.bold),),
                  )


                ],
              ),
            ),

            ElevatedButton(onPressed:_submitData, child: Text('Add Transaction'))

          ],
        ),
      ),


    );


  }

}