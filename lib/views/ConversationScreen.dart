import 'package:flutter/material.dart';
import 'package:vibez_chat/helper/constants.dart';
import 'package:vibez_chat/services/Auth.dart';
import 'package:vibez_chat/services/Database.dart';
import 'package:vibez_chat/views/SignIn.dart';

class ConversationScreen extends StatefulWidget {
  final String? chatRoomId;
  ConversationScreen({this.chatRoomId});
  //const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  AuthClass authClass = AuthClass();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream? qstream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: qstream,
      builder: (context, AsyncSnapshot snapshot) {
        //print('Snapshot is $snapshot');
        //return Text('${snapshot.data}', style: TextStyle(color: Colors.white),);
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(snapshot.data.docs[index]['message'], snapshot.data.docs[index]['sendBy']==Constants.myName);
            },
          );
        }
        else {
          return Container();
        }
      },
    );
  }

  sendMessage() {
    if(messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message' : messageController.text,
        'sendBy' : Constants.myName,
        'time' : DateTime.now().microsecondsSinceEpoch,
      };
      
      databaseMethods.addConversationMessage(widget.chatRoomId!, messageMap);
      messageController.text = '';
    }
  }


  @override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId!).then((val) {
      setState(() {
        qstream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width-100,
                    height: 50.0,
                    child: TextFormField(
                      controller: messageController,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Message...',
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
                      sendMessage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 25,
                      child: Icon(Icons.send, color: Colors.white,),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 20, right: isSendByMe ? 20: 0),
      margin: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [Colors.green, Colors.green[700]!, Colors.green[900]!] : [Colors.white30, Colors.white24, Colors.white12],
          ),
          borderRadius: isSendByMe ? BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ) : BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

