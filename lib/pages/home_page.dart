import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:socialnetwork_flutter/screens/screen_profile.dart';
import 'package:socialnetwork_flutter/screens/screen_activity.dart';
import 'package:socialnetwork_flutter/screens/screen_search.dart';
import 'package:socialnetwork_flutter/screens/screen_timeline.dart';
import 'package:socialnetwork_flutter/screens/screen_upload.dart';

import '../model/user.dart';

final DateTime timestamp = DateTime.now();
final storageRef = FirebaseStorage.instance.ref();
// Create a CollectionReference called users that references the firestore collection
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final feedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timelineRef = FirebaseFirestore.instance.collection('timeline');

User currentUser;
String current_uid;

class Home extends StatefulWidget {

  Home(String uid){
    current_uid = uid;
    getCurrentUser();
  }

  getCurrentUser() async {
    DocumentSnapshot doc = await usersRef.doc(current_uid).get();
    currentUser = User.fromDocument(doc);
  }

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  items selelected_item = items.home;

  static List<Widget> screens = [
    //ScreenAdd(),
    ScreenTimeline(),
    ScreenSearch(),
    ScreenUpload(),
    ScreenActivity(),
    ScreenProfile(profileId: current_uid),
  ];

  Widget screen = screens[0];
  final bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket,child: screen,),
      bottomNavigationBar: Container(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.fromBorderSide(BorderSide(color: Colors.grey[300]))
          ),
          child: Row(
            children: <Widget>[
              Expanded(child: IconButton(icon: Icon(selelected_item == items.home ? Foundation.home : LineAwesomeIcons.home, color: Colors.black,size: 25,), onPressed: (){
                setState(() {
                  selelected_item = items.home;
                  screen = screens[0];
                });
              })),
              Expanded(child: IconButton(icon: Icon(selelected_item == items.search ? FontAwesome.search : Ionicons.ios_search, color: Colors.black,), onPressed: (){
                setState(() {
                  selelected_item= items.search;
                  screen = screens[1];
                });
              })),
              Expanded(child: IconButton(icon: Icon(LineAwesomeIcons.plus_square, color: Colors.black,), onPressed: (){
                setState(() {
                  selelected_item = items.add;
                  screen = screens[2];
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenAdd()));
              })),
              Expanded(child: IconButton(icon: Icon(selelected_item == items.activities ? LineAwesomeIcons.heart : LineAwesomeIcons.heart_o, color: Colors.black,), onPressed: (){
                setState(() {
                  selelected_item = items.activities;
                  screen = screens[3];
                });
              })),
              Expanded(child: IconButton(icon: Icon(selelected_item == items.profile ? FontAwesome.user :FontAwesome.user_o, color: Colors.black,), onPressed: (){
                setState(() {
                  selelected_item = items.profile;
                  screen = screens[4];
                });
              })),
            ],
          ),
        ),
      ),
    );
  }
}

enum items{
  home,
  search,
  add,
  activities,
  profile
}
