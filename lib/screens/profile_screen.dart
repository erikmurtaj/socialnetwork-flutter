import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork_flutter/components/profile_widgets/profile_button.dart';
import 'package:socialnetwork_flutter/home_page.dart';
import 'package:socialnetwork_flutter/model/post.dart';
import 'package:socialnetwork_flutter/model/user.dart';
import 'package:socialnetwork_flutter/post_view.dart';
import '../constant.dart';
import '../edit_profile.dart';

class ProfileScreen extends StatefulWidget{
  final String profileId;

  ProfileScreen({this.profileId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;
  bool isLoading = false;
  bool isFollowing = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  @override
  void initState(){
    super.initState();
    //TODO: correct the bug of photoUrl null
    getUser(widget.profileId);
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  checkIfFollowing() async{
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection("userFollowers")
        .doc(current_uid)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async{
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileId)
        .collection("userFollowers")
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async{
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection("userFollowing")
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  getUser(String profileId) async{
    DocumentSnapshot doc = await usersRef.doc(profileId).get();
    setState(() {
      this.user = User.fromDocument(doc);
    });
  }

  getProfilePosts() async {
    print(widget.profileId);
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef.doc(widget.profileId)
        .collection("userPosts")
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();

    });
  }

  editProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
    EditProfile()));
  }

  postView(Post post){
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        PostView(post: post,)));
  }

  @override
  Widget build(BuildContext context) {
    if(this.user != null) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/profile_bg.png',
                ),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 260,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: kWhiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 48,
                                  backgroundImage: CachedNetworkImageProvider(
                                      this.user.photoUrl),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        this.user.full_name,
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: kBlueColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(this.user.username),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      if(this.user.id ==
                                          current_uid) ProfileButton(
                                          text: "Edit Profile", onPress: () {})
                                      else if(isFollowing)
                                        ProfileButton(
                                            text: "Unfollow", onPress: handleUnfollowUser)
                                      else if(!isFollowing)
                                        ProfileButton(
                                            text: "Follow", onPress: handleFollowUser)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "$postCount",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: kBlueColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Posts',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      followerCount.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: kBlueColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      followingCount.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: kBlueColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Friends',
                              style: TextStyle(
                                fontSize: 20,
                                color: kBlueColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Friends row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 28,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                AssetImage('assets/images/friend_pic1.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                AssetImage('assets/images/friend_pic2.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                AssetImage('assets/images/friend_pic3.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                AssetImage('assets/images/friend_pic4.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                AssetImage('assets/images/friend_pic5.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                AssetImage('assets/images/friend_pic6.png'),
                              ),
                            ),
                            SizedBox(
                              width: 28,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        child: Text(
                          'Photos',
                          style: TextStyle(
                            color: kBlueColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      /// Posts
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: buildProfilePosts(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    };
  }

  List<Widget> buildProfilePosts() {

    List<Widget> widgets = [];

    widgets.add(SizedBox(
      width: 28,
    ));

    posts.forEach((post) {
      print(post.timestamp);
      widgets.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            onTap: () => postView(post),
            child: Image.network(
              post.mediaUrl,
              height: 200,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ));
    });

    widgets.add(SizedBox(
      width: 28,
    ));

    return widgets;
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    
    // Make auth user follower of ANOTHER user (update their followers)
    followersRef
      .doc(widget.profileId)
      .collection("userFollowers")
      .doc(current_uid)
      .set({});

    // Put that user on YOUR following collection (update ypur following collection)
    followingRef
        .doc(current_uid)
        .collection("userFollowing")
        .doc(widget.profileId)
        .set({});

    // Add activity feed item to nofify that user about new follower
    feedRef
        .doc()
        .collection("feedItems")
        .doc(current_uid)
        .set({
          "type": "follow",
          "username": currentUser.username,
          "userId": currentUser.id,
          "postId": "",
          "commentData": "",
          "mediaUrl": "",
          "timestamp": timestamp
        });
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });

    // Remove follower
    followersRef
        .doc(widget.profileId)
        .collection("userFollowers")
        .doc(current_uid)
        .get().then((doc) {
          if(doc.exists) doc.reference.delete();
        });

    // Remove that user on YOUR following collection (update ypur following collection)
    followingRef
        .doc(current_uid)
        .collection("userFollowing")
        .doc(widget.profileId)
        .get().then((doc) {
          if(doc.exists) doc.reference.delete();
        });

    // Delete the activity
    feedRef
        .doc()
        .collection("feedItems")
        .doc(current_uid)
        .get().then((doc) {
          if(doc.exists) doc.reference.delete();
        });
  }

}
