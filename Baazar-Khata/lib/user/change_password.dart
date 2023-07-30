import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeUserPassword extends StatefulWidget {
  const ChangeUserPassword({Key? key}) : super(key: key);

  @override
  ChangeUserPasswordState createState() => ChangeUserPasswordState();
}

class ChangeUserPasswordState extends State<ChangeUserPassword> {
  // ignore: prefer_typing_uninitialized_variables
  var _oldPassword;
  // ignore: prefer_typing_uninitialized_variables
  var _newPassword;
  // ignore: prefer_typing_uninitialized_variables
  var _reNewPassword;
  bool _inProcess = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final currentUser = FirebaseAuth.instance.currentUser;
  
  // Future<bool> validatePassword(String email, String password) async {
  //   AuthCredential authCrendentials =
  //       EmailAuthProvider.credential(email: email, password: password);
  //   UserCredential authResult =
  //       await currentUser!.reauthenticateWithCredential(authCrendentials);
  //   return authResult.user == null;
  // }

  Future changePassword(String email) async {
    setState(() {
      _inProcess = true;
    });
    // bool check = false;
    // check = validatePassword(email, _oldPassword) as bool;
    if (_reNewPassword != _newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('New Password and Re-Entered Password should be same')));
    } else if (_oldPassword == _newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Old Password and New Password should be different')));
    }
    // else if (check) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Old Password is incorrect')));
    // }
    else {
      try {
        currentUser!.email;
        await currentUser!.updatePassword(_newPassword);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Password Change Successfully')));
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
    setState(() {
      _inProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.orange[600],
        title: const Text('Change Password'),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(15),
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Old Password',
                            border: OutlineInputBorder()),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Old Password';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _oldPassword = value;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'New Password',
                            border: OutlineInputBorder()),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter New Password';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _newPassword = value;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Re-Enter New Password',
                            border: OutlineInputBorder()),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Re-Enter New Password';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _reNewPassword = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFF9000)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Change Password',
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
                    changePassword(currentUser!.email ?? "");
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
