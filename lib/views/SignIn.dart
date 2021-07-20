import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibez_chat/helper/helperfunctions.dart';
import 'package:vibez_chat/services/Auth.dart';
import 'package:vibez_chat/services/Database.dart';
import 'package:vibez_chat/views/ChatRoomsScreen.dart';
import 'package:vibez_chat/views/SignUp.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  AuthClass authClass = AuthClass();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot? querySnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Linker",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            letterSpacing: 2,
            fontFamily: 'Pacifico-Regular',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-80,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: AssetImage('assets/cartoonLink.jpg'),
                  )
                ),
                height: 150,
                width: 150,
              ),
              SizedBox(height: 10.0,),
              textItem(context, emailTextEditingController,'Email', false),
              SizedBox(height: 10.0,),
              textItem(context, passwordTextEditingController,'Password', true),
              SizedBox(height: 30,),
              coloredButton(context, 'Sign In'),
              SizedBox(height: 10,),
              // buttonItem(context, 'assets/google.svg', 'Continue with Google', 30),
              // SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignUp()), (route) => false);
                    },
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,)
            ]
          ),
        ),
      ),
    );
  }

  Widget coloredButton(BuildContext context, String text) {
    return InkWell(
      onTap: () async {
        try {
          HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
          databaseMethods.getUserByEmail(emailTextEditingController.text).then((val) {
            querySnapshot = val;
            HelperFunctions.saveUserNameSharedPreference(querySnapshot!.docs[0]['name']);
          });

          authClass.logInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
            if(val !=  null) {

              HelperFunctions.saveUserLoggedInSharedPreference(true);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ChatRoomScreen()), (route) => false);
            }
          });
        }
        catch(err) {
          final snackBar = SnackBar(
            content: Text(err.toString()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width-70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [Colors.lightGreen, Colors.green, Colors.greenAccent],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget textItem(BuildContext context, TextEditingController textEditingController, String labelText, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width-70,
      height: 55.0,
      child: TextFormField(
        obscureText: obscureText,
        controller: textEditingController,
        style: TextStyle(
          fontSize: 17.0,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              width: 3.0,
              color: Colors.lightGreen,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonItem(BuildContext context, String imagePath, String buttonName, double size) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        width: MediaQuery.of(context).size.width-70,
        height: 60,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              width: 2.0,
              color: Colors.white,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                height: size,
                width: size,
              ),
              SizedBox(width: 20.0,),
              Text(
                buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
