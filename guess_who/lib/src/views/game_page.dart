import 'package:flutter/material.dart';
import 'package:guess_who/src/domain/game.dart';
import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:guess_who/src/views/widgets/buttons.dart';
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
  bool isUserTurn = true;

  late String gameId, otherPlayer, character;
  String timer = "00:00";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    gameId = widget.game.getId();
    otherPlayer = widget.game.getPlayer2Id();
    character = widget.game.getCharacter1Id();
  }

  void getCurrentUser() async {
    loggedInUser = await applicationDAO.getCurrentUser();
  }

  Future<void> _showCharacterDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.expand_more, size: 48, color: AppTheme.primary),
                  Text('Hide characters',
                      style: TextStyle(fontSize: 16, color: AppTheme.primary))
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
              children: List.generate(
                16,
                (index) => ElevatedButton(
                  onPressed: () {
                    // Realizar acción al seleccionar un botón
                  },
                  child: Image.asset(
                    'lib/assets/images/Bill.jpg',
                    height: 96 * 0.8,
                    width: 64 * 0.8,
                  ),
                ),
              ),
            ),
          ),
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
                    isUserTurn = !isUserTurn;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/Bill.jpg',
                    height: 96 * 0.8, width: 64 * 0.8),
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
            ChatButton(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
