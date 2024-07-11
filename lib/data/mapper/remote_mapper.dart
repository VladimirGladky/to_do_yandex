import 'package:to_do/data/api/model/remote/api_remote_to_do_task.dart';
import 'package:to_do/domain/models/task.dart';

class RemoteTodoTaskMapper {
  static TodoTask fromApi(ApiRemoteTodoTask task) {
    return TodoTask(
      id: task.id,
      text: task.text,
      deadline: task.deadline == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(task.deadline!),
      importance: RemoteImportanceMapper.fromApi(task.importance),
      done: task.done,
      createdAt: DateTime.fromMillisecondsSinceEpoch(task.createdAt),
      changedAt: DateTime.fromMillisecondsSinceEpoch(task.changedAt),
      lastUpdatedBy: task.lastUpdatedBy,
      isSynchronized: true,
    );
  }

  static ApiRemoteTodoTask toApi(TodoTask task) {
    return ApiRemoteTodoTask.fromData(task);
  }
}

class RemoteImportanceMapper {
  static DegreeOfImportance fromApi(String importance) {
    return switch (importance) {
      'important' => DegreeOfImportance.high,
      'low' => DegreeOfImportance.low,
      _ => DegreeOfImportance.none,
    };
  }
}
