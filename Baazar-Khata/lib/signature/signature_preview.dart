import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List signature;

  const SignaturePreviewPage({Key? key, required this.signature})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.orange[600],
          leading: const CloseButton(),
          title: const Text('Save Signature'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () => storeSignature(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: Image.memory(signature, width: double.infinity),
        ),
      );

  Future storeSignature(BuildContext context) async {
    final currentuser = FirebaseAuth.instance.currentUser;

    final result = await Utility.saveImageToPreferences(
        "OwnerSignature${currentuser!.uid}", Utility.base64String(signature));

    // ignore: unnecessary_null_comparison
    if (result != null) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green, content: Text('Signature Saved')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Failed to save signature')));
    }
  }
}
