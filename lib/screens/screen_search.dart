import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socialnetwork_flutter/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:socialnetwork_flutter/screens/profile_screen.dart';

import '../home_page.dart';

class ScreenSearch extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<ScreenSearch> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildNoContent() : buildSearchResults()
    );
  }

  ///String typed into the text form automatically passed from onFieldSubmitted field
  handleSearch(String query){

    // Using the CollectionReference usersRef that references the firestore collection
    Future<QuerySnapshot> users = usersRef
                                    .where("username", isGreaterThanOrEqualTo: query)
                                    .get();

    /* 1. Save the results in a state so we can get it from the body
    *  2. Since it's a Future, we can retrieve the results with a FutureBuilder
    *       in the buildSearchResults method
     */
    setState(() {
      searchResultsFuture = users;
    });
    
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search for a user...",
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          )
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  clearSearch(){
    searchController.clear();
  }

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/search.svg',
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text("Find Users", textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 60.0,
                )
            )
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
        future: searchResultsFuture,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          List<UserResult> searchResults = [];
          snapshot.data.docs.forEach((doc){
            User user = User.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          });
          return ListView(
            children: searchResults,
          );
        }
    );
  }
}

class UserResult extends StatelessWidget{
  final User user;

  UserResult(this.user);

  profileView(BuildContext context, String user_id){
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        ProfileScreen(profileId: user_id,)));
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            //TODO: profile page
            onTap: () => profileView(context, user.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(user.username, style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),),
              subtitle: Text(user.full_name, style: TextStyle(
                  color: Colors.white,),
              ))
            ),
            Divider(
              height: 2.0,
              color: Colors.white54,
            ),
        ],
      )
    );
  }
}
