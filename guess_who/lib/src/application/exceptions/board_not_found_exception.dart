class BoardNotFoundException implements Exception {
  final String message;

  BoardNotFoundException(this.message);
}