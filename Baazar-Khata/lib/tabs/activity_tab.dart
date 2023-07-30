// import 'package:flutter/material.dart';

// class ActivityTab extends StatefulWidget {
//   const ActivityTab({Key? key}) : super(key: key);

//   @override
//   _ActivityTabState createState() => _ActivityTabState();
// }

// class _ActivityTabState extends State<ActivityTab> {
//   @override
//   Widget build(BuildContext context) {
//     return const Text('Customer Tab');
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_bazaar_khata/models/note.dart';
import 'package:new_bazaar_khata/util/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ActivityTab extends StatefulWidget {
  const ActivityTab({Key? key}) : super(key: key);

  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Activity> noteList = [];
  int count = 0;

  final currentuser = FirebaseAuth.instance.currentUser;

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Activity>> noteListFuture =
          databaseHelper.getActivityList(currentuser!.uid);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }

  Widget _buildActity() {
    if (count == 0) {
      return const Center(
        child: Text('No recent Activity found'),
      );
    }
    return ListView.builder(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 65),
      itemCount: count,
      itemBuilder: (buildcontext, position) => Card(
        child: Container(
            color: Colors.white,
            child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                title: AbsorbPointer(
                  child: Text(
                    noteList[position].activityDate,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    noteList[position].activityContent,
                    style: TextStyle(
                        color: color('${noteList[position].activityMethod}'),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                trailing: IconButton(
                    onPressed: () async {
                      await databaseHelper
                          .deleteActivity(noteList[position].activityId);
                      updateListView();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[400],
                    )))),
      ),
    );
  }

  color(method) {
    if (method == 'paid') {
      return Colors.blueGrey[400];
    }
    if (method == 'payment') {
      return Colors.red[400];
    }
    if (method == 'save') {
      return Colors.green[400];
    }
    return Colors.grey[400];
  }

  bool refresh = true;

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty && refresh) {
      noteList = [];
      refresh = false;
      updateListView();
    }
    return Container(
      child: _buildActity(),
    );
  }
}
