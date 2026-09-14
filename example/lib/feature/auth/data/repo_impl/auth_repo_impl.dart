import 'package:example/feature/auth/domain/data_source/auth_data_source.dart';
import 'package:example/feature/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({required this.remote});
  final AuthDataSource remote;

  // Add your repo implementation here
}
