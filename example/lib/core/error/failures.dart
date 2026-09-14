/// A recoverable, expected failure your UI can show a message for — as
/// opposed to an uncaught exception. Extend this for feature-specific
/// failures; the built-in ones cover the common cases.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on the server']);
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Something went wrong reading local data',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Either the [value] an operation produced, or the [Failure] it hit —
/// pattern-match with a switch, no third-party package required:
/// '''dart
/// switch (result) {
///   case Success(:final value): ...
///   case Failed(:final failure): ...
/// }
/// '''
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;
}
