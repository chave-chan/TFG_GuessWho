import 'package:flutter/material.dart';
import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:guess_who/src/views/log_in_page.dart';
import 'package:guess_who/utils/theme.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ApplicationDAO applicationDAO = ApplicationDAO();
  late Future<ParseUser?> futureCurrentUser;
  int wins = 0, rank = 0;
  bool isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    futureCurrentUser = applicationDAO.getCurrentUser();
    loadPlayerWins();
    loadPlayerRank();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParseUser?>(
      future: futureCurrentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          ParseUser? currentUser = snapshot.data;
          String username = currentUser?.get('username');
          String email = currentUser?.get('email');
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile', style: TextStyle(fontSize: 30)),
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
                      Container(
                        height: 88,
                        width: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('lib/assets/images/user.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: Text(username,
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                            textAlign: TextAlign.start),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(email,
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.start),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Wins',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.emoji_events, size: 40),
                      SizedBox(width: 8),
                      Text('$wins', style: TextStyle(fontSize: 32)),
                    ],
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Rank',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(' #',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary)),
                      SizedBox(width: 16),
                      Text('$rank', style: TextStyle(fontSize: 32)),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.red,
                          minimumSize: Size(360, 72),
                        ),
                        onPressed: () {
                          userLogOut();
                        },
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontSize: 28, color: AppTheme.backgroundLight),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void loadPlayerWins() async {
    final user = await ParseUser.currentUser() as ParseUser;
    applicationDAO.getPlayerWins(user.get('objectId')).then((wins) {
      setState(() {
        this.wins = wins;
      });
    });
  }

  void loadPlayerRank() async {
    final user = await ParseUser.currentUser() as ParseUser;
    applicationDAO.getRank(user.get('objectId')).then((rank) {
      setState(() {
        this.rank = rank;
      });
    });
  }

  void userLogOut() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();

    if (response.success) {
      setState(() {
        isLoggedIn = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogInPage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error logging out')));
    }
  }
}
