import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:guess_who/src/views/widgets/buttons.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  ApplicationDAO applicationDAO = ApplicationDAO();
  ParseUser? loggedInUser;

  String gameId = 'I3HD80kryN';
  String timer = "00:00",
      opponent = "Opponent's username",
      character = "Character's name";

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
        title: Text(timer, style: TextStyle(fontSize: 30)),
        iconTheme: IconThemeData(size: 32),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 32, 16, 0),
        child: Column(
          children: [
            SizedBox(
              height: 520,
              width: double.maxFinite,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
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
                  Container(
                      child: Text(opponent, style: TextStyle(fontSize: 24))),
                  Positioned(
                    top: 140,
                    child: Container(
                      width: 400,
                      height: 400,
                      child: ModelViewer(
                        src: 'lib/assets/models/blueBoard.glb',
                        alt: "Blue Board",
                        cameraOrbit: '-15deg 60deg 0deg',
                        maxCameraOrbit: '90deg 90deg 0deg',
                        autoRotate: false,
                        autoPlay: false,
                        loading: Loading.eager,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/Bill.jpg',
                    height: 96, width: 64),
                SizedBox(width: 16),
                Text(character, style: TextStyle(fontSize: 30)),
              ],
            ),
            Spacer(),
            ChatButton(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
