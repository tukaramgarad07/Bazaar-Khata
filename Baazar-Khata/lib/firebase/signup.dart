import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_bazaar_khata/firebase/login.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  bool hasInternet = false;
  late String _email;
  late String _pass;
  late String _cpass;
  // ignore: prefer_final_fields
  bool _inProcess = false;
  // ignore: non_constant_identifier_names
  bool _OTP = false;
  int otpCheck = 1;
  int enterOtp = 0;
  Random random = Random();

  CollectionReference user = FirebaseFirestore.instance.collection('owners');
  Future registration(context) async {
    if (_pass == _cpass) {
      hasInternet = await InternetConnectionChecker().hasConnection;
      setState(() {
        _inProcess = true;
      });
      if (hasInternet) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: _email, password: _pass);

          user
              .add({
                'owner': userCredential.user!.uid.toString(),
                'email': false,
                'sigBill': false,
                'qrBill': false,
                'sigMon': false,
                'qrMon': false
              })
              .then((value) {})
              .catchError((error) {});

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registraion Successful')));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        } on FirebaseAuthException catch (e) {
          setState(() {
            _inProcess = false;
          });
          if (e.code == 'weak-password') {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('WeakPassword')));
          }
          if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email id already Exist')));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet connection')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400],
          content: const Text('Password and Confirm password doesnot match')));
      return;
    }
  }

  Future sendEmail({required int otp}) async {
    const serviceId = 'service_nohnjrh';
    const templateId = 'template_2bhax9m';
    const userId = 'user_pfn6cH7dYs8TcXy8ldYIB';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    // ignore: unused_local_variable
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {'OTP': otp, 'to_user': _email}
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25),
            child: ListView(
              padding: const EdgeInsets.only(
                  top: 85, left: 10, bottom: 10, right: 10),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Bazaar Khata',
                            style: TextStyle(
                                color: Colors.orange[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
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
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is Required';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            _pass = value!;
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Confirm Password',
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is Required';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            _cpass = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      // style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.all<Color>(
                      //         Colors.orange[600])),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        bool hasInternet =
                            await InternetConnectionChecker().hasConnection;
                        if (hasInternet == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('No Internet Connection',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center)));
                          return;
                        }
                        int otp = random.nextInt(900000) + 100000;
                        sendEmail(otp: otp);
                        setState(() {
                          _OTP = true;
                          otpCheck = otp;
                        });
                      },
                    )),
                // ignore: avoid_unnecessary_containers
                Container(
                    child: Row(
                  children: <Widget>[
                    const Text('Already have an Account   '),
                    TextButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const Login()));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
              ],
            ),
          ),
          (_OTP)
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                      children: [
                        Form(
                          key: _formKey1,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                // border: OutlineInputBorder(),
                                labelText: 'Enter OTP',
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'OTP is Required';
                                } else if (value.length != 6) {
                                  return 'Please Enter valid 6 digit OTP';
                                } else if (otpCheck != int.parse(value)) {
                                  return 'Incorrect OTP';
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                enterOtp = int.parse(value!);
                              },
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: const Text(
                                'Resend OTP',
                                // style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                bool hasInternet =
                                    await InternetConnectionChecker()
                                        .hasConnection;
                                if (hasInternet == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              'No Internet Connection',
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center)));
                                  return;
                                }
                                int otp = random.nextInt(900000) + 100000;
                                sendEmail(otp: otp);
                                setState(() {
                                  _OTP = true;
                                  otpCheck = otp;
                                });
                              },
                            )),
                        const SizedBox(height: 20),
                        SizedBox(
                            height: 50,
                            // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                if (!_formKey1.currentState!.validate()) {
                                  return;
                                }
                                _formKey1.currentState!.save();
                                bool hasInternet =
                                    await InternetConnectionChecker()
                                    
                                        .hasConnection;
                                if (hasInternet == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              'No Internet Connection',
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center)));
                                  return;
                                }
                                registration(context);
                              },
                            )),
                      ],
                    ),
                  ),
                )
              : const Center(),
          (_inProcess)
              ? Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  height: MediaQuery.of(context).size.height * 0.95,
                )
              : const Center(),
        ],
      ),
    );
  }
}
