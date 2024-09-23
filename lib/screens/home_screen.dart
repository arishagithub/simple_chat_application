import 'package:chat_app/auth/chat_provider.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  Future<Map<String , dynamic>> _fetchChatData(String chatId) async {
    final chatDoc =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data();
    final users = chatData!['users'] as List<dynamic>;
    final receiverId = users.firstWhere((id) => id!= loggedInUser!.uid);
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(receiverId).get();
    final userData = userDoc.data();
    return{
      'chatId' : chatId,
      'lastMessage' : chatData['lastMessage'] ?? '',
      'timeStamp' : chatData['timeStamp']?.toData() ?? DateTime.now(),
      'userData' : userData,
    };
  }
  @override
  Widget build(BuildContext context) {
     final chatProvider = Provider.of<ChatProvider>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Chats"),
          actions: [
            IconButton(onPressed: (){
              _auth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }, icon: Icon(Icons.logout)),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: StreamBuilder<QuerySnapshot>(
                stream: chatProvider.getChats(loggedInUser!.uid),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  final chatDocs = snapshot.data!.docs;
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(chatDocs.map((chatDoc)=> _fetchChatData(chatDoc.id))),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final chatDataList = snapshot.data!;
                      return ListView.builder(
                          itemCount: chatDataList.length,
                          itemBuilder: (context,index){
                            final chatData = chatDataList[index];
                        return ChatTile(
                            chatId: chatData['chatId'],
                            lastMessage: chatData['lastMessage'],
                            timeStamp: chatData['timeStamp'],
                            receiverData: chatData['userData'],
                        );
                      });
                    },
                  );
                }
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0XFF3876FD),
          foregroundColor: Colors.white,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),));
          },
          child: Icon(Icons.search),
        ),
      ),
    );
  }
}
