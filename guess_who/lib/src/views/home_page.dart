import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:guess_who/src/domain/game.dart';
import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:guess_who/src/views/pages.dart';
import 'package:guess_who/src/views/widgets/buttons.dart';
import 'package:guess_who/utils/theme.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApplicationDAO applicationDAO = ApplicationDAO();
  CancelableOperation<Game?>? searchGameOperation;
  ParseUser? loggedInUser;
  bool isWaiting = false;
  String message = '';

  late Game testGame;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getTestGame();
  }

  void getTestGame() async {
    testGame = await applicationDAO.getGame('I3HD80kryN');
  }

  void getCurrentUser() async {
    loggedInUser = await applicationDAO.getCurrentUser();
  }

  void searchGame(bool type) async {
    searchGameOperation = CancelableOperation<Game?>.fromFuture(Future.any([
      applicationDAO.seekGame(loggedInUser!.objectId!, type),
      Future.delayed(Duration(minutes: 1)),
    ]));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Search Status'),
          alignment: Alignment.center,
          content: DialogContent(searchGameOperation!),
        );
      },
    );

    searchGameOperation!.value.then((game) {
      if (game != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GamePage(game: game)),
        );
      } else {
        cancelGameSearch();
        Future.delayed(Duration(seconds: 10), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    }).catchError((error) {
      cancelGameSearch();
      Future.delayed(Duration(seconds: 10), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Close the dialog
        }
      });
    });
  }

  void cancelGameSearch() {
    if (searchGameOperation != null && !searchGameOperation!.isCompleted) {
      searchGameOperation!.cancel();
    }

    setState(() {
      isWaiting = false;
      message = 'Game search cancelled';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 72, 16, 64),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SettingsButton(),
                SizedBox(width: 8),
                ProfileButton(),
                SizedBox(width: 8),
                RankingButton(),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InstructionsButton(),
              ],
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Guess Who',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary)),
              ],
            ),
            SizedBox(height: 100),
            SizedBox(
              height: 384.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 72),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppTheme.gameMode1,
                      minimumSize: Size(260, 384),
                    ),
                    child: Text(
                      'PLAY\nONLINE',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      searchGame(true);
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppTheme.gameMode2,
                      minimumSize: Size(260, 384),
                    ),
                    child: Text(
                      'PLAY\nVS.\nFRIEND',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      searchGame(false);
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppTheme.gameMode3,
                      minimumSize: Size(260, 384),
                    ),
                    child: Text(
                      'PLAY\nVS. AI',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      /*
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Game mode not available'),
                          duration: Duration(seconds: 1)));
                      */
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GamePage(game: testGame)),
                      );
                    },
                  ),
                  SizedBox(width: 72),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}