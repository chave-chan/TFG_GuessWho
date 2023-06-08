import 'package:guess_who/src/application/application_dao.dart';
import 'package:guess_who/src/application/exceptions/exceptions.dart';
import 'package:guess_who/src/domain/player.dart';
import 'package:guess_who/src/domain/game.dart';
import 'package:guess_who/src/domain/character.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ApplicationDAO implements IApplicationDAO {
  @override
  Future<bool> hasUserLogged() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }

    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

    if (parseResponse?.success == null || !parseResponse!.success) {
      await currentUser.logout();
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<ParseUser?> getCurrentUser() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  @override
  Future<List<Player>> getPlayers() async {
    final apiResponse = await ParseObject('User').getAll();

    try {
      final List<Player> players = apiResponse.results!
          .map((player) => Player.fromJson(player.toJson()))
          .toList();
      return players;
    } catch (e) {
      print('Error getting players. Error: $e');
      throw PlayerNotFoundException('Error getting players');
    }
  }

  @override
  Future<Player> getPlayer(String id) async {
    final apiResponse = await ParseObject('User').getObject(id);

    try {
      final Player player = Player.fromJson(apiResponse.results![0].toJson());
      return player;
    } catch (e) {
      print('Player with id $id not found');
      throw PlayerNotFoundException('Error getting player');
    }
  }

  @override
  Future<Player> getPlayerByEmail(String email) async {
    QueryBuilder<ParseObject> getPlayerByEmailQuery =
        QueryBuilder<ParseObject>(ParseObject('User'))
          ..whereEqualTo('email', email);
    final ParseResponse apiResponse = await getPlayerByEmailQuery.query();

    try {
      final Player player = Player.fromJson(apiResponse.results![0].toJson());
      return player;
    } catch (e) {
      print('Player with email $email not found');
      throw PlayerNotFoundException('Player with email $email not found');
    }
  }

  @override
  Future<int> getPlayerWins(String id) async {
    QueryBuilder<ParseObject> getPlayerWinsQuery =
        QueryBuilder<ParseObject>(ParseObject('Game'))
          ..whereEqualTo('winner', id);

    final ParseResponse apiResponse = await getPlayerWinsQuery.query();

    try {
      final int wins = apiResponse.results!.length;
      return wins;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> deletePlayer(String id) async {
    try {
      final ParseObject playerToDelete = ParseObject('User')..objectId = id;
      await playerToDelete.delete();
    } catch (e) {
      print('Error deleting player with id $id');
      throw PlayerDeleteException('Error deleting player with id $id');
    }
  }

  @override
  Future<List<Game>> getGames() async {
    final apiResponse = await ParseObject('Game').getAll();

    try {
      final List<Game> games = apiResponse.results!
          .map((game) => Game.fromJson(game.toJson()))
          .toList();
      return games;
    } catch (e) {
      print('Error getting games. Error: $e');
      throw GameNotFoundException('Error getting games');
    }
  }

  @override
  Future<Game> getGame(String id) async {
    final apiResponse = await ParseObject('Game').getObject(id);

    try {
      final Game game = Game.fromJson(apiResponse.results![0].toJson());
      return game;
    } catch (e) {
      print('Game with id $id not found');
      throw GameNotFoundException('Error getting game');
    }
  }

  @override
  Future<void> addGame(Game game) async {
    ParseObject parsePlayer1 = ParseObject('User')..objectId = game.player1Id;
    ParseObject parsePlayer2 = ParseObject('User')..objectId = game.player2Id;

    try {
      final ParseObject newGame = ParseObject('Game')
        ..set('type', game.getType())
        ..set('player1', parsePlayer1)
        ..set('Player2', parsePlayer2);
      await newGame.save();
    } catch (e) {
      print('Error adding game');
      throw GameCreateException('Error adding game');
    }
  }

  @override
  Future<void> updateGame(String id, Player player) async {
    ParseObject parsePlayer = ParseObject('User')..objectId = player.getId();

    try {
      final ParseObject updatedGame = ParseObject('Game')
        ..objectId = id
        //..set('character_p1', game.getCharacter1())
        //..set('character_p2', game.getCharacter2())
        ..set('winner', parsePlayer);
      await updatedGame.save();
    } catch (e) {
      print('Error updating game');
      throw GameUpdateException('Error updating game');
    }
  }

  @override
  Future<List<Character>> getCharacters() async {
    final apiResponse = await ParseObject('Character').getAll();

    try {
      final List<Character> characters = apiResponse.results!
          .map((character) => Character.fromJson(character.toJson()))
          .toList();
      return characters;
    } catch (e) {
      print('Error getting characters');
      throw CharacterNotFoundException('Error getting characters');
    }
  }

  @override
  Future<Character> getCharacter(String id) async {
    final apiResponse = await ParseObject('Character').getObject(id);

    try {
      final Character character =
          Character.fromJson(apiResponse.results![0].toJson());
      return character;
    } catch (e) {
      print('Character with id $id not found');
      throw CharacterNotFoundException('Error getting character');
    }
  }

  @override
  Future<Map<ParseUser, int>> getRanking() async {
    Map<String, int> winsPerPlayer = await getWinsPerPlayer();
    Map<String, int> ranking = sortRanking(winsPerPlayer);
    
    if (ranking.isNotEmpty) {
      Map<ParseUser, int> userRanking = {};

      for (var entry in ranking.entries) {
        ParseUser? user = await getUserFromObjectId(entry.key);
        if (user != null) {
          userRanking[user] = entry.value;
        }
        print('USER: $user');
      }
      print('USER RANKING: $userRanking');
      return userRanking;
    } else {
      print('Ranking is empty');
      return {};
    }
  }

  @override
  Future<int> getRank(String playerId) async {
    Map<ParseUser, int> ranking = await getRanking();
    int position = 0;
    for (var user in ranking.keys) {
      position++;
      if (user.objectId == playerId) {
        return position;
      }
    }
    return 0;
  }

  Future<Map<String, int>> getWinsPerPlayer() async {
    QueryBuilder<ParseObject> queryGames =
        QueryBuilder<ParseObject>(ParseObject('Game'))
          ..whereEqualTo('type', true)
          ..orderByDescending('createdAt');

    var apiResponse = await queryGames.query();

    try {
      final List<Game> games = (apiResponse.results ?? [])
          .map((game) => Game.fromJson(game.toJson()))
          .toList();

      Map<String, int> winsPerPlayer = {};

      for (var game in games) {
        if (game.winnerId != null) {
          String winnerId = game.winnerId!;
          if (!winsPerPlayer.containsKey(winnerId)) {
            winsPerPlayer[winnerId] = 1;
          } else {
            winsPerPlayer[winnerId] = (winsPerPlayer[winnerId] ?? 0) + 1;
          }
        }
      }
      return winsPerPlayer;
    } catch (e) {
      print('Error getting ranking');
      throw RankingException('Error getting ranking');
    }
  }

  Map<String, int> sortRanking(Map<String, int> ranking) {
    try {
      var entries = ranking.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      var sortedRanking = Map.fromEntries(entries);
      return sortedRanking;
    } catch (e) {
      print('Error sorting ranking');
      throw RankingException('Error sorting ranking');
    }
  }

  Future<ParseUser?> getUserFromObjectId(String objectId) async {
    QueryBuilder<ParseObject> queryUser =
        QueryBuilder<ParseObject>(ParseObject('User'))
          ..whereEqualTo('objectId', objectId);

    var response = await queryUser.query();

    if (response.results != null && response.results!.isNotEmpty) {
      return response.results!.first as ParseUser;
    } else {
      return null;
    }
  }
}
