import 'package:flutter/material.dart';
import 'package:guess_who/src/views/widgets/buttons.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How To Play', style: TextStyle(fontSize: 30)),
        iconTheme: IconThemeData(size: 32),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              GameMode2HTPButton(),
              SizedBox(width: 16),
              GameMode3HTPButton(),
              SizedBox(width: 16),
              GameMode1HTPButton(),
              SizedBox(width: 16),
              Text("[1] Public games affect the global ranking.\n[2] Private games do not affect the global ranking."),
            ],
          ),
        ),
      ),
    );
  }
}