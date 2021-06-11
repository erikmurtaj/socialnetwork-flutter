import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

class SignInPage extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.teal,
                          Colors.purple
                        ]
                      )
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[ Form(
                                child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 250.0,
                                        child: Image.asset(
                                          "assets/logo.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(height: 45.0),
                                      TextField(
                                        controller: emailController,
                                        style: style,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                            hintText: "Email",
                                            border:
                                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                                        ),
                                      ),
                                      SizedBox(height: 25.0),
                                      TextField(
                                        controller: passwordController,
                                        obscureText: true,
                                        style: style,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                            hintText: "Password",
                                            border:
                                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                                        ),
                                      ),
                                      SizedBox(
                                        height: 35.0,
                                      ),
                                      Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(30.0),
                                        color: Color(0xff01A0C7),
                                        child: MaterialButton(
                                          minWidth: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                          onPressed: () {
                                            context.read<AuthenticationService>().logIn(
                                              email: emailController.text.trim(),
                                              password: passwordController.text.trim(),
                                            );
                                          },
                                          child: Text("Login",
                                              textAlign: TextAlign.center,
                                              style: style.copyWith(
                                                  color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 100,
                                      ),
                                    ]
                                )
                            )
                            ]
                        ))))
        )
    );
  }
}