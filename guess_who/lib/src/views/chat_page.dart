import 'package:flutter/material.dart';
import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:guess_who/utils/theme.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ApplicationDAO applicationDAO = ApplicationDAO();
  final messageTextController = TextEditingController();
  ParseUser? loggedInUser;
  String? messageText;
  bool isUserTurn = true;

  String gameId = 'I3HD80kryN';
  String timer = '00:00';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    loggedInUser = await applicationDAO.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 32, 4, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: FutureBuilder<List<ParseObject>>(
                  future: applicationDAO.getChatMessages(gameId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final message = snapshot.data![index];
                          final messageText = message.get<String>('text')!;
                          final messageSender = message.get<String>('sender')!;
                          final isMe = messageSender == loggedInUser!.username;

                          return ListTile(
                            title: Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? AppTheme.gameMode1
                                      : AppTheme.gameMode3,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.fromLTRB(12, 4, 12, 8),
                                child: Text(
                                  messageText,
                                  style: TextStyle(fontSize: 24, height: 1.5),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return Container();
                  },
                ),
              ),
              SizedBox(height: 16),
              isUserTurn ? buildTextInput() : buildYesNoButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextInput() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: messageTextController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(fontSize: 20),
              ),
              style: TextStyle(fontSize: 24),
            ),
          ),
          TextButton(
            onPressed: sendMessage,
            child: Icon(
              Icons.send,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildYesNoButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(160, 60),
            backgroundColor: AppTheme.gameMode2,
          ),
          onPressed: () => sendYesNoMessage('Yes'),
          child: Text('Yes',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.backgroundLight)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(160, 60),
            backgroundColor: AppTheme.gameMode3,
          ),
          onPressed: () => sendYesNoMessage('No'),
          child: Text('No',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.backgroundLight)),
        ),
      ],
    );
  }

  Future<void> sendMessage() async {
    ParseObject parseGame = ParseObject('Game')..objectId = gameId;
    final String messageText = messageTextController.text.trim();
    if (messageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter a message'),
            duration: Duration(seconds: 1)),
      );
      return;
    }
    final messageToSave = ParseObject('Message')
      ..set('game_id',parseGame)
      ..set<String>('text', messageTextController.text)
      ..set<String>('sender', loggedInUser!.username!);
    await messageToSave.save();
    setState(() {});
    messageTextController.clear();
  }

  Future<void> sendYesNoMessage(String answer) async {
    final messageToSave = ParseObject('Message')
      ..set<String>('text', answer)
      ..set<String>('sender', loggedInUser!.username!);
    await messageToSave.save();
    setState(() {});
  }

}
