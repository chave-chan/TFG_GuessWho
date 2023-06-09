import 'package:flutter/material.dart';
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

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true, debug: true);

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
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: LogInPage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}