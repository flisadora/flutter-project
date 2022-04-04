import 'dart:convert';

import 'package:bytebank_persistence/http/webclient.dart';
import 'package:bytebank_persistence/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {

  Future<List<Transaction>> findAll() async {
    final Response response =
    await client.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) =>
        Transaction.fromJson(json)).toList();
    /*List<Transaction> list = decodedJson.map((dynamic json) => Transaction.fromJson(json)).toList();
    for(Transaction item in list){
      delete(item.id);
      print(item.toString());
    }
    return list;*/
    }

  Future<Transaction> save(Transaction transaction) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-type': 'application/json',
          'password': '1000',
        },
        body: transactionJson
    );

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future<Response> delete(int id) async {
    final Response response = await client.delete(
        Uri.parse('http://192.168.1.80:8080/transactions/$id'),
        headers: {
          'Content-type': 'application/json',
          'password': '1000',
        },
    );
    print('deleted');

    return response;
  }

}