import 'package:flutter/material.dart';
import 'package:guess_who/src/views/widgets/buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  GameMode1Button(),
                  SizedBox(width: 16),
                  GameMode2Button(),
                  SizedBox(width: 16),
                  GameMode3Button(),
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
