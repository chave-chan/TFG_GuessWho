part of 'package:guess_who/src/domain/board.dart';

Board _$BoardFromJson(Map<String, dynamic> json) {
  return Board(
    gameId: json['gameId'] as String,
    playerId: json['playerId'] as String,
    board: List<bool>.generate(16, (index) => json['ch$index'] as bool),
  );
}

Map<String, dynamic> _$BoardToJson(Board instance) {
  final data = <String, dynamic>{
    'gameId': instance.gameId,
    'playerId': instance.playerId,
  };

  for (var i = 0; i < instance.board.length; i++) {
    data['ch$i'] = instance.board[i];
  }

  return data;
}