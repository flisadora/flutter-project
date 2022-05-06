import 'package:bytebank_persistence/components/progress.dart';
import 'package:bytebank_persistence/database/dao/contact_dao.dart';
import 'package:bytebank_persistence/models/contact.dart';
import 'package:bytebank_persistence/screens/contact_form.dart';
import 'package:bytebank_persistence/screens/transaction_form.dart';
import 'package:flutter/material.dart';

const _titleAppBar = 'Transfer';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: FutureBuilder<List<Contact>>(
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
              final List<Contact> contacts = snapshot.data as List<Contact>;
              return ListView.builder(
                itemBuilder: (context, index){
                  final Contact contact = contacts[index];
                  return _ContactItem(contact, onClick: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => TransactionForm(contact)
                        )
                    );
                  },);
                },
                itemCount: contacts.length,
              );
          }
          return Text('Unknown error');
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            ),
          ).then((value) => setState(() {} ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget{
  final Contact contact;
  final Function onClick;

  _ContactItem(this.contact, {required this.onClick});

  @override
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(contact.name),
        subtitle: Text(contact.accountNumber.toString()),
      ),
    );
  }
}