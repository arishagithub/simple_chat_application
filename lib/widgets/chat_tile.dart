import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class ChatTile extends StatelessWidget {
  final String chatId;
  final String lastMessage;
  final DateTime timeStamp;
  final Map<String, dynamic> receiverData;
  const ChatTile({
    super.key,
    required this.chatId,
    required this.lastMessage,
    required this.timeStamp,
    required this.receiverData
  });

  @override
  Widget build(BuildContext context) {
    return lastMessage != "" ? ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(receiverData['imageUrl']),
      ),
      title: Text(receiverData['name']),
      subtitle: Text(lastMessage,maxLines: 2,),
      trailing: Text(
        '${timeStamp.hour}:${timeStamp.minute}',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatId: chatId,receiverId: receiverData['uid'],)));
      },
    ) : Container();
  }
}
