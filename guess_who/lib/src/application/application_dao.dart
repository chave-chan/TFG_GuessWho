import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../domain/player.dart';
import '../domain/game.dart';
import '../domain/character.dart';
import '../domain/board.dart';

abstract class IApplicationDAO {
  Future<bool> hasUserLogged();
  Future<ParseUser?> getCurrentUser();

  Future<List<Player>> getPlayers();
  Future<Player> getPlayer(String id);
  Future<Player> getPlayerByEmail(String email);
  Future<int> getPlayerWins(String id);
  Future<void> deletePlayer(String id);

  Future<void> setSeekingGame(String playerId, bool isSeekingGame);
  Future<Game?> seekGame(String playerId, bool type, {Stream<bool>? cancellationToken});

  Future<List<Game>> getGames();
  Future<Game> getGame(String id);
  Future<Game> addGame(Game game);
  Future<void> updateGame(String id, String playerId);

  Future<List<Character>> getCharacters();
  Future<Character> getCharacter(String id);

  Future<void> addBoard(Board board);
  Future<Board> getBoard(String gameId, String playerId);
  Future<void> updateBoard(String gameId, String playerId, List<bool> board);
  Future<void> deleteBoard(String gameId, String playerId);

  Future<List<ParseObject>> getChatMessages(String gameId);
  Future<void> deleteChatMessages(String gameId);

  Future<Map<String, int>> getRanking();
  Future<int> getRank(String id);
}
