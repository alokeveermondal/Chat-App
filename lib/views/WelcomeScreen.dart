import 'package:flutter/material.dart';
import 'package:vibez_chat/views/SignIn.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                  ),
                  //color: Colors.orangeAccent,
                ),
                height: 300,
                width: 300,
              ),
              Text(
                'a new chat platform',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontFamily: 'Pacifico-Regular',
                  letterSpacing: 1.5
                ),
              ),
              SizedBox(height: 100,),
              coloredButton(context, "Let's begin"),
            ],
          ),
        ),
      ),
    );
  }

  Widget coloredButton(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignIn()), (route) => false);
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
}
