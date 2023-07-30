import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_bazaar_khata/customer/customer_detail.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';

class ZoomCustomerImage extends StatefulWidget {
  final int gender;
  final String name;
  final String id;
  const ZoomCustomerImage(
      {Key? key, required this.id, required this.gender, required this.name})
      : super(key: key);

  @override
  _ZoomCustomerImageState createState() => _ZoomCustomerImageState();
}

class _ZoomCustomerImageState extends State<ZoomCustomerImage> {
  // ignore: avoid_init_to_null
  var imagefromPref = null;
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

  ImageProvider customerImage(gender, id) {
    if (imagefromPref == null) {
      loadImage(id);
    }
    if (imagefromPref != null) {
      return imagefromPref;
    } else if (gender == 0) {
      return const AssetImage('images/maleAvatar.jpg');
    } else if (gender == 1) {
      return const AssetImage('images/femaleavatar (2).jpg');
    }
    return const AssetImage('images/avatar.png');
  }

  @override
  void initState() {
    super.initState();
    if (imagefromPref == null) {
      loadImage(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.grey[100],
        ),
        padding: const EdgeInsets.all(0),
        width: 251.99,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                child: Image(
                    width: 251.99,
                    image: customerImage(widget.gender, widget.id))),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text(
                widget.name,
                style: TextStyle(
                    color: Colors.teal[400],
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerImage extends StatefulWidget {
  final String id;
  final int gender;
  const CustomerImage({Key? key, required this.id, required this.gender})
      : super(key: key);

  @override
  _CustomerImageState createState() => _CustomerImageState();
}

class _CustomerImageState extends State<CustomerImage> {
  // ignore: avoid_init_to_null
  var imagefromPref = null;
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

  ImageProvider customerImage(gender, id) {
    if (imagefromPref == null) {
      loadImage(id);
    }
    if (imagefromPref != null) {
      return imagefromPref;
    } else if (gender == 0) {
      return const AssetImage('images/maleAvatar.jpg');
    } else if (gender == 1) {
      return const AssetImage('images/femaleavatar (2).jpg');
    }
    return const AssetImage('images/avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image(
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        image: customerImage(widget.gender, widget.id),
      ),
    );
  }
}

class CustomerTab extends StatefulWidget {
  const CustomerTab({Key? key}) : super(key: key);

  @override
  _CustomerTabState createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
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

  final currentuser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          return const Center(child: CircularProgressIndicator());
        }
        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();
        if (storedocs.isEmpty) {
          return const Center(child: Text('No Customer'));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 65),
          itemCount: storedocs.length,
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
                            showDialogFunction(context, storedocs[i]['id'],
                                storedocs[i]['gender'], storedocs[i]['name']);
                          },
                          child: CustomerImage(
                              id: storedocs[i]['id'],
                              gender: storedocs[i]['gender'])),
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
                          title: Text(storedocs[i]['name'] ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          subtitle: Text(
                            storedocs[i]['lastbill'] ?? '16/11/2021',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: money(storedocs[i]['price'] ?? "0"),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                PageRouteBuilder(
                                    reverseTransitionDuration:
                                        const Duration(microseconds: 100),
                                    transitionDuration:
                                        const Duration(milliseconds: 100),
                                    transitionsBuilder: (context, animation,
                                        animationTime, child) {
                                      // return SlideTransition(
                                      //     position: Tween<Offset>(
                                      //       begin: const Offset(-1, 0),
                                      //       end: Offset.zero,
                                      //     ).animate(animation),
                                      //     child: child);
                                      return ScaleTransition(
                                          alignment: Alignment.center,
                                          scale: animation,
                                          child: child);
                                    },
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> animationTime) {
                                      return CustomerDetail(
                                        customerEmail: storedocs[i]['email'],
                                        customerDesc: storedocs[i]['desc'],
                                        customerName: storedocs[i]['name'],
                                        id: storedocs[i]['id'],
                                        money: storedocs[i]['price'],
                                      );
                                    }));
                            setState(() {});
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
