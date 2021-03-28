import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'screens/sample.dart';
import 'screens/chat2.dart';
import 'screens/messagescreen.dart';
import 'screens/map.dart';
import 'services/sound_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(FlashChat());
}

class FlashChat extends StatefulWidget {
  @override
  _FlashChatState createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focusaro',
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => MyHomePage(),
        LoginScreen.id: (context) => LoginScreen(),
        Mock.id: (context) => Mock(),
        ChatScreen.id: (context) => ChatScreen(),
        MyHomePage.id: (context) => MyHomePage(),
        Accounts.id: (context) => Accounts(),
        MyMap.id: (context) => MyMap(),
        Sound.id: (context) => Sound(),
      },
    );
  }
}
