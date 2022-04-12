import 'package:bytebank_persistence/database/dao/expense_dao.dart';
import 'package:bytebank_persistence/models/expense.dart';
import 'package:bytebank_persistence/sensors/qrcode_reader.dart';
import 'package:flutter/material.dart';

const _titleAppBar = 'New expense';
const _textButtonCreate = 'Create';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _valueController =
  TextEditingController();
  final ExpenseDao _dao = ExpenseDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleAppBar)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Type',
              ),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: 'Value',
                ),
                style: TextStyle(
                  fontSize: 20.0,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text(_textButtonCreate),
                  onPressed: () {
                    final String type = _typeController.text;
                    final double? value =
                    double.tryParse(_valueController.text);
                    final Expense newExpense = Expense(0, type, value!);
                    _dao.save(newExpense).then((id) => Navigator.pop(context));
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          QrCodeReader('qr code reader');
        },
        child: Icon(
          Icons.qr_code_2_sharp,
          size: 32,
        ),
      ),
    );
  }
}
