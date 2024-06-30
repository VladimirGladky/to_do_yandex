import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do/data/api/model/local/api_local_todo_task.dart';
import 'package:to_do/utils/constutils.dart';

class LocalTodoService {
  Isar? _isar;

  Future<Isar> get _isarGetter async {
    final appDir = await getApplicationDocumentsDirectory();
    _isar ??= await Isar.open(
      [ApiLocalTodoTaskSchema],
      directory: appDir.path,
    );
    return _isar!;
  }

  Future<List<ApiLocalTodoTask>> getAll() async {
    final isar = await _isarGetter;
    final items = await isar.apiLocalTodoTasks.where().findAll();
    return items;
  }

  Future<ApiLocalTodoTask?> getById(String id) async {
    final isar = await _isarGetter;
    final items = await isar.apiLocalTodoTasks
        .filter()
        .isarIdEqualTo(MyFunctions.fastHash(id))
        .findFirst();
    return items;
  }

  Future<bool> deleteById(String id) async {
    final isar = await _isarGetter;
    final result = await isar.writeTxn(() async {
      return await isar.apiLocalTodoTasks
          .filter()
          .isarIdEqualTo(MyFunctions.fastHash(id))
          .deleteFirst();
    });
    return result;
  }

  Future<bool> deleteAll() async {
    final isar = await _isarGetter;
    final result = await isar.writeTxn(() async {
      return await isar.apiLocalTodoTasks.where().deleteAll();
    });
    return result > 0;
  }

  Future<bool> updateOrAdd(ApiLocalTodoTask task) async {
    final isar = await _isarGetter;
    final result = await isar.writeTxn(() async {
      return await isar.apiLocalTodoTasks.put(task) > 0;
    });
    return result;
  }

  Future<bool> addAll(List<ApiLocalTodoTask> todoTasks) async {
    int counter = 0;
    for (ApiLocalTodoTask task in todoTasks) {
      if (await updateOrAdd(task)) {
        counter++;
      }
    }
    return counter == todoTasks.length;
  }
}
