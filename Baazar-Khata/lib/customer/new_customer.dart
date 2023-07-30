import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

class NewCustomer extends StatefulWidget {
  final String id;
  const NewCustomer({Key? key, required this.id}) : super(key: key);
  @override
  _NewCustomerState createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  late String _name;
  late String _desc;
  late String _email;
  late String _phone;
  final String _money = '0';
  final currentuser = FirebaseAuth.instance.currentUser;

  int colorGroupValue = 0;
  bool _inProcess = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  Widget _buildName() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Customer Name',
          border: OutlineInputBorder()),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }
        if (value.length > 20) {
          return 'Name should be less than 20 alphabet';
        }
        return null;
      },
      onSaved: (String? value) {
        _name = value!;
      },
    );
  }

  Widget _buildDesc() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.description),
          labelText: 'Description',
          border: OutlineInputBorder()),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Description is Required';
        }
        if (value.length > 30) {
          return 'Description should less than 30 alphabet';
        }
        return null;
      },
      onSaved: (String? value) {
        _desc = value!;
      },
    );
  }

  Widget _gender() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Radio(
                  value: 0,
                  groupValue: colorGroupValue,
                  onChanged: (int? val) {
                    colorGroupValue = val!;
                    setState(() {
                      colorGroupValue = val;
                    });
                  }),
              const Text('Male', style: TextStyle(fontSize: 18)),
            ],
          ),
          Row(
            children: [
              Radio(
                  value: 1,
                  groupValue: colorGroupValue,
                  onChanged: (int? val) {
                    colorGroupValue = val!;
                    setState(() {
                      colorGroupValue = val;
                    });
                  }),
              const Text('Female', style: TextStyle(fontSize: 18))
            ],
          ),
          Row(
            children: [
              Radio(
                  value: 2,
                  groupValue: colorGroupValue,
                  onChanged: (int? val) {
                    colorGroupValue = val!;
                    setState(() {
                      colorGroupValue = val;
                    });
                  }),
              const Text('Other', style: TextStyle(fontSize: 18))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: 'Email',
          border: OutlineInputBorder()),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Email is Required';
        } else if (!RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(value)) {
          return 'Please Enter Valid Email Address';
        }
        return null;
      },
      onSaved: (String? value) {
        _email = value!;
      },
    );
  }

  Widget _buildPhone() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      //maxLength: 10,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.phone),
          labelText: 'Mobile No',
          border: OutlineInputBorder()),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Mobile No is Required';
        }
        if (value.length != 10) {
          return 'Please Enter Valid Mobile No';
        }
        return null;
      },
      onSaved: (String? value) {
        _phone = value!;
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  CollectionReference customer =
      FirebaseFirestore.instance.collection('customers');

  Future<void> addUser() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy ').add_jm();
    final String formatted = formatter.format(now);

    setState(() {
      _inProcess = true;
    });
    // _inProcess = true;
    return customer.add({
      'owner': currentuser!.uid,
      'name': _name,
      'desc': _desc,
      'email': _email,
      'phone': _phone,
      'price': _money,
      'gender': colorGroupValue,
      'lastbill': formatted,
      'lastSeen': now
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Customer Added Successfully')));
      _inProcess = false;
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to Add New Customer')));
      _inProcess = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text('Add New Customer'),
          titleSpacing: 0,
          backgroundColor: Colors.orange[600]),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white70),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    children: [
                      const SizedBox(height: 5),
                      _buildName(),
                      const SizedBox(height: 20),
                      _buildDesc(),
                      const SizedBox(height: 20),
                      _buildEmail(),
                      const SizedBox(height: 20),
                      _buildPhone(),
                      _gender(),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFFB8C00)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Add New Customer',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();
                  
                  bool hasInternet =
                      await InternetConnectionChecker().hasConnection;
                  if (hasInternet == false) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('No Internet Connection',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center)));
                    return;
                  }
                  await addUser();
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ),
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
      ]),
    );
  }
}
