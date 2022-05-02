import 'package:bytebank_persistence/components/centered_message.dart';
import 'package:bytebank_persistence/components/progress.dart';
import 'package:bytebank_persistence/database/dao/expense_dao.dart';
import 'package:bytebank_persistence/models/expense.dart';
import 'package:bytebank_persistence/screens/expense_form.dart';
import 'package:flutter/material.dart';

const _titleAppBar = 'Expenses';
final ExpenseDao _dao = ExpenseDao();

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key}) : super(key: key);

  @override
  State<ExpensesList> createState() => ExpensesListState();
}

class ExpensesListState extends State<ExpensesList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: FutureBuilder<List<Expense>>(
        initialData: [],
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if(snapshot.hasData) {
                final List<Expense> expenses = snapshot.data as List<Expense>;
                if (expenses.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Expense expense = expenses[index];
                      return _ExpenseItem(expense, onClick: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ExpenseForm(expense)
                            )
                        );
                      },);
                    },
                    itemCount: expenses.length,
                  );
                }
              }
              return CenteredMessage('No expenses found', icon: Icons.warning);
            }
          return CenteredMessage('Unknown error');
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExpenseForm(),
            ),
          ).then((_) => setState(() {} ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ExpenseItem extends StatelessWidget{
  final Expense expense;
  final Function onClick;

  _ExpenseItem(this.expense, {required this.onClick});

  @override
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        leading: Icon(Icons.monetization_on),
        title: Text(
          expense.label,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            expense.value.toString(),
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        trailing: TextButton(
          onPressed: () {
            _dao.delete(expense);
            FutureBuilder<List<Expense>>(
                initialData: [],
                future: _dao.findAll(),
                builder: (context, snapshot) {
                  print('sera???');
                  return ExpensesList();
                }
            );
          },
          child: Icon(Icons.delete)
        ),
      ),
    );
  }
}