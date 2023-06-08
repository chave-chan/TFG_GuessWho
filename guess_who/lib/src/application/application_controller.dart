import 'dart:async';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:guess_who/src/application/application_dao.dart';
import 'package:guess_who/src/domain/player.dart';
import 'package:guess_who/src/domain/game.dart';
import 'package:guess_who/src/domain/character.dart';

class ApplicationController {
  /*
  final keyApplicationId = 'i73k2qbpNuOHG0X98R8oTZL7Kx0piozahz6N35EI';
  final keyClientKey = '9lSbIoVxxjnAYucvIfffmC6ZmMHY7cCrobOIOHBi';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  */

  //IApplicationDAO _applicationDAO;
  //ApplicationController(this._applicationDAO);

  ApplicationController();

  /*
  void openConnection() async {
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true, debug: true);
  }
  */

/*
  Future<List<Player>> getPlayers() {
    return _applicationDAO.getPlayers();
  }

  Future<Player> getPlayer(String id) {
    return _applicationDAO.getPlayer(id);
  }

  Future<Player> getPlayerByEmail(String email) {
    return _applicationDAO.getPlayerByEmail(email);
  }

  Future<Player> addPlayer(Player player) {
    return _applicationDAO.addPlayer(player);
  }

  Future<List<Game>> getGames() {
    return _applicationDAO.getGames();
  }

  Future<Game> getGame(String id) {
    return _applicationDAO.getGame(id);
  }

  Future<Game> addGame(Game game) {
    return _applicationDAO.addGame(game);
  }

  Future<List<Character>> getCharacters() {
    return _applicationDAO.getCharacters();
  }

  Future<Character> getCharacter(String id) {
    return _applicationDAO.getCharacter(id);
  }
*/
}
