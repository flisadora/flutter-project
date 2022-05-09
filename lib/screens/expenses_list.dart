import 'package:bytebank_persistence/components/centered_message.dart';
import 'package:bytebank_persistence/components/progress.dart';
import 'package:bytebank_persistence/database/dao/expense_dao.dart';
import 'package:bytebank_persistence/models/expense.dart';
import 'package:bytebank_persistence/screens/expense_form.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

const _titleAppBar = 'Expenses';
final ExpenseDao _dao = ExpenseDao();
const Map<String,String> monthsInYear = {
  '01': "January",
  '02': "February",
  '03': "March",
  '04': "April",
  '05': "May",
  '06': "June",
  '07': "July",
  '08': "August",
  '09': "September",
  '10': "October",
  '11': "November",
  '12': "December"
};

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
                  expenses.sort((a, b) => b.date.compareTo(a.date));
                  return GroupedListView<dynamic, String>(
                    elements: expenses,
                    groupBy: (expense) => expense.date.substring(0,7),
                    groupComparator: (value1, value2) => value2.compareTo(value1),
                    itemComparator: (item1, item2) =>
                    item2.date.substring(8).compareTo(item1.date.substring(8)),
                    order: GroupedListOrder.ASC,
                    useStickyGroupSeparators: true,
                    groupSeparatorBuilder: (String value) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20, fontWeight:
                        FontWeight.bold),
                      ),
                    ),
                    itemBuilder: (context, expense) {
                      return _ExpenseItem(
                        expense,
                        onClick: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: "/ExpenseForm"),
                              builder: (context) => ExpenseForm(expense)
                            )
                          );
                          setState(() {});
                        },
                      );
                    },
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
              settings: RouteSettings(name: "/ExpenseForm"),
              builder: (context) => ExpenseForm(),
            ),
          );
          setState(() {});
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ExpensesList(),
              ),
            );
          },
          child: Icon(Icons.delete)
        ),
      ),
    );
  }
}