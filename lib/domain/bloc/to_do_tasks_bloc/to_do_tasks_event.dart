part of 'to_do_tasks_bloc.dart';

@immutable
sealed class ToDoTasksEvent {}

class TodoTasksLoadEvent extends ToDoTasksEvent {}

class TodoTasksChangeDoneEvent extends ToDoTasksEvent {
  final String id;
  TodoTasksChangeDoneEvent({required this.id});
}

class TodoTasksChangeDoneVisibilityEvent extends ToDoTasksEvent {}

class TodoTasksAddEvent extends ToDoTasksEvent {
  final TodoTask task;
  TodoTasksAddEvent({required this.task});
}

class TodoTasksRemoveEvent extends ToDoTasksEvent {
  final String id;
  TodoTasksRemoveEvent({required this.id});
}

class TodoTasksChangeTaskEvent extends ToDoTasksEvent {
  final String id;
  final TodoTask task;
  TodoTasksChangeTaskEvent({required this.id, required this.task});
}
