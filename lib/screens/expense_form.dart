import 'package:bytebank_persistence/database/dao/expense_dao.dart';
import 'package:bytebank_persistence/models/expense.dart';
import 'package:bytebank_persistence/models/expense_type.dart';
import 'package:bytebank_persistence/sensors/qrcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? expense;

  ExpenseForm([this.expense]);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  String _titleAppBar = 'New expense';
  String _textButtonCreate = 'Create';
  final ExpenseDao _dao = ExpenseDao();
  String? selectedValue;
  final List<String> items = expenseTypeList(ExpenseTypeMap);
  TextEditingController _valueController =
  TextEditingController();
  TextEditingController _labelController =
  TextEditingController();
  DateTime _chosenDateTime = DateTime.now();
  int _expenseId = 0;

  @override
  Widget build(BuildContext context) {
    if(widget.expense != null) {
      print('expense not null');
      print(widget.expense.toString());
      _editExpense();
    }
    return Scaffold(
      appBar: AppBar(title: Text(_titleAppBar)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                child: Container(
                  height: 120,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _chosenDateTime,
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _chosenDateTime = newDateTime;
                      });
                    },
                  ),
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
                        _expenseId, type!, value!, label,
                        _chosenDateTime.toString().substring(0, 10)
                      );
                      if(widget.expense != null){
                        _dao.update(newExpense);
                      }
                      else {
                        _dao.save(newExpense);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          ),
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

  void _editExpense() {
    _titleAppBar = 'Edit Expense';
    _textButtonCreate = 'Save';
    selectedValue = widget.expense?.type;
    _labelController.text = widget.expense!.label;
    _valueController.text = widget.expense!.value.toString();
    _chosenDateTime = DateTime.tryParse(widget.expense!.date)!;
    _expenseId = widget.expense!.id;
  }
}