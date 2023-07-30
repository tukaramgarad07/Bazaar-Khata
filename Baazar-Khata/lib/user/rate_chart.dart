import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_bazaar_khata/models/note.dart';
import 'package:new_bazaar_khata/util/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class RateChart extends StatefulWidget {
  final String id;
  const RateChart({Key? key, required this.id}) : super(key: key);

  @override
  _RateChartState createState() => _RateChartState();
}

class _RateChartState extends State<RateChart> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final currentuser = FirebaseAuth.instance.currentUser;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Items> noteList = [];
  int count = 0;

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Items>> noteListFuture =
          databaseHelper.getItemsList(currentuser!.uid);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }

  Future showAddItemFunction(context) {
    var _shopId = currentuser!.uid;
    // ignore: prefer_typing_uninitialized_variables
    var _itemName;
    // ignore: prefer_typing_uninitialized_variables
    var _itemStep;
    // ignore: prefer_typing_uninitialized_variables
    var _itemQuanity;
    // ignore: prefer_typing_uninitialized_variables
    var _itemPrice;

    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Material(
            type: MaterialType.transparency,
            child: Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.grey[100],
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                          key: _formKey,
                          child: ListView(
                            physics: const ScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            children: [
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: 'Item Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Name is Required';
                                  }
                                  if (value.length >= 30) {
                                    return 'Item Name should be less than 30';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _itemName = value;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Lowest Item Quantity'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Increase Quantity is Required';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _itemQuanity = value;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Item Increase Quantity'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Increase Quantity is Required';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _itemStep = value;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Item Price'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Price is Required';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _itemPrice = value;
                                },
                              ),
                              const SizedBox(height: 100),
                            ],
                          )),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFB8C00))),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          await databaseHelper.insertItems(Items(
                              _shopId,
                              '$_itemName',
                              _itemQuanity,
                              _itemStep,
                              _itemPrice));

                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Text('Add Item', style: TextStyle(fontSize: 18)),
                        )),
                    const SizedBox(height: 10)
                  ],
                )),
          ));
        });
  }

  Future showUpdateItemFunction(context, itemId, name, quantity, step, price) {
    var _itemId = itemId;
    var _itemName = name;
    var _itemIncreseQuanity = step;
    var _itemlowestQuanity = quantity;
    var _itemPrice = price;
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Material(
            type: MaterialType.transparency,
            child: Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.grey[100],
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 400,
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
                                initialValue: '$name',
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: 'Item Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Name is Required';
                                  }
                                  if (value.length >= 30) {
                                    return 'Item Name should be less than 30 alphabet';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _itemName = value;
                                  setState(() {
                                    _itemName = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                initialValue: '$quantity',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Lowest Item Quantity'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Increase Quantity is Required';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _itemlowestQuanity = int.parse(value!);
                                  setState(() {
                                    _itemlowestQuanity = int.parse(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                initialValue: '$step',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Item Increase Quantity'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Increase Quantity is Required';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _itemIncreseQuanity = int.parse(value!);
                                  setState(() {
                                    _itemIncreseQuanity = int.parse(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                initialValue: '$price',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Item Price'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Item Price is Required';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  _itemPrice = int.parse(value!);
                                  setState(() {
                                    _itemPrice = int.parse(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 100),
                            ],
                          )),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFB8C00))),
                        onPressed: () async {
                          if (!_formKey1.currentState!.validate()) {
                            return;
                          }
                          _formKey1.currentState!.save();
                          await databaseHelper.updateItems(
                              _itemName,
                              _itemlowestQuanity,
                              _itemIncreseQuanity,
                              _itemPrice,
                              _itemId);
                          updateListView();
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Update Item',
                              style: TextStyle(fontSize: 18)),
                        )),
                    const SizedBox(height: 10)
                  ],
                )),
          ));
        });
  }

  Future deleteItemFunction(context, itemId) async {
    await databaseHelper.deleteItems(itemId);
  }

  Widget _rateGeneration(context) {
    if (count == 0) {
      return const Center(
        child: Text('No Items'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 65),
      itemCount: count,
      itemBuilder: (buildcontext, position) => Card(
          shadowColor: Colors.orange[600],
          color: Colors.grey[100],
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        '${noteList[position].itemName} (\u{20B9} ${noteList[position].itemPrice})',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        icon:
                            Icon(Icons.edit, color: Colors.blue[400], size: 28),
                        onPressed: () {
                          showUpdateItemFunction(
                              context,
                              noteList[position].itemId,
                              noteList[position].itemName,
                              noteList[position].itemQuantity,
                              noteList[position].itemStep,
                              noteList[position].itemPrice);
                          updateListView();
                        }),
                    IconButton(
                        tooltip: 'Delete a Bill',
                        icon: Icon(Icons.delete,
                            color: Colors.red[400], size: 28),
                        onPressed: () {
                          deleteItemFunction(
                              context, noteList[position].itemId);
                          updateListView();
                        }),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  bool refresh = true;

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty && refresh) {
      noteList = [];
      refresh = false;
      updateListView();
    }

    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.orange[600],
          title: const Text('Rate Chart'),
        ),
        body: _rateGeneration(context),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.orange[600],
          onPressed: () async {
            await showAddItemFunction(context);
            updateListView();
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Item'),
        ));
  }
}
