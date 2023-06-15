import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:guess_who/src/domain/game.dart';
import 'package:guess_who/utils/theme.dart';
import 'package:guess_who/src/views/pages.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

/*SIGN IN PAGE*/

class LogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(double.maxFinite, 64),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Log In',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()),
        );
      },
    );
  }
}

/*LOG IN PAGE*/

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(double.maxFinite, 64),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sign In',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      },
    );
  }
}

/*HOME PAGE*/

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      iconSize: 48,
      color: Colors.grey,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      },
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: Size(double.maxFinite, 60),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 28),
            SizedBox(width: 8),
            Text('Profile', style: TextStyle(fontSize: 24)),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
      ),
    );
  }
}

class RankingButton extends StatelessWidget {
  const RankingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: Size(double.maxFinite, 60),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 24),
            SizedBox(width: 8),
            Text('Ranking', style: TextStyle(fontSize: 24)),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RankingPage()),
          );
        },
      ),
    );
  }
}

class InstructionsButton extends StatelessWidget {
  const InstructionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          minimumSize: Size(double.maxFinite, 68),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('How To Play',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstructionsPage()),
          );
        },
      ),
    );
  }
}

class DialogContent extends StatefulWidget {
  final CancelableOperation<Game?> searchGameOperation;

  DialogContent(this.searchGameOperation);

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  String message = '\nSearching for an opponent...';

  @override
  void initState() {
    super.initState();

    widget.searchGameOperation.value.then((game) {
      if (game != null) {
        setState(() {
          message = '\nGame found, redirecting...';
        });
      } else {
        Timer(Duration(seconds: 5), () {
          setState(() {
            message = 'No available players right now.\nTry again later';
          });
        });
      }
    }).catchError((error) {
      setState(() {
        message = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 24),
        Text(message, textAlign: TextAlign.center),
        SizedBox(height: 16),
        ElevatedButton(
          child: Text('Cancel'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            widget.searchGameOperation.cancel();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

/*
class GameMode1Button extends StatelessWidget {
  const GameMode1Button({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: AppTheme.gameMode1,
        minimumSize: Size(260, 384),
      ),
      child: Text(
        'PLAY\nVS. AI',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Game mode not available'),
            duration: Duration(seconds: 1)));
      },
    );
  }
}

class GameMode2Button extends StatelessWidget {
  const GameMode2Button({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: AppTheme.gameMode2,
        minimumSize: Size(260, 384),
      ),
      child: Text(
        'PLAY\nONLINE',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GamePage()),
        );
      },
    );
  }
}

class GameMode3Button extends StatelessWidget {
  const GameMode3Button({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: AppTheme.gameMode3,
        minimumSize: Size(260, 384),
      ),
      child: Text(
        'PLAY\nVS.\nFRIEND',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GamePage()),
        );
      },
    );
  }
}
*/

/*SETTINGS PAGE*/

class Volume extends StatefulWidget {
  const Volume({super.key});

  @override
  State<Volume> createState() => _VolumeState();
}

class _VolumeState extends State<Volume> {
  double currentVolume = 0.5;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      currentVolume = await PerfectVolumeControl.getVolume();
      setState(() {});
    });

    PerfectVolumeControl.stream.listen((Volume) {
      setState(() {
        currentVolume = Volume;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Slider(
        value: currentVolume,
        min: 0,
        max: 1,
        divisions: 100,
        onChanged: (Volume) {
          currentVolume = Volume;
          PerfectVolumeControl.setVolume(Volume);
          setState(() {});
        },
      ),
    );
  }
}

const List<Widget> languages = <Widget>[
  Text('English'),
  Text('Spanish'),
];

class LanguageButtons extends StatefulWidget {
  const LanguageButtons({super.key});

  @override
  State<LanguageButtons> createState() => _LanguageButtonsState();
}

class _LanguageButtonsState extends State<LanguageButtons> {
  final List<bool> selectedLanguage = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          ToggleButtons(
            direction: Axis.vertical,
            textStyle: TextStyle(fontSize: 24),
            constraints: BoxConstraints(minWidth: 300, minHeight: 72),
            selectedBorderColor: Theme.of(context).colorScheme.primary,
            borderColor: Theme.of(context).colorScheme.primary,
            borderWidth: 1.5,
            borderRadius: BorderRadius.circular(8),
            isSelected: selectedLanguage,
            children: languages,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < selectedLanguage.length; i++) {
                  selectedLanguage[i] = i == index;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class ColorblindCheckbox extends StatefulWidget {
  const ColorblindCheckbox({super.key});

  @override
  State<ColorblindCheckbox> createState() => _ColorblindCheckboxState();
}

class _ColorblindCheckboxState extends State<ColorblindCheckbox> {
  bool isChecked = false;
  String text = "Off";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Transform.scale(
            scale: 2,
            child: Checkbox(
              activeColor: Theme.of(context).colorScheme.primary,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                  text = isChecked ? "On" : "Off";
                });
              },
            ),
          ),
          SizedBox(width: 24),
          Text(
            'Colorblind Mode $text',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

/*INSTRUCTIONS (HTP) PAGE*/

class GameMode1HTPButton extends StatefulWidget {
  const GameMode1HTPButton({super.key});

  @override
  State<GameMode1HTPButton> createState() => _GameMode1HTPButtonState();
}

class _GameMode1HTPButtonState extends State<GameMode1HTPButton> {
  String textTitle =
          "Play against an AI without the need for an internet connection.\n\n",
      textBody =
          "Both the AI and you will receive a random character. Your goal is to guess the AI's character before it guesses yours.\n\nYou can ask about physical features like 'Does your character wear glasses?'.\nThe AI will respond with 'Yes' or 'No' based on its character's features.\n\nUse the answers to eliminate characters from your list of possible options.\nKeep asking questions until you are confident in identifying the AI's character.\n\nIf you guess the AI's character, the game will end, and you will win the match. Otherwise, if it guesses your character, the game will end, and you will lose the match.\n";
  bool displayText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: AppTheme.gameMode3,
            minimumSize: Size(double.maxFinite, 80),
          ),
          child: Text(
            'Play VS. AI',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              displayText = !displayText;
            });
          },
        ),
        SizedBox(height: 16),
        displayText
            ? RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: textTitle,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground)),
                  TextSpan(
                      text: textBody,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.25,
                          color: Theme.of(context).colorScheme.onBackground)),
                ]))
            : Container(),
      ],
    );
  }
}

class GameMode2HTPButton extends StatefulWidget {
  const GameMode2HTPButton({super.key});

  @override
  State<GameMode2HTPButton> createState() => _GameMode2HTPButtonState();
}

class _GameMode2HTPButtonState extends State<GameMode2HTPButton> {
  String textTitle =
          "Play against another player online in a public game[1].\n\n",
      textBody =
          "Both players will receive a random character. Your goal is to guess the other player's character before they guess yours.\n\nYou can ask about physical features such as 'Does your character have blond hair?'.\nThe other player will respond with 'Yes' or 'No' based on their character's features.\n\nUse the answers to eliminate characters from your list of possibilities.\nKeep asking questions until you are confident in identifying the other player's character.\n\nIf you guess the other player's character, the game will end, and you will win the match. Otherwise, if they guess your character, the game will end, and you will lose the match.\n";
  bool displayText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: AppTheme.gameMode1,
            minimumSize: Size(double.maxFinite, 80),
          ),
          child: Text(
            'Play Online',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              displayText = !displayText;
            });
          },
        ),
        SizedBox(height: 16),
        displayText
            ? RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: textTitle,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground)),
                  TextSpan(
                      text: textBody,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.25,
                          color: Theme.of(context).colorScheme.onBackground)),
                ]))
            : Container(),
      ],
    );
  }
}

class GameMode3HTPButton extends StatefulWidget {
  const GameMode3HTPButton({super.key});

  @override
  State<GameMode3HTPButton> createState() => _GameMode3HTPButtonState();
}

class _GameMode3HTPButtonState extends State<GameMode3HTPButton> {
  String textTitle = "Play against a friend online in a private game[2].\n\n",
      textBody =
          "Both players will receive a random character. Your goal is to guess the other player's character before they guess yours.\n\nYou can ask about physical features such as 'Does your character have blond hair?'.\nThe other player will respond with 'Yes' or 'No' based on their character's features.\n\nUse the answers to eliminate characters from your list of possibilities.\nKeep asking questions until you are confident in identifying the other player's character.\n\nIf you guess the other player's character, the game will end, and you will win the match. Otherwise, if they guess your character, the game will end, and you will lose the match.\n";
  bool displayText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: AppTheme.gameMode2,
            minimumSize: Size(double.maxFinite, 80),
          ),
          child: Text(
            'Play VS. Friend',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              displayText = !displayText;
            });
          },
        ),
        SizedBox(height: 16),
        displayText
            ? RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: textTitle,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground)),
                  TextSpan(
                      text: textBody,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.25,
                          color: Theme.of(context).colorScheme.onBackground)),
                ]))
            : Container(),
      ],
    );
  }
}