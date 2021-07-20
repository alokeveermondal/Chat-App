import 'package:flutter/material.dart';
import 'package:vibez_chat/helper/constants.dart';
import 'package:vibez_chat/helper/helperfunctions.dart';
import 'package:vibez_chat/services/Auth.dart';
import 'package:vibez_chat/services/Database.dart';
import 'package:vibez_chat/views/ConversationScreen.dart';
import 'package:vibez_chat/views/Search.dart';
import 'package:vibez_chat/views/SignIn.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  AuthClass authClass = AuthClass();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomsStream;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return ChatRoomsTile(
              snapshot.data.docs[index]['chatroomId'].toString().replaceAll('_', '').replaceAll(Constants.myName, ''),
              snapshot.data.docs[index]['chatroomId']
            );
          },
        ) : Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "Linker",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                letterSpacing: 2,
                fontFamily: 'Pacifico-Regular',
              ),
            ),
            Text(
              'Your friends',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              authClass.logOut();
              HelperFunctions.saveUserLoggedInSharedPreference(false);
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
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => SearchScreen()));
        },
        backgroundColor: Colors.green,
        child: Icon(
          Icons.search,
          size: 30,
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(
                '${userName.substring(0,1)}'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              radius: 20,
              backgroundColor: Colors.green,
            ),
            SizedBox(width: 10,),
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


