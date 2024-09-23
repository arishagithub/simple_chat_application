import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool  isMe;
  final dynamic timestamp;
  const MessageBubble({super.key, required this.sender, required this.text, required this.isMe, this.timestamp});

  @override
  Widget build(BuildContext context) {
    final DateTime messageTime = (timestamp is Timestamp) ? timestamp.toDate():
    DateTime.now();
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width*0.75,
            ),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 2,
              ),
              ],
              borderRadius: isMe ? BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ): BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft:  Radius.circular(15),
              ),
              color : isMe ? Color(0XFF3876FD) : Colors.white,
            ),
            child: Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text,
                    style: TextStyle(
                      color: isMe ? Colors.white: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text('${messageTime.hour}:${messageTime.minute}',
                    style: TextStyle(
                      color: isMe ? Colors.white: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
