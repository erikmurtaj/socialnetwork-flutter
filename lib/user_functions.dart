import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserFunctions{

  Future<void> addUser(username){
    //TODO: sistemare aggunta utente
    /// Creating a CollectionReference called users that references the firestore collection
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return usersRef
          .add({
        'username': username,
        'isAdmin': false,
        'postsCount': 0
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  String getUsernameByEmail(email){
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').where("email", isEqualTo: "erik.murtaj@gmail.com").snapshots();
    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          children:
          snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return data["username"];
          }).toList();
        },
      );
    }
  }

  void getUserPostsCount(username) async{
    /// Creating a CollectionReference called users that references the firestore collection
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    final QuerySnapshot snapshot = await usersRef
        .where("username", isEqualTo: username)
        .get();

    snapshot.docs.forEach((DocumentSnapshot doc) {
      print(doc.data);
    });
  }

}