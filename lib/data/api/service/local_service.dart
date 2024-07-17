import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do/data/api/model/local/api_local_todo_task.dart';
import 'package:to_do/domain/exception/exceptions.dart';
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

  Future<List<ApiLocalTodoTask>> getList() async {
    try {
      final isar = await _isarGetter;
      final items = await isar.apiLocalTodoTasks.where().findAll();
      return items;
    } catch (e) {
      throw DatabaseErrorException();
    }
  }

  Future<ApiLocalTodoTask?> getTask(String id) async {
    try {
      final isar = await _isarGetter;
      final items = await isar.apiLocalTodoTasks
          .filter()
          .isarIdEqualTo(MyFunctions.fastHash(id))
          .findFirst();
      return items;
    } catch (e) {
      throw DatabaseErrorException();
    }
  }

  Future<bool> removeTask(String id) async {
    try {
      final isar = await _isarGetter;
      final result = await isar.writeTxn(() async {
        return await isar.apiLocalTodoTasks
            .filter()
            .isarIdEqualTo(MyFunctions.fastHash(id))
            .deleteFirst();
      });
      return result;
    } catch (e) {
      throw DatabaseErrorException();
    }
  }

  Future<bool> removeAll() async {
    try {
      final isar = await _isarGetter;
      final result = await isar.writeTxn(() async {
        return await isar.apiLocalTodoTasks.where().deleteAll();
      });
      return result > 0;
    } catch (e) {
      throw DatabaseErrorException();
    }
  }

  Future<bool> editOrAddTask(ApiLocalTodoTask task) async {
    try {
      final isar = await _isarGetter;
      final result = await isar.writeTxn(() async {
        return await isar.apiLocalTodoTasks.put(task) > 0;
      });
      return result;
    } catch (e) {
      throw DatabaseErrorException();
    }
  }

  Future<bool> addAll(List<ApiLocalTodoTask> todoTasks) async {
    try {
      int counter = 0;
      for (ApiLocalTodoTask task in todoTasks) {
        if (await editOrAddTask(task)) {
          counter++;
        }
      }
      return counter == todoTasks.length;
    } catch (e) {
      throw DatabaseErrorException();
    }
  }
}
