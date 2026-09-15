import 'package:example/core/error/failures.dart';

/// One application action — implement `call` per use case, e.g.:
/// `class Get${Feature} extends UseCase<${Feature}Entity, NoParams> { ... }`
abstract class UseCase<ReturnType, Params> {
  Future<Result<ReturnType>> call(Params params);
}

/// Pass this to a [UseCase] that doesn't need parameters.
class NoParams {
  const NoParams();
}
