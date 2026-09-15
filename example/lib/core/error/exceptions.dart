/// Thrown by a data source when a call fails; the repository catches it and
/// maps it to a [Failure] for the rest of the app to handle.
class ServerException implements Exception {
  const ServerException([
    this.message = 'Something went wrong on the server',
  ]);

  final String message;
}

class CacheException implements Exception {
  const CacheException([
    this.message = 'Something went wrong reading local data',
  ]);

  final String message;
}
