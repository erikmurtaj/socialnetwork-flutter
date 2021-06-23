import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork_flutter/components/timeline/friends_row.dart';
import 'package:socialnetwork_flutter/pages/home_page.dart';
import 'package:socialnetwork_flutter/model/post.dart';
import 'package:socialnetwork_flutter/components/post/post_view.dart';
import 'package:socialnetwork_flutter/screens/screen_search.dart';
import 'package:socialnetwork_flutter/model/user.dart';

class ScreenTimeline extends StatefulWidget {
  @override
  _ScreenTimelineState createState() => _ScreenTimelineState();
}

class _ScreenTimelineState extends State<ScreenTimeline> {
  List<Post> posts;
  List<String> followingList = [];

  @override
  void initState(){
    super.initState();
    getTimeline();
    getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Timeline"),),
      body: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: buildTimeline(),
      ),
    );
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .doc(current_uid)
        .collection("timelinePosts")
        .orderBy("timestamp", descending: true)
        .get();
    List<Post> posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }


  buildTimeline() {
    if(posts == null){
      return CircularProgressIndicator();
    } else if(posts.isEmpty){
      //return buildUserToFollow();
    } else{
      List<Widget> post_widgets = [];
      posts.forEach((post) => post_widgets.add(PostView(post: post,)));
      return buildUserToFollow();
      return ListView(children: post_widgets);
    }
  }

  buildUserToFollow() {
    return StreamBuilder(
      stream: usersRef.limit(30).snapshots(),
      builder: (context, snapshot) {

        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        List<UserResult> userResults = [];
        List<User> suggested_users = [];
        int count = 0;
        snapshot.data.docs.forEach((doc) {

          User user = User.fromDocument(doc);
          final bool isAuthUser = current_uid == user.id;
          final bool isFollowingUser = followingList.contains(user.id);

          // remove auth user from reccomended list
          if(isAuthUser){
            return;
          } else{
            print(count++);
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
            suggested_users.add(user);
            print(suggested_users.length);
          }
        });

        return FriendsRow(suggested_users);

      },
    );
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(current_uid)
        .collection("userFollowing")
        .get();
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }
}