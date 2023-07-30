import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';

class EditCustomer extends StatefulWidget {
  final String id;
  final String name;
  final int gender;
  final String desc;
  final String email;
  final String phone;
  const EditCustomer(
      {Key? key,
      required this.id,
      required this.name,
      required this.gender,
      required this.desc,
      required this.email,
      required this.phone})
      : super(key: key);
  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  late String _name;
  late String _desc;
  late String _email;
  late String _phone;

  int colorGroupValue = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  File? _selectedFile;
  bool _inProcess = false;
  final _picker = ImagePicker();

  DecorationImage? imagefromPref;
  // ignore: prefer_typing_uninitialized_variables
  var image;

  loadImage(key) async {
    Utility.getImageFromPreferences(key).then((value) {
      if (null == value) {
        return;
      }
      setState(() {
        imagefromPref = Utility.imageFromBase64StringCustomer(value);
      });
    });
  }

  getImageWidget(gender) {
    if (_selectedFile != null) {
      return DecorationImage(
        image: FileImage(_selectedFile!),
      );
    } else if (gender == 0) {
      return const DecorationImage(
        image: AssetImage('images/maleAvatar.jpg'),
      );
    } else if (gender == 1) {
      return const DecorationImage(
        image: AssetImage('images/femaleavatar (2).jpg'),
      );
    } else {
      return const DecorationImage(
        image: AssetImage('images/avatar.png'),
      );
    }
  }

  getImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });
    image = await _picker.pickImage(
        source: source, maxHeight: 2000, maxWidth: 2000, imageQuality: 100);
    if (image != null) {
      File? cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 50,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.white,
              toolbarTitle: "Bazaar Khata",
              statusBarColor: Colors.orange[600],
              backgroundColor: Colors.grey[300]));

      setState(() {
        _selectedFile = cropped!;
        String id1 = widget.id;
        Utility.saveImageToPreferences(
            id1, Utility.base64String(_selectedFile!.readAsBytesSync()));
        _inProcess = false;
        imagefromPref = null;
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  Widget _buildName(String name) {
    return TextFormField(
      initialValue: name,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Name'),
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

  Widget _buildDesc(String desc) {
    return TextFormField(
      initialValue: desc,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(labelText: 'Description'),
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

  Widget _gender(gender) {
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

  Widget _buildEmail(email) {
    return TextFormField(
      initialValue: email,
      decoration: const InputDecoration(labelText: 'Email'),
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

  Widget _buildPhone(phone) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: phone,
      decoration: const InputDecoration(labelText: 'Mobile No'),
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

  Widget _camera(gender) {
    return Container(
        padding: const EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              children: [
                null == imagefromPref
                    ? Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: getImageWidget(gender),
                        ),
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: imagefromPref,
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
            Positioned(
              top: 150,
              left: 130,
              child: FloatingActionButton(
                elevation: 0,
                child: const Icon(Icons.photo_camera),
                backgroundColor: Colors.green[300],
                onPressed: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (context) {
                        return buildSheet();
                      });
                },
              ),
            )
          ],
        ));
  }

  Widget buildSheet() {
    // ignore: avoid_unnecessary_containers
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ])),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Row(children: const [
                  Icon(Icons.camera, color: Colors.pink, size: 30),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text('Camera',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                ]),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              InkWell(
                child: Row(children: const [
                  Icon(Icons.folder, color: Colors.pink, size: 30),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text('Gallery',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                ]),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (imagefromPref == null) {
      loadImage(widget.id);
    }
    colorGroupValue = widget.gender;
  }

  CollectionReference customer =
      FirebaseFirestore.instance.collection('customers');

  Future<void> updateUser() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy ').add_jm();
    final String formatted = formatter.format(now);
    setState(() {
      _inProcess = true;
    });
    return customer.doc(widget.id).update({
      'name': _name,
      'desc': _desc,
      'email': _email,
      'phone': _phone,
      'gender': colorGroupValue,
      'lastbill': formatted,
      'lastSeen': now
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Customer Details Update Successfully')));
      setState(() {
        _inProcess = false;
      });
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to Update Customer Details')));
      setState(() {
        _inProcess = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          titleSpacing: 0,
          title: const Text('Edit Customer Details'),
          backgroundColor: Colors.orange[600]),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white70),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    children: [
                      _camera(widget.gender),
                      const SizedBox(height: 5),
                      _buildName(widget.name),
                      const SizedBox(height: 5),
                      _buildDesc(widget.desc),
                      const SizedBox(height: 5),
                      _buildEmail(widget.email),
                      const SizedBox(height: 5),
                      _buildPhone(widget.phone),
                      const SizedBox(height: 5),
                      _gender(widget.gender),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFF9000)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Edit Customer Details',
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
                    setState(() {
                      _inProcess = true;
                    });
                    //loadImage();
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
                    updateUser();
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Edit Customer Details'),
    //     backgroundColor: Colors.orange[600],
    //   ),
    //   body: const Center(child: CircularProgressIndicator()),
    // );
  }
}

/*
Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: customer.doc(widget.id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  title: const Text('Edit Customer Details'),
                  backgroundColor: Colors.orange[600]),
              body: Stack(children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.white70),
                  child: Column(
                    children: [
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            children: [
                              _camera(data["gender"]),
                              const SizedBox(height: 5),
                              _buildName(data["name"]),
                              const SizedBox(height: 5),
                              _buildDesc(data["desc"]),
                              const SizedBox(height: 5),
                              _buildEmail(data["email"]),
                              const SizedBox(height: 5),
                              _buildPhone(data["phone"]),
                              const SizedBox(height: 5),
                              _gender(data["gender"]),
                              const SizedBox(height: 150),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFF9000)),
                            // Colors.orange[600]),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Edit Customer Details',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState!.save();
                            setState(() {
                              _inProcess = true;
                            });
                            //loadImage();
                            updateUser();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
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
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Customer Details'),
              backgroundColor: Colors.orange[600],
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        });
  }
*/