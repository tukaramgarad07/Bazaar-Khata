import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_bazaar_khata/firebase/forgotpass.dart';
import 'package:new_bazaar_khata/firebase/signup.dart';
import 'package:new_bazaar_khata/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late StreamSubscription<User?> _listener;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;

  late String _email;
  bool _true = true;
  late String _pass;
  bool _inProcess = false;

  final storage = const FlutterSecureStorage();
  Future userLogin(context) async {
    setState(() {
      _inProcess = true;
    });
    try {
      UserCredential _user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _pass);
      // print(_user.user.uid);
      // if (_user.user.emailVerified == true) {
      await storage.write(key: "uid", value: _user.user!.uid);
      await storage.write(key: "qrcode${_user.user!.uid}", value: "No Qr Code");
      // await storage.write(key: "sendemail", value: "1");
      // await storage.write(key: "usesigbill", value: "1");
      // await storage.write(key: "useqrbill", value: "1");
      // await storage.write(key: "usesigmonth", value: "0");
      // await storage.write(key: "useqrmonth", value: "0");
      await storage.write(key: "shopOwner", value: "Shop Owner Name");
      await storage.write(key: "shopName", value: "Shop Name");

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green, content: Text('Login Successfully')));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'Bazaar Khata')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User Not Found')));
        setState(() {
          _inProcess = false;
        });
      }
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Wrong Password')));
        setState(() {
          _inProcess = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _listener = FirebaseAuth.instance.userChanges().listen((User? user) {});
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 25),
              child: ListView(
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.only(
                    top: 85, left: 10, bottom: 10, right: 10),
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
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      )),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.mail),
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
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            obscureText: _true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.vpn_key),
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _true
                                        ? CupertinoIcons.eye_solid
                                        : CupertinoIcons.eye_slash_fill,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _true = !_true;
                                    });
                                  }),
                              border: const OutlineInputBorder(),
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
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPass()));
                    },
                    child: const Text(
                      'Forgot Password ?',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        // style: ButtonStyle(
                        //     backgroundColor: MaterialStateProperty.all<Color>(
                        //         const Color(0xFFFF9000))),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
                          userLogin(context);
                        },
                      )),
                  // ignore: avoid_unnecessary_containers
                  Container(
                      child: Row(
                    children: <Widget>[
                      const Text('Does not have account?'),
                      TextButton(
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )),
                ],
              ),
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
        ],
      ),
    );
  }
}
