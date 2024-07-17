import 'package:get_it/get_it.dart';
import 'package:to_do/app/navigation/route_parser.dart';
import 'package:to_do/data/api/local_api_util.dart';
import 'package:to_do/data/api/remote_api_util.dart';
import 'package:to_do/data/api/service/local_service.dart';
import 'package:to_do/data/api/service/remote_service.dart';
import 'package:to_do/data/api/service/shared_pref_service.dart';
import 'package:to_do/data/api/shared_pref_api_util.dart';
import 'package:to_do/data/repository/data_local_repository.dart';
import 'package:to_do/data/repository/data_remote_repository.dart';
import 'package:to_do/data/repository/data_shared_pref_repo.dart';
import 'package:to_do/domain/repository/abstract_shared_pref_to_do_repo.dart';
import 'package:to_do/domain/repository/abstract_to_do_repo.dart';

import '../navigation/router_delegate.dart';

void setUpDI(DIOptions options) {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<MyRouterDelegate>(() => MyRouterDelegate());
  getIt.registerLazySingleton<CustomRouteInformationParser>(
      () => CustomRouteInformationParser());
  switch (options) {
    ///DEV OPTIONS
    case DIOptions.dev:
      getIt.registerLazySingleton<AbstractTodoTasksRepository>(
        () => TodoDataRemoteRepository(
          RemoteApiUtil(
            RemoteToDoService(),
          ),
        ),
        instanceName: "RemoteRepository",
      );
      getIt.registerLazySingleton<AbstractTodoTasksRepository>(
        () => TodoDataLocalRepository(
          LocalApiUtil(
            LocalTodoService(),
          ),
        ),
        instanceName: "LocalRepository",
      );

      getIt.registerLazySingleton<AbstractSharedPrefsRepository>(
        () => SharedPrefsDataRepository(
          SharedPrefsApiUtil(
            SharedPrefsService(),
          ),
        ),
        instanceName: "SharedPrefsRepository",
      );
      break;

    ///PROD OPTIONS
    case DIOptions.prod:
      getIt.registerLazySingleton<AbstractTodoTasksRepository>(
        () => TodoDataRemoteRepository(
          RemoteApiUtil(
            RemoteToDoService(),
          ),
        ),
        instanceName: "RemoteRepository",
      );
      getIt.registerLazySingleton<AbstractTodoTasksRepository>(
        () => TodoDataLocalRepository(
          LocalApiUtil(
            LocalTodoService(),
          ),
        ),
        instanceName: "LocalRepository",
      );

      getIt.registerLazySingleton<AbstractSharedPrefsRepository>(
        () => SharedPrefsDataRepository(
          SharedPrefsApiUtil(
            SharedPrefsService(),
          ),
        ),
        instanceName: "SharedPrefsRepository",
      );
      break;
    case DIOptions.test:
    // TODO: Handle this case.
  }
}

enum DIOptions { test, prod, dev }
