import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork_flutter/home_page.dart';
import 'package:socialnetwork_flutter/model/comment.dart';
import 'package:socialnetwork_flutter/model/feedItem.dart';
import 'package:socialnetwork_flutter/model/post.dart';
import 'package:socialnetwork_flutter/post_view.dart';
import 'package:socialnetwork_flutter/screens/profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityBuild extends StatelessWidget{
  final FeedItem feed;
  Widget mediaPreview;
  String activityText;

  ActivityBuild({this.feed});


  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
          color: Colors.white54,
          child: ListTile(
            title: GestureDetector(
              onTap: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(profileId: feed.userId,)),
              );},
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: feed.username,
                      style: TextStyle(fontWeight:  FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $activityText',
                    ),
                  ]
                )   ,
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider("https://static.vecteezy.com/ti/vettori-gratis/p2/439863-icona-utenti-gratuito-vettoriale.jpg"),
            ),
            subtitle: Text(
                timeago.format(feed.timestamp.toDate()),
                overflow: TextOverflow.ellipsis,
            ),
            trailing: mediaPreview,
          ),
        ),
    );
  }

  configureMediaPreview(BuildContext context){
    if(feed.type == "like" || feed.type  == "comment"){
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(feed.mediaUrl),
                )
              ),
            ),
          ),
        ),
      );
    } else{
      mediaPreview = Text("");
    }

    if(feed.type == "like"){
      activityText = "liked your post";
    } else if(feed.type == "follow"){
      activityText = "is following you";
    } else if(feed.type == "comment"){
      String commentData = feed.commentData;
      activityText = "commented: $commentData";
    } else{
      String type = feed.type;
      activityText = "Error: Unknown type '$type'";
    }
  }

  showPost(BuildContext context) async {
    DocumentSnapshot doc = await postsRef.doc(current_uid)
        .collection("userPosts")
        .doc(feed.postId)
        .get();

    Navigator.push(context, MaterialPageRoute(builder: (context) =>
    PostView(post: Post.fromDocument(doc))));
  }

}