part of 'package:guess_who/src/domain/player.dart';

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      id: json['objectId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
    };