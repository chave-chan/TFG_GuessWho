import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:json_annotation/json_annotation.dart';
import 'player.dart';
import 'character.dart';

part 'package:guess_who/utils/JsonSerializable/gameJS.dart';

@JsonSerializable()
class Game {
  ApplicationDAO applicationDAO = ApplicationDAO();
  bool type; //true if public, false if private
  String id, player1Id, player2Id, character1Id, character2Id;
  String? winnerId;
  //Player player1, player2;
  //late Character character1, character2;
  //late Player winner;

  Game({
    required this.id,
    required this.type,
    required this.player1Id,
    required this.player2Id,
    required this.character1Id,
    required this.character2Id,
    this.winnerId,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  @override
  String toString() => 'Game(ID: $id, Player1: $player1Id, Player2: $player2Id, Winner: ${winnerId ?? 'No winner'})';
/*
  @override
  String toString() => 'Game(ID: $id, Player1: ${player1.toString()} with Character: ${character1.toString()}, Player2: ${player2.toString()} with Character: ${character2.toString()})';
*/
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