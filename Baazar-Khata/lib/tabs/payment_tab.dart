import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_bazaar_khata/util/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class PaymentTab extends StatefulWidget {
  const PaymentTab({Key? key}) : super(key: key);
  @override
  _PaymentTabState createState() => _PaymentTabState();
}

class _PaymentTabState extends State<PaymentTab> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List noteList = [];
  int count = 0;

  final currentuser = FirebaseAuth.instance.currentUser;

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List> noteListFuture = databaseHelper.getPaymentList(currentuser!.uid);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }

  Widget buildPayment() {
    if (count == 0) {
      return const Center(
        child: Text('No recents Payment found'),
      );
    }
    return ListView.builder(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 65),
      itemCount: count,
      itemBuilder: (buildcontext, position) => Card(
        child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(2),
              title: AbsorbPointer(
                child: Text(
                  noteList[position].customerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  noteList[position].dateTime,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              trailing: Text(
                '\u{20B9} ${noteList[position].amount}',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ),
    );
  }

  Color? color(method) {
    if (method == 'paid') {
      return Colors.green[400];
    }
    if (method == 'payment') {
      return Colors.red[400];
    }
    if (method == 'save') {
      return Colors.blueGrey[400];
    }
    return Colors.grey[400];
  }

  bool refresh = true;
  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty && refresh) {
      noteList = [];
      refresh = false;
      updateListView();
    }
    return Container(
      child: buildPayment(),
    );
  }
}
