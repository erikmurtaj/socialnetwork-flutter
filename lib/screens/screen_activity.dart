import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork_flutter/components/post/activity_build.dart';
import 'package:socialnetwork_flutter/model/feedItem.dart';

import '../home_page.dart';

class ScreenActivity extends StatefulWidget{
  @override
  _ScreenActivityState createState() => _ScreenActivityState();
}

class _ScreenActivityState extends State<ScreenActivity> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Activity Feed"),),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            return ListView(
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }

  getActivityFeed() async{
    QuerySnapshot snapshot = await feedRef
        .doc(current_uid)
        .collection("feedItems")
        .orderBy("timestamp", descending: true)
        .limit(20)
        .get();

    print(snapshot.docs.length);

    List<FeedItem> feedItems = [];
    snapshot.docs.forEach((doc) {
      feedItems.add(FeedItem.fromDocument(doc));
    });
    print(feedItems.first.type);
    List<Widget> activities_build = [];
    feedItems.forEach((element) {
      activities_build.add(ActivityBuild(feed: element,));
    });
    return activities_build;
  }

}