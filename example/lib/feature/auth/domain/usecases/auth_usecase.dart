import 'package:example/feature/auth/domain/repositories/auth_repository.dart';

class AuthUseCase {
  const AuthUseCase(this.repository);

  final AuthRepository repository;

  // Add your use case call(s) here — one per action this feature exposes
  // to the presentation layer, e.g. call() or get/update/delete methods
}
