import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:settings_ui/settings_ui.dart';

class SettingsClass extends StatefulWidget {
  const SettingsClass({Key? key}) : super(key: key);

  @override
  _SettingsClassState createState() => _SettingsClassState();
}

class _SettingsClassState extends State<SettingsClass> {
  late Future<String?> value1;
  // String value1 = "";
  late Future<String?> value2;
  late Future<String?> value3;
  late Future<String?> value4;
  late Future<String?> value5;

  bool val1 = true;
  bool val2 = true;
  bool val3 = true;
  bool val4 = true;
  bool val5 = true;

  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    value1 = storage.read(key: "sendemail");
    value2 = storage.read(key: "usesigbill");
    value3 = storage.read(key: "useqrbill");
    value4 = storage.read(key: "usesigmonth");
    value5 = storage.read(key: "useqrmonth");
    // print(value1);
    // print(value2);
    // print(value3);
    // print(value4);
    // print(value5);
  }

  bool takeValue(Future<String?> s) {
    // print(s);
    // ignore: unrelated_type_equality_checks
    if (s == "1") {
      return true;
    } else {
      return false;
    }
  }

  bool takeValue1(String s) {
    if (s == "1") {
      return true;
    } else {
      return false;
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       titleSpacing: 0,
  //       title: const Text('Settings'),
  //       backgroundColor: Colors.orange[600],
  //     ),
  //     body: SettingsList(
  //       sections: [
  //         SettingsSection(
  //           // title: 'Section',
  //           tiles: [
  //             // SettingsTile(
  //             //   title: 'Language',
  //             //   subtitle: 'English',
  //             //   leading: Icon(Icons.language),
  //             //   onPressed: (BuildContext context) {},
  //             // ),
  //             SettingsTile.switchTile(
  //               title: 'Send E-mail after Bill',
  //               // leading: Icon(Icons.fingerprint),
  //               switchValue: val1,
  //               onToggle: (bool value) {
  //                 setState(() {
  //                   val1 = value;
  //                 });
  //               },
  //             ),
  //             SettingsTile.switchTile(
  //               title: 'Use Signature on Bill Pdf',
  //               // leading: Icon(Icons.fingerprint),
  //               switchValue: val1,
  //               onToggle: (bool value) {},
  //             ),
  //             SettingsTile.switchTile(
  //               title: 'Use QRCode on Bill pdf',
  //               // leading: Icon(Icons.fingerprint),
  //               switchValue: val1,
  //               onToggle: (bool value) {},
  //             ),
  //             SettingsTile.switchTile(
  //               title: 'Use Signature on Monthy Statement',
  //               // leading: Icon(Icons.fingerprint),
  //               switchValue: val1,
  //               onToggle: (bool value) {},
  //             ),
  //             SettingsTile.switchTile(
  //               title: 'Use QRCode on Monthy Statement',
  //               // leading: Icon(Icons.fingerprint),
  //               switchValue: val1,
  //               onToggle: (bool value) {},
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: const Text('Settings'),
          backgroundColor: Colors.orange[600],
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Send E-mail after Bill',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Colors.blue,
                            trackColor: Colors.grey,
                            // value: val1,
                            value: takeValue(value1),
                            onChanged: (bool newValue) {
                              setState(() {
                                // print(newValue);
                                val1 = newValue;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            child: Text(
                          'Use Signature on Bill Pdf',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Colors.blue,
                            trackColor: Colors.grey,
                            value: takeValue(value2),
                            onChanged: (bool newValue) {
                              setState(() {
                                // print(newValue);
                                val2 = newValue;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            child: Text(
                          'Use QRCode on Bill pdf',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Colors.blue,
                            trackColor: Colors.grey,
                            value: takeValue(value3),
                            onChanged: (bool newValue) {
                              setState(() {
                                // print(newValue);
                                val3 = newValue;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            child: Text(
                          'Use Signature on Monthly Statement',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Colors.blue,
                            trackColor: Colors.grey,
                            value: takeValue(value4),
                            onChanged: (bool newValue) {
                              setState(() {
                                // print(newValue);
                                val4 = newValue;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            child: Text(
                          'Use QRCode on Monthy Statement',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Colors.blue,
                            trackColor: Colors.grey,
                            value: takeValue(value5),
                            onChanged: (bool newValue) {
                              setState(() {
                                // print(newValue);
                                val5 = newValue;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ])));
  }
}
