import 'package:chat_app/auth/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/message_stream.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final String receiverId;
  const ChatScreen({super.key,required this.chatId, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? loggedInUser;
  String? chatId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatId = widget.chatId;
    getCurrentUser();
  }

  getCurrentUser(){
    final user = _auth.currentUser;
    if(user!=null){
      setState(() {
        loggedInUser = user;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final TextEditingController _textController = TextEditingController();
    return FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(widget.receiverId).get(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            final receiverData = snapshot.data!.data() as Map<String,dynamic>;
            
            return Scaffold(
              backgroundColor: Color(0XFFEEEEEE),
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(receiverData['imageUrl']),
                    ),
                    SizedBox(width: 10,),
                    Text(receiverData['name']),
                  ],
                ),
              ),
              body:  Column(
                children: [
                  Expanded(
                      child: chatId != null && chatId!.isNotEmpty ?MessagesStream(chatId: chatId!)
                      : Center(child: Text("No Messages Yet"),
                      )
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(child: TextFormField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "Enter your message...",
                            border: InputBorder.none,
                          ),
                        )),
                        IconButton(onPressed: ()async{
                          if(_textController.text.isNotEmpty){
                            if(chatId == null || chatId!.isEmpty){
                              chatId=await chatProvider.createChatRoom(widget.receiverId);
                            }
                            if(chatId!=null){
                              chatProvider.sendMessage(chatId!, _textController.text, widget.receiverId);
                              _textController.clear();
                            }
                          }
                        }, icon: Icon(Icons.send),color: Color(0XFF3876FD),),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
    );
  }
}





