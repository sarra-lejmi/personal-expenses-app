import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const TransactionList({
    super.key,
    required this.transactions,
    required this.deleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        transactions.isEmpty
            ? LayoutBuilder(
                builder: (context, constraint) {
                  return Column(
                    children: [
                      Text(
                        "No transactions addes yet!",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 180,
                        child: Image.asset(
                          "assets/images/waiting.png",
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  );
                },
              )
            : SizedBox(
                height: 450,
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: FittedBox(
                              child: Text("${transactions[index].amount}"),
                            ),
                          ),
                        ),
                        title: Text(transactions[index].title),
                        subtitle: Text(
                          DateFormat.yMMMMd().format(transactions[index].date),
                        ),
                        trailing: MediaQuery.of(context).size.width > 450
                            ? TextButton.icon(
                                onPressed: () =>
                                    deleteTransaction(transactions[index].id),
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                label: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                ),
                              )
                            : IconButton(
                                onPressed: () =>
                                    deleteTransaction(transactions[index].id),
                                icon: const Icon(Icons.delete),
                                color: Theme.of(context).colorScheme.error,
                              )),
                  ),
                ),
              ),
      ],
    );
  }
}
