import 'package:to_do/data/api/local_api_util.dart';
import 'package:to_do/data/api/service/local_service.dart';

class ApiLocalModule {
  static LocalApiUtil? _apiUtil;

  static LocalApiUtil apiUtil() {
    _apiUtil ??= LocalApiUtil(LocalTodoService());
    return _apiUtil!;
  }
}
