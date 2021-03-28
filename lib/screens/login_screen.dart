import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat2.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'messagescreen.dart';

final _firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  static const String id = 'Login_Screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String username, password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;

    print(data['userId']);
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/figma.jpg'),
                    radius: 100.0,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                      onChanged: (value) {
                        //Do something with the user input.
                        username = value;
                      },
                      decoration: kTextFileDecoration.copyWith(
                        hintText: 'Username',
                        hintStyle: kcolor.copyWith(
                          color: Colors.white24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  //   child: TextField(
                  //     obscureText: true,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: Colors.white70,
                  //     ),
                  //     onChanged: (value) {
                  //       //Do something with the user input.
                  //       password = value;
                  //     },
                  //     decoration: kTextFileDecoration.copyWith(
                  //       hintText: 'Password',
                  //       hintStyle: kcolor.copyWith(
                  //         color: Colors.white24,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: RoundedButton(
                  function: () async {
                    setState(
                      () {
                        showSpinner = true;
                      },
                    );
                    //Implement login functionality.
                    try {
                      // _firestore.collection('user').add(
                      //   {
                      //     'userId': data['userId'],
                      //     'phoneNumber': data['phoneNumber'],
                      //     'userName': username,
                      //     'focusMode': false,
                      //     'photoUrl':
                      //         'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.6qHDJF8Tc0NOMgaWlq8VkQAAAA%26pid%3DApi&f=1',
                      //     'isOnline': false,
                      //   },
                      // );
                      _firestore
                          .collection('user')
                          .doc(data['userId'].toString())
                          .set(
                        {
                          'userId': data['userId'],
                          'phoneNumber': data['phoneNumber'],
                          'userName': username,
                          'focusMode': false,
                          'photoUrl':
                              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.6qHDJF8Tc0NOMgaWlq8VkQAAAA%26pid%3DApi&f=1',
                          'isOnline': false,
                          'focusLocation': [0.0, 0.0],
                        },
                      );
                      print(data['userId'].toString() + data['phoneNumber']);
                      Navigator.popAndPushNamed(
                        context,
                        Accounts.id,
                        arguments: {
                          'phoneNumber': data['phoneNumber'],
                          'userId': data['userId']
                        },
                      );

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  color: Colors.lightBlueAccent,
                  text: 'Continue',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
