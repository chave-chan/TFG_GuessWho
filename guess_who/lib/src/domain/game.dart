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
  String player1Username = '', player2Username = '', character1Name = '', character2Name = '', winnerUsername = '';
  int character1Index = -1, character2Index = -1;

  List<bool> board = List.filled(16, true);
  Timer? timer;
  StreamController<Duration> timerController = StreamController<Duration>.broadcast();
  StreamController<bool> turnController = StreamController<bool>.broadcast();
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

  @override
  void dispose() {
    timerController.close();
    turnController.close();
  }

  Future<void> updateBoard() async {
    await applicationDAO.updateBoard(id, player1Turn ? player1Id : player2Id, board);
  }

  void startTurn() {
    const oneSec = Duration(seconds: 1);
    int secondsRemaining = 60;

    timer?.cancel();
    timer = Timer.periodic(oneSec, (Timer t) {
      secondsRemaining--;
      timerController.add(Duration(seconds: secondsRemaining));

      if (secondsRemaining <= 0) {
        t.cancel();
        endTurn();
      }
    });
  }

  void endTurn() {
    updateBoard();
    timer?.cancel();
    switchTurn();
    startTurn();
  }

  void switchTurn() {
    player1Turn = !player1Turn;
    turnController.add(player1Turn);
  }

  Future<void> getInfo() async {
    player1Username =
        (await applicationDAO.getUsernameFromObjectId(player1Id))!;
    player2Username =
        (await applicationDAO.getUsernameFromObjectId(player2Id))!;
    character1Name = (await applicationDAO.getNameFromObjectId(character1Id))!;
    character1Index = (await applicationDAO.getCharacterIndexFromObjectId(character1Id))!;
    character2Name = (await applicationDAO.getNameFromObjectId(character2Id))!;
    character2Index = (await applicationDAO.getCharacterIndexFromObjectId(character2Id))!;
    if (winnerId != null) {
      winnerUsername =
          (await applicationDAO.getUsernameFromObjectId(winnerId!))!;
    }
  }

  void endGame(String winnerId) {
    timer?.cancel();
    this.winnerId = winnerId;
    dispose();
  }

  @override
  String toString() =>
      'Game(ID: $id, Player1: $player1Username with character $character1Name, Player2: $player2Username with character $character2Name, Winner: $winnerUsername)';

  String getId() => id;
  bool getType() => type;
  String getPlayer1Id() => player1Id;
  String getPlayer1Username() => player1Username;
  String getPlayer2Id() => player2Id;
  String getPlayer2Username() => player2Username;
  String getCharacter1Id() => character1Id;
  String getCharacter1Name() => character1Name;
  int getCharacter1Index() => character1Index;
  String getCharacter2Id() => character2Id;
  String getCharacter2Name() => character2Name;
  int getCharacter2Index() => character2Index;
  String? getWinnerId() => winnerId;
  String? getWinnerUsername() => winnerUsername;

  setId(String id) => this.id = id;
  setType(bool type) => this.type = type;
  setPlayer1Id(String player1Id) => this.player1Id = player1Id;
  setPlayer2Id(String player2Id) => this.player2Id = player2Id;
  setCharacter1Id(String character1Id) => this.character1Id = character1Id;
  setCharacter2Id(String character2Id) => this.character2Id = character2Id;
  setWinnerId(String? winnerId) => this.winnerId = winnerId;
}