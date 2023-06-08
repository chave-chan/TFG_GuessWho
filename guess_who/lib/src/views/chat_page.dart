import 'package:flutter/material.dart';
import 'package:guess_who/utils/theme.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageTextController = TextEditingController();
//final database;
  String timer = '00:00';

  @override
  void initState() {
    super.initState();
  }
/*
  Stream<QuerySnapshot> getChatMessagesStream(){
    return database.collection('messages').orderBy('timestamp', descending: true).snapshots();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            color: AppTheme.backgroundDark,
          ),
          child: IconButton(
            icon: Icon(Icons.close),
            iconSize: 32,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(timer, style: TextStyle(fontSize: 30, color: AppTheme.backgroundDark)),
        backgroundColor: AppTheme.backgroundLight,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }
}
