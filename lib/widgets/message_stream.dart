import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

class MessagesStream extends StatelessWidget {
  final String chatId;
  const MessagesStream({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').
        orderBy('timestamp',descending: true).snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data!.docs;
          List<MessageBubble> messageWidgets = [];
          for(var message in messages){
            final messageData = message.data() as Map<String,dynamic>;
            final messageText = messageData['messageBody'];
            final messageSender = messageData['senderId'];
            final timestamp = messageData['timestamp'] ?? FieldValue.serverTimestamp();
            final currentUser = FirebaseAuth.instance.currentUser!.uid;
            final messageWidget = MessageBubble(
              sender:messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
              timestamp: timestamp,
            );
            messageWidgets.add(messageWidget);
          }
          return ListView(
            reverse: true,
            children: messageWidgets,
          );
        }
    );
  }
}