import 'package:to_do/data/api/model/local/api_local_todo_task.dart';
import 'package:to_do/domain/models/task.dart';

class LocalTodoTaskMapper {
  static TodoTask fromApi(ApiLocalTodoTask task) {
    return TodoTask(
      id: task.id ?? "",
      text: task.text ?? "",
      deadline: task.deadline,
      importance: LocalImportanceMapper.fromApi(task.importance),
      done: task.done ?? false,
      createdAt: task.createdAt ?? DateTime.now(),
      changedAt: task.changedAt ?? DateTime.now(),
      lastUpdatedBy: task.lastUpdatedBy ?? "",
    );
  }

  static ApiLocalTodoTask toApi(TodoTask task) {
    return ApiLocalTodoTask()
      ..id = task.id
      ..text = task.text
      ..importance = LocalImportanceMapper.toApi(task.importance)
      ..deadline = task.deadline
      ..color = task.color.toString()
      ..createdAt = task.createdAt
      ..changedAt = task.changedAt
      ..done = task.done
      ..lastUpdatedBy = task.lastUpdatedBy;
  }
}

class LocalImportanceMapper {
  static DegreeOfImportance fromApi(ApiLocalTaskPriority importance) {
    return switch (importance) {
      ApiLocalTaskPriority.important => DegreeOfImportance.high,
      ApiLocalTaskPriority.low => DegreeOfImportance.low,
      _ => DegreeOfImportance.none,
    };
  }

  static ApiLocalTaskPriority toApi(DegreeOfImportance importance) {
    return switch (importance) {
      DegreeOfImportance.high => ApiLocalTaskPriority.important,
      DegreeOfImportance.low => ApiLocalTaskPriority.low,
      _ => ApiLocalTaskPriority.basic,
    };
  }
}
