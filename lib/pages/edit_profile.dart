import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../authentication/authentication_service.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_service.dart';
import 'home_page.dart';
import '../model/user.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});
  
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>{

  bool isLoading = false;

  void initState(){
    super.initState();
    getUser();
  }

  void getUser() async{
    setState(() {
      isLoading = true;
    });

    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();

    User.fromDocument(doc);

  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.grey[100],
          title: Text("Activity",style: TextStyle(fontFamily: 'Sans',fontWeight: FontWeight.bold),),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("HOME"),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
                child: Text("Sign out"),
              ),
            ],
          ),
        ),
      );
  }


}