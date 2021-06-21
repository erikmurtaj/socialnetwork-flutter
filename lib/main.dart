import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialnetwork_flutter/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialnetwork_flutter/sign_in_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  /*
    Initializing the Firebase App: this needs to be done before you use any
      kind of Firebase service
   */
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
              create: (context) => context.read<AuthenticationService>().authStateChanges,
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: AuthenticationWrapper(),
      ),
    );
  }
}

/*
    Authentication Wrapper: used to return either the home page or the login
      page depending on if the user is authenticated or not
 */
class AuthenticationWrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      //UserFunctions funtions = new UserFunctions();
      //funtions.getUserPostsCount("user_test");
      //AuthenticationService auth = new AuthenticationService(FirebaseAuth.instance);
      //auth.signOut();
      print(firebaseUser.uid);
      return Home(firebaseUser.uid);
    }
    return SignInPage();
  }
}


