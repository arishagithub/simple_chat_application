import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/chat_provider.dart';
import '../widgets/user_tile.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;
  String searchQuery = '';
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
  
  void handleSearch(String query){
    setState(() {
      searchQuery = query;
    });
  }
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Search Users"),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search Users...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: handleSearch,
            ),
          ),
          Expanded(child: StreamBuilder(
              stream: searchQuery.isEmpty ? Stream.empty() : chatProvider.searchUsers(searchQuery),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final users = snapshot.data!.docs;
                List<UserTile> userWidgets = [];
                for(var user in users){
                  final userData = user.data() as Map<String,dynamic>;
                  if(userData['uid']!= loggedInUser!.uid){
                    final userWidget = UserTile(
                        userId: userData['uid'],
                        name: userData['name'],
                        email: userData['email'],
                        imageUrl: userData['imageUrl']
                    );
                    userWidgets.add(userWidget);
                  }
                }
                return ListView(
                  children: userWidgets,
                );
              },
          )),
        ],
      ),
    );
  }
}

