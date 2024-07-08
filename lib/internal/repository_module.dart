import 'package:to_do/data/repository/local/data_local_repository.dart';
import 'package:to_do/data/repository/remote/data_remote_repository.dart';
import 'package:to_do/internal/local/api_local_module.dart';
import 'package:to_do/internal/remote/api_remote_module.dart';

class RepositoryModule {
  static TodoDataRemoteRepository? _remoteRepository;
  static TodoDataLocalRepository? _localRepository;
  static TodoDataRemoteRepository remoteRepository() {
    _remoteRepository ??= TodoDataRemoteRepository(ApiRemoteModule.apiUtil());
    return _remoteRepository!;
  }

  static TodoDataLocalRepository localRepository() {
    _localRepository ??= TodoDataLocalRepository(ApiLocalModule.apiUtil());
    return _localRepository!;
  }
}
