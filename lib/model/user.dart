import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String username;
  final String full_name;
  final String photoUrl;
  final String bio;

  User({this.id, this.email, this.username, this.full_name,  this.photoUrl, this.bio});

  ///Factory method to create a User from a Document
  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      full_name: doc['full_name'],
      bio: doc['bio']
    );
  }


}