import 'package:flutter/material.dart';

class SuccessBill extends StatefulWidget {
  final String method;
  const SuccessBill({Key? key, required this.method}) : super(key: key);

  @override
  _SuccessBillState createState() => _SuccessBillState();
}

class _SuccessBillState extends State<SuccessBill> {
  Widget loadImage() {
    return Image.asset("images/success.gif", scale: 1.0);
  }

  void _evictImage(url) {
    final AssetImage provider = AssetImage(url);
    provider.evict().then<void>((bool success) {});
  }

  @override
  Widget build(BuildContext context) {
    String i = widget.method;
    if (i == 'record') {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                // ignore: sized_box_for_whitespace
                Container(
                  width: 200,
                  child: loadImage(),
                ),
                Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: const Text('Bill Recordeed Successfully !',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600))),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    color: Colors.orange[800],
                    child: TextButton(
                        onPressed: () {
                          _evictImage("images/success.gif");
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                )
              ])),
        ),
      );
    }
    if (i == 'save') {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                // ignore: sized_box_for_whitespace
                Container(width: 200, child: loadImage()),
                Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: const Text('Bill Saved Successfully !',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600))),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    color: Colors.orange[800],
                    child: TextButton(
                        onPressed: () {
                          _evictImage("images/success.gif");
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                )
              ])),
        ),
      );
    }
    if (i == 'post') {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                // ignore: sized_box_for_whitespace
                Container(width: 200, child: loadImage()),
                Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: const Text('Bill Posted Successfully !',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600))),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    color: Colors.orange[800],
                    child: TextButton(
                        onPressed: () {
                          _evictImage("images/success.gif");
                          Navigator.pop(context, 'true');
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                )
              ])),
        ),
      );
    }
    if (i == 'payment') {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                // ignore: sized_box_for_whitespace
                Container(width: 200, child: loadImage()),
                Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: const Text('Payment Recorded Successfully !',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600))),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    color: Colors.orange[800],
                    child: TextButton(
                        onPressed: () {
                          _evictImage("images/success.gif");
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                )
              ])),
        ),
      );
    }
    return Container();
  }
}
