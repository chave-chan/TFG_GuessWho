import 'package:flutter/material.dart';
import 'package:guess_who/src/domain/game.dart';
import 'package:guess_who/src/domain/player.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:guess_who/utils/theme.dart';
import 'package:guess_who/src/views/pages.dart';
import 'package:guess_who/src/persistence/application_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'MzdJuLfQCNzq70Che5MXd7kG1SxJr0lUmmIG5g0j';
  const keyClientKey = '1VAjmwJp8T9zjwasVLSuc6tMEq5UJRUgIGmRV8WW';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  ApplicationDAO applicationDAO = ApplicationDAO();

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true, debug: true);

  /*PRUEBAS (QUITAR)*/
  /*
  Player p = await applicationDAO.getPlayer('YIdLE2TlsU');
  print('\nPLAYER p ${p.toString()}\n');
  await applicationDAO.addPlayer('testUsername', 'testEmail', 'testPassword');
  Player p0 = await applicationDAO.getPlayerByEmail('test2');
  print('\nPLAYER p0 ${p0.toString()}\n');
  List<Player> players = await applicationDAO.getPlayers();
  print('\nPLAYERS ${players.toString()}\n');
  await applicationDAO.addGame(Game(id: '', type: true, player1Id: p.getId(), player2Id: p0.getId()));
  List<Game> games = await applicationDAO.getGames();
  print('\nGAMES ${games.toString()}\n');
  await applicationDAO.updateGame(games[0].getId(), p);
  Game g = await applicationDAO.getGame(games[0].getId());
  print('\nGAME g ${g.toString()}\n');
  print('\nRANKING\n');
  await applicationDAO.getRanking();
  */
  /*FIN PRUEBAS*/

  runApp(const GuessWho());
}

class GuessWho extends StatelessWidget {
  const GuessWho({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'GuessWho',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: LogInPage(),
      ),
    );
  }
}

//Define el estado de la app
//Define los datos que la app necesita para funcionar
class AppState extends ChangeNotifier {}