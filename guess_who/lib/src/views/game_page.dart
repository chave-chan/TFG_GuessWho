import 'package:flutter/material.dart';
import 'package:guess_who/src/views/widgets/buttons.dart';
//import 'package:model_viewer_plus/model_viewer_plus.dart';

class GamePage extends StatelessWidget {
  GamePage({super.key});

  String timer = "00:00", opponent = "Opponent's username", character = "Character's name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(timer, style: TextStyle(fontSize: 30)),
        iconTheme: IconThemeData(size: 32),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(opponent, style: TextStyle(fontSize: 30)),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: 240,
                  color: Colors.red,
                ),
                /*
                ModelViewer(
                  src: 'assets/models/redBoard.gltf',
                  alt: "Red Board",
                ),
                */
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 200,
                  width: 240,
                  color: Colors.blue,
                ),
                /*
                ModelViewer(
                  src: 'assets/models/blueBoard.gltf',
                  alt: "Blue Board",
                ),
                */
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/Bill.jpg',
                    height: 96, width: 64),
                SizedBox(width: 16),
                Text(character, style: TextStyle(fontSize: 30)),
              ],
            ),
            //WrittingInput(),
          ],
        ),
      ),
    );
  }
}
