import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './transaction.dart';


class TransactionList extends StatelessWidget{

  final List<Transaction> transactions;
  final Function deleteTransactions;
  TransactionList(this.transactions,this.deleteTransactions);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 10),
      height: 450,
      child: transactions.isEmpty?
      Column(
        children:<Widget> [
          Text('No transactions added yet',style: Theme.of(context).textTheme.titleMedium,),
          const SizedBox(height: 20,),
        ],
      )
          :ListView.builder(itemBuilder: (ctx,index){
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5
          ),
          child: ListTile(
            leading: CircleAvatar(

              backgroundColor:transactions[index].type == 'Income'? Colors.blue.shade400 : Colors.orangeAccent.shade400 ,
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(' ₹${transactions[index].amount}',style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic),),
                ),
              ),
            ),
            title: Text(
              '${transactions[index].title}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: Text(
                DateFormat.yMMMd().format(transactions[index].date)

            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: ()=>deleteTransactions(transactions[index].id),
            ),

          ),

        );
      },
        itemCount: transactions.length,
      ),
    );


  }



}