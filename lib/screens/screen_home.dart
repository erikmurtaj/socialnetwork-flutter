import 'package:flutter/material.dart';
import '../authentication_service.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[100],
        title: Text("Activity",style: TextStyle(fontFamily: 'Sans',fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HOME"),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
            child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
