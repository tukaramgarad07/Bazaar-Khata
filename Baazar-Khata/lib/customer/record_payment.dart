import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:new_bazaar_khata/models/note.dart';
import 'package:new_bazaar_khata/util/database_helper.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';
import 'package:new_bazaar_khata/util/success.dart';
import 'package:http/http.dart' as http;

class RecordPayment extends StatefulWidget {
  final String shopName;
  final String customerName;
  final String customerId;
  final String money;
  final String customerEmail;
  const RecordPayment(
      {Key? key,
      required this.shopName,
      required this.customerName,
      required this.customerId,
      required this.customerEmail,
      required this.money})
      : super(key: key);

  @override
  _RecordPaymentState createState() => _RecordPaymentState();
}

class _RecordPaymentState extends State<RecordPayment> {
  DatabaseHelper helper = DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final currentuser = FirebaseAuth.instance.currentUser;

  var _desc = '';
  var _sum = 0;

  // ignore: avoid_init_to_null
  var imagefromPref = null;

  Future loadImage(key) async {
    Utility.getImageFromPreferences(key).then((value) {
      if (null == value) {
        return;
      }
      setState(() {
        imagefromPref = Utility.imageFromBase64StringCustomerDetail(value);
      });
    });
  }

  Widget getImage(String photoUrl) {
    if (null == imagefromPref) {
      loadImage(photoUrl);
    }
    if (imagefromPref != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image(
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            image: imagefromPref,
          ));
    }
    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const Image(
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            image: AssetImage('images/shop.jpeg')));
  }

  bool _inProcess = false;

  CollectionReference customer =
      FirebaseFirestore.instance.collection('customers');

  Future<void> updateUser(String price) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy ').add_jm();
    final String formatted = formatter.format(now);
    return customer
        .doc(widget.customerId)
        .update({'price': price, 'lastbill': formatted, 'lastSeen': now})
        .then((value) {})
        .catchError((error) {});
  }

  Future sendEmail(
      {required String msgInfo,
      required String customerEmail,
      required String customerName,
      required String desc,
      required String msg,
      required String ownerEmail,
      required String amount,
      required String date}) async {
    const serviceId = 'service_nohnjrh';
    const templateId = 'template_1udt798';
    const userId = 'user_pfn6cH7dYs8TcXy8ldYIB';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    // ignore: unused_local_variable
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'msg_info': msgInfo,
            'customer_email': customerEmail,
            'customer_name': customerName,
            'desc': desc,
            'msg': msg,
            'owner_email': ownerEmail,
            'amount': amount,
            'date': date
          }
        }));
  }

  @override
  void initState() {
    super.initState();
    loadImage(currentuser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy ').add_jm();
    final String formatted = formatter.format(now);
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');

    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(widget.customerId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  centerTitle: false,
                  titleSpacing: 0,
                  title: const Text('Record New Payment'),
                  backgroundColor: Colors.orange[600]),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListTile(
                                  leading: getImage(currentuser!.uid),
                                  title: Text(
                                    currentuser!.photoURL ?? 'Shop Name',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    formatted,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: const InputDecoration(
                                              labelText: 'Description',
                                              border: OutlineInputBorder()),
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'Please Enter Description ';
                                            }
                                            return null;
                                          },
                                          onSaved: (String? value) {
                                            _desc = value!;
                                          }),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.green[800],
                                                fontSize: 26,
                                                fontWeight: FontWeight.w700),
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              prefixText: '\u{20B9}  ',
                                              labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              labelText: 'Enter Amount',
                                            ),
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Amount is Required';
                                              }
                                              if (value.length > 4 ||
                                                  value.contains('-')) {
                                                return 'Amount should between 0 to 9999';
                                              }
                                              if (value.contains(',') ||
                                                  value.contains('.')) {
                                                return "Amount should not contain ' . ' or ' , '";
                                              }
                                              return null;
                                            },
                                            onSaved: (String? value) {
                                              _sum = int.parse(value!);
                                              setState(() {
                                                _sum = int.parse(value);
                                              });
                                            }),
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: Container(
                            width: double.infinity,
                            color: Colors.red[400],
                            child: TextButton(
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  setState(() {
                                    _inProcess = true;
                                  });
                                  bool hasInternet =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                  if (hasInternet == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'No Internet Connection',
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.center)));
                                    return;
                                  }

                                  int finalAmount = int.parse(data['price']);
                                  finalAmount = finalAmount - _sum;
                                  await updateUser(finalAmount.toString());

                                  final DateTime now = DateTime.now();
                                  final DateFormat formatter =
                                      DateFormat('dd-MM-yyyy ').add_jm();
                                  final DateFormat formatter1 =
                                      DateFormat('dd-MM-yyyy ');
                                  final String formatted =
                                      formatter.format(now);
                                  final String formattedDate =
                                      formatter1.format(now);
                                  String msg =
                                      "${widget.shopName} record a Payment of \u{20B9} $_sum in your Account";
                                  String ownerEmail = currentuser!.email ?? '';

                                  sendEmail(
                                      msgInfo: "New Payment recorded",
                                      customerEmail: widget.customerEmail,
                                      customerName: widget.customerName,
                                      desc: _desc,
                                      msg: msg,
                                      ownerEmail: ownerEmail,
                                      amount: finalAmount.toString(),
                                      date: formatted);

                                  var result = await helper.insertNote(Note(
                                      widget.shopName,
                                      currentuser!.uid,
                                      widget.customerName,
                                      widget.customerId,
                                      'You received Cash Payment of \u{20B9} $_sum',
                                      _desc,
                                      '$_sum',
                                      'cash',
                                      formattedDate,
                                      formatted));

                                  if (result != 0) {
                                    await helper.insertActivity(Activity(
                                        currentuser!.uid,
                                        "You record a cash payment of \u{20B9} $_sum in ${widget.customerName}'s Account",
                                        'payment',
                                        formatted));
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SuccessBill(
                                                    method: 'payment')));
                                    Navigator.pop(context, 'true');
                                  } else {}
                                },
                                child: const Text(
                                  'Record Payment',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                          )),
                    ],
                  ),
                  (_inProcess)
                      ? Container(
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          height: MediaQuery.of(context).size.height * 0.95,
                        )
                      : const Center()
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
                centerTitle: false,
                titleSpacing: 0,
                title: const Text('Record New Payment'),
                backgroundColor: Colors.orange[600]),
          );
        });
  }
}
