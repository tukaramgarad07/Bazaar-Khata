import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_bazaar_khata/customer/customer_detail.dart';
import 'package:new_bazaar_khata/customer/new_customer.dart';
import 'package:new_bazaar_khata/firebase/login.dart';
import 'package:new_bazaar_khata/signature/home_signature.dart';
import 'package:new_bazaar_khata/tabs/activity_tab.dart';
import 'package:new_bazaar_khata/tabs/customer_tab.dart';
import 'package:new_bazaar_khata/tabs/payment_tab.dart';
import 'package:new_bazaar_khata/user/calculate_bill.dart';
import 'package:new_bazaar_khata/user/change_password.dart';
import 'package:new_bazaar_khata/user/feedback.dart';
import 'package:new_bazaar_khata/user/qr_code.dart';
import 'package:new_bazaar_khata/user/rate_chart.dart';
import 'package:new_bazaar_khata/user/total.dart';
import 'package:new_bazaar_khata/user/update_user.dart';
import 'package:new_bazaar_khata/util/about.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';
import 'package:new_bazaar_khata/util/setting.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _intialization = Firebase.initializeApp();
  final storage = const FlutterSecureStorage();
  Future<bool> checkLoginStatus() async {
    String? value = await storage.read(key: "uid");
    if (value == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _intialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Bazaar Khata',
              theme: ThemeData(
                  //     primarySwatch: const MaterialColor(
                  //   // 0xFFFB8C00,
                  //   0xFF6D4C41,
                  //   // 0xFF8E24AA,
                  //   // 0xFF43A047,
                  //   // 0xFFD81B60,
                  //   // 0xFF1E88E5,
                  //   // 0xFF3949AB,

                  //   <int, Color>{
                  //     50: Color(0xFFFB8C00),
                  //     100: Color(0xFFFFFFFF),
                  //     200: Color(0xFFFFFFFF),
                  //     300: Color(0xFFFFFFFF),
                  //     400: Color(0xFFFFFFFF),
                  //     500: Color(0xFFFFFFFF),
                  //     600: Color(0xFFFFFFFF),
                  //     700: Color(0xFFFFFFFF),
                  //     800: Color(0xFFFFFFFF),
                  //     900: Color(0xFFFFFFFF),
                  //   },
                  // )
                  // Color(0xFFFF9000)
                  // primarySwatch: MaterialColor(primary, swatch)
                  // primarySwatch: const Color(0xFFFF9000),
                  // backgroundColor: Colors.purple[600],
                  // backgroundColor: Colors.pink[600],
                  // backgroundColor: Colors.green[600],
                  // backgroundColor: Colors.blue[600],
                  // backgroundColor: Colors.indigo[600],
                  // backgroundColor: Colors.brown[600],
                  ),
              home: FutureBuilder(
                  future: checkLoginStatus(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.data == false) {
                      return const Login();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                          backgroundColor: Colors.white,
                          body: Center(
                              child: Container(
                                  color: Colors.white,
                                  child: const CircularProgressIndicator())));
                    }
                    return const MyHomePage(title: 'Flutter Demo Home Page');
                  }),
              debugShowCheckedModeBanner: false,
            );
          }
          return MaterialApp(
            title: 'Bazaar Khata',
            theme: ThemeData(
                // primarySwatch: Colors.blue,

                primaryColor: Colors.orange[600]),
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> toptabs = const <Tab>[
    Tab(text: 'CUSTOMERS'),
    Tab(text: 'PAYMENTS'),
    Tab(text: 'ACTIVITY')
  ];
  final storage = const FlutterSecureStorage();

  final Stream<QuerySnapshot> customers =
      FirebaseFirestore.instance.collection('customers').snapshots();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              backgroundColor: Colors.orange[600],
              // backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text('Bazaar Khata', style: TextStyle(fontSize: 22)),
              titleSpacing: 0.0,
              actions: [
                InkWell(
                  child: const Icon(Icons.search),
                  onTap: () {
                    showSearch(context: context, delegate: DataSearch());
                  },
                ),
                PopupMenuButton(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Contraints.choices.map((String choices) {
                      return PopupMenuItem(
                          value: choices, child: Text(choices));
                    }).toList();
                  },
                )
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: toptabs,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2.5,
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: const [
              CustomerTab(),
              PaymentTab(),
              ActivityTab(),
            ],
          ),
        ),
        drawer: const DrawerTab(),
        floatingActionButton: _fAB(),
      ),
    );
  }

  FloatingActionButton? _fAB() {
    if (_tabController.index == 0) {
      return FloatingActionButton.extended(
        label: const Text('New Customer'),
        icon: const Icon(Icons.person_add),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const NewCustomer(id: 'Mayur Tea Stall')));

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(
                        title: 'Mayur Bansod',
                      )));
        },
        // backgroundColor: Colors.pink[600],
        backgroundColor: Colors.orange[600],
      );
    }
    return null;
  }

  void choiceAction(String choices) async {
    if (choices == Contraints.updateProfile) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const UpdateUser()));
    }
    if (choices == Contraints.settings) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SettingsClass()));
    }
    if (choices == Contraints.changePassword) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ChangeUserPassword()));
    }
    if (choices == Contraints.signOut) {
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      if (hasInternet == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text('No Internet Connection',
                style: TextStyle(fontSize: 16), textAlign: TextAlign.center)));
      }
      try {
        await FirebaseAuth.instance.currentUser!.delete();
        await storage.delete(key: 'uid');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Please try again',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center)));
        }
      }
    }
  }
}

class Contraints {
  static const String updateProfile = 'Update Profile';
  static const String settings = 'Settings';
  static const String changePassword = 'Change Password';
  static const String signOut = 'Delete Account';
  static const List<String> choices = <String>[
    updateProfile,
    settings,
    changePassword,
    signOut,
  ];
}

class DrawerTab extends StatefulWidget {
  const DrawerTab({Key? key}) : super(key: key);

  @override
  _DrawerTabState createState() => _DrawerTabState();
}

class _DrawerTabState extends State<DrawerTab> {
  // ignore: avoid_init_to_null
  var imagefromPref = null;
  final storage = const FlutterSecureStorage();
  final currentuser = FirebaseAuth.instance.currentUser;
  String? shopName = "Shop Name";
  String? shopOwnerName = "Owner Name";

  Future loadImage(key) async {
    Utility.getImageFromPreferences(key).then((value) {
      if (null == value) {
        return;
      }
      setState(() {
        imagefromPref = Utility.imageFromBase64StringCustomerDetail(value);
      });
    });
  }

  Widget getImage(String uid) {
    if (null == imagefromPref) {
      loadImage(uid);
    }
    if (imagefromPref != null) {
      return Container(
          height: 130,
          alignment: Alignment.centerLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              width: 130,
              height: 130,
              fit: BoxFit.cover,
              image: imagefromPref,
            ),
          ));
    }
    return Container(
      height: 130,
      alignment: Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const Image(
            width: 130,
            height: 130,
            fit: BoxFit.cover,
            image: AssetImage('images/shop.jpeg')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 15, left: 20),
            decoration: BoxDecoration(color: Colors.orange[600]),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getImage(currentuser!.uid),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(currentuser!.photoURL ?? "Shop Name",
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentuser!.displayName ?? "Shop Owner Name",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white70),
                    )
                  ],
                ),
                const Positioned(top: 0, right: 20, child: TotalAmount())
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                const Divider(height: 1.0),
                ListTile(
                    leading: const Icon(CupertinoIcons.signature,
                        color: Colors.black87),
                    title: const Text(
                      'Signature',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeSignature()));
                    }),
                ListTile(
                    leading: const Icon(CupertinoIcons.qrcode,
                        color: Colors.black87),
                    title: const Text(
                      'Show QR Code',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QRCode()));
                    }),
                ListTile(
                  leading: const Icon(CupertinoIcons.chart_pie_fill,
                      color: Colors.black87),
                  title: const Text(
                    'Rate Chart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RateChart(id: 'mayur')));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_chart, color: Colors.black87),
                  title: const Text(
                    'Calculate Bill',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalculateBill()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: Colors.black87),
                  title: const Text(
                    'Share this App',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () async {
                    await Share.share("https://bazaarkhata.000webhostapp.com/");
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.videocam_circle,
                      color: Colors.black87),
                  title: const Text(
                    'How to use',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () async {
                    await canLaunch("https://www.youtube.com")
                        ? await launch("https://www.youtube.com")
                        : throw 'Could not launch https://www.youtube.com';
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.chart_bar_square,
                      color: Colors.black87),
                  title: const Text(
                    'Feedback',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FeedBack()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black87),
                  title: const Text(
                    'About Bazaar Khata App',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutUs()));
                  },
                )
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading:
                const Icon(Icons.power_settings_new, color: Colors.black87),
            title: const Text(
              'Log Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              await storage.delete(key: 'uid');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final currentuser = FirebaseAuth.instance.currentUser;

  Future showDialogFunction(context, String id, int gender, String name) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: ZoomCustomerImage(id: id, gender: gender, name: name));
        });
  }

  Widget money(var money) {
    int k = money.length;
    if (int.parse(money) >= 0) {
      if (int.parse(money) > 100000) {
        return RichText(
          text: TextSpan(
              text: '\u{20B9} ',
              style: TextStyle(
                color: color(money),
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: '${money.substring(0, k - 5)}L',
                  style: TextStyle(
                    color: color(money),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
        );
      } else if (int.parse(money) > 1000) {
        return RichText(
          text: TextSpan(
              text: '\u{20B9} ',
              style: TextStyle(
                color: color(money),
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: '${money.substring(0, k - 3)}K',
                  style: TextStyle(
                    color: color(money),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
        );
      }
      return RichText(
        text: TextSpan(
            text: '\u{20B9} ',
            style: TextStyle(
              color: color(money),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: '$money',
                style: TextStyle(
                  color: color(money),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      );
    } else {
      int price = (int.parse(money)).abs();
      if (price > 100000) {
        return RichText(
          text: TextSpan(
              text: '\u{20B9} ',
              style: TextStyle(
                color: color(money),
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: '${money.substring(1, k - 5)}L',
                  style: TextStyle(
                    color: color(money),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
        );
      } else if (price > 1000) {
        return RichText(
          text: TextSpan(
              text: '\u{20B9} ',
              style: TextStyle(
                color: color(money),
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: '${money.substring(1, k - 3)}K',
                  style: TextStyle(
                    color: color(money),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
        );
      }
      return RichText(
        text: TextSpan(
            text: '\u{20B9} ',
            style: TextStyle(
              color: color(money),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: '${money.substring(1, k)}',
                style: TextStyle(
                  color: color(money),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      );
    }
  }

  Color color(String money) {
    int price = int.parse(money);
    if (price > 0) {
      return Colors.green;
    } else if (price < 0) {
      return Colors.red;
    }
    return Colors.grey;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //Action For app Bar
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 65),
      itemCount: suggestionList.length,
      itemBuilder: (buildcontext, i) => GestureDetector(
        onLongPress: () {},
        child: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: InkWell(
                      onTap: () {
                        showDialogFunction(
                            context,
                            suggestionList[i]['id'],
                            suggestionList[i]['gender'],
                            suggestionList[i]['name']);
                      },
                      child: CustomerImage(
                          id: suggestionList[i]['id'],
                          gender: suggestionList[i]['gender'])),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xFFE0E0E0)))),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(suggestionList[i]['name'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                      subtitle: Text(
                        suggestionList[i]['lastbill'] ?? '16/11/2021',
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                      trailing: money(suggestionList[i]['price'] ?? "0"),
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerDetail(
                                    customerEmail: suggestionList[i]['email'],
                                    customerDesc: suggestionList[i]['desc'],
                                    customerName: suggestionList[i]['name'],
                                    money: suggestionList[i]['price'],
                                    id: suggestionList[i]['id'])));
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  List suggestionList = [];
  final List storedocs = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestionList = query.isEmpty
        ? storedocs
        : storedocs
            .where((element) =>
                element['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('customers')
          .where('owner', isEqualTo: currentuser!.uid)
          .orderBy('lastSeen', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(""));
        }
        if (storedocs.isEmpty) {
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
        }

        if (storedocs.isEmpty) {
          return const Center(child: Text('No Customer'));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 65),
          itemCount: suggestionList.length,
          itemBuilder: (buildcontext, i) => GestureDetector(
            onLongPress: () {},
            child: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: InkWell(
                          onTap: () {
                            showDialogFunction(
                                context,
                                suggestionList[i]['id'],
                                suggestionList[i]['gender'],
                                suggestionList[i]['name']);
                          },
                          child: CustomerImage(
                              id: suggestionList[i]['id'],
                              gender: suggestionList[i]['gender'])),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFE0E0E0)))),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(suggestionList[i]['name'] ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          subtitle: Text(
                            suggestionList[i]['lastbill'] ?? '16/11/2021',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: money(suggestionList[i]['price'] ?? "0"),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerDetail(
                                        customerEmail: suggestionList[i]
                                            ['email'],
                                        customerDesc: suggestionList[i]['desc'],
                                        customerName: suggestionList[i]['name'],
                                        money: suggestionList[i]['price'],
                                        id: suggestionList[i]['id'])));
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
