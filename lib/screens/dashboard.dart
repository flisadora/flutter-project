import 'package:bytebank_persistence/screens/contacts_list.dart';
import 'package:bytebank_persistence/screens/expenses_list.dart';
import 'package:bytebank_persistence/screens/transactions_list.dart';
import 'package:flutter/material.dart';

const _titleAppBar = 'WalletWatch';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/ww_logo.png'),
          ),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _FeatureItem(
                  'Expenses',
                  Icons.money,
                  onClick: () {
                    _ShowExpensesList(context);
                  },
                ),
                _FeatureItem(
                  'Transaction Feed',
                  Icons.description,
                  onClick: () {
                    _ShowTransactionsList(context);
                  },
                ),
                _FeatureItem(
                  'Transaction Feed',
                  Icons.star,
                  onClick: () {
                    debugPrint('shine on');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _ShowTransactionsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TransactionsList()),
    );
  }

  void _ShowExpensesList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ExpensesList()),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  _FeatureItem(this.name, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20.0,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
