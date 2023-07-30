import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_bazaar_khata/signature/signature.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';

class HomeSignature extends StatefulWidget {
  const HomeSignature({Key? key}) : super(key: key);

  @override
  _HomeSignatureState createState() => _HomeSignatureState();
}

class _HomeSignatureState extends State<HomeSignature> {
  // ignore: avoid_init_to_null
  var imagefromPref = null;
  final storage = const FlutterSecureStorage();
  final currentuser = FirebaseAuth.instance.currentUser;

  Future loadImage(key) async {
    Utility.getImageFromPreferences(key).then((value) {
      // ignore: unnecessary_null_comparison
      if (null == value) {
        return;
      }
      setState(() {
        imagefromPref = Utility.imageFromBase64String(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (imagefromPref == null) {
      loadImage("OwnerSignature${currentuser!.uid}");
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.orange[600],
        title: const Text('Signature Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ignore: prefer_if_null_operators
                  null == imagefromPref
                      ? Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset('images/NoSignature.png'),
                        )
                      : imagefromPref,
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red[400],
                    child: TextButton(
                        onPressed: () async {
                          await Utility.RemoveImageToPreferences(
                              "OwnerSignature${currentuser!.uid}");
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content:
                                      Text('Signature Removed Successfully')));
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Remove Signature',
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignaturePage()));
                        },
                        child: const Text(
                          'Change Signature',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
