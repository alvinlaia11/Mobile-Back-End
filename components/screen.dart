import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:basic/components/cloudfirebase.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

Future testData() async {
  await Firebase.initializeApp();
  print('ini Done');
  FirebaseFirestore db = await FirebaseFirestore.instance;
  print('init Firestore Done');

  var data = await db.collection('event_detail').get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
    }
  });
}

class _MyHomeState extends State<MyHome> {
  List<EventModel> details = [];
  @override
  Widget build(BuildContext context) {
    testData();
    return Scaffold(
      appBar: AppBar(title: Text("Cloud Firestore")),
      body: ListView.builder(
        itemCount: (details != null) ? details.length : 0,
        itemBuilder: (context, position) {
          return CheckboxListTile(
            onChanged: (bool? value) {},
            value: null,
          );
        },
      ),
      floatingActionButton: FabCircularMenu(children: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: () {}),
        IconButton(icon: Icon(Icons.minimize), onPressed: () {})
      ]),
    );
  }
}
