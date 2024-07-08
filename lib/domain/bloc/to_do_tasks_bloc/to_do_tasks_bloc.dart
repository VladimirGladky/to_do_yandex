import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:logger/logger.dart';
import 'package:to_do/domain/repository/to_do_repository.dart';

part 'to_do_tasks_event.dart';
part 'to_do_tasks_state.dart';

class ToDoTasksBloc extends Bloc<ToDoTasksEvent, ToDoTasksState> {
  late final TodoRepository repository;

  List<TodoTask> resultList = [];
  List<TodoTask> tasks = [];
  int doneCounter = 0;
  var logger = Logger();
  bool isComplitedHide = false;

  ToDoTasksBloc() : super(ToDoTasksInitial()) {
    repository = TodoRepository();
    on<TodoTasksLoadEvent>(_onTasksLoadEvent);
    on<TodoTasksChangeDoneEvent>(_onTasksChangeDoneEvent);
    on<TodoTasksRemoveEvent>(_onTasksRemoveEvent);
    on<TodoTasksAddEvent>(_onTodoTasksAddEvent);
    on<TodoTasksChangeDoneVisibilityEvent>(
        _onTodoTasksChangeDoneVisibilityEvent);
    on<TodoTasksChangeTaskEvent>(_onTodoTasksChangeTaskEvent);
  }

  FutureOr<void> _onTasksLoadEvent(
      TodoTasksLoadEvent event, Emitter<ToDoTasksState> emit) async {
    emit(TodoTaskLoadingState());
    int statusCode;
    List<TodoTask> tmpList;
    (statusCode, tmpList) = await repository.getAndMergeTasks();
    tasks = tmpList;
    _filterFunction();
    logger.log(Level.trace,
        "End load task event with $statusCode code\nResultative list: $resultList");
    logger.log(Level.trace, jsonEncode("tasks: $tasks"));
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  FutureOr<void> _onTasksChangeDoneEvent(
      TodoTasksChangeDoneEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(
        Level.trace, "Start Change Done event for task with ${event.id} id");

    TodoTask changedTask =
        tasks.firstWhere((element) => element.id == event.id);
    changedTask.done = !changedTask.done;

    emit(TodoTaskLoadedState(
        tasks: resultList,
        doneCounter: changedTask.done ? doneCounter + 1 : doneCounter));

    await Future<void>.delayed(const Duration(milliseconds: 850));
    emit(TodoTaskLoadingState());
    _filterFunction();
    logger.log(
        Level.trace, "End Change Done event for task with ${event.id} id");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));

    List<TodoTask>? tmpList;
    (_, tmpList) = await repository.changeTask(changedTask);
    if (tmpList != null) {
      tasks = tmpList;
      _filterFunction();
      emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
    }
  }

  FutureOr<void> _onTasksRemoveEvent(
      TodoTasksRemoveEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(Level.trace, "Start Remove event for task with ${event.id} id");
    emit(TodoTaskLoadingState());
    tasks.removeWhere((element) => element.id == event.id);
    _filterFunction();
    logger.log(Level.trace, "End Remove event for task with ${event.id} id");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));

    List<TodoTask>? tmpList;
    (_, tmpList) = await repository.taskRemove(event.id);
    if (tmpList != null) {
      tasks = tmpList;
      _filterFunction();
      emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
    }
  }

  FutureOr<void> _onTodoTasksAddEvent(
      TodoTasksAddEvent event, Emitter<ToDoTasksState> emit) {
    logger.log(Level.trace, "Start Add task event with task  ${event.task}");
    emit(TodoTaskLoadingState());
    tasks.add(event.task);
    _filterFunction();
    logger.log(Level.trace, "End Add task event with task  ${event.task}");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  FutureOr<void> _onTodoTasksChangeDoneVisibilityEvent(
      TodoTasksChangeDoneVisibilityEvent event, Emitter<ToDoTasksState> emit) {
    logger.log(Level.trace, "Start Change visibility event");
    emit(TodoTaskLoadingState());
    isComplitedHide = !isComplitedHide;
    _filterFunction();
    logger.log(Level.trace, "End Change visibility event");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  FutureOr<void> _onTodoTasksChangeTaskEvent(
      TodoTasksChangeTaskEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(Level.trace, "Start Change event with task  ${event.task}");
    emit(TodoTaskLoadingState());
    int i = tasks.indexWhere((element) => element.id == event.id);

    tasks[i] = event.task;
    _filterFunction();
    logger.log(Level.trace, "End Change event with task  ${event.task}");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));

    List<TodoTask>? tmpList;
    (_, tmpList) = await repository.changeTask(event.task);
    if (tmpList != null) {
      tasks = tmpList;
      _filterFunction();
      emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
    }
  }

  void _filterFunction() {
    logger.log(Level.trace, "Start filter");
    final List<TodoTask> doneTasks =
        tasks.where((element) => element.done).toList();
    doneCounter = doneTasks.length;
    tasks.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
    resultList = tasks.where((element) => !element.done).toList() +
        (isComplitedHide ? [] : doneTasks);
    logger.log(Level.trace, "Filter done");
  }
}
