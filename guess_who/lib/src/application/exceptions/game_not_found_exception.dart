class GameNotFoundException implements Exception {
  final String message;

  GameNotFoundException(this.message);
}