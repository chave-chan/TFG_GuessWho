import 'package:json_annotation/json_annotation.dart';

part 'package:guess_who/utils/JsonSerializable/boardJS.dart';

@JsonSerializable()
class Board {
  String gameId, playerId;
  List<bool> board = List.filled(16, true, growable: false);
  
  Board({
    required this.gameId,
    required this.playerId,
    required this.board,
  });

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  Map<String, dynamic> toJson() => _$BoardToJson(this);

  void resetBoard() {
    board = List.filled(16, true, growable: false);
  }

  void changeState(int index) {
    board[index] = !board[index];
  }

  bool getState(int index) {
    return board[index];
  }

  String getGameId() => gameId;
  String getPlayerId() => playerId;

  String setGameId(String gameId) => this.gameId = gameId;
  String setPlayerId(String playerId) => this.playerId = playerId;
}