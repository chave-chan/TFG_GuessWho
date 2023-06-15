import 'package:json_annotation/json_annotation.dart';

part 'package:guess_who/utils/JsonSerializable/characterJS.dart';

@JsonSerializable()
class Character {
  String id, name;
  int index;

  Character({
    required this.id,
    required this.name,
    required this.index,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  @override
  String toString() => 'Character(ID: $id, Name: $name, Index: $index)';

  String getId() => id;
  String getPlayername() => name;
  int getIndex() => index;

  setId(String id) => this.id = id;
  setPlayername(String name) => this.name = name;
  setIndex(int index) => this.index = index;
}