import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses App",
      theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: "Quicksand",
          textTheme: const TextTheme(
            titleMedium: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 20),
          )),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: "t1",
    //   title: "New shoes",
    //   amount: 95.0,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t2",
    //   title: "new shirt",
    //   amount: 59.9,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime dateChoosen) {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: dateChoosen,
    );

    setState(() {
      _userTransaction.add(transaction);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: NewTransaction(addTransaction: _addNewTransaction),
      ),
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((transaction) => transaction.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text("Personal Expenses App"),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
    final transactionListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
        transactions: _userTransaction,
        deleteTransaction: _deleteTransaction,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Show chart"),
                  Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  )
                ],
              ),
            if (!isLandscape)
              SizedBox(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(recentTransactions: _recentTransactions)),
            if (!isLandscape) transactionListWidget,
            if (isLandscape)
              _showChart
                  ? SizedBox(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(recentTransactions: _recentTransactions))
                  : transactionListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
