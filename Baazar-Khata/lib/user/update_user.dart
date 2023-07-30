import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  String _name = "";
  String _shopname = "";
  // ignore: unused_field
  String _phone = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final currentUser = FirebaseAuth.instance.currentUser;
  String ownervalue = FirebaseAuth.instance.currentUser!.uid;
  // ignore: prefer_typing_uninitialized_variables
  var _selectedFile;
  bool _inProcess = false;
  final _picker = ImagePicker();

  // ignore: duplicate_ignore
  Widget getImageWidget() {
    // ignore: unnecessary_null_comparison
    if (_selectedFile != null) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: FileImage(_selectedFile),
            )),
      );
    } else {
      return null == imagefromPref
          ? Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('images/shop.jpeg'),
                  )),
            )
          // ignore: sized_box_for_whitespace
          : Container(
              width: 200,
              height: 200,
              child: ClipRRect(
                child: imagefromPref,
                borderRadius: BorderRadius.circular(100),
              ),
            );
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var imagefromPref;

  Future loadImage(key) async {
    Utility.getImageFromPreferences(key).then((value) {
      if (null == value) {
        return;
      }
      setState(() {
        imagefromPref = Utility.imageFromBase64String2(value);
      });
    });
  }

  Future getImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });
    final image = await _picker.pickImage(
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

        Utility.saveImageToPreferences(
            ownervalue, Utility.base64String(_selectedFile.readAsBytesSync()));

        _inProcess = false;
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  Widget _buildName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        initialValue: currentUser!.displayName,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Shop Owner Name',
          border: OutlineInputBorder(),
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Shop Owner Name is Required';
          }
          if (value.length > 20) {
            return 'Shop Owner Name should be less than 20';
          }
          return null;
        },
        onSaved: (String? value) {
          _name = value!;
        },
      ),
    );
  }

  Widget _buildShopName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        initialValue: currentUser!.photoURL,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Shop Name',
          border: OutlineInputBorder(),
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Shop Name is Required';
          }
          if (value.length > 20) {
            return 'Shop Name should be less than 20';
          }
          return null;
        },
        onSaved: (String? value) {
          _shopname = value!;
        },
      ),
    );
  }

  Widget _buildPhone() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Mobile No',
          border: OutlineInputBorder(),
        ),
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
      ),
    );
  }

  Widget _camera() {
    return Container(
        padding: const EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              children: [
                getImageWidget(),
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

  Future<void> updateUser() async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet) {
      setState(() {
        _inProcess = true;
      });
      await currentUser!.updateDisplayName(_name);
      await currentUser!.updatePhotoURL(_shopname);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('User Details Update Successfully')));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('No internet Connection')));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (imagefromPref == null) {
      loadImage(ownervalue);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: const Text('Update Shop Owner Details'),
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
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    children: [
                      _camera(),
                      _buildShopName(),
                      _buildName(),
                      _buildPhone(),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFF9000)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Update Shop Owner Details',
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
}
