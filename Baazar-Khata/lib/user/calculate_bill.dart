import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_bazaar_khata/models/note.dart';
import 'package:new_bazaar_khata/util/database_helper.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';
import 'package:sqflite/sqflite.dart';

class CalculateBill extends StatefulWidget {
  const CalculateBill({Key? key}) : super(key: key);

  @override
  _CalculateBillState createState() => _CalculateBillState();
}

class _CalculateBillState extends State<CalculateBill> {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  DatabaseHelper helper = DatabaseHelper();
  final currentuser = FirebaseAuth.instance.currentUser;
  List<Items> noteList = [];
  int count = 0;

  var _otherquantity = 0;
  var _otherprice = 1;
  var _othertotal = 0;
  var _sum = 0;
  final _items = [];
  final _quantity = [];
  final _price = [];
  final _increase = [];
  final _total = [];

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Items>> noteListFuture =
          helper.getItemsList(currentuser!.uid);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }

  Widget buildDataTable() {
    final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
    return Form(
      key: _formKey1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: DataTable(
            showBottomBorder: true,
            columns: const [
              DataColumn(label: Text('Items')),
              DataColumn(label: Text('Quantity')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Total')),
            ],
            rows: [
              DataRow(selected: true, cells: [
                DataCell(Text(_items[0])),
                DataCell(
                  Row(children: [
                    InkWell(
                        child: Icon(CupertinoIcons.minus_square_fill,
                            color: Colors.red[400], size: 28),
                        onTap: () {
                          setState(() {
                            if (_quantity[0] > 0) {
                              _quantity[0] = _quantity[0] - 1;
                              _total[0] = _quantity[0] * _price[0];
                              sum();
                            }
                          });
                        }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                          child: TextFormField(
                            initialValue: _quantity[0].toString(),
                            readOnly: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                          width: 40),
                    ),
                    InkWell(
                      child: const Icon(Icons.add_box,
                          color: Colors.green, size: 28),
                      onTap: () {
                        setState(() {
                          if (_quantity[0] < 1000) {
                            _quantity[0] = _quantity[0] + 1;
                            _total[0] = _quantity[0] * _price[0];
                            sum();
                          }
                        });
                      },
                    ),
                  ]),
                ),
                DataCell(Text('${_price[0]}')),
                DataCell(Text('${_total[0]}')),
              ]),
              DataRow(selected: true, cells: [
                DataCell(Text(_items[1])),
                DataCell(
                  Row(children: [
                    InkWell(
                        child: Icon(CupertinoIcons.minus_square_fill,
                            color: Colors.red[400], size: 28),
                        onTap: () {
                          setState(() {
                            if (_quantity[1] > 0) {
                              _quantity[1] = _quantity[1] - 1;
                              _total[1] = _quantity[1] * _price[1];
                              sum();
                            }
                          });
                        }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                          child: TextFormField(
                            initialValue: _quantity[1].toString(),
                            readOnly: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                          width: 40),
                    ),
                    InkWell(
                      child: const Icon(Icons.add_box,
                          color: Colors.green, size: 28),
                      onTap: () {
                        setState(() {
                          if (_quantity[1] < 1000) {
                            _quantity[1] = _quantity[1] + 1;
                            _total[1] = _quantity[1] * _price[1];
                            sum();
                          }
                        });
                      },
                    ),
                  ]),
                ),
                DataCell(Text('${_price[1]}')),
                DataCell(Text('${_total[1]}')),
              ]),
              DataRow(selected: true, cells: [
                DataCell(Text(_items[2])),
                DataCell(
                  Row(children: [
                    InkWell(
                        child: Icon(CupertinoIcons.minus_square_fill,
                            color: Colors.red[400], size: 28),
                        onTap: () {
                          setState(() {
                            if (_quantity[2] > 0) {
                              _quantity[2] = _quantity[2] - 1;
                              _total[2] = _quantity[2] * _price[2];
                              sum();
                            }
                          });
                        }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                          child: TextFormField(
                            initialValue: _quantity[2].toString(),
                            readOnly: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                          width: 40),
                    ),
                    InkWell(
                      child: const Icon(Icons.add_box,
                          color: Colors.green, size: 28),
                      onTap: () {
                        setState(() {
                          if (_quantity[2] < 1000) {
                            _quantity[2] = _quantity[2] + 1;
                            _total[2] = _quantity[2] * _price[2];
                            sum();
                          }
                        });
                      },
                    ),
                  ]),
                ),
                DataCell(Text('${_price[2]}')),
                DataCell(Text('${_total[2]}')),
              ]),
            ],
          ),
        ),
      ),
    );
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

  TableRow billrow(var i) {
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
                        _quantity[i] = _quantity[i] - 1;
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
                      _quantity[i] = _quantity[i] + 1;
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

  TableRow otherrow(var i) {
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
        var row2 = {
          'Items': _items[i],
          'Quantity': _quantity[i],
          'Prize': _price[i],
          'Total': _total[i]
        };
        row.add(row2);
      }
      i++;
    }
    if (_otherquantity > 0) {
      var row3 = {
        'Items': 'Others',
        'Quantity': _otherquantity,
        'Prize': _otherprice,
        'Total': _othertotal
      };
      row.add(row3);
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
                        // style: ButtonStyle(
                        //     backgroundColor: MaterialStateProperty.all<Color>(
                        //         Colors.orange[600])),
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

  // ignore: avoid_init_to_null
  var imagefromPref = null;

  loadImage(key) async {
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
        appBar: AppBar(
          titleSpacing: 0,
          title: const Text('Calculate Bill'),
          backgroundColor: Colors.orange[600],
        ),
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
                          currentuser!.displayName ?? 'Shop Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 19),
                        ),
                        subtitle: Text(
                          currentuser!.photoURL ?? 'Shop Owner Name',
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                        // trailing: IconButton(
                        //     onPressed: () {},
                        //     tooltip: 'Share a Bill',
                        //     icon:
                        //         Icon(Icons.share, color: Colors.blueGrey[400])),
                      )),
                  const SizedBox(height: 10),
                  Container(
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
                ],
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.green[400],
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Bill Amount   =   \u{20B9} $_sum',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 0)
          ],
        ));
  }
}
