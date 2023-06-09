import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../domain/player.dart';
import '../domain/game.dart';
import '../domain/character.dart';

abstract class IApplicationDAO {
  Future<bool> hasUserLogged();
  Future<ParseUser?> getCurrentUser();

  Future<List<Player>> getPlayers();
  Future<Player> getPlayer(String id);
  Future<Player> getPlayerByEmail(String email);
  Future<int> getPlayerWins(String id);
  Future<void> deletePlayer(String id);

  Future<List<Game>> getGames();
  Future<Game> getGame(String id);
  Future<void> addGame(Game game);
  Future<void> updateGame(String id, Player player);

  Future<List<Character>> getCharacters();
  Future<Character> getCharacter(String id);

  Future<List<ParseObject>> getChatMessages(String gameId);
  Future<void> deleteChatMessages(String gameId);

  Future<Map<String, int>> getRanking();
  Future<int> getRank(String id);
}
