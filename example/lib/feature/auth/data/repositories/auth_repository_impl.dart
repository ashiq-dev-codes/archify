import 'package:example/core/network/network_info.dart';
import 'package:example/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:example/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl
    implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  // Implement the methods declared in AuthRepository
  // here — check networkInfo.isConnected before calling remoteDataSource,
  // and map a ServerException to a ServerFailure (see core/error)
}
