import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibez_chat/helper/constants.dart';
import 'package:vibez_chat/services/Auth.dart';
import 'package:vibez_chat/services/Database.dart';
import 'package:vibez_chat/views/ConversationScreen.dart';
import 'package:vibez_chat/views/SignIn.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = TextEditingController();
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
        actions: [
          InkWell(
            onTap: () {
              authClass.logOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignIn()), (route) => false);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width-100,
                    height: 50.0,
                    child: TextFormField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Search username',
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
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: () {
                      initiateSearch();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 25,
                      child: Icon(Icons.search, color: Colors.white,),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30,),
              searchList(),
            ],
          ),
        ),
      ),
    );
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val) {
      setState(() {
        querySnapshot = val;
      });
    });
  }

  createChatroomAndStartConversation({String? userName}) {

    if(userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName!, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        'users' : users,
        'chatroomId' : chatRoomId,
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (builder) => ConversationScreen(chatRoomId:chatRoomId)
      ));
    }
    else {
      print('You cannot send message to yourself');
    }
  }

  Widget searchTile({String? userName, String? userEmail}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightGreen, Colors.teal[900]!, Colors.black],
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2,),
                Text(
                  userEmail!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              createChatroomAndStartConversation(
                userName: userName,
              );
            },
            child: Icon(
              Icons.message_rounded,
              color: Colors.lightGreenAccent,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
   return querySnapshot!=null ? ListView.builder(
     shrinkWrap: true,
     itemCount: querySnapshot!.docs.length,
     itemBuilder: (context, index) {
       return searchTile(
         userEmail: querySnapshot!.docs[0]['email'],
         userName: querySnapshot!.docs[0]['name'],
       );
     },
   ) : Container();
  }
}

getChatRoomId (String a, String b) {
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
    return '$b\_$a';
  }
  else {
    return '$a\_$b';
  }
}

