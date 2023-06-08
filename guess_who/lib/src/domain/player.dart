import 'package:json_annotation/json_annotation.dart';

part 'package:guess_who/utils/JsonSerializable/playerJS.dart';

@JsonSerializable()
class Player {
  String id, username, email;

  Player({
    required this.id,
    required this.username,
    required this.email,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  @override
  String toString() => 'Player(ID: $id, username: $username, Email: $email)';

  String getId() => id;
  String getPlayername() => username;
  String getEmail() => email;

  setId(String id) => this.id = id;
  setPlayername(String username) => this.username = username;
  setEmail(String email) => this.email = email;
}