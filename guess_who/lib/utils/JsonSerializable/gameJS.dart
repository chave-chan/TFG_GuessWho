part of 'package:guess_who/src/domain/game.dart';

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      id: json['objectId'] as String,
      type: json['type'] as bool,
      player1Id: json['player1']['objectId'] as String,
      player2Id: json['player2']['objectId'] as String,
      character1Id: json['character_p1']['objectId'] as String,
      character2Id: json['character_p2']['objectId'] as String,
      winnerId: json['winner'] != null ? json['winner']['objectId'] as String : null,
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'player1': {
        '__type': 'Pointer',
        'className': 'Player',
        'objectId': instance.player1Id,
      },
      'player2': {
        '__type': 'Pointer',
        'className': 'Player',
        'objectId': instance.player2Id,
      },
      'character_p1': {
        '__type': 'Pointer',
        'className': 'Character',
        'objectId': instance.character1Id
      },
      'character_p2': {
        '__type': 'Pointer',
        'className': 'Character',
        'objectId': instance.character2Id
      },
      if (instance.winnerId != null)
        'winner': {
          '__type': 'Pointer',
          'className': 'Player',
          'objectId': instance.winnerId
        },
    };
