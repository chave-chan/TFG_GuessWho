part of 'package:guess_who/src/domain/character.dart';

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['objectId'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };