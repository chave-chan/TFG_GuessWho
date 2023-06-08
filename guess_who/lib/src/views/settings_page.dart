import 'package:flutter/material.dart';
import 'package:guess_who/src/views/widgets/buttons.dart';
import 'package:flag/flag.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 30)),
        iconTheme: IconThemeData(size: 32),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Volume',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volume_up, size: 40),
                SizedBox(width: 8),
                Volume(),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Language',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Flag.fromCode(
                      FlagsCode.GB,
                      height: 42,
                      width: 56,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 32),
                    Flag.fromCode(
                      FlagsCode.ES,
                      height: 42,
                      width: 56,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                LanguageButtons(),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Colorblind Mode',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorblindCheckbox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
