import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bytebank_persistence/models/expense.dart';
import 'package:bytebank_persistence/components/progress.dart';
import 'package:bytebank_persistence/database/dao/expense_dao.dart';
import 'package:bytebank_persistence/models/expense_type.dart';

import '../components/centered_message.dart';

const _titleAppBar = 'Expenses Graphic';

class GraphicsPage extends StatefulWidget {
  GraphicsPage({Key? key}) : super(key: key);

  @override
  GraphicsPageState createState() => GraphicsPageState();
}

class GraphicsPageState extends State<GraphicsPage> {
  final ExpenseDao _dao = ExpenseDao();
  final List<String> items = expenseTypeList(ExpenseTypeMap);
  double total = 0;
  List<double> graphicData = [];
  int index = -1;
  String graphicLabel = 'Total';
  double graphicValue = 0.00;
  List<double> transactions = [];
  late NumberFormat real;
  List<Expense> expenses = [];
  @override
  Widget build(BuildContext context) {
    real = NumberFormat.currency(locale: "en_US", symbol: "€");

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: FutureBuilder<List<Expense>>(
        initialData: [],
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                expenses = snapshot.data as List<Expense>;
                if (expenses.isNotEmpty) {
                  print('expenses');
                  print(expenses.length);
                  if (graphicData.length == 0) {
                    for (var i = 0; i < items.length; i++) {
                      graphicData.add(0);
                    }

                    for (var i = 0; i < expenses.length; i++) {
                      for (var j = 0; j < items.length; j++) {
                        if (expenses[i].type == items[j]) {
                          graphicData[j] += expenses[i].value as double;
                          total += expenses[i].value as double;
                        }
                      }
                    }
                  }
                  graphicValue = total;
                  graphicLabel = 'total';

                  return Container(
                      child: Column(
                    children: [loadGraphic()],
                  ));
                }
              }
              return CenteredMessage('No expenses found',
                  icon: Icons.warning);
          }
          return CenteredMessage('Unknown error');
        },
      ),
    );
  }

  List<PieChartSectionData> loadWallet() {
    setGraphicData(index);
    final lenTransactions = graphicData.length;
    return List.generate(lenTransactions, (i) {
      final isTouched = i == index;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];
      double porcent = 0;

      porcent = graphicData[i] * 100 / total;
      print(i);
      return PieChartSectionData(
        color: color,
        value: porcent,
        title: '${porcent.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    }, growable: false);
  }

  loadGraphic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sectionsSpace: 1,
              centerSpaceRadius: 112,
              sections: loadWallet(),
              pieTouchData: PieTouchData(
                touchCallback: (touch) => setState(() {
                  index = touch.touchedSection!.touchedSectionIndex;
                  print('ind');
                  print(index);
                  setGraphicData(index);
                }),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              graphicLabel,
              style: TextStyle(fontSize: 20, color: Colors.teal),
            ),
            Text(
              real.format(graphicValue),
              style: TextStyle(fontSize: 28),
            ),
          ],
        )
      ],
    );
  }

  setGraphicData(int index) {
    if (index < 0) return;

    if (index == -1) {
      graphicLabel = 'Total';
      graphicValue = total;
    } else {
      graphicValue = graphicData[index];
      graphicLabel = items[index];
    }
  }
}
