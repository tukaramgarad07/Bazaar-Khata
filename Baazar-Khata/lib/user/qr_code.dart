import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  String qrCode = "No Qr Code";
  final currentuser = FirebaseAuth.instance.currentUser;

  Future changeQRCodeFunction(context) {
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
                          key: _formKey,
                          child: ListView(
                            physics: const ScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter QRCode Value'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'QRCode is Required';
                                  }
                                  if (value.length > 30) {
                                    return 'Length should be less than 30 alphabet';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) async {
                                  qrCode = value!;
                                  await storage.write(
                                      key: "qrcode${currentuser!.uid}",
                                      value: value);
                                  setState(() {
                                    qrCode = value;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                              'QR Code Update Successfully')));
                                },
                              )
                            ],
                          )),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFFF9000)),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Change QRCode',
                              style: TextStyle(fontSize: 18)),
                        )),
                    const SizedBox(height: 10)
                  ],
                )),
          ));
        });
  }

  Future<bool> checkQrStatus() async {
    String? value = await storage.read(key: "qrcode${currentuser!.uid}");
    if (value == null) {
      return false;
    }
    setState(() {
      qrCode = value;
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    checkQrStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.orange[600],
        title: const Text('QR Code'),
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 30),
            child: QrImage(
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square),
              foregroundColor: Colors.orange[800],
              data: qrCode,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  changeQRCodeFunction(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Edit QR Code',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
