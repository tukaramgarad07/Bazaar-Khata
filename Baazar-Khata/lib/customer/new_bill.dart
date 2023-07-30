import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:new_bazaar_khata/models/note.dart';
import 'package:new_bazaar_khata/util/database_helper.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';
import 'package:new_bazaar_khata/util/success.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class NewBill extends StatefulWidget {
  final String shopName;
  final String customerName;
  final String customerId;
  final String money;
  final String customerEmail;
  const NewBill(
      {Key? key,
      required this.shopName,
      required this.customerName,
      required this.customerId,
      required this.customerEmail,
      required this.money})
      : super(key: key);
  @override
  _NewBillState createState() => _NewBillState();
}

class _NewBillState extends State<NewBill> {
  DatabaseHelper helper = DatabaseHelper();
  final currentuser = FirebaseAuth.instance.currentUser;

  late List<dynamic> noteList;
  int count = 0;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd-MM-yyyy ').add_jm();
  static final DateFormat formatter1 = DateFormat('dd-MM-yyyy ');
  final String formatted = formatter.format(now);
  final String formattedDate = formatter1.format(now);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  var _otherquantity = 0;
  var _otherprice = 1;
  var _othertotal = 0;
  var _sum = 0;
  final _items = [];
  final _quantity = [];
  final _price = [];
  final _increase = [];
  final _total = [];
  var _desc = '';
  var _bill = [];

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List> noteListFuture = helper.getItemsList(currentuser!.uid);
      noteListFuture.then((nList) {
        setState(() {
          noteList = nList;
          count = nList.length;
        });
      });
    });
  }

  void sum() {
    int i = 0;
    _sum = 0;
    while (i < _items.length) {
      _sum = _total[i] + _sum;
      i++;
    }
    _sum = _othertotal + _sum;
  }

  billrow(var i) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Center(
              child: ExpandableText(
                _items[i],
                expandText: '',
                collapseText: '',
                maxLines: 1,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                  child: Center(
                    child: Icon(CupertinoIcons.minus_square_fill,
                        color: Colors.red[400], size: 28),
                  ),
                  onTap: () {
                    setState(() {
                      if (_quantity[i] > 0) {
                        _quantity[i] = _quantity[i] - _increase[i];
                        _total[i] = _quantity[i] * _price[i];
                        sum();
                      }
                    });
                  }),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                    child: Center(child: Text('${_quantity[i]}')), width: 40),
              ),
              InkWell(
                child: const Center(
                    child: Icon(Icons.add_box, color: Colors.green, size: 28)),
                onTap: () {
                  setState(() {
                    if (_quantity[i] < 1000) {
                      _quantity[i] = _quantity[i] + _increase[i];
                      _total[i] = _quantity[i] * _price[i];
                      sum();
                    }
                  });
                },
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Center(
              child: ExpandableText(
                '${_price[i]}',
                expandText: '',
                collapseText: '',
                maxLines: 1,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Center(
              child: ExpandableText(
                '${_total[i]}',
                expandText: '',
                collapseText: '',
                maxLines: 1,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  otherrow(var i) {
    return TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Center(
              child: ExpandableText(
                'Others',
                expandText: '',
                collapseText: '',
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                  child: Center(
                    child: Icon(CupertinoIcons.minus_square_fill,
                        color: Colors.red[400], size: 28),
                  ),
                  onTap: () {
                    setState(() {
                      if (_otherquantity > 0) {
                        _otherquantity = _otherquantity - 1;
                        _othertotal = _otherquantity * _otherprice;
                        sum();
                      }
                    });
                  }),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                    child: Center(child: Text('$_otherquantity')), width: 40),
              ),
              InkWell(
                child: const Center(
                    child: Icon(Icons.add_box, color: Colors.green, size: 28)),
                onTap: () {
                  setState(() {
                    if (_otherquantity < 1000) {
                      _otherquantity = _otherquantity + 1;
                      _othertotal = _otherquantity * _otherprice;
                      sum();
                    }
                  });
                },
              ),
            ]),
          ),
        ),
        InkWell(
          onTap: () {
            changeOtherItemFunction(context);
          },
          child: Align(
            alignment: Alignment.center,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Text(
                      '$_otherprice ',
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.edit),

                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: SizedBox(
                  //       child: Center(
                  //           child: Text(
                  //         '$_otherquantity',
                  //       )),
                  //       width: 10),
                  // ),
                  // SizedBox(
                  //   width: 50,
                  //   child: TextFormField(
                  //     initialValue: _otherprice.toString(),
                  //     keyboardType: TextInputType.number,
                  //     textAlign: TextAlign.center,
                  //     decoration: new InputDecoration(
                  //       border: InputBorder.none,
                  //       focusedBorder: InputBorder.none,
                  //       enabledBorder: InputBorder.none,
                  //     ),
                  //     validator: (value) {},
                  //     onSaved: (String value) {
                  //       setState(() {
                  //         _otherprice = int.parse(value);
                  //       });
                  //     },
                  //   ),
                  //)
                  // InkWell(
                  //   child: Center(child: Icon(Icons.edit, size: 22)),
                  //   onTap: () {
                  //     print('Hello World');
                  //   },
                  // ),
                ]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Center(
              child: ExpandableText(
                '$_othertotal',
                expandText: '',
                collapseText: '',
                maxLines: 1,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<TableRow> billTable() {
    var items = _items.length;
    var row = [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ];

    int i = 0;
    while (i < items + 1) {
      if (i < items) {
        var row2 = billrow(i);
        row.add(row2);
      } else {
        var row2 = otherrow(0);
        row.add(row2);
      }
      i = i + 1;
    }

    return row;
  }

  List returnBill() {
    int i = 0;
    var row = [];
    while (i < _items.length) {
      if (_quantity[i] > 0) {
        List row2 = [
          '${_items[i]}',
          '${_quantity[i]}',
          '${_price[i]}',
          '${_total[i]}'
        ];
        row.add(row2.join(','));
      }
      i++;
    }
    if (_otherquantity > 0) {
      List row3 = ['Others', '$_otherquantity', '$_otherprice', '$_othertotal'];
      row.add(row3.join(','));
    }
    return row;
  }

  Future changeOtherItemFunction(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Material(
            type: MaterialType.transparency,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.grey[100],
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 160,
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                          key: _formKey1,
                          child: ListView(
                            physics: const ScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Other Item Price'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Price is Required';
                                  }
                                  if (value.length > 4 || value.contains('-')) {
                                    return 'Price should between 0 to 9999';
                                  }
                                  if (value.contains(',') ||
                                      value.contains('.')) {
                                    return "Price should not contain '.' or ','";
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _otherprice = int.parse(value!);
                                  setState(() {
                                    _otherprice = int.parse(value);
                                    _othertotal = _otherprice * _otherquantity;
                                    sum();
                                  });
                                },
                              ),
                            ],
                          )),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFF9000))),
                        // Colors.orange[600])),
                        onPressed: () {
                          if (!_formKey1.currentState!.validate()) {
                            return;
                          }
                          _formKey1.currentState!.save();
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Change Other Item Price',
                              style: TextStyle(fontSize: 18)),
                        )),
                    const SizedBox(height: 10)
                  ],
                )),
          ));
        });
  }

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
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      updateListView();
      int i = 0;
      while (i < count) {
        _items.add(noteList[i].itemName);
        _quantity.add(0);
        _price.add(noteList[i].itemPrice);
        _total.add(0);
        _increase.add(noteList[i].itemStep);
        i = i + 1;
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: const Text('Add New Bill'),
          backgroundColor: Colors.orange[600]),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: getImage(currentuser!.uid),
                      title: Text(
                        currentuser!.photoURL ?? "Shop Name",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        formatted,
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      trailing: RichText(
                        text: TextSpan(
                            text: '\u{20B9} ',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            children: [
                              TextSpan(
                                text: '$_sum',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]),
                      ),
                    )),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                              textCapitalization: TextCapitalization.sentences,
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
                        ],
                      )),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                      },
                      children: billTable(),
                    ),
                  ),
                ),
                const SizedBox(height: 100)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blueGrey[400],
                    child: TextButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          bool hasInternet =
                              await InternetConnectionChecker().hasConnection;
                          if (hasInternet == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('No Internet Connection',
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center)));
                            return;
                          }
                          setState(() {
                            _bill = returnBill();
                          });

                          int finalAmount = int.parse(widget.money);
                          await updateUser(finalAmount.toString());

                          final DateTime now = DateTime.now();
                          final DateFormat formatter =
                              DateFormat('dd-MM-yyyy ').add_jm();
                          final DateFormat formatter1 =
                              DateFormat('dd-MM-yyyy ');
                          final String formatted = formatter.format(now);
                          final String formattedDate = formatter1.format(now);

                          var newBIll = _bill.join("*");
                          var result = await helper.insertNote(Note(
                              widget.shopName,
                              currentuser!.uid,
                              widget.customerName,
                              widget.customerId,
                              newBIll,
                              _desc,
                              '$_sum',
                              'paid',
                              formattedDate,
                              formatted));

                          if (result != 0) {
                            await helper.insertActivity(Activity(
                                currentuser!.uid,
                                "You record a Bill of \u{20B9} $_sum in ${widget.customerName}'s Account",
                                'paid',
                                formatted));
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SuccessBill(method: 'record')));
                            Navigator.pop(context, 'true');
                          } else {}
                        },
                        child: const Text(
                          'Record a Bill',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.green[400],
                    child: TextButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          bool hasInternet =
                              await InternetConnectionChecker().hasConnection;
                          if (hasInternet == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('No Internet Connection',
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center)));
                            return;
                          }
                          setState(() {
                            _bill = returnBill();
                          });

                          int finalAmount = int.parse(widget.money);
                          finalAmount = finalAmount + _sum;
                          await updateUser(finalAmount.toString());

                          final DateTime now = DateTime.now();
                          final DateFormat formatter =
                              DateFormat('dd-MM-yyyy ').add_jm();
                          final DateFormat formatter1 =
                              DateFormat('dd-MM-yyyy ');
                          final String formatted = formatter.format(now);
                          final String formattedDate = formatter1.format(now);

                          String msg =
                              "${widget.shopName} post a Bill of \u{20B9} $_sum in your Account";
                          String ownerEmail = currentuser!.email ?? '';

                          sendEmail(
                              msgInfo: "New Bill Posted",
                              customerEmail: widget.customerEmail,
                              customerName: widget.customerName,
                              desc: _desc,
                              msg: msg,
                              ownerEmail: ownerEmail,
                              amount: finalAmount.toString(),
                              date: formatted);

                          var newBIll = _bill.join("*");
                          var result = await helper.insertNote(Note(
                              widget.shopName,
                              currentuser!.uid,
                              widget.customerName,
                              widget.customerId,
                              newBIll,
                              _desc,
                              '$_sum',
                              'borrow',
                              formattedDate,
                              formatted));

                          if (result != 0) {
                            await helper.insertActivity(Activity(
                                currentuser!.uid,
                                "You post a Bill of \u{20B9} $_sum in ${widget.customerName}'s Account",
                                'save',
                                formatted));
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SuccessBill(method: 'post')));
                            Navigator.pop(context, 'true');
                          } else {}
                        },
                        child: const Text(
                          'Post a Bill',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
