import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String content = "";
  CollectionReference feedback =
      FirebaseFirestore.instance.collection('feedback');
  final currentuser = FirebaseAuth.instance.currentUser;

  bool _inProcess = false;
  Future<void> addFeedback() {
    _inProcess = true;
    return feedback.add({
      'shopName': currentuser!.photoURL,
      'name': currentuser!.displayName,
      'feedback': content
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Thank you for your Feedback')));
      _inProcess = false;
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red, content: Text('Please try again')));
      _inProcess = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _inProcess = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.orange[600],
        title: const Text('Feedback'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Please give your valuable Feedback ",
                    style: TextStyle(fontSize: 18),
                  )),
              Expanded(
                  child: ListView(padding: const EdgeInsets.all(15), children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    maxLines: 5,
                    minLines: 1,
                    decoration: const InputDecoration(
                        labelText: 'Feedback', border: OutlineInputBorder()),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Feedback should not be Empty';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      content = value!;
                    },
                  ),
                )
              ])),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFF9000)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Post Your Feedback',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _formKey.currentState!.save();
                    addFeedback();
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
        ],
      ),
    );
  }
}
