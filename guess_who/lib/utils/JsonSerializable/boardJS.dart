part of 'package:guess_who/src/domain/board.dart';

Board _$BoardFromJson(Map<String, dynamic> json) {
  return Board(
    gameId: json['game_id']['objectId'] as String,
    playerId: json['player_id']['objectId'] as String,
    board: List<bool>.generate(16, (index) => json['ch$index'] as bool),
  );
}

Map<String, dynamic> _$BoardToJson(Board instance) {
  final data = <String, dynamic>{
    'game_id': instance.gameId,
    'player_id': instance.playerId,
  };

  for (var i = 0; i < instance.board.length; i++) {
    data['ch$i'] = instance.board[i];
  }

  return data;
}