
import 'package:expense_manager/transaction.dart';
import 'package:expense_manager/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'new_transaction.dart';

void main() {
  runApp(const MyApp());
}

final List<Transaction> _userTransactions = [];

final colorList = <Color>[
  Colors.blue.shade400,
  Colors.orangeAccent.shade400,
  Colors.purpleAccent.shade200,
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      color: Colors.white,

      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple),
      debugShowCheckedModeBanner: false,
      home : MyHome(),
    );
  }

}

class MyHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return HomeState();
  }
}

class HomeState extends State<MyHome>{
  double income= 0,expense=0;
  Map<String, double> dataMap = {
    "Income":0,
    "Expense":0,
    "Savings": 0
  };

  void _addNewTransaction(String txTitle,String type, double txAmount,DateTime _selectedDate) {

    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date:_selectedDate,
      id: DateTime.now().toString(),
      type: type,
    );

    setState(() {
      _userTransactions.add(newTx);
      if(type == 'Income') {
        income = income + newTx.amount;
      } else {
        expense = expense + newTx.amount;
      }

     double savings = income - expense;
      dataMap.update('Income', (value) => income);
      dataMap.update('Expense', (value) => expense);
      dataMap.update('Savings', (value) => savings);

    });
  }

  void _deleteTransaction(String id){
    setState(() {
       Transaction ele = _userTransactions.where((element) => element.id == id).single;
       ele.type == 'Income'?{income = income - ele.amount} :{expense = expense - ele.amount};
      _userTransactions.removeWhere((element) =>
           element.id == id

      );
       if(_userTransactions.length == 0){
         dataMap.update('Income', (value) => 0);
         dataMap.update('Expense', (value) => 0);
         dataMap.update('Savings', (value) => 0);
       }else{
         double savings = income - expense;
         dataMap.update('Income', (value) => income);
         dataMap.update('Expense', (value) => expense);
         dataMap.update('Savings', (value) => savings);
       }


    });

  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){

      return GestureDetector(
        onTap: (){},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );

    },);

  }


  @override
  Widget build(BuildContext context) {
    if(_userTransactions.length == 0){
      dataMap.update('Income', (value) => 0);
      dataMap.update('Expense', (value) => 0);
      dataMap.update('Savings', (value) => 0);
    }

    return Scaffold(
       backgroundColor: Colors.white,
       body: SingleChildScrollView(
         padding:  const EdgeInsets.all( 30.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             SizedBox(height: 40.0),
            Container(
              height: 150,
                width: 300,
                child:PieChart(
               dataMap: dataMap,
               animationDuration: Duration(milliseconds: 800),
               chartLegendSpacing: 45,
               chartRadius: MediaQuery.of(context).size.width / 3.2,
               colorList: colorList,
               initialAngleInDegree: 0,
               chartType: ChartType.ring,
               ringStrokeWidth: 35,
               centerText: "Money flow",
               legendOptions: LegendOptions(
                 showLegendsInRow: false,
                 legendPosition: LegendPosition.right,
                 showLegends: true,
                 legendShape: BoxShape.circle,
                 legendTextStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                 ),
               ),
               chartValuesOptions: ChartValuesOptions(
                 showChartValueBackground: true,
                 showChartValues: true,
                 showChartValuesInPercentage: false,
                 showChartValuesOutside: true,
                 decimalPlaces: 1,
               ),
             )),
             const SizedBox(height: 40.0),

              Card(
                  shape: RoundedRectangleBorder(  borderRadius: BorderRadius.circular(20.0)),
                 child:Text( textAlign: TextAlign.center,'***Recent Transactions***',style: TextStyle(fontSize: 26,color: Colors.purple,fontStyle: FontStyle.normal))),

             TransactionList(_userTransactions,_deleteTransaction)

             ],

         ),
       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
       floatingActionButton: FloatingActionButton(

         child: Icon(Icons.add),
         onPressed: () =>{
           _startAddNewTransaction(context)
         },
       ),

     );

  }

}


