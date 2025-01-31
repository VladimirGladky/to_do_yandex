part of 'to_do_tasks_bloc.dart';

@immutable
sealed class ToDoTasksState {}

final class ToDoTasksInitial extends ToDoTasksState {}

class TodoTaskLoadedState extends ToDoTasksState {
  final List<TodoTask> tasks;
  final int doneCounter;
  TodoTaskLoadedState({required this.tasks, required this.doneCounter});
}

class TodoTaskLoadingState extends ToDoTasksState {}

class TodoTaskNoInternetState extends ToDoTasksState {}

class TodoTaskErrorState extends ToDoTasksState {
  final String errorMessage;
  TodoTaskErrorState({required this.errorMessage});
}
