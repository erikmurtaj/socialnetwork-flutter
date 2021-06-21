import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// creating a reference to fetch the data
final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState(){
    //getUsers();
  }

  void getUserName() {
    //usersRef.doc(documentId).get(),
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }


}
