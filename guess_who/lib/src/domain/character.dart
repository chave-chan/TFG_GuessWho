import 'package:json_annotation/json_annotation.dart';

part 'package:guess_who/utils/JsonSerializable/characterJS.dart';

@JsonSerializable()
class Character {
  String id, name;

  Character({
    required this.id,
    required this.name,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  @override
  String toString() => 'Character(ID: $id, Name: $name)';

  String getId() => id;
  String getPlayername() => name;

  setId(String id) => this.id = id;
  setPlayername(String name) => this.name = name;
}