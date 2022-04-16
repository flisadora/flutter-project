import 'package:bytebank_persistence/database/dao/expense_dao.dart';
import 'package:bytebank_persistence/models/expense.dart';
import 'package:bytebank_persistence/models/expense_type.dart';
import 'package:bytebank_persistence/sensors/qrcode_scan.dart';
import 'package:flutter/material.dart';
import  'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

const _titleAppBar = 'New expense';
const _textButtonCreate = 'Create';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final TextEditingController _valueController =
  TextEditingController();
  final TextEditingController _labelController =
  TextEditingController();
  final ExpenseDao _dao = ExpenseDao();
  String? selectedValue;
  final List<String> items = expenseTypeList(ExpenseTypeMap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleAppBar)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                hint: Text(
                  'Select Type',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: items.map((item) =>
                  DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )).toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                buttonHeight: 50,
                buttonWidth: 400,
                itemHeight: 40,
              ),
            ),
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                labelText: 'Label',
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
                    final String? type = selectedValue;
                    final double? value =
                    double.tryParse(_valueController.text);
                    final String label = _labelController.text;
                    final Expense newExpense = Expense(
                      0,
                      type!,
                      value!,
                      label,
                      DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
                    );
                    print(newExpense.toString());
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
          debugPrint('qr code scan call');
          QrCodeScan();
        },
        child: Icon(
          //Icons.qr_code_2_sharp,
          Icons.more_vert,
          size: 32,
        ),
      ),
    );
  }
}
