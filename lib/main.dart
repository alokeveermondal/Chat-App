import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vibez_chat/helper/helperfunctions.dart';
import 'package:vibez_chat/views/ChatRoomsScreen.dart';
import 'package:vibez_chat/views/Search.dart';
import 'package:vibez_chat/views/SignIn.dart';
import 'package:vibez_chat/views/SignUp.dart';
import 'package:vibez_chat/views/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool? userIsLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }
  
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userIsLoggedIn!=null ? userIsLoggedIn==true ? ChatRoomScreen() : Welcome() : Welcome(),

    );
  }
}

