import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:to_do/app/firebase/firebase_config.dart';
import 'package:to_do/app/firebase/firebase_config_prod.dart';
import 'package:to_do/app/firebase/firebase_congig_mock.dart';
import 'package:to_do/app/navigation/route_parser.dart';
import 'package:to_do/app/navigation/router_delegate.dart';
import 'package:to_do/app/tests_widgets/local_service_mock.dart';
import 'package:to_do/app/tests_widgets/remote_service_mock.dart';
import 'package:to_do/app/tests_widgets/shared_pref_service_mock.dart';
import 'package:to_do/data/api/local_api_util.dart';
import 'package:to_do/data/api/service/local_service.dart';
import 'package:to_do/data/api/service/remote_service.dart';
import 'package:to_do/data/api/service/shared_pref_service.dart';
import 'package:to_do/data/api/shared_pref_api_util.dart';
import 'package:to_do/data/repository/data_local_repository.dart';
import 'package:to_do/data/repository/data_remote_repository.dart';
import 'package:to_do/data/repository/data_shared_pref_repo.dart';
import 'package:to_do/domain/repository/abstract_shared_pref_to_do_repo.dart';
import 'package:to_do/domain/repository/abstract_to_do_repo.dart';
import 'package:to_do/firebase_options.dart';
import '../../data/api/remote_api_util.dart';

Future<void> setUpDI(DIOptions options) async {
  await initFirebase();
  final getIt = GetIt.instance;
  GetIt.instance
      .registerLazySingleton<MyRouterDelegate>(() => MyRouterDelegate());
  getIt.registerLazySingleton<CustomRouteInformationParser>(
      () => CustomRouteInformationParser());

  switch (options) {
    ///DEV OPTIONS
    case DIOptions.dev:
      await _setUpDev(getIt);
      break;

    ///PROD OPTIONS
    case DIOptions.prod:
      await _setUpProd(getIt);
      break;

    ///TEST OPTIONS
    case DIOptions.test:
      await _setUpTest(getIt);
      break;
  }
}

enum DIOptions { test, prod, dev }

Future<void> initFirebase() async {
  var logger = Logger();
  logger.d('Firebase initialization started');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.d('Firebase initialized');
}

///SETUP DEV
Future<void> _setUpDev(GetIt getIt) async {
  getIt.registerLazySingleton<FAnalytic>(() => FAnalyticProd());
  getIt.registerLazySingleton<FRemoteConfigs>(() => FRemoteConfigsProd());
  getIt.registerLazySingleton<FirebaseAppConfig>(
    () => FirebaseAppConfigProd(
      GetIt.I<FAnalytic>(),
      GetIt.I<FRemoteConfigs>(),
    ),
  );
  await GetIt.I<FirebaseAppConfig>().initRemoteConfigDev();
  GetIt.I<FirebaseAppConfig>().initCrashlytics();
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
}

///SETUP PROD
Future<void> _setUpProd(GetIt getIt) async {
  getIt.registerLazySingleton<FAnalytic>(() => FAnalyticProd());
  getIt.registerLazySingleton<FRemoteConfigs>(() => FRemoteConfigsProd());
  getIt.registerLazySingleton<FirebaseAppConfig>(
    () => FirebaseAppConfigProd(
      GetIt.I<FAnalytic>(),
      GetIt.I<FRemoteConfigs>(),
    ),
  );
  await GetIt.I<FirebaseAppConfig>().initRemoteConfigProd();
  GetIt.I<FirebaseAppConfig>().initCrashlytics();
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
}

///SETUP TEST
Future<void> _setUpTest(GetIt getIt) async {
  getIt.registerLazySingleton<FAnalytic>(() => FAnalyticMock());
  getIt.registerLazySingleton<FRemoteConfigs>(() => FRemoteConfigsMock());
  getIt.registerLazySingleton<FirebaseAppConfig>(
    () => FirebaseAppConfigMock(
      GetIt.I<FAnalytic>(),
      GetIt.I<FRemoteConfigs>(),
    ),
  );
  getIt.registerSingleton<LocalTodoService>(MockLocalToDoService());
  getIt.registerSingleton<RemoteToDoService>(MockRemoteToDoService());
  getIt.registerSingleton<SharedPrefsService>(MockSharedPrefsService());
  getIt.registerLazySingleton<AbstractTodoTasksRepository>(
    () => TodoDataRemoteRepository(
      RemoteApiUtil(
        GetIt.I<RemoteToDoService>(),
      ),
    ),
    instanceName: "RemoteRepository",
  );
  getIt.registerLazySingleton<AbstractTodoTasksRepository>(
    () => TodoDataLocalRepository(
      LocalApiUtil(
        GetIt.I<LocalTodoService>(),
      ),
    ),
    instanceName: "LocalRepository",
  );

  getIt.registerLazySingleton<AbstractSharedPrefsRepository>(
    () => SharedPrefsDataRepository(
      SharedPrefsApiUtil(
        GetIt.I<SharedPrefsService>(),
      ),
    ),
    instanceName: "SharedPrefsRepository",
  );
}
