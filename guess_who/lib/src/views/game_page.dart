import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guess_who/src/domain/board.dart';
import 'package:guess_who/src/domain/character.dart';
import 'package:guess_who/src/domain/game.dart';
import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:guess_who/src/views/pages.dart';
import 'package:guess_who/utils/theme.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GamePage extends StatefulWidget {
  final Game game;
  GamePage({required this.game, super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  ApplicationDAO applicationDAO = ApplicationDAO();
  ParseUser? loggedInUser;
  StreamSubscription? timerSubscription;
  StreamSubscription? turnSubscription;
  String? selectedCharacter;
  int? selectedCharacterIndex;
  String timer = "01:00";
  bool isUserTurn = false, guessMode = false;
  List<Character> characters = [];
  List<bool> boardState = List.filled(16, true);

  String gameId = '', otherPlayer = '', username = '', character = '';
  int characterIndex = -1;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getCharacters();
    listenTimeChange();
    listenTurnChange();
    gameId = widget.game.getId();
    widget.game.getInfo().then((_) {
      if (loggedInUser?.objectId == widget.game.getPlayer1Id) {
        otherPlayer = widget.game.getPlayer2Username();
        username = widget.game.getPlayer1Username();
        character = widget.game.getCharacter1Name();
        characterIndex = widget.game.getCharacter1Index();
      } else {
        otherPlayer = widget.game.getPlayer1Username();
        username = widget.game.getPlayer2Username();
        character = widget.game.getCharacter2Name();
        characterIndex = widget.game.getCharacter2Index();
      }
      isUserTurn = widget.game.player1Turn;

      if (isUserTurn) {
        widget.game.startTurn();
      }
    });
  }

  void getCurrentUser() async {
    loggedInUser = await applicationDAO.getCurrentUser();
  }

  void getCharacters() async {
    characters = await applicationDAO.getCharacters();
  }

  void listenTimeChange() {
    timerSubscription = widget.game.timerController.stream.listen((duration) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      setState(() {
        timer =
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      });
    });
  }

  void listenTurnChange() async {
    turnSubscription =
        widget.game.turnController.stream.listen((isPlayer1Turn) async {
      Board board =
          await applicationDAO.getBoard(gameId, loggedInUser!.objectId!);

      for (int i = 0; i < 16; i++) {
        boardState[i] = board.getState(i);
      }

      setState(() {
        isUserTurn = !isUserTurn;
      });
    });
  }

  void makeGuess(String guessedCharacter) async {
    if (guessedCharacter ==
        (isUserTurn
            ? widget.game.getCharacter2Name()
            : widget.game.getCharacter1Name())) {
      String winnerId;
      if (guessedCharacter == widget.game.getCharacter2Id()) {
        winnerId = widget.game.getPlayer1Id();
      } else {
        winnerId = widget.game.getPlayer2Id();
      }
      widget.game.setWinnerId(winnerId);
      applicationDAO.updateGame(gameId, winnerId);
      widget.game.endGame(winnerId);
      _showWinnerDialog(winnerId == widget.game.getPlayer1Id()
          ? widget.game.getPlayer1Username()
          : widget.game.getPlayer2Username());
      applicationDAO.deleteBoard(gameId, widget.game.getPlayer1Id());
      applicationDAO.deleteBoard(gameId, widget.game.getPlayer2Id());
      dispose();
      Future.delayed(Duration(seconds: 30), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    } else {
      widget.game.endTurn();
    }
  }

  @override
  void dispose() {
    timerSubscription?.cancel();
    turnSubscription?.cancel();
    super.dispose();
  }

  Future<void> _showCharacterDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.expand_more,
                              size: 48, color: AppTheme.primary),
                          Text('Hide characters',
                              style: TextStyle(
                                  fontSize: 16, color: AppTheme.primary))
                        ]),
                  ),
                ],
              ),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.maxFinite,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.8,
                  physics: NeverScrollableScrollPhysics(),
                  children: characters.map((character) {
                    final characterIndex = character.index;
                    return GestureDetector(
                      onTap: () async {
                        if (guessMode) {
                          if (selectedCharacterIndex == null ||
                              selectedCharacterIndex != characterIndex) {
                            selectedCharacterIndex = characterIndex;
                            selectedCharacter =
                                'Character${characterIndex + 1}';
                            setState(() {});
                          }
                        } else {
                          await applicationDAO.updateBoard(
                              gameId, loggedInUser!.objectId!, boardState);
                          setState(() {
                            boardState[characterIndex] =
                                !boardState[characterIndex];
                          });
                        }
                      },
                      child: Opacity(
                        opacity: (selectedCharacterIndex == characterIndex &&
                                    guessMode) ||
                                boardState[characterIndex]
                            ? 1
                            : 0.25,
                        child: Container(
                          decoration: BoxDecoration(
                            color: (selectedCharacterIndex == characterIndex &&
                                    guessMode)
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Image.asset(
                            'lib/assets/images/ch$characterIndex.png',
                            height: 95,
                            width: 95,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: guessMode
                            ? AppTheme.gameMode2
                            : Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        if (!guessMode) {
                          setState(() {
                            guessMode = true;
                          });
                        } else if (selectedCharacterIndex != null) {
                          makeGuess(selectedCharacter!);
                          setState(() {
                            guessMode = false;
                            selectedCharacterIndex = null;
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text(guessMode ? 'Confirm Guess' : 'Make a Guess'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showWinnerDialog(String winnerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content:
              Text('The winner is $winnerName', style: TextStyle(fontSize: 24)),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Spacer(),
            Text(timer, style: TextStyle(fontSize: 30)),
            Spacer(),
            IconButton(
                onPressed: () {
                  setState(() {
                    try {
                      widget.game.endTurn();
                    } catch (e, stackTrace) {
                      print('Error calling endTurn: $e');
                      print('Stack trace: $stackTrace');
                    }
                  });
                },
                icon: Icon(Icons.change_circle,
                    size: 40,
                    color:
                        isUserTurn ? AppTheme.gameMode1 : AppTheme.gameMode3)),
          ],
        ),
        iconTheme: IconThemeData(
          size: 32,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
        child: Column(
          children: [
            SizedBox(
              height: 520,
              width: double.maxFinite,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Container(
                      child: Text(otherPlayer, style: TextStyle(fontSize: 28))),
                  Positioned(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: ModelViewer(
                        src: 'lib/assets/models/redBoard.glb',
                        alt: "Red Board",
                        orientation: '180deg 190deg 20deg',
                        cameraControls: false,
                        autoRotate: false,
                        autoPlay: false,
                        loading: Loading.eager,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    child: Container(
                      width: 380,
                      height: 380,
                      child: ModelViewer(
                        src: 'lib/assets/models/blueBoard.glb',
                        alt: "Blue Board",
                        cameraOrbit: '-15deg 60deg 0deg',
                        maxCameraOrbit: '90deg 90deg 0deg',
                        autoRotate: false,
                        autoPlay: false,
                        disablePan: true,
                        disableTap: true,
                        disableZoom: true,
                        loading: Loading.eager,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 120),
                Image.asset('lib/assets/images/Bill.jpg',
                    height: 95, width: 95),
                /*
                Image.asset(
                    loggedInUser!.objectId == widget.game.getPlayer1Id()
                        ? 'lib/assets/images/ch${widget.game.getCharacter1Index()}.png'
                        : 'lib/assets/images/ch${widget.game.getCharacter2Index()}.png',
                    height: 95,
                    width: 95),
                    */
                SizedBox(width: 16),
                Text(character, style: TextStyle(fontSize: 28)),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                _showCharacterDialog();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppTheme.primary),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.expand_less, size: 48, color: AppTheme.primary),
                  Text('Show characters',
                      style: TextStyle(fontSize: 16, color: AppTheme.primary))
                ]),
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.88,
                      child: ChatPage(game: widget.game),
                    );
                  },
                  isScrollControlled: true,
                );
              },
              child: Container(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 16, right: 14),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 140, 140, 140),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 14),
                          child: Text(
                            'Type a message...',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 172, 172, 172)),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.send,
                      size: 36,
                      color: AppTheme.primary,
                    ),
                    SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
