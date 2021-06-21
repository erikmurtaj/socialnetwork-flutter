import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final Timestamp timestamp;
  final Map likes;
  int likesCount;

  Post({this.id, this.ownerId, this.username, this.location,  this.description, this.mediaUrl, this.likes, this.timestamp});

  ///Factory method to create a User from a Document
  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(
        id: doc['postId'],
        ownerId: doc['ownerId'],
        username: doc['username'],
        location: doc['location'],
        description: doc['description'],
        mediaUrl: doc['mediaUrl'],
        likes: doc['likes'],
        timestamp: doc['timestamp']
    );
  }

  int getLikeCount(){
    if (likes==null) return 0;
    likesCount = 0;
    likes.values.forEach((val){
      if(val == true){
        likesCount += 1;
      }
    });
    return likesCount;
  }


}