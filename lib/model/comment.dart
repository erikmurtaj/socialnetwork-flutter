import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String userId;
  final String comment;
  final Timestamp timestamp;

  Comment({this.username, this.userId,  this.comment, this.timestamp});

  ///Factory method to create a User from a Document
  factory Comment.fromDocument(DocumentSnapshot doc){
    return Comment(
        username: doc['username'],
        userId: doc['userId'],
        comment: doc['comment'],
        timestamp: doc['timestamp']
    );
  }


}