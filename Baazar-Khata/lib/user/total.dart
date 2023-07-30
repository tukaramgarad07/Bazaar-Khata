import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalAmount extends StatefulWidget {
  const TotalAmount({Key? key}) : super(key: key);

  @override
  _TotalAmountState createState() => _TotalAmountState();
}

class _TotalAmountState extends State<TotalAmount> {
  final currentuser = FirebaseAuth.instance.currentUser;

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
            return const Text(
              "\u{20B9} 0",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
              "\u{20B9} 0",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            );
          }
          final List storedocs = [];
          int sum = 0;
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
            sum = sum + int.parse(a['price']);
          }).toList();
          return Text(
            "\u{20B9} $sum",
            style: const TextStyle(
                fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600),
          );
        });
  }
}
