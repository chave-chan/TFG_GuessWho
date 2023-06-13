import 'dart:async';
import 'dart:math';
import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package:guess_who/utils/JsonSerializable/gameJS.dart';

@JsonSerializable()
class Game {
  ApplicationDAO applicationDAO = ApplicationDAO();
  bool type; //true if public, false if private
  String id, player1Id, player2Id, character1Id, character2Id;
  String? winnerId;
  late String player1Username, player2Username, character1Name, character2Name, winnerUsername;

  late List<bool> board;
  Timer? timer;
  bool player1Turn;

  Game({
    required this.id,
    required this.type,
    required this.player1Id,
    required this.player2Id,
    required this.character1Id,
    required this.character2Id,
    this.winnerId,
  }) : player1Turn = Random().nextBool();

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  Future<void> updateBoard() async {
    await applicationDAO.updateBoard(id, player1Turn ? player1Id : player2Id, board);
  }

  void startTurn() {
    timer?.cancel();
    timer = Timer(Duration(minutes: 1), endTurn);
  }

  void endTurn() {
    updateBoard();
    switchTurn();
    timer?.cancel();
  }

  void switchTurn() {
    player1Turn = !player1Turn;
    startTurn();
  }

  void getInfo() {
    player1Username =
        applicationDAO.getUsernameFromObjectId(player1Id) as String;
    player2Username =
        applicationDAO.getUsernameFromObjectId(player2Id) as String;
    character1Name = applicationDAO.getNameFromObjectId(character1Id) as String;
    character2Name = applicationDAO.getNameFromObjectId(character2Id) as String;
    if (winnerId != null) {
      winnerUsername =
          applicationDAO.getUsernameFromObjectId(winnerId!) as String;
    }
  }

  @override
  String toString() =>
      'Game(ID: $id, Player1: $player1Username with character $character1Name, Player2: $player2Username with character $character2Name, Winner: $winnerUsername)';

  String getId() => id;
  bool getType() => type;
  String getPlayer1Id() => player1Id;
  String getPlayer2Id() => player2Id;
  String getCharacter1Id() => character1Id;
  String getCharacter2Id() => character2Id;
  String? getWinnerId() => winnerId;

  setId(String id) => this.id = id;
  setType(bool type) => this.type = type;
  setPlayer1Id(String player1Id) => this.player1Id = player1Id;
  setPlayer2Id(String player2Id) => this.player2Id = player2Id;
  setCharacter1Id(String character1Id) => this.character1Id = character1Id;
  setCharacter2Id(String character2Id) => this.character2Id = character2Id;
  setWinnerId(String? winnerId) => this.winnerId = winnerId;
}
